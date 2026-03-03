TrainersanityNumber = CustomItem:extend()

function TrainersanityNumber:init()
    self:createItem("Trainersanity - Full")
    self.code = "trainersanity"
    self.type = "full"
    self:setStage(340)
    self.baseImage = "images/settings/trainersanity.png"
    self.stageCount = 340
    self:updateIcon()
end

function TrainersanityNumber:setType(type)
    self:setProperty("type", type)
end

function TrainersanityNumber:getType()
    return self:getProperty("type")
end

function TrainersanityNumber:setStage(stage)
    self:setProperty("stage", stage)
end

function TrainersanityNumber:getStage()
    return self:getProperty("stage")
end

function TrainersanityNumber:updateIcon()
    local stage = self:getStage()
    local type = self:getType()
    local overlayImg = ""
    local img_mod = ""
    if type == "none" then
        self.ItemInstance.Name = "Trainersanity - None"
        overlayImg = "images/settings/trainersanity_none_overlay.png"
    elseif type == "partial" then
        self.ItemInstance.Name = "Trainersanity - Partial"
        overlayImg = "images/settings/trainersanity_partial_overlay.png"
    elseif type == "full" then
        self.ItemInstance.Name = "Trainersanity - Full"
        overlayImg = "images/settings/trainersanity_full_overlay.png"
    end
    if self:getType() == "partial" then
        self.ItemInstance:SetOverlay(tostring(math.floor(stage)))
    else
        self.ItemInstance:SetOverlay("")
    end
    self.ItemInstance.Icon = self.baseImage
    self.ItemInstance.IconMods = "overlay|" .. overlayImg
    self.ItemInstance:SetOverlayBackground("202020")
end

function TrainersanityNumber:onLeftClick()
    if self:getType() == "partial" then
        if self:getStage() < self.stageCount then
            self:setStage(self:getStage() + 1)
        elseif self:getStage() == self.stageCount then
            self:setStage(0)
        end
    end
end

function TrainersanityNumber:onRightClick()
    if self:getType() == "none" then
        self:setType("partial")
    elseif self:getType() == "partial" then
        self:setType("full")
    elseif self:getType() == "full" then
        self:setType("none")
    end
end

function TrainersanityNumber:canProvideCode(code)
    if self.code == code then
        return true
    end
    return false
end

function TrainersanityNumber:providesCode(code)
    if self:canProvideCode(code) then
        if self:getType() == "full" then
            return 1
        end
    end
    return 0
end

function TrainersanityNumber:save()
    local save_data = {}
    save_data["type"] = self:getType()
    save_data["stage"] = self:getStage()
    return save_data
end

function TrainersanityNumber:load(data)
    if data["type"] ~= nil then
        self:setType(data["type"])
    end
    if data["stage"] ~= nil then
        self:setStage(data["stage"])
    end
    self:updateIcon()
    return true
end

function TrainersanityNumber:propertyChanged(key, value)
    --if TRACKER_READY then
        if key == "type" or key == "stage" then
            self:updateIcon()
        end
    --end
end
