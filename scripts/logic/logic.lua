function badges()
	return Tracker:ProviderCountForCode("ZEPHYR_BADGE") + 
	Tracker:ProviderCountForCode("HIVE_BADGE") + 
	Tracker:ProviderCountForCode("PLAIN_BADGE") + 
	Tracker:ProviderCountForCode("FOG_BADGE") + 
	Tracker:ProviderCountForCode("STORM_BADGE") + 
	Tracker:ProviderCountForCode("MINERAL_BADGE") + 
	Tracker:ProviderCountForCode("GLACIER_BADGE") + 
	Tracker:ProviderCountForCode("RISING_BADGE") + 

	Tracker:ProviderCountForCode("BOULDER_BADGE") + 
	Tracker:ProviderCountForCode("CASCADE_BADGE") + 
	Tracker:ProviderCountForCode("THUNDER_BADGE") + 
	Tracker:ProviderCountForCode("RAINBOW_BADGE") + 
	Tracker:ProviderCountForCode("SOUL_BADGE") + 
	Tracker:ProviderCountForCode("MARSH_BADGE") + 
	Tracker:ProviderCountForCode("VOLCANO_BADGE") + 
	Tracker:ProviderCountForCode("EARTH_BADGE")
end

function hid()
	return (has("ITEMFINDER") or has("reqitemfinder_off"))
end

function cut_badge()
	return (
		(has("badgereqs_vanilla") and has("HIVE_BADGE")) or
		(has("badgereqs_kanto") and (has("HIVE_BADGE") or has("CASCADE_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_cut()
	return (has("HM_CUT") and cut_badge())
end

function flash_badge()
	return (
		(has("badgereqs_vanilla") and has("ZEPHYR_BADGE")) or
		(has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_flash()
	if has("HM_FLASH") and flash_badge() then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function strength_badge()
	return (
		(has("badgereqs_vanilla") and has("PLAIN_BADGE")) or
		(has("badgereqs_kanto") and (has("PLAIN_BADGE") or has("RAINBOW_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_strength()
	return (has("HM_STRENGTH") and strength_badge())
end

function surf_badge()
	return (
		(has("badgereqs_vanilla") and has("FOG_BADGE")) or
		(has("badgereqs_kanto") and (has("FOG_BADGE") or has("SOUL_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_surf()
	return (has("HM_SURF") and surf_badge())
end

function whirlpool_badge()
	return (
		(has("badgereqs_vanilla") and has("GLACIER_BADGE")) or
		(has("badgereqs_kanto") and (has("GLACIER_BADGE") or has("VOLCANO_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_whirlpool()
	return (has("HM_WHIRLPOOL") and whirlpool_badge() and can_surf())
end

function waterfall_badge()
	return (
		(has("badgereqs_vanilla") and has("RISING_BADGE")) or
		(has("badgereqs_kanto") and (has("RISING_BADGE") or has("EARTH_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_waterfall()
	return (has("HM_WATERFALL") and waterfall_badge() and can_surf())
end

function can_rocksmash()
	return has("TM_ROCK_SMASH")
end

function fly_badge()
	return (
		(has("badgereqs_vanilla") and has("STORM_BADGE")) or
		(has("badgereqs_kanto") and (has("STORM_BADGE") or has("THUNDER_BADGE"))) or
		has("badgereqs_none")
	)
end

function can_fly()
	return (has("HM_FLY") and fly_badge())
end

function has_mapcard()
	return has("POKE_GEAR") and has("MAP_CARD")
end


function can_freefly(destination)
	return can_fly() and (has("free_fly_"..destination) or (has("map_card_fly_"..destination) and has_mapcard()))
end

function tower_takeover() 
	return badges() >= progCount("e4_badges") - 1
end

function ecruteak_freefly()
	return can_freefly("Ecruteak") or can_freefly("Olivine") or can_freefly("Mahogany") or can_freefly("Blackthorn") or (can_freefly("Cianwood") and can_surf())
end

function ecruteak_access()
	return has("SQUIRTBOTTLE") or ferry_from_vermilion() or ecruteak_freefly()
end

function ferry_from_vermilion()
	return (has("PASS") or saffron_freefly() or west_kanto_freefly()) and has("S_S_TICKET")
end

function tintower_access()
    if ecruteak_access() and has("CLEAR_BELL") and has("EVENT_CLEARED_RADIO_TOWER") then
        return AccessibilityLevel.Normal
    elseif ecruteak_access() and has("EVENT_CLEARED_RADIO_TOWER") then
        return AccessibilityLevel.None
    elseif ecruteak_access() then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.None -- or any default value that fits your logic
    end
end

function cianwood_access()
	return (ecruteak_access() and can_surf()) or can_freefly("Cianwood")
end

function icepath_access()
	return (ecruteak_access() and tower_takeover() ) or can_freefly("Blackthorn")
end

function blackthorn_access()
	return (icepath_access() and can_strength()) or can_freefly("Blackthorn")
end

function clear_snorlax()
	return (has("POKE_GEAR") and has("RADIO_CARD") and has("EXPN_CARD"))
end

function elite_four_badges()
	return badges() >= progCount("e4_badges")
end

function rt26_access()
	return can_waterfall() or (viridian_access() and clear_snorlax()) 
end

function victoryroad_access()
	return rt26_access() and elite_four_badges()
end

function saffron_freefly()
	return can_freefly("Saffron") or can_freefly("Cerulean") or can_freefly("Vermilion") or can_freefly("Lavender") or can_freefly("Fuchsia") or can_freefly("Celadon")
end

function saffron_access()
	return has("PASS") or ferry_from_ecruteak() or saffron_freefly() or west_kanto_freefly()
end

function ferry_from_ecruteak()
	return (has("SQUIRTBOTTLE") or ecruteak_freefly()) and has("S_S_TICKET")
end

function powerplant_access()
	return saffron_access() and can_surf() and (can_flash() or can_cut())
end

function west_kanto_freefly()
	return can_freefly("Viridian") or can_freefly("Pewter")
end

function viridian_access()
	return (clear_snorlax() and saffron_access()) or west_kanto_freefly()
end

function red_badges()
	return badges() >= progCount("red_badges")
end

function all_badges()
	return badges() > 15
end

function red_access()
	return red_badges() and rt26_access()
end

function silver_cave()
	return not has("johto_only_on")
end

function ilextree()
  return has("ilextree_off")
  or has("ilextree_on") and can_cut()
end