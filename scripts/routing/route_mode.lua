-- Route mode: given two entrance regions, find a path between them through the current
-- (possibly shuffled) graph and display each hop on the Route tab.
-- Ported/trimmed from the ALTTP AP pack (scripts/logic/logic_main.lua GetRoute/FindPath),
-- using the category-gated entrance detour (EntranceDetourTarget) instead of side matching.
--
-- Loaded after canreach.lua and entrance_item.lua. GetRoute is called from an EntranceItem's
-- middle-click (route mode). The Route tab shows solidblack0..N tiles (items/route.json).

ROUTE_TILE_COUNT = 30

-- saved last warp taken (from a bounce)
LAST_WARP_TOKEN = nil
-- region the last bounce put the player in outright (dig/escape rope arrival)
LAST_WARP_REGION = nil
-- fly token (or HOME_SENTINEL) the last bounce landed on; resolved lazily in
-- CurrentRegionNode, like the ER pairing, so a reroute or a reconnect isn't baked in
LAST_WARP_SPAWN = nil

-- wLastWarpID id ranges, from the apworld's data/warp_ids.json.
local SPAWN_ID_BASE = 0x2000
local DIG_ID_BASE = 0x4000
local SPAWN_HOME = 23
local HOME_SENTINEL = "@HOME"

local FOUND = false
local ALREADY_VISITED = {}
local PATH = {}
local STEPS = -1

-- The player can always warp back to their starting town, so route mode treats "warp home"
-- as a virtual one-hop transition available on every node. HOME is the active start-town
-- region node (set per route in GetRoute); nil until then. See HomeRegion below.
local HOME = nil

local FLY_HOPS = {}

--- The starting-town region for this seed: the single Entry_point exit whose start_town_*
--- rule currently passes. Derived from the structural entry edges in connections.lua so there
--- is one source of truth. Returns nil if no start town is set yet.
---@return table|nil
local function HomeRegion()
    for _, exit in pairs(Entry_point.exits) do
        local ok = exit[2](0)
        if type(ok) == "boolean" then ok = A(ok) end
        if ok and ok > ACCESS_NONE then
            return exit[1]
        end
    end
    return nil
end

local function ReachableFlyHops()
    local hops = {}
    for _, exit in pairs(Entry_point.exits) do
        local token = exit[7]
        if token then
            local ok = exit[2](0)
            if type(ok) == "boolean" then ok = A(ok) end
            local target = FlyDetourTarget(token)
            if ok and ok > ACCESS_SEQUENCEBREAK - 1
                and target:accessibility() > ACCESS_SEQUENCEBREAK - 1 then
                hops[#hops + 1] = { node = target, label = exit[6] or "" }
            end
        end
    end
    return hops
end

--- Depth-first search over the graph honoring the entrance detour. Fills PATH with the
--- pretty-name of each TRANSITION (edge) taken when a route to `finish` is found. Only steps
--- onto nodes that are both reachable (cached accessibility) and whose edge rule passes.
--- The label stored for a hop is the transition you physically traverse:
---   * walking edge      -> its inline pretty-name (exit[6])
---   * warp/entrance edge -> the door's pretty-name from ENTRANCE_REGISTRY[token] (exit[5]);
---     this is the door you step INTO, independent of where it currently leads once shuffled.
--- Structural/unnamed edges store "" so PATH stays dense (accurate #PATH) but print nothing.
---@param start table
---@param finish table
---@param stage integer
---@return boolean
local function FindPath(start, finish, stage)
    local next_sweep = {}
    local any_true = false
    stage = stage + 1

    if FOUND and ALREADY_VISITED[finish.name] and ALREADY_VISITED[finish.name] > stage then
        FOUND = false
    end
    if FOUND and stage >= #PATH then
        return false
    end

    if ALREADY_VISITED[start.name] ~= nil then
        if ALREADY_VISITED[start.name] > stage then
            ALREADY_VISITED[start.name] = stage
        else
            return false
        end
    else
        ALREADY_VISITED[start.name] = stage
    end

    if start.name == finish.name then
        FOUND = true
        STEPS = stage
        return true
    end

    for _, exit in pairs(start.exits) do
        local target = exit[1]
        local is_entrance = exit[3]
        if is_entrance and ER_CATEGORY_ENABLED[exit[4]] then
            target = EntranceDetourTarget(exit[5])
        elseif exit[7] then
            target = FlyDetourTarget(exit[7])
        end
        local rule = exit[2]
        local access = rule(target.keys)
        if type(access) == "boolean" then
            access = A(access)
        end
        if target:accessibility() > ACCESS_SEQUENCEBREAK - 1 and access > ACCESS_SEQUENCEBREAK - 1 then
            local label
            if is_entrance then
                local row = ENTRANCE_REGISTRY[exit[5]]
                label = row and row.pretty
            else
                label = exit[6]
            end
            table.insert(next_sweep, { node = target, label = label or "" })
        end
    end

    -- Warp home: a virtual one-hop transition available from any node except home itself.
    -- Home is always reachable, so no rule/accessibility gate is needed. This lets the search
    -- pick "warp home, then walk out" when that is fewer hops than walking from here.
    if HOME and start ~= HOME then
        table.insert(next_sweep, { node = HOME, label = "Warp Home" })
    end

    for _, hop in pairs(FLY_HOPS) do
        if hop.node ~= start then
            table.insert(next_sweep, { node = hop.node, label = hop.label })
        end
    end

    for _, step in pairs(next_sweep) do
        if FindPath(step.node, finish, stage) then
            PATH[stage] = step.label
            any_true = true
        end
    end
    return any_true
end

--- Clears all route tiles.
local function clearRouteTiles()
    for i = 0, ROUTE_TILE_COUNT do
        local tile = Tracker:FindObjectForCode("solidblack" .. tostring(i))
        if tile then
            tile.BadgeText = ""
        end
    end
end

--- Writes text onto a route tile with consistent styling.
local function writeRouteTile(index, text)
    local tile = Tracker:FindObjectForCode("solidblack" .. tostring(index))
    if not tile then
        return
    end
    tile.BadgeText = text
    tile:SetOverlayFontSize(16)
    tile.BadgeTextColor = "FFFFFFFF"
    tile:SetOverlayAlign("left")
end

--- Compute and display the route from `start` to `finish` (both region Nodes) as the ordered
--- list of TRANSITIONS to traverse — one transition pretty-name per Route tile.
---@param start table
---@param finish table
function GetRoute(start, finish)
    if start == nil or finish == nil then
        return
    end
    -- ensure the accessibility cache is current before pathfinding
    CanReach("Entry_point")

    FOUND = false
    ALREADY_VISITED = {}
    PATH = {}
    STEPS = -1
    HOME = HomeRegion()
    FLY_HOPS = ReachableFlyHops()

    FindPath(start, finish, 0)
    clearRouteTiles()

    if STEPS > 0 then
        -- the found route occupies stages 1..STEPS-1 (the hop into `finish` is at STEPS-1);
        -- clear any stale entries a longer rejected path may have left beyond it.
        for i = STEPS, #PATH do
            PATH[i] = nil
        end
        local line = 0
        for stage = 1, STEPS - 1 do
            local label = PATH[stage]
            if label and label ~= "" then
                writeRouteTile(line, label)
                line = line + 1
            end
        end
        if line == 0 then
            -- reachable, but no named transition lies between them (same area)
            writeRouteTile(0, "Already There")
        end
    else
        writeRouteTile(0, "No Route Found")
    end

    Tracker:UiHint("ActivateTab", "Routing")

    FOUND = false
    ALREADY_VISITED = {}
    PATH = {}
    STEPS = -1
    HOME = nil
    FLY_HOPS = {}
end

--- Records the warp id a map bounce carried. A map-connection crossing never commits a new
--- id, so the bounce omits the key entirely and the last position goes stale rather than nil.
---   0                  no warp identity (scripted warp, new game) -- position unknown
---   < SPAWN_ID_BASE    a warp that was traversed: the player is on its far side
---   SPAWN_ID_BASE + i  spawn point i -- fly/teleport (flypoints 0-22), Go Home (23);
---                      the pokecenter respawns above those are left unknown
---   DIG_ID_BASE + id   materialised standing ON warp id (dig, escape rope, warpback)
---@param id integer|nil
function SetLastWarp(id)
    LAST_WARP_TOKEN = nil
    LAST_WARP_REGION = nil
    LAST_WARP_SPAWN = nil
    if id == nil or id == 0 then
        return
    end
    if id >= DIG_ID_BASE then
        local row = ResolveEntranceRow(id - DIG_ID_BASE)
        -- standing on the tile rather than through it, so this is its near side
        LAST_WARP_REGION = row and EntranceSourceRegion(row.token) or nil
    elseif id >= SPAWN_ID_BASE then
        local spawn = id - SPAWN_ID_BASE
        if spawn == SPAWN_HOME then
            LAST_WARP_SPAWN = HOME_SENTINEL
        else
            LAST_WARP_SPAWN = FLY_REGION_TOKENS[spawn + 1]
        end
    else
        local row = ResolveEntranceRow(id)
        LAST_WARP_TOKEN = row and row.token or nil
    end
end

function CurrentRegionNode()
    local token = LAST_WARP_TOKEN
    if not token then
        local region = LAST_WARP_REGION
        if LAST_WARP_SPAWN == HOME_SENTINEL then
            return HomeRegion()
        elseif LAST_WARP_SPAWN then
            region = FLY_DESTINATIONS[LAST_WARP_SPAWN]
        end
        return region and NAMED_NODES[region] or nil
    end
    local cat = ENTRANCE_CATEGORY and ENTRANCE_CATEGORY[token]
    if cat and ER_CATEGORY_ENABLED and ER_CATEGORY_ENABLED[cat] then
        local target = EntranceDetourTarget(token)
        if target and target ~= Empty_node then
            return target
        end
    end
    return NAMED_NODES[EntranceDestRegion(token)]
end

function ShowRouteMessage(text)
    clearRouteTiles()
    writeRouteTile(0, text)
    Tracker:UiHint("ActivateTab", "Routing")
end
