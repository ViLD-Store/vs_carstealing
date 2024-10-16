Core = GetLib()
local cooldown = false
local sellingcar = false
local spawnedPed
local spawned_car
local BlipForCar
local spawnedPedd
CarCoords = vec3(0,0,0)

CreateThread(function()
    local model = Config.Stealing_Cars.Ped.Ped
    RequestModel(model)
	while not HasModelLoaded(model) do
		Citizen.Wait(50)
	end
    spawnedPed = CreatePed(0, model, Config.Stealing_Cars.Ped.Loc.x, Config.Stealing_Cars.Ped.Loc.y, Config.Stealing_Cars.Ped.Loc.z-0.99, Config.Stealing_Cars.Ped.Loc.w, false, true)

    if Config.UseInteract then
        exports.vs_interactions:addLocalEntity({
            entity = spawnedPed,
            icon = "fa-solid fa-user-ninja",
            distance = 2.0,
            options = {
                {
                    label = Config.Language[Config.Lang].TakeMission,
                    type = 'function',
                    icon = 'fa-solid fa-location-dot',
                    onSelect = function()  
                        Core.TriggerCallback('vs_carstealing:checkitem', function(data) 
                            if data then
                                Core.TriggerCallback('vs_carstealing:getpd', function(data) 
                                    if data >= Config.PoliceJobs then
                                        local RandomLocal = math.random(0,#Config.Stealing_Cars.CarLocalisations)
                                        cooldown = true
                                        Core.Notification(Config.Language[Config.Lang].GoAndFind)
                                        TriggerServerEvent('vs_carstealing:scanner', true)
                                        local Randomscanner_local = math.random(0,#Config.Stealing_Cars.CarLocalisations[RandomLocal].scanner_local)
                                        SetupScanner(Config.Stealing_Cars.CarLocalisations[RandomLocal].scanner_local[Randomscanner_local], RandomLocal)
                                    else
                                        Core.Notification(Config.Language[Config.Lang].NoMuchPd)
                                    end
                                end)
                            else
                                Core.Notification(Config.Language[Config.Lang].NoItem)
                            end
                        end)
                    end,
                    canInteract = function()
                        if not cooldown then
                            return true
                        end
            
                        return false
                    end
                },
            }
        })
    else
        exports.ox_target:addLocalEntity(spawnedPed, {
            {
                icon = "fa-solid fa-user-ninja",
                label = Config.Language[Config.Lang].TakeMission,
                onSelect = function()    
                    Core.TriggerCallback('vs_carstealing:checkitem', function(data) 
                        if data then
                            Core.TriggerCallback('vs_carstealing:getpd', function(data) 
                                if data >= Config.PoliceJobs then
                                    local RandomLocal = math.random(0,#Config.Stealing_Cars.CarLocalisations)
                                    cooldown = true
                                    Core.Notification(Config.Language[Config.Lang].GoAndFind)
                                    TriggerServerEvent('vs_carstealing:scanner', true)
                                    local Randomscanner_local = math.random(0,#Config.Stealing_Cars.CarLocalisations[RandomLocal].scanner_local)
                                    SetupScanner(Config.Stealing_Cars.CarLocalisations[RandomLocal].scanner_local[Randomscanner_local], RandomLocal)
                                else
                                    Core.Notification(Config.Language[Config.Lang].NoMuchPd)
                                end
                            end)
                        else
                            Core.Notification(Config.Language[Config.Lang].NoItem)
                        end
                    end)
                end,
                distance = 2.0,
                canInteract = function(entity)
                    if not cooldown then
                        return true
                    end
        
                    return false
                end
            }
        })
    end

    SetAmbientVoiceName(spawnedPed, 'AMMUCITY') -- Sets Voice Type
    FreezeEntityPosition(spawnedPed, true)
    SetBlockingOfNonTemporaryEvents(spawnedPed, true)
    SetEntityInvincible(spawnedPed, true)
    RequestAnimDict(Config.Stealing_Cars.Ped.Animation.dict)
    while (not HasAnimDictLoaded(Config.Stealing_Cars.Ped.Animation.dict)) do Citizen.Wait(0) end
    TaskPlayAnim(spawnedPed,Config.Stealing_Cars.Ped.Animation.dict,Config.Stealing_Cars.Ped.Animation.lib,1.0,-1.0, -1, 1, 1, true, true, true)
end)

function SetupScanner(vec, rmd)
    local RandomLocal = math.random(1,#Config.Stealing_Cars.VehList)
    local ModelHash = Config.Stealing_Cars.VehList[RandomLocal]
    
    if not IsModelInCdimage(ModelHash) then return end
        RequestModel(ModelHash) -- Request the model
        while not HasModelLoaded(ModelHash) do -- Waits for the model to load
        Wait(0)
    end
    CarCoords = Config.Stealing_Cars.CarLocalisations[rmd].veh_location
    spawned_car = CreateVehicle(GetHashKey(ModelHash), Config.Stealing_Cars.CarLocalisations[rmd].veh_location, Config.Stealing_Cars.CarLocalisations[rmd].heading, true, false)
    SetVehicleOnGroundProperly(spawned_car)
    SetVehicleFixed(spawned_car)
    SetVehicleDeformationFixed(spawned_car)
    SetVehicleEngineOn(spawned_car, false, false)
    SetVehicleDoorsLocked(spawned_car, 2)
    SetModelAsNoLongerNeeded(ModelHash)

    SetupDigiScanner(vec, {
        event = FoundX,
        isAction = true,
        args = {},
        blip = {
            text = Config.Language[Config.Lang].BlipName,
            sprite = 9,
            display = 2,
            scale = Config.Stealing_Cars.Blip.Scale,
            color = 2,
            opacity = 65,
        },
        interact = {
            interactKey = 38,
            interactMessage = Config.Language[Config.Lang].OpenMinigame,
        }
    })
end

function FoundX()
    StartMinigame(function(success)
        if success then
            SetNuiFocus(false, false)
            Core.Notification(Config.Language[Config.Lang].SuccessOpen)
            SetVehicleDoorsLocked(spawned_car, 0)
            Citizen.Wait(Config.Wait.Found)
            TriggerServerEvent('vs_carstealing:SendToPolice', spawned_car, true)
            Citizen.Wait(Config.Wait.WhenPlayerCanGoSell)
            TriggerEvent('vs_carstealing:rmblip')
            SellVehicle()
        else
            SetNuiFocus(false, false)
            Core.Notification(Config.Language[Config.Lang].LostGame)
            Citizen.Wait(Config.Wait.Found)
            TriggerServerEvent('vs_carstealing:SendToPolice', spawned_car, true)
        end
    end, Config.Bridge.MiniGame)
end

function SellVehicle()
    -- Generate a random location for car deposit
    local RandomLocal = math.random(0,#Config.Stealing_Cars.CarDeposit)
    local carDepositLocation = Config.Stealing_Cars.CarDeposit[RandomLocal]

    -- Add a blip for the Car Buyer
    local carBuyerBlip = AddBlipForCoord(carDepositLocation.x, carDepositLocation.y, carDepositLocation.z)
    SetBlipSprite(carBuyerBlip, 225)  -- Set an appropriate icon for the car buyer
    SetBlipColour(carBuyerBlip, 1)    -- You can set the color here (1 = red, you can change this)
    SetBlipScale(carBuyerBlip, 0.8)   -- Adjust blip size
    SetBlipAsShortRange(carBuyerBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Language[Config.Lang].CarBuy)
    EndTextCommandSetBlipName(carBuyerBlip)

    -- Set new waypoint to the car deposit location
    SetNewWaypoint(carDepositLocation.x, carDepositLocation.y)

    -- Ped model and animation
    local model = Config.Stealing_Cars.Ped.Ped
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(50)
    end

    sellingcar = true

    -- Create ped at the car deposit location
    spawnedPedd = CreatePed(0, model, carDepositLocation.x, carDepositLocation.y, carDepositLocation.z-0.99, carDepositLocation.w, false, true)
    SetAmbientVoiceName(spawnedPedd, 'AMMUCITY') -- Sets Voice Type
    FreezeEntityPosition(spawnedPedd, true)
    SetBlockingOfNonTemporaryEvents(spawnedPedd, true)
    SetEntityInvincible(spawnedPedd, true)

    -- Request and play the animation
    RequestAnimDict(Config.Stealing_Cars.Ped.Animation.dict)
    while not HasAnimDictLoaded(Config.Stealing_Cars.Ped.Animation.dict) do 
        Citizen.Wait(0) 
    end
    TaskPlayAnim(spawnedPedd, Config.Stealing_Cars.Ped.Animation.dict, Config.Stealing_Cars.Ped.Animation.lib, 1.0, -1.0, -1, 1, 1, true, true, true)

    if Config.UseInteract then
        exports.vs_interactions:addLocalEntity({
            entity = spawnedPedd,
            icon = "fa-solid fa-user-ninja",
            distance = 2.0,
            options = {
                {
                    label = Config.Language[Config.Lang].SellCar,
                    type = 'function',
                    icon = 'fa-solid fa-location-dot',
                    onSelect = function()    
                        TriggerServerEvent('vs_carstealing:scanner', false)
                        Citizen.Wait(1000)

                        -- Remove the blip after interaction
                        if DoesBlipExist(carBuyerBlip) then
                            RemoveBlip(carBuyerBlip)
                        end

                        FreezeEntityPosition(spawnedPedd, false)
                        SetBlockingOfNonTemporaryEvents(spawnedPedd, false)
                        SetEntityInvincible(spawnedPedd, false)
                        TaskVehicleDriveWander(spawnedPedd, spawned_car, 60.0, 316)
                        sellingcar = false
                        RemoveCoolDown()
                    end,
                    canInteract = function()
                        if cooldown and sellingcar then
                            return true
                        end
                        return false
                    end
                },
            }
        })
    else
        exports.ox_target:addLocalEntity(spawnedPedd, {
            {
                icon = "fa-solid fa-user-ninja",
                label = Config.Language[Config.Lang].SellCar,
                onSelect = function()
                    TriggerServerEvent('vs_carstealing:scanner', false)
                    Citizen.Wait(1000)

                    -- Remove the blip after interaction
                    if DoesBlipExist(carBuyerBlip) then
                        RemoveBlip(carBuyerBlip)
                    end

                    FreezeEntityPosition(spawnedPedd, false)
                    SetBlockingOfNonTemporaryEvents(spawnedPedd, false)
                    SetEntityInvincible(spawnedPedd, false)
                    TaskVehicleDriveWander(spawnedPedd, spawned_car, 60.0, 316)
                    sellingcar = false
                    RemoveCoolDown()
                end,
                distance = 2.0,
                canInteract = function(entity)
                    if cooldown and sellingcar then
                        return true
                    end
                    return false
                end
            }
        })
    end
end

function RemoveCoolDown()
    Citizen.Wait(Config.Wait.Cooldown)
    cooldown = false
    sellingcar = false
end

RegisterNetEvent('vs_carstealing:PDTracker', function(ped_thing, addorremove)
    if Core.GetJob() == Config.PoliceJob then
        BlipForCar = AddBlipForEntity(ped_thing)
        SetBlipSprite(BlipForCar, 56)
        SetBlipDisplay(BlipForCar, 56)
        SetBlipScale(BlipForCar, 1.0)
        SetBlipColour(BlipForCar, 60)
        SetBlipAsShortRange(BlipForCar, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(Config.Language[Config.Lang].Blip)
        EndTextCommandSetBlipName(BlipForCar)
        Citizen.Wait(Config.Wait.WhenPlayerCanGoSell)
        RemoveBlip(BlipForCar)
    end
end)