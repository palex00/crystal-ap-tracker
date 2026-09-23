REQUEST_ITEMS = {
    { code = "request_trade_kyle",   section = ENCOUNTER_MAPPING["TRADE_KYLE"],   reveal = "TRADE_KYLE",   pokemon = function() return TRADE_DATA["TRADE_KYLE"].requested end },
    { code = "request_trade_mike",   section = ENCOUNTER_MAPPING["TRADE_MIKE"],   reveal = "TRADE_MIKE",   pokemon = function() return TRADE_DATA["TRADE_MIKE"].requested end },
    { code = "request_trade_tim",    section = ENCOUNTER_MAPPING["TRADE_TIM"],    reveal = "TRADE_TIM",    pokemon = function() return TRADE_DATA["TRADE_TIM"].requested end },
    { code = "request_trade_emy",    section = ENCOUNTER_MAPPING["TRADE_EMY"],    reveal = "TRADE_EMY",    pokemon = function() return TRADE_DATA["TRADE_EMY"].requested end },
    { code = "request_trade_chris",  section = ENCOUNTER_MAPPING["TRADE_CHRIS"],  reveal = "TRADE_CHRIS",  pokemon = function() return TRADE_DATA["TRADE_CHRIS"].requested end },
    { code = "request_trade_forest", section = ENCOUNTER_MAPPING["TRADE_FOREST"], reveal = "TRADE_FOREST", pokemon = function() return TRADE_DATA["TRADE_FOREST"].requested end },
    { code = "request_trade_kim",    section = ENCOUNTER_MAPPING["TRADE_KIM"],    reveal = "TRADE_KIM",    pokemon = function() return TRADE_DATA["TRADE_KIM"].requested end },
    { code = "request_grandpa_1", section = LOCATION_MAPPING[522], reveal = nil, pokemon = function() return REQUEST_POKEMON[1] end },
    { code = "request_grandpa_2", section = LOCATION_MAPPING[523], reveal = nil, pokemon = function() return REQUEST_POKEMON[2] end },
    { code = "request_grandpa_3", section = LOCATION_MAPPING[524], reveal = nil, pokemon = function() return REQUEST_POKEMON[3] end },
    { code = "request_grandpa_4", section = LOCATION_MAPPING[525], reveal = nil, pokemon = function() return REQUEST_POKEMON[4] end },
    { code = "request_grandpa_5", section = LOCATION_MAPPING[526], reveal = nil, pokemon = function() return REQUEST_POKEMON[5] end },
    { code = "request_beverly",   section = LOCATION_MAPPING[332], reveal = nil, pokemon = function() return REQUEST_POKEMON[6] end },
    { code = "request_derek",     section = LOCATION_MAPPING[376], reveal = nil, pokemon = function() return REQUEST_POKEMON[7] end },
    { code = "request_tiffany",   section = LOCATION_MAPPING[260], reveal = nil, pokemon = function() return REQUEST_POKEMON[8] end },
}

function revealRequest(request)
    local obj = Tracker:FindObjectForCode(request.code)
    if has(request.reveal) then
        obj.CurrentStage = tonumber(request.pokemon())
    else
        obj.CurrentStage = 0
    end
end

function syncRequests()
    for _, request in ipairs(REQUEST_ITEMS) do
        Tracker:FindObjectForCode(request.code).Active = Tracker:FindObjectForCode(request.section).AvailableChestCount == 0
    end
end

function resetRequests()
    for _, request in ipairs(REQUEST_ITEMS) do
        local obj = Tracker:FindObjectForCode(request.code)
        obj.CurrentStage = 0
        obj.Active = false
    end
end

for _, request in ipairs(REQUEST_ITEMS) do
    if request.reveal then
        ScriptHost:AddWatchForCode("request_" .. request.reveal, request.reveal, function() revealRequest(request) end)
    end
end
