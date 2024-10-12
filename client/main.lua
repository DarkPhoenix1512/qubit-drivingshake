local lastDamage = 0.0
local vehicle = nil
local minSpeed = 5.0
local shakeIntensityDriver = 0.2
local shakeIntensityPassenger = 0.1

Citizen.CreateThread(function()
    local sleep = 1000
    while true do
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed) then
            sleep = 100
            vehicle = GetVehiclePedIsIn(playerPed, false)
            local shakeRate = GetEntitySpeed(vehicle)
            local curHealth = GetVehicleBodyHealth(vehicle)
            
            if curHealth ~= lastDamage and shakeRate > minSpeed then
                local intensity = (shakeRate - minSpeed) / 200.0
                intensity = math.min(intensity, shakeIntensityDriver)
                
                ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", intensity)

                for i = 0, GetVehicleMaxNumberOfPassengers(vehicle) - 1 do
                    local passengerPed = GetPedInVehicleSeat(vehicle, i)
                    if passengerPed and passengerPed ~= 0 then
                        local passengerIntensity = intensity * (shakeIntensityPassenger / shakeIntensityDriver)
                        ShakeGameplayCam("SMALL_EXPLOSION_SHAKE", passengerIntensity)
                    end
                end
            end
            
            lastDamage = curHealth
        else
            sleep = 1000
        end
        Citizen.Wait(sleep)
    end
end)
