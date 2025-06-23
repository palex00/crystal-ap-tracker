Tracker.AllowDeferredLogicUpdate = true
-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/pokemon.json")
Tracker:AddItems("items/dexsanity_items.json")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/logic/dexsanity.lua")
ScriptHost:LoadScript("scripts/custom_items.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/pokedex.json")
Tracker:AddMaps("maps/ilex_forest_tree.json")
Tracker:AddMaps("maps/route_2_ledge.json")
Tracker:AddMaps("maps/lake_of_rage_vanilla.json")
Tracker:AddMaps("maps/blackthorn_dark_cave_vanilla.json")
Tracker:AddMaps("maps/maps_johto_and_kanto.json")

-- Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/dungeons.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/encounters_submaps.json")
Tracker:AddLocations("locations/special_encounters.json")

-- Layout
Tracker:AddLayouts("layouts/dungeon_maps.json")
Tracker:AddLayouts("layouts/events.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/pokemonlogic.json")
Tracker:AddLayouts("layouts/items_no_tea.json")
Tracker:AddLayouts("layouts/tabs_single.json")
Tracker:AddLayouts("layouts/overworld.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/dexsanity_items.json")
Tracker:AddLayouts("layouts/dexcountsanity.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)
ScriptHost:AddWatchForCode("tea_guard", "tea_guard", toggle_johto)
ScriptHost:AddWatchForCode("badges", "badges", toggle_johto)
ScriptHost:AddWatchForCode("splitmap", "splitmap", toggle_splitmap)
ScriptHost:AddWatchForCode("ilextree", "ilextree", toggle_ilex)
ScriptHost:AddWatchForCode("route_2_access", "route_2_access", toggle_route2)
ScriptHost:AddWatchForCode("red_gyarados_access", "red_gyarados_access", toggle_lakeofrage)
ScriptHost:AddWatchForCode("blackthorn_dark_cave_access", "blackthorn_dark_cave_access", toggle_darkcave)
ScriptHost:AddWatchForCode("mischief", "mischief", toggle_mischief)
ScriptHost:AddWatchForCode("chrism", "chrism", toggle_mischief)
for _, code in ipairs(gym_codes) do
    ScriptHost:AddWatchForCode(code, code, update_gymcount)
end
ScriptHost:AddWatchForCode("gym_digit1", "gym_digit1", calculateEvoLevel)
ScriptHost:AddWatchForCode("gym_digit2", "gym_digit2", calculateEvoLevel)
ScriptHost:AddWatchForCode("yaml_digit1", "yaml_digit1", calculateEvoLevel)
ScriptHost:AddWatchForCode("yaml_digit2", "yaml_digit2", calculateEvoLevel)
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", updatePokemon)

ScriptHost:AddWatchForCode("dexsanity", "dexsanity", showMonVisibility)


--for _, code in ipairs(FLAG_STATIC_CODES) do
--    print(code)
--    ScriptHost:AddWatchForCode(code, code, updatePokemon)
--end

-- Makes version nil
first_two_dots = nil
pokemon = nil