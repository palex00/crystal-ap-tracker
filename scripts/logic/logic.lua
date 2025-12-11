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

function johtobadges()
  return
  Tracker:ProviderCountForCode("ZEPHYR_BADGE") +
  Tracker:ProviderCountForCode("HIVE_BADGE") +
  Tracker:ProviderCountForCode("PLAIN_BADGE") +
  Tracker:ProviderCountForCode("FOG_BADGE") +
  Tracker:ProviderCountForCode("STORM_BADGE") +
  Tracker:ProviderCountForCode("MINERAL_BADGE") +
  Tracker:ProviderCountForCode("GLACIER_BADGE") +
  Tracker:ProviderCountForCode("RISING_BADGE")
end

function kantobadges()
  return
  Tracker:ProviderCountForCode("BOULDER_BADGE") +
  Tracker:ProviderCountForCode("CASCADE_BADGE") +
  Tracker:ProviderCountForCode("THUNDER_BADGE") +
  Tracker:ProviderCountForCode("RAINBOW_BADGE") +
  Tracker:ProviderCountForCode("SOUL_BADGE") +
  Tracker:ProviderCountForCode("MARSH_BADGE") +
  Tracker:ProviderCountForCode("VOLCANO_BADGE") +
  Tracker:ProviderCountForCode("EARTH_BADGE")
end

function unown_goal()
  return((
  Tracker:ProviderCountForCode("UNOWN_1") +
  Tracker:ProviderCountForCode("UNOWN_2") +
  Tracker:ProviderCountForCode("UNOWN_3") +
  Tracker:ProviderCountForCode("UNOWN_4") +
  Tracker:ProviderCountForCode("UNOWN_5") +
  Tracker:ProviderCountForCode("UNOWN_6") +
  Tracker:ProviderCountForCode("UNOWN_7") +
  Tracker:ProviderCountForCode("UNOWN_8") +
  Tracker:ProviderCountForCode("UNOWN_9") +
  Tracker:ProviderCountForCode("UNOWN_10") +
  Tracker:ProviderCountForCode("UNOWN_11") +
  Tracker:ProviderCountForCode("UNOWN_12") +
  Tracker:ProviderCountForCode("UNOWN_13") +
  Tracker:ProviderCountForCode("UNOWN_14") +
  Tracker:ProviderCountForCode("UNOWN_15") +
  Tracker:ProviderCountForCode("UNOWN_16") +
  Tracker:ProviderCountForCode("UNOWN_17") +
  Tracker:ProviderCountForCode("UNOWN_18") +
  Tracker:ProviderCountForCode("UNOWN_19") +
  Tracker:ProviderCountForCode("UNOWN_20") +
  Tracker:ProviderCountForCode("UNOWN_21") +
  Tracker:ProviderCountForCode("UNOWN_22") +
  Tracker:ProviderCountForCode("UNOWN_23") +
  Tracker:ProviderCountForCode("UNOWN_24") +
  Tracker:ProviderCountForCode("UNOWN_25") +
  Tracker:ProviderCountForCode("UNOWN_26")) == 26)
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

function strength_badge()
    return (
        (has("badgereqs_vanilla") and has("PLAIN_BADGE")) or
        (has("badgereqs_kanto") and (has("PLAIN_BADGE") or has("RAINBOW_BADGE"))) or
        (has("badgereqs_none")) or
        (has("badgereqs_regional") and has("PLAIN_BADGE")) or 
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
    (has("badgereqs_regional") and has("GLACIER_BADGE")) or 
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
    (has("badgereqs_regional") and has("RISING_BADGE")) or 
    has("FREE_WATERFALL")
  )
end

function can_waterfall()
  return (has("HM_WATERFALL") and waterfall_badge() and can_surf_johto())
  -- this is hardcoded to Johto because Kanto does currently not have waterfalls
end

function mm_rocksmash()
    return (has("TM_ROCK_SMASH") or has("mount_mortar_access_vanilla"))
end

function route42_passage()
    if has("route_42_access_vanilla") then
        return can_surf_johto()
    elseif (has("route_42_access_whirlpool") or has("route_42_access_whirlchanges")) then
        return can_whirlpool()
    else
        return false
    end
end

function fly_badge()
  return (
    (has("badgereqs_vanilla") and has("STORM_BADGE")) or
    (has("badgereqs_kanto") and (has("STORM_BADGE") or has("THUNDER_BADGE"))) or
    has("badgereqs_none") or
    (has("badgereqs_regional") and (has("STORM_BADGE") or has("THUNDER_BADGE"))) or 
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
  return can_fly() and 
  (has("free_fly_"..destination) or
  (has("map_card_fly_"..destination) and has_mapcard()) or
  (has("flyunlock_"..destination)))
end

function clear_snorlax()
  return (has("POKE_GEAR") and has("RADIO_CARD") and has("EXPN_CARD"))
end

function all_badges()
    return kantobadges() == 8
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

function fly_cheese()
    if has("fly_cheese_optional") and can_fly() and has("randomize_fly_unlocks_false") then
        return AccessibilityLevel.SequenceBreak
    elseif has("fly_cheese_required") and can_fly() and has("randomize_fly_unlocks_false") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.None
    end
end

function fly_cheese_unlock()
    if has("fly_cheese_optional") then
        return AccessibilityLevel.SequenceBreak
    elseif has("fly_cheese_required") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.None
    end
end

function kurt_shop(color)
    if has(color.."_APRICORN") then
        return AccessibilityLevel.Normal
    elseif has("berries_off") then
        return AccessibilityLevel.SequenceBreak
    else
        return AccessibilityLevel.Inspect
    end
end

function bluecard_shop(amount)
    if has("BLUE_CARD") and has("BLUE_CARD_POINT", amount) then
        return AccessibilityLevel.Normal
    elseif has("BLUE_CARD") then
        return AccessibilityLevel.Inspect
    else
        return AccessibilityLevel.None
    end
end

function victory_road_access()
    if has("victory_road_access_vanilla") then
        return AccessibilityLevel.Normal
    elseif has("victory_road_access_strength") and can_strength() then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.None
    end
end

function dark(area)
    if has("dark_"..area.."_false") then
        return AccessibilityLevel.Normal
    elseif has("dark_"..area.."_true") then
        if area == "diglettscave" or area == "mountmoon" or area == "rocktunnel" then
            return can_flash("kanto")
        else
            return can_flash("johto")
        end
    end
end

function can_use_flash(region)
    return has("HM_FLASH") and (
        has("FREE_FLASH") or
        has("badgereqs_none") or
        (has("badgereqs_vanilla") and has("ZEPHYR_BADGE")) or
        (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE"))) or
        (has("badgereqs_regional") and (
            (region == "johto" and has("ZEPHYR_BADGE")) or
            (region == "kanto" and has("BOULDER_BADGE"))
        ))
    )
end

function can_flash(region)
    if has("require_flash_notrequired") then
        return AccessibilityLevel.Normal
    elseif has("require_flash_hardrequired") then
        return can_use_flash(region) and AccessibilityLevel.Normal or AccessibilityLevel.None
    else
        return can_use_flash(region) and AccessibilityLevel.Normal or AccessibilityLevel.SequenceBreak
    end
end

-- this one literally only exists for the Aerodactyl Room
function flash_badge()
    return (
        has("badgereqs_none") or
        has("FREE_FLASH") or
        ((has("badgereqs_vanilla") or has("badgereqs_regional")) and has("ZEPHYR_BADGE")) or
        (has("badgereqs_kanto") and (has("ZEPHYR_BADGE") or has("BOULDER_BADGE")))
    )
end

function kantogymlock()
    local snorlax = Tracker:FindObjectForCode("@JohtoKanto/Vermilion City/City").AccessibilityLevel
    local hooh = Tracker:FindObjectForCode("@JohtoKanto/Tin Tower/9F - Item").AccessibilityLevel
    local lugia = Tracker:FindObjectForCode("@JohtoKanto/Whirl Islands/B2F - North Item").AccessibilityLevel
    local suicune = Tracker:FindObjectForCode("@JohtoKanto/Tin Tower").AccessibilityLevel
    local silvercave = Tracker:FindObjectForCode("@JohtoKanto/Silver Cave").AccessibilityLevel

    if has("lock_kanto_gyms_false") then
        return AccessibilityLevel.Normal
    end

    if has("lock_kanto_gyms_true") then
        if (snorlax == AccessibilityLevel.Normal and clear_snorlax())
        or hooh == AccessibilityLevel.Normal
        or (lugia == AccessibilityLevel.Normal and has("SILVER_WING"))
        or suicune == AccessibilityLevel.Normal
        or silvercave == AccessibilityLevel.Normal then
            return AccessibilityLevel.Normal
        else
            return AccessibilityLevel.SequenceBreak
        end
    end
end

function boat_access()
    if has("ss_aqua_access_vanilla") and has("S_S_TICKET") then
        return true
    elseif has("ss_aqua_access_amphy") and has("S_S_TICKET") and has("EVENT_JASMINE_RETURNED_TO_GYM") then
        return true
    else
        return false    
    end
end

function train_access()
    if has("magnet_train_access_vanilla") and has("PASS") then
        return true
    elseif has("magnet_train_access_power") and has("PASS") and has("EVENT_RESTORED_POWER_TO_KANTO") then
        return true
    else
        return false    
    end
end

function unownsign(sign)
    if (CHECKED_SIGNS == nil) or (UNOWN_DATA == nil) then
        return AccessibilityLevel.Inspect
    end

    local allChecked = true
    for key, _ in pairs(UNOWN_DATA) do
        if not table_contains(CHECKED_SIGNS, key) then
            allChecked = false
            break
        end
    end
    local value = nil
    local letter = nil
    if UNOWN_DATA[sign] ~= nil then
        value = UNOWN_DATA[sign]
        letter = value:sub(#value, #value)
    end
    
    if allChecked == false then
        if not table_contains(CHECKED_SIGNS, sign) then
            return AccessibilityLevel.Inspect
        elseif not UNOWN_DATA[sign] then
            Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            return AccessibilityLevel.Normal
        elseif has("Unown_"..letter) then
            Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            return AccessibilityLevel.Normal
        else
            if letter >= "A" and letter <= "K" then
                if has("ENGINE_UNLOCKED_UNOWNS_A_TO_K") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "L" and letter <= "R" then
                if has("ENGINE_UNLOCKED_UNOWNS_L_TO_R") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "S" and letter <= "W" then
                if has("ENGINE_UNLOCKED_UNOWNS_S_TO_W") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "X" and letter <= "Z" then
                if has("ENGINE_UNLOCKED_UNOWNS_X_TO_Z") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            end
        end
    else
        if not table_contains(UNOWN_DATA, sign) then
            Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            return AccessibilityLevel.Normal
        elseif has("Unown_"..letter) then
            Tracker:FindObjectForCode(SIGN_MAPPING[sign]).AvailableChestCount = 0
            return AccessibilityLevel.Normal
        else
            if letter >= "A" and letter <= "K" then
                if has("ENGINE_UNLOCKED_UNOWNS_A_TO_K") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "L" and letter <= "R" then
                if has("ENGINE_UNLOCKED_UNOWNS_L_TO_R") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "S" and letter <= "W" then
                if has("ENGINE_UNLOCKED_UNOWNS_S_TO_W") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            elseif letter >= "X" and letter <= "Z" then
                if has("ENGINE_UNLOCKED_UNOWNS_X_TO_Z") then
                    return AccessibilityLevel.Normal
                else
                    return AccessibilityLevel.None
                end
            end
        end        
    end
end

function phonecard()
    if has("PHONE_CARD") and has("POKE_GEAR") then
        return AccessibilityLevel.Normal
    elseif has("PHONE_CARD") and has("require_pokegear_for_phone_numbers_false") then
        return AccessibilityLevel.SequenceBreak    
    else
        return AccessibilityLevel.None
    end
end

function phonecall()
    if has("randomize_phone_call_items_vanilla") then
        if Tracker:FindObjectForCode("@JohtoKanto/New Bark Town").AccessibilityLevel ~= AccessibilityLevel.None then
            return math.max(Tracker:FindObjectForCode("@JohtoKanto/New Bark Town").AccessibilityLevel, phonecard())
        else
            return phonecard()
        end
    elseif has("randomize_phone_call_items_simple") then
        return phonecard()
    end
end

function request_pokemon()
    return AccessibilityLevel.Normal
    -- we'll deal with this when people complain.
end

function diplomagoal()
    return CAUGHT_COUNT <= Tracker:FindObjectForCode("diploma_goal_count").AcquiredCount
end