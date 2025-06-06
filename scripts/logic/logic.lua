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

gym_codes = {
    "EVENT_BEAT_FALKNER",
    "EVENT_BEAT_BUGSY",
    "EVENT_BEAT_WHITNEY",
    "EVENT_BEAT_MORTY",
    "EVENT_BEAT_JASMINE",
    "EVENT_BEAT_CHUCK",
    "EVENT_BEAT_PRYCE",
    "EVENT_BEAT_CLAIR",
    "EVENT_BEAT_BROCK",
    "EVENT_BEAT_MISTY",
    "EVENT_BEAT_LTSURGE",
    "EVENT_BEAT_ERIKA",
    "EVENT_BEAT_JANINE",
    "EVENT_BEAT_SABRINA",
    "EVENT_BEAT_BLAINE",
    "EVENT_BEAT_BLUE"
}

function gyms()
  return
  Tracker:ProviderCountForCode("EVENT_BEAT_FALKNER") +
  Tracker:ProviderCountForCode("EVENT_BEAT_BUGSY") +
  Tracker:ProviderCountForCode("EVENT_BEAT_WHITNEY") +
  Tracker:ProviderCountForCode("EVENT_BEAT_MORTY") +
  Tracker:ProviderCountForCode("EVENT_BEAT_JASMINE") +
  Tracker:ProviderCountForCode("EVENT_BEAT_CHUCK") +
  Tracker:ProviderCountForCode("EVENT_BEAT_PRYCE") +
  Tracker:ProviderCountForCode("EVENT_BEAT_CLAIR") +

  Tracker:ProviderCountForCode("EVENT_BEAT_BROCK") +
  Tracker:ProviderCountForCode("EVENT_BEAT_MISTY") +
  Tracker:ProviderCountForCode("EVENT_BEAT_LTSURGE") +
  Tracker:ProviderCountForCode("EVENT_BEAT_ERIKA") +
  Tracker:ProviderCountForCode("EVENT_BEAT_JANINE") +
  Tracker:ProviderCountForCode("EVENT_BEAT_SABRINA") +
  Tracker:ProviderCountForCode("EVENT_BEAT_BLAINE") +
  Tracker:ProviderCountForCode("EVENT_BEAT_BLUE")
end

function hid()
    if has("reqitemfinder_off") then
        return AccessibilityLevel.Normal
    elseif has("ITEMFINDER") then
        return AccessibilityLevel.Normal
    elseif has("reqitemfinder_logic") then
        return AccessibilityLevel.SequenceBreak
    elseif has("reqitemfinder_required") then
        return AccessibilityLevel.None
    end
end

function can_cut_johto()
  return has("HM_CUT") and (
  has("FREE_CUT") or
  has("badgereqs_none") or
  ((has("badgereqs_vanilla") or has("badgereqs_regional")) and has("HIVE_BADGE")) or
  (has("badgereqs_kanto") and (has("HIVE_BADGE") or has("CASCADE_BADGE")))
  )
end

function can_cut_kanto()
  return has("HM_CUT") and (
  has("FREE_CUT") or
  has("badgereqs_none") or
  (has("badgereqs_vanilla") and has("HIVE_BADGE")) or
  (has("badgereqs_kanto") and (has("HIVE_BADGE") or has("CASCADE_BADGE"))) or
  (has("badgereqs_regional") and has("CASCADE_BADGE"))
  )
end

function can_flash_johto()
  if has("HM_FLASH") and (
  has("FREE_FLASH") or
  has("badgereqs_none") or
  ((has("badgereqs_vanilla") or has("badgereqs_regional")) and has("ZEPHYR_BADGE")) or
  (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE")))
  ) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

function can_flash_kanto()
  if has("HM_FLASH") and (
  has("FREE_FLASH") or
  has("badgereqs_none") or
  (has("badgereqs_vanilla") and has("ZEPHYR_BADGE")) or
  (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE"))) or
  (has("badgereqs_regional") and has("BOULDER_BADGE"))
  ) then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end

-- this one literally only exists for the Aerodactyl Room
function flash_badge()
  return (
    has("badgereqs_none") or
    has("FREE_FLASH") or
    ((has("badgereqs_vanilla") or has("badge_reqs_regional")) and has("ZEPHYR_BADGE")) or
    (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE")))
  )
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

function can_surf_johto()
  return has("HM_SURF") and (
  has("FREE_SURF") or
  has("badgereqs_none") or
  ((has("badgereqs_vanilla") or has("badgereqs_regional")) and has("FOG_BADGE")) or
  (has("badgereqs_kanto") and (has("FOG_BADGE") or has("SOUL_BADGE")))
  )
end

function can_surf_kanto()
  return has("HM_SURF") and (
  has("FREE_SURF") or
  has("badgereqs_none") or
  (has("badgereqs_vanilla") and has("FOG_BADGE")) or
  (has("badgereqs_kanto") and (has("FOG_BADGE") or has("SOUL_BADGE"))) or
  (has("badgereqs_regional") and has("SOUL_BADGE"))
  )
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
  return (has("HM_WHIRLPOOL") and whirlpool_badge() and can_surf_johto())
  -- this is hardcoded to Johto because Kanto does currently not have whirlpools
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
  return (has("HM_WATERFALL") and waterfall_badge() and can_surf_johto())
  -- this is hardcoded to Johto because Kanto does currently not have waterfalls
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

function clear_snorlax()
  return (has("POKE_GEAR") and has("RADIO_CARD") and has("EXPN_CARD"))
end

function all_badges()
  return badges() > 15
end

function silver_cave()
  return not has("johto_only_on")
end

function ilextree()
  return has("ilextree_off")
  or has("ilextree_on") and can_cut_johto()
end

function r32_guy()
  return has("r32_guy_open")
  or has("r32_guy_badge") and (badges() >= 1)
  or has("r32_guy_gym") and (gyms() >= 1)
  or has("r32_guy_egg") and has("EVENT_GOT_TOGEPI_EGG_FROM_ELMS_AIDE")
  or has("r32_guy_zephyr") and has("ZEPHYR_BADGE")
end

function tea(direction)
  return has("coffee_"..direction) and has("tea")
  or not has("coffee_"..direction)
end

function passage(direction)
  return has("underground_power_".. direction) and has("EVENT_RESTORED_POWER_TO_KANTO")
  or not has("underground_power_".. direction)
end

function nationalpark()
  return has("national_park_vanilla") or has("BICYCLE")
end

function scout()
  return AccessibilityLevel.Inspect
end

function badges_randomised()
  return has("badges_on") or has("badges_shuffle")
end