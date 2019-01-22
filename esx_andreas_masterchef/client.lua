local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local menuIsShowed 				 = false
local hasEnteredMarker 	         = false
local isInMarker 		         = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



AddEventHandler('esx_andreas_chef:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

--------------------------- CREATE MARKERS -----------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZonesSize.x, Config.ZonesSize.y, Config.ZonesSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local coords         = GetEntityCoords(GetPlayerPed(-1))
		isInMarker = false
		local currentZone    = nil
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.ZonesSize.x / 2) then
				isInMarker  = true
				SetTextComponentFormat('STRING')
				AddTextComponentString('Tryck på ~INPUT_CONTEXT~ för att laga mat')
				DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInMarker and not hasEnteredMarker then
			hasEnteredMarker = true
		end
		if not isInMarker and hasEnteredMarker then
			hasEnteredMarker = false
			TriggerEvent('esx_andreas_chef:hasExitedMarker')
		end
	end
end)


--------------------------------- KEY CONTROLS -------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(10)
		if IsControlJustReleased(0, Keys['E']) and isInMarker and not menuIsShowed then
			OpenChefMenu()
		end
	end
end)

------------------------------------FOODS ------------------------------------

RegisterNetEvent('esx_andreas_chef:cookHamburger')
AddEventHandler('esx_andreas_chef:cookHamburger', function()
    local playerPed = PlayerPedId()
  
    ESX.TriggerServerCallback('esx_andreas_chef:checkHamburger', function(hasItem)
        if hasItem then
            TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BBQ", 0, false)
            Citizen.Wait(Config.TimeToCook)
            TriggerServerEvent('esx_andreas_chef:cookHamburger')
            ClearPedTasksImmediately(playerPed)
        else
            ESX.ShowNotification('Du har inte ingredienserna som behövs')
        end
    end)
end)

RegisterNetEvent('esx_andreas_chef:cookSteak')
AddEventHandler('esx_andreas_chef:cookSteak', function()
	local playerPed = PlayerPedId()
	
	ESX.TriggerServerCallback('esx_andreas_chef:checkSteak', function(hasItem)
		if hasItem then
			TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BBQ", 0, false)
			Citizen.Wait(Config.TimeToCook)
			TriggerServerEvent('esx_andreas_chef:cookSteak')
            ClearPedTasksImmediately(playerPed)
		else
			ESX.ShowNotification('Du har inte ingredienserna som behövs')
		end
	end)
end)

RegisterNetEvent('esx_andreas_chef:cookPizza')
AddEventHandler('esx_andreas_chef:cookPizza', function()
    local playerPed = PlayerPedId()

	ESX.TriggerServerCallback('esx_andreas_chef:checkPizza', function(hasItem)
		if hasItem then
			TaskStartScenarioInPlace(GetPlayerPed(-1), "PROP_HUMAN_BBQ", 0, false)
			Citizen.Wait(Config.TimeToCook)
			TriggerServerEvent('esx_andreas_chef:cookPizza')
            ClearPedTasksImmediately(playerPed)
		else
			ESX.ShowNotification('Du har inte ingredienserna som behövs')
		end
	end)
end)
----------------------------------- MENUS -----------------------------------


function OpenChefMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), 'menu_menu',
        {
            title    = 'Maträtter',
            elements = {
				{label = 'Hamburgare', value = 'hamburger'},
                {label = 'Köttbit', value = 'steak'},
                {label = 'Pizza', value = 'pizza'},
            }
        },
        function(data, menu)
            
            if data.current.value == 'hamburger' then
                TriggerEvent('esx_andreas_chef:cookHamburger')
            end

            if data.current.value == 'steak' then
				TriggerEvent('esx_andreas_chef:cookSteak')
			end
			
            if data.current.value == 'pizza' then
				TriggerEvent('esx_andreas_chef:cookPizza')
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end