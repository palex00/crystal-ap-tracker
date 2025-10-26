ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
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
POKE_ID = ""
EVOLUTION_DATA = ""
BREEDING_DATA = ""

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
    for i = 296, 302 do
        local obj = Tracker:FindObjectForCode("trainersanity_" .. i)
        obj.Active = false
    end
    Tracker:FindObjectForCode("trainersanity_1702").Active = false -- literally just Eusine the fucker.


    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    print(dump_table(slot_data))
    
    for k, v in pairs(slot_data) do
        if slot_data["johto_only"] ~= nil then
            if  k == "apworld_version" then
                local version_str = tostring(v)
                local first_two_dots = version_str:match("^([^.]+%.[^.]+)%.")
                if first_two_dots == "5.2" or nil then
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
            for _, value in ipairs(v) do
                Tracker:FindObjectForCode("trainersanity_" .. value).Active = true
            end
            if #v == 0 then
                TRAINERS:setType("none")
            elseif #v == 372 and has("johto_only_off") then
                TRAINERS:setType("full")
            elseif #v == 242 and (has("johto_only_on") or has("johto_only_silver")) then
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
        
        POKE_ID="pokemon_crystal_pokemon_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({POKE_ID})
        Archipelago:Get({POKE_ID})
    end

    toggle_itemgrid()
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
        if v == "BLUE_CARD_POINT" then
            obj.AcquiredCount = obj.AcquiredCount + 1
        else
            obj.Active = true
        end
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
        elseif key == EVENT2_ID then
            updateEvents2(value)
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
        elseif key == EVENT2_ID then
            updateEvents2(value)
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

function updateEvents2(value)
    if value ~= nil then
        for i, code in ipairs(FLAG_EVENT_2_CODES) do
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
        --print(string.format("updatePokemon: Pokemon - %s", dump_table(pokemon)))
		for dex_number, code in pairs(POKEMON_MAPPING) do
			if table_contains(pokemon["caught"], dex_number) then
				Tracker:FindObjectForCode(code).Active = true
			else
				Tracker:FindObjectForCode(code).Active = false
			end
		end
        
		if has("encounter_tracking_strict") or has("encounter_tracking_loose") then
            resetEvolutionsanityData()
            updateEvolutionInfo(pokemon)
            updateBreedingInfo(pokemon)
            
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
                elseif is_seen and (dexloc.Active or not dexcode.Active) and has("encounter_tracking_loose") then
                    should_decrement = true
                end

                if should_decrement then
                   for _, location in pairs(locations) do
                        local object_name = ENCOUNTER_MAPPING[location]
                        if object_name ~= nil then
                            local object = Tracker:FindObjectForCode(object_name)
                            if object then
                                if string.sub(location, 1, 7):lower() == "static_" then
                                    local event_code = Tracker:FindObjectForCode(location)
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

function resetEvolutionsanityData()
    for _, evo_string in pairs(EVO_LOC_MAPPING) do
        local breed_loc = Tracker:FindObjectForCode("@Breeding/Breed " .. evo_string.. "/Breed ".. evo_string)
        if breed_loc then
            breed_loc.AvailableChestCount = 1
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


function updateEvolutionInfo(pokemon)
    if not pokemon.caught then
        return
    end

    for _, caught_id in pairs(pokemon.caught) do
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

function updateBreedingInfo(pokemon)
    if not pokemon.caught then
        return
    end

    for first_id, second_id in pairs(BREEDING_DATA) do
        for _, caught_id in pairs(pokemon.caught) do
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

ScriptHost:AddWatchForCode("Sudowoodo", "Static_Sudowoodo", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RedGyarados", "Static_RedGyarados", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Ho_Oh", "Static_Ho_Oh", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Lugia", "Static_Lugia", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Suicune", "Static_Suicune", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQElectrode1", "Static_RocketHQElectrode1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQElectrode2", "Static_RocketHQElectrode2", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQElectrode3", "Static_RocketHQElectrode3", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQTrap1", "Static_RocketHQTrap1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQTrap2", "Static_RocketHQTrap2", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_RocketHQTrap3", "Static_RocketHQTrap3", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Shuckie", "Static_Shuckie", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Eevee", "Static_Eevee", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Dratini", "Static_Dratini", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Tyrogue", "Static_Tyrogue", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_UnionCaveLapras", "Static_UnionCaveLapras", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_Celebi", "Static_Celebi", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_GoldenrodGameCorner1", "Static_GoldenrodGameCorner1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_GoldenrodGameCorner2", "Static_GoldenrodGameCorner2", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_GoldenrodGameCorner3", "Static_GoldenrodGameCorner3", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_CeladonGameCornerPrizeRoom1", "Static_CeladonGameCornerPrizeRoom1", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_CeladonGameCornerPrizeRoom2", "Static_CeladonGameCornerPrizeRoom2", function() updatePokemon() end)
ScriptHost:AddWatchForCode("Static_CeladonGameCornerPrizeRoom3", "Static_CeladonGameCornerPrizeRoom3", function() updatePokemon() end)
ScriptHost:AddWatchForCode("encounter_tracking", "encounter_tracking", function() updatePokemon() end)