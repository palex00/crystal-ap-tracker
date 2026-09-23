LOADED_LAYOUTS = {}

function load_layout(slot, path)
    if LOADED_LAYOUTS[slot] ~= path then
        LOADED_LAYOUTS[slot] = path
        Tracker:AddLayouts(path)
    end
end

local ER_CODES = {}
for _, cat in ipairs(ER_CATEGORIES) do
    table.insert(ER_CODES, "er_"..cat)
end

local function merge_codes(...)
    local codes, seen = {}, {}
    for _, list in ipairs({...}) do
        for _, code in ipairs(list) do
            if not seen[code] then
                seen[code] = true
                table.insert(codes, code)
            end
        end
    end
    return codes
end

local function with_er(...)
    return merge_codes({...}, ER_CODES)
end

local function any_er()
    for _, code in ipairs(ER_CODES) do
        if has(code.."_on") then
            return true
        end
    end
    return false
end

local function routing()
    return any_er() and "_routing" or ""
end

local function routing_side(side)
    if (side == "submap") == has("routing_tab_submap") then
        return routing()
    end
    return ""
end

local function nosilver()
    return has("johto_only_on") and "_nosilver" or ""
end

local function kanto_badges()
    local reqs = {RADIO_REQ, VR_REQ, E4_REQ, R44_REQ}
    if silver_cave() then
        table.insert(reqs, SILVER_REQ)
        table.insert(reqs, RED_REQ)
    end
    for _, req in ipairs(reqs) do
        if req:getType() == "badges" and req:getStage() > 8 then
            return true
        end
    end
    return false
end

local KANTO_BADGE_CODES = {"johto_only", "tower_requirement", "vr_requirement", "e4_requirement",
                           "route_44_requirement", "mt_silver_requirement", "red_requirement"}

local ITEM_GROUPS = {
    phone = {{"randomize_rematches", "randomize_phone_call_items", "encmethod_swarm"}, function()
        return has("randomize_rematches_true") or has("randomize_phone_call_items_on") or has("encmethod_swarm_on")
    end},
    map = {{"map_card_fly"}, function()
        return Tracker:FindObjectForCode("map_card_fly").CurrentStage > 0
    end},
    itemfinder = {{"hiddenitems_on"}, function()
        return has("hiddenitems_on") and not has("reqitemfinder_off")
    end},
    bicycle = {{"johto_only", "national_park_access"}, function()
        return johto_mode() == "johto_only" and has("national_park_bicycle")
    end},
    uberpass = {{"goal_battletower", "battle_tower_sanity"}, function()
        return has("battle_tower_sanity_tiers") and not has("goal_battletower_on")
    end},
    tierunlock = {{"goal_battletower", "battle_tower_sanity", "battle_tower_progressive_tier_unlocks"}, function()
        return has("battle_tower_sanity_tiers") and has("battle_tower_progressive_tier_unlocks_on") and not has("goal_battletower_on")
    end},
    tea = {{"johto_only", "coffee_north"}, function()
        return johto_mode() == "full" and (has("coffee_north") or has("coffee_east") or has("coffee_south") or has("coffee_west"))
    end},
    bluecard = {{"shopsanity_bluecard"}, function()
        return has("shopsanity_bluecard_true")
    end},
}

local function item_variant()
    if johto_mode() == "full" then
        return "full"
    end
    return "johto_only"..(kanto_badges() and "_kantobadges" or "")
end

local EVENT_GROUPS = {
    mom = {{"momsanity"}, function()
        return has("momsanity_on")
    end},
    rocket = {{"goal_rocket"}, function()
        return not has("goal_rocket_on")
    end},
    azalea = {{"goal_rival"}, function()
        return not has("goal_rival_on")
    end},
    jasmine = {{"vanilla_chain_jasmine"}, function()
        return has("vanilla_chain_jasmine_on")
    end},
    dungeon = {{"er_dungeon_interior"}, function()
        return has("er_dungeon_interior_on")
    end},
    gym = {{"er_gym_interior"}, function()
        return has("er_gym_interior_on")
    end},
    elitefour = {{"lance_requires_elite_four", "goal_e4"}, function()
        return has("lance_requires_elite_four_on") and not has("goal_e4_on")
    end},
    champion = {{"goal_e4"}, function()
        return not has("goal_e4_on")
    end},
    red = {{"johto_only", "battle_tower_sanity", "goal_red"}, function()
        return silver_cave() and has("battle_tower_sanity_tiers") and not has("goal_red_on")
    end},
    copycat = {{"vanilla_chain_copycat"}, function()
        return has("vanilla_chain_copycat_on")
    end},
    misty = {{"vanilla_chain_misty"}, function()
        return has("vanilla_chain_misty_on")
    end},
    mtmoon = {{"trainersanity", "trainersanity_301", "goal_rival"}, function()
        return (has("trainersanity") or partial_trainersanity() and has("trainersanity_301")) and not has("goal_rival_on")
    end},
}

local GOAL_GROUPS = {
    unown = {{"goal_unown"}, function()
        return has("goal_unown_on")
    end},
    rival = {{"goal_rival"}, function()
        return has("goal_rival_on")
    end},
    rocket = {{"goal_rocket"}, function()
        return has("goal_rocket_on")
    end},
    elitefour = {{"goal_e4", "lance_requires_elite_four"}, function()
        return has("goal_e4_on") and has("lance_requires_elite_four_on")
    end},
    champion = {{"goal_e4"}, function()
        return has("goal_e4_on")
    end},
    red = {{"goal_red"}, function()
        return has("goal_red_on")
    end},
    diploma = {{"goal_diploma"}, function()
        return has("goal_diploma_on")
    end},
    uberpass = {{"goal_battletower"}, function()
        return has("goal_battletower_on")
    end},
    tierunlock = {{"goal_battletower", "battle_tower_progressive_tier_unlocks"}, function()
        return has("goal_battletower_on") and has("battle_tower_progressive_tier_unlocks_on")
    end},
}

local function flow_grid(key, groups, order, extra_codes, path)
    local codes = {extra_codes}
    for _, name in ipairs(order) do
        table.insert(codes, groups[name][1])
    end
    return {key, merge_codes(table.unpack(codes)), function()
        local suffix = ""
        for _, name in ipairs(order) do
            if groups[name][2]() then
                suffix = suffix.."_"..name
            end
        end
        return path(suffix)
    end}
end

local function slot(group, name, codes, variant)
    return {"slot_"..name, codes, function()
        local value = variant()
        if value == true then
            value = "on"
        elseif value == false then
            value = "off"
        end
        return "layouts/slots/"..group.."/"..name.."_"..value..".json"
    end}
end

LAYOUT_SLOTS = {
    {"johto_dungeons", {"flooded_mine"}, function()
        return "layouts/submaps/johto_dungeons"..(has("flooded_mine_on") and "_floodedmine" or "")..".json"
    end},
    {"route_23", {"route_23_restored"}, function()
        return "layouts/submaps/route_23"..(has("route_23_restored_on") and "_restored" or "")..".json"
    end},
    {"ew_underground", {"ew_underground"}, function()
        return "layouts/submaps/ew_underground"..(has("ew_underground_on") and "_on" or "_off")..".json"
    end},
    {"tabs_meta", with_er("routing_tab"), function()
        return "layouts/tabs/meta"..routing_side("meta")..".json"
    end},
    {"tabs_regions", with_er("routing_tab", "johto_only"), function()
        return "layouts/"..johto_mode().."/tabs_regions"..nosilver()..routing_side("submap")..".json"
    end},
    {"tabbed_maps", with_er("splitmap", "johto_only"), function()
        if has("splitmap_off") then
            return "layouts/"..johto_mode().."/tabs_single"..nosilver()..routing()..".json"
        end
        return "layouts/tabs/tabs_"..(has("splitmap_on") and "split" or "reverse")..".json"
    end},
    {"tracker_default", {}, function()
        return "layouts/tracker/tracker.json"
    end},
    {"apricorn_section", {"shopsanity_apricorn"}, function()
        return "layouts/items/apricorns_"..(has("shopsanity_apricorn_true") and "on" or "off")..".json"
    end},

    {"shared_item_grid", KANTO_BADGE_CODES, function()
        return "layouts/"..johto_mode().."/items"..(item_variant() == "johto_only_kantobadges" and "_kantobadges" or "")..".json"
    end},
    flow_grid("item_tail", ITEM_GROUPS, {"phone", "map", "itemfinder", "bicycle", "uberpass", "tierunlock", "tea", "bluecard"}, KANTO_BADGE_CODES, function(suffix)
        return "layouts/items/tails/"..item_variant().."/tail"..suffix..".json"
    end),

    flow_grid("event_grid", EVENT_GROUPS, {"mom", "rocket", "azalea", "jasmine", "elitefour", "champion", "red"}, {}, function(suffix)
        return "layouts/events/johto/events"..suffix..".json"
    end),
    flow_grid("puzzle_event_grid", EVENT_GROUPS, {"dungeon", "gym"}, {}, function(suffix)
        return "layouts/events/puzzles/events"..suffix..".json"
    end),
    {"puzzle_event_section", {"er_dungeon_interior", "er_gym_interior"}, function()
        local shown = EVENT_GROUPS.dungeon[2]() or EVENT_GROUPS.gym[2]()
        return "layouts/events/puzzle_section_"..(shown and "on" or "off")..".json"
    end},
    flow_grid("kanto_event_grid", EVENT_GROUPS, {"copycat", "misty", "mtmoon"}, {"johto_only"}, function(suffix)
        if johto_mode() == "johto_only" then
            return "layouts/events/kanto/johto_only.json"
        end
        return "layouts/events/kanto/events"..suffix..".json"
    end),
    flow_grid("goal_progress_grid", GOAL_GROUPS, {"unown", "rival", "rocket", "elitefour", "champion", "red", "diploma", "uberpass", "tierunlock"}, {"johto_only"}, function(suffix)
        return "layouts/goal/"..johto_mode().."/goal"..suffix..".json"
    end),

    slot("tools", "digits", {}, function()
        return SLOT_TRACK == true
    end),
    slot("tools", "show_signs", {"goal_unown"}, function()
        return has("goal_unown_on")
    end),
    slot("tools", "show_grass", {"grasssanity"}, function()
        return has("grasssanity_any")
    end),
    slot("tools", "show_entrances", with_er(), any_er),
    slot("tools", "routing_tab", with_er(), any_er),
    slot("tools", "auto_shop", {"shopsanity_johtomarts", "shopsanity_kantomarts"}, function()
        return has("shopsanity_anymart")
    end),

    slot("pokedex", "inlogic", {"randomize_evolution", "randomize_breeding", "dexsanity"}, function()
        return inlogic_split() and "split" or "new"
    end),
}

SLOTS_BY_CODE = {}
SLOT_BY_NAME = {}

function update_layout_slots(code)
    for _, entry in ipairs(SLOTS_BY_CODE[code]) do
        load_layout(entry[1], entry[3]())
    end
end

function update_layout_slot(name)
    local entry = SLOT_BY_NAME[name]
    load_layout(entry[1], entry[3]())
end

for _, entry in ipairs(LAYOUT_SLOTS) do
    SLOT_BY_NAME[entry[1]] = entry
    for _, code in ipairs(entry[2]) do
        if not SLOTS_BY_CODE[code] then
            SLOTS_BY_CODE[code] = {}
            ScriptHost:AddWatchForCode("layout_slots_"..code, code, update_layout_slots)
        end
        table.insert(SLOTS_BY_CODE[code], entry)
    end
    load_layout(entry[1], entry[3]())
end
