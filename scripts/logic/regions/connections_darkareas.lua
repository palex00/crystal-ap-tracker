-- Dark areas and Cycling Road: requirements that belong to a REGION rather than to any one
-- transition. Ported from external_files/rules.py (DARK_AREA_REGIONS / CYCLING_ROAD_REGIONS).
--
-- Loaded AFTER connections.lua (the edges must already exist to be wrapped) and BEFORE
-- check_leafs.lua (so the check leaves are not wrapped -- see "locations" below).
--
-- WHY ONLY OUTGOING EDGES:
-- The engine has no per-region rule, only per-edge rules, and under ER discover() swaps an
-- entrance edge's TARGET while keeping its rule (canreach.lua). So a gate is only safe on
-- edges whose SOURCE is inside the dark region -- the source never moves.
--   * outgoing edges (internal walks AND the doors out) carry the gate: the door is
--     physically inside the dark room, so needing Flash to reach and use it stays true no
--     matter where the door now leads.
--   * inbound edges from lit regions are deliberately NOT gated: their target moves under ER,
--     so the gate would follow the wrong door -- demanding Flash to enter some unrelated
--     building while the real dark room asked for nothing.
--
-- LOCATIONS: rules.py also adds the gate to every location inside these regions. That is not
-- done here, because arriving through a shuffled door traverses no gated edge. It is handled
-- on the location side in the JSON instead, by ANDing the area gate onto the section:
--     "access_rules": ["^$CanReach|REGION_UNION_CAVE_1F, ^$dark|unioncave"]
--
-- Area keys must match the dark_<area>_true / dark_<area>_false codes in items/settings.json.

DARK_AREA_REGIONS = {
    -- Dark Cave
    darkcave = {
        "REGION_DARK_CAVE_VIOLET_ENTRANCE:WEST",
        "REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTHEAST",
        "REGION_DARK_CAVE_VIOLET_ENTRANCE:SOUTHEAST",
        "REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTH",
        "REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHEAST",
        "REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHEAST",
        "REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHWEST",
        "REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHWEST",
    },
    -- Union Cave
    unioncave = {
        "REGION_UNION_CAVE_1F",
        "REGION_UNION_CAVE_1F:SOUTH",
        "REGION_UNION_CAVE_B1F:NORTH",
        "REGION_UNION_CAVE_B1F:STRENGTH",
        "REGION_UNION_CAVE_B1F:CENTER",
        "REGION_UNION_CAVE_B1F:SOUTHWEST",
        "REGION_UNION_CAVE_B1F:SOUTHEAST",
        "REGION_UNION_CAVE_B2F:NORTH",
        "REGION_UNION_CAVE_B2F:SURF",
    },
    -- Slowpoke Well
    slowpokewell = {
        "REGION_SLOWPOKE_WELL_B1F:ENTRANCE",
        "REGION_SLOWPOKE_WELL_B1F",
        "REGION_SLOWPOKE_WELL_B1F:WEST",
        "REGION_SLOWPOKE_WELL_B1F:CENTER",
        "REGION_SLOWPOKE_WELL_B2F:CENTER",
        "REGION_SLOWPOKE_WELL_B2F:ISLANDS",
    },
    -- Ilex Forest
    ilexforest = {
        "REGION_ILEX_FOREST:NORTH",
        "REGION_ILEX_FOREST:SOUTH",
    },
    -- Goldenrod Underground
    goldenrodunderground = {
        "REGION_GOLDENROD_UNDERGROUND",
        "REGION_GOLDENROD_UNDERGROUND:BASEMENT_LANDING",
    },
    -- Burned Tower
    burnedtower = {
        "REGION_BURNED_TOWER_1F",
        "REGION_BURNED_TOWER_B1F",
    },
    -- Olivine Lighthouse
    olivinelighthouse = {
        "REGION_OLIVINE_LIGHTHOUSE_1F",
        "REGION_OLIVINE_LIGHTHOUSE_2F",
        "REGION_OLIVINE_LIGHTHOUSE_2F:POWER",
        "REGION_OLIVINE_LIGHTHOUSE_2F:HOLE",
        "REGION_OLIVINE_LIGHTHOUSE_3F",
        "REGION_OLIVINE_LIGHTHOUSE_3F:NORTH",
        "REGION_OLIVINE_LIGHTHOUSE_3F:HOLE",
        "REGION_OLIVINE_LIGHTHOUSE_4F",
        "REGION_OLIVINE_LIGHTHOUSE_4F:CENTER",
        "REGION_OLIVINE_LIGHTHOUSE_4F:NORTH_HOLE",
        "REGION_OLIVINE_LIGHTHOUSE_4F:HOLE",
        "REGION_OLIVINE_LIGHTHOUSE_5F",
        "REGION_OLIVINE_LIGHTHOUSE_5F:CENTER",
        "REGION_OLIVINE_LIGHTHOUSE_5F:HOLE",
        "REGION_OLIVINE_LIGHTHOUSE_6F",
    },
    -- Whirl Islands
    whirlislands = {
        "REGION_WHIRL_ISLAND_NW:NORTH",
        "REGION_WHIRL_ISLAND_NW:SOUTH",
        "REGION_WHIRL_ISLAND_NE:WEST",
        "REGION_WHIRL_ISLAND_NE:CENTER",
        "REGION_WHIRL_ISLAND_NE:SOUTHEAST",
        "REGION_WHIRL_ISLAND_NE:NORTHEAST",
        "REGION_WHIRL_ISLAND_SW:NORTHWEST",
        "REGION_WHIRL_ISLAND_SW:NORTHEAST",
        "REGION_WHIRL_ISLAND_SW:SOUTHWEST",
        "REGION_WHIRL_ISLAND_SW:SOUTHEAST",
        "REGION_WHIRL_ISLAND_SE",
        "REGION_WHIRL_ISLAND_B1F:NORTH",
        "REGION_WHIRL_ISLAND_B1F:NORTHEAST",
        "REGION_WHIRL_ISLAND_B1F:SOUTHWEST",
        "REGION_WHIRL_ISLAND_B1F:SOUTHEAST",
        "REGION_WHIRL_ISLAND_B1F:LEDGE",
        "REGION_WHIRL_ISLAND_B2F:NORTH",
        "REGION_WHIRL_ISLAND_B2F:CENTER",
        "REGION_WHIRL_ISLAND_B2F:LUGIA_CHAMBER_ENTRANCE",
        "REGION_WHIRL_ISLAND_B2F:SOUTH",
        "REGION_WHIRL_ISLAND_CAVE",
        "REGION_WHIRL_ISLAND_LUGIA_CHAMBER",
        "REGION_WHIRL_ISLAND_LUGIA_CHAMBER:WATER",
    },
    -- Mount Mortar
    mountmortar = {
        "REGION_MOUNT_MORTAR_1F_INSIDE",
        "REGION_MOUNT_MORTAR_1F_INSIDE:NORTH",
        "REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH",
        "REGION_MOUNT_MORTAR_2F_INSIDE",
        "REGION_MOUNT_MORTAR_2F_INSIDE:SOUTH",
        "REGION_MOUNT_MORTAR_2F_INSIDE:SOUTHWEST",
        "REGION_MOUNT_MORTAR_2F_INSIDE:NORTH",
        "REGION_MOUNT_MORTAR_B1F",
        "REGION_MOUNT_MORTAR_B1F:SOUTH",
        "REGION_MOUNT_MORTAR_B1F:NORTHWEST",
    },
    -- Ice Path
    icepath = {
        "REGION_ICE_PATH_1F:WEST",
        "REGION_ICE_PATH_1F:EAST",
        "REGION_ICE_PATH_B1F:NORTH",
        "REGION_ICE_PATH_B1F:SOUTH",
        "REGION_ICE_PATH_B2F_BLACKTHORN_SIDE",
        "REGION_ICE_PATH_B2F_MAHOGANY_SIDE",
        "REGION_ICE_PATH_B2F_MAHOGANY_SIDE:MIDDLE",
        "REGION_ICE_PATH_B3F",
    },
    -- Dragons Den
    dragonsden = {
        "REGION_DRAGONS_DEN_1F:UPPER",
        "REGION_DRAGONS_DEN_1F:LOWER",
        "REGION_DRAGONS_DEN_B1F:NORTH",
        "REGION_DRAGONS_DEN_B1F:CENTER",
        "REGION_DRAGONS_DEN_B1F:WEST",
        "REGION_DRAGONS_DEN_B1F:SOUTH",
        "REGION_DRAGONS_DEN_B1F:SOUTHEAST",
    },
    -- Tohjo Falls
    tohjofalls = {
        "REGION_TOHJO_FALLS:WEST",
        "REGION_TOHJO_FALLS:EAST",
    },
    -- Victory Road
    victoryroad = {
        "REGION_VICTORY_ROAD:1F:ENTRANCE",
        "REGION_VICTORY_ROAD:1F",
        "REGION_VICTORY_ROAD:2F",
        "REGION_VICTORY_ROAD:2F:NORTHEAST",
        "REGION_VICTORY_ROAD:2F:NORTHWEST",
        "REGION_VICTORY_ROAD:3F",
        "REGION_VICTORY_ROAD:3F:SOUTHEAST",
    },
    -- Silver Cave
    silvercave = {
        "REGION_SILVER_CAVE_ROOM_1",
    },
    -- Digletts Cave
    diglettscave = {
        "REGION_DIGLETTS_CAVE",
        "REGION_DIGLETTS_CAVE:SOUTH_ENTRANCE",
        "REGION_DIGLETTS_CAVE:NORTH_ENTRANCE",
    },
    -- Mount Moon
    mountmoon = {
        "REGION_MOUNT_MOON",
        "REGION_MOUNT_MOON:LEDGE",
        "REGION_MOUNT_MOON:NORTH_ENTRANCE",
        "REGION_MOUNT_MOON:SOUTH_ENTRANCE",
    },
    -- Rock Tunnel
    rocktunnel = {
        "REGION_ROCK_TUNNEL_1F:SOUTH",
        "REGION_ROCK_TUNNEL_1F:NORTHEAST",
        "REGION_ROCK_TUNNEL_1F:NORTHWEST",
        "REGION_ROCK_TUNNEL_B1F:WEST",
        "REGION_ROCK_TUNNEL_B1F:EAST",
    },
    -- Flooded Mine
    floodedmine = {
        "REGION_FLOODED_MINE",
        "REGION_FLOODED_MINE:NORTH_ENTRANCE",
        "REGION_FLOODED_MINE:SOUTH_ENTRANCE",
    },
}

CYCLING_ROAD_REGIONS = {
    "REGION_ROUTE_16:CYCLING_ROAD",
    "REGION_ROUTE_17",
}

--- ANDs `gateFn` onto every outgoing edge of each named region, preserving the edge's own rule.
---@param regions string[]
---@param gateFn function
local function gate_region_exits(regions, gateFn)
    for _, name in ipairs(regions) do
        local node = NAMED_NODES[name]
        if node == nil then
            print("connections_darkareas.lua: unknown region " .. name)
        else
            for _, exit in pairs(node.exits) do
                local base = exit[2]
                exit[2] = function(keys)
                    return ALL(gateFn, function() return base(keys) end)
                end
            end
        end
    end
end

for area, regions in pairs(DARK_AREA_REGIONS) do
    local a = area -- capture per iteration; `area` is reused by the loop
    -- dark() returns nil when neither dark_<a>_true nor dark_<a>_false is set (its if/elseif
    -- chain has no else), and ALL would then compare nil. Treat that as unreachable.
    gate_region_exits(regions, function() return dark(a) or ACCESS_NONE end)
end

gate_region_exits(CYCLING_ROAD_REGIONS, function() return has("BICYCLE") end)
