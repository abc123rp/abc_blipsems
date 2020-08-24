local blips = {}
local PlayerData                = {}
local GUI                       = {}
local sData 					= false
local playerCanSee 				= false
local PlayerData                = {}
ESX                             = nil
local isCop                     = false

Citizen.CreateThread(function()
  while ESX == nil do
   TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(1)
  end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	  PlayerData = xPlayer
	  if (PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and (sData == false ) then
		TriggerServerEvent('abc_blipsEms:addEmsToTable')
		sData = true
	end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	 PlayerData.job = job
	 if (PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and (sData == false ) then
		TriggerServerEvent('abc_blipsEms:addEmsToTable')
		sData = true
	end

	if (PlayerData.job ~= nil and PlayerData.job.name == 'offpolice' or PlayerData.job ~= nil and PlayerData.job.name == 'offambulance') and sData then

		TriggerServerEvent('abc_blipsEms:removeEmsFromTable')
		sData = false
	end
end)

RegisterNetEvent('abc_blipsEms:updateEms')
AddEventHandler('abc_blipsEms:updateEms',function(emstable,name,showblips)
	if name == GetPlayerName(PlayerId()) and (showblips == true) then

		playerCanSee = true

	elseif name ==  GetPlayerName(PlayerId()) and (showblips == false) then

			playerCanSee = false
	end
	
	if (PlayerData.job ~= nil and PlayerData.job.name == 'offpolice' or PlayerData.job ~= nil and PlayerData.job.name == 'offambulance') or (playerCanSee == false) then
		for i,player in ipairs(GetActivePlayers()) do
			RemoveBlip(blips[i])
		end
	end

	if	(PlayerData.job ~= nil and PlayerData.job.name == 'police' or PlayerData.job ~= nil and PlayerData.job.name == 'ambulance') and playerCanSee then
	
		for i,player in ipairs(GetActivePlayers()) do
			RemoveBlip(blips[i])
		end
		for i,player in ipairs(GetActivePlayers()) do
			for k,v in pairs(emstable) do
				local playerPed = GetPlayerPed(player)
				local playerName = GetPlayerName(player)
				if playerName == emstable[k].i and emstable[k].drawBlips then
					local blip = AddBlipForEntity(playerPed)
					BeginTextCommandSetBlipName("STRING");
					AddTextComponentString(emstable[k]._blip);
					EndTextCommandSetBlipName(blip);
					SetBlipCategory(blip, emstable[k].isCop and 4 or 5) 
					Citizen.InvokeNative(0x5FBCA48327B914DF, blip, true)
					SetBlipColour(blip, emstable[k].isCop and 57 or 59)
					SetBlipScale(blip, 0.85)
					blips[k] = blip
				--	Citizen.InvokeNative(0xBFEFE3321A3F5015, playerPed, playerName, false, false, '', false)
				end
			end
		end
	end
end)
