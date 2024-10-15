if GetFramework() ~= 'QBOX' then
    return
end

local LocalCore = {
    TriggerCallback = function(name, cb, ...)
        QBCore.Functions.TriggerCallback(name, cb, ...) 
    end,
    GetJob = function()
        return exports['qbx_core']:GetPlayerData().job.name 
    end,
    Notification = function(message, type)
        if not type then type = 'success' end
        exports['qbx_core']:Notify(message, type) 
    end,
}

for k, v in pairs(LocalCore) do
    Core[k] = v
end