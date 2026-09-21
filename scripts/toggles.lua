MODE_LAYOUTS = {
    "items",
    "overworld",
    "events",
    "flyunlocks",
    "settings",
    "settings_flydestinations"
}

function johto_mode()
    return has("johto_only_off") and "full" or "johto_only"
end

function toggle_johto()
    local dir = johto_mode()

    Tracker:AddMaps(dir == "full" and "maps/maps_johto_and_kanto.json" or "maps/maps_johto_only.json")

    for _, name in ipairs(MODE_LAYOUTS) do
        Tracker:AddLayouts("layouts/"..dir.."/"..name..".json")
    end

    toggle_splitmap()
end

SUDOWOODO = false

local function add_map(name)
    Tracker:AddMaps("maps/"..(SUDOWOODO and "mischief/" or "")..name..".json")
end

function toggle_mischief()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1
    if sudowoodo == SUDOWOODO then
        return
    end
    SUDOWOODO = sudowoodo

    add_map("maps")
    toggle_ilex()
    toggle_route2()
    toggle_lakeofrage()
    toggle_darkcave()
    toggle_mountmortar()
    toggle_r12()
    toggle_victoryroad()
    toggle_floodedmine()
end

function toggle_ilex()
    local suffix = "_no_tree"

    if has("ilextree_on") then
        suffix = "_tree"
    end

    add_map("ilex_forest"..suffix)
end

function toggle_route2()
    local suffix = "_ledge"

    if has("route_2_fence") then
        suffix = "_fence"
    elseif has("route_2_open") then
        suffix = "_open"
    end

    add_map("route_2"..suffix)
end

function toggle_lakeofrage()
    local suffix = "_vanilla"

    if has("red_gyarados_whirlpool") then
        suffix = "_whirlpool"
    elseif has("red_gyarados_shore") then
        suffix = "_shore"
    end

    add_map("lake_of_rage"..suffix)
end

function toggle_darkcave()
    local suffix = "_vanilla"

    if has("blackthorn_dark_cave_waterfall") then
        suffix = "_waterfall"
    end

    add_map("blackthorn_dark_cave"..suffix)
end

function toggle_mountmortar()
    local suffix = "vanilla"

    if has("mount_mortar_access_rocksmash") then
        suffix = "rocksmash"
    end

    if has("route_42_access_whirlchanges") or has("route_42_access_blocked") then
        suffix = suffix.."_hole"
    end

    add_map("mm_"..suffix)

    suffix = ""

    if has("route_42_access_whirlpool") or has("route_42_access_whirlchanges") then
        suffix = "_whirl"
    elseif has("route_42_access_blocked") then
        suffix = "_blocked"
    end

    add_map("r42"..suffix)
end

function toggle_r12()
    local suffix = ""

    if has("route_12_access_weirdtree") then
        suffix = "_tree"
	elseif has("route_12_access_weirdtree_surfblock") then
		suffix = "_treerocks"
    end

    add_map("r12"..suffix)
end

function toggle_victoryroad()
    local suffix = "_vanilla"

    if has("victory_road_strength_on") then
        suffix = "_strength"
    end

    add_map("victory_road"..suffix)
end

function toggle_floodedmine()
    local suffix = "_off"

    if has("flooded_mine_on") then
        suffix = "_on"
    end

    add_map("floodedmine"..suffix)
end

function toggle_splitmap()
    local suffix = "_single"
    if has("splitmap_on") then
        suffix = "_split"
    elseif has("splitmap_reverse") then
        suffix = "_reverse"
    end

    Tracker:AddLayouts("layouts/"..johto_mode().."/tabs"..suffix..".json")
end

function toggle_itemgrid()
    local suffix = ""
    if has("randomize_fly_unlocks_true") then
        suffix = suffix .. "_flyunlock"
    end
    if has("shopsanity_bluecard_true") or has("shopsanity_apricorn_true") then
        suffix = suffix .. "_shopsanity"
    end
    if has("goal_unown") then
        suffix = suffix .. "_tiles"
    end

    Tracker:AddLayouts("layouts/tracker/tracker"..suffix..".json")

    local prefix = ""
    if has("broadcast_view_vertical") then
        prefix = "vertical_"
    end

    Tracker:AddLayouts("layouts/broadcast/"..prefix.."broadcast"..suffix..".json")

    toggle_shopgrid()
end

function toggle_shopgrid()
    local bluecard = has("shopsanity_bluecard_true")
    local apricorn = has("shopsanity_apricorn_true")
    if bluecard and apricorn then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_all.json")
    elseif bluecard then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_bluecard.json")
    elseif apricorn then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_apricorn.json")
    end
end

function toggleQuickSettings()
    local suffix = ""

    if SLOT_TRACK == true then
        suffix = suffix .. "_slots"
    end

    if has("goal_unown") then
        suffix = suffix .. "_signs"
    end

    if has("grasssanity_any") then
        suffix = suffix .. "_grass"
    end

    if has("shopsanity_anymart") then
        suffix = suffix .. "_shop"
    end

    Tracker:AddLayouts("layouts/settings_quick/settings_quick"..suffix..".json")
end

function updateGoalLayout()
    toggleQuickSettings()
    toggle_itemgrid()
end

HOSTED_EVENT_CODES = {
    "ENGINE_UNLOCKED_UNOWNS_A_TO_K",
    "ENGINE_UNLOCKED_UNOWNS_L_TO_R",
    "ENGINE_UNLOCKED_UNOWNS_S_TO_W",
    "ENGINE_UNLOCKED_UNOWNS_X_TO_Z",
    "EVENT_BEAT_AZALEA_RIVAL",
    "EVENT_BEAT_BLAINE",
    "EVENT_BEAT_BLUE",
    "EVENT_BEAT_BROCK",
    "EVENT_BEAT_BUGSY",
    "EVENT_BEAT_CHERRYGROVE_RIVAL",
    "EVENT_BEAT_CHUCK",
    "EVENT_BEAT_CLAIR",
    "EVENT_BEAT_ELITE_4_BRUNO",
    "EVENT_BEAT_ELITE_4_KAREN",
    "EVENT_BEAT_ELITE_4_KOGA",
    "EVENT_BEAT_ELITE_4_WILL",
    "EVENT_BEAT_ELITE_FOUR",
    "EVENT_BEAT_ERIKA",
    "EVENT_BEAT_FALKNER",
    "EVENT_BEAT_GOLDENROD_UNDERGROUND_RIVAL",
    "EVENT_BEAT_JANINE",
    "EVENT_BEAT_JASMINE",
    "EVENT_BEAT_LTSURGE",
    "EVENT_BEAT_MISTY",
    "EVENT_BEAT_MORTY",
    "EVENT_BEAT_PRYCE",
    "EVENT_BEAT_RED",
    "EVENT_BEAT_RIVAL_IN_INDIGO_PLATEAU",
    "EVENT_BEAT_RIVAL_IN_MT_MOON",
    "EVENT_BEAT_ROCKET_EXECUTIVEM_3",
    "EVENT_BEAT_ROCKET_GRUNTF_5",
    "EVENT_BEAT_ROCKET_GRUNTM_28",
    "EVENT_BEAT_SABRINA",
    "EVENT_BEAT_VICTORY_ROAD_RIVAL",
    "EVENT_BEAT_WHITNEY",
    "EVENT_BOULDER_IN_BLACKTHORN_GYM_1",
    "EVENT_BOULDER_IN_BLACKTHORN_GYM_3",
    "EVENT_BOULDER_IN_ICE_PATH_1A",
    "EVENT_BOULDER_IN_ICE_PATH_2A",
    "EVENT_BOULDER_IN_ICE_PATH_3A",
    "EVENT_BOULDER_IN_ICE_PATH_4A",
    "EVENT_CLEARED_RADIO_TOWER",
    "EVENT_CLEARED_ROCKET_HIDEOUT",
    "EVENT_CLEARED_SLOWPOKE_WELL",
    "EVENT_DECIDED_TO_HELP_LANCE",
    "EVENT_GAVE_KENYA",
    "EVENT_GAVE_MYSTERY_EGG_TO_ELM",
    "EVENT_GOT_ALL_UNOWN",
    "EVENT_GOT_EON_MAIL_FROM_EUSINE",
    "EVENT_GOT_KENYA",
    "EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON",
    "EVENT_GOT_ODD_EGG",
    "EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE",
    "EVENT_HEALED_MOOMOO",
    "EVENT_HERDED_FARFETCHD",
    "EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS",
    "EVENT_JASMINE_RETURNED_TO_GYM",
    "EVENT_KURT_RETURNED_GS_BALL",
    "EVENT_LEARNED_HAIL_GIOVANNI",
    "EVENT_MET_BILL",
    "EVENT_MET_COPYCAT_FOUND_OUT_ABOUT_LOST_ITEM",
    "EVENT_MET_KURT",
    "EVENT_MET_MANAGER_AT_POWER_PLANT",
    "EVENT_MET_ROCKET_GRUNT_AT_CERULEAN_GYM",
    "EVENT_MISTY_RETURNED_TO_GYM",
    "EVENT_OBTAINED_DIPLOMA",
    "EVENT_RELEASED_THE_BEASTS",
    "EVENT_RESTORED_POWER_TO_KANTO",
    "EVENT_RIVAL_BURNED_TOWER",
    "EVENT_ROUTE_24_ROCKET",
    "EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY",
    "EVENT_SAW_SUICUNE_ON_ROUTE_36",
    "EVENT_SAW_SUICUNE_ON_ROUTE_42",
    "EVENT_TALKED_TO_MOM_AFTER_MYSTERY_EGG_QUEST",
    "EVENT_USED_THE_CARD_KEY_IN_THE_RADIO_TOWER",
    "EVENT_VIRIDIAN_GYM_BLUE"
}

HOSTED_ITEM_CODES = {
    "BLK_APRICORN",
    "BLU_APRICORN",
    "BOULDER_BADGE",
    "CASCADE_BADGE",
    "EARTH_BADGE",
    "EXPN_CARD",
    "FOG_BADGE",
    "GLACIER_BADGE",
    "GRN_APRICORN",
    "HIVE_BADGE",
    "MAP_CARD",
    "MARSH_BADGE",
    "MINERAL_BADGE",
    "PHONE_CARD",
    "PLAIN_BADGE",
    "PNK_APRICORN",
    "POKEDEX",
    "POKE_GEAR",
    "RADIO_CARD",
    "RAINBOW_BADGE",
    "RED_APRICORN",
    "RISING_BADGE",
    "SOUL_BADGE",
    "STORM_BADGE",
    "THUNDER_BADGE",
    "VOLCANO_BADGE",
    "WHT_APRICORN",
    "YLW_APRICORN",
    "ZEPHYR_BADGE"
}

function syncHostedFromBase(code)
    Tracker:FindObjectForCode(code .. "_hosted").Active = Tracker:FindObjectForCode(code).Active
end

function syncBaseFromHosted(code)
    local base = code:gsub("_hosted$", "")
    Tracker:FindObjectForCode(base).Active = Tracker:FindObjectForCode(code).Active
end
