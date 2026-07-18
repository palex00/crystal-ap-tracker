-- Check leaves: locations whose reachability needs MORE than reaching their region.
-- Ported from external_files/rules.py (every set_rule(get_location(...)) that resolves to a
-- real location or an event).
--
-- A leaf is a dead-end node named exactly after the AP location const, attached to the region
-- that holds it (regions.json "locations" / "events"). It is not a transition and never shows
-- in a route. Bind one from a location JSON with:
--     "access_rules": ["^$CanReach|HM01_CUT"]
-- A location whose only requirement is being in its region needs NO leaf -- point its JSON at
-- the region instead: "^$CanReach|REGION_ROUTE_35".
-- The leading ^ is required: CanReach returns an AccessibilityLevel, and a bare $rule is
-- coerced to a bool, which would silently promote Inspect/SequenceBreak to fully reachable.
--
-- Loaded AFTER connections_darkareas.lua, so the dark-area pass does not wrap these: the
-- area gate is applied on the location side in the JSON instead. See connections_darkareas.lua.
--
-- Rule style matches connections.lua: has() returns a bool and discover coerces bools, so
-- plain and/or is fine where every operand is a bool; ALL/ANY is used wherever a
-- level-returning function (phonecall, can_phone_call_power, request_pokemon) is involved,
-- because AccessibilityLevel.None == 0 is truthy in Lua.
--
-- Out of scope (deliberately no leaves): signs, statics, trainers and Pokemon, which the pack
-- places and gates through its own systems; plus rules.py's dynamic
-- RIVAL_*/Snorlax/RED_1/Battle Tower/dexsanity locations.

--- Accessibility of another region (rules.py's CanReachRegion / CanReachLocation). Reads the
--- flood-fill cache rather than calling CanReach(), which would re-enter the rebuild.
---@param region string
---@return integer
local function reach(region)
    local node = NAMED_NODES[region]
    return node and node:accessibility() or ACCESS_NONE
end

-- === REGION_AZALEA_TOWN ===
REGION_AZALEA_TOWN:connect_one_way("EVENT_BEAT_AZALEA_RIVAL", function() return has("EVENT_CLEARED_SLOWPOKE_WELL") end)
REGION_AZALEA_TOWN:connect_one_way("ITEM_FROM_RIVAL_2", function() return has("EVENT_CLEARED_SLOWPOKE_WELL") end)

-- === REGION_BLACKTHORN_GYM_2F ===
REGION_BLACKTHORN_GYM_2F:connect_one_way("EVENT_BOULDER_IN_BLACKTHORN_GYM_1", can_strength)
REGION_BLACKTHORN_GYM_2F:connect_one_way("EVENT_BOULDER_IN_BLACKTHORN_GYM_3", can_strength)

-- === REGION_BURNED_TOWER_1F ===
REGION_BURNED_TOWER_1F:connect_one_way("BURNED_TOWER_1F_HP_UP", can_rock_smash)

-- === REGION_BURNED_TOWER_B1F ===
REGION_BURNED_TOWER_B1F:connect_one_way("BURNED_TOWER_B1F_TM_ENDURE", can_strength)

-- === REGION_CELADON_MANSION_3F ===
REGION_CELADON_MANSION_3F:connect_one_way("EVENT_OBTAINED_DIPLOMA", diplomagoal)

-- === REGION_CHARCOAL_KILN ===
REGION_CHARCOAL_KILN:connect_one_way("CHARCOAL_IN_CHARCOAL_KILN", function() return has("EVENT_HERDED_FARFETCHD") end)

-- === REGION_CHERRYGROVE_CITY ===
REGION_CHERRYGROVE_CITY:connect_one_way("EVENT_BEAT_CHERRYGROVE_RIVAL", function() return has("EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON") end)
REGION_CHERRYGROVE_CITY:connect_one_way("ITEM_FROM_RIVAL_1", function() return has("EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON") end)
REGION_CHERRYGROVE_CITY:connect_one_way("MYSTIC_WATER_IN_CHERRYGROVE", can_surf_johto)

-- === REGION_CIANWOOD_CITY ===
REGION_CIANWOOD_CITY:connect_one_way("CIANWOOD_CITY_HIDDEN_MAX_ETHER", can_rock_smash)
REGION_CIANWOOD_CITY:connect_one_way("CIANWOOD_CITY_HIDDEN_REVIVE", can_rock_smash)
REGION_CIANWOOD_CITY:connect_one_way("EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY", function() return has("EVENT_RELEASED_THE_BEASTS") end)
REGION_CIANWOOD_CITY:connect_one_way("HM02_FLY", function() return has("EVENT_BEAT_CHUCK") end)
REGION_CIANWOOD_CITY:connect_one_way("ITEM_FROM_MYSTICALMAN_EUSINE", function() return has("EVENT_RELEASED_THE_BEASTS") end)

-- === REGION_CIANWOOD_PHARMACY ===
REGION_CIANWOOD_PHARMACY:connect_one_way("SECRETPOTION_FROM_PHARMACY", function() return not has("vanilla_chain_jasmine_on")
        or has("EVENT_JASMINE_EXPLAINED_AMPHYS_SICKNESS") end)

-- === REGION_COPYCATS_HOUSE_2F ===
REGION_COPYCATS_HOUSE_2F:connect_one_way("PASS_FROM_COPYCAT", function() return has("LOST_ITEM") end)

-- === REGION_ELMS_LAB ===
REGION_ELMS_LAB:connect_one_way("EVENT_GAVE_MYSTERY_EGG_TO_ELM", function() return has("MYSTERY_EGG") end)
REGION_ELMS_LAB:connect_one_way("EVERSTONE_FROM_ELM", function() return has("EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE") end)
REGION_ELMS_LAB:connect_one_way("MASTER_BALL_FROM_ELM", function() return has("RISING_BADGE") end)
REGION_ELMS_LAB:connect_one_way("POKE_BALL_FROM_ELMS_AIDE", function() return has("MYSTERY_EGG") end)
REGION_ELMS_LAB:connect_one_way("SS_TICKET_FROM_ELM", function() return has("EVENT_BEAT_ELITE_FOUR") end)

-- === REGION_GOLDENROD_FLOWER_SHOP ===
REGION_GOLDENROD_FLOWER_SHOP:connect_one_way("SQUIRTBOTTLE", function() return has("PLAIN_BADGE") end)

-- === REGION_GOLDENROD_POKECENTER_1F ===
REGION_GOLDENROD_POKECENTER_1F:connect_one_way("GS_BALL_FROM_GOLDENROD_POKEMON_CENTER", function() return has("EVENT_BEAT_ELITE_FOUR") end)
REGION_GOLDENROD_POKECENTER_1F:connect_one_way("REVIVE_FROM_GOLDENROD_POKEMON_CENTER", function() return has("EVENT_GOT_EON_MAIL_FROM_EUSINE") end)

-- === REGION_ICE_PATH_B1F:NORTH ===
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_one_way("EVENT_BOULDER_IN_ICE_PATH_1A", can_strength)
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_one_way("EVENT_BOULDER_IN_ICE_PATH_2A", can_strength)

-- === REGION_ICE_PATH_B1F:NORTH:STRENGTH ===
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH:STRENGTH"]:connect_one_way("EVENT_BOULDER_IN_ICE_PATH_3A", can_strength)
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH:STRENGTH"]:connect_one_way("EVENT_BOULDER_IN_ICE_PATH_4A", can_strength)

-- === REGION_ILEX_FOREST:NORTH ===
NAMED_NODES["REGION_ILEX_FOREST:NORTH"]:connect_one_way("EVENT_HERDED_FARFETCHD", function() return has("EVENT_CLEARED_SLOWPOKE_WELL") end)

-- === REGION_ILEX_FOREST:SOUTH ===
NAMED_NODES["REGION_ILEX_FOREST:SOUTH"]:connect_one_way("HM01_CUT", function() return has("EVENT_HERDED_FARFETCHD") end)

-- === REGION_KURTS_HOUSE ===
REGION_KURTS_HOUSE:connect_one_way("KURT_GAVE_YOU_LURE_BALL", function() return has("EVENT_CLEARED_SLOWPOKE_WELL") end)

-- === REGION_LAKE_OF_RAGE ===
REGION_LAKE_OF_RAGE:connect_one_way("EVENT_DECIDED_TO_HELP_LANCE", function() return reach("REGION_LAKE_OF_RAGE:GYARADOS") end)

-- === REGION_LAKE_OF_RAGE_MAGIKARP_HOUSE ===
REGION_LAKE_OF_RAGE_MAGIKARP_HOUSE:connect_one_way("LAKE_OF_RAGE_MAGIKARP_PRIZE", function()
        return has("EVENT_CLEARED_ROCKET_HIDEOUT") and has_pokedex()
    end)

-- === REGION_LAV_RADIO_TOWER_1F ===
REGION_LAV_RADIO_TOWER_1F:connect_one_way("EVENT_GOT_EXPN_CARD", function() return has("EVENT_RESTORED_POWER_TO_KANTO") end)
REGION_LAV_RADIO_TOWER_1F:connect_one_way("EXPN_CARD", function() return has("EVENT_RESTORED_POWER_TO_KANTO") end)

-- === REGION_MOUNT_MOON_SQUARE ===
REGION_MOUNT_MOON_SQUARE:connect_one_way("MOUNT_MOON_SQUARE_HIDDEN_MOON_STONE", can_rock_smash)

-- === REGION_MR_POKEMONS_HOUSE ===
REGION_MR_POKEMONS_HOUSE:connect_one_way("EXP_SHARE", function() return has("RED_SCALE") end)

-- === REGION_NATIONAL_PARK ===
REGION_NATIONAL_PARK:connect_one_way("NUGGET_FROM_BEVERLY", function() return ALL(phonecall, request_pokemon, has_pokedex) end)

-- === REGION_OLIVINE_LIGHTHOUSE_6F ===
REGION_OLIVINE_LIGHTHOUSE_6F:connect_one_way("EVENT_JASMINE_RETURNED_TO_GYM", function() return has("SECRETPOTION") end)

-- === REGION_OLIVINE_PORT:TICKET ===
NAMED_NODES["REGION_OLIVINE_PORT:TICKET"]:connect_one_way("OLIVINE_PORT_HIDDEN_PROTEIN", can_surf_johto)

-- === REGION_POKEMON_FAN_CLUB ===
REGION_POKEMON_FAN_CLUB:connect_one_way("LOST_ITEM_FROM_FAN_CLUB", function()
        return has("EVENT_RESTORED_POWER_TO_KANTO")
           and (not has("vanilla_chain_copycat_on")
                or has("EVENT_MET_COPYCAT_FOUND_OUT_ABOUT_LOST_ITEM"))
    end)

-- === REGION_POWER_PLANT ===
REGION_POWER_PLANT:connect_one_way("EVENT_RESTORED_POWER_TO_KANTO", function() return has("MACHINE_PART") end)
REGION_POWER_PLANT:connect_one_way("TM07_ZAP_CANNON", function() return has("EVENT_RESTORED_POWER_TO_KANTO") end)

-- === REGION_RADIO_TOWER_3F ===
REGION_RADIO_TOWER_3F:connect_one_way("EVENT_USED_THE_CARD_KEY_IN_THE_RADIO_TOWER", function() return has("CARD_KEY") end)
REGION_RADIO_TOWER_3F:connect_one_way("SUNNY_DAY_FROM_RADIO_TOWER", function() return has("EVENT_CLEARED_RADIO_TOWER") end)

-- === REGION_RADIO_TOWER_4F:EAST ===
NAMED_NODES["REGION_RADIO_TOWER_4F:EAST"]:connect_one_way("PINK_BOW_FROM_MARY", function() return has("EVENT_CLEARED_RADIO_TOWER") end)

-- === REGION_ROUTE_12:NORTH ===
NAMED_NODES["REGION_ROUTE_12:NORTH"]:connect_one_way("ROUTE_12_HIDDEN_ELIXER", can_surf_kanto)

-- === REGION_ROUTE_12:SOUTH ===
NAMED_NODES["REGION_ROUTE_12:SOUTH"]:connect_one_way("ROUTE_12_CALCIUM", can_cut_kanto)
NAMED_NODES["REGION_ROUTE_12:SOUTH"]:connect_one_way("ROUTE_12_NUGGET", function() return can_cut_kanto() and can_surf_kanto() end)

-- === REGION_ROUTE_15 ===
REGION_ROUTE_15:connect_one_way("ROUTE_15_PP_UP", can_cut_kanto)

-- === REGION_ROUTE_24:ROCKET ===
NAMED_NODES["REGION_ROUTE_24:ROCKET"]:connect_one_way("ITEM_FROM_ROCKET_GRUNTM_31", function() return has("EVENT_MET_MANAGER_AT_POWER_PLANT") end)

-- === REGION_ROUTE_25 ===
REGION_ROUTE_25:connect_one_way("ROUTE_25_PROTEIN", can_cut_kanto)

-- === REGION_ROUTE_27:EASTWHIRLPOOL ===
NAMED_NODES["REGION_ROUTE_27:EASTWHIRLPOOL"]:connect_one_way("STAR_PIECE_FROM_BIRD_KEEPER_JOSE", phonecall)

-- === REGION_ROUTE_27:WESTWATER ===
NAMED_NODES["REGION_ROUTE_27:WESTWATER"]:connect_one_way("ROUTE_27_RARE_CANDY", can_surf_johto)

-- === REGION_ROUTE_29 ===
REGION_ROUTE_29:connect_one_way("PINK_BOW_FROM_TUSCANY", function() return has("ZEPHYR_BADGE") end)

-- === REGION_ROUTE_30:POST_MYSTERY_EGG ===
NAMED_NODES["REGION_ROUTE_30:POST_MYSTERY_EGG"]:connect_one_way("HP_UP_FROM_JOEY", function() return ALL(phonecall, function() return has("EVENT_BEAT_ELITE_FOUR") end) end)

-- === REGION_ROUTE_31 ===
REGION_ROUTE_31:connect_one_way("BERRY_FROM_BUG_CATCHER_WADE", phonecall)
REGION_ROUTE_31:connect_one_way("EVENT_GAVE_KENYA", function() return has("EVENT_GOT_KENYA") end)
REGION_ROUTE_31:connect_one_way("TM50_NIGHTMARE", function() return has("EVENT_GOT_KENYA") end)

-- === REGION_ROUTE_32:MIRACLE_SEED ===
NAMED_NODES["REGION_ROUTE_32:MIRACLE_SEED"]:connect_one_way("MIRACLE_SEED_IN_ROUTE_32", function() return has("ZEPHYR_BADGE") end)

-- === REGION_ROUTE_32:SOUTH ===
NAMED_NODES["REGION_ROUTE_32:SOUTH"]:connect_one_way("TM05_ROAR", can_cut_johto)

-- === REGION_ROUTE_34 ===
REGION_ROUTE_34:connect_one_way("LEAF_STONE_FROM_GINA", phonecall)

-- === REGION_ROUTE_35_GOLDENROD_GATE ===
REGION_ROUTE_35_GOLDENROD_GATE:connect_one_way("HP_UP_FROM_RANDY", function() return has("EVENT_GAVE_KENYA") end)

-- === REGION_ROUTE_36:EAST ===
NAMED_NODES["REGION_ROUTE_36:EAST"]:connect_one_way("TM08_ROCK_SMASH", function() return has("SQUIRTBOTTLE") end)

-- === REGION_ROUTE_36:WEST ===
NAMED_NODES["REGION_ROUTE_36:WEST"]:connect_one_way("EVENT_SAW_SUICUNE_ON_ROUTE_36", function() return has("EVENT_RELEASED_THE_BEASTS") end)
NAMED_NODES["REGION_ROUTE_36:WEST"]:connect_one_way("FIRE_STONE_FROM_ALAN", phonecall)

-- === REGION_ROUTE_38 ===
REGION_ROUTE_38:connect_one_way("THUNDERSTONE_FROM_DANA", phonecall)

-- === REGION_ROUTE_39 ===
REGION_ROUTE_39:connect_one_way("NUGGET_FROM_DEREK", function() return ALL(phonecall, request_pokemon, has_pokedex) end)

-- === REGION_ROUTE_39_FARMHOUSE ===
REGION_ROUTE_39_FARMHOUSE:connect_one_way("MOOMOO_MILK_FROM_MOOMOO_FARM", function() return has("EVENT_HEALED_MOOMOO") end)
REGION_ROUTE_39_FARMHOUSE:connect_one_way("TM13_SNORE_FROM_MOOMOO_FARM", function() return has("EVENT_HEALED_MOOMOO") end)

-- === REGION_ROUTE_40 ===
REGION_ROUTE_40:connect_one_way("ROUTE_40_HIDDEN_HYPER_POTION", can_rock_smash)

-- === REGION_ROUTE_42:CENTERFRUIT ===
NAMED_NODES["REGION_ROUTE_42:CENTERFRUIT"]:connect_one_way("EVENT_SAW_SUICUNE_ON_ROUTE_42", function() return has("EVENT_RELEASED_THE_BEASTS") end)

-- === REGION_ROUTE_42:EAST ===
NAMED_NODES["REGION_ROUTE_42:EAST"]:connect_one_way("WATER_STONE_FROM_TULLY", phonecall)

-- === REGION_ROUTE_42:WEST ===
NAMED_NODES["REGION_ROUTE_42:WEST"]:connect_one_way("ROUTE_42_HIDDEN_MAX_POTION", can_surf_johto)

-- === REGION_ROUTE_43 ===
REGION_ROUTE_43:connect_one_way("PINK_BOW_FROM_TIFFANY", function() return ALL(phonecall, request_pokemon, has_pokedex) end)

-- === REGION_ROUTE_43_GATE ===
REGION_ROUTE_43_GATE:connect_one_way("TM36_SLUDGE_BOMB", function() return has("EVENT_CLEARED_ROCKET_HIDEOUT") end)

-- === REGION_ROUTE_44 ===
REGION_ROUTE_44:connect_one_way("POKE_BALL_FROM_WILTON", phonecall)

-- === REGION_ROUTE_44:POWER ===
NAMED_NODES["REGION_ROUTE_44:POWER"]:connect_one_way("CARBOS_FROM_VANCE", can_phone_call_power)

-- === REGION_ROUTE_45 ===
REGION_ROUTE_45:connect_one_way("PP_UP_FROM_KENJI", phonecall)
REGION_ROUTE_45:connect_one_way("ROUTE_45_HIDDEN_PP_UP", can_surf_johto)

-- === REGION_ROUTE_45:POWER ===
NAMED_NODES["REGION_ROUTE_45:POWER"]:connect_one_way("IRON_FROM_PARRY", can_phone_call_power)

-- === REGION_ROUTE_46:POWER ===
NAMED_NODES["REGION_ROUTE_46:POWER"]:connect_one_way("CALCIUM_FROM_ERIN", can_phone_call_power)

-- === REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER ===
REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER:connect_one_way("ENGINE_UNLOCKED_UNOWNS_S_TO_W", function() return has("AERODACTYL_TILE", 16) end)

-- === REGION_RUINS_OF_ALPH_HO_OH_CHAMBER ===
REGION_RUINS_OF_ALPH_HO_OH_CHAMBER:connect_one_way("ENGINE_UNLOCKED_UNOWNS_X_TO_Z", function() return has("HO-OH_TILE", 16) end)

-- === REGION_RUINS_OF_ALPH_KABUTO_CHAMBER ===
REGION_RUINS_OF_ALPH_KABUTO_CHAMBER:connect_one_way("ENGINE_UNLOCKED_UNOWNS_A_TO_K", function() return has("KABUTO_TILE", 16) end)

-- === REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER ===
REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER:connect_one_way("ENGINE_UNLOCKED_UNOWNS_L_TO_R", function() return has("OMANYTE_TILE", 16) end)

-- === REGION_RUINS_OF_ALPH_RESEARCH_CENTER ===
REGION_RUINS_OF_ALPH_RESEARCH_CENTER:connect_one_way("EVENT_GOT_ALL_UNOWN", unown_goal)

-- === REGION_SILVER_CAVE_ROOM_3 ===
REGION_SILVER_CAVE_ROOM_3:connect_one_way("EVENT_BEAT_RED", function() return has("red_requirement") end)

-- === REGION_TIN_TOWER_1F ===
REGION_TIN_TOWER_1F:connect_one_way("EVENT_GOT_EON_MAIL_FROM_EUSINE", function()
        return has("EVENT_SAW_SUICUNE_ON_ROUTE_36") and has("EVENT_SAW_SUICUNE_ON_ROUTE_42")
           and has("EVENT_SAW_SUICUNE_AT_CIANWOOD_CITY")
    end)
REGION_TIN_TOWER_1F:connect_one_way("TIN_TOWER_1F_RAINBOW_WING", function() return has("EVENT_BEAT_ELITE_FOUR") end)

-- === REGION_TIN_TOWER_ROOF ===
REGION_TIN_TOWER_ROOF:connect_one_way("EVENT_FOUGHT_HO_OH", function() return has("RAINBOW_WING") end)

-- === REGION_TOHJO_FALLS:WEST ===
NAMED_NODES["REGION_TOHJO_FALLS:WEST"]:connect_one_way("TOHJO_FALLS_MOON_STONE", can_surf_johto)

-- === REGION_VERMILION_CITY ===
REGION_VERMILION_CITY:connect_one_way("EVENT_FOUGHT_SNORLAX", clear_snorlax)
REGION_VERMILION_CITY:connect_one_way("HP_UP_FROM_VERMILION_GUY", function() return kantobadges() >= 8 end)

-- === REGION_VERMILION_PORT:TICKET ===
NAMED_NODES["REGION_VERMILION_PORT:TICKET"]:connect_one_way("VERMILION_PORT_HIDDEN_IRON", can_surf_kanto)

-- === REGION_VICTORY_ROAD_GATE ===
REGION_VICTORY_ROAD_GATE:connect_one_way("EVENT_OPENED_MT_SILVER", function() return has("mt_silver_requirement") end)

-- === REGION_VIOLET_CITY ===
REGION_VIOLET_CITY:connect_one_way("VIOLET_CITY_HIDDEN_HYPER_POTION", can_cut_johto)
REGION_VIOLET_CITY:connect_one_way("VIOLET_CITY_PP_UP", can_surf_johto)
REGION_VIOLET_CITY:connect_one_way("VIOLET_CITY_RARE_CANDY", can_surf_johto)

-- === REGION_VIOLET_POKECENTER_1F ===
REGION_VIOLET_POKECENTER_1F:connect_one_way("EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE", function() return has("EVENT_BEAT_FALKNER") end)

-- === REGION_VIRIDIAN_CITY ===
REGION_VIRIDIAN_CITY:connect_one_way("TM42_DREAM_EATER", function() return can_surf_kanto() or can_cut_kanto() end)

-- === REGION_WHIRL_ISLAND_LUGIA_CHAMBER:WATER ===
NAMED_NODES["REGION_WHIRL_ISLAND_LUGIA_CHAMBER:WATER"]:connect_one_way("EVENT_FOUGHT_LUGIA", function() return has("SILVER_WING") end)

