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

-- Rebuilds ER_CATEGORY_ENABLED (read by the CanReach detour) from the ER settings items,
-- then invalidates the CanReach cache. Runs when any ER category toggle changes (init.lua
-- watches) and after onClear sets them from slot_data.
function refreshERCategories()
    if not ER_CATEGORIES then
        return
    end
    ER_CATEGORY_ENABLED = ER_CATEGORY_ENABLED or {}
    for _, cat in ipairs(ER_CATEGORIES) do
        ER_CATEGORY_ENABLED[cat] = has("er_" .. cat .. "_on")
    end
    if InvalidateCanReach then
        InvalidateCanReach()
    end
end

-- Entrance randomization is per-category; there is no single ER on/off. The Route tab is
-- part of tabs_single.json. When you author additional tab variants (split/reverse/johto),
-- add a "Route" tab there too, or swap ER-specific tab layouts here.
function toggle_er()
    refreshERCategories()
end

function updateRemainingDexcountsanityChecks()
    Tracker.BulkUpdate = true
    local val = Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total").AvailableChestCount
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit1").CurrentStage = math.floor(val / 100)
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit2").CurrentStage = math.floor(val / 10) % 10
    Tracker:FindObjectForCode("dexcountsanity_remainingchecks_digit3").CurrentStage = val % 10
    Tracker.BulkUpdate = false
end

function showMonVisibility()
    local dexcountsanity = Tracker:FindObjectForCode("@ZDexsanity/Dexcountsanity/Total").AvailableChestCount
    local dexsanity = has("dexsanity")
    if dexcountsanity ~= 0 or dexsanity ~= false then
        Tracker:FindObjectForCode("visibility_mons").CurrentStage = 0
    end
end

function getDigits(code1, code2, code3)
    if code3 then
        return (Tracker:FindObjectForCode(code1).CurrentStage or 0) * 100
             + (Tracker:FindObjectForCode(code2).CurrentStage or 0) * 10
             + (Tracker:FindObjectForCode(code3).CurrentStage or 0)
    else
        return (Tracker:FindObjectForCode(code1).CurrentStage or 0) * 10
             + (Tracker:FindObjectForCode(code2).CurrentStage or 0)
    end
end

function makeDigits(value, code1, code2, code3)
    local val = tonumber(value) or 0
    if code3 then
        Tracker:FindObjectForCode(code1).CurrentStage = math.floor(val / 100)
        Tracker:FindObjectForCode(code2).CurrentStage = math.floor(val / 10) % 10
        Tracker:FindObjectForCode(code3).CurrentStage = val % 10
    else
        Tracker:FindObjectForCode(code1).CurrentStage = math.floor(val / 10)
        Tracker:FindObjectForCode(code2).CurrentStage = val % 10
    end
end
