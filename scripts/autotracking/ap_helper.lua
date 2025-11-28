function resetItems()
    for _, v in pairs(ITEM_MAPPING) do
        if v then
            local obj = Tracker:FindObjectForCode(v)
            if obj then
                if v == "BLUE_CARD_POINT" then
                    obj.AcquiredCount = 0
                else
                    obj.Active = false
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
            end
        else
            local obj = Tracker:FindObjectForCode(v)
            if obj ~= nil then
                obj.Active = false
            end
        end
    end
end

MAP_TOGGLE = {
    [0] = 0,
    [1] = 1
}
MAP_TRIPLE = {
    [0] = 0,
    [1] = 1,
    [2] = 2
}
MAP_QUADRUPLE = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3
}
MAP_QUINTUPLE = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4
}
MAP_SIXTUPLE = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5
}
MAP_TOGGLE_REVERSE = {
    [0] = 1,
    [1] = 0
}
MAP_BADGEGYM = {
    [0] = "badges",
    [1] = "gyms",
    [2] = "johtobadges"
}
MAP_KANTO_ACCESS = {
    [0] = "snorlax",
    [1] = "badges",
    [2] = "gyms",
    [3] = "champion"
}

NONE = 0
PALLET = 2
VIRIDIAN = 3
PEWTER = 4
CERULEAN = 5
ROCKTUNNEL = 6
VERMILION = 7
LAVENDER = 8
SAFFRON = 9
CELADON = 10
FUCHSIA = 11
CINNABAR = 12
NEW_BARK = 14
CHERRYGROVE = 15
VIOLET = 16
UNIONCAVE = 17
AZALEA = 18
CIANWOOD = 19
GOLDENROD = 20
OLIVINE = 21
ECRUTEAK = 22
MAHOGANY = 23
LAKE_OF_RAGE = 24
BLACKTHORN = 25
SILVER_CAVE = 26

TOWN_MAPPING = {
    [NONE] = 0,
    [NEW_BARK] = 1,
    [CHERRYGROVE] = 2,
    [VIOLET] = 3,
    [AZALEA] = 4,
    [GOLDENROD] = 5,
    [ECRUTEAK] = 6,
    [OLIVINE] = 7,
    [CIANWOOD] = 8,
    [MAHOGANY] = 9,
    [LAKE_OF_RAGE] = 10,
    [BLACKTHORN] = 11,
    [PALLET] = 12,
    [VIRIDIAN] = 13,
    [PEWTER] = 14,
    [CERULEAN] = 15,
    [VERMILION] = 16,
    [LAVENDER] = 17,
    [CELADON] = 18,
    [SAFFRON] = 19,
    [CINNABAR] = 20,
    [FUCHSIA] = 21,
    [SILVER_CAVE] = 22
}

STARTTOWN_MAPPING = {
    [NONE] = 0,
    [NEW_BARK] = 0,
    [CHERRYGROVE] = 1,
    [VIOLET] = 2,
    [UNIONCAVE] = 3,
    [AZALEA] = 4,
    [GOLDENROD] = 5,
    [ECRUTEAK] = 6,
    [OLIVINE] = 7,
    [CIANWOOD] = 8,
    [MAHOGANY] = 9,
    [LAKE_OF_RAGE] = 10,
    [BLACKTHORN] = 11,
    [PALLET] = 12,
    [VIRIDIAN] = 13,
    [PEWTER] = 14,
    [CERULEAN] = 15,
    [ROCKTUNNEL] = 16,
    [VERMILION] = 17,
    [LAVENDER] = 18,
    [CELADON] = 19,
    [SAFFRON] = 20,
    [CINNABAR] = 21,
    [FUCHSIA] = 22,
    [SILVER_CAVE] = 23
}

SLOT_CODES = {
    goal = {
        code = "goal",
        mapping = MAP_TOGGLE
    },
    randomize_badges = {
        code = "badges",
        mapping = MAP_TRIPLE
    },
    randomize_pokegear = {
        code = "pokegear",
        mapping = MAP_TOGGLE
    },
    hm_badge_requirements = {
        code = "badgereqs",
        mapping = MAP_QUADRUPLE
    },
    johto_only = {
        code = "johto_only",
        mapping = MAP_TRIPLE
    },
    free_fly_location = {
        code = "free_fly_location",
        mapping = TOWN_MAPPING
    },
    map_card_fly_location = {
        code = "map_card_fly",
        mapping = TOWN_MAPPING
    },
    randomize_berry_trees = {
        code = "berries",
        mapping = MAP_TOGGLE
    },
    remove_ilex_cut_tree = {
        code = "ilextree",
        mapping = MAP_TOGGLE
    },
    route_32_condition = {
        code = "r32_guy",
        mapping = MAP_QUINTUPLE
    },
    tea_north = {
        code = "tea_north",
        mapping = MAP_TOGGLE
    },
    tea_east = {
        code = "tea_east",
        mapping = MAP_TOGGLE
    },
    tea_south = {
        code = "tea_south",
        mapping = MAP_TOGGLE
    },
    tea_west = {
        code = "tea_west",
        mapping = MAP_TOGGLE
    },
    free_cut = {
        code = "FREE_CUT",
        mapping = MAP_TOGGLE
    },
    free_fly = {
        code = "FREE_FLY",
        mapping = MAP_TOGGLE
    },
    free_surf = {
        code = "FREE_SURF",
        mapping = MAP_TOGGLE
    },
    free_strength = {
        code = "FREE_STRENGTH",
        mapping = MAP_TOGGLE
    },
    free_flash = {
        code = "FREE_FLASH",
        mapping = MAP_TOGGLE
    },
    free_whirlpool = {
        code = "FREE_WHIRLPOOL",
        mapping = MAP_TOGGLE
    },
    free_waterfall = {
        code = "FREE_WATERFALL",
        mapping = MAP_TOGGLE
    },
    east_west_underground = {
        code = "ew_underground",
        mapping = MAP_TOGGLE
    },
    undergrounds_require_power = {
        code = "underground_power",
        mapping = MAP_QUADRUPLE
    },
    enable_mischief = {
        code = "mischief",
        mapping = MAP_TOGGLE
    },
    route_2_access = {
        code = "route_2_access",
        mapping = MAP_TRIPLE
    },
    red_gyarados_access = {
        code = "red_gyarados_access",
        mapping = MAP_TRIPLE
    },
    blackthorn_dark_cave_access = {
        code = "blackthorn_dark_cave_access",
        mapping = MAP_TOGGLE
    },
    national_park_access = {
        code = "national_park_access",
        mapping = MAP_TOGGLE
    },
    kanto_access_condition = {
        code = "kanto_access_condition",
        mapping = MAP_TRIPLE
    },
    route_3_access = {
        code = "route_3_access",
        mapping = MAP_TOGGLE
    },
    starting_town = {
        code = "start_town_location",
        mapping = STARTTOWN_MAPPING
    },
    vanilla_clair = {
        code = "clair_behaviour",
        mapping = MAP_TOGGLE
    },
    evomethod_happiness = {
        code = "evomethod_happiness",
        mapping = MAP_TOGGLE
    },
    evomethod_level = {
        code = "evomethod_level",
        mapping = MAP_TOGGLE
    },
    evomethod_tyrogue = {
        code = "evomethod_tyrogue",
        mapping = MAP_TOGGLE
    },
    evomethod_useitem = {
        code = "evomethod_useitem",
        mapping = MAP_TOGGLE
    },
    encmethod_land = {
        code = "encmethod_land",
        mapping = MAP_TRIPLE
    },
    encmethod_water = {
        code = "encmethod_water",
        mapping = MAP_TRIPLE
    },
    encmethod_fishing = {
        code = "encmethod_fishing",
        mapping = MAP_TRIPLE
    },
    encmethod_headbutt = {
        code = "encmethod_headbutt",
        mapping = MAP_TRIPLE
    },
    encmethod_rocksmash = {
        code = "encmethod_rocksmash",
        mapping = MAP_TRIPLE
    },
    static_pokemon_required = {
        code = "encmethod_static",
        mapping = MAP_TOGGLE
    },
    breeding_methods_required = {
        code = "breeding_logic",
        mapping = MAP_TRIPLE
    },
    all_pokemon_seen = {
        code = "all_pokemon_seen",
        mapping = MAP_TOGGLE
    },
    hiddenitem_logic = {
        code = "hiddenitem_logic",
        mapping = MAP_SIXTUPLE
    },
    mount_mortar_access = {
        code = "mount_mortar_access",
        mapping = MAP_TOGGLE
    },
    fly_cheese = {
        code = "fly_cheese",
        mapping = MAP_TRIPLE
    },
    randomize_pokemon_requests = {
        code = "randomize_pokemon_requests",
        mapping = MAP_QUADRUPLE
    },
    randomize_fly_unlocks = {
        code = "randomize_fly_unlocks",
        mapping = MAP_TRIPLE
    },
    shopsanity_apricorn = {
        code = "shopsanity_apricorn",
        mapping = MAP_TOGGLE
    },
    shopsanity_bluecard = {
        code = "shopsanity_bluecard",
        mapping = MAP_TOGGLE
    },
    shopsanity_gamecorners = {
        code = "shopsanity_gamecorners",
        mapping = MAP_TOGGLE
    },
    shopsanity_johtomarts = {
        code = "shopsanity_johtomarts",
        mapping = MAP_TOGGLE
    },
    shopsanity_kantomarts = {
        code = "shopsanity_kantomarts",
        mapping = MAP_TOGGLE
    },
    randomize_evolution = {
        code = "randomize_evolution",
        mapping = MAP_TRIPLE
    },
    victory_road_access = {
        code = "victory_road_access",
        mapping = MAP_TOGGLE
    },
    require_flash = {
        code = "require_flash",
        mapping = MAP_TRIPLE
    },
    lock_kanto_gyms = {
        code = "lock_kanto_gyms",
        mapping = MAP_TOGGLE
    },
    grasssanity = {
        code = "grasssanity",
        mapping = MAP_TRIPLE
    },
    route_30_battle = {
        code = "route_30_battle",
        mapping = MAP_TOGGLE
    }
}

REQUIREMENT_CODES = {
    elite_four_requirement = {
        code = "e4_requirement",
        mapping = MAP_BADGEGYM,
        item = E4_REQ
    },
    red_requirement = {
        code = "red_requirement",
        mapping = MAP_BADGEGYM,
        item = RED_REQ
    },
    radio_tower_requirement = {
        code = "tower_requirement",
        mapping = MAP_BADGEGYM,
        item = RADIO_REQ
    },
    mt_silver_requirement = {
        code = "mt_silver_requirement",
        mapping = MAP_BADGEGYM,
        item = SILVER_REQ
    },
    route_44_access_requirement = {
        code = "route_44_requirement",
        mapping = MAP_BADGEGYM,
        item = R44_REQ
    },
    kanto_access_requirement = {
        code = "kanto_access_condition",
        mapping = MAP_KANTO_ACCESS,
        item = KANTO_REQ
    }
}
AMOUNT_CODES = {
    elite_four_count = {
        code = "e4_requirement",
        item = E4_REQ
    },
    red_count = {
        code = "red_requirement",
        item = RED_REQ
    },
    radio_tower_count = {
        code = "tower_requirement",
        item = RADIO_REQ
    },
    mt_silver_count = {
        code = "mt_silver_requirement",
        item = SILVER_REQ
    },
    route_44_access_count = {
        code = "route_44_requirement",
        item = R44_REQ
    },
    kanto_access_count = {
        code = "kanto_access_count",
        item = KANTO_REQ
    }
}

LIST_CODES = {
    dark_areas = {
        mapping = MAP_TOGGLE,
        values = {
            ["Burned Tower"]         = "dark_burnedtower",
            ["Dark Cave"]            = "dark_darkcave",
            ["Digletts Cave"]        = "dark_diglettscave",
            ["Dragons Den"]          = "dark_dragonsden",
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
    }
}