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
        if v then
            local obj = Tracker:FindObjectForCode(v)
            if obj then
                obj.AvailableChestCount = 1
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

FLY_ECRUTEAK = 22
FLY_OLIVINE = 21
FLY_CIANWOOD = 19
FLY_MAHOGANY = 23
FLY_BLACKTHORN = 25
FLY_VIRIDIAN = 3
FLY_PEWTER = 4
FLY_CERULEAN = 5
FLY_VERMILION = 7
FLY_LAVENDER = 8
FLY_CELADON = 10
FLY_SAFFRON = 9
FLY_FUCHSIA = 11
FLY_AZALEA = 18
FLY_GOLDENROD = 20
FLY_LAKE_OF_RAGE = 24
FLY_PALLET = 2
FLY_CINNABAR = 12
FLY_SILVER_CAVE = 26

MAP_FREEFLY = {
    [0] = 0,
    [FLY_AZALEA] = 1,
    [FLY_GOLDENROD] = 2,
    [FLY_ECRUTEAK] = 3,
    [FLY_OLIVINE] = 4,
    [FLY_CIANWOOD] = 5,
    [FLY_MAHOGANY] = 6,
    [FLY_LAKE_OF_RAGE] = 7,
    [FLY_BLACKTHORN] = 8,
    [FLY_PALLET] = 9,
    [FLY_VIRIDIAN] = 10,
    [FLY_PEWTER] = 11,
    [FLY_CERULEAN] = 12,
    [FLY_VERMILION] = 13,
    [FLY_LAVENDER] = 14,
    [FLY_CELADON] = 15,
    [FLY_SAFFRON] = 16,
    [FLY_CINNABAR] = 17,
    [FLY_FUCHSIA] = 18,
    [FLY_SILVER_CAVE] = 19
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
        mapping = MAP_FREEFLY
    },
    map_card_fly_location = {
        code = "map_card_fly",
        mapping = MAP_FREEFLY
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