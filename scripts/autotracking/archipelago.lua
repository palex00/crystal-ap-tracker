ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/ap_helper.lua")

BASE_OFFSET = 7680000

CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0

EVENT_ID = ""
KEY_ID = ""

function reverse_offset(id)
    if id >= BASE_OFFSET then
        return id - BASE_OFFSET
    end
    return id
end

function onClear(slot_data)
    CUR_INDEX = -1
    resetLocations()
    resetItems()

    if slot_data == nil then
        print("its fucked")
        return
    end

    PLAYER_ID = Archipelago.PlayerNumber or -1
    TEAM_NUMBER = Archipelago.TeamNumber or 0

    --print(dump_table(slot_data))

    for k, v in pairs(slot_data) do
        if  k == "apworld_version" then
            local version_str = tostring(v)
            local first_two_dots = version_str:match("^([^.]+%.[^.]+)%.")
            if first_two_dots == "3.2" or nil then
                Tracker:AddLayouts("layouts/tracker.json")
            else
                Tracker:AddLayouts("layouts/versionmismatch.json")
            end
        elseif SLOT_CODES[k] then
            Tracker:FindObjectForCode(SLOT_CODES[k].code).CurrentStage = SLOT_CODES[k].mapping[v]
            -- print("Setting " .. k .. " to " .. v)
        elseif REQUIREMENT_CODES[k] then
			local item = SLOT_CODES[k].item
			item:setType(SLOT_CODES[k].mapping[v])
		elseif AMOUNT_CODES[k] then
			local item = SLOT_CODES[k].item
			item:setStage(v)
        elseif k == "hiddenitems" then
        -- hiddenitems are handled specially because this sets it to Active / Inactive
        -- because I merged hiddenitems and itemfinder logic into one item
            if v == 0 then
                Tracker:FindObjectForCode(k).Active = false
            elseif v == 1 then
                Tracker:FindObjectForCode(k).Active = true
            end
        else
            print(string.format("No setting could be found for key: %s", k))
        end
    end

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

        KEY_ID="pokemon_crystal_keys_"..TEAM_NUMBER.."_"..PLAYER_ID
        Archipelago:SetNotify({KEY_ID})
        Archipelago:Get({KEY_ID})
    end
end

function onItem(index, item_id, item_name, player_number)
    if index <= CUR_INDEX then
        return
    end
    CUR_INDEX = index;
    local v = ITEM_MAPPING[reverse_offset(item_id)]
    if not v then
        -- print(string.format("onItem: could not find item mapping for id %s", item_id))
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
    local v = LOCATION_MAPPING[reverse_offset(location_id)]
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
end

function onNotify(key, value, old_value)
    if key == EVENT_ID then
        updateEvents(value)
    elseif key == KEY_ID then
        updateVanillaKeyItems(value)
    end
end

function onNotifyLaunch(key, value)
    if key == EVENT_ID then
        updateEvents(value)
    elseif key == KEY_ID then
        updateVanillaKeyItems(value)
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
                Tracker:FindObjectForCode(code).Active = Tracker:FindObjectForCode(code).Active or bit
            end
        end
    end
end


function updateVanillaKeyItems(value)
    if value ~= nil then
        -- print(value)
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
        if tabs then
            for i, tab in ipairs(tabs) do
                -- Optional check: only activate tabs if conditions are met
                if ssaqua.CurrentStage ~= nil and fast_ship_event.Active == true then
                    Tracker:UiHint("ActivateTab", tab)
                elseif fast_ship_event.Active == false then
                    Tracker:UiHint("ActivateTab", tab)
                end
            end
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