ESX = exports["es_extended"]:getSharedObject()

local Cooldown = "00:00"
RegisterNetEvent('esx:playerLoaded', function()
    ESX.TriggerServerCallback("kael-cooldown:server:getconfig", function(newconfig)
        Config = newconfig
    end)
end)

RegisterNetEvent("kael-cooldown:client:updateconfig", function(newconfig)
    Config = newconfig
end)

CreateThread(function()
    while true do 
        if Config.CurrentCooldown > 0 then 
            local seconds = Config.CurrentCooldown
            local mins = string.format("%02.f", math.floor(seconds/60));
            local secs = string.format("%02.f", math.floor(seconds - mins *60));
            Cooldown = mins..":"..secs
            Config.CurrentCooldown = Config.CurrentCooldown - 1
        end
        SendNUIMessage({
            action = "showstatus",
            type = Config.CurrentType,
            active = Config.Types[Config.CurrentType],
            cooldown = Cooldown,
        })
        Wait(1000)
    end
end)

RegisterNUICallback("setprio", function(data)
    SetNuiFocus(false, false)
    TriggerServerEvent("kael-cooldown:server:setprio", data.ptype)
end)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
end)

RegisterCommand("prio", function()
    local PlayerJob = ESX.PlayerData.job.name
    if PlayerJob == "police" then 
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "openlist",
            list = Config.Types,
            active = Config.CurrentType,
            name = ESX.PlayerData.firstName .. " " .. ESX.PlayerData.lastName,
        })
    else
        ESX.ShowNotification("Not Authorized!")
    end  
end)