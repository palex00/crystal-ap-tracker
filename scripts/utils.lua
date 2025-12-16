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

function table_contains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end

function dump_table(o, depth)
    if depth == nil then
        depth = 0
    end

    local ignore_keys = {
        region_encounters = true,
        trainersanity = true,
        dexcountsanity_counts = true,
        dexsanity_pokemon = true,
        hm_compat = true,
        breeding_info = true,
        evolution_info = true,
    }

    if type(o) == 'table' then
        local tabs = ('\t'):rep(depth)
        local tabs2 = ('\t'):rep(depth + 1)
        local s = '{\n'
        for k, v in pairs(o) do
            local key_str = tostring(k)
            if not ignore_keys[key_str] then
                if type(k) ~= 'number' then
                    k = '"' .. k .. '"'
                end
                s = s .. tabs2 .. '[' .. k .. '] = ' .. dump_table(v, depth + 1) .. ',\n'
            end
        end
        return s .. tabs .. '}'
    else
        return tostring(o)
    end
end

function toggle_johto()
    local coffee = has("coffee_west") or has("coffee_north") or has("coffee_east") or has("coffee_south")
    local phone = has("phone_calls_visible")
    
    if has("johto_only_off") then
        Tracker:AddMaps("maps/maps_johto_and_kanto.json")
        Tracker:AddLayouts("layouts/overworld.json")
        
        if has("goal_e4") then
            Tracker:AddLayouts("layouts/events_e4.json")
        elseif has("goal_red") then
            Tracker:AddLayouts("layouts/events_red.json")
        elseif has("goal_diploma") then
            Tracker:AddLayouts("layouts/events_diploma.json")
        elseif has("goal_rival") then
            Tracker:AddLayouts("layouts/events_rival.json")
        elseif has("goal_rocket") then
            Tracker:AddLayouts("layouts/events_rocket.json")
        elseif has("goal_unown") then
            Tracker:AddLayouts("layouts/events_unown.json")
        end       
        
        Tracker:AddLayouts("layouts/settings.json")
        Tracker:AddLayouts("layouts/flyunlocks.json")
        
        if coffee and phone then
            Tracker:AddLayouts("layouts/items.json")
        elseif coffee and not phone then
            Tracker:AddLayouts("layouts/items_no_phone.json")
        elseif not coffee and not phone then
            Tracker:AddLayouts("layouts/items_no_to_both.json")
        elseif not coffee and phone then
            Tracker:AddLayouts("layouts/items_no_tea.json")
        end
    else
        local badges = has("badges_on")
        if badges and phone then
            Tracker:AddLayouts("layouts/johto_only/items.json")
        elseif not badges and phone then
            Tracker:AddLayouts("layouts/johto_only/items_no_kanto_badges.json")
        elseif badges and not phone then
            Tracker:AddLayouts("layouts/johto_only/items_no_phone.json")
        elseif not badges and not phone then
            Tracker:AddLayouts("layouts/johto_only/items_no_kanto_badges_and_no_phone.json")
        end
        
        Tracker:AddLayouts("layouts/johto_only/overworld.json")
        
        if has("goal_e4") then
            Tracker:AddLayouts("layouts/johto_only/events_e4.json")
        elseif has("goal_red") then
            Tracker:AddLayouts("layouts/johto_only/events_red.json")
        elseif has("goal_rival") then
            Tracker:AddLayouts("layouts/johto_only/events_rival.json")
        elseif has("goal_rocket") then
            Tracker:AddLayouts("layouts/johto_only/events_rocket.json")
        end

        if has("johto_only_on") then
            Tracker:AddMaps("maps/maps_johto_no_silver.json")
            Tracker:AddLayouts("layouts/johto_only/flyunlocks_no_silver.json")
            Tracker:AddLayouts("layouts/johto_only/settings_johto_no_silver.json")
        elseif has("johto_only_silver") then
            Tracker:AddMaps("maps/maps_johto_only.json")
            Tracker:AddLayouts("layouts/johto_only/flyunlocks.json")
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
    elseif has("red_gyarados_shore") and sudowoodo then
        Tracker:AddMaps("maps/mischief/lake_of_rage_shore.json")
    elseif has("red_gyarados_shore") and not sudowoodo then
        Tracker:AddMaps("maps/lake_of_rage_shore.json")
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

function toggle_mountmortar()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    prefix = ""
    suffix = ""
    
    if sudowoodo then
        prefix = "mischief/"
    end
    
    if has("mount_mortar_access_vanilla") then
        suffix = "vanilla"
    elseif has("mount_mortar_access_rocksmash") then
        suffix = "rocksmash"
    end
    
    if has("route_42_access_whirlchanges") or has("route_42_access_blocked") then
        suffix = suffix.."_hole"
    end
    
    Tracker:AddMaps("maps/"..prefix.."mm_"..suffix..".json")
    
    suffix = ""
    
    if has("route_42_access_whirlpool") or has("route_42_access_whirlchanges") then
        suffix = "_whirl"
    elseif has("route_42_access_blocked") then
        suffix = "_blocked"
    end
    
    Tracker:AddMaps("maps/"..prefix.."r42"..suffix..".json")
end

function toggle_r12()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    prefix = ""
    suffix = ""
    
    if sudowoodo then
        prefix = "mischief/"
    end
    
    if has("route_12_access_weirdtree") then
        suffix = "_tree"
    end

    Tracker:AddMaps("maps/"..prefix.."r12"..suffix..".json")
end

function toggle_victoryroad()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1 
    if has("victory_road_access_vanilla") and not sudowoodo then
        Tracker:AddMaps("maps/victory_road_vanilla.json")
    elseif has("victory_road_access_strength") and not sudowoodo then
        Tracker:AddMaps("maps/victory_road_strength.json")
    elseif has("victory_road_access_vanilla") and sudowoodo then
        Tracker:AddMaps("maps/mischief/victory_road_vanilla.json")
    elseif has("victory_road_access_strength") and sudowoodo then
        Tracker:AddMaps("maps/mischief/victory_road_strength.json")
    end
end

function toggle_splitmap()
    if has("splitmap_off") and has("johto_only_off") then
        Tracker:AddLayouts("layouts/tabs_single.json")
    elseif has("splitmap_on") and has("johto_only_off") then
        Tracker:AddLayouts("layouts/tabs_split.json")
    elseif has("splitmap_reverse") and has("johto_only_off") then
        Tracker:AddLayouts("layouts/tabs_reverse.json")
    elseif has("splitmap_off") then
        Tracker:AddLayouts("layouts/johto_only/tabs_single.json")
    elseif has("splitmap_on") then
        Tracker:AddLayouts("layouts/johto_only/tabs_split.json")
    elseif has("splitmap_reverse") then
        Tracker:AddLayouts("layouts/johto_only/tabs_reverse.json")
    end
end

function toggle_itemgrid()
    local shops = has("shopsanity_bluecard_true") or has("shopsanity_apricorn_true")
    
    local suffix = ""
    if has("randomize_fly_unlocks_true") then
        suffix = suffix .. "_flyunlock"
    end
    if shops then
        suffix = suffix .. "_shopsanity"
    end
    if has("goal_unown") then
        suffix = suffix .. "_tiles"
    end
        
    Tracker:AddLayouts("layouts/tracker"..suffix..".json")
    
    local prefix = ""
    if has("broadcast_view_vertical") then
        prefix = "vertical_"
    end
    
    Tracker:AddLayouts("layouts/broadcast/"..prefix.."broadcast"..suffix..".json")
    
    toggle_shopgrid()
end

function toggle_shopgrid()
    local bluecard = has("shopsanity_bluecard_true")
    local apricorn = has("shopsanity_apricorn_true")
    if bluecard and not apricorn then
        Tracker:AddLayouts("layouts/shopsanity_bluecard.json")
    elseif not bluecard and apricorn then
        Tracker:AddLayouts("layouts/shopsanity_apricorn.json")
    elseif bluecard and apricorn then
        Tracker:AddLayouts("layouts/shopsanity_all.json")
    end
end

function updateRemainingDexcountsanityChecks()
    local val = Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total").AvailableChestCount
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit1").CurrentStage = math.floor(val / 100)
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit2").CurrentStage = math.floor(val / 10) % 10
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit3").CurrentStage = val % 10
end

function showMonVisibility()
    local dexcountsanity = Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total").AvailableChestCount
    local dexsanity = has("dexsanity")
    if dexcountsanity ~= 0 or dexsanity ~= false then
        Tracker:FindObjectForCode("location_visibility").CurrentStage = 1
    end
end