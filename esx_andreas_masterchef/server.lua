TriggerEvent('esx:getSharedObject', function(obj)
	ESX = obj
end)


---------------------- HAMBURGER ----------------------

RegisterServerEvent('esx_andreas_chef:cookHamburger')
AddEventHandler('esx_andreas_chef:cookHamburger', function()

	local xPlayer = ESX.GetPlayerFromId(source)
    local meat = xPlayer.getInventoryItem('meat').count
    local bread = xPlayer.getInventoryItem('bread').count
    local dressing = xPlayer.getInventoryItem('dressing').count

    if meat > 0 and bread > 0 and dressing > 0 then
        xPlayer.removeInventoryItem('meat', 1)
        xPlayer.removeInventoryItem('bread', 1)
        xPlayer.removeInventoryItem('dressing', 1)
        xPlayer.addInventoryItem('hamburger', 1)
    end
end)

ESX.RegisterServerCallback('esx_andreas_chef:checkHamburger', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local meat = xPlayer.getInventoryItem('meat').count
    local bread = xPlayer.getInventoryItem('bread').count
    local dressing = xPlayer.getInventoryItem('dressing').count
   
    if meat and bread and dressing > 0 then
        cb(true)
    else
        cb(false)
    end
end)

------------------------ MEAT ---------------------

RegisterServerEvent('esx_andreas_chef:cookSteak')
AddEventHandler('esx_andreas_chef:cookSteak', function()

	local xPlayer = ESX.GetPlayerFromId(source)
    local meat = xPlayer.getInventoryItem('meat').count
    local marinade = xPlayer.getInventoryItem('marinade').count
    local butter = xPlayer.getInventoryItem('butter').count

    if meat > 0 and marinade > 0 and butter > 0 then
        xPlayer.removeInventoryItem('meat', 1)
        xPlayer.removeInventoryItem('marinade', 1)
        xPlayer.removeInventoryItem('butter', 1)
        xPlayer.addInventoryItem('steak', 1)
    end
end)

ESX.RegisterServerCallback('esx_andreas_chef:checkSteak', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local meat = xPlayer.getInventoryItem('meat').count
    local marinade = xPlayer.getInventoryItem('marinade').count
    local butter = xPlayer.getInventoryItem('butter').count
   
    if meat and marinade and butter > 0 then
        cb(true)
    else
        cb(false)
    end
end)

----------------------- PIZZA -------------------

RegisterServerEvent('esx_andreas_chef:cookPizza')
AddEventHandler('esx_andreas_chef:cookPizza', function()

	local xPlayer = ESX.GetPlayerFromId(source)
    local bread = xPlayer.getInventoryItem('bread').count
    local ham = xPlayer.getInventoryItem('ham').count
    local cheese = xPlayer.getInventoryItem('cheese').count
    local tomato = xPlayer.getInventoryItem('tomato').count

    if bread > 0 and ham > 0 and cheese > 0 and tomato > 0 then
        xPlayer.removeInventoryItem('bread', 1)
        xPlayer.removeInventoryItem('ham', 1)
        xPlayer.removeInventoryItem('cheese', 1)
        xPlayer.removeInventoryItem('tomato', 1)
        xPlayer.addInventoryItem('pizza', 1)
    end
end)

ESX.RegisterServerCallback('esx_andreas_chef:checkPizza', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local bread = xPlayer.getInventoryItem('bread').count
    local ham = xPlayer.getInventoryItem('ham').count
    local cheese = xPlayer.getInventoryItem('cheese').count
   
    if bread and ham and cheese > 0 then
        cb(true)
    else
        cb(false)
    end
end)



function notification(text)
	TriggerClientEvent('esx:showNotification', source, text)
end