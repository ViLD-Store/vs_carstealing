local framework = GetFramework()
local Notification = Config.Bridge.Notification
Core = {
    GetId = function(src)
        if framework == 'ESX' then
            return ESX.GetPlayerFromId(src)
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayer(src)
        end
    end,
    MakeItem = function(item, cb)
        if framework == 'QB' then
            QBCore.Functions.CreateUseableItem(item, function(source, item)
                local Player = QBCore.Functions.GetPlayer(source)
                if not Player.Functions.GetItemByName(item.name) then return end
                    cb(source)
            end)
        elseif framework == 'ESX' then
            ESX.RegisterUsableItem(item, function(source)
                cb(source)
            end)
        end
    end,
    GiveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            Player.addInventoryItem(item, amount)
        elseif framework == 'QB' then
            Player.Functions.AddItem(item, amount)
        end
    end,
    RegisterCallback = function(name, cb)
        if ESX ~= nil then 
            ESX.RegisterServerCallback(name, cb)
        elseif QBCore ~= nil then
            QBCore.Functions.CreateCallback(name, cb)
        end
    end,
    ReplaceString = function(main_text, replace, replaceto)
        return string.gsub(main_text, replace, replaceto)
    end,
    RemoveItem = function(source, item, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            Player.removeInventoryItem(item, amount)
        elseif framework == 'QB' then
            Player.Functions.RemoveItem(item, amount)
        end
    end,
    Notification = function(source, message, type)
        if not type then type = 'success' end
        if Notification == 'ESX' then
            TriggerClientEvent('esx:showNotification', source, message)
        elseif Notification == 'OKOK' then
            TriggerClientEvent('okokNotify:Alert', source, type, message, 3000, type, false)
        elseif Notification == 'mythic' then 
            exports['mythic_notify']:DoCustomHudText(type, message, 3000, type)
        elseif Notification == 'QB' then
            TriggerClientEvent('QBCore:Notify', source, message)
        elseif Notification == 'OX' then
            TriggerClientEvent('ox_lib:notify', source, {description = message, type = type})
        else
            CustomNotifyServer(type, message)
        end
    end,
    GiveMoney = function(source, type, amount)
        local Player = Core.GetId(tonumber(source))
        if framework == 'ESX' then
            if type == 'bank' then
                Player.addMoney(tonumber(amount))
            else
                Player.addAccountMoney(type, tonumber(amount))
            end
        elseif framework == 'QB' then
            Player.Functions.AddMoney(type, tonumber(amount))
        end
    end,
    PlayersWithJob = function(jobName)
        local jobCount = 0
        if framework == 'ESX' then
            for _, player in pairs(ESX.GetExtendedPlayers()) do
                local job = player.getJob()
                if job.name == jobName then
                    jobCount = jobCount + 1
                end
            end
        elseif framework == 'QB' then
            for _, players in pairs(QBCore.Functions.GetPlayers()) do
                local player = QBCore.Functions.GetPlayer(players)
                local job = player.PlayerData.job
                if job.name == jobName then
                    jobCount = jobCount + 1
                end
            end
        end
        return jobCount
    end,
    Debug = function(o)
        if type(o) == 'table' then
            local s = '{ '
            for k,v in pairs(o) do
               if type(k) ~= 'number' then k = '"'..k..'"' end
               s = s .. '['..k..'] = ' .. Core.Debug(v) .. ','
            end
            return s .. '} '
         else
            return tostring(o)
         end
    end,
}

function GetLib()
	return Core
end