CeruleanCaveRequirement = CustomItem:extend()

function CeruleanCaveRequirement:init()
    self:createItem("Cerulean Cave Requirement - Vanilla")
    self.code = "cerulean_cave_requirement"
    self.type = "vanilla"
    self:setStage(8)
    self.stageCount = 8
    self:updateIcon()
end

function CeruleanCaveRequirement:setType(type)
    self:setProperty("type", type)
end

function CeruleanCaveRequirement:getType()
    return self:getProperty("type")
end

function CeruleanCaveRequirement:setStage(stage)
    self:setProperty("stage", stage)
end

function CeruleanCaveRequirement:getStage()
    return self:getProperty("stage")
end

function CeruleanCaveRequirement:updateIcon()
    local stage = self:getStage()
    local type = self:getType()
    local img = ""
    local img_mod = ""
    if type == "vanilla" then
        self.ItemInstance.Name = "Cerulean Cave Requirement - Vanilla"
        img = "images/settings/rival_celio.png"
    elseif type == "champion" then
        self.ItemInstance.Name = "Cerulean Cave Requirement - Champion"
        img = "images/settings/rival.png"
    elseif type == "network_machine" then
        self.ItemInstance.Name = "Cerulean Cave Requirement - Restore Network Machine"
        img = "images/settings/celio.png"
    elseif type == "badges" then
        self.ItemInstance.Name = "Cerulean Cave Requirement - Badges"
        img = "images/settings/badge.png"
    elseif type == "gyms" then
        self.ItemInstance.Name = "Cerulean Cave Requirement - Gyms"
        img = "images/settings/gym.png"
    end
    if self:getType() == "badges" or self:getType() == "gyms" then
        img_mod = "overlay|images/overlays/long_count_numbers/" .. math.floor(stage) .. ".png"
    end
    self.ItemInstance.Icon = ImageReference:FromPackRelativePath(img)
    self.ItemInstance.IconMods = ImageReference:FromPackRelativePath(img_mod)
end

function CeruleanCaveRequirement:onLeftClick()
    if self:getType() == "badges" or self:getType() == "gyms" then
        if self:getStage() < self.stageCount then
            self:setStage(self:getStage() + 1)
        elseif self:getStage() == self.stageCount then
            self:setStage(0)
        end
    end
end

function CeruleanCaveRequirement:onRightClick()
    if self:getType() == "vanilla" then
        self:setType("champion")
    elseif self:getType() == "champion" then
        self:setType("network_machine")
    elseif self:getType() == "network_machine" then
        self:setType("badges")
    elseif self:getType() == "badges" then
        self:setType("gyms")
    elseif self:getType() == "gyms" then
        self:setType("vanilla")
    end
end

function CeruleanCaveRequirement:canProvideCode(code)
    if self.code == code then
        return true
    end
    return false
end

function CeruleanCaveRequirement:providesCode(code)
    if self:canProvideCode(code) then
        if self:getType() == "vanilla" then
            if has("defeat_champion") and has("restore_pokemon_network_machine") then
                return 1
            end
        elseif self:getType() == "champion" then
            if has("defeat_champion") then
                return 1
            end
        elseif self:getType() == "network_machine" then
            if has("restore_pokemon_network_machine") then
                return 1
            end
        elseif self:getType() == "badges" or self:getType() == "gyms" then
            local req_items = {}
            local count = 0
            if self:getType() == "badges" then
                req_items = BADGES
            elseif self:getType() == "gyms" then
                req_items = GYMS
            end
            for _, item in pairs(req_items) do
                if has(item) then
                    count = count + 1
                end
                if count >= self:getStage() then
                    return 1
                end
            end
        end
    end
    return 0
end

function CeruleanCaveRequirement:save()
    local save_data = {}
    save_data["type"] = self:getType()
    save_data["stage"] = self:getStage()
    return save_data
end

function CeruleanCaveRequirement:load(data)
    if data["type"] ~= nil then
        self:setType(data["type"])
    end
    if data["stage"] ~= nil then
        self:setStage(data["stage"])
    end
    self:updateIcon()
    return true
end

function CeruleanCaveRequirement:propertyChanged(key, value)
    if TRACKER_READY then
        if key == "type" or key == "stage" then
            self:updateIcon()
        end
    end
end
