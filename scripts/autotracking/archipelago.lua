ScriptHost:LoadScript("scripts/autotracking/item_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/location_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/map_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/flag_mapping.lua")
ScriptHost:LoadScript("scripts/autotracking/ap_helper.lua")

BASE_OFFSET = 7680000

CUR_INDEX = -1
PLAYER_ID = -1
TEAM_NUMBER = 0

EVENT_ID=""
KEY_ID=""

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
	
	print(dump_table(slot_data))

	for k,v in pairs(slot_data) do
		if SLOT_CODES[k] then
			Tracker:FindObjectForCode(SLOT_CODES[k].code).CurrentStage = SLOT_CODES[k].mapping[v]
		else
			if k == "elite_four_badges" then
				Tracker:FindObjectForCode("e4_badges").AcquiredCount = v
			end 
			if k == "red_badges" then
				Tracker:FindObjectForCode("red_badges").AcquiredCount = v
			end
			if k == "radio_tower_badges" then
				Tracker:FindObjectForCode("tower_badges").AcquiredCount = v
			end
		end
	end

	if PLAYER_ID>-1 then
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
		--print(string.format("onItem: could not find item mapping for id %s", item_id))
		return
	end
	local obj = Tracker:FindObjectForCode(v)
	if obj then
		obj.Active = true
	else
		--print(string.format("onItem: could not find object for code %s", v[1]))
	end
end

--called when a location gets cleared
function onLocation(location_id, location_name)
	local v = LOCATION_MAPPING[reverse_offset(location_id)]
	if not v then
		print(string.format("onLocation: could not find location mapping for id %s", location_id))
		return
	end
	local obj = Tracker:FindObjectForCode(v)
	if obj then
		obj.AvailableChestCount = 0
	else
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
			if #code>0 then
				Tracker:FindObjectForCode(code).Active = Tracker:FindObjectForCode(code).Active or bit
			end
		end
	end
end

function updateVanillaKeyItems(value) 
	if value ~= nil then
		--print(value)
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

function onMap(value)
	if has("automap_on") and value ~= nil and value["data"] ~= nil then
		map_group = value["data"]["mapGroup"]
		map_number = value["data"]["mapNumber"]
		tabs = MAP_MAPPING[map_group][map_number]
		for i, tab in ipairs(tabs) do
			Tracker:UiHint("ActivateTab", tab)
		end
	end
end


Archipelago:AddClearHandler("clear handler", onClear)
Archipelago:AddItemHandler("item handler", onItem)
Archipelago:AddLocationHandler("location handler", onLocation)
Archipelago:AddSetReplyHandler("notify handler", onNotify)
Archipelago:AddRetrievedHandler("notify launch handler", onNotifyLaunch)
Archipelago:AddBouncedHandler("map handler", onMap)
