local SendNUIMessage = SendNUIMessage
local GetEntityCoords = GetEntityCoords
local DoesEntityExist = DoesEntityExist

local visibleOptions = {}
local optionsFunctions = {}
local isDisabled = false
local optionsForId = {}
local optionsFunctions = {}
local interactOptions = {}
local utils = {}

local function tableType(table)
    for k, v in pairs(table) do
        if type(k) == 'string' then
            return 'object'
        elseif type(k) == 'number' then
            return 'array'
        end
    end
end

utils.isPlayerInJob = function(job)
    local playerJob = Core.GetJob()
    if type(job) == 'string' then
        if playerJob.name == job then
            return true
        end
    elseif type(job) == 'table' then
        local table = tableType(job)
        if table == 'object' then
            if job[playerJob.name] and tonumber(playerJob.grade) >= job[playerJob.name] then
                return true
            end
        elseif table == 'array' then
            for i = 1, #job, 1 do
                if job[i] == playerJob.name then
                    return true
                end
            end
        end
    end

    return false
end

utils.canInteract = function()
    local playerPed = PlayerPedId()
    return not LocalPlayer.state.isDead and not LocalPlayer.state.isCuffed
end

local function hideInteract(id)
    if visibleOptions[id] then
        SendNUIMessage({action = 'HideInteract', id = id})
        visibleOptions[id] = nil
    end
    optionsForId[id] = nil
end

function addPedModelInteract(data)
    if not data.options or not data.model then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        icon = data.icon or nil,
        distance = data.distance or 1.75,
        model = data.model,
        type = 'pedModel',
        options = data.options
    }
    return interactId
end

exports('addPedModelInteract', addPedModelInteract)

function addPedInteract(data)
    if not data.options then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        icon = data.icon or nil,
        distance = data.distance or 1.75,
        type = 'globalPed',
        options = data.options
    }
    return interactId
end

exports('addPedInteract', addPedInteract)

function addVehicleInteract(data)
    if not data.options then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        icon = data.icon or nil,
        distance = data.distance or 1.75,
        type = 'globalVehicle',
        options = data.options
    }
    return interactId
end

exports('addVehicleInteract', addVehicleInteract)

function addInteract(data)
    if not data.options then
        return
    end

    if not data.coords and not data.entity then
        return
    end

    local interactId <const> = (#interactOptions + 1)
    interactOptions[interactId] = {
        icon = data.icon or nil,
        coords = data.coords or nil,
        entity = data.entity or nil,
        distance = data.distance or 1.75,
        options = data.options
    }
    return interactId
end

exports('addInteract', addInteract)

local function removeInteract(id)
    if not interactOptions[id] then
        print(('Attempt to remove not existing option %s'):format(id))
    end

    hideInteract(id)
    table.remove(interactOptions, id)
end

exports('removeInteract', removeInteract)

local function disableInteract(bool)
    isDisabled = bool
end

exports('disableInteract', disableInteract)

RegisterCommand('interact_select', function()
    for id, type in pairs(visibleOptions) do
        if type == 'all' then
            SendNUIMessage({action = 'SelectInteract', id = id})
            break
        end
    end
end)

RegisterCommand('interact_use', function()
    for id, type in pairs(visibleOptions) do
        if type == 'all' then
            SendNUIMessage({action = 'UseInteract', id = id})
            break
        end
    end
end)

RegisterNUICallback('UseInteract', function(data)
    if data.type == 'function' then
        local itemId = data.itemId
        local optionId = tonumber(data.optionId + 1)
        optionsFunctions[itemId][optionId]()
    elseif data.type == 'serverEvent' then
        TriggerServerEvent(data.event, data.args)
    elseif data.type == 'command' then
        ExecuteCommand(data.command)
    elseif data.type == 'event' then
        TriggerEvent(data.event, data.args)
    end
end)

RegisterKeyMapping('interact_use', 'Zatwierdź opcje', 'keyboard', 'E')

RegisterKeyMapping('interact_select', 'Zmień opcje', 'keyboard', 'DOWN')

Citizen.CreateThread(function()
    while true do
        local sleep = 1500
        if not isDisabled and utils.canInteract() then
            local plyCoords = GetEntityCoords(PlayerPedId())
            local screenX, screenY = GetActiveScreenResolution()
            for i = 1, #interactOptions, 1 do
                local item = interactOptions[i]
                if item.entity then
                    item.coords = DoesEntityExist(item.entity) and GetEntityCoords(item.entity) or nil
                end

                if item.type then
                    if item.type == 'globalPed' then
                        local ped, pedCoords = Core.GetClosestPed(plyCoords, item.distance or 2.5)
                        if ped and ped ~= 0 then
                            item.coords = pedCoords
                        else
                            item.coords = nil
                            hideInteract(i)
                        end
                    elseif item.type == 'globalVehicle' then
                        local vehicle, vehCoords = Core.GetClosestVehicleToPlayer(plyCoords, item.distance or 3.5, true)
                        if vehicle and vehicle ~= 0 then
                            item.coords = vector3(vehCoords.x, vehCoords.y, vehCoords.z + 0.75)
                        else
                            item.coords = nil
                            hideInteract(i)
                        end
                    end
                end
    
                if item.coords then
                    local dist = #(plyCoords - item.coords)
                    sleep = dist <= (item.distance * 1.5) and 500 or dist <= (item.distance * 2.5) and 1000 or 1250

                    if dist <= item.distance and not IsPauseMenuActive() then
                        
                        local state = visibleOptions[i]
                        local onscreen, x, y = GetScreenCoordFromWorldCoord(item.coords.x, item.coords.y, item.coords.z)
                        if onscreen and x and y then

                            sleep = 10
                            local posX = (x * screenX)
                            local posY = (y * screenY)

                            local sortedItems = {}
                            if optionsForId[i] then
                                sortedItems = optionsForId[i]
                            else
                                if not optionsFunctions[i] then
                                    optionsFunctions[i] = {}
                                end

                                for j = 1, #item.options, 1 do
                                    local option = item.options[j]
                                    if option.canInteract and option.canInteract(item.entity or 0) then
                                        print(option.canInteract(item.entity or 0))
                                        if option.job and utils.isPlayerInJob(option.job) then
                                            sortedItems[j] = Core.table_deepclone(option)
                                            sortedItems[j].canInteract = nil
                                            if sortedItems[j].onSelect then
                                                optionsFunctions[i][j] = sortedItems[j].onSelect
                                                sortedItems[j].onSelect = nil
                                            end
                                        elseif not option.job then
                                            sortedItems[j] = Core.table_deepclone(option)
                                            sortedItems[j].canInteract = nil
                                            if sortedItems[j].onSelect then
                                                optionsFunctions[i][j] = sortedItems[j].onSelect
                                                sortedItems[j].onSelect = nil
                                            end
                                        end
                                    elseif not option.canInteract then
                                        if option.job and utils.isPlayerInJob(option.job) then
                                            sortedItems[j] = Core.table_deepclone(option)
                                            sortedItems[j].canInteract = nil
                                            if sortedItems[j].onSelect then
                                                optionsFunctions[i][j] = sortedItems[j].onSelect
                                                sortedItems[j].onSelect = nil
                                            end
                                        elseif not option.job then
                                            sortedItems[j] = Core.table_deepclone(option)
                                            sortedItems[j].canInteract = nil
                                            if sortedItems[j].onSelect then
                                                optionsFunctions[i][j] = sortedItems[j].onSelect
                                                sortedItems[j].onSelect = nil
                                            end
                                        end
                                    end
                                end
                                optionsForId[i] = sortedItems
                            end
                            if #sortedItems > 0 then
                                if dist <= 0.9 then
                                    if (not state or state == 'circle') then
                                        visibleOptions[i] = 'all'
                                        SendNUIMessage({
                                            action = 'ShowInteract', type = 'all', id = i, options = sortedItems,
                                            position = {
                                                left = posX,
                                                top = posY,
                                                scale = scale
                                            }
                                        })
                                    else
                                        SendNUIMessage({
                                            action = 'UpdateInteract',
                                            id = i,
                                            left = posX,
                                            top = posY,
                                            scale = scale
                                        })
                                    end
                                elseif dist > 0.9 then
                                    if (not state or state == 'all') then
                                        visibleOptions[i] = 'circle'
                                        SendNUIMessage({
                                            action = 'ShowInteract', type = 'circle', id = i,
                                            icon = item.icon,
                                            position = {
                                                left = posX,
                                                top = posY,
                                                scale = scale
                                            }
                                        })
                                    else
                                        SendNUIMessage({
                                            action = 'UpdateInteract',
                                            id = i,
                                            left = posX,
                                            top = posY,
                                            scale = scale
                                        })
                                    end
                                end
                            else
                                hideInteract(i)
                            end
                        else
                            hideInteract(i)
                        end
                    else
                        hideInteract(i)
                    end
                end
            end
        else
            for k, v in pairs(visibleOptions) do
                hideInteract(k)
            end
        end
        Wait(sleep)
    end
end)
