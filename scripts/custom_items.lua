-- palex00 here. I am out of my depth.
-- I am cannibalising FRLG's custom lua items with Vyneras' permission.
-- I am leaving Pokedex stuff in it in case I ever need it

ScriptHost:LoadScript("scripts/custom_items/class.lua")
ScriptHost:LoadScript("scripts/custom_items/custom_item.lua")
ScriptHost:LoadScript("scripts/custom_items/badges_gyms_requirement.lua")
-- ScriptHost:LoadScript("scripts/custom_items/kanto_access_requirement.lua")
-- ScriptHost:LoadScript("scripts/custom_items/pokedex.lua")
-- ScriptHost:LoadScript("scripts/custom_items/pokedex_requirement.lua")

E4_REQ = BadgesGymsRequirement("Elite Four Requirement", "e4_requirement", 8, 16, "images/settings/e4_requirement.png")
RED_REQ = BadgesGymsRequirement("Red Requirement", "red_requirement", 16, 16, "images/settings/red_requirement.png")
RADIO_REQ = BadgesGymsRequirement("Radio Tower Requirement", "tower_requirement", 7, 16, "images/settings/tower_requirement.png")
SILVER_REQ = BadgesGymsRequirement("Mt. Silver Requirement", "mt_silver_requirement", 16, 16, "images/settings/mt_silver_requirement.png")

-- POKEDEX = Pokedex()