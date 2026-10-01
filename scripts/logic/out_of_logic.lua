UNFILTERED = {}

local FILTERED_RULES = {
    "CanReach",
    "dark",
    "hid",
    "kantogymlock",
    "phonecall",
    "mom_saving",
    "battletower_milestones",
    "battletower_trainer",
    "land_encounter",
    "surf_encounter_johto",
    "surf_encounter_kanto",
    "fishing_old",
    "fishing_good",
    "fishing_super",
    "headbutting",
    "rocksmash_encounter",
    "static_encounter",
    "contest_encounter",
    "swarm_encounter",
    "trade",
}

for _, name in ipairs(FILTERED_RULES) do
    local rule = _G[name]
    UNFILTERED[name] = rule
    _G[name] = function(...)
        local level = rule(...)
        if level == ACCESS_SEQUENCEBREAK and has("out_of_logic_off") then
            return ACCESS_NONE
        end
        return level
    end
end
