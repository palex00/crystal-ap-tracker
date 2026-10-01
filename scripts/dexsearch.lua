DEXSEARCH_ID = nil
DEXSEARCH_POKEDEX = false

local NO_POKEDEX_ICON = "images/settings/pokedex.png"
local DIGIT_CODES = {"dexsearch_digit1", "dexsearch_digit2", "dexsearch_digit3"}
local SEARCH_VISIBILITY = {
    visibility_items = 1,
    visibility_mons = 0,
    visibility_events = 1,
    visibility_signs = 1,
    visibility_grass = 1,
    visibility_entrances = 1,
}
local saved_visibility = nil

local function seen(id)
    return has("all_pokemon_seen_true") or table_contains(SEEN, id) or table_contains(CAUGHT, id)
end

local function restoreEncounterCounts()
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        if REGION_ENCOUNTERS[region_key] ~= nil then
            Tracker:FindObjectForCode(location).AvailableChestCount = #REGION_ENCOUNTERS[region_key]
        end
    end
end

function applyDexSearch()
    local found = {}
    for _, region_key in ipairs(POKEMON_TO_LOCATIONS[DEXSEARCH_ID] or {}) do
        local location = ENCOUNTER_MAPPING[region_key]
        if location then
            found[location] = true
        end
    end
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        if REGION_ENCOUNTERS[region_key] ~= nil then
            Tracker:FindObjectForCode(location).AvailableChestCount = found[location] and 1 or 0
        end
    end
    return next(found) ~= nil
end

local function endDexSearch()
    if DEXSEARCH_ID == nil then
        return
    end
    DEXSEARCH_ID = nil
    for code, stage in pairs(saved_visibility) do
        Tracker:FindObjectForCode(code).CurrentStage = stage
    end
    saved_visibility = nil
    restoreEncounterCounts()
    updatePokemon()
end

DexSearchResultItem = CustomItem:extend()

function DexSearchResultItem:init()
    self:createItem("DexSearch", {"dexsearch_result"})
    self:show(0, "")
end

function DexSearchResultItem:canProvideCode(code)
    return code == "dexsearch_result"
end

function DexSearchResultItem:show(id, status, disabled)
    local inst = self.ItemInstance
    if not DEXSEARCH_POKEDEX then
        inst.Icon = ImageReference:FromPackRelativePath(NO_POKEDEX_ICON)
        inst.IconMods = "@disabled"
        inst.Name = "DexSearch requires the Pokédex"
        return
    end
    inst.Icon = ImageReference:FromPackRelativePath("images/pokemon/" .. id .. ".png")
    inst.IconMods = disabled and "@disabled" or ""
    if id == 0 then
        inst.Name = "DexSearch"
    else
        inst.Name = "#" .. id .. " " .. EVO_LOC_MAPPING[id] .. " - " .. status
    end
end

DexSearchActionItem = CustomItem:extend()

function DexSearchActionItem:init(name, code, icon, action)
    self.code = code
    self.action = action
    self:createItem(name, {code})
    self.ItemInstance.Icon = ImageReference:FromPackRelativePath(icon)
end

function DexSearchActionItem:canProvideCode(code)
    return code == self.code
end

function DexSearchActionItem:onLeftClick()
    self.action()
end

DexSearchButtonItem = CustomItem:extend()

function DexSearchButtonItem:init(code, label, target)
    self.code = code
    self.label = label
    self.target = target
    self:createItem(label, {code})
    self:refresh()
end

function DexSearchButtonItem:canProvideCode(code)
    return code == self.code
end

function DexSearchButtonItem:refresh()
    local id = self.target()
    local inst = self.ItemInstance
    inst.Icon = ImageReference:FromPackRelativePath("images/pokemon/" .. id .. ".png")
    inst.IconMods = "overlay|/images/tools/dexsearch/search_overlay.png"
    if id == 0 then
        inst.Name = self.label .. ": not revealed yet"
    else
        inst.Name = self.label .. ": search for " .. EVO_LOC_MAPPING[id]
    end
end

function DexSearchButtonItem:onLeftClick()
    local id = self.target()
    if id ~= 0 then
        makeDigits(id, DIGIT_CODES[1], DIGIT_CODES[2], DIGIT_CODES[3])
        dexSearch(id)
    end
end

function dexSearch(id)
    if not DEXSEARCH_POKEDEX then
        return
    end
    if id < 1 or id > 251 then
        dexSearchReset()
        return
    end
    if not seen(id) then
        endDexSearch()
        DEXSEARCH_RESULT:show(id, "not seen yet", true)
        return
    end
    if DEXSEARCH_ID == nil then
        saved_visibility = {}
        for code, stage in pairs(SEARCH_VISIBILITY) do
            local obj = Tracker:FindObjectForCode(code)
            saved_visibility[code] = obj.CurrentStage
            obj.CurrentStage = stage
        end
    end
    DEXSEARCH_ID = id
    if applyDexSearch() then
        DEXSEARCH_RESULT:show(id, "showing encounter locations", false)
    else
        DEXSEARCH_RESULT:show(id, "no known encounter locations", true)
    end
end

function dexSearchDigits()
    dexSearch(getDigits(DIGIT_CODES[1], DIGIT_CODES[2], DIGIT_CODES[3]))
end

function dexSearchReset()
    endDexSearch()
    makeDigits(0, DIGIT_CODES[1], DIGIT_CODES[2], DIGIT_CODES[3])
    DEXSEARCH_RESULT:show(0, "")
end

local function requestTarget(code)
    return function()
        return Tracker:FindObjectForCode(code).CurrentStage
    end
end

local function fixedTarget(id)
    return function()
        return id
    end
end

DEXSEARCH_RESULT = DexSearchResultItem()
DexSearchActionItem("Search", "dexsearch_go", "images/tools/dexsearch/go.png", dexSearchDigits)
DexSearchActionItem("Reset Search", "dexsearch_reset", "images/tools/dexsearch/reset.png", dexSearchReset)

for _, entry in ipairs({
    {"request_trade_kyle",   "Trade: Kyle"},
    {"request_trade_mike",   "Trade: Mike"},
    {"request_trade_tim",    "Trade: Tim"},
    {"request_trade_emy",    "Trade: Emy"},
    {"request_trade_chris",  "Trade: Chris"},
    {"request_trade_forest", "Trade: Forest"},
    {"request_trade_kim",    "Trade: Kim"},
    {"request_grandpa_1",    "Bill's Grandpa Request 1"},
    {"request_grandpa_2",    "Bill's Grandpa Request 2"},
    {"request_grandpa_3",    "Bill's Grandpa Request 3"},
    {"request_grandpa_4",    "Bill's Grandpa Request 4"},
    {"request_grandpa_5",    "Bill's Grandpa Request 5"},
    {"request_beverly",      "Beverly's Request"},
    {"request_derek",        "Derek's Request"},
    {"request_tiffany",      "Tiffany's Request"},
}) do
    local source = entry[1]
    local button = DexSearchButtonItem("dexsearch_" .. source, entry[2], requestTarget(source))
    ScriptHost:AddWatchForCode("dexsearch_" .. source, source, function() button:refresh() end)
end
DexSearchButtonItem("dexsearch_ditto", "Ditto", fixedTarget(132))
DexSearchButtonItem("dexsearch_magikarp", "Magikarp", fixedTarget(129))

function setDexSearchPokedex(value)
    if DEXSEARCH_POKEDEX == value then
        return
    end
    DEXSEARCH_POKEDEX = value
    dexSearchReset()
end
