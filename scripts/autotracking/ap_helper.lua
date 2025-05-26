function resetItems()
    for _, v in pairs(ITEM_MAPPING) do
        if v then
            local obj = Tracker:FindObjectForCode(v)
            if obj then
                obj.Active = false
            end
        end
    end
end

function resetLocations()
    for _, v in pairs(LOCATION_MAPPING) do
        if v and v:sub(1, 2) == "@J" then -- this checks it's not a Dexsanity Location
            local obj = Tracker:FindObjectForCode(v)
            if obj ~= nil then
                obj.AvailableChestCount = 1
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
MAP_TOGGLE_REVERSE = {
    [0] = 1,
    [1] = 0
}
MAP_16 = {
    [0] = 0,
    [1] = 1,
    [2] = 2,
    [3] = 3,
    [4] = 4,
    [5] = 5,
    [6] = 6,
    [7] = 7,
    [8] = 8,
    [9] = 9,
    [10] = 10,
    [11] = 11,
    [12] = 12,
    [13] = 13,
    [14] = 14,
    [15] = 15,
    [16] = 16
}

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
    [NEW_BARK] = 0,
    [CHERRYGROVE] = 1,
    [VIOLET] = 2,
    [AZALEA] = 3,
    [GOLDENROD] = 4,
    [ECRUTEAK] = 5,
    [OLIVINE] = 6,
    [CIANWOOD] = 7,
    [MAHOGANY] = 8,
    [LAKE_OF_RAGE] = 9,
    [BLACKTHORN] = 10,
    [PALLET] = 11,
    [VIRIDIAN] = 12,
    [PEWTER] = 13,
    [CERULEAN] = 14,
    [VERMILION] = 15,
    [LAVENDER] = 16,
    [CELADON] = 17,
    [SAFFRON] = 18,
    [CINNABAR] = 19,
    [FUCHSIA] = 20,
    [SILVER_CAVE] = 21
}

STARTTOWN_MAPPING = {
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
    randomize_hidden_items = {
        code = "hiddenitems",
        mapping = MAP_TOGGLE
    },
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
    trainersanity = {
        code = "trainersanity",
        mapping = MAP_TOGGLE
    },
    hm_badge_requirements = {
        code = "badgereqs",
        mapping = MAP_TRIPLE
    },
    require_itemfinder = {
        code = "reqitemfinder",
        mapping = MAP_TRIPLE
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
        mapping = MAP_TRIPLE
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
        mapping = MAP_TOGGLE
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
    }
}

BADGE_CODES = {
    elite_four_badges = {
        code = "e4_badges",
        mapping = MAP_16
    },
    red_badges = {
        code = "red_badges",
        mapping = MAP_16
    },
    radio_tower_badges = {
        code = "tower_badges",
        mapping = MAP_16
    },
    mt_silver_badges = {
        code = "mt_silver_badges",
        mapping = MAP_16
    },
    kanto_access_badges = {
        code = "kanto_access_badges_count",
        mapping = MAP_16
    }
}