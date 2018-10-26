RegisterServerEvent('getLastServer')
AddEventHandler('getLastServer', function(id)
    local src = source
    TriggerClientEvent('getLastClient', -1, id, GetPlayerName(src))
end)

AddEventHandler('playerDropped', function(source, disconnectReason)
    local src = source
    print(GetPlayerName(src))
    TriggerClientEvent('deleteLastVehicles', src, GetPlayerName(src))
end)