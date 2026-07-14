-- Wire the Nodes declared in region_definitions.lua. Loaded after them, before locations.
--
-- Rule contract: a rule is `function(keys) -> AccessibilityLevel`. Rules read tracker item
-- state through the combinators in logic_helpers.lua (A / ALL / ANY / Has) — never the
-- server directly. A nil rule means "always traversable".
--
-- Every region-to-region transition has a PRETTY-NAME and shows up in route mode. There are
-- two kinds, plus a non-transition (the check leaf):
--
--   WALKING (always vanilla, never shuffled — but may still have a logic rule). The exit is
--   normally named differently from each side, so give both names in one call:
--     connect_two_ways(node, "Fwd Name", "Rev Name" [, rule])   self->node, node->self
--     connect_two_ways(node, "Same Name" [, rule])              same name both ways (rare)
--     connect_one_way(node, "Pretty Name" [, rule])             a genuinely one-way walk
--
--   WARP / ENTRANCE (randomizable — gated by an ER category, revealed via fog-of-war):
--     connect_two_ways_entrance(node, "category" [, rule])
--     connect_one_way_entrance(node, "category" [, rule])   one-way only (e.g. holes)
--   The warp's pretty-name is NOT given here — it lives in ENTRANCE_REGISTRY (keyed by the
--   token "<from> -> <to>"), because the entrance item's badge needs it too. When the
--   category is NOT enabled the edge is traversed vanilla; when it IS, discover/route detour
--   through the revealed pairing. `category` must match a key set from slot_data (see
--   ap_helper.lua / onClear) and an ER_CATEGORIES entry.
--
--   CHECK LEAF (not a transition — attaches a location; never printed in a route):
--     connect_one_way("Exact Location Name" [, rule])   string target => dead-end leaf
--   Only needed when a location has requirements beyond reaching its region; otherwise the
--   location JSON can just use "$CanReach|REGION_*" directly.

-- Region connections for Pokemon Crystal -- AUTO-GENERATED from external_files/
--   regions.json (exits), entrance_types.json (randomizable category),
--   and "Crystal Region Connection Names.xlsx" (transition pretty-names, Friendly Name column).
-- No access rules are applied yet: every transition assumes reachability.
--
-- Two regions that exit to each other => two-way; otherwise one-way. Edges listed in
-- entrance_types.json are randomizable warps (connect_*_entrance, category only; the warp
-- pretty-name lives in ENTRANCE_REGISTRY, not here); all others are walking (inline names).
-- "TODOBYSNOWFLAV" marks a walking transition with no approved Friendly Name yet.
-- Loaded after region_definitions.lua, before locations.

-- Structural entry edge to the starting region (no pretty-name, never routed):
Entry_point:connect_one_way(REGION_NEW_BARK_TOWN)

-- === REGION_AZALEA_GYM ===
REGION_AZALEA_GYM:connect_two_ways_entrance(REGION_AZALEA_TOWN, "gym")

-- === REGION_AZALEA_MART ===
REGION_AZALEA_MART:connect_two_ways_entrance(REGION_AZALEA_TOWN, "mart")

-- === REGION_AZALEA_POKECENTER_1F ===
REGION_AZALEA_POKECENTER_1F:connect_two_ways_entrance(REGION_AZALEA_TOWN, "pokecenter")
REGION_AZALEA_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Azalea Pokecenter Stairs")

-- === REGION_AZALEA_TOWN ===
REGION_AZALEA_TOWN:connect_two_ways_entrance(REGION_CHARCOAL_KILN, "building")
REGION_AZALEA_TOWN:connect_two_ways_entrance(REGION_KURTS_HOUSE, "building")
REGION_AZALEA_TOWN:connect_two_ways(NAMED_NODES["REGION_AZALEA_TOWN:WELL"], "TODOBYSNOWFLAV")
REGION_AZALEA_TOWN:connect_two_ways_entrance(REGION_ILEX_FOREST_AZALEA_GATE, "gate")
REGION_AZALEA_TOWN:connect_two_ways(REGION_ROUTE_33, "Azalea Town East Exit", "Route 33 West Exit")

-- === REGION_AZALEA_TOWN:WELL ===
NAMED_NODES["REGION_AZALEA_TOWN:WELL"]:connect_two_ways_entrance(NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:ENTRANCE"], "dungeon")

-- === REGION_BATTLE_TOWER_1F ===
REGION_BATTLE_TOWER_1F:connect_two_ways_entrance(REGION_BATTLE_TOWER_OUTSIDE, "dungeon")
REGION_BATTLE_TOWER_1F:connect_one_way(REGION_BATTLE_TOWER_ELEVATOR, "TODOBYSNOWFLAV")

-- === REGION_BATTLE_TOWER_BATTLE_ROOM ===
REGION_BATTLE_TOWER_BATTLE_ROOM:connect_two_ways(REGION_BATTLE_TOWER_HALLWAY, "TODOBYSNOWFLAV")

-- === REGION_BATTLE_TOWER_ELEVATOR ===
REGION_BATTLE_TOWER_ELEVATOR:connect_two_ways(REGION_BATTLE_TOWER_HALLWAY, "TODOBYSNOWFLAV")

-- === REGION_BATTLE_TOWER_OUTSIDE ===
REGION_BATTLE_TOWER_OUTSIDE:connect_two_ways_entrance(REGION_ROUTE_40_BATTLE_TOWER_GATE, "gate")

-- === REGION_BILLS_BROTHERS_HOUSE ===
REGION_BILLS_BROTHERS_HOUSE:connect_two_ways_entrance(REGION_FUCHSIA_CITY, "building")

-- === REGION_BILLS_FAMILYS_HOUSE ===
REGION_BILLS_FAMILYS_HOUSE:connect_two_ways_entrance(REGION_GOLDENROD_CITY, "building")

-- === REGION_BILLS_HOUSE ===
REGION_BILLS_HOUSE:connect_two_ways_entrance(REGION_ROUTE_25, "building")

-- === REGION_BLACKTHORN_CITY ===
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_BLACKTHORN_GYM_1F, "gym")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_BLACKTHORN_DRAGON_SPEECH_HOUSE, "building")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_BLACKTHORN_EMYS_HOUSE, "building")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_BLACKTHORN_MART, "mart")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_BLACKTHORN_POKECENTER_1F, "pokecenter")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(REGION_MOVE_DELETERS_HOUSE, "building")
REGION_BLACKTHORN_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_ICE_PATH_1F:EAST"], "dungeon")
REGION_BLACKTHORN_CITY:connect_two_ways(NAMED_NODES["REGION_BLACKTHORN_CITY:DRAGONS_DEN_ENTRANCE"], "Blackthorn City Water Crossing (Northbound)", "Blackthorn City Water Crossing (Southbound)")
REGION_BLACKTHORN_CITY:connect_two_ways(REGION_ROUTE_45, "Blackthorn City South Exit", "Route 45 North Exit")

-- === REGION_BLACKTHORN_CITY:DRAGONS_DEN_ENTRANCE ===
NAMED_NODES["REGION_BLACKTHORN_CITY:DRAGONS_DEN_ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_DRAGONS_DEN_1F:UPPER"], "dungeon")

-- === REGION_BLACKTHORN_GYM_1F ===
REGION_BLACKTHORN_GYM_1F:connect_two_ways_entrance(REGION_BLACKTHORN_GYM_2F, "gym_interior")

-- === REGION_BLACKTHORN_GYM_1F:MIDDLE ===
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:MIDDLE"]:connect_two_ways_entrance(REGION_BLACKTHORN_GYM_2F, "gym_interior")
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:MIDDLE"]:connect_one_way(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:LOLA"], "TODOBYSNOWFLAV")

-- === REGION_BLACKTHORN_GYM_1F:LOLA ===
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:LOLA"]:connect_one_way(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:CLAIR"], "TODOBYSNOWFLAV")

-- === REGION_BLACKTHORN_GYM_1F:HOLE_1 ===
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_1"]:connect_one_way(REGION_BLACKTHORN_GYM_1F, "Blackthorn Gym 1F West Hole Fall")

-- === REGION_BLACKTHORN_GYM_1F:HOLE_2 ===
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_2"]:connect_one_way(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:MIDDLE"], "Blackthorn Gym 1F Southeast Hole Fall")

-- === REGION_BLACKTHORN_GYM_1F:HOLE_3 ===
NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_3"]:connect_one_way(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:MIDDLE"], "Blackthorn Gym 1F Northeast Hole Fall")

-- === REGION_BLACKTHORN_GYM_2F ===
REGION_BLACKTHORN_GYM_2F:connect_one_way_entrance(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_1"], "one_way")
REGION_BLACKTHORN_GYM_2F:connect_one_way_entrance(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_2"], "one_way")
REGION_BLACKTHORN_GYM_2F:connect_one_way_entrance(NAMED_NODES["REGION_BLACKTHORN_GYM_1F:HOLE_3"], "one_way")

-- === REGION_BLACKTHORN_POKECENTER_1F ===
REGION_BLACKTHORN_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Blackthorn Pokecenter Stairs")

-- === REGION_BLUES_HOUSE ===
REGION_BLUES_HOUSE:connect_two_ways_entrance(REGION_PALLET_TOWN, "building")

-- === REGION_BRUNOS_ROOM ===
REGION_BRUNOS_ROOM:connect_two_ways_entrance(REGION_KOGAS_ROOM, "pokemon_league")
REGION_BRUNOS_ROOM:connect_two_ways_entrance(REGION_KARENS_ROOM, "pokemon_league")

-- === REGION_BURNED_TOWER_1F ===
REGION_BURNED_TOWER_1F:connect_two_ways_entrance(REGION_ECRUTEAK_CITY, "dungeon")
REGION_BURNED_TOWER_1F:connect_two_ways(REGION_BURNED_TOWER_B1F, "Burned Tower 1F Ladder/Hole", "Burned Tower B1F Ladder")

-- === REGION_CELADON_CAFE ===
REGION_CELADON_CAFE:connect_two_ways_entrance(REGION_CELADON_CITY, "building")

-- === REGION_CELADON_CITY ===
REGION_CELADON_CITY:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_1F, "mart")
REGION_CELADON_CITY:connect_two_ways_entrance(REGION_CELADON_MANSION_1F, "building")
REGION_CELADON_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_MANSION_1F:STAIRWELL"], "building")
REGION_CELADON_CITY:connect_two_ways_entrance(REGION_CELADON_POKECENTER_1F, "pokecenter")
REGION_CELADON_CITY:connect_two_ways_entrance(REGION_CELADON_GAME_CORNER, "building")
REGION_CELADON_CITY:connect_two_ways_entrance(REGION_CELADON_GAME_CORNER_PRIZE_ROOM, "building")
REGION_CELADON_CITY:connect_two_ways(NAMED_NODES["REGION_CELADON_CITY:GYM_ENTRANCE"], "TODOBYSNOWFLAV")
REGION_CELADON_CITY:connect_two_ways(REGION_ROUTE_16, "Celadon City West Exit", "Route 16 East Exit")
REGION_CELADON_CITY:connect_two_ways(REGION_ROUTE_7, "Celadon City East Exit", "Route 7 West Exit")

-- === REGION_CELADON_CITY:GYM_ENTRANCE ===
NAMED_NODES["REGION_CELADON_CITY:GYM_ENTRANCE"]:connect_two_ways_entrance(REGION_CELADON_GYM, "gym")

-- === REGION_CELADON_DEPT_STORE_1F ===
REGION_CELADON_DEPT_STORE_1F:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_2F, "mart_interior")
REGION_CELADON_DEPT_STORE_1F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:1F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_2F ===
REGION_CELADON_DEPT_STORE_2F:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_3F, "mart_interior")
REGION_CELADON_DEPT_STORE_2F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:2F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_3F ===
REGION_CELADON_DEPT_STORE_3F:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_4F, "mart_interior")
REGION_CELADON_DEPT_STORE_3F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:3F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_4F ===
REGION_CELADON_DEPT_STORE_4F:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_5F, "mart_interior")
REGION_CELADON_DEPT_STORE_4F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:4F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_5F ===
REGION_CELADON_DEPT_STORE_5F:connect_two_ways_entrance(REGION_CELADON_DEPT_STORE_6F, "mart_interior")
REGION_CELADON_DEPT_STORE_5F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:5F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_6F ===
REGION_CELADON_DEPT_STORE_6F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:6F"], "elevator")

-- === REGION_CELADON_DEPT_STORE_ELEVATOR ===
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:1F"], "Celadon Dept. Store Elevator Ride (to 1F)", "Celadon Dept. Store Elevator Ride (from 1F)")
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:2F"], "Celadon Dept. Store Elevator Ride (to 2F)", "Celadon Dept. Store Elevator Ride (from 2F)")
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:3F"], "Celadon Dept. Store Elevator Ride (to 3F)", "Celadon Dept. Store Elevator Ride (from 3F)")
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:4F"], "Celadon Dept. Store Elevator Ride (to 4F)", "Celadon Dept. Store Elevator Ride (from 4F)")
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:5F"], "Celadon Dept. Store Elevator Ride (to 5F)", "Celadon Dept. Store Elevator Ride (from 5F)")
REGION_CELADON_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_CELADON_DEPT_STORE_ELEVATOR:6F"], "Celadon Dept. Store Elevator Ride (to 6F)", "Celadon Dept. Store Elevator Ride (from 6F)")

-- === REGION_CELADON_MANSION_1F ===
REGION_CELADON_MANSION_1F:connect_two_ways_entrance(REGION_CELADON_MANSION_2F, "building_interior")

-- === REGION_CELADON_MANSION_1F:STAIRWELL ===
NAMED_NODES["REGION_CELADON_MANSION_1F:STAIRWELL"]:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_MANSION_2F:STAIRWELL"], "building_interior")

-- === REGION_CELADON_MANSION_2F ===
REGION_CELADON_MANSION_2F:connect_two_ways_entrance(REGION_CELADON_MANSION_3F, "building_interior")

-- === REGION_CELADON_MANSION_2F:STAIRWELL ===
NAMED_NODES["REGION_CELADON_MANSION_2F:STAIRWELL"]:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_MANSION_3F:STAIRWELL"], "building_interior")

-- === REGION_CELADON_MANSION_3F ===
REGION_CELADON_MANSION_3F:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_MANSION_ROOF:EAST"], "building_interior")

-- === REGION_CELADON_MANSION_3F:STAIRWELL ===
NAMED_NODES["REGION_CELADON_MANSION_3F:STAIRWELL"]:connect_two_ways_entrance(NAMED_NODES["REGION_CELADON_MANSION_ROOF:WEST"], "building_interior")

-- === REGION_CELADON_MANSION_ROOF:WEST ===
NAMED_NODES["REGION_CELADON_MANSION_ROOF:WEST"]:connect_two_ways_entrance(REGION_CELADON_MANSION_ROOF_HOUSE, "building_interior")

-- === REGION_CELADON_POKECENTER_1F ===
REGION_CELADON_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Celadon Pokecenter Stairs")

-- === REGION_CERULEAN_CITY ===
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_GYM_BADGE_SPEECH_HOUSE, "building")
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_POLICE_STATION, "building")
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_TRADE_SPEECH_HOUSE, "building")
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_POKECENTER_1F, "pokecenter")
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_GYM, "gym")
REGION_CERULEAN_CITY:connect_two_ways_entrance(REGION_CERULEAN_MART, "mart")
REGION_CERULEAN_CITY:connect_two_ways(REGION_ROUTE_24, "Cerulean City North Exit", "Route 24 South Exit")
REGION_CERULEAN_CITY:connect_two_ways(NAMED_NODES["REGION_ROUTE_4:EAST"], "Cerulean City West Exit", "Route 4 East Exit")
REGION_CERULEAN_CITY:connect_two_ways(REGION_ROUTE_5, "Cerulean City South Exit", "Route 5 North Exit")
REGION_CERULEAN_CITY:connect_two_ways(REGION_ROUTE_9, "Cerulean City East Exit", "Route 9 West Exit")

-- === REGION_CERULEAN_CITY:SURF ===
NAMED_NODES["REGION_CERULEAN_CITY:SURF"]:connect_two_ways(REGION_ROUTE_24, "Cerulean City North Exit (via Surf)", "Route 24 South Exit (via Surf)")
NAMED_NODES["REGION_CERULEAN_CITY:SURF"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_4:SURF"], "Cerulean City West Exit (via Surf)", "Route 4 East Exit (via Surf)")

-- === REGION_CERULEAN_GYM ===
REGION_CERULEAN_GYM:connect_one_way(NAMED_NODES["REGION_CERULEAN_GYM:ROCKET"], "TODOBYSNOWFLAV")
REGION_CERULEAN_GYM:connect_one_way(NAMED_NODES["REGION_CERULEAN_GYM:MISTY"], "TODOBYSNOWFLAV")

-- === REGION_CERULEAN_POKECENTER_1F ===
REGION_CERULEAN_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Cerulean Pokecenter Stairs")

-- === REGION_CHERRYGROVE_CITY ===
REGION_CHERRYGROVE_CITY:connect_two_ways_entrance(REGION_CHERRYGROVE_MART, "mart")
REGION_CHERRYGROVE_CITY:connect_two_ways_entrance(REGION_CHERRYGROVE_POKECENTER_1F, "pokecenter")
REGION_CHERRYGROVE_CITY:connect_two_ways_entrance(REGION_CHERRYGROVE_GYM_SPEECH_HOUSE, "building")
REGION_CHERRYGROVE_CITY:connect_two_ways_entrance(REGION_GUIDE_GENTS_HOUSE, "building")
REGION_CHERRYGROVE_CITY:connect_two_ways_entrance(REGION_CHERRYGROVE_EVOLUTION_SPEECH_HOUSE, "building")
REGION_CHERRYGROVE_CITY:connect_two_ways(NAMED_NODES["REGION_CHERRYGROVE_CITY:FLOODED_MINE_ENTRANCE"], "Cherrygrove City Water Crossing (Mainland -> Flooded Mine)", "Cherrygrove City Water Crossing (Flooded Mine -> Mainland)")
REGION_CHERRYGROVE_CITY:connect_two_ways(REGION_ROUTE_30, "Cherrygrove City North Exit", "Route 30 South Exit")
REGION_CHERRYGROVE_CITY:connect_two_ways(REGION_ROUTE_29, "Cherrygrove City East Exit", "Route 29 West Exit")

-- === REGION_CHERRYGROVE_POKECENTER_1F ===
REGION_CHERRYGROVE_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Cherrygrove Pokecenter Stairs")

-- === REGION_CIANWOOD_CITY ===
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_MANIAS_HOUSE, "building")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_CIANWOOD_GYM, "gym")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_CIANWOOD_POKECENTER_1F, "pokecenter")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_CIANWOOD_PHARMACY, "mart")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_CIANWOOD_PHOTO_STUDIO, "building")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_CIANWOOD_LUGIA_SPEECH_HOUSE, "building")
REGION_CIANWOOD_CITY:connect_two_ways_entrance(REGION_POKE_SEERS_HOUSE, "building")
REGION_CIANWOOD_CITY:connect_two_ways(REGION_ROUTE_41, "Cianwood City East Exit", "Route 41 West Exit")

-- === REGION_CIANWOOD_GYM ===
REGION_CIANWOOD_GYM:connect_two_ways(NAMED_NODES["REGION_CIANWOOD_GYM:STRENGTH"], "TODOBYSNOWFLAV")

-- === REGION_CIANWOOD_POKECENTER_1F ===
REGION_CIANWOOD_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Cianwood Pokecenter Stairs")

-- === REGION_CINNABAR_ISLAND ===
REGION_CINNABAR_ISLAND:connect_two_ways_entrance(REGION_CINNABAR_POKECENTER_1F, "pokecenter")
REGION_CINNABAR_ISLAND:connect_two_ways(NAMED_NODES["REGION_ROUTE_21:SOUTH"], "Cinnabar Island North Exit", "Route 21 South Exit")
REGION_CINNABAR_ISLAND:connect_two_ways(REGION_ROUTE_20, "Cinnabar Island East Exit", "Route 20 West Exit")

-- === REGION_CINNABAR_POKECENTER_1F ===
REGION_CINNABAR_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Cinnabar Pokecenter Stairs")

-- === REGION_COLOSSEUM ===
REGION_COLOSSEUM:connect_two_ways(REGION_POKECENTER_2F, "TODOBYSNOWFLAV")

-- === REGION_COPYCATS_HOUSE_1F ===
REGION_COPYCATS_HOUSE_1F:connect_two_ways_entrance(REGION_SAFFRON_CITY, "building")
REGION_COPYCATS_HOUSE_1F:connect_two_ways_entrance(REGION_COPYCATS_HOUSE_2F, "building_interior")

-- === REGION_DANCE_THEATER ===
REGION_DANCE_THEATER:connect_two_ways_entrance(REGION_ECRUTEAK_CITY, "building")

-- === REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHEAST ===
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHEAST"]:connect_two_ways_entrance(REGION_ROUTE_45, "dungeon")
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHEAST"]:connect_two_ways(NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHEAST"], "Dark Cave (Blackthorn Side) Water Crossing (Northeast -> Southeast)", "Dark Cave (Blackthorn Side) Water Crossing (Southeast -> Northeast)")

-- === REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHEAST ===
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHEAST"]:connect_two_ways(NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHWEST"], "Dark Cave (Blackthorn Side) Water Crossing (Southeast -> Northwest)", "Dark Cave (Blackthorn Side) Water Crossing (Northwest -> Southeast)")
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHEAST"]:connect_one_way(NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHWEST"], "TODOBYSNOWFLAV")

-- === REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHWEST ===
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:NORTHWEST"]:connect_one_way(NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHWEST"], "TODOBYSNOWFLAV")

-- === REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHWEST ===
NAMED_NODES["REGION_DARK_CAVE_BLACKTHORN_ENTRANCE:SOUTHWEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTH"], "dungeon_interior")

-- === REGION_DARK_CAVE_VIOLET_ENTRANCE:WEST ===
NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:WEST"]:connect_two_ways_entrance(REGION_ROUTE_31, "dungeon")
NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:WEST"]:connect_two_ways(NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTHEAST"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:WEST"]:connect_two_ways(NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTH"], "Dark Cave (Violet Side) Water Crossing (West -> North)", "Dark Cave (Violet Side) Water Crossing (North -> West)")

-- === REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTHEAST ===
NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:NORTHEAST"]:connect_two_ways(NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:SOUTHEAST"], "TODOBYSNOWFLAV")

-- === REGION_DARK_CAVE_VIOLET_ENTRANCE:SOUTHEAST ===
NAMED_NODES["REGION_DARK_CAVE_VIOLET_ENTRANCE:SOUTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_46:NORTH"], "dungeon")

-- === REGION_ROUTE_34:DAY_CARE_YARD ===
NAMED_NODES["REGION_ROUTE_34:DAY_CARE_YARD"]:connect_two_ways_entrance(REGION_DAY_CARE, "building")

-- === REGION_DAY_CARE ===
REGION_DAY_CARE:connect_two_ways_entrance(REGION_ROUTE_34, "building")

-- === REGION_DAY_OF_WEEK_SIBLINGS_HOUSE ===
REGION_DAY_OF_WEEK_SIBLINGS_HOUSE:connect_two_ways_entrance(REGION_ROUTE_26, "building")

-- === REGION_DIGLETTS_CAVE ===
REGION_DIGLETTS_CAVE:connect_two_ways_entrance(NAMED_NODES["REGION_DIGLETTS_CAVE:SOUTH_ENTRANCE"], "dungeon_interior")
REGION_DIGLETTS_CAVE:connect_two_ways_entrance(NAMED_NODES["REGION_DIGLETTS_CAVE:NORTH_ENTRANCE"], "dungeon_interior")

-- === REGION_DIGLETTS_CAVE:SOUTH_ENTRANCE ===
NAMED_NODES["REGION_DIGLETTS_CAVE:SOUTH_ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_VERMILION_CITY:DIGLETTS_CAVE_ENTRANCE"], "dungeon")

-- === REGION_DIGLETTS_CAVE:NORTH_ENTRANCE ===
NAMED_NODES["REGION_DIGLETTS_CAVE:NORTH_ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_2:NORTHEAST"], "dungeon")

-- === REGION_DRAGON_SHRINE:ENTRANCE ===
NAMED_NODES["REGION_DRAGON_SHRINE:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_DRAGONS_DEN_B1F:SOUTH"], "dungeon_interior")
NAMED_NODES["REGION_DRAGON_SHRINE:ENTRANCE"]:connect_one_way(REGION_DRAGON_SHRINE, "TODOBYSNOWFLAV")

-- === REGION_DRAGONS_DEN_1F:UPPER ===
NAMED_NODES["REGION_DRAGONS_DEN_1F:UPPER"]:connect_two_ways_entrance(NAMED_NODES["REGION_DRAGONS_DEN_1F:LOWER"], "dungeon_interior")

-- === REGION_DRAGONS_DEN_1F:LOWER ===
NAMED_NODES["REGION_DRAGONS_DEN_1F:LOWER"]:connect_two_ways_entrance(NAMED_NODES["REGION_DRAGONS_DEN_B1F:NORTH"], "dungeon_interior")

-- === REGION_DRAGONS_DEN_B1F:NORTH ===
NAMED_NODES["REGION_DRAGONS_DEN_B1F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_DRAGONS_DEN_B1F:CENTER"], "Dragon's Den B1F North Water Crossing (North -> Center)", "TODOBYSNOWFLAV")
NAMED_NODES["REGION_DRAGONS_DEN_B1F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_DRAGONS_DEN_B1F:WEST"], "Dragon's Den B1F North Water Crossing (North -> West)", "Dragon's Den B1F North Water Crossing (West -> North)")

-- === REGION_DRAGONS_DEN_B1F:WEST ===
NAMED_NODES["REGION_DRAGONS_DEN_B1F:WEST"]:connect_two_ways(NAMED_NODES["REGION_DRAGONS_DEN_B1F:SOUTH"], "Dragon's Den B1F Whirlpool Crosing (Southbound)", "Dragon's Den B1F Whirlpool Crosing (Northbound)")

-- === REGION_DRAGONS_DEN_B1F:SOUTH ===
NAMED_NODES["REGION_DRAGONS_DEN_B1F:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_DRAGONS_DEN_B1F:SOUTHEAST"], "Dragon's Den B1F South Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_EARLS_POKEMON_ACADEMY ===
REGION_EARLS_POKEMON_ACADEMY:connect_two_ways_entrance(REGION_VIOLET_CITY, "building")

-- === REGION_ECRUTEAK_CITY ===
REGION_ECRUTEAK_CITY:connect_two_ways(REGION_ROUTE_37, "Ecruteak City South Exit", "Route 37 North Exit")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ROUTE_42_ECRUTEAK_GATE, "gate")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_TIN_TOWER_ENTRANCE, "gate")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_POKECENTER_1F, "pokecenter")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_LUGIA_SPEECH_HOUSE, "building")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_MART, "mart")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_GYM, "gym")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ECRUTEAK_ITEMFINDER_HOUSE, "building")
REGION_ECRUTEAK_CITY:connect_two_ways_entrance(REGION_ROUTE_38_ECRUTEAK_GATE, "gate")

-- === REGION_ECRUTEAK_GYM ===
REGION_ECRUTEAK_GYM:connect_one_way(NAMED_NODES["REGION_ECRUTEAK_GYM:INTERIOR"], "TODOBYSNOWFLAV")

-- === REGION_ECRUTEAK_POKECENTER_1F ===
REGION_ECRUTEAK_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Ecruteak Pokecenter Stairs")

-- === REGION_ECRUTEAK_TIN_TOWER_ENTRANCE ===
REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:connect_two_ways(NAMED_NODES["REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:BEHIND_SAGE"], "TODOBYSNOWFLAV")

-- === REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:BEHIND_SAGE ===
NAMED_NODES["REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:BEHIND_SAGE"]:connect_two_ways_entrance(NAMED_NODES["REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:UNDERGROUND"], "gate")

-- === REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:UNDERGROUND ===
NAMED_NODES["REGION_ECRUTEAK_TIN_TOWER_ENTRANCE:UNDERGROUND"]:connect_two_ways_entrance(REGION_WISE_TRIOS_ROOM, "gate")

-- === REGION_ELMS_HOUSE ===
REGION_ELMS_HOUSE:connect_two_ways_entrance(REGION_NEW_BARK_TOWN, "building")

-- === REGION_ELMS_LAB ===
REGION_ELMS_LAB:connect_two_ways_entrance(REGION_NEW_BARK_TOWN, "pokecenter")

-- === REGION_FAST_SHIP_1F ===
REGION_FAST_SHIP_1F:connect_two_ways(NAMED_NODES["REGION_VERMILION_PORT:TICKET"], "S.S. Aqua Vermilion Exit", "S.S. Aqua Vermilion Entrance")
REGION_FAST_SHIP_1F:connect_two_ways(NAMED_NODES["REGION_OLIVINE_PORT:TICKET"], "S.S. Aqua Olivine Exit", "S.S. Aqua Olivine Entrance")
REGION_FAST_SHIP_1F:connect_two_ways(REGION_FAST_SHIP_CABINS_NNW_NNE_NE, "S.S. Aqua North Cabin Entrances", "S.S. Aqua North Cabin Exits")
REGION_FAST_SHIP_1F:connect_two_ways(REGION_FAST_SHIP_CABINS_SW_SSW_NW, "S.S. Aqua Southwest Cabin Entrances", "S.S. Aqua Southwest Cabin Exits")
REGION_FAST_SHIP_1F:connect_two_ways(REGION_FAST_SHIP_CABINS_SE_SSE_CAPTAINS_CABIN, "S.S. Aqua Southeast+Captain's Cabin Entrances", "S.S. Aqua Southeast+Captain's Cabin Exits")
REGION_FAST_SHIP_1F:connect_two_ways(REGION_FAST_SHIP_B1F, "S.S. Aqua 1F Stairs", "S.S. Aqua B1F Stairs")

-- === REGION_FIGHTING_DOJO ===
REGION_FIGHTING_DOJO:connect_two_ways_entrance(REGION_SAFFRON_CITY, "gym")

-- === REGION_FUCHSIA_CITY ===
REGION_FUCHSIA_CITY:connect_two_ways(REGION_ROUTE_18, "Fuchsia City West Exit", "Route 18 East Exit")
REGION_FUCHSIA_CITY:connect_two_ways(NAMED_NODES["REGION_FUCHSIA_CITY:CUT"], "TODOBYSNOWFLAV")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_SAFARI_ZONE_MAIN_OFFICE, "building")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_FUCHSIA_GYM, "gym")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_FUCHSIA_POKECENTER_1F, "pokecenter")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_SAFARI_ZONE_WARDENS_HOME, "building")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_ROUTE_15_FUCHSIA_GATE, "gate")
REGION_FUCHSIA_CITY:connect_two_ways_entrance(REGION_ROUTE_19_FUCHSIA_GATE, "gate")

-- === REGION_FUCHSIA_CITY:CUT ===
NAMED_NODES["REGION_FUCHSIA_CITY:CUT"]:connect_two_ways_entrance(REGION_FUCHSIA_MART, "mart")

-- === REGION_FUCHSIA_POKECENTER_1F ===
REGION_FUCHSIA_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Fuchsia Pokecenter Stairs")

-- === REGION_GOLDENROD_BIKE_SHOP ===
REGION_GOLDENROD_BIKE_SHOP:connect_two_ways_entrance(REGION_GOLDENROD_CITY, "mart")

-- === REGION_GOLDENROD_CITY ===
REGION_GOLDENROD_CITY:connect_two_ways(REGION_ROUTE_34, "Goldenrod City South Exit", "Route 34 North Exit")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_GYM, "gym")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_HAPPINESS_RATER, "building")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_MAGNET_TRAIN_STATION, "building")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_FLOWER_SHOP, "mart")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_PP_SPEECH_HOUSE, "building")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_NAME_RATER, "building")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_1F, "mart")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_GAME_CORNER, "building")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_RADIO_TOWER_1F, "dungeon")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_ROUTE_35_GOLDENROD_GATE, "gate")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:NORTH_ENTRANCE"], "dungeon")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:SOUTH_ENTRANCE"], "dungeon")
REGION_GOLDENROD_CITY:connect_two_ways_entrance(REGION_GOLDENROD_POKECENTER_1F, "pokecenter")

-- === REGION_GOLDENROD_DEPT_STORE_1F ===
REGION_GOLDENROD_DEPT_STORE_1F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_2F, "mart_interior")
REGION_GOLDENROD_DEPT_STORE_1F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:1F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_2F ===
REGION_GOLDENROD_DEPT_STORE_2F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_3F, "mart_interior")
REGION_GOLDENROD_DEPT_STORE_2F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:2F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_3F ===
REGION_GOLDENROD_DEPT_STORE_3F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_4F, "mart_interior")
REGION_GOLDENROD_DEPT_STORE_3F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:3F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_4F ===
REGION_GOLDENROD_DEPT_STORE_4F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_5F, "mart_interior")
REGION_GOLDENROD_DEPT_STORE_4F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:4F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_5F ===
REGION_GOLDENROD_DEPT_STORE_5F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_6F, "mart_interior")
REGION_GOLDENROD_DEPT_STORE_5F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:5F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_6F ===
REGION_GOLDENROD_DEPT_STORE_6F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:6F"], "elevator")
REGION_GOLDENROD_DEPT_STORE_6F:connect_two_ways_entrance(REGION_GOLDENROD_DEPT_STORE_ROOF, "mart_interior")

-- === REGION_GOLDENROD_DEPT_STORE_B1F ===
REGION_GOLDENROD_DEPT_STORE_B1F:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_B1F:WAREHOUSE"], "TODOBYSNOWFLAV")
REGION_GOLDENROD_DEPT_STORE_B1F:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:B1F"], "elevator")

-- === REGION_GOLDENROD_DEPT_STORE_B1F:WAREHOUSE ===
NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_B1F:WAREHOUSE"]:connect_two_ways_entrance(REGION_GOLDENROD_UNDERGROUND_WAREHOUSE, "dungeon")

-- === REGION_GOLDENROD_DEPT_STORE_ELEVATOR ===
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:B1F"], "Goldenrod Dept. Store Elevator Ride (to B1F)", "Goldenrod Dept. Store Elevator Ride (from B1F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:1F"], "Goldenrod Dept. Store Elevator Ride (to 1F)", "Goldenrod Dept. Store Elevator Ride (from 1F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:2F"], "Goldenrod Dept. Store Elevator Ride (to 2F)", "Goldenrod Dept. Store Elevator Ride (from 2F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:3F"], "Goldenrod Dept. Store Elevator Ride (to 3F)", "Goldenrod Dept. Store Elevator Ride (from 3F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:4F"], "Goldenrod Dept. Store Elevator Ride (to 4F)", "Goldenrod Dept. Store Elevator Ride (from 4F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:5F"], "Goldenrod Dept. Store Elevator Ride (to 5F)", "Goldenrod Dept. Store Elevator Ride (from 5F)")
REGION_GOLDENROD_DEPT_STORE_ELEVATOR:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_DEPT_STORE_ELEVATOR:6F"], "Goldenrod Dept. Store Elevator Ride (to 6F)", "Goldenrod Dept. Store Elevator Ride (from 6F)")

-- === REGION_GOLDENROD_MAGNET_TRAIN_STATION ===
REGION_GOLDENROD_MAGNET_TRAIN_STATION:connect_two_ways(REGION_SAFFRON_MAGNET_TRAIN_STATION, "Magnet Train (Eastbound)", "Magnet Train (Westbound)")

-- === REGION_GOLDENROD_POKECENTER_1F ===
REGION_GOLDENROD_POKECENTER_1F:connect_two_ways(REGION_POKECOM_CENTER_ADMIN_OFFICE_MOBILE, "TODOBYSNOWFLAV")
REGION_GOLDENROD_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Goldenrod Pokecenter Stairs")

-- === REGION_GOLDENROD_UNDERGROUND:BASEMENT_LANDING ===
NAMED_NODES["REGION_GOLDENROD_UNDERGROUND:BASEMENT_LANDING"]:connect_two_ways_entrance(REGION_GOLDENROD_UNDERGROUND, "dungeon_interior")
NAMED_NODES["REGION_GOLDENROD_UNDERGROUND:BASEMENT_LANDING"]:connect_two_ways_entrance(REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES, "dungeon_interior")

-- === REGION_GOLDENROD_UNDERGROUND ===
REGION_GOLDENROD_UNDERGROUND:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:NORTH_ENTRANCE"], "dungeon_interior")
REGION_GOLDENROD_UNDERGROUND:connect_two_ways_entrance(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:SOUTH_ENTRANCE"], "dungeon_interior")

-- === REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES ===
REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:connect_two_ways_entrance(REGION_GOLDENROD_UNDERGROUND_WAREHOUSE, "dungeon_interior")
REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_SWITCH_ROOM_ENTRANCES:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_GOLDENROD_UNDERGROUND_WAREHOUSE ===
REGION_GOLDENROD_UNDERGROUND_WAREHOUSE:connect_two_ways(NAMED_NODES["REGION_GOLDENROD_UNDERGROUND_WAREHOUSE:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_HALL_OF_FAME ===
REGION_HALL_OF_FAME:connect_two_ways(REGION_LANCES_ROOM, "Hall of Fame Exit", "Hall of Fame Entrance")

-- === REGION_ICE_PATH_1F:WEST ===
NAMED_NODES["REGION_ICE_PATH_1F:WEST"]:connect_two_ways_entrance(REGION_ROUTE_44, "dungeon")
NAMED_NODES["REGION_ICE_PATH_1F:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"], "dungeon_interior")

-- === REGION_ICE_PATH_1F:EAST ===
NAMED_NODES["REGION_ICE_PATH_1F:EAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ICE_PATH_B1F:SOUTH"], "dungeon_interior")

-- === REGION_ICE_PATH_B1F:NORTH ===
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_two_ways_entrance(REGION_ICE_PATH_B2F_MAHOGANY_SIDE, "dungeon_interior")
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_one_way_entrance(NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_1"], "one_way")
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_one_way_entrance(NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_2"], "one_way")
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ICE_PATH_B1F:NORTH:STRENGTH"], "TODOBYSNOWFLAV")

-- === REGION_ICE_PATH_B1F:NORTH:STRENGTH ===
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH:STRENGTH"]:connect_one_way_entrance(NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_3"], "one_way")
NAMED_NODES["REGION_ICE_PATH_B1F:NORTH:STRENGTH"]:connect_one_way_entrance(NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_4"], "one_way")

-- === REGION_ICE_PATH_B1F:SOUTH ===
NAMED_NODES["REGION_ICE_PATH_B1F:SOUTH"]:connect_two_ways_entrance(REGION_ICE_PATH_B2F_BLACKTHORN_SIDE, "dungeon_interior")

-- === REGION_ICE_PATH_B2F_BLACKTHORN_SIDE ===
REGION_ICE_PATH_B2F_BLACKTHORN_SIDE:connect_two_ways_entrance(REGION_ICE_PATH_B3F, "dungeon_interior")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE ===
REGION_ICE_PATH_B2F_MAHOGANY_SIDE:connect_two_ways(NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:MIDDLE"], "Ice Path B2F (Mahogany Side) Central Platform Access", "Ice Path B2F (Mahogany Side) Outer Platforms Access")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_1 ===
NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_1"]:connect_one_way(REGION_ICE_PATH_B2F_MAHOGANY_SIDE, "Ice Path B2F (Mahogany Side) Northeast Hole Fall")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_2 ===
NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_2"]:connect_one_way(REGION_ICE_PATH_B2F_MAHOGANY_SIDE, "Ice Path B2F (Mahogany Side) Northwest Hole Fall")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_3 ===
NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_3"]:connect_one_way(REGION_ICE_PATH_B2F_MAHOGANY_SIDE, "Ice Path B2F (Mahogany Side) Southwest Hole Fall")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_4 ===
NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:HOLE_4"]:connect_one_way(REGION_ICE_PATH_B2F_MAHOGANY_SIDE, "Ice Path B2F (Mahogany Side) Southeast Hole Fall")

-- === REGION_ICE_PATH_B2F_MAHOGANY_SIDE:MIDDLE ===
NAMED_NODES["REGION_ICE_PATH_B2F_MAHOGANY_SIDE:MIDDLE"]:connect_two_ways_entrance(REGION_ICE_PATH_B3F, "dungeon_interior")

-- === REGION_ILEX_FOREST:NORTH ===
NAMED_NODES["REGION_ILEX_FOREST:NORTH"]:connect_two_ways_entrance(REGION_ROUTE_34_ILEX_FOREST_GATE, "dungeon")
NAMED_NODES["REGION_ILEX_FOREST:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ILEX_FOREST:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_ILEX_FOREST:SOUTH ===
NAMED_NODES["REGION_ILEX_FOREST:SOUTH"]:connect_two_ways_entrance(REGION_ILEX_FOREST_AZALEA_GATE, "dungeon")

-- === REGION_INDIGO_PLATEAU_POKECENTER_1F ===
REGION_INDIGO_PLATEAU_POKECENTER_1F:connect_two_ways_entrance(REGION_ROUTE_23, "pokecenter")
REGION_INDIGO_PLATEAU_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Indigo Plateau Pokecenter Stairs")
REGION_INDIGO_PLATEAU_POKECENTER_1F:connect_two_ways(NAMED_NODES["REGION_INDIGO_PLATEAU_POKECENTER_1F:E4_GATE"], "TODOBYSNOWFLAV")
REGION_INDIGO_PLATEAU_POKECENTER_1F:connect_one_way(REGION_NEW_BARK_TOWN, "Indigo Plateau Abra Teleport")

-- === REGION_INDIGO_PLATEAU_POKECENTER_1F:E4_GATE ===
NAMED_NODES["REGION_INDIGO_PLATEAU_POKECENTER_1F:E4_GATE"]:connect_two_ways_entrance(REGION_WILLS_ROOM, "pokemon_league")
NAMED_NODES["REGION_INDIGO_PLATEAU_POKECENTER_1F:E4_GATE"]:connect_one_way(NAMED_NODES["REGION_INDIGO_PLATEAU_POKECENTER_1F:RIVAL"], "TODOBYSNOWFLAV")

-- === REGION_KARENS_ROOM ===
REGION_KARENS_ROOM:connect_two_ways_entrance(REGION_LANCES_ROOM, "pokemon_league")

-- === REGION_KOGAS_ROOM ===
REGION_KOGAS_ROOM:connect_two_ways_entrance(REGION_WILLS_ROOM, "pokemon_league")

-- === REGION_LAKE_OF_RAGE ===
REGION_LAKE_OF_RAGE:connect_two_ways(REGION_ROUTE_43, "Lake of Rage South Exit", "Route 43 North Exit")
REGION_LAKE_OF_RAGE:connect_two_ways(NAMED_NODES["REGION_LAKE_OF_RAGE:CUT"], "TODOBYSNOWFLAV")
REGION_LAKE_OF_RAGE:connect_two_ways_entrance(REGION_LAKE_OF_RAGE_MAGIKARP_HOUSE, "building")
REGION_LAKE_OF_RAGE:connect_one_way(NAMED_NODES["REGION_LAKE_OF_RAGE:GYARADOS"], "Lake of Rage Gyarados Access")

-- === REGION_LAKE_OF_RAGE:HIDDEN_POWER_HOUSE ===
NAMED_NODES["REGION_LAKE_OF_RAGE:HIDDEN_POWER_HOUSE"]:connect_two_ways(NAMED_NODES["REGION_LAKE_OF_RAGE:CUT"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_LAKE_OF_RAGE:HIDDEN_POWER_HOUSE"]:connect_two_ways_entrance(REGION_LAKE_OF_RAGE_HIDDEN_POWER_HOUSE, "building")

-- === REGION_LAV_RADIO_TOWER_1F ===
REGION_LAV_RADIO_TOWER_1F:connect_two_ways_entrance(REGION_LAVENDER_TOWN, "building")

-- === REGION_LAVENDER_MART ===
REGION_LAVENDER_MART:connect_two_ways_entrance(REGION_LAVENDER_TOWN, "mart")

-- === REGION_LAVENDER_NAME_RATER ===
REGION_LAVENDER_NAME_RATER:connect_two_ways_entrance(REGION_LAVENDER_TOWN, "building")

-- === REGION_LAVENDER_POKECENTER_1F ===
REGION_LAVENDER_POKECENTER_1F:connect_two_ways_entrance(REGION_LAVENDER_TOWN, "pokecenter")
REGION_LAVENDER_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Lavender Pokecenter Stairs")

-- === REGION_LAVENDER_SPEECH_HOUSE ===
REGION_LAVENDER_SPEECH_HOUSE:connect_two_ways_entrance(REGION_LAVENDER_TOWN, "building")

-- === REGION_LAVENDER_TOWN ===
REGION_LAVENDER_TOWN:connect_two_ways(REGION_ROUTE_10_SOUTH, "Lavender Town North Exit", "Route 10 South Exit")
REGION_LAVENDER_TOWN:connect_two_ways(NAMED_NODES["REGION_ROUTE_12:NORTH"], "Lavender Town South Exit", "Route 12 North Exit")
REGION_LAVENDER_TOWN:connect_two_ways(REGION_ROUTE_8, "Lavender Town West Exit", "Route 8 East Exit")
REGION_LAVENDER_TOWN:connect_two_ways_entrance(REGION_MR_FUJIS_HOUSE, "building")
REGION_LAVENDER_TOWN:connect_two_ways_entrance(REGION_SOUL_HOUSE, "building")

-- === REGION_MAHOGANY_GYM ===
REGION_MAHOGANY_GYM:connect_two_ways_entrance(REGION_MAHOGANY_TOWN, "gym")

-- === REGION_MAHOGANY_MART_1F ===
REGION_MAHOGANY_MART_1F:connect_two_ways_entrance(REGION_MAHOGANY_TOWN, "mart")
REGION_MAHOGANY_MART_1F:connect_two_ways_entrance(REGION_TEAM_ROCKET_BASE_B1F, "dungeon")

-- === REGION_MAHOGANY_POKECENTER_1F ===
REGION_MAHOGANY_POKECENTER_1F:connect_two_ways_entrance(REGION_MAHOGANY_TOWN, "pokecenter")
REGION_MAHOGANY_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Mahogany Pokecenter Stairs")

-- === REGION_MAHOGANY_RED_GYARADOS_SPEECH_HOUSE ===
REGION_MAHOGANY_RED_GYARADOS_SPEECH_HOUSE:connect_two_ways_entrance(NAMED_NODES["REGION_MAHOGANY_TOWN:EAST"], "building")

-- === REGION_MAHOGANY_TOWN ===
REGION_MAHOGANY_TOWN:connect_two_ways(NAMED_NODES["REGION_MAHOGANY_TOWN:EAST"], "TODOBYSNOWFLAV")
REGION_MAHOGANY_TOWN:connect_two_ways(NAMED_NODES["REGION_ROUTE_42:EAST"], "Mahogany Town West Exit", "Route 42 East Exit")
REGION_MAHOGANY_TOWN:connect_two_ways_entrance(REGION_ROUTE_43_MAHOGANY_GATE, "gate")

-- === REGION_MAHOGANY_TOWN:EAST ===
NAMED_NODES["REGION_MAHOGANY_TOWN:EAST"]:connect_two_ways(REGION_ROUTE_44, "Mahogany Town East Exit", "Route 44 West Exit")

-- === REGION_MOBILE_BATTLE_ROOM ===
REGION_MOBILE_BATTLE_ROOM:connect_two_ways(REGION_POKECENTER_2F, "TODOBYSNOWFLAV")

-- === REGION_MOBILE_TRADE_ROOM ===
REGION_MOBILE_TRADE_ROOM:connect_two_ways(REGION_POKECENTER_2F, "TODOBYSNOWFLAV")

-- === REGION_MOUNT_MOON ===
REGION_MOUNT_MOON:connect_two_ways_entrance(REGION_ROUTE_3, "dungeon")
REGION_MOUNT_MOON:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_4:WEST"], "dungeon")
REGION_MOUNT_MOON:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MOON:NORTH_ENTRANCE"], "dungeon_interior")

-- === REGION_MOUNT_MOON:LEDGE ===
NAMED_NODES["REGION_MOUNT_MOON:LEDGE"]:connect_one_way(REGION_MOUNT_MOON, "Mount Moon Southeast Ledge Jump")
NAMED_NODES["REGION_MOUNT_MOON:LEDGE"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MOON:SOUTH_ENTRANCE"], "dungeon_interior")

-- === REGION_MOUNT_MOON:NORTH_ENTRANCE ===
NAMED_NODES["REGION_MOUNT_MOON:NORTH_ENTRANCE"]:connect_two_ways_entrance(REGION_MOUNT_MOON_SQUARE, "dungeon_interior")

-- === REGION_MOUNT_MOON:SOUTH_ENTRANCE ===
NAMED_NODES["REGION_MOUNT_MOON:SOUTH_ENTRANCE"]:connect_two_ways_entrance(REGION_MOUNT_MOON_SQUARE, "dungeon_interior")

-- === REGION_MOUNT_MOON_GIFT_SHOP ===
REGION_MOUNT_MOON_GIFT_SHOP:connect_two_ways_entrance(REGION_MOUNT_MOON_SQUARE, "mart")

-- === REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways(REGION_MOUNT_MORTAR_1F_INSIDE, "TODOBYSNOWFLAV")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHWEST"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHEAST"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:WEST"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:EAST"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:WATERFALL_ISLAND"], "dungeon_interior")

-- === REGION_MOUNT_MORTAR_1F_INSIDE:NORTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:NORTH"]:connect_one_way(REGION_MOUNT_MORTAR_1F_INSIDE, "TODOBYSNOWFLAV")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_B1F:NORTHWEST"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_INSIDE:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:NORTH"], "dungeon_interior")

-- === REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHWEST:ENTRANCE ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHWEST:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_42:WEST"], "dungeon")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHWEST:ENTRANCE"]:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHWEST"], "TODOBYSNOWFLAV")

-- === REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_42:CENTER"], "dungeon")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_B1F:SOUTH"], "dungeon_interior")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:NORTH"], "Mount Mortar 1F Outside Waterfall Ascent", "Mount Mortar 1F Outside Waterfall Descent")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:WATERFALL_ISLAND"], "Mount Mortar 1F Outside Water Crossing (South -> Waterfall Center)", "Mount Mortar 1F Outside Water Crossing (Waterfall Center -> South)")

-- === REGION_MOUNT_MORTAR_1F_OUTSIDE:NORTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:SOUTH"], "dungeon_interior")

-- === REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHEAST:ENTRANCE ===
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHEAST:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_42:EAST"], "dungeon")
NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHEAST:ENTRANCE"]:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_1F_OUTSIDE:SOUTHEAST"], "TODOBYSNOWFLAV")

-- === REGION_MOUNT_MORTAR_2F_INSIDE:SOUTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:SOUTHWEST"], "Mount Mortar 2F Water Crossing (South -> Southwest)", "TODOBYSNOWFLAV")
NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:SOUTH"]:connect_two_ways(REGION_MOUNT_MORTAR_2F_INSIDE, "Mount Mortar 2F Water Crossing (South -> Center)", "Mount Mortar 2F Water Crossing (Center -> South)")

-- === REGION_MOUNT_MORTAR_2F_INSIDE ===
REGION_MOUNT_MORTAR_2F_INSIDE:connect_two_ways(NAMED_NODES["REGION_MOUNT_MORTAR_2F_INSIDE:NORTH"], "Mount Mortar 2F Water Crossing (Center -> North)", "Mount Mortar 2F Water Crossing (North -> Center)")

-- === REGION_MOUNT_MORTAR_B1F:SOUTH ===
NAMED_NODES["REGION_MOUNT_MORTAR_B1F:SOUTH"]:connect_two_ways(REGION_MOUNT_MORTAR_B1F, "Mount Mortar B1F Water Crossing (South -> Center)", "Mount Mortar B1F Water Crossing (Center -> South)")

-- === REGION_MOUNT_MORTAR_B1F:NORTHWEST ===
NAMED_NODES["REGION_MOUNT_MORTAR_B1F:NORTHWEST"]:connect_one_way(REGION_MOUNT_MORTAR_B1F, "TODOBYSNOWFLAV")

-- === REGION_MR_POKEMONS_HOUSE ===
REGION_MR_POKEMONS_HOUSE:connect_two_ways_entrance(REGION_ROUTE_30, "building")

-- === REGION_MR_PSYCHICS_HOUSE ===
REGION_MR_PSYCHICS_HOUSE:connect_two_ways_entrance(REGION_SAFFRON_CITY, "building")

-- === REGION_NATIONAL_PARK ===
REGION_NATIONAL_PARK:connect_two_ways(REGION_ROUTE_36_NATIONAL_PARK_GATE, "National Park East Exit", "National Park East Entrance")
REGION_NATIONAL_PARK:connect_two_ways(NAMED_NODES["REGION_ROUTE_35_NATIONAL_PARK_GATE:BIKE"], "National Park South Exit", "National Park South Entrance")

-- === REGION_NATIONAL_PARK:CONTEST ===
NAMED_NODES["REGION_NATIONAL_PARK:CONTEST"]:connect_one_way(REGION_ROUTE_35_NATIONAL_PARK_GATE, "Bug Catching Contest South Exit")
NAMED_NODES["REGION_NATIONAL_PARK:CONTEST"]:connect_two_ways(REGION_ROUTE_36_NATIONAL_PARK_GATE, "Bug Catching Contest East Exit", "Bug Catching Contest East Entrance")

-- === REGION_NEW_BARK_TOWN ===
REGION_NEW_BARK_TOWN:connect_two_ways(REGION_ROUTE_29, "New Bark Town West Exit", "Route 29 East Exit")
REGION_NEW_BARK_TOWN:connect_two_ways(NAMED_NODES["REGION_ROUTE_27:WEST"], "New Bark Town East Exit", "Route 27 West Exit")
REGION_NEW_BARK_TOWN:connect_two_ways_entrance(REGION_PLAYERS_HOUSE_1F, "building")
REGION_NEW_BARK_TOWN:connect_two_ways_entrance(REGION_PLAYERS_NEIGHBORS_HOUSE, "building")

-- === REGION_OAKS_LAB ===
REGION_OAKS_LAB:connect_two_ways_entrance(REGION_PALLET_TOWN, "building")

-- === REGION_OLIVINE_CAFE ===
REGION_OLIVINE_CAFE:connect_two_ways_entrance(REGION_OLIVINE_CITY, "building")

-- === REGION_OLIVINE_CITY ===
REGION_OLIVINE_CITY:connect_two_ways(REGION_ROUTE_39, "Olivine City North Exit", "Route 39 South Exit")
REGION_OLIVINE_CITY:connect_two_ways(REGION_ROUTE_40, "Olivine City West Exit", "Route 40 East Exit")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_POKECENTER_1F, "pokecenter")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_GYM, "gym")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_TIMS_HOUSE, "building")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_PUNISHMENT_SPEECH_HOUSE, "building")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_GOOD_ROD_HOUSE, "building")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_MART, "mart")
REGION_OLIVINE_CITY:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_1F, "dungeon")
REGION_OLIVINE_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_OLIVINE_PORT_PASSAGE:ENTRANCE"], "dungeon")

-- === REGION_OLIVINE_GYM ===
REGION_OLIVINE_GYM:connect_one_way(NAMED_NODES["REGION_OLIVINE_GYM:JASMINE"], "TODOBYSNOWFLAV")

-- === REGION_OLIVINE_LIGHTHOUSE_1F ===
REGION_OLIVINE_LIGHTHOUSE_1F:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_2F, "dungeon_interior")

-- === REGION_OLIVINE_LIGHTHOUSE_2F ===
REGION_OLIVINE_LIGHTHOUSE_2F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_2F:POWER"], "TODOBYSNOWFLAV")
REGION_OLIVINE_LIGHTHOUSE_2F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_2F:HOLE"], "Olivine Lighthouse 2F Hole Access")
REGION_OLIVINE_LIGHTHOUSE_2F:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_3F, "dungeon_interior")

-- === REGION_OLIVINE_LIGHTHOUSE_2F:HOLE ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_2F:HOLE"]:connect_one_way_entrance(REGION_OLIVINE_LIGHTHOUSE_1F, "one_way")

-- === REGION_OLIVINE_LIGHTHOUSE_3F ===
REGION_OLIVINE_LIGHTHOUSE_3F:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_4F, "dungeon_interior")
REGION_OLIVINE_LIGHTHOUSE_3F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_3F:HOLE"], "Olivine Lighthouse 3F Hole Access")

-- === REGION_OLIVINE_LIGHTHOUSE_3F:NORTH ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_3F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:CENTER"], "dungeon_interior")

-- === REGION_OLIVINE_LIGHTHOUSE_3F:HOLE ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_3F:HOLE"]:connect_one_way_entrance(REGION_OLIVINE_LIGHTHOUSE_2F, "one_way")

-- === REGION_OLIVINE_LIGHTHOUSE_4F ===
REGION_OLIVINE_LIGHTHOUSE_4F:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_5F, "dungeon_interior")
REGION_OLIVINE_LIGHTHOUSE_4F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:HOLE"], "Olivine Lighthouse 4F East Hole Access")
REGION_OLIVINE_LIGHTHOUSE_4F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:NORTH_HOLE"], "Olivine Lighthouse 4F North Hole Access (from East)")

-- === REGION_OLIVINE_LIGHTHOUSE_4F:CENTER ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:CENTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_5F:CENTER"], "dungeon_interior")
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:CENTER"]:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:NORTH_HOLE"], "Olivine Lighthouse 4F North Hole Access (from Center)")

-- === REGION_OLIVINE_LIGHTHOUSE_4F:NORTH_HOLE ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:NORTH_HOLE"]:connect_one_way_entrance(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_3F:NORTH"], "one_way")

-- === REGION_OLIVINE_LIGHTHOUSE_4F:HOLE ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_4F:HOLE"]:connect_one_way_entrance(REGION_OLIVINE_LIGHTHOUSE_3F, "one_way")

-- === REGION_OLIVINE_LIGHTHOUSE_5F ===
REGION_OLIVINE_LIGHTHOUSE_5F:connect_one_way(NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_5F:HOLE"], "Olivine Lighthouse 5F Hole Access")

-- === REGION_OLIVINE_LIGHTHOUSE_5F:CENTER ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_5F:CENTER"]:connect_two_ways_entrance(REGION_OLIVINE_LIGHTHOUSE_6F, "dungeon_interior")

-- === REGION_OLIVINE_LIGHTHOUSE_5F:HOLE ===
NAMED_NODES["REGION_OLIVINE_LIGHTHOUSE_5F:HOLE"]:connect_one_way_entrance(REGION_OLIVINE_LIGHTHOUSE_4F, "one_way")

-- === REGION_OLIVINE_LIGHTHOUSE_6F ===
REGION_OLIVINE_LIGHTHOUSE_6F:connect_one_way_entrance(REGION_OLIVINE_LIGHTHOUSE_5F, "one_way")

-- === REGION_OLIVINE_POKECENTER_1F ===
REGION_OLIVINE_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Olivine Pokecenter Stairs")

-- === REGION_OLIVINE_PORT ===
REGION_OLIVINE_PORT:connect_two_ways_entrance(NAMED_NODES["REGION_OLIVINE_PORT_PASSAGE:TUNNEL"], "dungeon_interior")
REGION_OLIVINE_PORT:connect_two_ways(NAMED_NODES["REGION_OLIVINE_PORT:TICKET"], "Olivine Port Ticket Inspection", "Olivine Port Access (from Ship)")

-- === REGION_OLIVINE_PORT_PASSAGE:ENTRANCE ===
NAMED_NODES["REGION_OLIVINE_PORT_PASSAGE:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_OLIVINE_PORT_PASSAGE:TUNNEL"], "dungeon_interior")

-- === REGION_PALLET_TOWN ===
REGION_PALLET_TOWN:connect_two_ways(REGION_ROUTE_1, "Pallet Town North Exit", "Route 1 South Exit")
REGION_PALLET_TOWN:connect_two_ways(NAMED_NODES["REGION_ROUTE_21:NORTH"], "Pallet Town South Exit", "Route 21 North Exit")
REGION_PALLET_TOWN:connect_two_ways_entrance(REGION_REDS_HOUSE_1F, "building")

-- === REGION_PEWTER_CITY ===
REGION_PEWTER_CITY:connect_two_ways(NAMED_NODES["REGION_ROUTE_2:WEST"], "Pewter City South Exit", "Route 2 North Exit")
REGION_PEWTER_CITY:connect_two_ways(REGION_ROUTE_3, "Pewter City East Exit", "Route 3 West Exit")
REGION_PEWTER_CITY:connect_two_ways_entrance(REGION_PEWTER_NIDORAN_SPEECH_HOUSE, "building")
REGION_PEWTER_CITY:connect_two_ways_entrance(REGION_PEWTER_GYM, "gym")
REGION_PEWTER_CITY:connect_two_ways_entrance(REGION_PEWTER_MART, "mart")
REGION_PEWTER_CITY:connect_two_ways_entrance(REGION_PEWTER_POKECENTER_1F, "pokecenter")
REGION_PEWTER_CITY:connect_two_ways_entrance(REGION_PEWTER_SNOOZE_SPEECH_HOUSE, "building")

-- === REGION_PEWTER_POKECENTER_1F ===
REGION_PEWTER_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Pewter Pokecenter Stairs")

-- === REGION_PLAYERS_HOUSE_1F ===
REGION_PLAYERS_HOUSE_1F:connect_two_ways_entrance(REGION_PLAYERS_HOUSE_2F, "building_interior")

-- === REGION_POKECENTER_2F ===
REGION_POKECENTER_2F:connect_two_ways(REGION_TRADE_CENTER, "TODOBYSNOWFLAV")
REGION_POKECENTER_2F:connect_two_ways(REGION_TIME_CAPSULE, "TODOBYSNOWFLAV")

-- === REGION_POKEMON_FAN_CLUB ===
REGION_POKEMON_FAN_CLUB:connect_two_ways_entrance(REGION_VERMILION_CITY, "building")

-- === REGION_POWER_PLANT ===
REGION_POWER_PLANT:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_10_NORTH:SURF"], "building")

-- === REGION_RADIO_TOWER_1F ===
REGION_RADIO_TOWER_1F:connect_two_ways_entrance(REGION_RADIO_TOWER_2F, "dungeon_interior")
REGION_RADIO_TOWER_1F:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_1F:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_2F ===
REGION_RADIO_TOWER_2F:connect_two_ways_entrance(REGION_RADIO_TOWER_3F, "dungeon_interior")
REGION_RADIO_TOWER_2F:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_2F:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_3F ===
REGION_RADIO_TOWER_3F:connect_two_ways_entrance(NAMED_NODES["REGION_RADIO_TOWER_4F:WEST"], "dungeon_interior")
REGION_RADIO_TOWER_3F:connect_two_ways(NAMED_NODES["REGION_RADIO_TOWER_3F:EAST"], "TODOBYSNOWFLAV")
REGION_RADIO_TOWER_3F:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_3F:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_3F:EAST ===
NAMED_NODES["REGION_RADIO_TOWER_3F:EAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_RADIO_TOWER_4F:EAST"], "dungeon_interior")
NAMED_NODES["REGION_RADIO_TOWER_3F:EAST"]:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_3F:EAST:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_4F:WEST ===
NAMED_NODES["REGION_RADIO_TOWER_4F:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_RADIO_TOWER_5F:WEST"], "dungeon_interior")
NAMED_NODES["REGION_RADIO_TOWER_4F:WEST"]:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_4F:WEST:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_4F:EAST ===
NAMED_NODES["REGION_RADIO_TOWER_4F:EAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_RADIO_TOWER_5F:EAST"], "dungeon_interior")
NAMED_NODES["REGION_RADIO_TOWER_4F:EAST"]:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_4F:EAST:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_5F:WEST ===
NAMED_NODES["REGION_RADIO_TOWER_5F:WEST"]:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_5F:WEST:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_RADIO_TOWER_5F:EAST ===
NAMED_NODES["REGION_RADIO_TOWER_5F:EAST"]:connect_one_way(NAMED_NODES["REGION_RADIO_TOWER_5F:EAST:TAKEOVER"], "TODOBYSNOWFLAV")

-- === REGION_REDS_HOUSE_1F ===
REGION_REDS_HOUSE_1F:connect_two_ways_entrance(REGION_REDS_HOUSE_2F, "building_interior")

-- === REGION_ROCK_TUNNEL_1F:SOUTH ===
NAMED_NODES["REGION_ROCK_TUNNEL_1F:SOUTH"]:connect_two_ways_entrance(REGION_ROUTE_10_SOUTH, "dungeon")
NAMED_NODES["REGION_ROCK_TUNNEL_1F:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROCK_TUNNEL_B1F:WEST"], "dungeon_interior")

-- === REGION_ROCK_TUNNEL_1F:NORTHEAST ===
NAMED_NODES["REGION_ROCK_TUNNEL_1F:NORTHEAST"]:connect_two_ways_entrance(REGION_ROUTE_9, "dungeon")
NAMED_NODES["REGION_ROCK_TUNNEL_1F:NORTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROCK_TUNNEL_B1F:EAST"], "dungeon_interior")

-- === REGION_ROCK_TUNNEL_1F:NORTHWEST ===
NAMED_NODES["REGION_ROCK_TUNNEL_1F:NORTHWEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROCK_TUNNEL_B1F:EAST"], "dungeon_interior")
NAMED_NODES["REGION_ROCK_TUNNEL_1F:NORTHWEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROCK_TUNNEL_B1F:WEST"], "dungeon_interior")

-- === REGION_ROUTE_1 ===
REGION_ROUTE_1:connect_two_ways(REGION_VIRIDIAN_CITY, "Route 1 North Exit", "Viridian City South Exit")

-- === REGION_ROUTE_10_NORTH:POKECENTER ===
NAMED_NODES["REGION_ROUTE_10_NORTH:POKECENTER"]:connect_two_ways(REGION_ROUTE_9, "Route 10 North Exit", "Route 9 South Exit")
NAMED_NODES["REGION_ROUTE_10_NORTH:POKECENTER"]:connect_two_ways_entrance(REGION_ROUTE_10_POKECENTER_1F, "pokecenter")

-- === REGION_ROUTE_10_NORTH:SURF ===
NAMED_NODES["REGION_ROUTE_10_NORTH:SURF"]:connect_two_ways(REGION_ROUTE_9, "Route 10 North Exit (via Surf)", "Route 9 South Exit (via Surf)")

-- === REGION_ROUTE_10_POKECENTER_1F ===
REGION_ROUTE_10_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Route 10 Pokecenter Stairs")

-- === REGION_ROUTE_11 ===
REGION_ROUTE_11:connect_two_ways(REGION_VERMILION_CITY, "Route 11 West Exit", "Vermilion City East Exit")
REGION_ROUTE_11:connect_two_ways(NAMED_NODES["REGION_ROUTE_12:SOUTH"], "Route 11 East Exit", "Route 12 West Exit")

-- === REGION_ROUTE_12:NORTH ===
NAMED_NODES["REGION_ROUTE_12:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_12:SOUTH"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_ROUTE_12:NORTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_12:SIGN"], "Route 12 Sign Access (from North)")

-- === REGION_ROUTE_12:SOUTH ===
NAMED_NODES["REGION_ROUTE_12:SOUTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_12:SIGN"], "Route 12 Sign Access (from South)")
NAMED_NODES["REGION_ROUTE_12:SOUTH"]:connect_two_ways(REGION_ROUTE_13, "Route 12 South Exit", "Route 13 East Exit")
NAMED_NODES["REGION_ROUTE_12:SOUTH"]:connect_two_ways_entrance(REGION_ROUTE_12_SUPER_ROD_HOUSE, "building")

-- === REGION_ROUTE_13 ===
REGION_ROUTE_13:connect_two_ways(NAMED_NODES["REGION_ROUTE_13:CUT"], "TODOBYSNOWFLAV")
REGION_ROUTE_13:connect_two_ways(REGION_ROUTE_14, "Route 13 West Exit", "Route 14 North Exit")

-- === REGION_ROUTE_14 ===
REGION_ROUTE_14:connect_two_ways(NAMED_NODES["REGION_ROUTE_14:CUT"], "TODOBYSNOWFLAV")
REGION_ROUTE_14:connect_two_ways(REGION_ROUTE_15, "Route 14 South Exit", "Route 15 East Exit")

-- === REGION_ROUTE_15 ===
REGION_ROUTE_15:connect_two_ways_entrance(REGION_ROUTE_15_FUCHSIA_GATE, "gate")

-- === REGION_ROUTE_16 ===
REGION_ROUTE_16:connect_two_ways(NAMED_NODES["REGION_ROUTE_16:NORTH"], "TODOBYSNOWFLAV")
REGION_ROUTE_16:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_16_GATE:EAST"], "gate")

-- === REGION_ROUTE_16:CYCLING_ROAD ===
NAMED_NODES["REGION_ROUTE_16:CYCLING_ROAD"]:connect_two_ways(REGION_ROUTE_17, "Route 16 South Exit", "Route 17 North Exit")
NAMED_NODES["REGION_ROUTE_16:CYCLING_ROAD"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_16_GATE:WEST"], "gate")
NAMED_NODES["REGION_ROUTE_16:CYCLING_ROAD"]:connect_one_way(NAMED_NODES["REGION_ROUTE_16:SIGN"], "Route 16 Sign Access (from Cycling Road)")

-- === REGION_ROUTE_16:NORTH ===
NAMED_NODES["REGION_ROUTE_16:NORTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_16:SIGN"], "Route 16 Sign Access (from North)")
NAMED_NODES["REGION_ROUTE_16:NORTH"]:connect_two_ways_entrance(REGION_ROUTE_16_FUCHSIA_SPEECH_HOUSE, "building")

-- === REGION_ROUTE_16_GATE:WEST ===
NAMED_NODES["REGION_ROUTE_16_GATE:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_16_GATE:EAST"], "Route 16 Gate Traversal (Eastbound)", "Route 16 Gate Traversal (Westbound)")

-- === REGION_ROUTE_17 ===
REGION_ROUTE_17:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_17_ROUTE_18_GATE:WEST"], "gate")

-- === REGION_ROUTE_17_ROUTE_18_GATE:WEST ===
NAMED_NODES["REGION_ROUTE_17_ROUTE_18_GATE:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_17_ROUTE_18_GATE:EAST"], "Route 17-18 Gate Traversal (Eastbound)", "Route 17-18 Gate Traversal (Westbound)")

-- === REGION_ROUTE_17_ROUTE_18_GATE:EAST ===
NAMED_NODES["REGION_ROUTE_17_ROUTE_18_GATE:EAST"]:connect_two_ways_entrance(REGION_ROUTE_18, "gate")

-- === REGION_ROUTE_19 ===
REGION_ROUTE_19:connect_two_ways(REGION_ROUTE_20, "Route 19 South Exit", "Route 20 North Exit")
REGION_ROUTE_19:connect_two_ways(NAMED_NODES["REGION_ROUTE_19:SHORE"], "Route 19 Water Crossing (Northbound)", "Route 19 Water Crossing (Southbound)")

-- === REGION_ROUTE_19:SHORE ===
NAMED_NODES["REGION_ROUTE_19:SHORE"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_19:GATE_ENTRANCE"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_19:GATE_ENTRANCE ===
NAMED_NODES["REGION_ROUTE_19:GATE_ENTRANCE"]:connect_two_ways_entrance(REGION_ROUTE_19_FUCHSIA_GATE, "gate")

-- === REGION_ROUTE_2:WEST ===
NAMED_NODES["REGION_ROUTE_2:WEST"]:connect_two_ways(REGION_VIRIDIAN_CITY, "Route 2 South Exit", "Viridian City North Exit")
NAMED_NODES["REGION_ROUTE_2:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_2:NORTHEAST"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_ROUTE_2:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_2:SOUTHEAST"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_2:NORTHEAST ===
NAMED_NODES["REGION_ROUTE_2:NORTHEAST"]:connect_two_ways_entrance(REGION_ROUTE_2_NUGGET_HOUSE, "building")
NAMED_NODES["REGION_ROUTE_2:NORTHEAST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_2:CENTEREAST"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_2:CENTEREAST ===
NAMED_NODES["REGION_ROUTE_2:CENTEREAST"]:connect_two_ways_entrance(REGION_ROUTE_2_GATE, "gate")

-- === REGION_ROUTE_2:SOUTHEAST ===
NAMED_NODES["REGION_ROUTE_2:SOUTHEAST"]:connect_two_ways_entrance(REGION_ROUTE_2_GATE, "gate")

-- === REGION_ROUTE_20 ===
REGION_ROUTE_20:connect_two_ways(NAMED_NODES["REGION_ROUTE_20:SEAFOAM"], "Route 20 Water Crossing (to Seafoam)", "Route 20 Water Crossing (from Seafoam)")

-- === REGION_ROUTE_20:SEAFOAM ===
NAMED_NODES["REGION_ROUTE_20:SEAFOAM"]:connect_two_ways_entrance(REGION_SEAFOAM_GYM, "gym")

-- === REGION_ROUTE_21:NORTH ===
NAMED_NODES["REGION_ROUTE_21:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_21:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_22 ===
REGION_ROUTE_22:connect_two_ways(REGION_VIRIDIAN_CITY, "Route 22 East Exit", "Viridian City West Exit")
REGION_ROUTE_22:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD_GATE:EAST"], "gate")

-- === REGION_ROUTE_23 ===
REGION_ROUTE_23:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD:3F"], "dungeon")

-- === REGION_ROUTE_24 ===
REGION_ROUTE_24:connect_two_ways(REGION_ROUTE_25, "Route 24 North Exit", "Route 25 South Exit")
REGION_ROUTE_24:connect_one_way(NAMED_NODES["REGION_ROUTE_24:ROCKET"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_25 ===
REGION_ROUTE_25:connect_one_way(NAMED_NODES["REGION_ROUTE_25:MISTY_DATE"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_26 ===
REGION_ROUTE_26:connect_two_ways(NAMED_NODES["REGION_ROUTE_27:EAST"], "Route 26 West Exit", "Route 27 East Exit")
REGION_ROUTE_26:connect_two_ways_entrance(REGION_VICTORY_ROAD_GATE, "gate")
REGION_ROUTE_26:connect_two_ways_entrance(REGION_ROUTE_26_HEAL_HOUSE, "building")

-- === REGION_ROUTE_27:WEST ===
NAMED_NODES["REGION_ROUTE_27:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_TOHJO_FALLS:WEST"], "dungeon")
NAMED_NODES["REGION_ROUTE_27:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_27:WESTWATER"], "Route 27 South Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_27:CENTER ===
NAMED_NODES["REGION_ROUTE_27:CENTER"]:connect_two_ways_entrance(REGION_ROUTE_27_SANDSTORM_HOUSE, "building")
NAMED_NODES["REGION_ROUTE_27:CENTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_TOHJO_FALLS:EAST"], "dungeon")
NAMED_NODES["REGION_ROUTE_27:CENTER"]:connect_one_way(NAMED_NODES["REGION_ROUTE_27:WEST"], "Route 27 Ledge Jump")
NAMED_NODES["REGION_ROUTE_27:CENTER"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_27:EAST"], "Route 27 East Water Crossing (Center -> East)", "Route 27 East Water Crossing (East -> Center)")

-- === REGION_ROUTE_27:EAST ===
NAMED_NODES["REGION_ROUTE_27:EAST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_27:EASTWHIRLPOOL"], "Route 27 Whirlpool Crossing", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_28 ===
REGION_ROUTE_28:connect_two_ways(REGION_SILVER_CAVE_OUTSIDE, "Route 28 West Exit", "Silver Cave Outside East Exit")
REGION_ROUTE_28:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD_GATE:WEST"], "gate")

-- === REGION_ROUTE_28:CUT ===
NAMED_NODES["REGION_ROUTE_28:CUT"]:connect_one_way(REGION_ROUTE_28, "Route 28 North Ledge Jump")
NAMED_NODES["REGION_ROUTE_28:CUT"]:connect_two_ways(REGION_SILVER_CAVE_OUTSIDE, "Route 28 West Exit (via Cut)", "Silver Cave Outside East Exit (via Cut)")
NAMED_NODES["REGION_ROUTE_28:CUT"]:connect_two_ways_entrance(REGION_ROUTE_28_STEEL_WING_HOUSE, "building")

-- === REGION_ROUTE_29 ===
REGION_ROUTE_29:connect_two_ways_entrance(REGION_ROUTE_29_ROUTE_46_GATE, "gate")

-- === REGION_ROUTE_29_ROUTE_46_GATE ===
REGION_ROUTE_29_ROUTE_46_GATE:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_46:SOUTH"], "gate")

-- === REGION_ROUTE_30 ===
REGION_ROUTE_30:connect_two_ways_entrance(REGION_ROUTE_30_BERRY_HOUSE, "building")
REGION_ROUTE_30:connect_two_ways(NAMED_NODES["REGION_ROUTE_30:NORTHWEST"], "TODOBYSNOWFLAV")
REGION_ROUTE_30:connect_one_way(NAMED_NODES["REGION_ROUTE_30:POST_MYSTERY_EGG"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_30:NORTHWEST ===
NAMED_NODES["REGION_ROUTE_30:NORTHWEST"]:connect_two_ways(REGION_ROUTE_31, "Route 30 North Exit", "Route 31 South Exit")

-- === REGION_ROUTE_31 ===
REGION_ROUTE_31:connect_two_ways_entrance(REGION_ROUTE_31_VIOLET_GATE, "gate")

-- === REGION_ROUTE_31_VIOLET_GATE ===
REGION_ROUTE_31_VIOLET_GATE:connect_two_ways_entrance(REGION_VIOLET_CITY, "gate")

-- === REGION_ROUTE_32:NORTH ===
NAMED_NODES["REGION_ROUTE_32:NORTH"]:connect_two_ways(REGION_VIOLET_CITY, "Route 32 North Exit", "Violet City South Exit")
NAMED_NODES["REGION_ROUTE_32:NORTH"]:connect_two_ways_entrance(REGION_ROUTE_32_RUINS_OF_ALPH_GATE, "gate")
NAMED_NODES["REGION_ROUTE_32:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_32:SOUTH"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_ROUTE_32:NORTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_32:MIRACLE_SEED"], "Route 32 Miracle Seed Guy Access (from North)")

-- === REGION_ROUTE_32:SOUTH ===
NAMED_NODES["REGION_ROUTE_32:SOUTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_32:MIRACLE_SEED"], "Route 32 Miracle Seed Guy Access (from South)")
NAMED_NODES["REGION_ROUTE_32:SOUTH"]:connect_two_ways_entrance(REGION_ROUTE_32_POKECENTER_1F, "pokecenter")
NAMED_NODES["REGION_ROUTE_32:SOUTH"]:connect_two_ways_entrance(REGION_UNION_CAVE_1F, "dungeon")
NAMED_NODES["REGION_ROUTE_32:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_FLOODED_MINE:NORTH_ENTRANCE"], "dungeon")

-- === REGION_ROUTE_32_POKECENTER_1F ===
REGION_ROUTE_32_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Route 32 Pokecenter Stairs")

-- === REGION_ROUTE_32_RUINS_OF_ALPH_GATE ===
REGION_ROUTE_32_RUINS_OF_ALPH_GATE:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_OUTSIDE, "gate")

-- === REGION_ROUTE_33 ===
REGION_ROUTE_33:connect_two_ways_entrance(REGION_UNION_CAVE_1F, "dungeon")

-- === REGION_ROUTE_34 ===
REGION_ROUTE_34:connect_two_ways_entrance(REGION_ROUTE_34_ILEX_FOREST_GATE, "gate")
REGION_ROUTE_34:connect_two_ways(NAMED_NODES["REGION_ROUTE_34:WATER"], "Route 34 Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_35 ===
REGION_ROUTE_35:connect_two_ways_entrance(REGION_ROUTE_35_GOLDENROD_GATE, "gate")
REGION_ROUTE_35:connect_two_ways_entrance(REGION_ROUTE_35_NATIONAL_PARK_GATE, "gate")
REGION_ROUTE_35:connect_two_ways(NAMED_NODES["REGION_ROUTE_36:WEST"], "Route 35 North Exit", "Route 36 South Exit")
REGION_ROUTE_35:connect_two_ways(NAMED_NODES["REGION_ROUTE_35:FRUITTREE"], "Route 35 Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_35_NATIONAL_PARK_GATE ===
REGION_ROUTE_35_NATIONAL_PARK_GATE:connect_one_way(NAMED_NODES["REGION_ROUTE_35_NATIONAL_PARK_GATE:BIKE"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_35_NATIONAL_PARK_GATE:BIKE ===
NAMED_NODES["REGION_ROUTE_35_NATIONAL_PARK_GATE:BIKE"]:connect_one_way(NAMED_NODES["REGION_NATIONAL_PARK:CONTEST"], "Bug Catching Contest South Entrance")

-- === REGION_ROUTE_36:EAST ===
NAMED_NODES["REGION_ROUTE_36:EAST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_36:WEST"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_ROUTE_36:EAST"]:connect_two_ways(REGION_ROUTE_37, "Route 36 North Exit (from East)", "Route 37 Southeast Exit")
NAMED_NODES["REGION_ROUTE_36:EAST"]:connect_two_ways(REGION_VIOLET_CITY, "Route 36 East Exit", "Violet City West Exit")
NAMED_NODES["REGION_ROUTE_36:EAST"]:connect_two_ways_entrance(REGION_ROUTE_36_RUINS_OF_ALPH_GATE, "gate")

-- === REGION_ROUTE_36:WEST ===
NAMED_NODES["REGION_ROUTE_36:WEST"]:connect_two_ways_entrance(REGION_ROUTE_36_NATIONAL_PARK_GATE, "gate")
NAMED_NODES["REGION_ROUTE_36:WEST"]:connect_two_ways(REGION_ROUTE_37, "Route 36 North Exit (from West)", "Route 37 Southwest Exit")

-- === REGION_ROUTE_36_RUINS_OF_ALPH_GATE ===
REGION_ROUTE_36_RUINS_OF_ALPH_GATE:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_OUTSIDE, "gate")

-- === REGION_ROUTE_38 ===
REGION_ROUTE_38:connect_two_ways(REGION_ROUTE_39, "Route 38 West Exit", "Route 39 North Exit")
REGION_ROUTE_38:connect_two_ways_entrance(REGION_ROUTE_38_ECRUTEAK_GATE, "gate")

-- === REGION_ROUTE_39 ===
REGION_ROUTE_39:connect_two_ways_entrance(REGION_ROUTE_39_BARN, "building")
REGION_ROUTE_39:connect_two_ways_entrance(REGION_ROUTE_39_FARMHOUSE, "building")

-- === REGION_ROUTE_4:WEST ===
NAMED_NODES["REGION_ROUTE_4:WEST"]:connect_one_way(NAMED_NODES["REGION_ROUTE_4:EAST"], "Route 4 Ledge Jump")

-- === REGION_ROUTE_40 ===
REGION_ROUTE_40:connect_two_ways(NAMED_NODES["REGION_ROUTE_40:WATER"], "Route 40 Water Crossing (Southbound)", "Route 40 Water Crossing (Northbound)")
REGION_ROUTE_40:connect_two_ways_entrance(REGION_ROUTE_40_BATTLE_TOWER_GATE, "gate")

-- === REGION_ROUTE_40:WATER ===
NAMED_NODES["REGION_ROUTE_40:WATER"]:connect_two_ways(REGION_ROUTE_41, "Route 40 South Exit", "Route 41 North Exit")

-- === REGION_ROUTE_41 ===
REGION_ROUTE_41:connect_two_ways(NAMED_NODES["REGION_ROUTE_41:NW_ISLAND"], "Route 41 Northwest Island Whirlpool Crossing (Inbound)", "Route 41 Northwest Island Whirlpool Crossing (Outbound)")
REGION_ROUTE_41:connect_two_ways(NAMED_NODES["REGION_ROUTE_41:NE_ISLAND"], "Route 41 Northeast Island Whirlpool Crossing (Inbound)", "Route 41 Northeast Island Whirlpool Crossing (Outbound)")
REGION_ROUTE_41:connect_two_ways(NAMED_NODES["REGION_ROUTE_41:SW_ISLAND"], "Route 41 Southwest Island Whirlpool Crossing (Inbound)", "Route 41 Southwest Island Whirlpool Crossing (Outbound)")
REGION_ROUTE_41:connect_two_ways(NAMED_NODES["REGION_ROUTE_41:SE_ISLAND"], "Route 41 Southeast Island Whirlpool Crossing (Inbound)", "Route 41 Southeast Island Whirlpool Crossing (Outbound)")

-- === REGION_ROUTE_41:NW_ISLAND ===
NAMED_NODES["REGION_ROUTE_41:NW_ISLAND"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NW:NORTH"], "dungeon")

-- === REGION_ROUTE_41:NE_ISLAND ===
NAMED_NODES["REGION_ROUTE_41:NE_ISLAND"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NE:WEST"], "dungeon")

-- === REGION_ROUTE_41:SW_ISLAND ===
NAMED_NODES["REGION_ROUTE_41:SW_ISLAND"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_SW:NORTHWEST"], "dungeon")

-- === REGION_ROUTE_41:SE_ISLAND ===
NAMED_NODES["REGION_ROUTE_41:SE_ISLAND"]:connect_two_ways_entrance(REGION_WHIRL_ISLAND_SE, "dungeon")
NAMED_NODES["REGION_ROUTE_41:SE_ISLAND"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_41:SE_ISLAND:ITEM"], "Route 41 Southeast Island Water Crossing (to Hidden Item)", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_42:WEST ===
NAMED_NODES["REGION_ROUTE_42:WEST"]:connect_two_ways_entrance(REGION_ROUTE_42_ECRUTEAK_GATE, "gate")
NAMED_NODES["REGION_ROUTE_42:WEST"]:connect_one_way(NAMED_NODES["REGION_ROUTE_42:HEADBUTT"], "Route 42 Headbutt Trees Access (from West)")

-- === REGION_ROUTE_42:CENTER ===
NAMED_NODES["REGION_ROUTE_42:CENTER"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_42:CENTERFRUIT"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_42:CENTERFRUIT ===
NAMED_NODES["REGION_ROUTE_42:CENTERFRUIT"]:connect_one_way(NAMED_NODES["REGION_ROUTE_42:HEADBUTT"], "Route 42 Headbutt Trees Access (from Center)")

-- === REGION_ROUTE_43 ===
REGION_ROUTE_43:connect_two_ways_entrance(REGION_ROUTE_43_MAHOGANY_GATE, "gate")
REGION_ROUTE_43:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_43_GATE:NORTH"], "gate")
REGION_ROUTE_43:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_43_GATE:SOUTH"], "gate")
REGION_ROUTE_43:connect_two_ways(NAMED_NODES["REGION_ROUTE_43:FRUITTREE"], "Route 43 Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_ROUTE_43_GATE:NORTH ===
NAMED_NODES["REGION_ROUTE_43_GATE:NORTH"]:connect_two_ways(REGION_ROUTE_43_GATE, "Route 43 Gate Traversal (from North)", "Route 43 Gate Traversal (to North)")

-- === REGION_ROUTE_43_GATE:SOUTH ===
NAMED_NODES["REGION_ROUTE_43_GATE:SOUTH"]:connect_two_ways(REGION_ROUTE_43_GATE, "Route 43 Gate Traversal (from South)", "Route 43 Gate Traversal (to South)")

-- === REGION_ROUTE_44 ===
REGION_ROUTE_44:connect_two_ways(NAMED_NODES["REGION_ROUTE_44:WATER"], "Route 44 Water Crossing", "TODOBYSNOWFLAV")
REGION_ROUTE_44:connect_one_way(NAMED_NODES["REGION_ROUTE_44:POWER"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_45 ===
REGION_ROUTE_45:connect_one_way(NAMED_NODES["REGION_ROUTE_46:NORTH"], "Route 45 South Exit")
REGION_ROUTE_45:connect_one_way(NAMED_NODES["REGION_ROUTE_45:POWER"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_46:NORTH ===
NAMED_NODES["REGION_ROUTE_46:NORTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_46:SOUTH"], "Route 46 Ledge Jumps")
NAMED_NODES["REGION_ROUTE_46:NORTH"]:connect_one_way(NAMED_NODES["REGION_ROUTE_46:POWER"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_5 ===
REGION_ROUTE_5:connect_two_ways_entrance(REGION_ROUTE_5_UNDERGROUND_PATH_ENTRANCE, "dungeon")
REGION_ROUTE_5:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_5_SAFFRON_GATE:NORTH"], "gate")
REGION_ROUTE_5:connect_two_ways_entrance(REGION_ROUTE_5_CLEANSE_TAG_HOUSE, "building")

-- === REGION_ROUTE_5_SAFFRON_GATE:NORTH ===
NAMED_NODES["REGION_ROUTE_5_SAFFRON_GATE:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_5_SAFFRON_GATE:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_5_SAFFRON_GATE:SOUTH ===
NAMED_NODES["REGION_ROUTE_5_SAFFRON_GATE:SOUTH"]:connect_two_ways_entrance(REGION_SAFFRON_CITY, "gate")

-- === REGION_ROUTE_5_UNDERGROUND_PATH_ENTRANCE ===
REGION_ROUTE_5_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_UNDERGROUND_PATH, "dungeon_interior")

-- === REGION_ROUTE_6 ===
REGION_ROUTE_6:connect_two_ways(REGION_VERMILION_CITY, "Route 6 South Exit", "Vermilion City North Exit")
REGION_ROUTE_6:connect_two_ways_entrance(REGION_ROUTE_6_UNDERGROUND_PATH_ENTRANCE, "dungeon")
REGION_ROUTE_6:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_6_SAFFRON_GATE:SOUTH"], "gate")

-- === REGION_ROUTE_6_SAFFRON_GATE:NORTH ===
NAMED_NODES["REGION_ROUTE_6_SAFFRON_GATE:NORTH"]:connect_two_ways_entrance(REGION_SAFFRON_CITY, "gate")
NAMED_NODES["REGION_ROUTE_6_SAFFRON_GATE:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_6_SAFFRON_GATE:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_6_UNDERGROUND_PATH_ENTRANCE ===
REGION_ROUTE_6_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_UNDERGROUND_PATH, "dungeon_interior")

-- === REGION_ROUTE_7_UNDERGROUND_PATH_ENTRANCE ===
REGION_ROUTE_7_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_ROUTE_7, "dungeon")
REGION_ROUTE_7_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_EAST_WEST_UNDERGROUND, "dungeon_interior")

-- === REGION_ROUTE_8_UNDERGROUND_PATH_ENTRANCE ===
REGION_ROUTE_8_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_ROUTE_8, "dungeon_interior")
REGION_ROUTE_8_UNDERGROUND_PATH_ENTRANCE:connect_two_ways_entrance(REGION_EAST_WEST_UNDERGROUND, "dungeon_interior")

-- === REGION_ROUTE_7 ===
REGION_ROUTE_7:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_7_SAFFRON_GATE:WEST"], "gate")

-- === REGION_ROUTE_7_SAFFRON_GATE:WEST ===
NAMED_NODES["REGION_ROUTE_7_SAFFRON_GATE:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_7_SAFFRON_GATE:EAST"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_7_SAFFRON_GATE:EAST ===
NAMED_NODES["REGION_ROUTE_7_SAFFRON_GATE:EAST"]:connect_two_ways_entrance(REGION_SAFFRON_CITY, "gate")

-- === REGION_ROUTE_8 ===
REGION_ROUTE_8:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_8_SAFFRON_GATE:EAST"], "gate")
REGION_ROUTE_8:connect_two_ways(NAMED_NODES["REGION_ROUTE_8:CUT"], "TODOBYSNOWFLAV")

-- === REGION_ROUTE_8_SAFFRON_GATE:WEST ===
NAMED_NODES["REGION_ROUTE_8_SAFFRON_GATE:WEST"]:connect_two_ways_entrance(REGION_SAFFRON_CITY, "gate")
NAMED_NODES["REGION_ROUTE_8_SAFFRON_GATE:WEST"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_8_SAFFRON_GATE:EAST"], "TODOBYSNOWFLAV")

-- === REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER ===
REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER:connect_two_ways_entrance(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH"], "dungeon_interior")
REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")
REGION_RUINS_OF_ALPH_AERODACTYL_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM, "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM ===
REGION_RUINS_OF_ALPH_AERODACTYL_ITEM_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_AERODACTYL_WORD_ROOM, "one_way")

-- === REGION_RUINS_OF_ALPH_AERODACTYL_WORD_ROOM ===
REGION_RUINS_OF_ALPH_AERODACTYL_WORD_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")

-- === REGION_RUINS_OF_ALPH_HO_OH_CHAMBER ===
REGION_RUINS_OF_ALPH_HO_OH_CHAMBER:connect_two_ways_entrance(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:WEST"], "dungeon_interior")
REGION_RUINS_OF_ALPH_HO_OH_CHAMBER:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")
REGION_RUINS_OF_ALPH_HO_OH_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_HO_OH_ITEM_ROOM, "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_HO_OH_ITEM_ROOM ===
REGION_RUINS_OF_ALPH_HO_OH_ITEM_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_HO_OH_WORD_ROOM, "one_way")

-- === REGION_RUINS_OF_ALPH_HO_OH_WORD_ROOM ===
REGION_RUINS_OF_ALPH_HO_OH_WORD_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")

-- === REGION_RUINS_OF_ALPH_INNER_CHAMBER ===
REGION_RUINS_OF_ALPH_INNER_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_OUTSIDE, "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_KABUTO_CHAMBER ===
REGION_RUINS_OF_ALPH_KABUTO_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_OUTSIDE, "dungeon_interior")
REGION_RUINS_OF_ALPH_KABUTO_CHAMBER:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")
REGION_RUINS_OF_ALPH_KABUTO_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_KABUTO_ITEM_ROOM, "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_KABUTO_ITEM_ROOM ===
REGION_RUINS_OF_ALPH_KABUTO_ITEM_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_KABUTO_WORD_ROOM, "one_way")

-- === REGION_RUINS_OF_ALPH_KABUTO_WORD_ROOM ===
REGION_RUINS_OF_ALPH_KABUTO_WORD_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")

-- === REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER ===
REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER:connect_two_ways_entrance(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:OMANYTE_LEDGE"], "dungeon_interior")
REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")
REGION_RUINS_OF_ALPH_OMANYTE_CHAMBER:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_OMANYTE_ITEM_ROOM, "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_OMANYTE_ITEM_ROOM ===
REGION_RUINS_OF_ALPH_OMANYTE_ITEM_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_OMANYTE_WORD_ROOM, "one_way")

-- === REGION_RUINS_OF_ALPH_OMANYTE_WORD_ROOM ===
REGION_RUINS_OF_ALPH_OMANYTE_WORD_ROOM:connect_one_way_entrance(REGION_RUINS_OF_ALPH_INNER_CHAMBER, "one_way")

-- === REGION_RUINS_OF_ALPH_OUTSIDE ===
REGION_RUINS_OF_ALPH_OUTSIDE:connect_two_ways_entrance(REGION_RUINS_OF_ALPH_RESEARCH_CENTER, "building")
REGION_RUINS_OF_ALPH_OUTSIDE:connect_two_ways(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH"], "Ruins of Alph Water Crossing (Southbound)", "Ruins of Alph Water Crossing (Northbound)")

-- === REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:UNION_LEDGE ===
NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:UNION_LEDGE"]:connect_one_way(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:UNION_LEDGE"]:connect_one_way(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:OMANYTE_LEDGE"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:UNION_LEDGE"]:connect_two_ways_entrance(NAMED_NODES["REGION_UNION_CAVE_B1F:STRENGTH"], "dungeon_interior")

-- === REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:OMANYTE_LEDGE ===
NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH:OMANYTE_LEDGE"]:connect_one_way(NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_RUINS_OF_ALPH_OUTSIDE:WEST ===
NAMED_NODES["REGION_RUINS_OF_ALPH_OUTSIDE:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_UNION_CAVE_B1F:NORTH"], "dungeon_interior")

-- === REGION_SAFFRON_CITY ===
REGION_SAFFRON_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:ENTRANCE"], "gym")
REGION_SAFFRON_CITY:connect_two_ways_entrance(REGION_SAFFRON_MART, "mart")
REGION_SAFFRON_CITY:connect_two_ways_entrance(REGION_SAFFRON_POKECENTER_1F, "pokecenter")
REGION_SAFFRON_CITY:connect_two_ways_entrance(REGION_SAFFRON_MAGNET_TRAIN_STATION, "building")
REGION_SAFFRON_CITY:connect_two_ways_entrance(REGION_SILPH_CO_1F, "building")

-- === REGION_SAFFRON_GYM:ENTRANCE ===
NAMED_NODES["REGION_SAFFRON_GYM:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SE"], "gym_interior")

-- === REGION_SAFFRON_GYM:NW ===
NAMED_NODES["REGION_SAFFRON_GYM:NW"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:N"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:NW"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:W"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:NW"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:NE"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:NW"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:CENTER"], "gym_interior")

-- === REGION_SAFFRON_GYM:N ===
NAMED_NODES["REGION_SAFFRON_GYM:N"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SW"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:N"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:W"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:N"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:E"], "gym_interior")

-- === REGION_SAFFRON_GYM:NE ===
NAMED_NODES["REGION_SAFFRON_GYM:NE"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SE"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:NE"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SW"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:NE"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:E"], "gym_interior")

-- === REGION_SAFFRON_GYM:W ===
NAMED_NODES["REGION_SAFFRON_GYM:W"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:E"], "gym_interior")
NAMED_NODES["REGION_SAFFRON_GYM:W"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SW"], "gym_interior")

-- === REGION_SAFFRON_GYM:E ===
NAMED_NODES["REGION_SAFFRON_GYM:E"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SE"], "gym_interior")

-- === REGION_SAFFRON_GYM:SW ===
NAMED_NODES["REGION_SAFFRON_GYM:SW"]:connect_two_ways_entrance(NAMED_NODES["REGION_SAFFRON_GYM:SE"], "gym_interior")

-- === REGION_SAFFRON_POKECENTER_1F ===
REGION_SAFFRON_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Saffron Pokecenter Stairs")

-- === REGION_SILVER_CAVE_ITEM_ROOMS:WEST ===
NAMED_NODES["REGION_SILVER_CAVE_ITEM_ROOMS:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:WEST"], "dungeon_interior")

-- === REGION_SILVER_CAVE_ITEM_ROOMS:EAST ===
NAMED_NODES["REGION_SILVER_CAVE_ITEM_ROOMS:EAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:EAST"], "dungeon_interior")

-- === REGION_SILVER_CAVE_OUTSIDE ===
REGION_SILVER_CAVE_OUTSIDE:connect_two_ways_entrance(REGION_SILVER_CAVE_POKECENTER_1F, "pokecenter")
REGION_SILVER_CAVE_OUTSIDE:connect_two_ways_entrance(REGION_SILVER_CAVE_ROOM_1, "dungeon")
REGION_SILVER_CAVE_OUTSIDE:connect_two_ways(NAMED_NODES["REGION_SILVER_CAVE_OUTSIDE:SURF"], "Silver Cave Outside Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_SILVER_CAVE_POKECENTER_1F ===
REGION_SILVER_CAVE_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Silver Cave Pokecenter Stairs")

-- === REGION_SILVER_CAVE_ROOM_1 ===
REGION_SILVER_CAVE_ROOM_1:connect_two_ways_entrance(REGION_SILVER_CAVE_ROOM_2, "dungeon_interior")

-- === REGION_SILVER_CAVE_ROOM_2:WEST ===
NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:WEST"]:connect_two_ways(REGION_SILVER_CAVE_ROOM_2, "Silver Cave Middle West Waterfall Descent", "Silver Cave Middle West Waterfall Ascent")
NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:WEST"]:connect_two_ways(NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:WEST_ITEM"], "Silver Cave Middle West Water Crossing (to Item)", "TODOBYSNOWFLAV")

-- === REGION_SILVER_CAVE_ROOM_2:EAST ===
NAMED_NODES["REGION_SILVER_CAVE_ROOM_2:EAST"]:connect_two_ways(REGION_SILVER_CAVE_ROOM_2, "Silver Cave Middle East Waterfall Descent", "Silver Cave Middle East Waterfall Ascent")

-- === REGION_SILVER_CAVE_ROOM_2 ===
REGION_SILVER_CAVE_ROOM_2:connect_two_ways_entrance(REGION_SILVER_CAVE_ROOM_3, "dungeon_interior")

-- === REGION_SILVER_CAVE_ROOM_3 ===
REGION_SILVER_CAVE_ROOM_3:connect_one_way(REGION_SILVER_CAVE_OUTSIDE, "Beat Red")

-- === REGION_SLOWPOKE_WELL_B1F:ENTRANCE ===
NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:ENTRANCE"]:connect_two_ways(REGION_SLOWPOKE_WELL_B1F, "TODOBYSNOWFLAV")

-- === REGION_SLOWPOKE_WELL_B1F ===
REGION_SLOWPOKE_WELL_B1F:connect_two_ways(NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:WEST"], "TODOBYSNOWFLAV")

-- === REGION_SLOWPOKE_WELL_B1F:WEST ===
NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:WEST"]:connect_two_ways(NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:CENTER"], "Slowpoke Well B1F Water Crossing (West -> Center)", "Slowpoke Well B1F Water Crossing (Center -> West)")

-- === REGION_SLOWPOKE_WELL_B1F:CENTER ===
NAMED_NODES["REGION_SLOWPOKE_WELL_B1F:CENTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_SLOWPOKE_WELL_B2F:CENTER"], "dungeon_interior")

-- === REGION_SLOWPOKE_WELL_B2F:CENTER ===
NAMED_NODES["REGION_SLOWPOKE_WELL_B2F:CENTER"]:connect_two_ways(NAMED_NODES["REGION_SLOWPOKE_WELL_B2F:ISLANDS"], "Slowpoke Well B2F Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_SPROUT_TOWER_1F:OUTER ===
NAMED_NODES["REGION_SPROUT_TOWER_1F:OUTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_SPROUT_TOWER_2F:OUTER"], "dungeon_interior")
NAMED_NODES["REGION_SPROUT_TOWER_1F:OUTER"]:connect_two_ways_entrance(REGION_SPROUT_TOWER_2F, "dungeon_interior")

-- === REGION_SPROUT_TOWER_1F ===
REGION_SPROUT_TOWER_1F:connect_two_ways_entrance(REGION_VIOLET_CITY, "dungeon")
REGION_SPROUT_TOWER_1F:connect_two_ways_entrance(REGION_SPROUT_TOWER_2F, "dungeon_interior")

-- === REGION_SPROUT_TOWER_2F:OUTER ===
NAMED_NODES["REGION_SPROUT_TOWER_2F:OUTER"]:connect_two_ways_entrance(REGION_SPROUT_TOWER_3F, "dungeon_interior")

-- === REGION_TEAM_ROCKET_BASE_B1F ===
REGION_TEAM_ROCKET_BASE_B1F:connect_two_ways_entrance(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:SOUTH"], "dungeon_interior")

-- === REGION_TEAM_ROCKET_BASE_B2F:SOUTH ===
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:CENTER"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:SOUTH"], "dungeon_interior")

-- === REGION_TEAM_ROCKET_BASE_B2F:NORTH ===
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:WEST"], "dungeon_interior")
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:SOUTH"], "dungeon_interior")

-- === REGION_TEAM_ROCKET_BASE_B2F:WEST ===
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B2F:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:WEST"], "dungeon_interior")

-- === REGION_TEAM_ROCKET_BASE_B3F:WEST ===
NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:WEST"]:connect_two_ways(NAMED_NODES["REGION_TEAM_ROCKET_BASE_B3F:CENTER"], "TODOBYSNOWFLAV")

-- === REGION_ECRUTEAK_CITY:TIN_TOWER_TRAIL ===
NAMED_NODES["REGION_ECRUTEAK_CITY:TIN_TOWER_TRAIL"]:connect_two_ways_entrance(REGION_WISE_TRIOS_ROOM, "gate")
NAMED_NODES["REGION_ECRUTEAK_CITY:TIN_TOWER_TRAIL"]:connect_two_ways_entrance(REGION_TIN_TOWER_1F, "dungeon_interior")

-- === REGION_TIN_TOWER_1F ===
REGION_TIN_TOWER_1F:connect_two_ways_entrance(REGION_TIN_TOWER_2F, "dungeon_interior")

-- === REGION_TIN_TOWER_2F ===
REGION_TIN_TOWER_2F:connect_two_ways_entrance(REGION_TIN_TOWER_3F, "dungeon_interior")

-- === REGION_TIN_TOWER_3F ===
REGION_TIN_TOWER_3F:connect_two_ways_entrance(REGION_TIN_TOWER_4F, "dungeon_interior")

-- === REGION_TIN_TOWER_4F ===
REGION_TIN_TOWER_4F:connect_two_ways_entrance(REGION_TIN_TOWER_5F, "dungeon_interior")
REGION_TIN_TOWER_4F:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTHWEST"], "dungeon_interior")
REGION_TIN_TOWER_4F:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTHEAST"], "dungeon_interior")

-- === REGION_TIN_TOWER_5F:SOUTH ===
NAMED_NODES["REGION_TIN_TOWER_5F:SOUTH"]:connect_two_ways_entrance(REGION_TIN_TOWER_6F, "dungeon_interior")
NAMED_NODES["REGION_TIN_TOWER_5F:SOUTH"]:connect_one_way(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTHWEST"], "TODOBYSNOWFLAV")

-- === REGION_TIN_TOWER_5F ===
REGION_TIN_TOWER_5F:connect_one_way(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTHWEST"], "TODOBYSNOWFLAV")
REGION_TIN_TOWER_5F:connect_one_way(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTHEAST"], "TODOBYSNOWFLAV")
REGION_TIN_TOWER_5F:connect_one_way(NAMED_NODES["REGION_TIN_TOWER_5F:SOUTH"], "TODOBYSNOWFLAV")

-- === REGION_TIN_TOWER_6F ===
REGION_TIN_TOWER_6F:connect_two_ways_entrance(REGION_TIN_TOWER_7F, "dungeon_interior")

-- === REGION_TIN_TOWER_7F ===
REGION_TIN_TOWER_7F:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_8F:WEST"], "dungeon_interior")
REGION_TIN_TOWER_7F:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_7F:CENTER"], "dungeon_interior")

-- === REGION_TIN_TOWER_7F:CENTER ===
NAMED_NODES["REGION_TIN_TOWER_7F:CENTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:SOUTH"], "dungeon_interior")

-- === REGION_TIN_TOWER_8F:WEST ===
NAMED_NODES["REGION_TIN_TOWER_8F:WEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:NORTH"], "dungeon_interior")

-- === REGION_TIN_TOWER_8F:NORTH ===
NAMED_NODES["REGION_TIN_TOWER_8F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:NORTH"], "dungeon_interior")
NAMED_NODES["REGION_TIN_TOWER_8F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:CENTER"], "dungeon_interior")

-- === REGION_TIN_TOWER_8F:SOUTH ===
NAMED_NODES["REGION_TIN_TOWER_8F:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:SOUTH"], "dungeon_interior")

-- === REGION_TIN_TOWER_8F:CENTER ===
NAMED_NODES["REGION_TIN_TOWER_8F:CENTER"]:connect_two_ways_entrance(NAMED_NODES["REGION_TIN_TOWER_9F:SOUTH"], "dungeon_interior")

-- === REGION_TIN_TOWER_9F:CENTER ===
NAMED_NODES["REGION_TIN_TOWER_9F:CENTER"]:connect_two_ways_entrance(REGION_TIN_TOWER_ROOF, "dungeon_interior")

-- === REGION_TOHJO_FALLS:WEST ===
NAMED_NODES["REGION_TOHJO_FALLS:WEST"]:connect_two_ways(NAMED_NODES["REGION_TOHJO_FALLS:EAST"], "Tohjo Falls Water Crossing (Eastbound)", "Tohjo Falls Water Crossing (Westbound)")

-- === REGION_TRAINER_HOUSE_1F ===
REGION_TRAINER_HOUSE_1F:connect_two_ways_entrance(REGION_VIRIDIAN_CITY, "building")
REGION_TRAINER_HOUSE_1F:connect_two_ways_entrance(REGION_TRAINER_HOUSE_B1F, "building_interior")

-- === REGION_TRAINER_HOUSE_B1F ===
REGION_TRAINER_HOUSE_B1F:connect_one_way(NAMED_NODES["REGION_TRAINER_HOUSE_B1F:CAL"], "TODOBYSNOWFLAV")

-- === REGION_UNION_CAVE_1F ===
REGION_UNION_CAVE_1F:connect_two_ways(NAMED_NODES["REGION_UNION_CAVE_1F:SOUTH"], "Union Cave 1F Water Crossing (Center -> Southwest)", "Union Cave 1F Water Crossing (Southwest -> Center)")
REGION_UNION_CAVE_1F:connect_two_ways_entrance(NAMED_NODES["REGION_UNION_CAVE_B1F:CENTER"], "dungeon_interior")

-- === REGION_UNION_CAVE_1F:SOUTH ===
NAMED_NODES["REGION_UNION_CAVE_1F:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_UNION_CAVE_B1F:SOUTHWEST"], "dungeon_interior")

-- === REGION_UNION_CAVE_B1F:NORTH ===
NAMED_NODES["REGION_UNION_CAVE_B1F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_UNION_CAVE_B1F:STRENGTH"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_UNION_CAVE_B1F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_UNION_CAVE_B1F:CENTER"], "Union Cave B1F North Water Crossing (Southbound)", "Union Cave B1F North Water Crossing (Northbound)")

-- === REGION_UNION_CAVE_B1F:SOUTHWEST ===
NAMED_NODES["REGION_UNION_CAVE_B1F:SOUTHWEST"]:connect_two_ways(NAMED_NODES["REGION_UNION_CAVE_B1F:SOUTHEAST"], "Union Cave B1F South Water Crossing (Eastbound)", "Union Cave B1F South Water Crossing (Westbound)")

-- === REGION_UNION_CAVE_B1F:SOUTHEAST ===
NAMED_NODES["REGION_UNION_CAVE_B1F:SOUTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_UNION_CAVE_B2F:NORTH"], "dungeon_interior")

-- === REGION_UNION_CAVE_B2F:NORTH ===
NAMED_NODES["REGION_UNION_CAVE_B2F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_UNION_CAVE_B2F:SURF"], "Union Cave B2F Water Crossing", "TODOBYSNOWFLAV")

-- === REGION_VERMILION_CITY ===
REGION_VERMILION_CITY:connect_two_ways_entrance(REGION_VERMILION_FISHING_SPEECH_HOUSE, "building")
REGION_VERMILION_CITY:connect_two_ways_entrance(REGION_VERMILION_POKECENTER_1F, "pokecenter")
REGION_VERMILION_CITY:connect_two_ways_entrance(REGION_VERMILION_MAGNET_TRAIN_SPEECH_HOUSE, "building")
REGION_VERMILION_CITY:connect_two_ways_entrance(REGION_VERMILION_MART, "mart")
REGION_VERMILION_CITY:connect_two_ways_entrance(REGION_VERMILION_DIGLETTS_CAVE_SPEECH_HOUSE, "building")
REGION_VERMILION_CITY:connect_two_ways_entrance(NAMED_NODES["REGION_VERMILION_PORT_PASSAGE:ENTRANCE"], "dungeon")
REGION_VERMILION_CITY:connect_two_ways(NAMED_NODES["REGION_VERMILION_CITY:GYM_ENTRANCE"], "TODOBYSNOWFLAV")
REGION_VERMILION_CITY:connect_one_way(NAMED_NODES["REGION_VERMILION_CITY:GYM_ENTRANCE_SHARED"], "Vermilion City Hidden Item Bush Access (from Mainland)")
REGION_VERMILION_CITY:connect_two_ways(NAMED_NODES["REGION_VERMILION_CITY:DIGLETTS_CAVE_ENTRANCE"], "TODOBYSNOWFLAV")

-- === REGION_VERMILION_CITY:GYM_ENTRANCE ===
NAMED_NODES["REGION_VERMILION_CITY:GYM_ENTRANCE"]:connect_two_ways_entrance(REGION_VERMILION_GYM, "gym")
NAMED_NODES["REGION_VERMILION_CITY:GYM_ENTRANCE"]:connect_one_way(NAMED_NODES["REGION_VERMILION_CITY:GYM_ENTRANCE_SHARED"], "Vermilion City Hidden Item Bush Access (from Gym)")

-- === REGION_VERMILION_POKECENTER_1F ===
REGION_VERMILION_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Vermilion Pokecenter Stairs")

-- === REGION_VERMILION_PORT ===
REGION_VERMILION_PORT:connect_two_ways_entrance(NAMED_NODES["REGION_VERMILION_PORT_PASSAGE:TUNNEL"], "dungeon_interior")
REGION_VERMILION_PORT:connect_two_ways(NAMED_NODES["REGION_VERMILION_PORT:TICKET"], "Vermilion Port Ticket Inspection", "Vermilion Port Access (from Ship)")

-- === REGION_VERMILION_PORT_PASSAGE:ENTRANCE ===
NAMED_NODES["REGION_VERMILION_PORT_PASSAGE:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_VERMILION_PORT_PASSAGE:TUNNEL"], "dungeon_interior")

-- === REGION_VICTORY_ROAD:1F:ENTRANCE ===
NAMED_NODES["REGION_VICTORY_ROAD:1F:ENTRANCE"]:connect_two_ways(NAMED_NODES["REGION_VICTORY_ROAD:1F"], "TODOBYSNOWFLAV")
NAMED_NODES["REGION_VICTORY_ROAD:1F:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD_GATE:NORTH"], "dungeon")
NAMED_NODES["REGION_VICTORY_ROAD:1F:ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_23_RESTORED:NORTH"], "dungeon")

-- === REGION_VICTORY_ROAD:1F ===
NAMED_NODES["REGION_VICTORY_ROAD:1F"]:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD:2F"], "dungeon_interior")

-- === REGION_VICTORY_ROAD:2F ===
NAMED_NODES["REGION_VICTORY_ROAD:2F"]:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD:3F"], "dungeon_interior")

-- === REGION_VICTORY_ROAD:2F:NORTHEAST ===
NAMED_NODES["REGION_VICTORY_ROAD:2F:NORTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_VICTORY_ROAD:3F:SOUTHEAST"], "dungeon_interior")
NAMED_NODES["REGION_VICTORY_ROAD:2F:NORTHEAST"]:connect_one_way(NAMED_NODES["REGION_VICTORY_ROAD:2F"], "Victory Road 2F Northeast Ledge Jump")

-- === REGION_VICTORY_ROAD:2F:NORTHWEST ===
NAMED_NODES["REGION_VICTORY_ROAD:2F:NORTHWEST"]:connect_one_way(NAMED_NODES["REGION_VICTORY_ROAD:2F"], "Victory Road 2F Northwest Ledge Jump")

-- === REGION_VICTORY_ROAD:3F ===
NAMED_NODES["REGION_VICTORY_ROAD:3F"]:connect_one_way_entrance(NAMED_NODES["REGION_VICTORY_ROAD:2F:NORTHWEST"], "one_way")
NAMED_NODES["REGION_VICTORY_ROAD:3F"]:connect_one_way(NAMED_NODES["REGION_VICTORY_ROAD:3F:SOUTHEAST"], "Victory Road 3F Southeast Ledge Jump")

-- === REGION_VICTORY_ROAD_GATE ===
REGION_VICTORY_ROAD_GATE:connect_two_ways(NAMED_NODES["REGION_VICTORY_ROAD_GATE:EAST"], "Victory Road Gate Traversal (to East)", "Victory Road Gate Traversal (from East)")
REGION_VICTORY_ROAD_GATE:connect_two_ways(NAMED_NODES["REGION_VICTORY_ROAD_GATE:WEST"], "Victory Road Gate Traversal (to West)", "Victory Road Gate Traversal (from West)")
REGION_VICTORY_ROAD_GATE:connect_two_ways(NAMED_NODES["REGION_VICTORY_ROAD_GATE:NORTH"], "Victory Road Gate Traversal (to North)", "Victory Road Gate Traversal (from North)")

-- === REGION_VICTORY_ROAD_GATE:NORTH ===
NAMED_NODES["REGION_VICTORY_ROAD_GATE:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_ROUTE_23_RESTORED:SOUTH"], "gate")

-- === REGION_VIOLET_CITY ===
REGION_VIOLET_CITY:connect_two_ways_entrance(REGION_VIOLET_MART, "mart")
REGION_VIOLET_CITY:connect_two_ways_entrance(REGION_VIOLET_GYM, "gym")
REGION_VIOLET_CITY:connect_two_ways_entrance(REGION_VIOLET_NICKNAME_SPEECH_HOUSE, "building")
REGION_VIOLET_CITY:connect_two_ways_entrance(REGION_VIOLET_POKECENTER_1F, "pokecenter")
REGION_VIOLET_CITY:connect_two_ways_entrance(REGION_VIOLET_KYLES_HOUSE, "building")

-- === REGION_VIOLET_POKECENTER_1F ===
REGION_VIOLET_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Violet Pokecenter Stairs")

-- === REGION_VIRIDIAN_CITY ===
REGION_VIRIDIAN_CITY:connect_two_ways_entrance(REGION_VIRIDIAN_GYM, "gym")
REGION_VIRIDIAN_CITY:connect_two_ways_entrance(REGION_VIRIDIAN_NICKNAME_SPEECH_HOUSE, "building")
REGION_VIRIDIAN_CITY:connect_two_ways_entrance(REGION_VIRIDIAN_MART, "mart")
REGION_VIRIDIAN_CITY:connect_two_ways_entrance(REGION_VIRIDIAN_POKECENTER_1F, "pokecenter")

-- === REGION_VIRIDIAN_GYM ===
REGION_VIRIDIAN_GYM:connect_one_way(NAMED_NODES["REGION_VIRIDIAN_GYM:BLUE"], "TODOBYSNOWFLAV")

-- === REGION_VIRIDIAN_POKECENTER_1F ===
REGION_VIRIDIAN_POKECENTER_1F:connect_one_way(REGION_POKECENTER_2F, "Viridian Pokecenter Stairs")

-- === REGION_WHIRL_ISLAND_B1F:NORTH ===
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NW:NORTH"], "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NE:SOUTHEAST"], "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_B2F:CENTER"], "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTH"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHWEST"], "Whirl Islands B1F Center Ledge Jump")

-- === REGION_WHIRL_ISLAND_B1F:NORTHEAST ===
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NE:NORTHEAST"], "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:NORTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_B2F:NORTH"], "dungeon_interior")

-- === REGION_WHIRL_ISLAND_B1F:SOUTHWEST ===
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHWEST"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_SW:NORTHWEST"], "dungeon_interior")

-- === REGION_WHIRL_ISLAND_B1F:SOUTHEAST ===
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHEAST"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_SW:NORTHEAST"], "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHEAST"]:connect_two_ways_entrance(REGION_WHIRL_ISLAND_SE, "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHEAST"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHWEST"], "TODOBYSNOWFLAV")

-- === REGION_WHIRL_ISLAND_B1F:LEDGE ===
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:LEDGE"]:connect_two_ways_entrance(REGION_WHIRL_ISLAND_CAVE, "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B1F:LEDGE"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_B1F:SOUTHWEST"], "Whirl Islands B1F Lugia Exit Tunnel Ledge Jump")

-- === REGION_WHIRL_ISLAND_B2F:NORTH ===
NAMED_NODES["REGION_WHIRL_ISLAND_B2F:NORTH"]:connect_two_ways(NAMED_NODES["REGION_WHIRL_ISLAND_B2F:SOUTH"], "Whirl Islands B2F Waterfall Descent", "Whirl Islands B2F Waterfall Ascent")

-- === REGION_WHIRL_ISLAND_B2F:LUGIA_CHAMBER_ENTRANCE ===
NAMED_NODES["REGION_WHIRL_ISLAND_B2F:LUGIA_CHAMBER_ENTRANCE"]:connect_two_ways_entrance(REGION_WHIRL_ISLAND_LUGIA_CHAMBER, "dungeon_interior")
NAMED_NODES["REGION_WHIRL_ISLAND_B2F:LUGIA_CHAMBER_ENTRANCE"]:connect_two_ways(NAMED_NODES["REGION_WHIRL_ISLAND_B2F:SOUTH"], "Whirl Islands B2F South Water Crossing (Southbound)", "Whirl Islands B2F South Water Crossing (Northbound)")

-- === REGION_WHIRL_ISLAND_B2F:SOUTH ===
NAMED_NODES["REGION_WHIRL_ISLAND_B2F:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_SW:SOUTHEAST"], "dungeon_interior")

-- === REGION_WHIRL_ISLAND_CAVE ===
REGION_WHIRL_ISLAND_CAVE:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_NW:SOUTH"], "dungeon_interior")

-- === REGION_WHIRL_ISLAND_LUGIA_CHAMBER ===
REGION_WHIRL_ISLAND_LUGIA_CHAMBER:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_LUGIA_CHAMBER:WATER"], "TODOBYSNOWFLAV")

-- === REGION_WHIRL_ISLAND_NE:WEST ===
NAMED_NODES["REGION_WHIRL_ISLAND_NE:WEST"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_NE:CENTER"], "Whirl Islands Northeast Island West Ledge Jump")

-- === REGION_WHIRL_ISLAND_NE:CENTER ===
NAMED_NODES["REGION_WHIRL_ISLAND_NE:CENTER"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_NE:SOUTHEAST"], "Whirl Islands Northeast Island Southeast Ledge Jump")
NAMED_NODES["REGION_WHIRL_ISLAND_NE:CENTER"]:connect_one_way(NAMED_NODES["REGION_WHIRL_ISLAND_NE:NORTHEAST"], "Whirl Islands Northeast Island Northeast Ledge Jump")

-- === REGION_WHIRL_ISLAND_NW:SOUTH ===
NAMED_NODES["REGION_WHIRL_ISLAND_NW:SOUTH"]:connect_two_ways_entrance(NAMED_NODES["REGION_WHIRL_ISLAND_SW:SOUTHWEST"], "dungeon_interior")

-- === REGION_WHIRL_ISLAND_SW:NORTHWEST ===
NAMED_NODES["REGION_WHIRL_ISLAND_SW:NORTHWEST"]:connect_two_ways(NAMED_NODES["REGION_WHIRL_ISLAND_SW:NORTHEAST"], "Whirl Islands Southwest Island Water Crossing (Eastbound)", "Whirl Islands Southwest Island Water Crossing (Westbound)")

-- === REGION_WHIRL_ISLAND_SW:SOUTHWEST ===
NAMED_NODES["REGION_WHIRL_ISLAND_SW:SOUTHWEST"]:connect_two_ways(NAMED_NODES["REGION_WHIRL_ISLAND_SW:SOUTHEAST"], "Whirl Islands Lugia Exit Tunnel B2F Water Crossing (Eastbound)", "Whirl Islands Lugia Exit Tunnel B2F Water Crossing (Westbound)")

-- === REGION_ROUTE_23_RESTORED:SOUTH ===
NAMED_NODES["REGION_ROUTE_23_RESTORED:SOUTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_23_RESTORED:SURF"], "Route 23 Restored Water Crossing (South -> Island)", "Route 23 Restored Water Crossing (Island -> South)")

-- === REGION_ROUTE_23_RESTORED:NORTH ===
NAMED_NODES["REGION_ROUTE_23_RESTORED:NORTH"]:connect_two_ways(NAMED_NODES["REGION_ROUTE_23_RESTORED:SURF"], "Route 23 Restored Water Crossing (North -> Island)", "Route 23 Restored Water Crossing (Island -> North)")

-- === REGION_FLOODED_MINE:NORTH_ENTRANCE ===
NAMED_NODES["REGION_FLOODED_MINE:NORTH_ENTRANCE"]:connect_two_ways_entrance(REGION_FLOODED_MINE, "dungeon_interior")

-- === REGION_CHERRYGROVE_CITY:FLOODED_MINE_ENTRANCE ===
NAMED_NODES["REGION_CHERRYGROVE_CITY:FLOODED_MINE_ENTRANCE"]:connect_two_ways_entrance(NAMED_NODES["REGION_FLOODED_MINE:SOUTH_ENTRANCE"], "dungeon")

-- === REGION_FLOODED_MINE:SOUTH_ENTRANCE ===
NAMED_NODES["REGION_FLOODED_MINE:SOUTH_ENTRANCE"]:connect_two_ways_entrance(REGION_FLOODED_MINE, "dungeon_interior")
