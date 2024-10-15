if GetFramework() ~= 'ESX' then
    return
end

local LocalCore = {
    TriggerCallback = function(name, cb, ...)
        ESX.TriggerServerCallback(name, cb, ...)
    end,
    GetJob = function()
        return ESX.GetPlayerData().job.name
    end,
    Notification = function(message, type)
        if not type then type = 'success' end
        ESX.ShowNotification(message, false, true, nil)
    end,
}

for k, v in pairs(LocalCore) do
    Core[k] = v
end