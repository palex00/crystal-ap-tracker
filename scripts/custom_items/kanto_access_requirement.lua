KantoAccessRequirement = CustomItem:extend()

function KantoAccessRequirement:init()
    self:createItem("Kanto Access - Wake up Snorlax")
    self.code = "kanto_access_condition"
    self.type = "snorlax"
    self:setStage(8)
    self.baseImage = "images/settings/kanto_access.png"
    self.stageCount = 16
    self:updateIcon()
end

function KantoAccessRequirement:setType(type)
    self:setProperty("type", type)
end

function KantoAccessRequirement:getType()
    return self:getProperty("type")
end

function KantoAccessRequirement:setStage(stage)
    self:setProperty("stage", stage)
end

function KantoAccessRequirement:getStage()
    return self:getProperty("stage")
end

function KantoAccessRequirement:updateIcon()
    local stage = self:getStage()
    local type = self:getType()
    local overlayImg = ""
    local img_mod = ""
    if type == "snorlax" then
        self.ItemInstance.Name = "Kanto Access - Wake up Snorlax"
        overlayImg = "images/settings/kanto_access_snorlax_overlay.png"
    elseif type == "badges" then
        self.ItemInstance.Name = "Kanto Access - Obtain Badges"
        overlayImg = "images/settings/kanto_access_badges_overlay.png"
    elseif type == "gyms" then
        self.ItemInstance.Name = "Kanto Access - Defeat Gyms"
        overlayImg = "images/settings/kanto_access_gyms_overlay.png"
    elseif type == "champion" then
        self.ItemInstance.Name = "Kanto Access - Become Champion"
        overlayImg = "images/settings/kanto_access_champion_overlay.png"
    end
    if self:getType() == "badges" or self:getType() == "gyms" then
        self.ItemInstance:SetOverlay(tostring(math.floor(stage)))
    else
        self.ItemInstance:SetOverlay("")
    end
    self.ItemInstance.Icon = self.baseImage
    self.ItemInstance.IconMods = "overlay|" .. overlayImg
    self.ItemInstance:SetOverlayBackground("202020")
end

function KantoAccessRequirement:onLeftClick()
    if self:getType() == "badges" or self:getType() == "gyms" then
        if self:getStage() < self.stageCount then
            self:setStage(self:getStage() + 1)
        elseif self:getStage() == self.stageCount then
            self:setStage(0)
        end
    end
end

function KantoAccessRequirement:onRightClick()
    if self:getType() == "snorlax" then
        self:setType("badges")
    elseif self:getType() == "badges" then
        self:setType("gyms")
    elseif self:getType() == "gyms" then
        self:setType("champion")
    elseif self:getType() == "champion" then
        self:setType("snorlax")
    end
end

function KantoAccessRequirement:canProvideCode(code)
    if self.code == code then
        return true
    end
    return false
end

function KantoAccessRequirement:providesCode(code)
    if self:canProvideCode(code) then
        if self:getType() == "snorlax" then
            local vermilion = Tracker:FindObjectForCode("@JohtoKanto/Vermilion City").AccessibilityLevel
            if clear_snorlax() == true and vermilion ~= 0 then
                return vermilion
            end
        elseif self:getType() == "champion" then
            if has("EVENT_BEAT_ELITE_FOUR") then
                return 1
            end
        elseif self:getType() == "badges" then
            if badges() >= self:getStage() then
                return 1
            end
        elseif self:getType() == "gyms" then
            if gyms() >= self:getStage() then
                return 1
            end
        end
    end
    return 0
end

function KantoAccessRequirement:save()
    local save_data = {}
    save_data["type"] = self:getType()
    save_data["stage"] = self:getStage()
    return save_data
end

function KantoAccessRequirement:load(data)
    if data["type"] ~= nil then
        self:setType(data["type"])
    end
    if data["stage"] ~= nil then
        self:setStage(data["stage"])
    end
    self:updateIcon()
    return true
end

function KantoAccessRequirement:propertyChanged(key, value)
    --if TRACKER_READY then
        if key == "type" or key == "stage" then
            self:updateIcon()
        end
    --end
end
