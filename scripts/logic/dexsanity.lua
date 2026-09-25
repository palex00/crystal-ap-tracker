EVOLUTION_METHOD_MAP = {
    EVOLVE_LEVEL = function(_) return "Via Levelup" end,
    EVOLVE_HAPPINESS = function(_) return "Via Happiness" end,
    EVOLVE_STAT = function(condition)
        if condition == "ATK_LT_DEF" then
            return "While Attack is lower than Defense"
        elseif condition == "ATK_EQ_DEF" then
            return "While Attack is equal to Defense"
        elseif condition == "ATK_GT_DEF" then
            return "While Attack is greater than Defense"
        end
    end,
    EVOLVE_ITEM = function(condition)
        local item_map = {
            FIRE_STONE = "Using a Fire Stone",
            THUNDERSTONE = "Using a Thunderstone",
            WATER_STONE = "Using a Water Stone",
            UP_GRADE = "Using an Up-Grade",
            METAL_COAT = "Using a Metal Coat",
            DRAGON_SCALE = "Using a Dragon Scale",
            MOON_STONE = "Using a Moon Stone",
            SUN_STONE = "Using a Sun Stone",
            KINGS_ROCK = "Using a Kings Rock",
            LEAF_STONE = "Using a Leaf Stone",
            LINK_CABLE = "Using a Link Cable",
        }
        return item_map[condition]
    end,
    EVOLVE_TRADE = function(condition)
        local item_map = {
            METAL_COAT = "Using a Metal Coat",
            DRAGON_SCALE = "Using a Dragon Scale",
            KINGS_ROCK = "Using a Kings Rock",
            UP_GRADE = "Using an Up-Grade",
        }
        return item_map[condition]
    end
}

BREEDING_REQUIRES_DITTO = {
    [29] = true,  -- Nidoran (F)
    [32] = true,  -- Nidoran (M)
    [33] = true,  -- Nidorino
    [34] = true,  -- Nidoking
    [81] = true,  -- Magnemite
    [82] = true,  -- Magneton
    [100] = true, -- Voltorb
    [101] = true, -- Electrode
    [106] = true, -- Hitmonlee
    [107] = true, -- Hitmonchan
    [113] = true, -- Chansey
    [115] = true, -- Kangaskhan
    [120] = true, -- Staryu
    [121] = true, -- Starmie
    [124] = true, -- Jynx
    [128] = true, -- Tauros
    [137] = true, -- Porygon
    [233] = true, -- Porygon2
    [237] = true, -- Hitmontop
    [241] = true, -- Miltank
    [242] = true, -- Blissey
}

function breeding(ID)
    local daycare = ALL(CanReach("REGION_DAY_CARE"), CanReach("REGION_ROUTE_34:DAY_CARE_YARD"))

    if (daycare == 0) or has("breeding_logic_off_hard") then
        return AccessibilityLevel.None
    end

    if not has("pokemon_132") and (BREEDING_REQUIRES_DITTO[tonumber(ID)] or has("breeding_logic_ditto_hard")) then -- 132 = ditto
        return AccessibilityLevel.None
    end

    if has("breeding_logic_on") then
        return daycare
    elseif has("pokemon_132") and (has("breeding_logic_ditto_hard") or has("breeding_logic_ditto_soft")) then -- 132 = ditto
        return daycare
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_old(req_level)
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve(req_level)
    end
end

function evolve(req_level)
    local max_value     = getDigits("yaml_digit1", "yaml_digit2")
    local current_level = getDigits("result_digit1", "result_digit2")
    local req           = math.max(tonumber(req_level) or 0, max_value)

    if has("evomethod_level_on") and req <= current_level then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_friend()
    local daisy = CanReach("REGION_PALLET_TOWN")
    local massage = CanReach("REGION_GOLDENROD_UNDERGROUND")
    if has("evomethod_happiness_on") and (daisy == 6 or massage == 6) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_friend_old()
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve_friend()
    end
end

function evolve_item(condition)
    if has("evomethod_useitem_on") and has(condition) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_item_old(condition)
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve_item(condition)
    end
end

function evolve_helditem(condition)
    if has("evomethod_helditem_on") and has("LINK_CABLE") and has(condition) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_helditem_old(condition)
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve_helditem(condition)
    end
end
       
function evolve_tyrogue()
    local current_level = getDigits("result_digit1", "result_digit2")
    local goldenrod = CanReach("REGION_GOLDENROD_CITY")
    local celadon = CanReach("REGION_CELADON_CITY")
    
    if has("evomethod_tyrogue_on") and (20 <= current_level) and (goldenrod == 6 or celadon == 6) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_tyrogue_old()
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve_tyrogue()
    end
end

function land_encounter()
    if has("encmethod_land_on") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function land_tod(tod)
    if has("unlockable_tod_off") or has("starttod_" .. tod) then
        return AccessibilityLevel.Normal
    end
    if has(tod .. "_ITEM") and has("POKE_GEAR") then
        return AccessibilityLevel.Normal
    end
    return AccessibilityLevel.None
end

function fish_tod(tod)
    if tod == "DAY" then
        return math.max(land_tod("MORN"), land_tod("DAY"))
    end
    return land_tod(tod)
end

function surf_encounter_johto()
    if has("encmethod_water_on") and can_surf_johto() then
        return AccessibilityLevel.Normal
    elseif can_surf_johto() then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function surf_encounter_kanto()
    if has("encmethod_water_on") and can_surf_kanto() then
        return AccessibilityLevel.Normal
    elseif can_surf_kanto() then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function fishing_old()
    if has("encmethod_fishing_on") and has("OLD_ROD") then
        return AccessibilityLevel.Normal
    elseif has("OLD_ROD") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function fishing_good()
    if has("encmethod_fishing_on") and has("GOOD_ROD") then
        return AccessibilityLevel.Normal
    elseif has("GOOD_ROD") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function fishing_super()
    if has("encmethod_fishing_on") and has("SUPER_ROD") then
        return AccessibilityLevel.Normal
    elseif has("SUPER_ROD") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function headbutting()
    if has("encmethod_headbutt_on") and has("TM_HEAD_BUTT") and can_teach("HEADBUTT") then
        return AccessibilityLevel.Normal
    elseif has("TM_HEAD_BUTT") and can_teach("HEADBUTT") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function rocksmash_encounter()
    if has("encmethod_rocksmash_on") and can_rock_smash() then
        return AccessibilityLevel.Normal
    elseif can_rock_smash() then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function static_encounter()
    if has("encmethod_static_on") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function contest_encounter()
    if has("encmethod_contest_on") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function swarm_encounter(region)
    if not has("encmethod_swarm_on") then
        return AccessibilityLevel.SequenceBreak
    end
    return math.min(phonecall(), CanReach(region))
end


function trade(person)
    if TRADE_DATA ~= nil then
        if not has("POKEDEX") then
            return AccessibilityLevel.None
        end
        
        local checked = Tracker:FindObjectForCode("TRADE_"..person).Active
        local pokemon_code = "pokemon_" .. TRADE_DATA["TRADE_"..person].requested
    
        if not checked then
            return AccessibilityLevel.Inspect
        elseif not has(pokemon_code) then
            return AccessibilityLevel.None
        elseif has("encmethod_trades_on") then
            return AccessibilityLevel.Normal
        else
            return AccessibilityLevel.SequenceBreak
        end
    else
        return AccessibilityLevel.Inspect
    end
end

function evolution_access(evo)
    if evo.method == "EVOLVE_LEVEL" then
        return evolve(evo.condition)
    elseif evo.method == "EVOLVE_ITEM" then
        return evolve_item(evo.condition)
    elseif evo.method == "EVOLVE_HAPPINESS" then
        return evolve_friend()
    elseif evo.method == "EVOLVE_STAT" then
        return evolve_tyrogue()
    elseif evo.method == "EVOLVE_TRADE" then
        return evolve_helditem(evo.condition)
    end
end

function evolve_new(ID, method_filter, condition_filter)
    local evolutions = EVOLUTION_DATA[ID]

    if not evolutions then
        return
    end

    if Tracker:FindObjectForCode("pokemon_" .. ID).Active == false then
        return AccessibilityLevel.None
    end

    for _, evo in ipairs(evolutions) do
        if (method_filter == nil or evo.method == method_filter)
        and (condition_filter == nil or tostring(evo.condition) == condition_filter) then
            return evolution_access(evo)
        end
    end
end

function breeding_new(ID)
    if Tracker:FindObjectForCode("pokemon_" .. ID).Active == false then
        return AccessibilityLevel.None
    end
    return breeding(ID)
end

