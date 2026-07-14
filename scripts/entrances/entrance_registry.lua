-- DUMMY / EXAMPLE FILE — replace with the real Pokémon Crystal entrance registry.
--
-- The central correlation table between the three representations of every entrance:
--   * region-string token  (slot_data + graph identity, and the table key here)
--   * numeric id           (what the DataStorage "entered" list carries)
--   * pretty name          (shown to the user in badges / the route list)
-- Plus the UiHint tab-chain to navigate to the entrance's marker.
--
-- The warp's ER CATEGORY and its ONE-WAY-ness are NOT stored here — they live on the
-- matching connect_*_entrance edge in connections.lua (the category arg, and whether it's a
-- connect_one_way_/connect_two_ways_ call). This file is purely the id <-> token <-> pretty
-- (+ nav) table; the graph owns topology.
--
-- Loaded after the region graph and before entrance_item.lua's createEntrances().
-- The token MUST equal "<from region> -> <to region>" of the matching entrance edge in
-- connections.lua, so the graph, slot_data, and this registry all agree.

-- The ER categories (~10 modes). Each must have a matching progressive toggle item in
-- items/settings_er.json with codes "er_<cat>" / "er_<cat>_on" / "er_<cat>_off", and is
-- what a connect_*_entrance(..., "<cat>") edge is gated on.
ER_CATEGORIES = {
    "dungeon",
    "dungeon_interior",
    "gym",
    "gym_interior",
    "mart",
    "mart_interior",
    "building",
    "building_interior",
    "gate",
    "pokecenter",
    "elevator",
    "pokemon_league",
    "one_way",
}

ENTRANCE_REGISTRY = {
    ["REGION_NEW_BARK_TOWN -> REGION_ELMS_LAB"] = {
        id = 1180,
        pretty = "Elm's Lab Entrance", -- shown on the item badge AND as the route hop label
        tab = { "Johto Cities", "New Bark Town", "City" }, -- UiHint ActivateTab chain
        -- optional: "@Location/Section" of this entrance's marker, used to briefly
        -- highlight it when another entrance navigates here. Omit to skip the highlight.
        section = "@New Bark Town/Elm's Lab Entrance",
    },
    ["REGION_AZALEA_TOWN -> REGION_SLOWPOKE_WELL"] = {
        id = 214,
        pretty = "Slowpoke Well Entrance",
        tab = { "Johto Cities", "Azalea Town", "City" },
    },
    ["REGION_ILEX_FOREST -> REGION_ILEX_FOREST_HOLE"] = {
        id = 990,
        pretty = "Ilex Forest Hole",
        tab = { "Johto Routes", "Ilex Forest" }, -- one-way-ness comes from the edge (connect_one_way_entrance)
    },
}

-- Reverse indexes, built once at load. Do not edit by hand.
REGISTRY = { byId = {}, byPretty = {} }
for token, row in pairs(ENTRANCE_REGISTRY) do
    row.token = token
    REGISTRY.byId[row.id] = row
    REGISTRY.byPretty[row.pretty] = row
end
