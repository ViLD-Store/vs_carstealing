Core = GetLib()

RegisterServerEvent('vs_carstealing:scanner')
AddEventHandler('vs_carstealing:scanner', function(scannera)
	if scannera then
        Core.GiveItem(source, 'weapon_digiscanner', 1)
    else
        local reward = math.random(Config.Payment.min, Config.Payment.max)
        Core.GiveMoney(source, Config.Payment.type, reward)
        Core.Notification(source, Core.ReplaceString(Config.Language[Config.Lang].RewardInfo, "{REWARD}", reward))
        Core.RemoveItem(source, 'weapon_digiscanner', 1)
    end
end)

RegisterServerEvent('vs_carstealing:SendToPolice')
AddEventHandler('vs_carstealing:SendToPolice', function(veh, torf)
	TriggerClientEvent('vs_carstealing:PDTracker', -1, veh, torf)
    AlertPD(veh, torf)
end)

Core.RegisterCallback('vs_carstealing:getpd', function(source, cb)
    local policeCount = Core.PlayersWithJob(Config.PoliceJob)
    cb(policeCount)
end)