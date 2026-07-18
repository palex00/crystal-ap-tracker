-- EntranceItem: one custom Lua item per randomizable entrance.
-- Extends the pack's CustomItem base (scripts/custom_items/custom_item.lua).
--
-- Each item is keyed by its region-string token (also its LuaItem Name, used for
-- hosted_item placement in the location JSON). Its connection state is revealed by the
-- autotracker (archipelago.lua's updateEntrances) from the DataStorage "entered" list:
--   forwardTarget = token of where entering THIS entrance emerges (left-click destination)
--   reverseSource = token of the entrance that emerges HERE          (right-click source)
-- Both are independent and may be nil (decoupled seeds / one-way holes only fill one).
--
-- Clicks are pure navigation (no manual connecting):
--   left   -> tab to where this entrance leads          (no-op if unrevealed)
--   right  -> tab to what leads to this entrance         (no-op if unrevealed)
--   middle -> route mode (pick two entrances -> GetRoute)

ENTRANCE_CLOSED_ICON = "images/items/pokeball_bw.png" -- unrevealed marker
ENTRANCE_OPEN_ICON = "images/items/pokeball.png"      -- revealed marker

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
    self:createItem(token) -- LuaItem.Name = token
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
    inst.BadgeText = text
    inst.BadgeTextColor = "#abcdef"
    inst:SetOverlayFontSize(10)
    inst:SetOverlayAlign("left")
    if fwd or rev then
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

function EntranceItem:canProvideCode(code)
    return code == self.token
end

function EntranceItem:providesCode(code)
    return 0
end

--- Instantiate one EntranceItem per registry row. Call after ENTRANCE_REGISTRY is loaded.
ENTRANCE_ITEMS = {}
function createEntrances()
    for token, row in pairs(ENTRANCE_REGISTRY) do
        ENTRANCE_ITEMS[token] = EntranceItem(token, row)
    end
end

--- Map-marker color for an entrance (referenced from location JSON as "$ChangeEntranceColor|<token>").
--- Revealed entrances read as cleared; otherwise fall back to whether the region is reachable.
---@param token string
---@return integer
function ChangeEntranceColor(token)
    if Tracker.BulkUpdate then
        return ACCESS_NONE
    end
    local item = ENTRANCE_ITEMS[token]
    if item and (item.forwardTarget or item.reverseSource) then
        return ACCESS_CLEARED
    end
    return CanReach(EntranceSourceRegion(token))
end
