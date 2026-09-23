INLOGIC_SLOT_COUNT = 30
INLOGIC_COLUMN_SIZE = 15
INLOGIC_ITEMS = {}

local BLANK_ICON = "images/other/blank.png"
local SYNC_ICON = "images/placeholder.png"
local BADGE_INDENT = string.rep(" ", 12)

local SPRITE_OVERRIDES = {
    nidoranf = "nidoran_f",
    nidoranm = "nidoran_m",
    farfetchd = "farfetch'd",
}

local EMPTY_MESSAGES = {
    {"palex00 is proud of you!"},
    {"You truly are a MASTER BREEDER!"},
    {"You proved Darwin right!"},
    {"I've come to evolve and chew gum.", "And I'm all out of evolve."},
    {"Your ad here"},
}

InLogicItem = CustomItem:extend()

function InLogicItem:init(index)
    self.code = "inlogic_" .. index
    self:createItem("In Logic " .. index, {self.code})
    self:show(nil)
end

function InLogicItem:canProvideCode(code)
    return code == self.code
end

function InLogicItem:providesCode(code)
    return 0
end

function InLogicItem:show(entry)
    local inst = self.ItemInstance
    local icon = BLANK_ICON
    local name = ""
    local badge = ""
    if entry and entry.id then
        local code = POKEMON_MAPPING[entry.id]
        icon = "images/pokemon/" .. (SPRITE_OVERRIDES[code] or code) .. ".png"
        name = entry.action .. " " .. EVO_LOC_MAPPING[entry.id]
        badge = BADGE_INDENT .. name
    elseif entry and entry.text then
        badge = entry.text
    end
    inst.Icon = ImageReference:FromPackRelativePath(icon)
    inst.Name = name
    inst.BadgeText = badge
    inst.BadgeTextColor = "#abcdef"
    inst:SetOverlayBackground("")
    inst:SetOverlayFontSize(11)
    inst:SetOverlayAlign("left")
end

InLogicSyncItem = CustomItem:extend()

function InLogicSyncItem:init()
    self:createItem("Sync", {"inlogic_sync"})
    local inst = self.ItemInstance
    inst.Icon = ImageReference:FromPackRelativePath(SYNC_ICON)
    inst.BadgeText = BADGE_INDENT .. "Sync"
    inst.BadgeTextColor = "#abcdef"
    inst:SetOverlayBackground("")
    inst:SetOverlayFontSize(11)
    inst:SetOverlayAlign("left")
end

function InLogicSyncItem:canProvideCode(code)
    return code == "inlogic_sync"
end

function InLogicSyncItem:providesCode(code)
    return 0
end

function InLogicSyncItem:onLeftClick()
    syncInLogic()
end

local function owned(id)
    return Tracker:FindObjectForCode(POKEMON_MAPPING[id]).Active
end

local function green(level)
    return level == AccessibilityLevel.Normal
end

local function is_dexsanity_check(id)
    return has("dexsanity_" .. id) and not owned(id) and not Tracker:FindObjectForCode("dexsanity_" .. POKEMON_MAPPING[id]).Active
end

local function is_new(id)
    return not owned(id)
end

local function evolutions_of(id)
    return EVOLUTION_DATA[tostring(id)] or {}
end

local function evolve_targets(id, evo_vanilla, targets)
    for _, evo in ipairs(evolutions_of(id)) do
        if green(evolution_access(evo)) then
            table.insert(targets, evo.into)
            if evo_vanilla and not owned(evo.into) then
                evolve_targets(evo.into, evo_vanilla, targets)
            end
        end
    end
    return targets
end

local function stages_between(from, to)
    for _, evo in ipairs(evolutions_of(from)) do
        if evo.into == to then
            return {{id = from}}
        end
        local rest = stages_between(evo.into, to)
        if rest then
            rest[1].evo = evo
            table.insert(rest, 1, {id = from})
            return rest
        end
    end
end

local function breed_targets(id, full_vanilla)
    local child = BREEDING_DATA[tostring(id)]
    if not child or not green(breeding(id)) then
        return {}
    end
    local starts = {child}
    if child == 29 then
        table.insert(starts, 32)
    end
    local targets = {}
    for _, start in ipairs(starts) do
        local path = full_vanilla and not owned(start) and stages_between(start, id)
        if path then
            for i, stage in ipairs(path) do
                if i > 1 and not green(evolution_access(stage.evo)) then
                    break
                end
                table.insert(targets, stage.id)
                if i > 1 and owned(stage.id) then
                    break
                end
            end
        else
            table.insert(targets, start)
        end
    end
    return targets
end

local function any(targets, test)
    for _, target in ipairs(targets) do
        if test(target) then
            return true
        end
    end
    return false
end

local function fill(first, count, entries)
    for i = 1, count do
        INLOGIC_ITEMS[first + i - 1]:show(entries[i])
    end
end

function inlogic_split()
    return has("dexsanity") and (not has("randomize_evolution_true") or not has("randomize_breeding_true"))
end

function syncInLogic()
    if type(EVOLUTION_DATA) ~= "table" then
        fill(1, INLOGIC_SLOT_COUNT, {})
        return
    end

    local evo_vanilla = not has("randomize_evolution_true")
    local breed_vanilla = not has("randomize_breeding_true")
    local split = inlogic_split()

    local dexsanity, new = {}, {}
    for id = 1, #POKEMON_MAPPING do
        if owned(id) then
            local evolves = evolve_targets(id, evo_vanilla, {})
            local breeds = breed_targets(id, evo_vanilla and breed_vanilla)
            if evo_vanilla and any(evolves, is_dexsanity_check) then
                table.insert(dexsanity, {id = id, action = "Evolve"})
            end
            if breed_vanilla and any(breeds, is_dexsanity_check) then
                table.insert(dexsanity, {id = id, action = "Breed"})
            end
            if any(evolves, is_new) then
                table.insert(new, {id = id, action = "Evolve"})
            end
            if any(breeds, is_new) then
                table.insert(new, {id = id, action = "Breed"})
            end
        end
    end

    if #new == 0 then
        for _, line in ipairs(EMPTY_MESSAGES[math.random(#EMPTY_MESSAGES)]) do
            table.insert(new, {text = line})
        end
    end

    if split then
        fill(1, INLOGIC_COLUMN_SIZE, dexsanity)
        fill(INLOGIC_COLUMN_SIZE + 1, INLOGIC_SLOT_COUNT - INLOGIC_COLUMN_SIZE, new)
    else
        fill(1, INLOGIC_SLOT_COUNT, new)
    end
end

for i = 1, INLOGIC_SLOT_COUNT do
    INLOGIC_ITEMS[i] = InLogicItem(i)
end
INLOGIC_SYNC = InLogicSyncItem()
