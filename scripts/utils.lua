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

function has_value(t, val)
	for i, v in ipairs(t) do
		if v == val then return 1 end
	end
	return 0
end

function has(item, amount)
	local count = Tracker:ProviderCountForCode(item)
	amount = tonumber(amount)
	if not amount then
		return count > 0
	else
		return count >= amount
	end
end

function progCount(code)
	return Tracker:FindObjectForCode(code).AcquiredCount
end

function dump_table(o, depth)
	if depth == nil then
		depth = 0
	end
	if type(o) == 'table' then
		local tabs = ('\t'):rep(depth)
		local tabs2 = ('\t'):rep(depth + 1)
		local s = '{\n'
		for k, v in pairs(o) do
			if type(k) ~= 'number' then
				k = '"' .. k .. '"'
			end
			s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
		end
		return s .. tabs .. '}'
	else
		return tostring(o)
	end
end


function toggle_johto(code)
    if has("johto_only_off") then
        Tracker:AddMaps("maps/maps.json")
        Tracker:AddLayouts("layouts/items.json")
        Tracker:AddLayouts("layouts/events.json")
        Tracker:AddLayouts("layouts/tabs.json")
    else
        Tracker:AddLayouts("layouts/johto_only/items.json")
        Tracker:AddLayouts("layouts/johto_only/events.json")
        Tracker:AddLayouts("layouts/johto_only/tabs_johto.json")
        if has("johto_only_on") then
            Tracker:AddMaps("maps/maps_johto_no_silver.json")
        elseif has("johto_only_silver") then
            Tracker:AddMaps("maps/maps_johto_only.json")
        end
    end
end