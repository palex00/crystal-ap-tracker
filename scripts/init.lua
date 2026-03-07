Tracker.AllowDeferredLogicUpdate = true

-- Items
Tracker:AddItems("items/items.json")
Tracker:AddItems("items/items_hosted.json")
Tracker:AddItems("items/events.json")
Tracker:AddItems("items/events_hosted.json")
Tracker:AddItems("items/settings.json")
Tracker:AddItems("items/pokemon.json")
Tracker:AddItems("items/trainersanity.json")
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
Tracker:AddMaps("maps/mm_vanilla.json")
Tracker:AddMaps("maps/r42.json")
Tracker:AddMaps("maps/r12.json")
Tracker:AddMaps("maps/victory_road_vanilla.json")
Tracker:AddMaps("maps/maps_johto_and_kanto.json")

-- Locations
Tracker:AddLocations("locations/locations.json")
Tracker:AddLocations("locations/dungeons.json")
Tracker:AddLocations("locations/dexsanity.json")
Tracker:AddLocations("locations/pokedex.json")
Tracker:AddLocations("locations/evolutionsanity.json")
Tracker:AddLocations("locations/encounters_submaps.json")
Tracker:AddLocations("locations/special_encounters.json")
Tracker:AddLocations("locations/grass_submaps.json")
Tracker:AddLocations("locations/new_signs.json")

-- Layout
Tracker:AddLayouts("layouts/dungeon_maps.json")
Tracker:AddLayouts("layouts/events_red.json")
Tracker:AddLayouts("layouts/settings.json")
Tracker:AddLayouts("layouts/settings_quick.json")
Tracker:AddLayouts("layouts/pokemonlogic.json")
Tracker:AddLayouts("layouts/items_no_tea.json")
Tracker:AddLayouts("layouts/flyunlocks.json")
Tracker:AddLayouts("layouts/shopsanity_all.json")
Tracker:AddLayouts("layouts/tabs_single.json")
Tracker:AddLayouts("layouts/overworld.json")
Tracker:AddLayouts("layouts/tracker.json")
Tracker:AddLayouts("layouts/unown_tiles.json")
Tracker:AddLayouts("layouts/broadcast/broadcast.json")
Tracker:AddLayouts("layouts/pokedex.json")
Tracker:AddLayouts("layouts/dexcountsanity.json")

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
    ScriptHost:AddWatchForCode(code, code, update_gymcount)
end
ScriptHost:AddWatchForCode("gym_digit1", "gym_digit1", calculateEvoLevel)
ScriptHost:AddWatchForCode("gym_digit2", "gym_digit2", calculateEvoLevel)
ScriptHost:AddWatchForCode("yaml_digit1", "yaml_digit1", calculateEvoLevel)
ScriptHost:AddWatchForCode("yaml_digit2", "yaml_digit2", calculateEvoLevel)

ScriptHost:AddWatchForCode("dexsanity", "dexsanity", showMonVisibility)

ScriptHost:AddWatchForCode("goal2", "goal", toggle_itemgrid)
ScriptHost:AddWatchForCode("randomize_fly_unlocks", "randomize_fly_unlocks", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_gamecorners", "shopsanity_gamecorners", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_bluecard", "shopsanity_bluecard", toggle_itemgrid)
ScriptHost:AddWatchForCode("shopsanity_apricorn", "shopsanity_apricorn", toggle_itemgrid)
ScriptHost:AddWatchForCode("broadcast_view", "broadcast_view", toggle_itemgrid)

-- Hosted item watches
HOSTED_ITEMS = {
    "POKE_GEAR",
    "PHONE_CARD",
    "EVENT_GAVE_MYSTERY_EGG_TO_ELM",
    "MAP_CARD",
    "EVENT_BEAT_CHERRYGROVE_RIVAL",
    "EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON",
    "POKEDEX",
    "EVENT_GAVE_KENYA",
    "EVENT_BEAT_FALKNER",
    "ZEPHYR_BADGE",
    "EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE",
    "EVENT_GOT_ALL_UNOWN",
    "ENGINE_UNLOCKED_UNOWNS_A_TO_K",
    "ENGINE_UNLOCKED_UNOWNS_L_TO_R",
    "ENGINE_UNLOCKED_UNOWNS_S_TO_W",
    "ENGINE_UNLOCKED_UNOWNS_X_TO_Z",
    "EVENT_CLEARED_SLOWPOKE_WELL",
    "WHT_APRICORN",
    "EVENT_BEAT_BUGSY",
    "HIVE_BADGE",
    "EVENT_BEAT_AZALEA_RIVAL",
    "EVENT_HERDED_FARFETCHD",
    "EVENT_GOT_ODD_EGG",
    "WATER_STONE",
    "EVENT_BEAT_WHITNEY",
    "PLAIN_BADGE",
    "EVENT_BEAT_GOLDENROD_UNDERGROUND_RIVAL",
    "RADIO_CARD",
    "EVENT_BEAT_ROCKET_EXECUTIVEM_3",
    "EVENT_CLEARED_RADIO_TOWER",
    "EVENT_GOT_KENYA",
    "EVENT_SAW_SUICUNE_ON_ROUTE_36",
    "RED_APRICORN",
    "BLU_APRICORN",
    "BLK_APRICORN",
    "EVENT_MET_BILL",
    "EVENT_BEAT_MORTY",
    "FOG_BADGE",
    "EVENT_RIVAL_BURNED_TOWER",
    "EVENT_RELEASED_THE_BEASTS",
    "EVENT_GOT_EON_MAIL_FROM_EUSINE",
    "EVENT_BEAT_JASMINE",
    "MINERAL_BADGE",
    "EVENT_JASMINE_RETURNED_TO_GYM",
    "EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY",
    "EVENT_BEAT_CHUCK",
    "STORM_BADGE",
    "EVENT_SAW_SUICUNE_ON_ROUTE_42",
    "PNK_APRICORN",
    "GRN_APRICORN",
    "YLW_APRICORN",
    "EVENT_BEAT_PRYCE",
    "GLACIER_BADGE",
    "EVENT_CLEARED_ROCKET_HIDEOUT",
    "EVENT_DECIDED_TO_HELP_LANCE",
    "EVENT_BEAT_CLAIR",
    "RISING_BADGE",
    "EVENT_BEAT_VICTORY_ROAD_RIVAL",
    "EVENT_BEAT_RIVAL_IN_INDIGO_PLATEAU",
    "EVENT_BEAT_ELITE_FOUR",
    "EVENT_BEAT_RED",
    "EVENT_BEAT_BLUE",
    "EARTH_BADGE",
    "EVENT_BEAT_BROCK",
    "BOULDER_BADGE",
    "EVENT_BEAT_RIVAL_IN_MT_MOON",
    "EVENT_BEAT_MISTY",
    "CASCADE_BADGE",
    "EVENT_ROUTE_24_ROCKET",
    "EVENT_RESTORED_POWER_TO_KANTO",
    "EXPN_CARD",
    "EVENT_BEAT_SABRINA",
    "MARSH_BADGE",
    "EVENT_BEAT_ERIKA",
    "RAINBOW_BADGE",
    "EVENT_OBTAINED_DIPLOMA",
    "EVENT_BEAT_LTSURGE",
    "THUNDER_BADGE",
    "EVENT_BEAT_JANINE",
    "SOUL_BADGE",
    "EVENT_BEAT_BLAINE",
    "VOLCANO_BADGE",
    "EVENT_VIRIDIAN_GYM_BLUE"
}
for _, code in pairs(HOSTED_ITEMS) do
	ScriptHost:AddWatchForCode(code, code, toggle_item)
	ScriptHost:AddWatchForCode(code .. "_HOSTED", code .. "_HOSTED", toggle_hosted_item)
end


--for _, code in ipairs(FLAG_STATIC_CODES) do
--    print(code)
--    ScriptHost:AddWatchForCode(code, code, updatePokemon)
--end

-- Makes version nil
first_two_dots = nil
