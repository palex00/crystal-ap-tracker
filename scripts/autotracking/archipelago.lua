ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/sign_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/encounter_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/pokemon_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/evolution_location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/ap_helper.lua")

CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0

EVENT_ID = ""
EVENT2_ID = ""
KEY_ID = ""
STATIC_ID = ""
ROCKETTRAP_ID = ""
SEEN_ID = ""
CAUGHT_ID = ""
EVOLUTION_DATA = ""
BREEDING_DATA = ""
allChecked = nil
CHECKED_SIGNS = nil
UNOWN_DATA = nil
TRADE_DATA = nil
SAVED_HINTS = {}

if Highlight then
    HIGHLIGHT_LEVEL= {
        [0] = Highlight.Unspecified,
        [1] = Highlight.Priority,
        [2] = Highlight.NoPriority,
        [3] = Highlight.Priority,
        [4] = Highlight.Avoid,
        [5] = Highlight.Priority,
        [6] = Highlight.NoPriority
    }
end

HIGHLIGHT_PRIORITY =  {
    [3] = 1,
    [2] = 2,
    [-1] = 3,
    [1] = 4,
    [0] = 5
}

function onClear(slot_data)
    isUpdating = true
    CUR_INDEX = -1
    resetLocations()
    resetItems()
    CAUGHT = {}
    SEEN = {}
    
    for _, code in ipairs(FLAG_STATIC_CODES) do
        ScriptHost:RemoveWatchForCode(code)
    end
    
    -- resets unown codes
    for i = 1, 26 do
        local obj = Tracker:FindObjectForCode("UNOWN_" .. i)
        if obj then
            obj.Active = false
        end
    end

    for _, code in ipairs(FLAG_TRADE_CODES) do
        Tracker:FindObjectForCode(code).Active = false
    end

    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    print(dump_table(slot_data))
    
    for k, v in pairs(slot_data) do
        if slot_data["johto_only"] ~= nil then
            if  k == "apworld_version" then
                local version_str = tostring(v)
                local first_two_dots = version_str:match("^([^.]+%.[^.]+)%.")
                if first_two_dots == "5.4" or nil then
                    Tracker:AddLayouts("layouts/tracker.json")
                else
                    Tracker:AddLayouts("layouts/versionmismatch.json")
                    return
                end
            end
        else
            Tracker:AddLayouts("layouts/not_crystal.json")
        end            
    end


    POKEMON_TO_LOCATIONS = {}
    
    -- This appends Trades & BCC to region encounters slot data
    REGION_ENCOUNTERS = slot_data.region_encounters
    REGION_ENCOUNTERS["contest_encounters"] = slot_data.contest_encounters
    for trade_key, trade_data in pairs(slot_data.trades) do
        REGION_ENCOUNTERS[trade_key] = { tonumber(trade_data.received) }
    end

    for location, dex_list in pairs(REGION_ENCOUNTERS) do
        for _, dex_number in pairs(dex_list) do
            if POKEMON_TO_LOCATIONS[dex_number] == nil then
                POKEMON_TO_LOCATIONS[dex_number] = {}
            end
            table.insert(POKEMON_TO_LOCATIONS[dex_number], location)
        end
    end
    
    TRADE_DATA = slot_data.trades
    UNOWN_DATA = slot_data.unown_signs
    
    -- This sets each Encounter location to however many unique encounters there are in it
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        local object = Tracker:FindObjectForCode(location)
        object.AvailableChestCount = #REGION_ENCOUNTERS[region_key]
    end
    
    EVOLUTION_DATA = slot_data.evolution_info
    BREEDING_DATA = slot_data.breeding_info

    for k, v in pairs(slot_data) do
        if SLOT_CODES[k] then
            Tracker:FindObjectForCode(SLOT_CODES[k].code).CurrentStage = SLOT_CODES[k].mapping[v]
        elseif REQUIREMENT_CODES[k] then
			local item = REQUIREMENT_CODES[k].item
			item:setType(REQUIREMENT_CODES[k].mapping[v])
		elseif AMOUNT_CODES[k] then
			local item = AMOUNT_CODES[k].item
			item:setStage(v)
        elseif LIST_CODES[k] then
            for _, code in pairs(LIST_CODES[k].values) do
                Tracker:FindObjectForCode(code).CurrentStage = LIST_CODES[k].mapping[0]
            end
        
            for _, name in ipairs(v or {}) do
                local code = LIST_CODES[k].values[name]
                if code then
                    Tracker:FindObjectForCode(code).CurrentStage = LIST_CODES[k].mapping[1]
                end
            end
        elseif k == "trainersanity" then
            if #v == 0 then
                TRAINERS:setType("none")
            elseif #v == 372 and has("johto_only_off") then
                TRAINERS:setType("full")
            elseif #v == 242 and (has("johto_only_on") or has("johto_only_silver")) then
                TRAINERS:setType("full")
            else
                TRAINERS:setType("partial")
                TRAINERS:setStage(#v)
                resetTrainers()
                for _, value in ipairs(v) do
                    Tracker:FindObjectForCode("trainersanity_" .. value).Active = true
                end
            end
        elseif k == "dexsanity" then
            Tracker:FindObjectForCode("dexsanity").AcquiredCount = v
        elseif k == "evolution_gym_levels" then
            local val = tonumber(v) or 0
            Tracker:FindObjectForCode("yaml_digit1").CurrentStage = math.floor(val / 10)
            Tracker:FindObjectForCode("yaml_digit2").CurrentStage = val % 10
        elseif k == "dexcountsanity" then
            local val = tonumber(v) or 0
            Tracker:FindObjectForCode("dexcountsanity_lastcheck_digit1").CurrentStage = math.floor(val / 100)
            Tracker:FindObjectForCode("dexcountsanity_lastcheck_digit2").CurrentStage = math.floor(val / 10) % 10
            Tracker:FindObjectForCode("dexcountsanity_lastcheck_digit3").CurrentStage = val % 10
        elseif k == "dexcountsanity_step" then
            local val = tonumber(v) or 0
            Tracker:FindObjectForCode("dexcountsanity_stepinterval_digit1").CurrentStage = math.floor(val / 100)
            Tracker:FindObjectForCode("dexcountsanity_stepinterval_digit2").CurrentStage = math.floor(val / 10) % 10
            Tracker:FindObjectForCode("dexcountsanity_stepinterval_digit3").CurrentStage = val % 10
        elseif k == "dexcountsanity_leniency" then
            local val = tonumber(v) or 0
            Tracker:FindObjectForCode("dexcountsanity_logicleniency_digit1").CurrentStage = math.floor(val / 100)
            Tracker:FindObjectForCode("dexcountsanity_logicleniency_digit2").CurrentStage = math.floor(val / 10) % 10
            Tracker:FindObjectForCode("dexcountsanity_logicleniency_digit3").CurrentStage = val % 10
        elseif k == "dexcountsanity_checks" then
            local val = tonumber(v) or 0
            Tracker:FindObjectForCode("dexcountsanity_totalchecks_digit1").CurrentStage = math.floor(val / 100)
            Tracker:FindObjectForCode("dexcountsanity_totalchecks_digit2").CurrentStage = math.floor(val / 10) % 10
            Tracker:FindObjectForCode("dexcountsanity_totalchecks_digit3").CurrentStage = val % 10
            Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total").AvailableChestCount = val
        elseif k == "dexsanity_pokemon" then
            local valid_ids = {}
            for i = 1, 251 do valid_ids[i] = true end
            local found = {}
            for _, num in ipairs(v) do
                if valid_ids[num] then
                    Tracker:FindObjectForCode("dexsanity_" .. num).Active = true
                    found[num] = true
                end
            end
            for i = 1, 251 do
                if not found[i] then
                    Tracker:FindObjectForCode("dexsanity_" .. i).Active = false
                end
            end
        elseif k == "logically_available_pokemon_count" then
            Tracker:FindObjectForCode("diploma_goal_count").AcquiredCount = tonumber(v)
        else
            -- print(string.format("No setting could be found for key: %s", k))
        end
    end
    
    if has("randomize_pokedex_startwith") then
        Tracker:FindObjectForCode("POKEDEX").Active = true
    end
    
    updateRemainingDexcountsanityChecks()
    showMonVisibility()
    
    -- tea function
    local stages = {
        ["0000"] = 0,
        ["0001"] = 1,
        ["0010"] = 2,
        ["0011"] = 3,
        ["0100"] = 4,
        ["0101"] = 5,
        ["0110"] = 6,
        ["0111"] = 7,
        ["1000"] = 8,
        ["1001"] = 9,
        ["1010"] = 10,
        ["1011"] = 11,
        ["1100"] = 12,
        ["1101"] = 13,
        ["1110"] = 14,
        ["1111"] = 15
    }
    
    

    -- Fetch Active values for north, east, south, west directions
    local tea_north = Tracker:FindObjectForCode("tea_north").Active and "1" or "0"
    local tea_east = Tracker:FindObjectForCode("tea_east").Active and "1" or "0"
    local tea_south = Tracker:FindObjectForCode("tea_south").Active and "1" or "0"
    local tea_west = Tracker:FindObjectForCode("tea_west").Active and "1" or "0"

    -- Concatenate values to form the key
    local key = tea_north .. tea_east .. tea_south .. tea_west

    -- Set CurrentStage for "tea"
    Tracker:FindObjectForCode("tea_guard").CurrentStage = stages[key]
    
    if PLAYER_ID>-1 then
        if string.lower(Archipelago:GetPlayerAlias(PLAYER_ID)):find("chrism") then
            Tracker:FindObjectForCode("chrism").CurrentStage = 1
        else
            Tracker:FindObjectForCode("chrism").CurrentStage = 0
        end
        
        updateEvents(0)
        updateEvents2(0)
        updateStatics(0)
        updateRocketTraps(0)
        updateVanillaKeyItems(0)
        
        EVENT_ID="pokemon_crystal_events_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({EVENT_ID})
        Archipelago:Get({EVENT_ID})
        
        EVENT2_ID="pokemon_crystal_events_2_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({EVENT2_ID})
        Archipelago:Get({EVENT2_ID})
        
        STATIC_ID="pokemon_crystal_statics_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({STATIC_ID})
        Archipelago:Get({STATIC_ID})
    
        ROCKETTRAP_ID="pokemon_crystal_rockettraps_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({ROCKETTRAP_ID})
        Archipelago:Get({ROCKETTRAP_ID})
        
        KEY_ID="pokemon_crystal_keys_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({KEY_ID})
        Archipelago:Get({KEY_ID})
        
        SEEN_ID="pokemon_crystal_seen_pokemon_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({SEEN_ID})
        Archipelago:Get({SEEN_ID})
        
        CAUGHT_ID="pokemon_crystal_caught_pokemon_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({CAUGHT_ID})
        Archipelago:Get({CAUGHT_ID})
        
        SIGN_ID="pokemon_crystal_signs_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({SIGN_ID})
        Archipelago:Get({SIGN_ID})
        
        UNOWN_ID="pokemon_crystal_unowns_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({UNOWN_ID})
        Archipelago:Get({UNOWN_ID})
        
        TRADE_ID="pokemon_crystal_trades_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({TRADE_ID})
        Archipelago:Get({TRADE_ID})
        
        SLOT_UNLOCK="pokemon_crystal_tracker_slots_enabled_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({SLOT_UNLOCK})
        Archipelago:Get({SLOT_UNLOCK})
        
        HINT_ID = "_read_hints_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({HINT_ID})
        Archipelago:Get({HINT_ID})
    end

    toggle_itemgrid()
    
    for _, code in ipairs(FLAG_STATIC_CODES) do
        ScriptHost:AddWatchForCode(code, code, updatePokemon)
    end
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    CUR_INDEX = index;
    local v = ITEM_MAPPING[item_id]
    if not v then
        --print(string.format("onItem: could not find item mapping for id %s", item_id))
        return
    end
    
    if v == "PROGRESSIVE_ROD" then
        if has("GOOD_ROD") then
            Tracker:FindObjectForCode("SUPER_ROD").Active = true
        elseif has("OLD_ROD") then
            Tracker:FindObjectForCode("GOOD_ROD").Active = true
        else
            Tracker:FindObjectForCode("OLD_ROD").Active = true
        end
        return
    end
    
    local obj = Tracker:FindObjectForCode(v)
    if obj then
        if v == "BLUE_CARD_POINT" or v == "AERODACTYL_TILE" or v == "HO-OH_TILE" or v == "KABUTO_TILE" or v == "OMANYTE_TILE" then
            obj.AcquiredCount = obj.AcquiredCount + 1
        else
            obj.Active = true
        end
    else
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

---- we use this for hint tracking
CLEARED_LOCATIONS = {}

-- called when a location gets cleared
function onLocation(location_id, location_name)
    local v = LOCATION_MAPPING[location_id]
    if not v then
        print(string.format("onLocation: could not find location mapping for id %s", location_id))
    end
    
    local obj = Tracker:FindObjectForCode(v)
    if obj then
    	if v:sub(1, 1) == "@" then
    		obj.AvailableChestCount = obj.AvailableChestCount - 1
            local current_total = CLEARED_LOCATIONS[v] or 0
            CLEARED_LOCATIONS[v] = current_total + 1
    	elseif obj.Type == "progressive" then
    		obj.CurrentStage = obj.CurrentStage + 1
    	else
    		obj.Active = true
    	end
    elseif AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
    	print(string.format("onLocation: could not find object for code %s", v[1]))
    end
    
    local id_str = tostring(location_id)
    if #id_str == 5 and id_str:sub(1, 2) == "20" then
        updateRemainingDexcountsanityChecks()
    end
end

function onNotify(key, value, old_value)
    if value ~= nil and value ~= 0 then
        if key == EVENT_ID then
            updateEvents(value)
        elseif key == EVENT2_ID then
            updateEvents2(value)
        elseif key == STATIC_ID then
            updateStatics(value)
        elseif key == KEY_ID then
            updateVanillaKeyItems(value)
        elseif key == CAUGHT_ID then
            CAUGHT = value
            updatePokemon()
        elseif key == SEEN_ID then
            SEEN = value
            updatePokemon()
        elseif key == ROCKETTRAP_ID then
            updateRocketTraps(value)
        elseif key == SIGN_ID then
            updateSigns(value)
        elseif key == UNOWN_ID then
            updateUnown(value)
        elseif key == TRADE_ID then
            updateTrades(value)
        elseif key == SLOT_UNLOCK then
            Tracker:AddLayouts("layouts/settings_quick_slottrack.json")
        elseif key == HINT_ID then
            SAVED_HINTS = value
            toggleHints()
        end
    end
end

function onNotifyLaunch(key, value)
    if value ~= nil and value ~= 0 then
        if key == EVENT_ID then
            updateEvents(value)
        elseif key == EVENT2_ID then
            updateEvents2(value)
        elseif key == STATIC_ID then
            updateStatics(value)
        elseif key == KEY_ID then
            updateVanillaKeyItems(value)
        elseif key == CAUGHT_ID then
            CAUGHT = value
            updatePokemon()
        elseif key == SEEN_ID then
            SEEN = value
            updatePokemon()
        elseif key == ROCKETTRAP_ID then
            updateRocketTraps(value)
        elseif key == SIGN_ID then
            updateSigns(value)
        elseif key == UNOWN_ID then
            updateUnown(value)
        elseif key == TRADE_ID then
            updateTrades(value)
        elseif key == SLOT_UNLOCK then
            Tracker:AddLayouts("layouts/settings_quick_slottrack.json")
        elseif key == HINT_ID then
            SAVED_HINTS = value
            toggleHints()
        end
    end
end

function updateEvents(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_CODES) do
            local bit = (value >> (i - 1)) & 1
            Tracker:FindObjectForCode(code).Active = (bit == 1)
        end
    end
end

function updateEvents2(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_2_CODES) do
            local bit = (value >> (i - 1)) & 1
            Tracker:FindObjectForCode(code).Active = (bit == 1)
        end
    end
end

function updateStatics(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_STATIC_CODES) do
            local obj = Tracker:FindObjectForCode(code)
            if obj ~= nil then
                obj.Active = false
            end
            local bit = value >> (i - 1) & 1
            if #code > 0 then
                Tracker:FindObjectForCode(code).Active = Tracker:FindObjectForCode(code).Active or bit
            end
            local is_active = tostring(Tracker:FindObjectForCode(code).Active)
        end
    end
end

function updateRocketTraps(value)
    if value ~= nil then
        local statusMap = {}

        for i, code in ipairs(FLAG_ROCKETTRAPS_CODES) do
            if #code > 0 then
                local bit = (value >> (i - 1)) & 1
                statusMap[code] = (statusMap[code] or 0) | bit
            end
        end

        for code, _ in pairs(statusMap) do
            local obj = Tracker:FindObjectForCode(code)
            if obj ~= nil then
                obj.Active = false
            end
        end

        for code, bit in pairs(statusMap) do
            if bit == 1 then
                local obj = Tracker:FindObjectForCode(code)
                if obj ~= nil then
                    obj.Active = true
                end
            end
        end
    end
end


function updateTrades(value)
    if value ~= nil then
        for _, intVal in ipairs(value) do
            local code = FLAG_TRADE_CODES[intVal + 1]
            if code then
                local obj = Tracker:FindObjectForCode(code)
                if obj then
                    obj.Active = true
                end
            end
        end
   end
end


function updateVanillaKeyItems(value)
    if value ~= nil then
        for i, obj in ipairs(FLAG_ITEM_CODES) do
            local bit = value >> (i - 1) & 1
            if obj.codes and (obj.option == nil or has(obj.option)) then
                for i, code in ipairs(obj.codes) do
                    Tracker:FindObjectForCode(code).Active = Tracker:FindObjectForCode(code).Active or bit
                end
            end
        end
    end
end

function updateUnown(value)
    for i = 1, 26 do
        if table_contains(value, i) then
            Tracker:FindObjectForCode("UNOWN_"..i).Active = true
        end
    end
    updateSigns()
end

function updateSigns(checked_signs)
    if checked_signs ~= nil then
        CHECKED_SIGNS = checked_signs
    end

    allChecked = true
    for key, _ in pairs(UNOWN_DATA) do
        if not table_contains(CHECKED_SIGNS, key) then
            allChecked = false
            break
        end
    end
    
    local value = nil
    local letter = nil
    
    for _, sign in ipairs(CHECKED_SIGNS) do
        if not UNOWN_DATA[sign] then
            Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
        else
            if UNOWN_DATA[sign] ~= nil then
                value = UNOWN_DATA[sign]
                letter = value:sub(#value, #value)
                letter = string.byte(letter) - string.byte("A") + 1
            end
    
            if has("UNOWN_"..letter) then
                Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            end
        end 
    end
    
    if allChecked == true then
        for sign, _ in pairs(SIGN_MAPPING) do
            if UNOWN_DATA[sign] == nil then
                Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            end
        end
    end
end

CAUGHT_COUNT = 0

function updatePokemon()
    CAUGHT_COUNT = 0
    for dex_number, code in pairs(POKEMON_MAPPING) do
        if table_contains(CAUGHT, dex_number) then
            Tracker:FindObjectForCode(code).Active = true
            CAUGHT_COUNT = CAUGHT_COUNT + 1
        else
            Tracker:FindObjectForCode(code).Active = false
        end
    end

    if has("encounter_tracking_off") then
        return
    end

    if has("encounter_tracking_strict") or has("encounter_tracking_loose") then
        resetEvolutionsanityData()
        updateEvolutionInfo()
        updateBreedingInfo()
        
        local regionObjects = {}
        local baseCounts = {}
        local pendingDecrements = {}
        
        for region_key, location in pairs(ENCOUNTER_MAPPING) do
            regionObjects[region_key] = Tracker:FindObjectForCode(location)
            baseCounts[region_key] = #REGION_ENCOUNTERS[region_key]
            pendingDecrements[region_key] = 0
        end

        for dex_number, locations in pairs(POKEMON_TO_LOCATIONS) do
            local dexcode = Tracker:FindObjectForCode("dexsanity_" .. dex_number)
            local dexloc = Tracker:FindObjectForCode("dexsanity_"..POKEMON_MAPPING[dex_number])
            
            local is_caught = table_contains(CAUGHT, dex_number)
            local is_seen = table_contains(SEEN, dex_number)

            if has("all_pokemon_seen_true") then
                is_seen = true
            end
            
            local should_decrement = false

            if is_caught then
                should_decrement = true
            elseif is_seen and (dexloc.Active or not dexcode.Active) and has("encounter_tracking_loose") then
                should_decrement = true
            end
            
            if has("hint_tracking_on_plus") and SAVED_HINTS ~= nil then
                local padded_dex_number = 10000 + dex_number
                
                for _, hint in pairs(SAVED_HINTS) do
                    if hint.finding_player == PLAYER_ID then
                        if padded_dex_number == hint.location then
                            if hint.item_flags ~= 1 and hint.item_flags ~= 3 and hint.item_flags ~= 5 then
                                should_decrement = true
                                break
                            end
                        end
                    end
                    if should_decrement then break end
                end
            end

            if should_decrement then
                for _, location in pairs(locations) do
                    local object_name = ENCOUNTER_MAPPING[location]
                    if object_name ~= nil then
                        local object = Tracker:FindObjectForCode(object_name)
                        if object then
                            if string.sub(location, 1, 7):lower() == "static_" or string.sub(location, 1, 6):lower() == "trade_" then
                                local event_code = Tracker:FindObjectForCode(location)
                                if event_code and event_code.Active then
                                    pendingDecrements[location] = pendingDecrements[location] + 1
                                end
                            else
                                pendingDecrements[location] = pendingDecrements[location] + 1
                            end
                        end
                    end
                end
            end
        end
        
        for region_key, object in pairs(regionObjects) do
            object.AvailableChestCount = baseCounts[region_key] - pendingDecrements[region_key]
        end
        
    end
end

function resetEvolutionsanityData()
    for _, evo_string in pairs(EVO_LOC_MAPPING) do
        if  evo_string ~= "Nidorina"
        and evo_string ~= "Nidoqueen"
        and evo_string ~= "Ditto"
        and evo_string ~= "Pichu"
        and evo_string ~= "Cleffa"
        and evo_string ~= "Igglybuff"
        and evo_string ~= "Togepi"
        and evo_string ~= "Unown"
        and evo_string ~= "Tyrogue"
        and evo_string ~= "Smoochum"
        and evo_string ~= "Elekid"
        and evo_string ~= "Magby"
        then
            local breed_loc = Tracker:FindObjectForCode("@Breeding/Breed " .. evo_string .. "/Breed " .. evo_string)
            if breed_loc then
                breed_loc.AvailableChestCount = 1
            end
        end
    end
    
    for from_id, evolutions in pairs(EVOLUTION_DATA) do
        local evo_string = EVO_LOC_MAPPING[tonumber(from_id)]
        if evo_string then
            for _, evo in ipairs(evolutions) do
                if EVOLUTION_METHOD_MAP[evo.method] then
                    local method_result = EVOLUTION_METHOD_MAP[evo.method](evo.condition)
                    if method_result then
                        local loc = Tracker:FindObjectForCode("@Evolving/Evolve " .. evo_string .. "/" .. method_result)
                        if loc then
                            loc.AvailableChestCount = 1
                        end
                    end
                end
            end
        end
    end
end


function updateEvolutionInfo()
    for _, caught_id in pairs(CAUGHT) do
        for from_id, evolutions in pairs(EVOLUTION_DATA) do
            for _, evo in ipairs(evolutions) do
                if evo.into == caught_id then
                    local evo_string = EVO_LOC_MAPPING[tonumber(from_id)]
                    if evo_string and EVOLUTION_METHOD_MAP[evo.method] then
                        local method_result = EVOLUTION_METHOD_MAP[evo.method](evo.condition)
                        if method_result then
                            local loc = Tracker:FindObjectForCode("@Evolving/Evolve " .. evo_string .. "/" .. method_result)
                            if loc then
                                loc.AvailableChestCount = 0
                            end
                        end
                    end
                end
            end
        end
    end
end

function updateBreedingInfo()
    for first_id, second_id in pairs(BREEDING_DATA) do
        for _, caught_id in pairs(CAUGHT) do
            if second_id == caught_id then
                local evo_string = EVO_LOC_MAPPING[tonumber(first_id)]
                if evo_string then
                    local loc = Tracker:FindObjectForCode("@Breeding/Breed " .. evo_string .. "/Breed " .. evo_string)
                    if loc then
                        loc.AvailableChestCount = 0
                    end
                end
            end
        end
    end
end

function update_gymcount()
    local val = tonumber(gyms()) or 0
    Tracker:FindObjectForCode("gym_digit1").CurrentStage = math.floor(val / 10)
    Tracker:FindObjectForCode("gym_digit2").CurrentStage = val % 10
end

function calculateEvoLevel()
    local yaml1 = Tracker:FindObjectForCode("yaml_digit1").CurrentStage or 0
    local yaml2 = Tracker:FindObjectForCode("yaml_digit2").CurrentStage or 0
    local gym1 = Tracker:FindObjectForCode("gym_digit1").CurrentStage or 0
    local gym2 = Tracker:FindObjectForCode("gym_digit2").CurrentStage or 0

    local yaml_value = yaml1 * 10 + yaml2
    local gym_value = gym1 * 10 + gym2
    local result = math.min(99, yaml_value * gym_value)

    local result1 = math.floor(result / 10)
    local result2 = result % 10

    Tracker:FindObjectForCode("result_digit1").CurrentStage = result1
    Tracker:FindObjectForCode("result_digit2").CurrentStage = result2
end

function snorlax_access()
    if snorlax_code == true then
        return Tracker:FindObjectForCode("@JohtoKanto/Vermilion City/City").AccessibilityLevel
    else
        return false
    end
end

function toggleHints()
    print(dump_table(#SAVED_HINTS))
    if has("hint_tracking_off") then
        updatePokemon()
        resetHints()
    elseif has("hint_tracking_on") then
        updatePokemon()
        resetHints()
        updateHints()
    elseif has("hint_tracking_on_plus") then
        updatePokemon()
        updateHints()
    end
end

function resetHints()
    CLEARED_HINTS = {}
    for _, hint in ipairs(SAVED_HINTS) do
        if hint.finding_player == PLAYER_ID then
            local mapped = LOCATION_MAPPING[hint.location]
            local locations = (type(mapped) == "table") and mapped or { mapped }
    
            for _, location in ipairs(locations) do
                -- Only sections (items don't support Highlight)
                if location:sub(1, 1) == "@" then
                    local obj = Tracker:FindObjectForCode(location)
                    local final_value = obj.ChestCount
                    local cleared = CLEARED_LOCATIONS[location] or 0
                    final_value = final_value - cleared
                    obj.AvailableChestCount = final_value
                    obj.Highlight = 0
                end
            end
        end
    end
    
    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location and location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            obj.Highlight = 0
        end
    end
end

CLEARED_HINTS = {}
function updateHints()
    if not Highlight then return end
    if has("hint_tracking_off") then return end

    CLEARED_HINTS = {}

    local tracking_plus = has("hint_tracking_on_plus")

    for _, hint in ipairs(SAVED_HINTS) do
        if hint.finding_player == PLAYER_ID then
            local mapped = LOCATION_MAPPING[hint.location]
            local incoming_val = HIGHLIGHT_LEVEL[hint.item_flags]

            -- Special handling for Pokémon locations (10001–10251)
            if hint.location >= 10001 and hint.location <= 10251 then
                local poke_id = hint.location - 10000
                local poke_locations = POKEMON_TO_LOCATIONS[poke_id]

                if poke_locations then
                    for _, encounter_key in pairs(poke_locations) do
                        local mapped_location = ENCOUNTER_MAPPING[encounter_key]
                        if mapped_location and mapped_location:sub(1, 1) == "@" then
                            local obj = Tracker:FindObjectForCode(mapped_location)
    
                            if tracking_plus then
                                if incoming_val == 3 then
                                    obj.Highlight = incoming_val
                                end
                            else
                                local current_val = obj.Highlight
                                if current_val == nil or HIGHLIGHT_PRIORITY[incoming_val] < HIGHLIGHT_PRIORITY[current_val] then
                                    obj.Highlight = incoming_val
                                end
                            end
                        end
                    end
                end

                goto continue_hint
            end

            local locations = (type(mapped) == "table") and mapped or { mapped }

            for _, location in ipairs(locations) do
                if location:sub(1, 1) == "@" then
                    local obj = Tracker:FindObjectForCode(location)

                    if tracking_plus then
                        if incoming_val == 3 then
                            obj.Highlight = incoming_val
                        else
                            local current_total = CLEARED_HINTS[location] or 0
                            CLEARED_HINTS[location] = current_total + 1
                        end
                    else
                        local current_val = obj.Highlight
                        if current_val == nil or HIGHLIGHT_PRIORITY[incoming_val] < HIGHLIGHT_PRIORITY[current_val] then
                            obj.Highlight = incoming_val
                        end
                    end
                end
            end

            ::continue_hint::
        end
    end

    if tracking_plus then
        for location, count in pairs(CLEARED_HINTS) do
            local obj = Tracker:FindObjectForCode(location)
            local cleared = CLEARED_LOCATIONS[location] or 0
            obj.AvailableChestCount = obj.ChestCount - count - cleared
            if obj.AvailableChestCount == 0 then
                obj.Highlight = 0
            end
        end
    end

    for _, location in pairs(ENCOUNTER_MAPPING) do
        if location and location:sub(1, 1) == "@" then
            local obj = Tracker:FindObjectForCode(location)
            if obj and obj.AvailableChestCount == 0 then
                obj.Highlight = 0
            end
        end
    end
end


-- Store last map values
last_map_group = nil
last_map_number = nil

function onMap(value)
    if has("automap_on") and value ~= nil and value["data"] ~= nil then
        local slotdigit_1 = Tracker:FindObjectForCode("slotdigit_1").CurrentStage or 0
        local slotdigit_2 = Tracker:FindObjectForCode("slotdigit_2").CurrentStage or 0
        local slotdigit_3 = Tracker:FindObjectForCode("slotdigit_3").CurrentStage or 0
    
        local slot = slotdigit_1 * 100 + slotdigit_2 * 10 + slotdigit_3
        
        if (value["data"]["mapGroup_0"] ~= nil) or (value["data"]["mapGroup_"..slot] ~= nil) then

            local map_group = value["data"]["mapGroup_0"] or value["data"]["mapGroup_"..slot]
            local map_number = value["data"]["mapNumber_0"] or value["data"]["mapNumber_"..slot]
        
            -- This whole thing about SSAQUA exists to properly show west- or eastbound
            local ssaqua = Tracker:FindObjectForCode("ssaqua")
    
            -- Detect map transition logic
            if last_map_group == 15 and last_map_number == 1 and map_group == 15 and map_number == 3 then
                ssaqua.CurrentStage = 1
            elseif last_map_group == 15 and last_map_number == 2 and map_group == 15 and map_number == 3 then
                ssaqua.CurrentStage = 2
            end
    
            -- Check and possibly modify map_group based on conditions
            if map_group == 15 then
                if ssaqua.CurrentStage == 1 then
                    map_group = 115
                elseif ssaqua.CurrentStage == 2 then
                    map_group = 215
                end
            end
    
            -- Access correct mapping and activate tabs
            local tabs = MAP_MAPPING[map_group] and MAP_MAPPING[map_group][map_number]
            
            for i, tab in ipairs(tabs) do
                Tracker:UiHint("ActivateTab", tab)
            end
            
    
            -- Save last processed map
            last_map_group = value["data"]["mapGroup_0"] or value["data"]["mapGroup_"..slot]
            last_map_number = value["data"]["mapNumber_0"] or value["data"]["mapNumber_"..slot]
        end
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
Archipelago:AddBouncedHandler("map handler", onMap)

for _, code in ipairs(FLAG_STATIC_CODES) do
    ScriptHost:AddWatchForCode(code, code, updatePokemon)
end
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", function() updatePokemon() end)
