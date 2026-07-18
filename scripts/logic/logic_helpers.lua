-- Accessibility helpers for the CanReach entrance-graph system.
-- Ported/trimmed from the ALTTP AP pack (scripts/logic/logic_helpers.lua).
-- These globals are consumed by the region-logic files (region_definitions.lua /
-- connections.lua) and by canreach.lua. The pack's existing scripts/logic/logic.lua
-- is untouched; it uses AccessibilityLevel.* inline and does not define any of these.

ACCESS_NONE = AccessibilityLevel.None                   -- 0  unreachable
ACCESS_PARTIAL = AccessibilityLevel.Partial             -- 1
ACCESS_INSPECT = AccessibilityLevel.Inspect             -- 3  visible, not collectable
ACCESS_SEQUENCEBREAK = AccessibilityLevel.SequenceBreak -- 5  reachable out of logic
ACCESS_NORMAL = AccessibilityLevel.Normal               -- 6  reachable in logic
ACCESS_CLEARED = AccessibilityLevel.Cleared             -- 7

local bool_to_accesslvl = {
    [true] = ACCESS_NORMAL,
    [false] = ACCESS_NONE,
}

---coerce a boolean into an AccessibilityLevel
---@param result boolean
---@return integer
function A(result)
    if result then
        return ACCESS_NORMAL
    end
    return ACCESS_NONE
end

---AND: returns the MINIMUM accessibility over all arguments (short-circuits on NONE).
---Arguments may be levels, booleans, functions (called), or item-code strings (resolved via Has).
---@param ... unknown
---@return integer
function ALL(...)
    local args = { ... }
    local min = ACCESS_NORMAL
    for _, v in ipairs(args) do
        if type(v) == "function" then
            v = v()
        elseif type(v) == "string" then
            v = Has(v)
        end
        if type(v) == "boolean" then
            v = bool_to_accesslvl[v]
        end
        if v < min then
            if v == ACCESS_NONE then
                return ACCESS_NONE
            end
            min = v
        end
    end
    return min
end

---OR: returns the MAXIMUM accessibility over all arguments (short-circuits on NORMAL).
---Arguments may be levels, booleans, functions (called), or item-code strings (resolved via Has).
---@param ... unknown
---@return integer
function ANY(...)
    local args = { ... }
    local max = ACCESS_NONE
    for _, v in ipairs(args) do
        if type(v) == "function" then
            v = v()
        elseif type(v) == "string" then
            v = Has(v)
        end
        if type(v) == "boolean" then
            v = bool_to_accesslvl[v]
        end
        if v > max then
            if v == ACCESS_NORMAL then
                return ACCESS_NORMAL
            end
            max = v
        end
    end
    return max
end

---Compare a tracker count for an item code against a required threshold and return a level.
---  amountInLogic given: NORMAL if count >= amountInLogic, SEQUENCEBREAK if count >= amount, else NONE.
---  only amount given:   SEQUENCEBREAK if count >= amount, else NONE.
---  neither given:       NORMAL if count > 0, else NONE.
---@param item string
---@param amount? integer
---@param amountInLogic? integer
---@return integer
function Has(item, amount, amountInLogic)
    local count = LogicCount(item)
    if amountInLogic then
        if count >= amountInLogic then
            return ACCESS_NORMAL
        elseif count >= amount then
            return ACCESS_SEQUENCEBREAK
        end
        return ACCESS_NONE
    end
    if not amount then
        if count > 0 then
            return ACCESS_NORMAL
        end
        return ACCESS_NONE
    end
    if count >= amount then
        return ACCESS_SEQUENCEBREAK
    end
    return ACCESS_NONE
end
