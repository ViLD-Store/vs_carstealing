Core = {
    PlayerData = {},
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
    end,
    Notification = function(message, type)
        AddTextEntry('vild', message)
        BeginTextCommandThefeedPost('vild')
        EndTextCommandThefeedPostTicker(false, true)
    end,
}

function GetLib()
	return Core
end

RegisterNetEvent('custom_notification')
AddEventHandler('custom_notification', function(message, type)
    AddTextEntry('vild', message)
    BeginTextCommandThefeedPost('vild')
    EndTextCommandThefeedPostTicker(false, true)
end)
