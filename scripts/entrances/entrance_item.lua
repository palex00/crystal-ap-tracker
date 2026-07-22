-- EntranceItem: one custom Lua item per randomizable entrance.
-- Extends the pack's CustomItem base (scripts/custom_items/custom_item.lua).
--
-- Each item is keyed by its region-string token, which it provides as its item CODE (used
-- for hosted_item placement in the location JSON); the LuaItem Name is the pretty name, so
-- the UI/tooltip/feed shows that instead. Its connection state is revealed by the
-- autotracker (archipelago.lua's updateEntrances) from the DataStorage "entered" list:
--   forwardTarget = token of where entering THIS entrance emerges (left-click destination)
--   reverseSource = token of the entrance that emerges HERE          (right-click source)
-- Both are independent and may be nil (decoupled seeds / one-way holes only fill one).
--
-- Clicks are pure navigation (no manual connecting):
--   left   -> tab to where this entrance leads          (no-op if unrevealed)
--   right  -> tab to what leads to this entrance         (no-op if unrevealed)
--   middle -> route mode (pick two entrances -> GetRoute)

ENTRANCE_CLOSED_ICON = "images/entrances/entrance_unexplored.png" -- unrevealed marker
ENTRANCE_OPEN_ICON = "images/entrances/entrance_explored.png"     -- revealed marker

-- Temp-highlight state (feature: briefly highlight the destination after navigating).
local HIGHLIGHT_TARGET = nil
local HIGHLIGHT_TIME = 0
local HIGHLIGHT_SECONDS = 5

function RemoveEntranceHighlight()
    if os.clock() - HIGHLIGHT_TIME > HIGHLIGHT_SECONDS then
        ScriptHost:RemoveOnFrameHandler("entrance highlight handler")
        if HIGHLIGHT_TARGET then
            HIGHLIGHT_TARGET.Highlight = Highlight.None
        end
        HIGHLIGHT_TARGET = nil
        HIGHLIGHT_TIME = 0
    end
end

EntranceItem = CustomItem:extend()

function EntranceItem:init(token, row)
    self:createItem(row.pretty, {token}) -- display name; the token is provided as the item CODE
    self.token = token
    self.ids = row.ids
    self.pretty = row.pretty
    self.tab = row.tab
    self.node = EntranceSourceRegion(token) -- region this entrance sits in (route mode start/finish)
    self.forwardTarget = nil
    self.reverseSource = nil
    self:updateBadge()
end

--- Set/clear the revealed connection directions, then refresh the display.
function EntranceItem:setForward(token)
    self.forwardTarget = token
    self:updateBadge()
end

function EntranceItem:setReverse(token)
    self.reverseSource = token
    self:updateBadge()
end

function EntranceItem:reset()
    self.forwardTarget = nil
    self.reverseSource = nil
    self:updateBadge()
end

--- Whether either direction has been revealed.
function EntranceItem:isRevealed()
    return self.forwardTarget ~= nil or self.reverseSource ~= nil
end

--- Badge + icon. Badge rule:
---   one direction known -> "->dest" or "<-src"
---   both known & equal  -> "<->name"   (coupled/symmetric)
---   both known & differ -> two lines "->dest" / "<-src"  (decoupled)
function EntranceItem:updateBadge()
    local inst = self.ItemInstance
    local fwd = self.forwardTarget and ENTRANCE_REGISTRY[self.forwardTarget]
    local rev = self.reverseSource and ENTRANCE_REGISTRY[self.reverseSource]
    -- UTF-8 arrow glyphs as byte escapes (version-agnostic): -> = \226\134\146,
    -- <- = \226\134\144, <-> = \226\134\148
    local ARROW_FWD = "\226\134\146"
    local ARROW_REV = "\226\134\144"
    local ARROW_BOTH = "\226\134\148"
    local text = ""
    if fwd and rev then
        if self.forwardTarget == self.reverseSource then
            text = ARROW_BOTH .. fwd.pretty
        else
            text = ARROW_FWD .. fwd.pretty .. "\n" .. ARROW_REV .. rev.pretty
        end
    elseif fwd then
        text = ARROW_FWD .. fwd.pretty
    elseif rev then
        text = ARROW_REV .. rev.pretty
    end
    if text ~= "" then
        text = text .. "\n"
    end
    inst.BadgeText = text
    inst.BadgeTextColor = "#abcdef"
    inst:SetOverlayBackground("#c0000000")
    inst:SetOverlayFontSize(10)
    inst:SetOverlayAlign("left")
    if self:isRevealed() then
        inst.Icon = ImageReference:FromPackRelativePath(ENTRANCE_OPEN_ICON)
    else
        inst.Icon = ImageReference:FromPackRelativePath(ENTRANCE_CLOSED_ICON)
    end
end

--- Walk a tab-title chain to bring the destination marker into view.
local function activateTabChain(chain)
    if chain then
        for _, t in ipairs(chain) do
            Tracker:UiHint("ActivateTab", t)
        end
    end
end

--- Briefly highlight the destination marker (if its section is registered).
local function highlightTarget(token)
    local row = ENTRANCE_REGISTRY[token]
    if not row or not row.section then
        return
    end
    if HIGHLIGHT_TARGET then
        HIGHLIGHT_TARGET.Highlight = Highlight.None
    end
    HIGHLIGHT_TARGET = Tracker:FindObjectForCode(row.section)
    if HIGHLIGHT_TARGET then
        HIGHLIGHT_TARGET.Highlight = Highlight.Avoid
        HIGHLIGHT_TIME = os.clock()
        ScriptHost:AddOnFrameHandler("entrance highlight handler", RemoveEntranceHighlight)
    end
end

--- Navigate to a target entrance token (tab there + highlight it).
local function navigateTo(token)
    local row = ENTRANCE_REGISTRY[token]
    if row then
        activateTabChain(row.tab)
    end
    highlightTarget(token)
end

function EntranceItem:onLeftClick()
    if self.forwardTarget then
        navigateTo(self.forwardTarget)
    end
end

function EntranceItem:onRightClick()
    if self.reverseSource then
        navigateTo(self.reverseSource)
    end
end

-- Route mode: first middle-click picks the start, second computes the route between them.
ROUTE_START = nil

function EntranceItem:onMiddleClick()
    if ROUTE_START == nil then
        ROUTE_START = self.node
    else
        GetRoute(NAMED_NODES[ROUTE_START], NAMED_NODES[self.node])
        ROUTE_START = nil
    end
end

-- TEMPORARY DIAGNOSTIC (set ENTRANCE_PROBE = false to disable).
-- Pre-0.35.4, every PopTracker scan over _luaItems called canProvideCode on EVERY entrance item
-- as a separate uncached lua_pcall, so calls = #codes-scanned x #items. With PotentialCodes set
-- (0.35.4+) the core matches codes itself and never enters Lua, so a report of 0 calls means the
-- fast path is live; any nonzero count means we fell back to CanProvideCodeFunc.
ENTRANCE_PROBE = true
local probe_calls = 0
local probe_codes = {}
local probe_distinct = 0

function EntranceItem:canProvideCode(code)
    if ENTRANCE_PROBE then
        probe_calls = probe_calls + 1
        if not probe_codes[code] then
            probe_codes[code] = true
            probe_distinct = probe_distinct + 1
        end
    end
    return code == self.token
end

function EntranceProbeReport()
    if probe_calls == 0 then
        return
    end
    local sample, n = {}, 0
    for c in pairs(probe_codes) do
        n = n + 1
        if n <= 8 then
            sample[#sample + 1] = c
        end
    end
    print(string.format("ENTRANCE PROBE: %d canProvideCode calls / %d distinct codes / %d items",
        probe_calls, probe_distinct, ENTRANCE_ITEM_COUNT or 0))
    print("  sample codes: " .. table.concat(sample, ", "))
    probe_calls = 0
    probe_codes = {}
    probe_distinct = 0
end

--- Collected state for the section hosting this entrance (hosted_item = the token).
function EntranceItem:providesCode(code)
    if code == self.token and self:isRevealed() then
        return 1
    end
    return 0
end

--- token -> ER category, harvested from the graph's entrance edges (the category lives on the
--- connect_*_entrance edge as exit[4], with the token as exit[5]). Built once after the graph
--- is loaded, so we can tell which registry rows belong to a shuffled category.
ENTRANCE_CATEGORY = {}
function buildEntranceCategoryMap()
    if not NAMED_NODES_KEYS then
        return
    end
    for _, name in ipairs(NAMED_NODES_KEYS) do
        local node = NAMED_NODES[name]
        if node then
            for _, exit in ipairs(node.exits) do
                if exit[3] then -- is_entrance edge
                    ENTRANCE_CATEGORY[exit[5]] = exit[4]
                end
            end
        end
    end
end

--- Instantiate EntranceItems ONLY for entrances whose ER category is currently enabled.
--- A vanilla (non-shuffled) entrance has a fixed connection and needs no tracker item, so the
--- LuaItem count tracks what's actually shuffled (0 on a non-ER seed). This is what keeps
--- PopTracker's per-update cost down -- a large _luaItems set makes every item toggle laggy
--- regardless of the logic path. Idempotent and additive: safe to call repeatedly (e.g. from
--- refreshERCategories on connect / manual toggle). Items are never removed once created
--- (PopTracker has no RemoveItems), which is fine because categories are fixed per seed.
--- Call after ENTRANCE_REGISTRY, the graph, and buildEntranceCategoryMap() are ready.
ENTRANCE_ITEMS = {}
ENTRANCE_ITEM_COUNT = 0
function createEntrancesForEnabled()
    if not ENTRANCE_REGISTRY or not ER_CATEGORY_ENABLED then
        return
    end
    for token, row in pairs(ENTRANCE_REGISTRY) do
        if not ENTRANCE_ITEMS[token] then
            local cat = ENTRANCE_CATEGORY[token]
            if cat and ER_CATEGORY_ENABLED[cat] then
                ENTRANCE_ITEMS[token] = EntranceItem(token, row)
                ENTRANCE_ITEM_COUNT = ENTRANCE_ITEM_COUNT + 1
            end
        end
    end
end
