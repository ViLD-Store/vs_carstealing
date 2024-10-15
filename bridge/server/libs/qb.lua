if GetFramework() ~= 'QB' then
    return
end

local LocalCore = {
    GetId = function(src)
        return QBCore.Functions.GetPlayer(src)
    end,
    MakeItem = function(item, cb)
        QBCore.Functions.CreateUseableItem(item, function(source, item)
            local Player = QBCore.Functions.GetPlayer(source)
            if not Player.Functions.GetItemByName(item.name) then return end
                cb(source)
        end)
    end,
    GiveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        Player.Functions.AddItem(item, amount)
    end,
    RegisterCallback = function(name, cb)
        QBCore.Functions.CreateCallback(name, cb)
    end,
    RemoveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        Player.Functions.RemoveItem(item, amount)
    end,
    GiveMoney = function(source, type, amount)
        local Player = Core.GetId(tonumber(source))
        Player.Functions.AddMoney(type, tonumber(amount))
    end,
    HaveItem = function(source, item)
        local Player = Core.GetId(tonumber(source))
        local item = Player.Functions.GetItemByName(item)
        if GetResourceState('ox_inventory') == 'started' then
            return item?.count or 0
        else
            return item?.amount or 0
        end
    end,
    PlayersWithJob = function(jobName)
        local jobCount = 0
        for _, players in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(players)
            local job = player.PlayerData.job
            if job.name == jobName then
                jobCount = jobCount + 1
            end
        end
        return jobCount
    end,
    Notification = function(source, message, type)
        if not type then type = 'success' end
        TriggerClientEvent('QBCore:Notify', source, message)
    end,
}

for k, v in pairs(LocalCore) do
    Core[k] = v
end