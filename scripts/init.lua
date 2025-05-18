Tracker.AllowDeferredLogicUpdate = true
-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/pokemon.json")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/ilex_forest_no_tree.json")
Tracker:AddMaps("maps/route_2_ledge.json")
Tracker:AddMaps("maps/lake_of_rage_vanilla.json")
Tracker:AddMaps("maps/blackthorn_dark_cave_vanilla.json")
Tracker:AddMaps("maps/maps_johto_and_kanto.json")

-- Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/dungeons.json")

-- Layout
Tracker:AddLayouts("layouts/dungeon_maps.json")
Tracker:AddLayouts("layouts/events.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/overworld.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")
Tracker:AddLayouts("layouts/pokedex.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)
ScriptHost:AddWatchForCode("ilextree", "ilextree", toggle_ilex)
ScriptHost:AddWatchForCode("route_2_access", "route_2_access", toggle_route2)
ScriptHost:AddWatchForCode("red_gyarados_access", "red_gyarados_access", toggle_lakeofrage)
ScriptHost:AddWatchForCode("blackthorn_dark_cave_access", "blackthorn_dark_cave_access", toggle_darkcave)
ScriptHost:AddWatchForCode("r32_guy", "r32_guy", toggle_johto)
ScriptHost:AddWatchForCode("badges", "badges", toggle_johto)
ScriptHost:AddWatchForCode("mischief", "mischief", toggle_mischief)
ScriptHost:AddWatchForCode("chrism", "chrism", toggle_mischief)

-- Makes version nil
first_two_dots = nil