local vehicles = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        local ped = PlayerPedId()
        if IsPedSittingInAnyVehicle(ped) then
            local vehicle = GetVehiclePedIsIn(ped, true)
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            TriggerServerEvent('getLastServer', id)
        end
    end
end)

RegisterCommand('getlast', function()
    local offset = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 5.0, 0.0)
    local vehicle = GetVehicleInDirection(GetEntityCoords(PlayerPedId()), offset)
    if vehicle and table.empty(vehicles) == false then 
        local id = NetworkGetNetworkIdFromEntity(vehicle)
        TriggerEvent('chatMessage', '', {255, 255, 255}, '^8[CADOJRP]^0 The last person to enter this vehicle was ^3' .. vehicles[id])
    else
        TriggerEvent('chatMessage', '', {255, 255, 255}, '^8[CADOJRP]^0 No vehicle or prior player found!')
    end
end)

RegisterNetEvent('getLastClient')
AddEventHandler('getLastClient', function(id, name)
    vehicles[id] = name
end)

RegisterNetEvent('deleteLastVehicles')
AddEventHandler('deleteLastVehicles', function(name)
    for i, k in pairs(vehicles) do
        if k == name then
            local entity = NetworkGetEntityFromNetworkId(i)
            DeleteEntity(entity)
        end
    end
end)

function GetVehicleInDirection(coordFrom, coordTo)
    local rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    return vehicle
end

function table.empty (self)
    for _, _ in pairs(self) do
        return false
    end
    return true
end