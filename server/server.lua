Core = GetLib()

RegisterServerEvent('vs_carstealing:scanner')
AddEventHandler('vs_carstealing:scanner', function(scannera)
	if scannera then
        if not Config.Item.UseItem then
            Core.GiveItem(source, 'weapon_digiscanner', 1)
        end
    else
        local reward = math.random(Config.Payment.min, Config.Payment.max)
        Core.GiveMoney(source, Config.Payment.type, reward)
        Core.Notification(source, Core.ReplaceString(Config.Language[Config.Lang].RewardInfo, "{REWARD}", reward))
        if Config.Item.UseItem then
            if Config.Item.DeleteItem then
                Core.RemoveItem(source, 'weapon_digiscanner', 1)
            end
        else
            Core.RemoveItem(source, 'weapon_digiscanner', 1)
        end
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

Core.RegisterCallback('vs_carstealing:checkitem', function(source, cb)
    local HaveItemIn = Core.HaveItem(source, 'weapon_digiscanner')
    print(HaveItemIn)
    if Config.Item.UseItem then
        if HaveItemIn > 0 then
            cb(true)
        else
            cb(false)
        end
    else
        cb(true)
    end
end)

Citizen.CreateThread(function()
    local resourceName = GetCurrentResourceName()
    
    local function printVILDHeader()
        print([[
            
██╗   ██╗██╗██╗     ██████╗ 
██║   ██║██║██║     ██╔══██╗
██║   ██║██║██║     ██║  ██║
╚██╗ ██╔╝██║██║     ██║  ██║
 ╚████╔╝ ██║███████╗██████╔╝
  ╚═══╝  ╚═╝╚══════╝╚═════╝]])
    end

    -- Function to check version
    local function checkVersion()
        PerformHttpRequest("https://api.vildstore.com/api/getversion/"..GetCurrentResourceName(), function(err, responseText, headers)

            -- Parse the JSON response
            local responseData = json.decode(responseText)

            if not responseData then
                print("Error: Unable to parse version information.")
                return
            end

            local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')

            if not curVersion then
                print("Error: 'version' file not found in the resource root.")
                return
            end

            -- Display the version information
            printVILDHeader()

            -- Check and compare versions
            if curVersion ~= responseData.version and curVersion < responseData.version then
                print(GetCurrentResourceName() .. " is outdated!")
                print("Latest version: " .. responseData.version)
                print("Current version: " .. curVersion)
                print("Update notes: " .. responseData.update)
            else
                print(GetCurrentResourceName() .. " is up to date. Have fun!")
            end
        end, "GET")
    end

    -- Call the checkVersion function to start the process
    checkVersion()
end)
