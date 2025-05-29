function has_value(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return 1
        end
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

function toggle_johto()
    local coffee = has("coffee_west") or has("coffee_north") or has("coffee_east") or has("coffee_south")
    if has("johto_only_off") then
        Tracker:AddMaps("maps/maps_johto_and_kanto.json")
        Tracker:AddLayouts("layouts/overworld.json")
        Tracker:AddLayouts("layouts/settings.json")
        Tracker:AddLayouts("layouts/events.json")
        if coffee then
            Tracker:AddLayouts("layouts/items.json")
        else
            Tracker:AddLayouts("layouts/items_no_tea.json")      
        end
    else
        if has("badges_on") then
            Tracker:AddLayouts("layouts/johto_only/items.json")
        else
            Tracker:AddLayouts("layouts/johto_only/items_no_kanto_badges.json")
        end
        
        Tracker:AddLayouts("layouts/johto_only/overworld.json")
        Tracker:AddLayouts("layouts/johto_only/events.json")

        if has("johto_only_on") then
            Tracker:AddMaps("maps/maps_johto_no_silver.json")
            Tracker:AddLayouts("layouts/johto_only/settings_johto_no_silver.json")
        elseif has("johto_only_silver") then
            Tracker:AddMaps("maps/maps_johto_only.json")
            Tracker:AddLayouts("layouts/johto_only/settings_johto_with_silver.json")
        end
    end
    toggle_splitmap()
end

function toggle_ilex()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    if has("ilextree_on") and not sudowoodo then
        Tracker:AddMaps("maps/ilex_forest_tree.json")
    elseif has("ilextree_on") and sudowoodo then
        Tracker:AddMaps("maps/mischief/ilex_forest_tree.json")
    elseif has("ilextree_off") and not sudowoodo then
        Tracker:AddMaps("maps/ilex_forest_no_tree.json")
    elseif has("ilextree_off") and sudowoodo then
        Tracker:AddMaps("maps/mischief/ilex_forest_no_tree.json")
    end
end

function toggle_mischief()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1
    if sudowoodo then
        print("Applying Mischief...")
        Tracker:AddMaps("maps/mischief/maps.json")
        Tracker:AddMaps("maps/mischief/ilex_forest_no_tree.json")
    else
        Tracker:AddMaps("maps/maps.json")
        toggle_ilex()
    end
end

function toggle_route2()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    if has("route_2_fence") and not sudowoodo then
        Tracker:AddMaps("maps/route_2_fence.json")
    elseif has("route_2_ledge") and not sudowoodo then
        Tracker:AddMaps("maps/route_2_ledge.json")
    elseif has("route_2_open") and not sudowoodo then
        Tracker:AddMaps("maps/route_2_open.json")
    elseif has("route_2_fence") and sudowoodo then
        Tracker:AddMaps("maps/mischief/route_2_fence.json")
    elseif has("route_2_ledge") and sudowoodo then
        Tracker:AddMaps("maps/mischief/route_2_ledge.json")
    elseif has("route_2_open") and sudowoodo then
        Tracker:AddMaps("maps/mischief/route_2_open.json")
    end
end

function toggle_lakeofrage()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    if has("red_gyarados_vanilla") and not sudowoodo then
        Tracker:AddMaps("maps/lake_of_rage_vanilla.json")
    elseif has("red_gyarados_whirlpool") and not sudowoodo then
        Tracker:AddMaps("maps/lake_of_rage_whirlpool.json")
    elseif has("red_gyarados_vanilla") and sudowoodo then
        Tracker:AddMaps("maps/mischief/lake_of_rage_vanilla.json")
    elseif has("red_gyarados_whirlpool") and sudowoodo then
        Tracker:AddMaps("maps/mischief/lake_of_rage_whirlpool.json")
    end
end

function toggle_darkcave()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    if has("blackthorn_dark_cave_vanilla") and not sudowoodo then
        Tracker:AddMaps("maps/blackthorn_dark_cave_vanilla.json")
    elseif has("blackthorn_dark_cave_waterfall") and not sudowoodo then
        Tracker:AddMaps("maps/blackthorn_dark_cave_waterfall.json")
    elseif has("blackthorn_dark_cave_vanilla") and sudowoodo then
        Tracker:AddMaps("maps/mischief/blackthorn_dark_cave_vanilla.json")
    elseif has("blackthorn_dark_cave_waterfall") and sudowoodo then
        Tracker:AddMaps("maps/mischief/blackthorn_dark_cave_waterfall.json")
    end
end

function toggle_splitmap()
    if has("splitmap_off") and has("johto_only_off") then
        Tracker:AddLayouts("layouts/tabs_single.json")
    elseif has("splitmap_on") and has("johto_only_off") then
        Tracker:AddLayouts("layouts/tabs_split.json")
    elseif has("splitmap_off") then
        Tracker:AddLayouts("layouts/johto_only/tabs_single.json")
    elseif has("splitmap_on") then
        Tracker:AddLayouts("layouts/johto_only/tabs_split.json")
    end
end