local QBCore = exports['qb-core']:GetCoreObject()


RegisterNetEvent('rw-rental:server:rentVehicle')
AddEventHandler('rw-rental:server:rentVehicle', function(vehicleHash, vehiclePrice)
  local _source = source
  local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney("bank", vehiclePrice, _source, "rent-deposit")
    TriggerClientEvent("QBCore:Notify", _source, "Du betalte" .. vehiclePrice .. " kr", "success")
end)
