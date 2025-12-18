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
        }
        return item_map[condition]
    end
}

function breeding()
    local daycare = Tracker:FindObjectForCode("@JohtoKanto/Route 34").AccessibilityLevel
    if has("breeding_logic_on") and daycare ~= 0 then
        return daycare
    elseif has("breeding_logic_ditto") and has("ditto") and daycare ~= 0 then
        return daycare
    elseif daycare ~= 0 then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
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
    req_level = tonumber(req_level)
    req_level = req_level or 0
    local digit1 = Tracker:FindObjectForCode("result_digit1").CurrentStage or 0
    local digit2 = Tracker:FindObjectForCode("result_digit2").CurrentStage or 0
    local current_level = digit1 * 10 + digit2
    if has("evomethod_level_on") and req_level <= current_level then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_friend()
    local daisy = Tracker:FindObjectForCode("@JohtoKanto/Pallet Town").AccessibilityLevel
    local massage = Tracker:FindObjectForCode("@JohtoKanto/Goldenrod Underground/Item").AccessibilityLevel
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

function evolve_item()
    local goldenrod = Tracker:FindObjectForCode("@JohtoKanto/Goldenrod City").AccessibilityLevel
    local celadon = Tracker:FindObjectForCode("@JohtoKanto/Celadon City").AccessibilityLevel
    if has("evomethod_useitem_on") and (goldenrod == 6 or celadon == 6) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_item_old()
    if has("randomize_evolution_true") then
        return AccessibilityLevel.Inspect
    else
       return evolve_item()
    end
end
       
function evolve_tyrogue()
    local digit1 = Tracker:FindObjectForCode("result_digit1").CurrentStage or 0
    local digit2 = Tracker:FindObjectForCode("result_digit2").CurrentStage or 0
    local current_level = digit1 * 10 + digit2
    local goldenrod = Tracker:FindObjectForCode("@JohtoKanto/Goldenrod City").AccessibilityLevel
    local celadon = Tracker:FindObjectForCode("@JohtoKanto/Celadon City").AccessibilityLevel
    
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
    if has("encmethod_headbutt_on") and has("TM_HEAD_BUTT") then
        return AccessibilityLevel.Normal
    elseif has("TM_HEAD_BUTT") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function rocksmash_encounter()
    if has("encmethod_rocksmash_on") and has("TM_ROCK_SMASH") then
        return AccessibilityLevel.Normal
    elseif has("TM_ROCK_SMASH") then
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


function trade(person)
    if TRADE_DATA ~= nil then
        local checked = Tracker:FindObjectForCode("TRADE_"..person).Active
        local pokemon_name = POKEMON_MAPPING[tonumber(TRADE_DATA["TRADE_"..person].requested)]
    
        if not checked then
            return AccessibilityLevel.Inspect
        elseif has(pokemon_name) then
            return AccessibilityLevel.Normal
        else
            return AccessibilityLevel.SequenceBreak
        end
    else
        return AccessibilityLevel.Inspect
    end
end

function evolve_new(ID)
    local evolutions = EVOLUTION_DATA[ID]

    if not evolutions then
        return
    end
    
    local pokemon_ownership = POKEMON_MAPPING[tonumber(ID)]
    if Tracker:FindObjectForCode(pokemon_ownership).Active == false then
        return AccessibilityLevel.None
    end

    for _, evo in ipairs(evolutions) do
        if evo.method == "EVOLVE_LEVEL" then
            return evolve(evo.condition)
        elseif evo.method == "EVOLVE_ITEM" then
            return evolve_item()
        elseif evo.method == "EVOLVE_HAPPINESS" then
            return evolve_friend()
        elseif evo.method == "EVOLVE_STAT" then
            return evolve_tyrogue()
        end
    end
end

function breeding_new(ID)
    local pokemon_ownership = POKEMON_MAPPING[tonumber(ID)]
    if Tracker:FindObjectForCode(pokemon_ownership).Active == false then
        return AccessibilityLevel.None
    end
    return breeding()
end

