local QBCore = exports['qb-core']:GetCoreObject()

local display = false
local isRenting = false

local currentVehicle = nil




-- Send the vehicle data to the NUI
function SendVehiclesToNUI()
    SetNuiFocus(true, true)
    SendNUIMessage({
        type = "setVehicles",
        vehicles = Config.Vehicles
    })
end

-- Toggle display function
function SetDisplay(_display)
    display = _display
    SetNuiFocus(display, display)
    SendNUIMessage({
        type = "setDisplay",
        value = display
    })

    -- Send the vehicle data when the display is shown
    if display then
        SendVehiclesToNUI()
    end
end

RegisterNUICallback('close', function(data, cb)
    SetDisplay(false)
    cb('ok')
end)

-- Add a command to show the display for testing purposes
RegisterCommand("showdisp", function()
    SetDisplay(not display)
end, false)

RegisterNUICallback('rent', function(data, cb)
    print(data.vehicleHash, data.vehiclePrice)
    TriggerEvent('rw-rental:client:rent', data)
    SetDisplay(false)
    cb('ok')
end)


RegisterNetEvent('rw-rental:client:rent')
AddEventHandler('rw-rental:client:rent', function(data)
    local vehicle = data.vehicleHash
    local price = data.vehiclePrice
    local coords = Config.CarSpawn[1]

    TriggerServerEvent('rw-rental:server:rentVehicle', vehicle, price)
    QBCore.Functions.SpawnVehicle(vehicle, function(veh)
        SetVehicleNumberPlateText(veh, "LEIEBIL"..tostring(math.random(1000, 9999)))
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)     
end)


RegisterNetEvent('rw-rental:client:openMenu')
AddEventHandler('rw-rental:client:openMenu', function()
    SetDisplay(true)
end)


-- Target para alugar veiculo
CreateThread(function()
    exports['qb-target']:AddTargetModel(`a_f_m_fatcult_01`, {
        options = {
        {
            type = "client",
            event = "rw-rental:client:openMenu",
            icon = 'fas fa-clipboard',
            label = 'Lei bil av Laila Toril',
        },
        {
            type = "client",
            event = "rw-rental:client:deliverVehicle",
            icon = 'fas fa-clipboard',
            label = 'Lever tilbake bil',
        }
      },
      distance = 2.5,
    })
end)

Citizen.CreateThread(function()
    for i=1, #Config.PedSpawn do
      local pedModel = "a_f_m_fatcult_01"
      local pedName = "Laila Toril"
      local pedCoords = Config.PedSpawn[i]
      local pedHeading = pedCoords.w
      local pedHash = GetHashKey(pedModel)
  
      RequestModel(pedHash)
      while not HasModelLoaded(pedHash) do
        Wait(1)
      end
      
      local ped = CreatePed(4, pedHash, pedCoords.x, pedCoords.y, pedCoords.z, pedHeading, false, true)
      Wait(1000)
      SetEntityAsMissionEntity(ped, true, true)
      SetEntityInvincible(ped, true)
      SetBlockingOfNonTemporaryEvents(ped, true)
      FreezeEntityPosition(ped, true)
      TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE_UPRIGHT", 0, true)
      SetModelAsNoLongerNeeded(pedHash)
    end
  end)
  



-- Lever tilbake bilen
RegisterNetEvent('rw-rental:client:deliverVehicle')
AddEventHandler('rw-rental:client:deliverVehicle', function()
    QBCore.Functions.Notify('Kjøretøyet har blitt levert tilbake!', 'success', 2000)
    local car = GetVehiclePedIsIn(PlayerPedId(),true)
    DeleteVehicle(car)
    DeleteEntity(car)
end)

-- Blip
Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.PedSpawn[1])
	SetBlipSprite(blip, 326) 
	SetBlipDisplay(blip, 4)
	SetBlipScale(blip, 0.7)
	SetBlipAsShortRange(blip, true)
	SetBlipColour(blip, 2)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentSubstringPlayerName("Molde Bilutleie") 
    EndTextCommandSetBlipName(blip)
end)
