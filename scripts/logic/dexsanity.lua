function breeding()
    -- Info for prosperity. There is something deeply fucked with this.
    -- Initially I had it look for JohtoKanto/Route 34 but that returns 0 always. For some reason.
    -- So we're doing Goldenrod and I'm gonna physically restrain James from decoupling those in logic in the future
    local daycare = Tracker:FindObjectForCode("@JohtoKanto/Goldenrod City").AccessibilityLevel
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

function evolve(req_level)
    req_level = tonumber(req_level)
    req_level = req_level or 0
    local digit1 = Tracker:FindObjectForCode("result_digit1").CurrentStage or 0
    local digit2 = Tracker:FindObjectForCode("result_digit2").CurrentStage or 0
    local current_level = digit1 * 10 + digit2
    if has("encmethod_land_on") and req_level <= current_level then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function evolve_friend()
    local daisy = Tracker:FindObjectForCode("@JohtoKanto/Pallet Town").AccessibilityLevel
    local massage = Tracker:FindObjectForCode("@JohtoKanto/Goldenrod City").AccessibilityLevel
    if has("evomethod_happiness_on") and (daisy == 6 or massage == 6) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
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

function land_encounter()
    if has("encmethod_land_on") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function surf_encounter_johto()
    if has("encmethod_land_on") and can_surf_johto() then
        return AccessibilityLevel.Normal
    elseif can_surf_johto() then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None
    end
end

function surf_encounter_kanto()
    if has("encmethod_land_on") and can_surf_kanto() then
        return AccessibilityLevel.Normal
    elseif can_surf_johto() then
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