function badges()
  return
  LogicCount("ZEPHYR_BADGE") +
  LogicCount("HIVE_BADGE") +
  LogicCount("PLAIN_BADGE") +
  LogicCount("FOG_BADGE") +
  LogicCount("STORM_BADGE") +
  LogicCount("MINERAL_BADGE") +
  LogicCount("GLACIER_BADGE") +
  LogicCount("RISING_BADGE") +

  LogicCount("BOULDER_BADGE") +
  LogicCount("CASCADE_BADGE") +
  LogicCount("THUNDER_BADGE") +
  LogicCount("RAINBOW_BADGE") +
  LogicCount("SOUL_BADGE") +
  LogicCount("MARSH_BADGE") +
  LogicCount("VOLCANO_BADGE") +
  LogicCount("EARTH_BADGE")
end

function johtobadges()
  return
  LogicCount("ZEPHYR_BADGE") +
  LogicCount("HIVE_BADGE") +
  LogicCount("PLAIN_BADGE") +
  LogicCount("FOG_BADGE") +
  LogicCount("STORM_BADGE") +
  LogicCount("MINERAL_BADGE") +
  LogicCount("GLACIER_BADGE") +
  LogicCount("RISING_BADGE")
end

function kantobadges()
  return
  LogicCount("BOULDER_BADGE") +
  LogicCount("CASCADE_BADGE") +
  LogicCount("THUNDER_BADGE") +
  LogicCount("RAINBOW_BADGE") +
  LogicCount("SOUL_BADGE") +
  LogicCount("MARSH_BADGE") +
  LogicCount("VOLCANO_BADGE") +
  LogicCount("EARTH_BADGE")
end

function unown_goal()
  return((
  LogicCount("UNOWN_1") +
  LogicCount("UNOWN_2") +
  LogicCount("UNOWN_3") +
  LogicCount("UNOWN_4") +
  LogicCount("UNOWN_5") +
  LogicCount("UNOWN_6") +
  LogicCount("UNOWN_7") +
  LogicCount("UNOWN_8") +
  LogicCount("UNOWN_9") +
  LogicCount("UNOWN_10") +
  LogicCount("UNOWN_11") +
  LogicCount("UNOWN_12") +
  LogicCount("UNOWN_13") +
  LogicCount("UNOWN_14") +
  LogicCount("UNOWN_15") +
  LogicCount("UNOWN_16") +
  LogicCount("UNOWN_17") +
  LogicCount("UNOWN_18") +
  LogicCount("UNOWN_19") +
  LogicCount("UNOWN_20") +
  LogicCount("UNOWN_21") +
  LogicCount("UNOWN_22") +
  LogicCount("UNOWN_23") +
  LogicCount("UNOWN_24") +
  LogicCount("UNOWN_25") +
  LogicCount("UNOWN_26")) == 26)
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
  LogicCount("EVENT_BEAT_FALKNER") +
  LogicCount("EVENT_BEAT_BUGSY") +
  LogicCount("EVENT_BEAT_WHITNEY") +
  LogicCount("EVENT_BEAT_MORTY") +
  LogicCount("EVENT_BEAT_JASMINE") +
  LogicCount("EVENT_BEAT_CHUCK") +
  LogicCount("EVENT_BEAT_PRYCE") +
  LogicCount("EVENT_BEAT_CLAIR") +

  LogicCount("EVENT_BEAT_BROCK") +
  LogicCount("EVENT_BEAT_MISTY") +
  LogicCount("EVENT_BEAT_LTSURGE") +
  LogicCount("EVENT_BEAT_ERIKA") +
  LogicCount("EVENT_BEAT_JANINE") +
  LogicCount("EVENT_BEAT_SABRINA") +
  LogicCount("EVENT_BEAT_BLAINE") +
  LogicCount("EVENT_BEAT_BLUE")
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

-- Generic Rock Smash. Distinct from mm_rocksmash(), which also passes when Mt. Mortar is
-- set to vanilla access.
function can_rock_smash()
    return has("TM_ROCK_SMASH")
end

function can_headbutt()
    return has("TM_HEAD_BUTT")
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
  return (has("coffee_"..direction) and has("TEA"))
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
    elseif not has("EVENT_SEEN_MART_KURTS_BALLS") then
        return AccessibilityLevel.Inspect
    else
        return AccessibilityLevel.None
    end
end

function bluecard_shop(amount)
    if has("BLUE_CARD") and has("BLUE_CARD_POINT", amount) then
        return AccessibilityLevel.Normal
    elseif has("BLUE_CARD") and not has("EVENT_SEEN_MART_BLUE_CARD") then
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

-- DUMMY. The apworld gates the Victory Road Gate on a badge/gym COUNT
-- (VictoryRoadRequirement + victory_road_count), which the pack does not model yet: it needs
-- its own BadgesGymsRequirement custom item plus an ap_helper slot mapping, the way
-- e4_requirement / mt_silver_requirement / route_44_requirement do. Until then this always
-- passes, so the gate is not enforced.
-- NOTE: unrelated to victory_road_access() above, which is the Strength-boulder gate inside
-- Victory Road itself.
function has_victory_road_requirement()
    return true
end

function has_pokedex()
    return has("POKEDEX")
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
    -- The gate only exists at all when lock_kanto_gyms is on.
    if not has("lock_kanto_gyms_true") then
        return AccessibilityLevel.Normal
    end

    local snorlax = CanReach("REGION_VERMILION_CITY")
    local hooh = CanReach("REGION_TIN_TOWER_9F:NORTH")
    local lugia = CanReach("REGION_WHIRL_ISLAND_B2F:NORTH")
    local suicune = CanReach("REGION_TIN_TOWER_1F")
    local silvercave = CanReach("REGION_SILVER_CAVE_OUTSIDE")
    local victoryroad = CanReach("REGION_VICTORY_ROAD:1F:ENTRANCE")

    if (snorlax == AccessibilityLevel.Normal and clear_snorlax())
    or hooh == AccessibilityLevel.Normal
    or (lugia == AccessibilityLevel.Normal and has("SILVER_WING"))
    or suicune == AccessibilityLevel.Normal
    or silvercave == AccessibilityLevel.Normal
    or victoryroad == AccessibilityLevel.Normal then
        return AccessibilityLevel.Normal
    end
    return AccessibilityLevel.SequenceBreak
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

    allChecked = true
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
        letter = string.byte(letter) - string.byte("A") + 1
    end
    
    if not allChecked and not table_contains(CHECKED_SIGNS, sign) then
        return AccessibilityLevel.Inspect
    end
    
    if not UNOWN_DATA[sign] or has("UNOWN_" .. letter) then
        return AccessibilityLevel.Normal
    end
    
    local groupUnlock =
        (letter >= 1  and letter <= 11 and "ENGINE_UNLOCKED_UNOWNS_A_TO_K") or
        (letter >= 12 and letter <= 18 and "ENGINE_UNLOCKED_UNOWNS_L_TO_R") or
        (letter >= 19 and letter <= 23 and "ENGINE_UNLOCKED_UNOWNS_S_TO_W") or
        (letter >= 24 and letter <= 26 and "ENGINE_UNLOCKED_UNOWNS_X_TO_Z")
    
    if groupUnlock and has(groupUnlock) then
        return AccessibilityLevel.Normal
    end
    
    return AccessibilityLevel.None
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
        local newbark = CanReach("REGION_NEW_BARK_TOWN")
        if newbark ~= AccessibilityLevel.None then
            return math.min(newbark, phonecard())
        else
            return phonecard()
        end
    elseif has("randomize_phone_call_items_simple") then
        return phonecard()
    end
    -- randomize_phone_call_items_off: the phone call items are not in the pool at all.
    -- Explicit None rather than falling off the end -- a nil was already treated as None by
    -- PopTracker, but Node:discover logs a warning for every nil a rule returns.
    return AccessibilityLevel.None
end

-- Kanto phone calls only work once the power is back on.
function can_phone_call_power()
    return math.min(phonecall() or AccessibilityLevel.None,
        has("EVENT_RESTORED_POWER_TO_KANTO") and AccessibilityLevel.Normal or AccessibilityLevel.None)
end

function request_pokemon()
    return AccessibilityLevel.Normal
    -- we'll deal with this when people complain.
end

function diplomagoal()
    return CAUGHT_COUNT >= Tracker:FindObjectForCode("diploma_goal_count").AcquiredCount
end

function r12_passage()
    return has("SQUIRTBOTTLE") or has("route_12_access_vanilla") or can_surf_kanto()
end

function alph_passage()
    return (not has("goal_unown") or (has("HO-OH_TILE", 16) or can_strength()))
end

function partial_trainersanity()
    if TRAINERS:getType() == "partial" then
        return true
    else
        return false
    end
end

function r30_passage(direction)
    return
        (direction == "southbound" and has("route_30_battle_north")) or
        can_cut_johto() or
        (has("route_30_access_egg") and has("EVENT_GAVE_MYSTERY_EGG_TO_ELM")) or
        (has("route_30_access_mrpokemon") and has("EVENT_GOT_MYSTERY_EGG_FROM_MR_POKEMON"))
end

function landslide_clear()
    if has("south_kanto_condition_power") and has("EVENT_RESTORED_POWER_TO_KANTO") then
        return AccessibilityLevel.Normal
    elseif has("south_kanto_condition_south") then
        return CanReach("REGION_CINNABAR_ISLAND")
    else
        return AccessibilityLevel.None
    end
end

function landslide_19()
    if has("south_kanto_access_free") or has("south_kanto_access_21") then
        return AccessibilityLevel.Normal
    else
        return landslide_clear()
    end
end

function landslide_21()
    if has("south_kanto_access_free") or has("south_kanto_access_19") then
        return AccessibilityLevel.Normal
    else
        return landslide_clear()
    end
end

function magikarp()
    if has("magikarp") then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.Inspect
    end
end

function mom_saving(number)
    if not (has("EVENT_GAVE_MYSTERY_EGG_TO_ELM") or has("EVENT_MOM_CALLS")) then
        return AccessibilityLevel.None
    end
    local available_gyms = has("johto_only_off") and 16 or 8
    local required = math.min(number - 1, available_gyms)
    if gyms() >= required then
        return AccessibilityLevel.Normal
    else
        return AccessibilityLevel.SequenceBreak
    end
end