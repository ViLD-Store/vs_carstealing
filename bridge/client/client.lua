local framework = GetFramework()
local Notification = Config.Bridge.Notification

Core = {
    PlayerData = {},
    TriggerCallback = function(name, cb, ...)
        if framework == 'ESX' then
            ESX.TriggerServerCallback(name, cb, ...)
        elseif framework == 'QB' then
            QBCore.Functions.TriggerCallback(name, cb, ...)
        end
    end,
    Notification = function(message, type)
        if not type then type = 'success' end
        if Notification == 'ESX' then
            ESX.ShowNotification(message, false, true, nil)
        elseif Notification == 'OKOK' then
            exports['okokNotify']:Alert(type, message, 3000, type, false)
        elseif Notification == 'QB' then
            QBCore.Functions.Notify(message, type)
        elseif Notification == 'mythic' then
            exports['mythic_notify']:DoCustomHudText(type, message, 8000, {})
        elseif Notification == 'OX' then
            lib.notify({
                title = 'Notification',
                description = message,
                type = type
            })
        elseif framework == 'STANDALONE' then
            AddTextEntry('cs_lib', message)
            BeginTextCommandThefeedPost('cs_lib')
            EndTextCommandThefeedPostTicker(false, true)
        else
            CustomNotify(type, message)
        end
    end,
    GetJob = function()
        if framework == 'ESX' then
            return ESX.GetPlayerData().job.name
        elseif framework == 'QB' then
            return QBCore.Functions.GetPlayerData().job.name
        elseif framework == 'STANDALONE' then
            return 'STANDALONE'
        end
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
    loadDict = function(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) RequestAnimDict(dict) end
        return dict
    end,
    GetClosestVehicleToPlayer = function(coords, maxDistance, includePlayerVehicle)
        local vehicles = GetGamePool('CVehicle')
        local closestVehicle, closestCoords
        maxDistance = maxDistance or 2.0
    
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
    
            if lib.context == 'server' or not cache.vehicle or vehicle ~= cache.vehicle or includePlayerVehicle then
                local vehicleCoords = GetEntityCoords(vehicle)
                local distance = #(coords - vehicleCoords)
    
                if distance < maxDistance then
                    maxDistance = distance
                    closestVehicle = vehicle
                    closestCoords = vehicleCoords
                end
            end
        end
    
        return closestVehicle, closestCoords
    end,
    GetClosestPed = function(coords, maxDistance)
        local peds = GetGamePool('CPed')
        local closestPed, closestCoords
        maxDistance = maxDistance or 2.0
    
        for i = 1, #peds do
            local ped = peds[i]
    
            if not IsPedAPlayer(ped) then
                local pedCoords = GetEntityCoords(ped)
                local distance = #(coords - pedCoords)
    
                if distance < maxDistance then
                    maxDistance = distance
                    closestPed = ped
                    closestCoords = pedCoords
                end
            end
        end

        return closestPed, closestCoords
    end,
    table_deepclone = function(tbl)
	    tbl = table.clone(tbl)

	    for k, v in pairs(tbl) do
	    	if type(v) == 'table' then
	    		tbl[k] = table_deepclone(v)
	    	end
	    end

	    return tbl
    end
}

function GetLib()
    --GetInvokingResource()
	return Core
end