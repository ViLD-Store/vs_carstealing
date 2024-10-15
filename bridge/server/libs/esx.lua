if GetFramework() ~= 'ESX' then
    return
end

local LocalCore = {
    GetId = function(src)
        return ESX.GetPlayerFromId(src)
    end,
    MakeItem = function(item, cb)
        ESX.RegisterUsableItem(item, function(source)
            cb(source)
        end)
    end,
    GiveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        Player.addInventoryItem(item, amount)
    end,
    RegisterCallback = function(name, cb)
        ESX.RegisterServerCallback(name, cb)
    end,
    RemoveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        Player.removeInventoryItem(item, amount)
    end,
    GiveMoney = function(source, type, amount)
        local Player = Core.GetId(tonumber(source))
        if type == 'bank' then
            Player.addMoney(tonumber(amount))
        else
            Player.addAccountMoney(type, tonumber(amount))
        end
    end,
    HaveItem = function(source, item)
        local Player = Core.GetId(tonumber(source))
        local item = Player.getInventoryItem(item)
        if item ~= nil then
            return item.count
        else
            return 0
        end
    end,
    PlayersWithJob = function(jobName)
        local jobCount = 0
        for _, player in pairs(ESX.GetExtendedPlayers()) do
            local job = player.getJob()
            if job.name == jobName then
                jobCount = jobCount + 1
            end
        end
        return jobCount
    end,
    Notification = function(source, message, type)
        if not type then type = 'success' end
        TriggerClientEvent('esx:showNotification', source, message)
    end,
}

for k, v in pairs(LocalCore) do
    Core[k] = v
end