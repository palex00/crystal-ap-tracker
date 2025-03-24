function badges()
  return
  Tracker:ProviderCountForCode("ZEPHYR_BADGE") +
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
    has("badgereqs_none") or
        has("FREE_CUT")
  )
end

function can_cut()
  return (has("HM_CUT") and cut_badge())
end

function flash_badge()
  return (
    (has("badgereqs_vanilla") and has("ZEPHYR_BADGE")) or
    (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE"))) or
    has("badgereqs_none") or
        has("FREE_FLASH")
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
    has("badgereqs_none") or
        has("FREE_STRENGTH")
  )
end

function can_strength()
  return (has("HM_STRENGTH") and strength_badge())
end

function surf_badge()
  return (
    (has("badgereqs_vanilla") and has("FOG_BADGE")) or
    (has("badgereqs_kanto") and (has("FOG_BADGE") or has("SOUL_BADGE"))) or
    has("badgereqs_none") or
        has("FREE_SURF")
  )
end

function can_surf()
  return (has("HM_SURF") and surf_badge())
end

function whirlpool_badge()
  return (
    (has("badgereqs_vanilla") and has("GLACIER_BADGE")) or
    (has("badgereqs_kanto") and (has("GLACIER_BADGE") or has("VOLCANO_BADGE"))) or
    has("badgereqs_none") or
        has("FREE_WHIRLPOOL")
  )
end

function can_whirlpool()
  return (has("HM_WHIRLPOOL") and whirlpool_badge() and can_surf())
end

function waterfall_badge()
  return (
    (has("badgereqs_vanilla") and has("RISING_BADGE")) or
    (has("badgereqs_kanto") and (has("RISING_BADGE") or has("EARTH_BADGE"))) or
    has("badgereqs_none") or
        has("FREE_WATERFALL")
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
    has("badgereqs_none") or
        has("FREE_FLY")
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
  return badges() >= progCount("tower_badges")
end

function clear_snorlax()
  return (has("POKE_GEAR") and has("RADIO_CARD") and has("EXPN_CARD"))
end

function elite_four_badges()
  return badges() >= progCount("e4_badges")
end

function red_badges()
  return badges() >= progCount("red_badges")
end

function mt_silver_badges()
  return badges() >= progCount("mt_silver_badges")
end

function all_badges()
  return badges() > 15
end

function silver_cave()
  return not has("johto_only_on")
end

function ilextree()
  return has("ilextree_off")
  or has("ilextree_on") and can_cut()
end

function r32_guy()
  return has("r32_guy_open")
  or has("r32_guy_badge") and (badges() >= 1)
  or has("r32_guy_egg") and has("EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE")
end

function tea(direction)
  return has("coffee"..direction) and has("tea")
  or not has("coffee_"..direction)
end

function passage(direction)
  return has("underground_power_".. direction) and has("EVENT_RESTORED_POWER_TO_KANTO")
  or not has("underground_power_".. direction)
end