-- FlyDestinationItem: one read-only display item per fly unlock, badged with the region its fly
-- currently lands in (set from slot_data in onClear via FLY_DESTINATIONS). No click handlers --
-- the destination is fixed by the seed and the player cannot change it, just like a revealed
-- entrance. The town icon is reused from the flyunlock art; the badge is the destination name.
--
-- Items are created lazily (only when fly destinations are randomized) to match the entrance
-- items' perf pattern. Each provides only its own "flydest_<token>" code (PotentialCodes), so it
-- adds no cost to unrelated logic lookups.

FLY_DESTINATION_ITEMS = {}

FlyDestinationItem = CustomItem:extend()

function FlyDestinationItem:init(token)
    self:createItem("Fly " .. token, {"flydest_" .. token})
    self.token = token
    self.overlay = FLY_ICON_OVERLAYS[token]
    self:refresh()
end

-- Shown until a slot with fly-destination data is connected (FLY_DESTINATIONS is empty).
FLY_DESTINATION_PLACEHOLDER = "Connect to a slot..."
-- Leading pad so the left-aligned badge clears the town icon instead of overlapping it.
local FLY_BADGE_INDENT = "            "

--- Re-read this fly's destination and redraw icon + badge.
function FlyDestinationItem:refresh()
    local inst = self.ItemInstance
    inst.Icon = ImageReference:FromPackRelativePath("images/items/flyunlocks/flyunlock.png")
    if self.overlay then
        inst.IconMods = "overlay|" .. self.overlay
    end
    local dest = FLY_DESTINATIONS[self.token]
    local index = FLY_TOKEN_INDEX[self.token]
    inst.Name = index and ("Fly Unlock " .. index) or ("Fly " .. self.token)
    -- Trailing newline makes the (vertically centered) overlay a line taller, nudging the visible text up.
    inst.BadgeText = FLY_BADGE_INDENT .. (index and (index .. ": ") or "")
        .. (dest and FlyRegionPrettyName(dest) or FLY_DESTINATION_PLACEHOLDER) .. "\n"
    inst.BadgeTextColor = "#abcdef"
    inst:SetOverlayBackground("")
    inst:SetOverlayFontSize(11)
    inst:SetOverlayAlign("left")
end

function FlyDestinationItem:canProvideCode(code)
    return code == "flydest_" .. self.token
end

--- Display-only: never contributes to logic.
function FlyDestinationItem:providesCode(code)
    return 0
end

--- Instantiate the fly-destination display items once (idempotent); refresh existing ones.
--- Called from onClear when fly destinations are randomized.
function createFlyDestinationItems()
    for _, token in ipairs(FLY_REGION_TOKENS) do
        if not FLY_DESTINATION_ITEMS[token] then
            FLY_DESTINATION_ITEMS[token] = FlyDestinationItem(token)
        else
            FLY_DESTINATION_ITEMS[token]:refresh()
        end
    end
end
