if GetFramework() ~= 'QB' then
    return
end

local LocalCore = {
    TriggerCallback = function(name, cb, ...)
        QBCore.Functions.TriggerCallback(name, cb, ...)
    end,
    GetJob = function()
        return QBCore.Functions.GetPlayerData().job.name
    end,
    Notification = function(message, type)
        if not type then type = 'success' end
        QBCore.Functions.Notify(message, type)
    end,
}

for k, v in pairs(LocalCore) do
    Core[k] = v
end