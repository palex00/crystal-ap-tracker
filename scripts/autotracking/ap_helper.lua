function resetItems()
    for _, v in pairs(ITEM_MAPPING) do
        if v then
            if v == "PROGRESSIVE_ROD" then
                -- ignore
            else
                local obj = Tracker:FindObjectForCode(v)
                if obj then
                    if v == "BLUE_CARD_POINT" or v == "AERODACTYL_TILE" or v == "HO-OH_TILE" or v == "KABUTO_TILE" or v == "OMANYTE_TILE" or v == "BATTLE_TOWER_TIER_UNLOCK" then
                        obj.AcquiredCount = 0
                    else
                        obj.Active = false
                    end
                end
            end
        end
    end
end

function resetLocations()
    for _, v in pairs(LOCATION_MAPPING) do
        if v and (v:sub(1, 2) == "@J" or v:sub(1, 2) == "@Z") then -- this checks it's not a Dexsanity Location
            local obj = Tracker:FindObjectForCode(v)
            if obj ~= nil then
                obj.AvailableChestCount = obj.ChestCount
                obj.Highlight = HIGHLIGHT_LEVEL[40]
            end
        else
            local obj = Tracker:FindObjectForCode(v)
            if obj ~= nil then
                obj.Active = false
            end
        end
    end
    
    for _, v in pairs(SIGN_MAPPING) do
        if v then
            local obj = Tracker:FindObjectForCode(v)
            if obj ~= nil then
                obj.AvailableChestCount = obj.ChestCount
            end
        end
    end
end

function resetTrainers()
    -- this resets trainer visibility. It will cause some "cannot find object"-errors
    -- but I am not willing to make yet another list that is just a list.
    for i = 1039, 1522 do
        local obj = Tracker:FindObjectForCode("trainersanity_" .. i)
        if obj then
            obj.Active = false
        end
    end
    for i = 296, 302 do
        local obj = Tracker:FindObjectForCode("trainersanity_" .. i)
        obj.Active = false
    end
    Tracker:FindObjectForCode("trainersanity_1702").Active = false -- literally just Eusine the fucker.
    Tracker:FindObjectForCode("trainersanity_344").Active = false -- literally just Cal the fucker.
end

MAP_BADGEGYM = {
    [0] = "badges",
    [1] = "gyms",
    [2] = "johtobadges"
}
MAP_ROUTE_22_ACCESS = {
    [0] = "snorlax",
    [1] = "badges",
    [2] = "gyms",
    [3] = "champion"
}

FLYTOWN_MAPPING = {
    [0]  = 0,   -- No Free Fly Location
    [1]  = 1,   -- New Bark Town
    [2]  = 2,   -- Cherrygrove City
    [3]  = 3,   -- Violet City
    [4]  = 4,   -- Azalea Town
    [5]  = 5,   -- Goldenrod City
    [6]  = 6,   -- Ecruteak City
    [7]  = 7,   -- Olivine City
    [8]  = 8,   -- Cianwood City
    [9]  = 9,   -- Mahogany Town
    [10] = 10,  -- Lake of Rage
    [11] = 11,  -- Blackthorn City
    [12] = 12,  -- Silver Cave
    [13] = 13,  -- Pallet Town
    [14] = 14,  -- Viridian City
    [15] = 15,  -- Pewter City
    [16] = 16,  -- Cerulean City
    [17] = 17,  -- Vermilion City
    [18] = 18,  -- Lavender Town
    [19] = 19,  -- Celadon City
    [20] = 20,  -- Saffron City
    [21] = 21,  -- Cinnabar Island
    [22] = 22,  -- Fuchsia City
    [23] = 23   -- Indigo Plateau
}

STARTTOWN_MAPPING = {
    [0]   = 0,   -- None (no dedicated stage; falls back to New Bark Town)
    [37]  = 0,   -- New Bark Town
    [38]  = 1,   -- Cherrygrove City
    [39]  = 2,   -- Violet City
    [40]  = 3,   -- Union Cave
    [41]  = 4,   -- Azalea Town
    [42]  = 5,   -- Goldenrod City
    [43]  = 6,   -- Ecruteak City
    [44]  = 7,   -- Olivine City
    [45]  = 8,   -- Cianwood City
    [46]  = 9,   -- Mahogany Town
    [47]  = 10,  -- Lake of Rage
    [48]  = 11,  -- Blackthorn City
    [25]  = 12,  -- Pallet Town
    [26]  = 13,  -- Viridian City
    [27]  = 14,  -- Pewter City
    [28]  = 15,  -- Cerulean City
    [29]  = 16,  -- Rock Tunnel
    [30]  = 17,  -- Vermilion City
    [31]  = 18,  -- Lavender Town
    [32]  = 19,  -- Celadon City
    [33]  = 20,  -- Saffron City
    [34]  = 21,  -- Cinnabar Island
    [35]  = 22   -- Fuchsia City
}

SLOT_CODES = {
    enable_mischief = {code = "mischief"},
    randomize_badges = {code = "badges"},
    randomize_pokegear = {code = "pokegear"},
    hm_badge_requirements = {code = "badgereqs"},
    johto_only = {code = "johto_only"},
    free_fly_location = {code = "free_fly_location", mapping = FLYTOWN_MAPPING},
    map_card_fly_location = {code = "map_card_fly", mapping = FLYTOWN_MAPPING},
    randomize_berry_trees = {code = "berries"},
    remove_ilex_cut_tree = {code = "ilextree"},
    route_32_condition = {code = "r32_guy"},
    tea_north = {code = "tea_north"},
    tea_east = {code = "tea_east"},
    tea_south = {code = "tea_south"},
    tea_west = {code = "tea_west"},
    east_west_underground = {code = "ew_underground"},
    undergrounds_require_power = {code = "underground_power"},
    route_2_access = {code = "route_2_access"},
    red_gyarados_access = {code = "red_gyarados_access"},
    blackthorn_dark_cave_access = {code = "blackthorn_dark_cave_access"},
    national_park_access = {code = "national_park_access"},
    route_3_access = {code = "route_3_access"},
    starting_town = {code = "start_town_location", mapping = STARTTOWN_MAPPING},
    time_of_day_encounters = {code = "timeofday"},
    unlockable_time_of_day = {code = "unlockable_tod"},
    static_pokemon_required = {code = "encmethod_static"},
    breeding_method = {code = "breeding_logic"},
    all_pokemon_seen = {code = "all_pokemon_seen"},
    hiddenitem_logic = {code = "hiddenitem_logic"},
    mount_mortar_access = {code = "mount_mortar_access"},
    randomize_pokemon_requests = {code = "randomize_pokemon_requests"},
    randomize_fly_unlocks = {code = "randomize_fly_unlocks"},
    randomize_fly_destinations = {code = "randomize_fly_destinations"},
    randomize_evolution = {code = "randomize_evolution"},
    victory_road_strength = {code = "victory_road_strength"},
    require_flash = {code = "require_flash"},
    lock_kanto_gyms = {code = "lock_kanto_gyms"},
    grasssanity = {code = "grasssanity"},
    route_30_battle = {code = "route_30_battle"},
    ss_aqua_access = {code = "ss_aqua_access"},
    magnet_train_access = {code = "magnet_train_access"},
    randomize_bug_catching_contest = {code = "randomize_bug_catching_contest"},
    trades_required = {code = "encmethod_trades"},
    require_pokegear_for_phone_numbers = {code = "require_pokegear_for_phone_numbers"},
    route_42_access = {code = "route_42_access"},
    randomize_phone_call_items = {code = "randomize_phone_call_items"},
    phone_call_mode = {code = "phone_call_mode"},
    rematchsanity = {code = "randomize_rematches"},
    route_12_access = {code = "route_12_access"},
    route_30_access = {code = "route_30_access"},
    randomize_pokedex = {code = "randomize_pokedex"},
    south_kanto_access = {code = "south_kanto_access"},
    south_kanto_condition = {code = "south_kanto_condition"},
    route_23_restored = {code = "route_23_restored"},
    lance_requires_elite_four = {code = "lance_requires_elite_four"},
    flooded_mine = {code = "flooded_mine"},
    momsanity = {code = "momsanity"},
    coupled_entrances = {code = "coupled_entrances"},
    battle_tower_sanity = {code = "battle_tower_sanity"},
    battle_tower_progressive_tier_unlocks = {code = "battle_tower_progressive_tier_unlocks"},
    randomize_lucky_number_show = {code = "luckynumbershow"}
}

REQUIREMENT_CODES = {
    victory_road_requirement = {code = "vr_requirement",
        mapping = MAP_BADGEGYM,
        item = VR_REQ
    },
    elite_four_requirement = {code = "e4_requirement",
        mapping = MAP_BADGEGYM,
        item = E4_REQ
    },
    red_requirement = {code = "red_requirement",
        mapping = MAP_BADGEGYM,
        item = RED_REQ
    },
    radio_tower_requirement = {code = "tower_requirement",
        mapping = MAP_BADGEGYM,
        item = RADIO_REQ
    },
    mt_silver_requirement = {code = "mt_silver_requirement",
        mapping = MAP_BADGEGYM,
        item = SILVER_REQ
    },
    route_44_access_requirement = {code = "route_44_requirement",
        mapping = MAP_BADGEGYM,
        item = R44_REQ
    },
    route_22_access_requirement = {code = "route_22_access",
        mapping = MAP_ROUTE_22_ACCESS,
        item = ROUTE_22_REQ
    }
}
AMOUNT_CODES = {
    victory_road_count = {code = "vr_requirement",
        item = VR_REQ
    },
    elite_four_count = {code = "e4_requirement",
        item = E4_REQ
    },
    red_count = {code = "red_requirement",
        item = RED_REQ
    },
    radio_tower_count = {code = "tower_requirement",
        item = RADIO_REQ
    },
    mt_silver_count = {code = "mt_silver_requirement",
        item = SILVER_REQ
    },
    route_44_access_count = {code = "route_44_requirement",
        item = R44_REQ
    },
    route_22_access_count = {code = "route_22_access_count",
        item = ROUTE_22_REQ
    }
}

LIST_CODES = {
    goal = {
        mapping = MAP_TOGGLE,
        values = {
            ["Elite Four"]         = "goal_e4",
            ["Red"]                = "goal_red",
            ["Diploma"]            = "goal_diploma",
            ["Rival"]              = "goal_rival",
            ["Defeat Team Rocket"] = "goal_rocket",
            ["Unown Hunt"]         = "goal_unown",
            ["Battle Tower"]       = "goal_battletower",
        }
    },
    -- ER categories actually in the shuffle pool. The apworld's RandomizeEntrances OptionSet
    -- sends the display names below; anything absent stays off (its entrances are vanilla and
    -- get no tracker item). Setting er_<cat> fires the init.lua watch -> refreshERCategories()
    -- -> createEntrancesForEnabled(). Keys must match options.py RandomizeEntrances exactly.
    randomize_entrances = {
        mapping = MAP_TOGGLE,
        values = {
            ["Dungeon"]           = "er_dungeon",
            ["Dungeon Interior"]  = "er_dungeon_interior",
            ["Gym"]               = "er_gym",
            ["Gym Interior"]      = "er_gym_interior",
            ["Mart"]              = "er_mart",
            ["Mart Interior"]     = "er_mart_interior",
            ["Building"]          = "er_building",
            ["Building Interior"] = "er_building_interior",
            ["Gate"]              = "er_gate",
            ["Pokecenter"]        = "er_pokecenter",
            ["Elevator"]          = "er_elevator",
            ["Pokemon League"]    = "er_pokemon_league",
            ["One-Way"]           = "er_one_way",
        }
    },
    dark_areas = {
        mapping = MAP_TOGGLE,
        values = {
            ["Burned Tower"]         = "dark_burnedtower",
            ["Dark Cave"]            = "dark_darkcave",
            ["Digletts Cave"]        = "dark_diglettscave",
            ["Dragons Den"]          = "dark_dragonsden",
            ["Flooded Mine"]         = "dark_floodedmine",
            ["Goldenrod Underground"]= "dark_goldenrodunderground",
            ["Ice Path"]             = "dark_icepath",
            ["Ilex Forest"]          = "dark_ilexforest",
            ["Mount Moon"]           = "dark_mountmoon",
            ["Mount Mortar"]         = "dark_mountmortar",
            ["Olivine Lighthouse"]   = "dark_olivinelighthouse",
            ["Rock Tunnel"]          = "dark_rocktunnel",
            ["Silver Cave"]          = "dark_silvercave",
            ["Slowpoke Well"]        = "dark_slowpokewell",
            ["Tohjo Falls"]          = "dark_tohjofalls",
            ["Union Cave"]           = "dark_unioncave",
            ["Victory Road"]         = "dark_victoryroad",
            ["Whirl Islands"]        = "dark_whirlislands",
        }
    },
    vanilla_event_chains = {
        mapping = MAP_TOGGLE,
        values = {
            ["Misty"]               = "vanilla_chain_misty",
            ["Clair"]               = "clair_behaviour",
            ["Jasmine"]             = "vanilla_chain_jasmine",
            ["Copycat"]             = "vanilla_chain_copycat",
        }
    },
    remove_badge_requirement = {
        mapping = MAP_TOGGLE,
        values = {
            ["Cut"]                 = "FREE_CUT",
            ["Fly"]                 = "FREE_FLY",
            ["Surf"]                = "FREE_SURF",
            ["Strength"]            = "FREE_STRENGTH",
            ["Flash"]               = "FREE_FLASH",
            ["Whirlpool"]           = "FREE_WHIRLPOOL",
            ["Waterfall"]           = "FREE_WATERFALL",
        }
    },
    shopsanity = {
        mapping = MAP_TOGGLE,
        values = {
            ["Johto Marts"]         = "shopsanity_johtomarts",
            ["Kanto Marts"]         = "shopsanity_kantomarts",
            ["Blue Card"]           = "shopsanity_bluecard",
            ["Game Corners"]        = "shopsanity_gamecorners",
            ["Apricorns"]           = "shopsanity_apricorn",
        }
    },
    evolution_methods_required = {
        mapping = MAP_TOGGLE,
        values = {
            ["Level"]          = "evomethod_level",
            ["Level and Stat"] = "evomethod_tyrogue",
            ["Use Item"]       = "evomethod_useitem",
            ["Held Item"]      = "evomethod_helditem",
            ["Happiness"]      = "evomethod_happiness",
        }
    },
    wild_encounter_methods_required = {
        mapping = MAP_TOGGLE,
        values = {
            ["Land"]                 = "encmethod_land",
            ["Surfing"]              = "encmethod_water",
            ["Fishing"]              = "encmethod_fishing",
            ["Headbutt"]             = "encmethod_headbutt",
            ["Rock Smash"]           = "encmethod_rocksmash",
            ["Swarm"]                = "encmethod_swarm",
            ["Bug Catching Contest"] = "encmethod_contest",
        }
    }
}
