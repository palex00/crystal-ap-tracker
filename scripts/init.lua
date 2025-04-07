Tracker.AllowDeferredLogicUpdate = true
--Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/settings.json")
-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/ilex_forest_no_tree.json")
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

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)
ScriptHost:AddWatchForCode("ilextree", "ilextree", toggle_ilex)
ScriptHost:AddWatchForCode("r32_guy", "r32_guy", toggle_johto)
ScriptHost:AddWatchForCode("badges", "badges", toggle_johto)