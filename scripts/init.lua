Tracker.AllowDeferredLogicUpdate = true

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/settings_encevo.json")
Tracker:AddItems("items/tools.json")
Tracker:AddItems("items/pokemon.json")
Tracker:AddItems("items/trainersanity.json")
Tracker:AddItems("items/dexsanity_items.json")
Tracker:AddItems("items/settings_er.json")
Tracker:AddItems("items/route.json")

-- Logic
ScriptHost:LoadScript("scripts/utils.lua")
-- Must be the FIRST watch registered: watch callbacks fire in registration order, so this drops the
-- LogicCount memo before any other callback can read it. See InvalidateLogicCounts in utils.lua.
ScriptHost:AddWatchForCode("logiccount invalidate", "*", InvalidateLogicCounts)
ScriptHost:LoadScript("scripts/toggles.lua")
ScriptHost:LoadScript("scripts/logic/logic.lua")
ScriptHost:LoadScript("scripts/logic/dexsanity.lua")
ScriptHost:LoadScript("scripts/custom_items.lua")

-- Entrance Randomization: CanReach graph engine + entrance items + route mode.
-- Order matters (imperative graph construction): helpers -> engine -> nodes -> connections
-- -> registry -> items -> route mode. custom_items.lua (above) must load first (CustomItem base).
ScriptHost:LoadScript("scripts/logic/logic_helpers.lua")
ScriptHost:LoadScript("scripts/logic/canreach.lua")
ScriptHost:LoadScript("scripts/logic/regions/region_definitions.lua")
ScriptHost:LoadScript("scripts/logic/regions/connections.lua")
-- Encounter leaves load BEFORE the dark pass ON PURPOSE -- the opposite of check_leafs.lua
-- below. An encounter leaf is shared: one table is attached from every region that holds it,
-- and some tables straddle dark and lit regions (FISHING_Ocean has 1 dark attach point and 23
-- lit ones). A per-section $dark in the JSON would then demand Flash to fish the Ocean
-- anywhere, so the gate has to sit on the individual attach EDGE instead -- which is exactly
-- what gate_region_exits does to every outgoing edge of a dark region. Loading here lets the
-- dark attach points get gated and leaves the lit ones alone.
ScriptHost:LoadScript("scripts/logic/regions/encounter_leafs.lua")
-- Dark areas wrap the edges declared above, so they must come after connections.lua -- and
-- BEFORE check_leafs.lua, because they wrap every exit of a dark region and the check leaves
-- are exits too. Those leaves are deliberately left ungated here; each is attached from a
-- single region, so the area gate is ANDed onto the location in its JSON instead.
-- See connections_darkareas.lua.
ScriptHost:LoadScript("scripts/logic/regions/connections_darkareas.lua")
ScriptHost:LoadScript("scripts/logic/regions/check_leafs.lua")
ScriptHost:LoadScript("scripts/entrances/entrance_registry.lua")
ScriptHost:LoadScript("scripts/entrances/entrance_item.lua")
-- Entrance items are created per-ENABLED-category, not all at once: a vanilla entrance needs no
-- tracker item, and a large _luaItems set makes every toggle laggy. Build the token->category
-- map now; the actual EntranceItems are instantiated by createEntrancesForEnabled(), driven by
-- refreshERCategories() (called at the end of init and whenever a category toggles / on connect).
buildEntranceCategoryMap()
ScriptHost:LoadScript("scripts/routing/route_mode.lua")
-- Structural sanity check: warns loudly if a warp is declared in only one of the graph /
-- registry, has a bad category, or collides on an id. Read-only; no-ops until data exists.
ScriptHost:LoadScript("scripts/entrances/entrance_validate.lua")

-- Maps
Tracker:AddMaps("maps/maps.json")
Tracker:AddMaps("maps/pokedex.json")
Tracker:AddMaps("maps/ilex_forest_tree.json")
Tracker:AddMaps("maps/route_2_ledge.json")
Tracker:AddMaps("maps/lake_of_rage_vanilla.json")
Tracker:AddMaps("maps/blackthorn_dark_cave_vanilla.json")
Tracker:AddMaps("maps/mm_vanilla.json")
Tracker:AddMaps("maps/r42.json")
Tracker:AddMaps("maps/r12.json")
Tracker:AddMaps("maps/victory_road_vanilla.json")
Tracker:AddMaps("maps/maps_johto_and_kanto.json")

-- Locations
Tracker:AddLocations("locations/locations.jsonc")
Tracker:AddLocations("locations/dungeons.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/evolutionsanity.json")
Tracker:AddLocations("locations/encounters_submaps.json")
Tracker:AddLocations("locations/special_encounters.json")
Tracker:AddLocations("locations/grass_submaps.json")
Tracker:AddLocations("locations/new_signs.json")

-- Layout
---- maps & locations
Tracker:AddLayouts("layouts/dungeon_maps.json")
Tracker:AddLayouts("layouts/tabs_single.json")
Tracker:AddLayouts("layouts/overworld.json")
Tracker:AddLayouts("layouts/route.json")

---- items
Tracker:AddLayouts("layouts/tracker/tracker_flyunlock_other.json") -- maximum itemgrids
Tracker:AddLayouts("layouts/items/items_max.json") -- debug for now, will be changed to dynamic later
Tracker:AddLayouts("layouts/items/encevo_max.json") -- debug for now, will be changed to dynamic later
Tracker:AddLayouts("layouts/items/other_max.json") -- debug for now, will be changed to dynamic later
Tracker:AddLayouts("layouts/items/flyunlocks.json") --static
Tracker:AddLayouts("layouts/events/events_max.json") -- debug for now, will be changed to dynamic later

---- settings
Tracker:AddLayouts("layouts/settings/settings.json")
Tracker:AddLayouts("layouts/settings/settings_encevo.json")
Tracker:AddLayouts("layouts/settings/settings_popup.json")
Tracker:AddLayouts("layouts/tools/tools_max.json")

---- other
Tracker:AddLayouts("layouts/levelinglogic.json")
Tracker:AddLayouts("layouts/broadcast/broadcast.json")
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/dexcountsanity.json")


-- AutoTracking for Poptracker
ScriptHost:LoadScript("scripts/autotracking.lua")

---- Watches
--ScriptHost:AddWatchForCode("johto_only", "johto_only", toggle_johto)
--ScriptHost:AddWatchForCode("tea_guard", "tea_guard", toggle_johto)
--ScriptHost:AddWatchForCode("phone_calls_visible", "phone_calls_visible", toggle_johto)
--ScriptHost:AddWatchForCode("badges", "badges", toggle_johto)
--ScriptHost:AddWatchForCode("goal", "goal", toggle_johto)
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

--ScriptHost:AddWatchForCode("randomize_fly_unlocks", "randomize_fly_unlocks", toggle_itemgrid)
--ScriptHost:AddWatchForCode("shopsanity_gamecorners", "shopsanity_gamecorners", toggle_itemgrid)
--ScriptHost:AddWatchForCode("shopsanity_bluecard", "shopsanity_bluecard", toggle_itemgrid)
--ScriptHost:AddWatchForCode("shopsanity_apricorn", "shopsanity_apricorn", toggle_itemgrid)
--ScriptHost:AddWatchForCode("broadcast_view", "broadcast_view", toggle_itemgrid)
ScriptHost:AddWatchForCode("hint_tracking", "hint_tracking", toggleHints)
--ScriptHost:AddWatchForCode("grasssanity", "grasssanity", toggleQuickSettings)
--ScriptHost:AddWatchForCode("goal", "goal", updateGoalLayout)
--ScriptHost:AddWatchForCode("shopsanity_johtomarts", "shopsanity_johtomarts", toggleQuickSettings)
--ScriptHost:AddWatchForCode("shopsanity_kantomarts", "shopsanity_kantomarts", toggleQuickSettings)

-- ER category toggles -> refresh ER_CATEGORY_ENABLED for the CanReach detour
for _, cat in ipairs(ER_CATEGORIES) do
    ScriptHost:AddWatchForCode("er_" .. cat, "er_" .. cat, toggle_er)
end
refreshERCategories()

-- Warm the LogicCount cache across frames so a later batch (e.g. autotracking on connect)
-- never cold-resolves many codes inside one flood-fill. See WarmLogicCountsStep in canreach.lua.
ScriptHost:AddOnFrameHandler("logic warm", WarmLogicCountsStep)

-- TEMPORARY: per-frame report of how many entrance canProvideCode calls PopTracker made.
ScriptHost:AddOnFrameHandler("entrance probe", EntranceProbeReport)

-- Makes version nil
first_two_dots = nil
