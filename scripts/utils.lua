function has_value(t, val)
    for i, v in ipairs(t) do
        if v == val then
            return 1
        end
    end
    return 0
end

-- Persistent per-code count cache for logic. PopTracker wipes its own _providerCountCache on
-- EVERY state change, so Tracker:ProviderCountForCode re-scans all LuaItems for each code on
-- each toggle -- fatal now that 856 entrance LuaItems are in that scan. We memoize the exact
-- count here and invalidate ONLY the changed code via a per-code watch registered lazily on
-- first use, so a toggle drops just the codes it actually touched. Semantics are identical to
-- Tracker:ProviderCountForCode (unlike FindObjectForCode.AcquiredCount, which misreads the
-- per-stage _on/_off setting codes).
--
-- DERIVED CODES: a code whose provider is a custom LuaItem that computes its value from OTHER
-- items (e4_requirement/route_44_requirement/... read badges()/gyms(); kanto_access_condition
-- reads clear_snorlax() etc). Clearing a gym emits onStateChanged for EVENT_BEAT_* only, so the
-- watch on route_44_requirement never fires and its cached count would stay stale forever.
-- (PopTracker dodges this by refusing to cache such codes at all -- _indirectlyConnectedLuaCodes.)
-- We instead learn the dependencies: any LogicCount that happens WHILE another code is being
-- resolved is an input to that code, so when the input changes we drop everything derived from it.
LOGIC_COUNTS = LOGIC_COUNTS or {}
LOGIC_COLD_RESOLVES = LOGIC_COLD_RESOLVES or 0 -- count of cold misses; the warm pass budgets on this
local logic_count_watched = {}
local resolving = {}  -- stack of codes currently being resolved
local resolving_n = 0
local derived_from = {} -- input code -> set of codes computed from it

local function invalidateDerived(code, seen)
    local set = derived_from[code]
    if not set then
        return
    end
    seen = seen or {}
    for derived in pairs(set) do
        if not seen[derived] then
            seen[derived] = true
            LOGIC_COUNTS[derived] = nil -- lazy: only a handful, re-resolved on next read
            invalidateDerived(derived, seen)
        end
    end
end

-- Resolve a code for real, with the stack pushed so any nested LogicCount registers as an input.
local function resolveCode(code)
    resolving_n = resolving_n + 1
    resolving[resolving_n] = code
    local count = Tracker:ProviderCountForCode(code)
    resolving[resolving_n] = nil
    resolving_n = resolving_n - 1
    return count
end

function LogicCount(code)
    if resolving_n > 0 then
        local parent = resolving[resolving_n]
        if parent ~= code then
            local set = derived_from[code]
            if not set then
                set = {}
                derived_from[code] = set
            end
            set[parent] = true
        end
    end
    local count = LOGIC_COUNTS[code]
    if count == nil then
        count = resolveCode(code)
        LOGIC_COUNTS[code] = count
        LOGIC_COLD_RESOLVES = LOGIC_COLD_RESOLVES + 1
        if not logic_count_watched[code] then
            logic_count_watched[code] = true
            ScriptHost:AddWatchForCode("logiccount_" .. code, code, function()
                -- Re-resolve eagerly HERE (each watch callback is its own Lua call with its own
                -- instruction budget) instead of clearing and re-resolving inside the next
                -- flood-fill. A batch that changes N codes at once then costs N separate
                -- one-code scans rather than one flood-fill doing N cold scans in a single call.
                LOGIC_COUNTS[code] = resolveCode(code)
                invalidateDerived(code)
                if InvalidateCanReach then InvalidateCanReach() end
            end)
        end
    end
    return count
end

-- PopTracker dispatches watch callbacks in REGISTRATION order, and the per-code watches above are
-- registered lazily on first read -- so a callback registered in init.lua (toggle_splitmap and
-- friends) runs BEFORE the memo for the code it is about to read has been refreshed, and sees the
-- old value. Registered first in init.lua, this drops the whole memo before any other callback runs.
function InvalidateLogicCounts()
    LOGIC_COUNTS = {}
    if InvalidateCanReach then
        InvalidateCanReach()
    end
end

function has(item, amount)
    local count = LogicCount(item)
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
    -- Materialize entrance items for any now-enabled category (additive; skips already-created).
    if createEntrancesForEnabled then
        createEntrancesForEnabled()
    end
    if InvalidateCanReach then
        InvalidateCanReach()
    end
end

-- Entrance randomization is per-category; there is no single ER on/off. The Route tab is
-- part of tabs_single.json. When you author additional tab variants (split/reverse/johto),
-- add a "Routing" tab there too, or swap ER-specific tab layouts here.
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
