HIDE_CLEARED_CODE = "hide_cleared"

local toggle
local sections = {}

function uncleared(path, ...)
    toggle = toggle or Tracker:FindObjectForCode(HIDE_CLEARED_CODE)
    if toggle.CurrentStage == 0 then
        return AccessibilityLevel.Normal
    end
    local section = sections[path]
    if not section then
        section = Tracker:FindObjectForCode("@"..path)
        sections[path] = section
    end
    if section.AvailableChestCount > 0 then
        return AccessibilityLevel.Normal
    end
    for i = 1, select("#", ...) do
        if Tracker:ProviderCountForCode((select(i, ...))) == 0 then
            return AccessibilityLevel.Normal
        end
    end
    return AccessibilityLevel.None
end
