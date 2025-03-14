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
-- Locations
Tracker:AddLocations("locations/locations.json")
if PopVersion and PopVersion >= "0.23.0" then
	Tracker:AddLocations("locations/dungeons.json")
end

-- Layout
Tracker:AddLayouts("layouts/dungeon_maps.json")
Tracker:AddLayouts("layouts/events.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/items.json")
Tracker:AddLayouts("layouts/tabs.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/broadcast.json")

-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

-- Watches
ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)