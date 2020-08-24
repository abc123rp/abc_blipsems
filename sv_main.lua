local emstable = {}
local isCop = false
local _blip = "UNDEFINED"
ESX         = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

TriggerEvent('es:addCommand', 'identifier', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then

	local info = getInfo()
	local id = GetPlayerIdentifier(source, steam)
	local blipname = table.concat(args, " ")

	if info == nil then info = {} end

	if #info > 0 then 
		for k,v in pairs(info) do
			if info[k].steam == id then
				table.remove(info,k)
			end
		end
	end
		 
	   table.insert(info, {
		steam = id,
		blipinfo = blipname
	   })

	SaveResourceFile(GetCurrentResourceName(), "blips.json", json.encode(info), -1)

	end
end)


------------------------------------------------------


RegisterServerEvent('abc_blipsEms:addEmsToTable')
AddEventHandler('abc_blipsEms:addEmsToTable',function()

	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.job.name == 'police' then isCop = true else isCop = false end

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then

		local id = GetPlayerIdentifier(source, steam)
		local i = GetPlayerName(source)

		local info = getInfo()
		
		if  #emstable > 0 then
		
			for k,v in pairs(emstable) do
				if emstable[k].i == i then
					table.remove(emstable,k)
					
				end
			end
		end
		
		if info ~= nil then	
			for a,b in pairs(info) do
				if info[a].steam == id and info[a].blipinfo ~= nil then
					table.insert(emstable, {
						i = i,
						_blip = info[a].blipinfo,
						drawBlips = true,
						isCop = isCop
					})
				end
			end
			showblips = true
			TriggerClientEvent('abc_blipsEms:updateEms',-1,emstable,i,showblips)
		end
	end
end)


RegisterServerEvent('abc_blipsEms:removeEmsFromTable')
AddEventHandler('abc_blipsEms:removeEmsFromTable',function()

	local i = GetPlayerName(source)	

	for k,v in pairs(emstable) do
		if emstable[k].i == i then
			table.remove(emstable,k)
		end
	end
		showblips = false
		TriggerClientEvent('abc_blipsEms:updateEms',-1,emstable,i,showblips)
end)



---------------------------------------------------------------------------------

AddEventHandler("playerDropped", function()
	local i = GetPlayerName(source)	

	for k,v in pairs(emstable) do
		if emstable[k].i == i then
			table.remove(emstable,k)
		end
	end
		showblips = false
		TriggerClientEvent('abc_blipsEms:updateEms',-1,emstable,i,showblips)
end)

---------------------------------------------------------------------------------

TriggerEvent('es:addCommand', 'blipOFF', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

		local i = GetPlayerName(source)	
		
		for k,v in pairs(emstable) do
			if emstable[k].i == i then
				emstable[k].drawBlips = false
			end
		end
		
		showblips = false
		TriggerClientEvent('abc_blipsEms:updateEms',-1,emstable,i,showblips)
	
end)

TriggerEvent('es:addCommand', 'blipON', function(source, args, user)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'police' then isCop = true else isCop = false end

	if xPlayer.job.name == 'police' or xPlayer.job.name == 'ambulance' then

		local id = GetPlayerIdentifier(source, steam)
		local i = GetPlayerName(source)
	
		local info = getInfo()
		
		if  #emstable > 0 then
			for k,v in pairs(emstable) do
				if emstable[k].i == i then
					table.remove(emstable,k)
				end
			end
		end
		
		if info ~= nil then	
			for a,b in pairs(info) do
				if info[a].steam == id and info[a].blipinfo ~= nil then
					table.insert(emstable, {
						i = i,
						_blip = info[a].blipinfo,
						drawBlips = true,
						isCop = isCop
					})
				end
			end
			showblips = true
			TriggerClientEvent('abc_blipsEms:updateEms',-1,emstable,i,showblips)
		end
	end
end)

--- FUNÇÃO LEITURA DOCUMENTO ----
function getInfo()
	local file = LoadResourceFile(GetCurrentResourceName(), "./blips.json")
	local info = json.decode(file)
	return(info)
end