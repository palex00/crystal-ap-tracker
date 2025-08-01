ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/encounter_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/pokemon_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/ap_helper.lua")

CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0

EVENT_ID = ""
KEY_ID = ""
POKE_ID = ""

function onClear(slot_data)
    isUpdating = true
    CUR_INDEX = -1
    resetLocations()
    resetItems()
    -- this resets trainer visibility. It will cause some "cannot find object"-errors
    -- but I am not willing to make yet another list that is just a list.
    for i = 1039, 1522 do
        local obj = Tracker:FindObjectForCode("trainersanity_" .. i)
        if obj then
            obj.Active = false
        end
    end

    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    print(dump_table(slot_data))
    
    for k, v in pairs(slot_data) do
        if slot_data["johto_only"] ~= nil then
            if  k == "apworld_version" then
                local version_str = tostring(v)
                local first_two_dots = version_str:match("^([^.]+%.[^.]+)%.")
                if first_two_dots == "4.0" or nil then
                    Tracker:AddLayouts("layouts/tracker.json")
                else
                    Tracker:AddLayouts("layouts/versionmismatch.json")
                end
            end
        else
            Tracker:AddLayouts("layouts/not_crystal.json")
        end            
    end


    POKEMON_TO_LOCATIONS = {}
    for location, dex_list in pairs(slot_data["region_encounters"]) do
        for _, dex_number in pairs(dex_list) do
            if POKEMON_TO_LOCATIONS[dex_number] == nil then
                POKEMON_TO_LOCATIONS[dex_number] = {}
            end
            table.insert(POKEMON_TO_LOCATIONS[dex_number], location)
        end
    end
    
    -- This sets each Encounter location to however many unique encounters there are in it
    for region_key, location in pairs(ENCOUNTER_MAPPING) do
        local object = Tracker:FindObjectForCode(location)
        object.AvailableChestCount = #slot_data.region_encounters[region_key]
    end
    
    REGION_ENCOUNTERS = slot_data.region_encounters

    for k, v in pairs(slot_data) do
        if SLOT_CODES[k] then
            Tracker:FindObjectForCode(SLOT_CODES[k].code).CurrentStage = SLOT_CODES[k].mapping[v]
        elseif REQUIREMENT_CODES[k] then
			local item = REQUIREMENT_CODES[k].item
			item:setType(REQUIREMENT_CODES[k].mapping[v])
		elseif AMOUNT_CODES[k] then
			local item = AMOUNT_CODES[k].item
			item:setStage(v)
        elseif k == "trainersanity" then
            for _, value in ipairs(v) do
                Tracker:FindObjectForCode("trainersanity_" .. value).Active = true
            end
            if #v == 0 then
                TRAINERS:setType("none")
            elseif #v == 340 then
                TRAINERS:setType("full")
            else
                TRAINERS:setType("partial")
                TRAINERS:setStage(#v)
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
        else
            -- print(string.format("No setting could be found for key: %s", k))
        end
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
        EVENT_ID="pokemon_crystal_events_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({EVENT_ID})
        Archipelago:Get({EVENT_ID})
        
        STATIC_ID="pokemon_crystal_statics_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({STATIC_ID})
        Archipelago:Get({STATIC_ID})

        ROCKETTRAP_ID="pokemon_crystal_rockettraps_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({ROCKETTRAP_ID})
        Archipelago:Get({ROCKETTRAP_ID})
        
        KEY_ID="pokemon_crystal_keys_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({KEY_ID})
        Archipelago:Get({KEY_ID})
        
        POKE_ID="pokemon_crystal_pokemon_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({POKE_ID})
        Archipelago:Get({POKE_ID})
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
    local obj = Tracker:FindObjectForCode(v)
    if obj then
        obj.Active = true
    else
        print(string.format("onItem: could not find object for code %s", v[1]))
    end
end

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
        elseif key == STATIC_ID then
            updateStatics(value)
        elseif key == KEY_ID then
            updateVanillaKeyItems(value)
        elseif key == POKE_ID then
            last_pokemon = value
            updatePokemon(value)
        elseif key == ROCKETTRAP_ID then
            updateRocketTraps(value)
        end
    end
end

function onNotifyLaunch(key, value)
    if value ~= nil and value ~= 0 then
        if key == EVENT_ID then
            updateEvents(value)
        elseif key == STATIC_ID then
            updateStatics(value)
        elseif key == KEY_ID then
            updateVanillaKeyItems(value)
        elseif key == POKE_ID then
            last_pokemon = value
            updatePokemon(value)
        elseif key == ROCKETTRAP_ID then
            updateRocketTraps(value)
        end
    end
end

function updateEvents(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_CODES) do
            local obj = Tracker:FindObjectForCode(code)
            if obj ~= nil then
                obj.Active = false
            end
            local bit = value >> (i - 1) & 1
            if #code > 0 then
                local obj = Tracker:FindObjectForCode(code)
                obj.Active = obj.Active or bit == 1
            end
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

function updatePokemon(pokemon)
    pokemon = pokemon or last_pokemon
    
	if pokemon ~= nil then
		if AUTOTRACKER_ENABLE_DEBUG_LOGGING_AP then
            print(string.format("updatePokemon: Pokemon - %s", dump_table(pokemon)))
		end
		for dex_number, code in pairs(POKEMON_MAPPING) do
			if table_contains(pokemon["caught"], dex_number) then
				Tracker:FindObjectForCode(code).Active = true
			else
				Tracker:FindObjectForCode(code).Active = false
			end
		end
        
		if has("encounter_tracking_strict") or has("encounter_tracking_loose") then
            for region_key, location in pairs(ENCOUNTER_MAPPING) do
                local object = Tracker:FindObjectForCode(location)
                object.AvailableChestCount = #REGION_ENCOUNTERS[region_key]
            end
            
            local dexcountsanity = Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total")

            for dex_number, locations in pairs(POKEMON_TO_LOCATIONS) do
                local code = Tracker:FindObjectForCode(POKEMON_MAPPING[dex_number])
                local dexcode = Tracker:FindObjectForCode("dexsanity_" .. dex_number)
                local dexloc = Tracker:FindObjectForCode("dexsanity_"..POKEMON_MAPPING[dex_number])
                
                local is_caught = table_contains(pokemon["caught"], dex_number)
                local is_seen = table_contains(pokemon["seen"], dex_number)

                if has("all_pokemon_seen_true") then
                    is_seen = true
                end
                
                local should_decrement = false

                if is_caught then
                    should_decrement = true
                elseif is_seen and (dexloc.Active or not dexcode.Active) then
                    if (dexcountsanity and dexcountsanity.AvailableChestCount == 0) or has("encounter_tracking_loose") then
                        should_decrement = true
                    end
                end

                if should_decrement then
                   for _, location in pairs(locations) do
                        local object_name = ENCOUNTER_MAPPING[location]
                        if object_name ~= nil then
                            local object = Tracker:FindObjectForCode(object_name)
                            if object then
                                if string.sub(location, 1, 7):lower() == "static_" then
                                    local event_name = string.sub(location, 8)
                                    local event_code = Tracker:FindObjectForCode(event_name)
                                    if event_code and event_code.Active then
                                        object.AvailableChestCount = object.AvailableChestCount - 1
                                    end
                                else
                                    object.AvailableChestCount = object.AvailableChestCount - 1
                                end
                            end
                        end
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
        return Tracker:FindObjectForCode("@JohtoKanto/Vermilion City").AccessibilityLevel
    else
        return false
    end
end


-- Store last map values
last_map_group = nil
last_map_number = nil

function onMap(value)
    if has("automap_on") and value ~= nil and value["data"] ~= nil then
        local map_group = value["data"]["mapGroup"]
        local map_number = value["data"]["mapNumber"]
        
        -- Detect map transition logic
        if last_map_group == 15 and last_map_number == 1 and map_group == 15 and map_number == 3 then
            Tracker:FindObjectForCode("ssaqua").CurrentStage = 1
        elseif last_map_group == 15 and last_map_number == 2 and map_group == 15 and map_number == 3 then
            Tracker:FindObjectForCode("ssaqua").CurrentStage = 2
        end

        -- Retrieve ssaqua and event state
        local ssaqua = Tracker:FindObjectForCode("ssaqua")

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
        last_map_group = value["data"]["mapGroup"]
        last_map_number = value["data"]["mapNumber"]
    end
end

Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
Archipelago:AddBouncedHandler("map handler", onMap)


--for _, code in ipairs(FLAG_STATIC_CODES) do
--    ScriptHost:AddWatchForCode(code, code, updatePokemon)
--end

ScriptHost:AddWatchForCode("Sudowoodo_1", "Sudowoodo_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RedGyarados_1", "RedGyarados_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Ho_Oh_1", "Ho_Oh_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Lugia_1", "Lugia_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Suicune_1", "Suicune_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQElectrode1_1", "RocketHQElectrode1_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQElectrode2_1", "RocketHQElectrode2_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQElectrode3_1", "RocketHQElectrode3_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQTrap1_1", "RocketHQTrap1_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQTrap2_1", "RocketHQTrap2_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("RocketHQTrap3_1", "RocketHQTrap3_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Shuckie_1", "Shuckie_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Eevee_1", "Eevee_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Dratini_1", "Dratini_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Tyrogue_1", "Tyrogue_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("UnionCaveLapras_1", "UnionCaveLapras_1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Celebi_1", "Celebi_1", function() updatePokemon() end)