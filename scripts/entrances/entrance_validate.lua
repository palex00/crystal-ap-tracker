-- Load-time consistency validator for entrance-randomization data.
--
-- The pack keeps two files for warps on purpose (connections.lua graph edges <-> the
-- entrance_registry.lua rows), so each warp is declared in two places. The residual risk of
-- that split is SILENT failure: a token typo, or a warp present in only one file, produces a
-- dead reveal / missing route with no error at all — and only mid-seed. This pass turns those
-- into loud console lines the moment the pack loads.
--
-- Purely structural and read-only: runs once at load, prints warnings, never mutates state,
-- and is independent of slot_data / which ER categories happen to be enabled. It no-ops
-- quietly when there is neither a registry nor any entrance edges (i.e. before the real data
-- is authored, or on a non-ER pack build).
--
-- Loaded after connections.lua (the graph), entrance_registry.lua (ENTRANCE_REGISTRY /
-- REGISTRY / ER_CATEGORIES) and createEntrances(). Reads the edge tuple laid out in
-- canreach.lua: { target, rule, is_entrance, category, token, pretty }.

local PREFIX = "[ER validate] "

--- Region name to the RIGHT of " -> " in a token ("A -> B" -> "B"); nil if malformed.
--- (The left side is available as the global EntranceSourceRegion from canreach.lua.)
---@param token string
---@return string|nil
local function entranceDestRegion(token)
    local _, arrowEnd = string.find(token, " %-> ")
    if arrowEnd then
        return string.sub(token, arrowEnd + 1)
    end
    return nil
end

--- Number of keys in a (possibly non-sequence) table.
---@param t table
---@return integer
local function countKeys(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

--- Every warp (is_entrance) edge in the graph, keyed by token -> { category, count }.
--- `count` catches a token declared by more than one connect_*_entrance call.
---@return table<string, { category: any, count: integer }>
local function collectGraphEntrances()
    local edges = {}
    for _, node in pairs(NAMED_NODES) do
        if type(node) == "table" and node.exits then
            for _, exit in ipairs(node.exits) do
                if exit[3] then -- is_entrance
                    local token = exit[5]
                    if token ~= nil then
                        local e = edges[token]
                        if e then
                            e.count = e.count + 1
                        else
                            edges[token] = { category = exit[4], count = 1 }
                        end
                    end
                end
            end
        end
    end
    return edges
end

--- Cross-checks the graph's warp edges against ENTRANCE_REGISTRY and prints any mismatch.
--- Returns the number of problems found (0 = clean).
---@return integer
function ValidateEntrances()
    local graphEdges = collectGraphEntrances()
    local hasGraph = next(graphEdges) ~= nil
    local hasRegistry = type(ENTRANCE_REGISTRY) == "table" and next(ENTRANCE_REGISTRY) ~= nil
    if not hasGraph and not hasRegistry then
        return 0 -- nothing authored yet: stay silent
    end

    -- Fast membership set for the valid ER categories.
    local knownCategory = {}
    if type(ER_CATEGORIES) == "table" then
        for _, cat in ipairs(ER_CATEGORIES) do
            knownCategory[cat] = true
        end
    end

    local problems = 0
    local function warn(msg)
        problems = problems + 1
        print(PREFIX .. msg)
    end

    -- 1. Every warp EDGE needs a registry row (its id is what the autotracker reveals it by),
    --    must be declared exactly once, and must carry a real ER category.
    for token, e in pairs(graphEdges) do
        if not (hasRegistry and ENTRANCE_REGISTRY[token]) then
            warn("edge '" .. token .. "' has no ENTRANCE_REGISTRY row"
                .. " -> no id, so the autotracker can never reveal it.")
        end
        if e.count > 1 then
            warn("edge '" .. token .. "' is declared " .. e.count
                .. " times (duplicate connect_*_entrance call?).")
        end
        if e.category == nil then
            warn("edge '" .. token .. "' has no category.")
        elseif not knownCategory[e.category] then
            warn("edge '" .. token .. "' uses category '" .. tostring(e.category)
                .. "' which is not in ER_CATEGORIES -> it will never be shuffled/gated.")
        end
    end

    -- 2. Every registry ROW needs a matching graph edge, a well-formed token whose regions
    --    both exist, a pretty name, and tile ids that no OTHER ungated row also claims (a
    --    silent collision would make ResolveEntranceRow reveal the wrong entrance). Empty ids
    --    are allowed (reverse-elevator rows); gated rows may share an id with their vanilla
    --    partner on purpose and are exempt from the uniqueness check.
    local seenId = {}
    if hasRegistry then
        for token, row in pairs(ENTRANCE_REGISTRY) do
            if not graphEdges[token] then
                warn("registry row '" .. token .. "' has no matching graph entrance edge"
                    .. " -> nothing routes or detours through it.")
            end

            local dst = entranceDestRegion(token)
            if dst == nil then
                warn("registry token '" .. token .. "' is malformed"
                    .. " (expected \"REGION_A -> REGION_B\").")
            else
                local src = EntranceSourceRegion(token)
                if not NAMED_NODES[src] then
                    warn("registry token '" .. token .. "' source region '" .. tostring(src)
                        .. "' is not a known region.")
                end
                if not NAMED_NODES[dst] then
                    warn("registry token '" .. token .. "' destination region '" .. tostring(dst)
                        .. "' is not a known region.")
                end
            end

            if row.pretty == nil then
                warn("registry row '" .. token .. "' has no pretty name.")
            end

            if row.ids == nil then
                warn("registry row '" .. token .. "' has no ids field.")
            elseif not row.gate then
                for _, wid in ipairs(row.ids) do
                    if seenId[wid] ~= nil then
                        warn("warp id " .. tostring(wid) .. " is claimed by ungated rows '"
                            .. seenId[wid] .. "' and '" .. token
                            .. "' -> ambiguous reveal.")
                    else
                        seenId[wid] = token
                    end
                end
            end
        end
    end

    if problems == 0 then
        print(PREFIX .. "OK — " .. countKeys(graphEdges)
            .. " entrance edge(s) consistent with the registry.")
    else
        print(PREFIX .. problems .. " problem(s) found (see above).")
    end
    return problems
end

ValidateEntrances()
