Route22AccessRequirement = CustomItem:extend()

function Route22AccessRequirement:init()
    self.code = "route_22_access"
    self:createItem("Route 22 Access - Wake up Snorlax", {self.code})
    self.type = "snorlax"
    self:setStage(8)
    self.baseImage = "images/settings/route_22_access.png"
    self.stageCount = 16
    self:updateIcon()
end

function Route22AccessRequirement:setType(type)
    self:setProperty("type", type)
end

function Route22AccessRequirement:getType()
    return self:getProperty("type")
end

function Route22AccessRequirement:setStage(stage)
    self:setProperty("stage", stage)
end

function Route22AccessRequirement:getStage()
    return self:getProperty("stage")
end

function Route22AccessRequirement:updateIcon()
    local stage = self:getStage()
    local type = self:getType()
    local overlayImg = ""
    local img_mod = ""
    if type == "snorlax" then
        self.ItemInstance.Name = "Route 22 Access - Wake up Snorlax"
        overlayImg = "images/settings/route_22_access_snorlax_overlay.png"
    elseif type == "badges" then
        self.ItemInstance.Name = "Route 22 Access - Obtain Badges"
        overlayImg = "images/settings/route_22_access_badges_overlay.png"
    elseif type == "gyms" then
        self.ItemInstance.Name = "Route 22 Access - Defeat Gyms"
        overlayImg = "images/settings/gym_overlay_left.png"
    elseif type == "champion" then
        self.ItemInstance.Name = "Route 22 Access - Become Champion"
        overlayImg = "images/settings/route_22_access_champion_overlay.png"
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

function Route22AccessRequirement:onLeftClick()
    if self:getType() == "badges" or self:getType() == "gyms" then
        if self:getStage() < self.stageCount then
            self:setStage(self:getStage() + 1)
        elseif self:getStage() == self.stageCount then
            self:setStage(0)
        end
    end
end

function Route22AccessRequirement:onRightClick()
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

function Route22AccessRequirement:canProvideCode(code)
    if self.code == code then
        return true
    end
    return false
end

function Route22AccessRequirement:providesCode(code)
    if self:canProvideCode(code) then
        if self:getType() == "snorlax" then
            if clear_snorlax() == true then
                return 1
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

function Route22AccessRequirement:save()
    local save_data = {}
    save_data["type"] = self:getType()
    save_data["stage"] = self:getStage()
    return save_data
end

function Route22AccessRequirement:load(data)
    if data["type"] ~= nil then
        self:setType(data["type"])
    end
    if data["stage"] ~= nil then
        self:setStage(data["stage"])
    end
    self:updateIcon()
    return true
end

function Route22AccessRequirement:propertyChanged(key, value)
    --if TRACKER_READY then
        if key == "type" or key == "stage" then
            self:updateIcon()
        end
    --end
end
