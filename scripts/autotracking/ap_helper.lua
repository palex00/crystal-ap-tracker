function resetItems()
    for _, v in pairs(ITEM_MAPPING) do
        if v then
            if v == "PROGRESSIVE_ROD" then
                -- ignore
            else
                local obj = Tracker:FindObjectForCode(v)
                if obj then
                    if v == "BLUE_CARD_POINT" or v == "AERODACTYL_TILE" or v == "HO-OH_TILE" or v == "KABUTO_TILE" or v == "OMANYTE_TILE" then
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

FLYTOWN_MAPPING = {
    [0]  = 0,   -- No Starting Town Rando
    [1]  = 0,   -- New Bark Town
    [2]  = 1,   -- Cherrygrove City
    [3]  = 2,   -- Violet City
    [4]  = 3,   -- Azalea Town
    [5]  = 4,   -- Goldenrod City
    [6]  = 5,   -- Ecruteak City
    [7]  = 6,   -- Olivine City
    [8]  = 7,   -- Cianwood City
    [9]  = 8,   -- Mahogany Town
    [10] = 9,   -- Lake of Rage
    [11] = 10,  -- Blackthorn City
    [12] = 11,  -- Silver Cave
    [13] = 12,  -- Pallet Town
    [14] = 13,  -- Viridian City
    [15] = 14,  -- Pewter City
    [16] = 15,  -- Cerulean City
    [17] = 16,  -- Vermilion City
    [18] = 17,  -- Lavender Town
    [19] = 18,  -- Celadon City
    [20] = 19,  -- Saffron City
    [21] = 20,  -- Cinnabar Island
    [22] = 21,  -- Fuchsia City
    [23] = 22   -- Indigo Plateau
}

STARTTOWN_MAPPING = {
    [0]  = 0,    -- None (no dedicated stage; falls back to New Bark Town)
    [37]  = 0,   -- New Bark Town
    [38]  = 1,   -- Cherrygrove City
    [39]  = 2,   -- Violet City
    [40]  = 3,   -- Rock Tunnel
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
    [29]  = 17,  -- Vermilion City
    [30]  = 18,  -- Lavender Town
    [31]  = 19,  -- Celadon City
    [32]  = 20,  -- Saffron City
    [33]  = 21,  -- Cinnabar Island
    [34]  = 22   -- Fuchsia City
}

SLOT_CODES = {
    enable_mischief = {
        code = "mischief",
        mapping = MAP_TOGGLE
    },
    -- Entrance randomization category toggles. RENAME the left-hand slot_data keys to match
    -- your apworld's actual option names. Each maps onto its er_<cat> settings item
    -- (0 = off, 1 = on); the er_<cat> watch then refreshes ER_CATEGORY_ENABLED. If your
    -- slot_data sends booleans instead of 0/1, add [true]/[false] to MAP_TOGGLE.
    randomize_town_exits   = { code = "er_town_exits",   mapping = MAP_TOGGLE },
    randomize_dungeons     = { code = "er_dungeons",     mapping = MAP_TOGGLE },
    randomize_caves        = { code = "er_caves",        mapping = MAP_TOGGLE },
    randomize_holes        = { code = "er_holes",        mapping = MAP_TOGGLE },
    randomize_gyms         = { code = "er_gyms",         mapping = MAP_TOGGLE },
    randomize_pokecenters  = { code = "er_pokecenters",  mapping = MAP_TOGGLE },
    randomize_pokemarts    = { code = "er_pokemarts",    mapping = MAP_TOGGLE },
    randomize_houses       = { code = "er_houses",       mapping = MAP_TOGGLE },
    randomize_single_warps = { code = "er_single_warps", mapping = MAP_TOGGLE },
    randomize_special      = { code = "er_special",      mapping = MAP_TOGGLE },
    -- temp disabled
    --goal = {
    --    code = "goal",
    --    mapping = MAP_SIXTUPLE
    --},
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
        mapping = FLYTOWN_MAPPING
    },
    map_card_fly_location = {
        code = "map_card_fly",
        mapping = FLYTOWN_MAPPING
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
    breeding_method = {
        code = "breeding_logic",
        mapping = MAP_QUINTUPLE
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
    },
    ss_aqua_access = {
        code = "ss_aqua_access",
        mapping = MAP_TOGGLE
    },
    magnet_train_access = {
        code = "magnet_train_access",
        mapping = MAP_TOGGLE
    },
    randomize_bug_catching_contest = {
        code = "randomize_bug_catching_contest",
        mapping = MAP_QUADRUPLE
    },
    encmethod_contest = {
        code = "encmethod_contest",
        mapping = MAP_TRIPLE
    },
    trades_required = {
        code = "encmethod_trades",
        mapping = MAP_TOGGLE
    },
    require_pokegear_for_phone_numbers = {
        code = "require_pokegear_for_phone_numbers",
        mapping = MAP_TOGGLE
    },
    route_42_access = {
        code = "route_42_access",
        mapping = MAP_QUADRUPLE
    },
    randomize_phone_call_items = {
        code = "randomize_phone_call_items",
        mapping = MAP_TRIPLE
    },
    route_12_access = {
        code = "route_12_access",
        mapping = MAP_TOGGLE
    },
    route_30_access = {
        code = "route_30_access",
        mapping = MAP_TOGGLE
    },
    randomize_pokedex = {
        code = "randomize_pokedex",
        mapping = MAP_TRIPLE
    },
    south_kanto_access = {
        code = "south_kanto_access",
        mapping = MAP_QUADRUPLE
    },
    south_kanto_condition = {
        code = "south_kanto_condition",
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
    }
}