-- CanReach graph engine for entrance-randomization logic.
-- Ported/trimmed from the ALTTP AP pack (scripts/logic/logic_main.lua), with light/dark
-- worldstate, SNES coordinate mapping (ENTRANCE_MAPPING), the fixed er_check stage table,
-- and the indirect-connection mechanism removed. ER is gated per-category via
-- ER_CATEGORY_ENABLED (set from slot_data in archipelago.lua's onClear).
--
-- Model: the world is a graph of region Nodes. Edges carry a rule function. An "entrance
-- edge" additionally carries a category + a region-string token ("REGION_A -> REGION_B").
-- When that category is shuffled, discover detours the edge through the revealed pairing
-- stored on the entrance's LuaItem (keyed by the token); otherwise it uses the vanilla edge.

Node = {}
Node.__index = Node

---@type table<string, table>  name -> node, the table CanReach() looks names up in
NAMED_NODES = {}
---@type string[]
NAMED_NODES_KEYS = {}

-- which ER categories are shuffled this seed; set in onClear. Empty => everything vanilla.
ER_CATEGORY_ENABLED = ER_CATEGORY_ENABLED or {}

local stale = true
local accessibilityCache = {}
local accessibilityCacheComplete = false

--- Returns the substring before " -> " in a region-string token, i.e. the region the
--- entrance is physically located in ("REGION_A -> REGION_B" -> "REGION_A").
---@param token string
---@return string
function EntranceSourceRegion(token)
    local arrow = string.find(token, " %-> ")
    if arrow then
        return string.sub(token, 1, arrow - 1)
    end
    return token
end

--- Checks whether a named node is reachable from the entry point and returns its level.
--- Lazily rebuilds the whole flood-fill cache when the world state changed.
---@param name string
---@return integer
function CanReach(name)
    if stale then
        stale = false
        accessibilityCacheComplete = false
        accessibilityCache = {}
        while not accessibilityCacheComplete do
            accessibilityCacheComplete = true
            Entry_point:discover(ACCESS_NORMAL, 0)
        end
    end
    local node = NAMED_NODES[name]
    if node == nil then
        return ACCESS_NONE
    end
    return node:accessibility()
end

--- Forces the accessibility cache to be considered stale so the next CanReach rebuilds it.
function InvalidateCanReach()
    stale = true
end

--- Creates a region node and self-registers it in NAMED_NODES.
--- Regions carry no display name of their own — route labels live on the transitions
--- (edges), not the nodes. A node only needs its identity so locations can be placed in it.
---@param name string
---@return table
function Node.new(name)
    local self = setmetatable({}, Node)
    self.name = name
    self.exits = {}       -- list of { target, rule, is_entrance, category, token, pretty }
    self.keys = math.huge
    NAMED_NODES[name] = self
    table.insert(NAMED_NODES_KEYS, name)
    return self
end

--- default rule: always traversable
---@return integer
local function always()
    return ACCESS_NORMAL
end

--- One directed edge self -> exit, traversable when rule passes. Two uses, disambiguated by
--- the type of `exit`:
---   * exit is a Node  -> a WALKING transition. The 2nd arg is its route pretty-name (the
---     label printed when a route traverses it), the 3rd an optional access rule.
---       connect_one_way(REGION_ROUTE_29, "Route 29 West Exit", function() return ANY("cut") end)
---     A pretty-name is optional (structural edges like Entry_point -> start may omit it and
---     simply won't print in a route).
---   * exit is a string -> a CHECK LEAF named exactly as a location; the 2nd arg is the rule.
---     Leaves are dead-ends, carry no pretty-name, and never appear in a route.
---       connect_one_way("Route 29 - Hidden Item", function() return ANY("cut") end)
---@param exit string|table
---@param label_or_rule string|function|nil  pretty-name (Node target) or rule (string target)
---@param rule? function
function Node:connect_one_way(exit, label_or_rule, rule)
    if type(exit) == "string" then
        -- check leaf: attach a location by its exact name; no pretty-name, never printed
        exit = NAMED_NODES[exit] or Node.new(exit)
        self.exits[#self.exits + 1] = { exit, label_or_rule or always, false }
        return
    end
    -- walking transition to a region node
    local pretty, edgeRule
    if type(label_or_rule) == "string" then
        pretty, edgeRule = label_or_rule, rule
    else
        pretty, edgeRule = nil, label_or_rule  -- back-compat: (node) or (node, rule)
    end
    self.exits[#self.exits + 1] = { exit, edgeRule or always, false, nil, nil, pretty }
end

--- Two walking edges (both directions), each with its OWN pretty-name — the usual case,
--- since the exit is named differently from each side ("North Exit" vs "South Exit").
---   connect_two_ways(REGION_B, "A's North Exit", "B's South Exit" [, rule])
--- The rule (traversal logic) is shared by both directions; if a direction needs a different
--- name-less/structural form or a different rule, use two connect_one_way calls instead.
--- Convenience shorthands:
---   connect_two_ways(node, "Same Name")        -- same name both ways (rare)
---   connect_two_ways(node, "Same Name", rule)  -- same name both ways + a shared rule
---   connect_two_ways(node)                     -- structural, no names
---@param exit string|table
---@param pretty_fwd string|nil  name for self -> exit
---@param pretty_rev string|function|nil  name for exit -> self (or the shared rule)
---@param rule? function
function Node:connect_two_ways(exit, pretty_fwd, pretty_rev, rule)
    -- shorthand: (node, "Name", rule) — the 3rd arg is the rule, names match both ways
    if type(pretty_rev) == "function" then
        rule = pretty_rev
        pretty_rev = pretty_fwd
    end
    pretty_rev = pretty_rev or pretty_fwd
    self:connect_one_way(exit, pretty_fwd, rule)
    if type(exit) == "string" then
        exit = NAMED_NODES[exit]
    end
    exit:connect_one_way(self, pretty_rev, rule)
end

--- One directed randomizable entrance edge self -> exit in ER category `category`.
--- The edge's token is "<self.name> -> <exit.name>", matching the registry / slot_data.
--- Use this for one-way entrances (e.g. holes: you fall in, never come back out).
--- The route pretty-name for a warp is NOT passed here — it lives in ENTRANCE_REGISTRY
--- (keyed by token), because the entrance item's badge needs it too; route mode reads it
--- from there so there is one source of truth.
---@param exit table
---@param category string
---@param rule? function
function Node:connect_one_way_entrance(exit, category, rule)
    local token = self.name .. " -> " .. exit.name
    self.exits[#self.exits + 1] = { exit, rule or always, true, category, token }
end

--- Two directed randomizable entrance edges (both directions), each with its own token.
--- Both directions share the ER `category`.
---@param exit table
---@param category string
---@param rule? function
function Node:connect_two_ways_entrance(exit, category, rule)
    self:connect_one_way_entrance(exit, category, rule)
    exit:connect_one_way_entrance(self, category, rule)
end

--- Cached accessibility for this node (ACCESS_NONE if not discovered this rebuild).
---@return integer
function Node:accessibility()
    local res = accessibilityCache[self]
    if res == nil then
        res = ACCESS_NONE
        accessibilityCache[self] = res
    end
    return res
end

--- Given a shuffled entrance edge, returns the region node the player actually reaches.
--- Reads the revealed pairing off the entrance's LuaItem (keyed by the forward token).
--- Also used by route_mode.lua's FindPath so routes respect entrance connections.
---@param token string forward token of this entrance ("REGION_A -> REGION_B")
---@return table detour target node (Empty_node if unrevealed)
function EntranceDetourTarget(token)
    local item = Tracker:FindObjectForCode(token)
    local paired = item and item.ItemState and item.ItemState.forwardTarget
    if paired then
        -- Coupled/mouth-to-mouth convention: entering this door drops you at the paired
        -- door's location, i.e. the SOURCE region of the paired token. If the apworld's ER
        -- turns out to be exit-to-entrance instead, change EntranceSourceRegion -> a
        -- dest-region helper here (the one line to flip).
        return NAMED_NODES[EntranceSourceRegion(paired)] or Empty_node
    end
    return Empty_node
end

--- Flood-fill relaxation from this node. Bellman-Ford-style fixed point driven by CanReach.
---@param accessibility integer
---@param keys integer
function Node:discover(accessibility, keys)
    if accessibility > self:accessibility() then
        self.keys = math.huge
        accessibilityCache[self] = accessibility
        accessibilityCacheComplete = false
    end
    if keys < self.keys then
        self.keys = keys
    end

    if accessibility <= ACCESS_NONE then
        return
    end

    for _, exit in pairs(self.exits) do
        local target = exit[1]
        local rule = exit[2]
        local is_entrance = exit[3]

        if is_entrance and ER_CATEGORY_ENABLED[exit[4]] then
            -- shuffled entrance: detour through the revealed pairing (or dead-end)
            target = EntranceDetourTarget(exit[5])
        end

        local oldAccess = target:accessibility()
        local oldKey = target.keys or 0
        if oldAccess < accessibility then
            local access, key = rule(keys)
            local parent_access = self:accessibility()
            if type(access) == "boolean" then
                access = A(access)
            end
            if access == nil then
                print("Warning: " .. self.name .. " -> " .. target.name .. " rule returned nil")
                access = ACCESS_NONE
            end
            if access > parent_access then
                access = parent_access
            end
            if key == nil then
                key = keys
            end
            if access > oldAccess or (access == oldAccess and key < oldKey) then
                target:discover(access, key)
            end
        end
    end
end

-- Root of the graph and the dead-end sink for unconnected entrances.
-- connections.lua (user-authored) must connect Entry_point to the starting region(s).
Entry_point = Node.new("Entry_point")
Empty_node = Node.new("Empty_node")

--- Forces a graph rebuild on any tracker state change.
function StateChanged()
    stale = true
end

ScriptHost:AddWatchForCode("StateChanged", "*", StateChanged)
