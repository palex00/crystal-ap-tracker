function toggle_johto()
    local coffee = has("coffee_west") or has("coffee_north") or has("coffee_east") or has("coffee_south")
    local phone = has("phone_calls_visible")

    if has("johto_only_off") then
        Tracker:AddMaps("maps/maps_johto_and_kanto.json")
        Tracker:AddLayouts("layouts/overworld.json")

        if has("goal_e4") then
            Tracker:AddLayouts("layouts/events/events_e4.json")
        elseif has("goal_red") then
            Tracker:AddLayouts("layouts/events/events_red.json")
        elseif has("goal_diploma") then
            Tracker:AddLayouts("layouts/events/events_diploma.json")
        elseif has("goal_rival") then
            Tracker:AddLayouts("layouts/events/events_rival.json")
        elseif has("goal_rocket") then
            Tracker:AddLayouts("layouts/events/events_rocket.json")
        elseif has("goal_unown") then
            Tracker:AddLayouts("layouts/events/events_unown.json")
        end

        Tracker:AddLayouts("layouts/settings/settings.json")
        Tracker:AddLayouts("layouts/flyunlocks.json")

        if coffee and phone then
            Tracker:AddLayouts("layouts/items/items.json")
        elseif coffee and not phone then
            Tracker:AddLayouts("layouts/items/items_no_phone.json")
        elseif not coffee and not phone then
            Tracker:AddLayouts("layouts/items/items_no_to_both.json")
        elseif not coffee and phone then
            Tracker:AddLayouts("layouts/items/items_no_tea.json")
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

SUDOWOODO = false

local function add_map(name)
    Tracker:AddMaps("maps/"..(SUDOWOODO and "mischief/" or "")..name..".json")
end

function toggle_mischief()
    local sudowoodo = Tracker:FindObjectForCode("mischief").CurrentStage == 1 or Tracker:FindObjectForCode("chrism").CurrentStage == 1
    if sudowoodo == SUDOWOODO then
        return
    end
    SUDOWOODO = sudowoodo

    add_map("maps")
    toggle_ilex()
    toggle_route2()
    toggle_lakeofrage()
    toggle_darkcave()
    toggle_mountmortar()
    toggle_r12()
    toggle_victoryroad()
    toggle_floodedmine()
end

function toggle_ilex()
    local suffix = "_no_tree"

    if has("ilextree_on") then
        suffix = "_tree"
    end

    add_map("ilex_forest"..suffix)
end

function toggle_route2()
    local suffix = "_ledge"

    if has("route_2_fence") then
        suffix = "_fence"
    elseif has("route_2_open") then
        suffix = "_open"
    end

    add_map("route_2"..suffix)
end

function toggle_lakeofrage()
    local suffix = "_vanilla"

    if has("red_gyarados_whirlpool") then
        suffix = "_whirlpool"
    elseif has("red_gyarados_shore") then
        suffix = "_shore"
    end

    add_map("lake_of_rage"..suffix)
end

function toggle_darkcave()
    local suffix = "_vanilla"

    if has("blackthorn_dark_cave_waterfall") then
        suffix = "_waterfall"
    end

    add_map("blackthorn_dark_cave"..suffix)
end

function toggle_mountmortar()
    local suffix = "vanilla"

    if has("mount_mortar_access_rocksmash") then
        suffix = "rocksmash"
    end

    if has("route_42_access_whirlchanges") or has("route_42_access_blocked") then
        suffix = suffix.."_hole"
    end

    add_map("mm_"..suffix)

    suffix = ""

    if has("route_42_access_whirlpool") or has("route_42_access_whirlchanges") then
        suffix = "_whirl"
    elseif has("route_42_access_blocked") then
        suffix = "_blocked"
    end

    add_map("r42"..suffix)
end

function toggle_r12()
    local suffix = ""

    if has("route_12_access_weirdtree") then
        suffix = "_tree"
    end

    add_map("r12"..suffix)
end

function toggle_victoryroad()
    local suffix = "_vanilla"

    if has("victory_road_access_strength") then
        suffix = "_strength"
    end

    add_map("victory_road"..suffix)
end

function toggle_floodedmine()
    local suffix = "_off"

    if has("flooded_mine_on") then
        suffix = "_on"
    end

    add_map("floodedmine"..suffix)
end

function toggle_splitmap()
    local prefix = ""
    if not has("johto_only_off") then
        prefix = "johto_only/"
    end

    local suffix = "_single"
    if has("splitmap_on") then
        suffix = "_split"
    elseif has("splitmap_reverse") then
        suffix = "_reverse"
    end

    Tracker:AddLayouts("layouts/"..prefix.."tabs"..suffix..".json")
end

function toggle_itemgrid()
    local suffix = ""
    if has("randomize_fly_unlocks_true") then
        suffix = suffix .. "_flyunlock"
    end
    if has("shopsanity_bluecard_true") or has("shopsanity_apricorn_true") then
        suffix = suffix .. "_shopsanity"
    end
    if has("goal_unown") then
        suffix = suffix .. "_tiles"
    end

    Tracker:AddLayouts("layouts/tracker/tracker"..suffix..".json")

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
    if bluecard and apricorn then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_all.json")
    elseif bluecard then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_bluecard.json")
    elseif apricorn then
        Tracker:AddLayouts("layouts/shopsanity/shopsanity_apricorn.json")
    end
end

function toggleQuickSettings()
    local suffix = ""

    if SLOT_TRACK == true then
        suffix = suffix .. "_slots"
    end

    if has("goal_unown") then
        suffix = suffix .. "_signs"
    end

    if has("grasssanity_any") then
        suffix = suffix .. "_grass"
    end

    if has("shopsanity_anymart") then
        suffix = suffix .. "_shop"
    end

    Tracker:AddLayouts("layouts/settings_quick/settings_quick"..suffix..".json")
end

function updateGoalLayout()
    toggleQuickSettings()
    toggle_itemgrid()
end
