Tracker.AllowDeferredLogicUpdate = true

-- Items
Tracker:AddItems("items/items.jsonc")
Tracker:AddItems("items/events.jsonc")
Tracker:AddItems("items/settings.jsonc")
Tracker:AddItems("items/settings_encevo.jsonc")
Tracker:AddItems("items/tools.jsonc")
Tracker:AddItems("items/pokemon.jsonc")
Tracker:AddItems("items/trainersanity.jsonc")
Tracker:AddItems("items/dexsanity_items.jsonc")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/logic/dexsanity.lua")
ScriptHost:LoadScript("scripts/custom_items.lua")

-- Maps
Tracker:AddMaps("maps/maps.jsonc")
Tracker:AddMaps("maps/pokedex.jsonc")
Tracker:AddMaps("maps/ilex_forest_tree.jsonc")
Tracker:AddMaps("maps/route_2_ledge.jsonc")
Tracker:AddMaps("maps/lake_of_rage_vanilla.jsonc")
Tracker:AddMaps("maps/blackthorn_dark_cave_vanilla.jsonc")
Tracker:AddMaps("maps/mm_vanilla.jsonc")
Tracker:AddMaps("maps/r42.jsonc")
Tracker:AddMaps("maps/r12.jsonc")
Tracker:AddMaps("maps/victory_road_vanilla.jsonc")
Tracker:AddMaps("maps/maps_johto_and_kanto.jsonc")

-- Locations
Tracker:AddLocations("locations/locations.jsonc")
Tracker:AddLocations("locations/dungeons.jsonc")
Tracker:AddLocations("locations/dexsanity.jsonc")
Tracker:AddLocations("locations/pokedex.jsonc")
Tracker:AddLocations("locations/evolutionsanity.jsonc")
Tracker:AddLocations("locations/encounters_submaps.jsonc")
Tracker:AddLocations("locations/special_encounters.jsonc")
Tracker:AddLocations("locations/grass_submaps.jsonc")
Tracker:AddLocations("locations/new_signs.jsonc")

-- Layout
Tracker:AddLayouts("layouts/dungeon_maps.jsonc")
Tracker:AddLayouts("layouts/events_red.jsonc")
Tracker:AddLayouts("layouts/settings.jsonc")
Tracker:AddLayouts("layouts/settings_encevo.jsonc")
Tracker:AddLayouts("layouts/settings_popup.jsonc")
Tracker:AddLayouts("layouts/settings_quick/settings_quick.jsonc")
Tracker:AddLayouts("layouts/levelinglogic.jsonc")
Tracker:AddLayouts("layouts/items_no_tea.jsonc")
Tracker:AddLayouts("layouts/flyunlocks.jsonc")
Tracker:AddLayouts("layouts/shopsanity_all.jsonc")
Tracker:AddLayouts("layouts/tabs_single.jsonc")
Tracker:AddLayouts("layouts/overworld.jsonc")
Tracker:AddLayouts("layouts/tracker.jsonc")
Tracker:AddLayouts("layouts/unown_tiles.jsonc")
Tracker:AddLayouts("layouts/broadcast/broadcast.jsonc")
Tracker:AddLayouts("layouts/pokedex.jsonc")
Tracker:AddLayouts("layouts/dexcountsanity.jsonc")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)
ScriptHost:AddWatchForCode("tea_guard", "tea_guard", toggle_johto)
ScriptHost:AddWatchForCode("phone_calls_visible", "phone_calls_visible", toggle_johto)
ScriptHost:AddWatchForCode("badges", "badges", toggle_johto)
ScriptHost:AddWatchForCode("goal", "goal", toggle_johto)
ScriptHost:AddWatchForCode("splitmap", "splitmap", toggle_splitmap)
ScriptHost:AddWatchForCode("ilextree", "ilextree", toggle_ilex)
ScriptHost:AddWatchForCode("route_2_access", "route_2_access", toggle_route2)
ScriptHost:AddWatchForCode("red_gyarados_access", "red_gyarados_access", toggle_lakeofrage)
ScriptHost:AddWatchForCode("blackthorn_dark_cave_access", "blackthorn_dark_cave_access", toggle_darkcave)
ScriptHost:AddWatchForCode("mount_mortar_access", "mount_mortar_access", toggle_mountmortar)
ScriptHost:AddWatchForCode("route_42_access", "route_42_access", toggle_mountmortar)
ScriptHost:AddWatchForCode("route_12_access", "route_12_access", toggle_r12)
ScriptHost:AddWatchForCode("victory_road_access", "victory_road_access", toggle_victoryroad)
ScriptHost:AddWatchForCode("mischief", "mischief", toggle_mischief)
ScriptHost:AddWatchForCode("chrism", "chrism", toggle_mischief)
for _, code in ipairs(gym_codes) do
    ScriptHost:AddWatchForCode(code, code, calculateEvoLevel)
end
ScriptHost:AddWatchForCode("yaml_digit1", "yaml_digit1", calculateEvoLevel)
ScriptHost:AddWatchForCode("yaml_digit2", "yaml_digit2", calculateEvoLevel)
for _, code in ipairs(FLAG_STATIC_CODES) do
    ScriptHost:AddWatchForCode(code, code, updatePokemon)
end
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", function() updatePokemon() end)

ScriptHost:AddWatchForCode("dexsanity", "dexsanity", showMonVisibility)

ScriptHost:AddWatchForCode("goal2", "goal", toggle_itemgrid)
ScriptHost:AddWatchForCode("randomize_fly_unlocks", "randomize_fly_unlocks", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_gamecorners", "shopsanity_gamecorners", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_bluecard", "shopsanity_bluecard", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_apricorn", "shopsanity_apricorn", toggle_itemgrid)
ScriptHost:AddWatchForCode("broadcast_view", "broadcast_view", toggle_itemgrid)
ScriptHost:AddWatchForCode("hint_tracking", "hint_tracking", toggleHints)
ScriptHost:AddWatchForCode("grasssanity", "grasssanity", toggleQuickSettings)
ScriptHost:AddWatchForCode("goal", "goal", toggleQuickSettings)
ScriptHost:AddWatchForCode("shopsanity_johtomarts", "shopsanity_johtomarts", toggleQuickSettings)
ScriptHost:AddWatchForCode("shopsanity_kantomarts", "shopsanity_kantomarts", toggleQuickSettings)

-- Makes version nil
first_two_dots = nil
