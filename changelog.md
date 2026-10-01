# CHANGELOG

## New Features
- Support for all the new options
- Submap images for every single area that can have randomised entrances or checks
- Support for ENTRANCE RANDOMISATION:
    - Randomised Entrances will show in the tracker. If it's unlit, you don't know where it leads yet. Walk through it to connect it
    - You can RIGHT-CLICK on an Entrance to have poptracker show you what entrance leads to this entrance
    - You can LEFT-CLICK on an Entrance to have poptracker show you where this entrance leads to
    - In Coupled ER they do the same thing - but super useful in Decoupled ER!
    - **If you DOUBLE-MIDDLE-CLICK on any in logic Entrance it will start ROUTING MODE to that Entrance**
    - Routing Mode is a new tab that tells you which entrances to traverse to get to your destination. Those entrances also blink!
    - Routing Mode is SMARTER than Universal Tracker: it will tell you the shortest path to your destination from your CURRENT POSITION.
    - It also considers whether FLYING or WARPING HOME is faster!!! I AM SO EXCITED ABOUT THIS ONE OK.
- DexSearch: This works differently than the other integrations. You have to own the Pokédex and you have to have seen the Pokémon
    - DexSearch also helps with Request-Pokémon by offering them as a dynamically displayed button
- The "Everstone from Elm" location will now show you which Pokémon your egg hatched to - because you ALWAYS forget
- Lucky Number Show: You can learn about the numbers in the Radio Tower. Then they will automatically show as available once you have done the right trade! Trades do not mark off if you have the obtained Pokémon but didn't do the trade itself when Lucky Number Show is randomized
- During the Unown Hunt goal you can now also see how many Unowns you have SEEN and CAUGHT
- Added a new mode to "Show / Hide Encounters": "Only show Dexsanity-relevant locations"
- CHEESE Mode: Show "yellow" out of logic locations as yellow or red.
- Pokedex In Logic tab: Dynamically shows you which Pokémon you need to evolve or breed for new Dexsanity Checks or new Pokémon you don't own yet
- The entire backend is now using a lua logic graph based on the great work of Stripes007's Alttp pack
- The pack now quietly tracks your HM-Usage-Availability in the background: if you _could_ use a new HM but don't have the right Pokémon for it, it will yell at you! Loudly.
    
## Changes
- All Events and Vanilla Items are now "inverted": They are colorful when uncollected, gray when collected
- Grass Location Images now match the Kanto aesthetic in Kanto [@snowflav-goob]
- Added the two static eggs as proper static locations
- Request Locations now show as "Inspect" until you talked to them to learn what they want (and offer) and then show Red / Green depending on whether you own the Pokémon
- Blue Card is now shown as one item
- All item layouts changed:
    - The "EncEvo"-tab shows all Encounter & Evolution related items.
    - Fly Unlocks now show and track even when Fly Unlocks aren't randomized to indicate where you've been already
    - A new "Goal" section shows all goal-relevant items and events. It takes them out of the event grid when they are goal-relevant.
    - DexSearch and Tools now are tabs you can switch between
    - The Co-Op IDs always show now
    - You can change whether the "Routing Tab" appears over the Overworld image or the submap images
    - Silver Cave has been moved to its own tab
- Added a lot of the more "hidden" events to the event grid
- Added an Event for buying an Escape Rope. Because it legit softlocked some suckers
- Opened Poké Balls and collected Hidden Items are now grayed out
- The Evolutionsanity tab is now called "Detailed" because it's also helpful for randomized Breeding
- You now need poptracker 0.35.4 minimally. A version of poptracker was specifically released for us because we used a fuckton of LuaItems and they were costly before. No longer!
- The Pokedex Overview Image no longer has a black background. The last remnant of the old black layout finally gone.



## Bugfixes
- The Visibility toggle for Grass erronously said Signs [@darvitz]
- Fixed a bug where the Evolutionsanity page only checked for the first item in multi-target evolution Pokémon

## Thank You Section
@Darvitz for a lot of PRs, fixing bugs and adding images.
@Radis7Noir for icons
@snowflav-goob for PRs and images - especially Kanto Grass, and the *shudder* Battle Tower.
@Pain_Seer for some bug fix PRs
@gerbiljames for a couple of bug fix PRs