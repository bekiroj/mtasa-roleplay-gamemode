mysql = exports.vrp_mysql

local _setElementData = setElementData
function setElementData(element, data, index)
	return _setElementData(element, data, index)
end

vehicleData = {}

local null = nil
local toLoad = { }
local threads = { }
local syntaxTable = {
	["s"] = "#00a8ff[Valhalla]#ffffff ",
	["e"] = "#e84118[Valhalla]#ffffff ",
	["w"] = "#fbc531[Valhalla]#ffffff ",
}
--local vehicleTempPosList = {}
local variants =
{
	-- [model] = {{first variations}, {second variations}}
	[416] = {{0,1}}, -- Ambulance
	[435] = {{-1,0,1,2,3,4,5}}, -- Trailer
	[450] = {{-1,0}}, -- Trailer 2
	[607] = {{-1,0,1,2}}, -- Baggage Trailer
	[485] = {{-1,0,1,2}}, -- Baggage
	[433] = {{-1,0,1}}, -- Barracks
	[499] = {{-1,0,1,2,3}}, -- Benson
	[581] = {{0,1,2},{3,4}}, -- BF-400
	[424] = {{-1,0}}, -- BF Injection
	[504] = {{0,1,2,3,4,5}}, -- Bloodringx
	[422] = {{-1,0,1}}, -- Bobcat
	[482] = {{-1,0}}, -- Burrito
	[457] = {{-1,0,1,2},{-1,3,4,5}}, -- Caddy
	[483] = {{-1,1}}, -- Camper
	[415] = {{-1,0,1}}, -- Cheetah
	[437] = {{0,1}}, -- Coach
	[472] = {{-1,0,1,2}}, -- Coast Guard
	[521] = {{0,1,2},{3,4}}, -- FCR900
	[407] = {{0,1,2}}, -- Firetruck
	[455] = {{-1,0,1,2}}, -- Flatbed
	[434] = {{-1,0}}, -- Hotknife
	[502] = {{0,1,2,3,4,5}}, -- Hotring A
	[503] = {{0,1,2,3,4,5}}, -- Hotring B
	[571] = {{0}}, -- Kart
	[595] = {{-1,0,1}}, -- Launch
	[484] = {{-1,0}}, -- Marquis
	[500] = {{-1,0,1}}, -- Mesa
	[556] = {{-1,0,1,2}}, -- Monster A
	[557] = {{-1,1}}, -- Monster B
	[423] = {{-1,0,1}}, -- Mr. Whoopee
	[414] = {{-1,0,1,2,3}}, -- Mule
	[522] = {{0,1,2},{3,4}}, -- NRG-500
	[470] = {{-1,0,1,2}}, -- Patriot
	[404] = {{-1,0}}, -- Perennial
	[600] = {{-1,0,1}}, -- Picador
	[413] = {{-1,0}}, -- Pony
	[453] = {{-1,0,1}}, -- Reefer
	[442] = {{-1,0,1,2}}, -- Romero
	[440] = {{-1,0,1,2,3,4,5}}, -- Rumpo
	[543] = {{-1,0,1,2,3}}, -- Sadler
	[605] = {{-1,0,1,2,3}}, -- Sadler (shit)
	[428] = {{-1,0,1}}, -- Securicar
	[535] = {{0,1}}, -- Slamvan
	[439] = {{-1,0,1,2}}, -- Stallion
	[506] = {{-1,0}}, -- Super GT
	[601] = {{0,1,2,3}}, -- SWAT Van
	[459] = {{-1,0}}, -- ?
	[408] = {{-1,0}}, -- Trashmaster
	[583] = {{-1,0,1}}, -- Tug
	[552] = {{-1,0,1}}, -- Utility Van
	[478] = {{-1,0,1,2}}, -- Walton
	[555] = {{-1,0}}, -- Windsor
	[456] = {{-1,0,1,2,3}}, -- Yankee
	[477] = {{-1,0}}, -- ZR350
}

local function uc(num)
	return num == -1 and 255 or num
end

local function nuc(num)
	return num == 255 and -1 or num
end

function getRandomVariant(model)
	local data = variants[model] or {}
	local first = data[1] or {-1}
	local second = data[2] or {-1}
	
	return uc(first[math.random(1, #first)]), uc(second[math.random(1, #second)])
end

function vehicleDoorState(vehicle,id)
	setVehicleDoorState(vehicle,1,id)
end
addEvent('item-system:setVehicleDoorState',true)
addEventHandler('item-system:setVehicleDoorState',root,vehicleDoorState)

function isValidVariant(model, a, b)
	a,b = nuc(a),nuc(b)
	
	-- Can't have a part double
	if a ~= -1 and a == b then
		return false
	end
	
	local data = variants[model] or {}
	local first = data[1] or {-1}
	local second = data[2] or {-1}
	
	-- check if first variant is okay
	local found = false
	for k, v in ipairs(first) do
		if v == a then
			found = true
			break
		end
	end
	if not found then return false end
	
	-- check if second variant is okay
	for k, v in ipairs(second) do
		if v == b then
			return true
		end
	end
	return false
end

function cabrioletToggleRoof(theVehicle)
	if isCabriolet(theVehicle) then
		local data = g_cabriolet[getElementModel(theVehicle)]
		local currentVariant, currentVariant2 = getVehicleVariant(theVehicle)
		local newVariant
		if(currentVariant == data[1]) then
			newVariant = data[2] --set closed
		else
			newVariant = data[1] --set open
		end
		local engineState = getVehicleEngineState(theVehicle)
		setVehicleVariant(theVehicle,newVariant,255)

		--fix for vehicles auto-starting engine when variant is changed
		setVehicleEngineState(theVehicle, engineState)
	end
end
addEvent("vehicle:toggleRoof", true)
addEventHandler("vehicle:toggleRoof", getRootElement( ), cabrioletToggleRoof)

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

-- WORKAROUND ABIT
function getVehicleName(vehicle)
	return exports.vrp_global:getVehicleName(vehicle)
end

addCommandHandler("toplamvergi", 
	function(thePlayer)
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if theVehicle then
			outputChatBox("[-] #f0f0f0Aracın Toplam Vergisi: $" .. tostring(getElementData(theVehicle, "toplamvergi") or 0), thePlayer, 255, 194, 14, true)
		else
			outputChatBox("[-] #f0f0f0Her hangi bir araçta değilsin.", thePlayer, 255, 0, 15, true)
		end
	end
)

-- /makeveh
function createPermVehicle(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerHeadAdmin(thePlayer) then
		local args = {...}
		if (#args < 7) then
			printMakeVehError(thePlayer, commandName )
		else

			local vehShopData = exports["vrp_vehicle_manager"]:getInfoFromVehShopID(tonumber(args[1]))
			if not vehShopData then
				--outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName )
				return false
			end

			local vehicleID = tonumber(vehShopData.vehmtamodel)
			local col1, col2, userName, factionVehicle, cost, tint

			if not vehicleID then -- vehicle is specified as name
				--outputDebugString("VEHICLE SYSTEM / createPermVehicle / FAILED TO FETCH VEHSHOP DATA")
				printMakeVehError(thePlayer, commandName )
				return false
			end

			col1 = tonumber(args[2])
			col2 = tonumber(args[3])
			userName = args[4]
			factionVehicle = tonumber(args[5])
			cost = tonumber(args[6])
			if cost < 0 then
				cost = tonumber(vehShopData.vehprice)
			end
			tint = tonumber(args[7])

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

			local targetPlayer, username = exports.vrp_global:findPlayerByPartialNick(thePlayer, userName)
			local loadstate = 0
			if targetPlayer then
				local to = nil
				local dbid = getElementData(targetPlayer, "dbid")

				if (factionVehicle==1) then
					factionVehicle = tonumber(getElementData(targetPlayer, "faction"))
					local theTeam = getPlayerTeam(targetPlayer)
					to = theTeam
					loadstate = 1
					if not exports.vrp_global:takeMoney(theTeam, cost) then
						outputChatBox("[MAKEVEH] This faction cannot afford this vehicle.", thePlayer, 255, 128, 128)
						outputChatBox("Your faction cannot afford this vehicle.", targetPlayer, 255, 128, 128)
						return
					end
				else
					factionVehicle = -1
					to = targetPlayer
					if not exports.vrp_global:takeMoney(targetPlayer, cost) then
						outputChatBox("[MAKEVEH] This player cannot afford this vehicle.", thePlayer, 255, 128, 128)
						outputChatBox("You cannot afford this vehicle.", targetPlayer, 255, 128, 128)
						return
					elseif not exports.vrp_global:canPlayerBuyVehicle(targetPlayer) then
						outputChatBox("[MAKEVEH] This player has too many cars.", thePlayer, 255, 128, 128)
						outputChatBox("You have too many cars.", targetPlayer, 255, 128, 128)
						exports.vrp_global:giveMoney(targetPlayer, cost)
						return
					end
				end

					local letter1 = string.char(math.random(65,90))
					local letter2 = string.char(math.random(65,90))
					local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)

				local veh = Vehicle(id, x, y, z, 0, 0, r, plate)
				if not (veh) then
					outputChatBox("#575757Valhalla:#f9f9f9 Hatalı Araç ID'si.", thePlayer, 255, 128, 128, true)
					exports.vrp_global:giveMoney(to, cost)
				else
					setVehicleColor(veh, col1, col2, col1, col2)
					local col =  { getVehicleColor(veh, true) }
					local color1 = toJSON( {col[1], col[2], col[3]} )
					local color2 = toJSON( {col[4], col[5], col[6]} )
					local color3 = toJSON( {col[7], col[8], col[9]} )
					local color4 = toJSON( {col[10], col[11], col[12]} )
					local vehicleName = getVehicleName(veh)
					destroyElement(veh)
					local dimension = getElementDimension(thePlayer)
					local interior = getElementInterior(thePlayer)
					local var1, var2 = exports['vrp_vehicle']:getRandomVariant(id)
					local smallestID = SmallestID()
					dbExec(mysql:getConnection(),"INSERT INTO vehicles SET id='" .. (smallestID) .. "', model='" .. (id) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (r) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (( factionVehicle == -1 and dbid or -1 )) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (r) .. "', locked=1, interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1="..var1..",variant2="..var2..", creationDate=NOW(), createdBy="..getElementData(thePlayer, "account:id")..", `vehicle_shop_id`='"..args[1].."'")
					local insertid = smallestID
					if (insertid) then
						if (factionVehicle==-1) then
							exports.vrp_global:giveItem(targetPlayer, 3, tonumber(insertid))
						end

						local owner = ""
						if factionVehicle == -1 then
							owner = getPlayerName( targetPlayer )
						else
							owner = "Faction #" .. factionVehicle
						end

					
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
						local adminUsername = getElementData(thePlayer, "account:username")
						local adminID = getElementData(thePlayer, "account:id")

					
						if (hiddenAdmin==0) then
							exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " ("..adminUsername..") has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".")
							outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".", targetPlayer, 255, 194, 14)
						else
							exports.vrp_global:sendMessageToAdmins("AdmCmd: A Hidden Admin has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".")
							outputChatBox("A Hidden Admin has spawned a "..vehicleName .. " (ID #" .. insertid .. ") to "..owner.." for $"..cost..".", targetPlayer, 255, 194, 14)
						end
						outputChatBox("[MAKEVEH] "..vehicleName .. " (ID #" .. insertid .. ") successfully spawned to "..owner..".", thePlayer, 89, 158, 255)

						

						reloadVehicle(tonumber(insertid))
					end
				end
			end
		end
	end
end
addCommandHandler("makeveh", createPermVehicle, false, false)

function printMakeVehError(thePlayer, commandName )
	outputChatBox("KULLANIM: /" .. commandName .. " [ID from Veh Lib] [color1] [color2] [Owner] [Faction Vehicle (1/0)] [-1=carshop price] [Tinted Windows] ", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, ownership will be given to the 'owner''s faction.", thePlayer, 255, 194, 14)
	outputChatBox("NOTE: If it is a faction vehicle, the cost is taken from the faction fund, rather than the player.", thePlayer, 255, 194, 14)
end

-- /makecivveh
function createCivilianPermVehicle(thePlayer, commandName, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local args = {...}
		if (#args < 4) then
			outputChatBox("KULLANIM: /" .. commandName .. " [id/name] [color1 (-1 for random)] [color2 (-1 for random)] [Job ID -1 for none]", thePlayer, 255, 194, 14)
		else
			local vehicleID = tonumber(args[1])
			local col1, col2, job

			if not vehicleID then -- vehicle is specified as name
				local vehicleEnd = 1
				repeat
					vehicleID = getVehicleModelFromName(table.concat(args, " ", 1, vehicleEnd))
					vehicleEnd = vehicleEnd + 1
				until vehicleID or vehicleEnd == #args
				if vehicleEnd == #args then
					outputChatBox("Invalid Vehicle Name.", thePlayer, 255, 128, 128)
					return
				else
					col1 = tonumber(args[vehicleEnd])
					col2 = tonumber(args[vehicleEnd + 1])
					job = tonumber(args[vehicleEnd + 2])
				end
			else
				col1 = tonumber(args[2])
				col2 = tonumber(args[3])
				job = tonumber(args[4])
			end

			local id = vehicleID

			local r = getPedRotation(thePlayer)
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
			y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

					local letter1 = string.char(math.random(65,90))
					local letter2 = string.char(math.random(65,90))
					local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)


			local veh = Vehicle(id, x, y, z, 0, 0, r, plate)
			if not (veh) then
				outputChatBox("#575757Valhalla:#f9f9f9 Hatalı Araç ID'si.", thePlayer, 255, 128, 128, true)
			else
				local vehicleName = getVehicleName(veh)
				destroyElement(veh)

				local var1, var2 = exports['vrp_vehicle']:getRandomVariant(id)
				local smallestID = SmallestID()
				local insertid = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id='" .. (smallestID) .. "', job='" .. (job) .. "', model='" .. (args[1]) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='" .. ("0.0") .. "', roty='" .. ("0.0") .. "', rotz='" .. (r) .. "', color1='[ [ 0, 0, 0 ] ]', color2='[ [ 0, 0, 0 ] ]', color3='[ [ 0, 0, 0 ] ]', color4='[ [0, 0, 0] ]', faction='-1', owner='-2', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (r) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "',variant1="..var1..",variant2="..var2..", creationDate=NOW(), createdBy="..getElementData(thePlayer, "account:id").."")
			
				insertid = smallestID
				if (insertid) then
					reloadVehicle(insertid)

					local adminID = getElementData(thePlayer, "account:id")
					local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('"..tostring(insertid).."', '"..commandName.." "..vehicleName.." (job "..job..")', '"..adminID.."')") or false
					if not addLog then
						--outputDebugString("Failed to add vehicle logs.")
					end
				end
							
			
			end
		end
	end
end
addCommandHandler("makecivveh", createCivilianPermVehicle, false, false)

function loadAllVehicles(res)
	
	local vehicleLoadList = {}
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				Async:foreach(res, function(row)
					vehicleData[tonumber(row.id)] = {}
					for key, value in pairs(row) do
						vehicleData[tonumber(row.id)][key] = value
					end
					loadOneVehicle(row.id)
				end)
			end
		end,
	mysql:getConnection(), "SELECT * FROM `vehicles` WHERE deleted=0 ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllVehicles)

function reloadVehicle(id)
	local theVehicle = exports.vrp_pool:getElement("vehicle", tonumber(id))
	if (theVehicle) then
		removeSafe(tonumber(id))
		saveVehicle(theVehicle)
		destroyElement(theVehicle)
	end
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				Async:foreach(res, function(row)
					vehicleData[tonumber(row.id)] = {}
					for key, value in pairs(row) do
						vehicleData[tonumber(row.id)][key] = value
					end
					
					loadOneVehicle(row.id)
				end)
			end
		end,
	mysql:getConnection(), "SELECT * FROM `vehicles` WHERE `id`='"..id.."'")
	return true
end

function loadOneVehicle(id, hasCoroutine, loadDeletedOne)
	local row = vehicleData[tonumber(id)]
	if not row then
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						vehicleData[tonumber(row.id)] = {}
						for key, value in pairs(row) do
							vehicleData[tonumber(row.id)][key] = value
						end
						
						loadOneVehicle(row.id)
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `vehicles` WHERE `id`='"..id.."'")
	
	return
	end
	local var1, var2 = row.variant1, row.variant2
	if not isValidVariant(row.model, var1, var2) then
		var1, var2 = getRandomVariant(row.model)
		dbExec(mysql:getConnection(), "UPDATE vehicles SET variant1 = " .. var1 .. ", variant2 = " .. var2 .. " WHERE id='" .. (id) .. "'")
	end
	local veh = createVehicle(row.model, row.x, row.y, row.z, row.rotx, row.roty, row.rotz, row.plate or "", false, var1, var2)
	if veh then
		setElementData(veh, "dbid", row.id)
		exports["vrp_items"]:loadItems(veh)
		exports.vrp_pool:allocateElement(veh, row.id)
		if row.paintjob ~= 0 then
			setVehiclePaintjob(veh, row.paintjob)
		end

		if row.paintjob_url then
			setElementData(veh, "paintjob:url", row.paintjob_url, true)
		end

	

		local color1 = fromJSON(row.color1)
		local color2 = fromJSON(row.color2)
		local color3 = fromJSON(row.color3)
		local color4 = fromJSON(row.color4)
		setVehicleColor(veh, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])
		-- Set the vehicle armored if it is armored
		if (armoredCars[row.model]) then
			setVehicleDamageProof(veh, true)
		end

		-- Cosmetics
		local upgrades = fromJSON(row["upgrades"])
		for slot, upgrade in ipairs(upgrades) do
			if upgrade and tonumber(upgrade) > 0 then
				addVehicleUpgrade(veh, upgrade)
			end
		end

		local panelStates = fromJSON(row["panelStates"])
		for panel, state in ipairs(panelStates) do
			setVehiclePanelState(veh, panel-1 , tonumber(state) or 0)
		end

		local doorStates = fromJSON(row["doorStates"])
		for door, state in ipairs(panelStates) do
			setVehicleDoorState(veh, door-1, tonumber(state) or 0)
		end
		local faction = fromJSON(row["faction"])
		

		local headlightColors = fromJSON(row["headlights"])
		if headlightColors then
			setVehicleHeadLightColor ( veh, headlightColors[1], headlightColors[2], headlightColors[3])
		end
		setElementData(veh, "headlightcolors", headlightColors, true)

		local wheelStates = fromJSON(row["wheelStates"])
		setVehicleWheelStates(veh, tonumber(wheelStates[1]) , tonumber(wheelStates[2]) , tonumber( wheelStates[3]) , tonumber(wheelStates[4]) )

		-- lock the vehicle if it's locked
		setVehicleLocked(veh, row.owner ~= -1 and row.locked == 1)

		-- set the sirens on if it has some
		setVehicleSirensOn(veh, row.sirens == 1)

		-- job
		if row.job > 0 then
			toggleVehicleRespawn(veh, true)
			setVehicleRespawnDelay(veh, 60000)
			setVehicleIdleRespawnDelay(veh, 15 * 60000)
			setElementData(veh, "job", row.job, true)
		else
			setElementData(veh, "job", 0, true)
		end

		setVehicleRespawnPosition(veh, row.x, row.y, row.z, row.rotx, row.roty, row.rotz)
		setElementData(veh, "respawnposition", {row.x, row.y, row.z, row.rotx, row.roty, row.rotz}, false)

		-- element data
		setElementData(veh, "vehicle_shop_id", row.vehicle_shop_id)
		setElementData(veh, "fuel", row.fuel)
		setElementData(veh, "oldx", row.currx)
		setElementData(veh, "oldy", row.curry)
		setElementData(veh, "oldz", row.currz)
		setElementData(veh, "faction", tonumber(row.faction))
		setElementData(veh, "owner", tonumber(row.owner))
		setElementData(veh, "vehicle:windowstat", 0, true)
		setElementData(veh, "plate", row.plate, true)
		setElementData(veh, "registered", row.registered, true)
		setElementData(veh, "show_plate", row.show_plate, true)
		setElementData(veh, "show_vin", row.show_vin, true)
		setElementData(veh, "description:1", row.description1, true)
		setElementData(veh, "description:2", row.description2, true)
		setElementData(veh, "description:3", row.description3, true)
		setElementData(veh, "description:4", row.description4, true)
		setElementData(veh, "description:5", row.description5, true)
		setElementData(veh, "tuning.neon", row.neon, true)
		setElementData(veh, "toplamvergi", row.vergi, true)
		setElementData(veh, "faizkilidi", row.faizkilidi == 1 and true or false, true)
		setElementData(veh, "ceza", tonumber(row.ceza), true)
		setElementData(veh, "ceza_sebep", row.ceza_sebep, true)
				
		
		if row.lastused_sec ~= nil then
			setElementData(veh, "lastused", row.lastused_sec, true)
		end

		--outputDebugString(tostring(row.owner_last_login))
		if row.owner_last_login ~= nil then
			setElementData(veh, "owner_last_login", row.owner_last_login, true)
		end

		if row.owner > 0 and row.protected_until ~= -1 then
			setElementData(veh, "protected_until", row.protected_until, true)
		end

		local customTextures = fromJSON(row.textures) or {}
		setElementData(veh, "textures", customTextures, true) -- 30/12/14 Exciter
		
		if #customTextures > 0 then
			for somenumber, texture in ipairs(customTextures) do
				exports["vrp_item_texture"]:addTexture(veh, texture[1], texture[2])
			end
		end

		setElementData(veh, "deleted", row.deleted, false)
		setElementData(veh, "chopped", row.chopped, false)
		--setElementData(veh, "note", row.note, true)

		-- impound shizzle
		setElementData(veh, "Impounded", tonumber(row.Impounded), true)
		if tonumber(row.Impounded) > 0 then
			setVehicleDamageProof(veh, true)
			if row.impounder then
				--outputDebugString("set")
				setElementData(veh, "impounder", row.impounder, false, true)
			else
				setElementData(veh, "impounder", 4, false, true) --RT
			end
		end

		--setElementCollisionsEnabled(veh, false)
		
		
		if veh:getData("job") > 0 or veh:getData("faction") then
			setElementDimension(veh, row.currdimension)
			setElementInterior(veh, row.currinterior)

			setElementData(veh, "dimension", row.dimension, false)
			setElementData(veh, "interior", row.interior, false)		
		end
			--[[
			setElementDimension(veh, row.currdimension)
			setElementInterior(veh, row.currinterior)

			setElementData(veh, "dimension", row.dimension, false)
			setElementData(veh, "interior", row.interior, false)		
			--]]
		-- lights
		setVehicleOverrideLights(veh, row.lights == 0 and 1 or row.lights )

		-- engine
		if row.hp <= 350 then
			setElementHealth(veh, 300)
			setVehicleDamageProof(veh, true)
			setVehicleEngineState(veh, false)
			setElementData(veh, "engine", 0, false)
			setElementData(veh, "enginebroke", 1, false)
		else
			setElementHealth(veh, row.hp)
			setVehicleEngineState(veh, row.engine == 1)
			setElementData(veh, "engine", row.engine, true)
			setElementData(veh, "enginebroke", 0, true)
		end
		setVehicleFuelTankExplodable(veh, false)

		-- handbrake
		setElementData(veh, "handbrake", row.handbrake, true)
		if row.handbrake > 0 then
			setElementFrozen(veh, true)
		end

		local hasInterior, interior = exports['vrp_vehicle_interiors']:add( veh )
		if hasInterior and row.safepositionX and row.safepositionY and row.safepositionZ and row.safepositionRZ then
			addSafe( row.id, row.safepositionX, row.safepositionY, row.safepositionZ, row.safepositionRZ, interior )
		end

		if row.bulletproof == 1 then
			setVehicleDamageProof(veh, true)
		end

		if row.tintedwindows == 1 then
			setElementData(veh, "tinted", true)
		end
		setElementData(veh, "odometer", tonumber(row.odometer), false)

		

		if getResourceFromName("vrp_vehicle_manager") then
			exports["vrp_vehicle_manager"]:loadCustomVehProperties(tonumber(row.id), veh) -- bekiroj / LOAD CUSTOM VEHICLE PROPERTIES AND HANDLING
		end
	end
end

function vehicleExploded()
	local job = source:getData("job")

	if not job or job<=0 then
		setTimer(respawnVehicle, 45000, 1, source)
	end
end
addEventHandler("onVehicleExplode", getRootElement(), vehicleExploded)

function vehicleRespawn(exploded)
	local id = source:getData("dbid")
	local faction = source:getData("faction")
	local job = source:getData("job")
	local owner = source:getData("owner")
	local windowstat = source:getData("vehicle:windowstat")

	if (job>0) then
		toggleVehicleRespawn(source, true)
		setVehicleRespawnDelay(source, 60000)
		setVehicleIdleRespawnDelay(source, 15 * 60000)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1, false)
	end

	-- Set the vehicle armored if it is armored
	local vehid = getElementModel(source)
	if (armoredCars[tonumber(vehid)]) then
		setVehicleDamageProof(source, true)
	else
		setVehicleDamageProof(source, false)
	end

	setVehicleFuelTankExplodable(source, false)
	setVehicleEngineState(source, false)
	setVehicleLandingGearDown(source, true)

	setElementData(source, "enginebroke", 0, false)

	setElementData(source, "dbid", id)
	setElementData(source, "fuel", exports["vrp_vehicle_fuel"]:getMaxFuel(vehid))
	setElementData(source, "engine", 0, false)
	setElementData(source, "vehicle:windowstat", windowstat, false)

	local x, y, z = getElementPosition(source)
	setElementData(source, "oldx", x, false)
	setElementData(source, "oldy", y, false)
	setElementData(source, "oldz", z, false)

	setElementData(source, "faction", faction)
	setElementData(source, "owner", owner, false)

	setVehicleOverrideLights(source, 1)
	setElementFrozen(source, false)

	-- Set the sirens off
	setVehicleSirensOn(source, false)

	setVehicleLightState(source, 0, 0)
	setVehicleLightState(source, 1, 0)

	local dimension = getElementDimension(source)
	local interior = getElementInterior(source)

	setElementDimension(source, dimension)
	setElementInterior(source, interior)

	-- unlock civ vehicles
	if owner == -1 then
		setVehicleLocked(source, false)
		setElementFrozen(source, true)
		setElementData(source, "handbrake", 1, false)
	end

	setElementFrozen(source, source:getData("handbrake") == 1)
end
addEventHandler("onVehicleRespawn", getResourceRootElement(), vehicleRespawn)

function setEngineStatusOnEnter(thePlayer, seat)
	-- outputDebugString('server engine state')
	if source:getData("botVehicle") then return end
	if seat == 0 then
		local engine = source:getData("engine")
		local model = getElementModel(source)
		if not (enginelessVehicle[model]) then
			if (engine==0) then
				toggleControl(thePlayer, 'brake_reverse', false)
				setVehicleEngineState(source, false)
			else
				toggleControl(thePlayer, 'brake_reverse', true)
				setVehicleEngineState(source, true)
			end
		else
			toggleControl(thePlayer, 'brake_reverse', true)

			setVehicleEngineState(source, true)
			setElementData(source, "engine", 1, false)
		end
	end
	triggerEvent("sendCurrentInventory", thePlayer, source)
end
addEventHandler("onVehicleEnter", root, setEngineStatusOnEnter)

function vehicleExit(thePlayer, seat)
	if (isElement(thePlayer)) then
		toggleControl(thePlayer, 'brake_reverse', true)
		-- For oldcar
		local vehid = source:getData("dbid")
		setElementData(thePlayer, "lastvehid", vehid, false)
		setPedGravity(thePlayer, 0.008)
		setElementFrozen(thePlayer, false)
	end
end
addEventHandler("onVehicleExit", getRootElement(), vehicleExit)

function destroyTyre(veh)
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(veh)

	if (tyre1==1) then
		tyre1 = 2
	end

	if (tyre2==1) then
		tyre2 = 2
	end

	if (tyre3==1) then
		tyre3 = 2
	end

	if (tyre4==1) then
		tyre4 = 2
	end

	if (tyre1==2 and tyre2==2 and tyre3==2 and tyre4==2) then
		tyre3 = 0
	end

	setElementData(veh, "tyretimer", false)
	setVehicleWheelStates(veh, tyre1, tyre2, tyre3, tyre4)
end

function damageTyres()
	local tyre1, tyre2, tyre3, tyre4 = getVehicleWheelStates(source)
	local tyreTimer = source:getData("tyretimer")

	if (tyretimer~=1) then
		if (tyre1==1) or (tyre2==1) or (tyre3==1) or (tyre4==1) then
			setElementData(source, "tyretimer", 1, false)
			local randTime = math.random(5, 15)
			randTime = randTime * 1000
			setTimer(destroyTyre, randTime, 1, source)
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), damageTyres)

-- Bind Keys required
function bindKeys()
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "j", "down", toggleEngine)) then
			bindKey(arrayPlayer, "j", "down", toggleEngine)
		end

		if not(isKeyBound(arrayPlayer, "l", "down", toggleLights)) then
			bindKey(arrayPlayer, "l", "down", toggleLights)
		end

		if not(isKeyBound(arrayPlayer, "k", "down", toggleLock)) then
			bindKey(arrayPlayer, "k", "down", toggleLock)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "j", "down", toggleEngine)
	bindKey(source, "l", "down", toggleLights)
	bindKey(source, "k", "down", toggleLock)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function toggleEngine(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")
	if isTimer(vehicleRunnerTimer) then return end
	if veh and inVehicle == 1 then
		local seat = getPedOccupiedVehicleSeat(source)

		if (seat == 0) then
			local model = getElementModel(veh)
			if not (enginelessVehicle[model]) then
				local engine = veh:getData("engine")
				local vehID = veh:getData("dbid")
				local vehKey = exports['vrp_global']:hasItem(source, 3, vehID)
				if engine == 0 then
					local vjob = tonumber(veh:getData("job"))
					local job = source:getData("job")
					local owner = veh:getData("owner")
					local faction = tonumber(veh:getData("faction"))
					local factionrank = tonumber(veh:getData("factionrank")) or 1
					local playerFaction = tonumber(source:getData("faction"))
					local playerFactionRank = tonumber(source:getData("factionrank"))
					if (vehKey) or (owner < 0) and (faction == -1) or (playerFaction == faction) and (playerFactionRank >= factionrank) and (faction ~= -1) or ((source:getData("duty_admin") or 0) == 1) then
					--if (vehKey) or (owner < 0) and (faction == -1) or (playerFaction == faction) and (faction ~= -1) or ((source:getData("duty_admin") or 0) == 1) then

						local fuel = veh:getData("fuel")
						local broke = veh:getData("enginebroke")
						if broke == 1 then
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							outputChatBox(syntaxTable["e"].."Aracın motoru bozulduğu için aracı çalıştıramazsın.", source, 255, 255, 255, true)
						elseif exports.vrp_global:hasItem(veh, 74) then
							while exports.vrp_global:hasItem(veh, 74) do
								exports.vrp_global:takeItem(veh, 74)
							end

							blowVehicle(veh)
						elseif veh:getData("faizkilidi") then
							outputChatBox("[-] #f0f0f0Araç vergi borcu yüzünden kilitlenmiştir.", source, 255, 128, 128, true)
							return
						elseif fuel > 0 then
							randomVehicleEngine = math.random(1,9)
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							triggerClientEvent(source, 'vehicleEngineSound', source, "engine.mp3")
							local vehicleRunnerTimer = setTimer(
								function()
									if randomVehicleEngine ~= 1 then
										toggleControl(source, 'brake_reverse', true)
										setVehicleEngineState(veh, true)
										setElementData(veh, "engine", 1, false)
										setElementData(veh, "vehicle:radio", tonumber(veh:getData("vehicle:radio:old")), true)
										setElementData(veh, "lastused", exports.vrp_datetime:now(), true)
										dbExec(mysql:getConnection(), "UPDATE vehicles SET lastUsed=NOW() WHERE id="..vehID)
									
										triggerEvent('sendAdo', source, "Aracın motoru çalışmıştır.")
									else
										triggerEvent('sendAdo', source, "Araç çalıştırılamadı.")
									end
								end,
							1000, 1)

						elseif fuel <= 0 then
							triggerEvent('sendAme', source, "aracın motorunu çalıştırmayı dener.")
							outputChatBox(syntaxTable["e"].."Araçta yakıt olmadığı için aracı çalıştıramazsın.", source, 255, 255, 255, true)
						end
					else
						outputChatBox(syntaxTable["w"].."Anahtarın olmadığı için aracı çalıştıramazsın.", source, 255, 128, 128, true)
					end
				else
					toggleControl(source, 'brake_reverse', false)
					setVehicleEngineState(veh, false)
					triggerEvent('sendAme', source, "aracın motorunu kapatır.")
					setElementData(veh, "engine", 0, false)
					setElementData(veh, "vehicle:radio", 0, true)
				end
			end
		end
	end
end
addEvent("toggleEngine", true)
addEventHandler("toggleEngine", root, toggleEngine)
addCommandHandler("motor", toggleEngine)

function toggleLock(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")

	if (veh) and (inVehicle==1) then
		triggerEvent("lockUnlockInsideVehicle", source, veh)
	elseif not veh then
		if getElementDimension(source) >= 19000 then
			local vehicle = exports.vrp_pool:getElement("vehicle", getElementDimension(source) - 20000)
			if vehicle and exports['vrp_vehicle_interiors']:isNearExit(source, vehicle) then
				local model = getElementModel(vehicle)
				local owner = getElementData(vehicle, "owner")
				local dbid = getElementData(vehicle, "dbid")

				--if (owner ~= -1) then
					if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
						local locked = isVehicleLocked(vehicle)
						if (locked) then
							setVehicleLocked(vehicle, false)
							triggerEvent('sendAme', source, "araç kapılarını açar.")
						else
							setVehicleLocked(vehicle, true)
							triggerEvent('sendAme', source, "araç kapılarını kilitler.")
						end
					else
						outputChatBox("(( Çekilmiş araçları kilitleyemezsin. ))", source, 255, 195, 14)
					end
				--else
					--outputChatBox("(( You can't lock civilian vehicles. ))", source, 255, 195, 14)
				--end
				return
			end
		end

		local interiorFound, interiorDistance = exports['vrp_interiors']:lockUnlockHouseEvent(source, true)

		local x, y, z = getElementPosition(source)
		local nearbyVehicles = exports.vrp_global:getNearbyElements(source, "vehicle", 30)

		local found = nil
		local shortest = 31
		for i, veh in ipairs(nearbyVehicles) do
			local dbid = tonumber(veh:getData("dbid"))
			local distanceToVehicle = getDistanceBetweenPoints3D(x, y, z, getElementPosition(veh))
			if shortest > distanceToVehicle and ( exports.vrp_global:isStaffOnDuty(source) or exports.vrp_global:hasItem(source, 3, dbid) or (source:getData("faction") > 0 and source:getData("faction") == veh:getData("faction")) ) then
				shortest = distanceToVehicle
				found = veh
			end
		end

		if (interiorFound and found) then
			if shortest < interiorDistance then
				triggerEvent("lockUnlockOutsideVehicle", source, found)
			else
				triggerEvent("lockUnlockHouse", source)
			end
		elseif found then
			triggerEvent("lockUnlockOutsideVehicle", source, found)
		elseif interiorFound then
			triggerEvent("lockUnlockHouse", source)
		end
	end
end
addCommandHandler("lock", toggleLock, true)
addEvent("togLockVehicle", true)
addEventHandler("togLockVehicle", getRootElement(), toggleLock)

function checkLock(thePlayer, seat, jacked)
	local locked = isVehicleLocked(source)

	if (locked) and not (jacked) then
		cancelEvent()
		outputChatBox(syntaxTable["w"].."Arabanın kapıları kilitli olduğu için araçtan inemezsin.", thePlayer, 255, 255, 255, true)
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), checkLock)





function sellVehicle(thePlayer, commandName, targetPlayerName)
	if isPedInVehicle(thePlayer) then
		if not targetPlayerName then
			exports["vrp_infobox"]:addBox(thePlayer, "info", "/sell [Karakter Adı & ID]")
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 20 then
					local theVehicle = getPedOccupiedVehicle(thePlayer)
					if theVehicle then
						local vehicleID = getElementData(theVehicle, "dbid")
						if getElementData(theVehicle, "owner") == getElementData(thePlayer, "dbid") or exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
							if getElementData(targetPlayer, "dbid") ~= getElementData(theVehicle, "owner") then
								if exports.vrp_global:hasSpaceForItem(targetPlayer, 3, vehicleID) then
									if exports.vrp_global:canPlayerBuyVehicle(targetPlayer) then
											local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET owner = '" .. (getElementData(targetPlayer, "dbid")) .. "', lastUsed=NOW() WHERE id='" .. (vehicleID) .. "'")
											if query then
												exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "owner", getElementData(targetPlayer, "dbid"), true)
												exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "owner_last_login", exports.vrp_datetime:now(), true)
												exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "lastused", exports.vrp_datetime:now(), true)

												exports.vrp_global:takeItem(thePlayer, 3, vehicleID)

												if not exports.vrp_global:hasItem(targetPlayer, 3, vehicleID) then
													exports.vrp_global:giveItem(targetPlayer, 3, vehicleID)
												end

												exports.vrp_logs:logMessage("[SELL] car #" .. vehicleID .. " was sold from " .. getPlayerName(thePlayer):gsub("_", " ") .. " to " .. targetPlayerName, 9)
												exports["vrp_infobox"]:addBox(thePlayer, "success", "Başarıyla " .. getVehicleName(theVehicle) .. " isimli aracınızı " .. targetPlayerName .. " kişisine devrettiniz.")
												exports["vrp_infobox"]:addBox(targetPlayer, "success", ""..getPlayerName(thePlayer) .. " isimli oyuncu size " .. getVehicleName(theVehicle) .. " model aracını devretti.")



												local adminID = getElementData(thePlayer, "account:id")
												local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` (`vehID`, `action`, `actor`) VALUES ('"..tostring(vehicleID).."', '"..commandName.." to "..getPlayerName(targetPlayer).."', '"..adminID.."')") or false
												exports.vrp_logs:dbLog(thePlayer, 6, { theVehicle, thePlayer, targetPlayer }, "SELL '".. getVehicleName(theVehicle).."' '".. (getPlayerName(thePlayer):gsub("_", " ")) .."' => '".. targetPlayerName .."'")
											end
									else
										outputChatBox(targetPlayerName .. " isimli oyuncunun araç limiti dolmuş.", thePlayer, 255, 0, 0)
										outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " isimli oyuncu size araç satmaya çalıştı fakat araç limitiniz dolmuş.", targetPlayer, 255, 0, 0)
									end
								else
									outputChatBox(targetPlayerName .. " isimli oyuncunun araç anahtarı için envanterinde yeterli alanı yok.", thePlayer, 255, 0, 0)
									outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " isimli oyuncu size aracı satmaya çalıştı fakat envanterinizde yeterli alan yok.", targetPlayer, 255, 0, 0)
								end
							else
								outputChatBox("#575757Valhalla:#f9f9f9 Kendi aracınızı kendinize satamazsınız.", thePlayer, 255, 0, 0, true)
							end
						else
							outputChatBox("#575757Valhalla:#f9f9f9 Bu araç sana ait değil.", thePlayer, 255, 0, 0, true)
						end
					else
						outputChatBox("#575757Valhalla:#f9f9f9 Araçta olmak zorundasınız.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("#575757Valhalla:#f9f9f9 " .. targetPlayerName .. " isimli kişiye çok uzaksınız.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addEvent("sellVehicle", true)
addEventHandler("sellVehicle", getResourceRootElement(), sellVehicle)

function AdminVehicleSale(thePlayer, commandName, args)
	if isPedInVehicle(thePlayer) and exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
		local vehType = getVehicleType(getPedOccupiedVehicle(thePlayer))
		if ( vehType == ("Plane" or "Helicopter" or "Boat") or (getElementData(thePlayer, "temporarySell") == true ) or (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) ) and not args then
			exports["vrp_infobox"]:addBox(thePlayer, "info", "/sell [Karakter Adı & ID]")
		elseif ( vehType == ("Plane" or "Helicopter" or "Boat") or (getElementData(thePlayer, "temporarySell") == true ) or (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) ) and args then
			triggerEvent("sellVehicle", getResourceRootElement(), thePlayer, "sell", args)
		end
	end
end
--addCommandHandler("sell", sellVehicle)

function toggleLights(source, key, keystate)
	local veh = getPedOccupiedVehicle(source)
	local inVehicle = source:getData("realinvehicle")

	if (veh) and (inVehicle==1) then
		local model = getElementModel(veh)
		if not (lightlessVehicle[model]) then
			local lights = getVehicleOverrideLights(veh)
			local seat = getPedOccupiedVehicleSeat(source)

			if (seat==0) then
				setElementData(veh, "long_headlights", not veh:getData("long_headlights"))
				if (lights~=2) then
					setVehicleOverrideLights(veh, 2)
					setElementData(veh, "lights", 1, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 2)
					end
				elseif (lights~=1) then
					setVehicleOverrideLights(veh, 1)
					setElementData(veh, "lights", 0, true)
					local trailer = getVehicleTowedByVehicle(veh)
					if trailer then
						setVehicleOverrideLights(trailer, 1)
					end
				end
			end
		end
	end
end
addCommandHandler("lights", toggleLights, true)
addEvent('togLightsVehicle', true)
addEventHandler('togLightsVehicle', root,
	function()
		toggleLights(client)
	end)

function checkBikeLock(thePlayer)
	if (isVehicleLocked(source))then
		if not getElementData(thePlayer, "interiormarker") then
			outputChatBox("(( Araç kapıları kilitli. ))", thePlayer, 255, 128, 128, true)
		end
		cancelEvent()
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkBikeLock)

function setRealInVehicle(thePlayer)
	if isVehicleLocked(source) then
		setElementData(thePlayer, "realinvehicle", 0, false)
		removePedFromVehicle(thePlayer)
		setVehicleLocked(source, true)
	else
		-- bekiroj 'S CUSTOM VEHICLE
		local brand = source:getData("brand") or false
		local model = source:getData("model")
		local year = source:getData("year")
		local sistemf = source:getData("carshop:cost") or 0
		setElementData(thePlayer, "realinvehicle", 1, false)

		-- 0000464: Car owner message.
		local owner = source:getData("owner") or -1
		local faction = source:getData("faction") or -1
		local birlika = source:getData("faction") or -1
		local carName = getVehicleName(source)
		local plaka = source:getData("plate")
		local kilom = source:getData("odometer")
		local vergiborc = source:getData("toplamvergi") or 0
		
		
		local birlika = 'Birlik Yok'
							if birlika == 0 then
								birlika = exports.vrp_cache:getFactionNameFromId(birlika)
							end
		 
		 
		if owner < 0 and faction == -1 then
			if brand then
				outputChatBox("(( Bu "..year.." "..brand.." "..model.." bir sivil aracıdır. ))", thePlayer, 255, 194, 14)
			else
				-- outputChatBox("(( Bu "..carName.." bir sivil aracıdır. ))", thePlayer, 255, 194, 14)
				outputChatBox("#5e9cff[-]#f9f9f9 Bu "..carName.." bir sivil aracıdır.", thePlayer, 89, 158, 255, true)
			end
		elseif (faction==-1) and (owner>0) then
			local ownerName = exports['vrp_cache']:getCharacterName(owner)

			if ownerName then
				if brand then
					outputChatBox("#5e9cff[-]#f9f9f9 Sahibi: " .. ownerName .. " / Model: "..year.." "..brand.." "..model.." / Kilometre: "..kilom.."km.", thePlayer, 89, 158, 255, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Sistem Fiyatı: "..sistemf.." / Araç Plakası: ".. plaka ..".", thePlayer, 255, 194, 14, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Vergi borcu: "..vergiborc, thePlayer, 255, 194, 14, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Ait Olduğu Birlik: "..birlika.." ", thePlayer, 255, 194, 14, true)
				else
			if ownerName then
				if brand then
				if year then
				if model then
					outputChatBox("#5e9cff[-]#f9f9f9 Sahibi: " .. ownerName .. " / Model: "..year.." "..brand.." "..model.."  / Kilometre: "..kilom.."km.", thePlayer, 89, 158, 255, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Sistem Fiyatı: "..sistemf.." / Araç Plakası: ".. plaka ..".", thePlayer, 255, 194, 14, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Vergi borcu: "..vergiborc, thePlayer, 255, 194, 14, true)
					outputChatBox("#5e9cff[-]#f9f9f9 Ait Olduğu Birlik: "..birlika.." ", thePlayer, 255, 194, 14, true)
				end
				if (source:getData("Impounded") > 0) then
					local output = getRealTime().yearday-source:getData("Impounded")
					if brand then
						outputChatBox("(( Bu "..year.." "..brand.." "..model..", " .. output .. (output == 1 and " gündür" or " gündür") .. " hacizli.))", thePlayer, 255, 194, 14)
					else
						outputChatBox("(( Bu "..carName..", " .. output .. (output == 1 and "gündür" or "gündür") .. " hacizli.))", thePlayer, 255, 194, 14)
					end
				end
				if (source:getData("faizkilidi")) then
					if brand then
						outputChatBox("(( Bu "..year.." "..brand.." "..model..", vergi borcu ödenmediği için çekilmiştir. ))", thePlayer, 255, 194, 14)
					else
						outputChatBox("(( Bu " .. carName .. ", vergi borcu ödenmediği için çekilmiştir. ))", thePlayer, 255, 194, 14)
					end
					outputChatBox("(( Toplam Vergi Borcu: " .. source:getData("toplamvergi") .. " ))", thePlayer, 255, 194, 14)
			end
		end
	end
end
end
end
end
end
end
addEventHandler("onVehicleEnter", getRootElement(), setRealInVehicle)

function setRealNotInVehicle(thePlayer)
	local locked = isVehicleLocked(source)

	if not (locked) then
		if (thePlayer) then
			setElementData(thePlayer, "realinvehicle", 0, false)
		end
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), setRealNotInVehicle)

-- Faction vehicles removal script
function removeFromFactionVehicle(thePlayer)
	if source:getData("botVehicle") then return end
	
	local faction = getElementData(thePlayer, "faction")
	local vfaction = tonumber(source:getData("faction"))
	
	if (vfaction~=-1) then
		local seat = getPedOccupiedVehicleSeat(thePlayer)
		local factionName = "Kimse (Silinecek)"
		for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("team")) do
			local id = tonumber(getElementData(value, "id"))
			if (id==vfaction) then
				factionName = getTeamName(value)
				break
			end
		end
		if (faction~=vfaction) and (seat==0) then
			outputChatBox(syntaxTable["s"]..getVehicleName(source).." - Sahip : " .. factionName, thePlayer, 255, 194, 14, true)
			
			setElementData(source, "enginebroke", 1, false)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			return
		end
	end
	local Impounded = getElementData(source,"Impounded")
	if (Impounded and Impounded > 0) then
		setElementData(source, "enginebroke", 1, false)
		setVehicleDamageProof(source, true)
		setVehicleEngineState(source, false)
	end
	if (CanTowDriverEnter) then -- Nabs abusing
		return
	end
	local vjob = tonumber(source:getData("job")) or -1
	local job = getElementData(thePlayer, "job") or -1
	local seat = getPedOccupiedVehicleSeat(thePlayer)

	if (vjob>0) and (seat==0) then
		for key, value in pairs(exports['vrp_items']:getMasks()) do
			if getElementData(thePlayer, value[1]) then
				exports.vrp_global:sendLocalMeAction(thePlayer, value[3] .. ".")
				setElementData(thePlayer, value[1], false, true)
			end
		end
	end
end
addEventHandler("onVehicleEnter", root, removeFromFactionVehicle)

-- engines dont break down
function doBreakdown()
	if exports.vrp_global:hasItem(source, 74) then
		while exports.vrp_global:hasItem(source, 74) do
			exports.vrp_global:takeItem(source, 74)
		end

		blowVehicle(source)
	else
		local health = getElementHealth(source)
		local broke = source:getData("enginebroke")

		if (health<=350) and (broke==0 or broke==false) then
			setElementHealth(source, 300)
			setVehicleDamageProof(source, true)
			setVehicleEngineState(source, false)
			setElementData(source, "enginebroke", 1, false)
			setElementData(source, "engine", 0, false)

			local player = getVehicleOccupant(source)
			if player then
				toggleControl(player, 'brake_reverse', false)
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), doBreakdown)

function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")

	--if (owner ~= -1) then
		if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
			if not locklessVehicle[model] or exports.vrp_global:hasItem( source, 3, dbid ) then
				if (source:getData("realinvehicle") == 1) then
					local locked = isVehicleLocked(vehicle)
					local seat = getPedOccupiedVehicleSeat(source)
					if seat == 0 or exports.vrp_global:hasItem( source, 3, dbid ) then
						
						if (locked) then
							setVehicleLocked(vehicle, false)
							triggerEvent('sendAme', source, "aracın kapılarını açar.")
						else
							setVehicleLocked(vehicle, true)
							triggerEvent('sendAme', source, "aracın kapılarını kilitler.")
						end
					end
				end
			end
		else
			outputChatBox("(( Çekilmiş araçları kilitleyemezsin. ))", source, 255, 195, 14)
		end
end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", getRootElement(), lockUnlockInside)


local storeTimers = { }

function lockUnlockOutside(vehicle)
	if (not source or exports.vrp_integration:isPlayerTrialAdmin(source)) or ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
		local dbid = getElementData(vehicle, "dbid")

		if (isVehicleLocked(vehicle)) then
			setVehicleLocked(vehicle, false)
			triggerEvent('sendAme', source, "anahtara basarak aracın kapılarını açar. ((" .. getVehicleName(vehicle) .. "))")
		else
			setVehicleLocked(vehicle, true)
			triggerEvent('sendAme', source, "anahtara basarak aracın kapılarını kilitler. ((" .. getVehicleName(vehicle) .. "))")
		end

		if (storeTimers[vehicle] == nil) or not (isTimer(storeTimers[vehicle])) then
			storeTimers[vehicle] = setTimer(storeVehicleLockState, 180000, 1, vehicle, dbid)
		end
	end
end
addEvent("lockUnlockOutsideVehicle", true)
addEventHandler("lockUnlockOutsideVehicle", getRootElement(), lockUnlockOutside)

function storeVehicleLockState(vehicle, dbid)
	if (isElement(vehicle)) then
		local newdbid = getElementData(vehicle, "dbid")
		if tonumber(newdbid) > 0 then
			local locked = isVehicleLocked(vehicle)

			local state = 0
			if (locked) then
				state = 1
			end

			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET locked='" .. (tostring(state)) .. "' WHERE id='" .. (tostring(newdbid)) .. "' LIMIT 1")
		end
		storeTimers[vehicle] = nil
	end
end

function fillFuelTank(veh, fuel)
	local currFuel = veh:getData("fuel")
	local engine = veh:getData("engine")
	local max = exports["vrp_vehicle_fuel"]:getMaxFuel(getElementModel(veh))
	if (math.ceil(currFuel)==max) then
		outputChatBox(syntaxTable["e"].."Aracın yakıt deposu zaten dolu.", source, 255, 255, 255, true)
	elseif (fuel==0) then
		outputChatBox(syntaxTable["e"].."İstasyonda yakıt bulunmuyor!", source, 255, 128, 128, true)
	elseif (engine==1) then
		outputChatBox(syntaxTable["w"].."Aracın motorunu durdurman gerekiyor.", source, 255, 128, 128)
	else
		local fuelAdded = fuel

		if (fuelAdded+currFuel>max) then
			fuelAdded = max - currFuel
		end

		outputChatBox(syntaxTable["s"].."Başarıyla "..math.ceil(fuelAdded).." lt yakıt doldurdun.", source, 89, 158, 255, true)

		local gender = source:getData("gender")
		local genderm = "his"
		if (gender == 1) then
			genderm = "her"
		end
		triggerEvent('sendAme', source, "fills up " .. genderm .. " vehicle from a small petrol canister.")
		exports.vrp_global:takeItem(source, 57, fuel)
		exports.vrp_global:giveItem(source, 57, math.ceil(fuel-fuelAdded))

		setElementData(veh, "fuel", currFuel+fuelAdded, false)
		triggerClientEvent(source, "syncFuel", veh, currFuel+fuelAdded)
	end
end
addEvent("fillFuelTankVehicle", true)
addEventHandler("fillFuelTankVehicle", getRootElement(), fillFuelTank)

function getYearDay(thePlayer)
	local time = getRealTime()
	local currYearday = time.yearday

	outputChatBox("Year day is " .. currYearday, thePlayer)
end
addCommandHandler("yearday", getYearDay)

function removeNOS(theVehicle)
	removeVehicleUpgrade(theVehicle, getVehicleUpgradeOnSlot(theVehicle, 8))
	triggerEvent('sendAme', source, "removes NOS from the " .. getVehicleName(theVehicle) .. ".")
	exports['vrp_save']:saveVehicleMods(theVehicle)
	exports.vrp_logs:dbLog(source, 4, {  theVehicle }, "MODDING REMOVENOS")
end
addEvent("removeNOS", true)
addEventHandler("removeNOS", getRootElement(), removeNOS)

-- /VEHPOS /PARK
local destroyTimers = { }

function checkVehpos(veh, dbid)
	local requires = veh:getData("requires.vehpos")

	if (requires) then
		if (requires==1) then
			local id = tonumber(veh:getData("dbid"))

			if (id==dbid) then
				destroyElement(veh)
				local query = dbExec(mysql:getConnection(), "DELETE FROM vehicles WHERE id='" .. (id) .. "' LIMIT 1")

				call( getResourceFromName( "vrp_items" ), "clearItems", veh )
				call( getResourceFromName( "vrp_items" ), "deleteAll", 3, id )
			end
		end
	end
end
-- VEHPOS
local PershingSquareCol = createColRectangle( 1420, -1775, 130, 257 )
local HospitalCol = createColRectangle( 1166, -1384, 52, 92 )

function setVehiclePosition(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if veh then
		if isElementWithinColShape( thePlayer, HospitalCol ) and getElementData( thePlayer, "faction" ) ~= 2 and not exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and not exports.vrp_integration:isPlayerSupporter(thePlayer) then
			outputChatBox("#575757Valhalla:#f9f9f9 Sadece Başakşehir Devlet Hastanesi üyeleri bu bölgeye araç parkında bulunabilir.", thePlayer, 255, 128, 128, true)
		elseif isElementWithinColShape( thePlayer, PershingSquareCol ) and getElementData( thePlayer, "faction" ) ~= 1  and not exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and not exports.vrp_integration:isPlayerSupporter(thePlayer) then
			outputChatBox("#575757Valhalla:#f9f9f9 Sadece Los Santos Police Department üyeleri bu bölgeye araç parkında bulunabilir.", thePlayer, 255, 128, 128, true)
		else
			local playerid = getElementData(thePlayer, "dbid")
			local playerfl = getElementData(thePlayer, "factionleader")
			local playerfid = getElementData(thePlayer, "faction")
			local owner = veh:getData("owner")
			local dbid = veh:getData("dbid")
			local carfid = veh:getData("faction")
			local x, y, z = getElementPosition(veh)
			if (owner==playerid) or (exports.vrp_global:hasItem(thePlayer, 3, dbid)) or (exports.vrp_integration:isPlayerSupporter(thePlayer) and  exports.vrp_logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) or (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and exports.vrp_logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
				if (dbid<0) then
					outputChatBox("#575757Valhalla:#f9f9f9 Bu araç kalıcı olarak park edilemez.", thePlayer, 255, 128, 128, true)
				else
				
					local rx, ry, rz = getVehicleRotation(veh)

					local interior = getElementInterior(thePlayer)
					local dimension = getElementDimension(thePlayer)

					local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
					setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
					setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
					setElementData(veh, "interior", interior)
					setElementData(veh, "dimension", dimension)
					exports["vrp_infobox"]:addBox(thePlayer, "info", "Başarıyla bulunduğunuz konuma aracınızı parkladınız.")
					exports.vrp_logs:dbLog(thePlayer, 4, {  veh }, "PARK")

					local adminID = getElementData(thePlayer, "account:id")

					for key, value in ipairs(destroyTimers) do
						if (tonumber(destroyTimers[key][2]) == dbid) then
							local timer = destroyTimers[key][1]

							if (isTimer(timer)) then
								killTimer(timer)
								table.remove(destroyTimers, key)
							end
						end
					end

					if ( veh:getData("Impounded") or 0 ) > 0 then
						local owner = getPlayerFromName( exports['vrp_cache']:getCharacterName( getElementData( veh, "owner" ) ) )
						if isElement( owner ) and exports.vrp_global:hasItem( owner, 2 ) then
							outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
						end
					end
				end
			end
		end
	else
		exports["vrp_infobox"]:addBox(thePlayer, "error", "Bir aracın içerisinde değilsin.")
	end
end
addCommandHandler("vehpos", setVehiclePosition, false, false)
addCommandHandler("park", setVehiclePosition, false, false)

function autoSetVehiclePosition(thePlayer, seat, jacked)
	if thePlayer and seat == 0 then
		if getElementData(thePlayer, "autopark") == "1" then
			local dbid = source:getData("dbid")
			if source:getData("owner") > -1 and dbid > 0 then
				if exports.vrp_global:hasItem(thePlayer, 3, dbid) or exports.vrp_global:hasItem(source, 3, dbid) then
					local x, y, z = getElementPosition(source)
					local rx, ry, rz = getElementRotation(source)
					local interior = getElementInterior(source)
					local dimension = getElementDimension(source)
					local query = dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `x`='" .. (x) .. "', `y`='" .. (y) .."', `z`='" .. (z) .. "', `rotx`='" .. (rx) .. "', `roty`='" .. (ry) .. "', `rotz`='" .. (rz) .. "', `currx`='" .. (x) .. "', `curry`='" .. (y) .. "', `currz`='" .. (z) .. "', `currrx`='" .. (rx) .. "', `currry`='" .. (ry) .. "', `currrz`='" .. (rz) .. "', `interior`='" .. (interior) .. "', `currinterior`='" .. (interior) .. "', `dimension`='" .. (dimension) .. "', `currdimension`='" .. (dimension) .. "' WHERE `id`='" .. (dbid) .. "'")
					if not query then
						--outputDebugString("[vehicle] Auto park failed, Vehicle: " .. dbid, 2)
					end
					setVehicleRespawnPosition(source, x, y, z, rx, ry, rz)
					setElementData(source, "respawnposition", {x, y, z, rx, ry, rz}, false)
					setElementData(source, "interior", interior)
					setElementData(source, "dimension", dimension)
					--outputDebugString("Autoparked. "..dbid)
					--outputChatBox("Vehicle spawn position set.", thePlayer)
				end
			end
		end
	end
end
addEventHandler("onVehicleExit", getRootElement(), autoSetVehiclePosition)

function setVehiclePosition2(thePlayer, commandName, vehicleID)
	if exports.vrp_integration:isPlayerTrialAdmin( thePlayer ) then
		local vehicleID = tonumber(vehicleID)
		if not vehicleID or vehicleID < 0 then
			outputChatBox( "SYNTAX: /" .. commandName .. " [vehicle id]", thePlayer, 255, 194, 14 )
		else
			local veh = exports.vrp_pool:getElement("vehicle", vehicleID)
			if veh then
				--setElementData(veh, "requires.vehpos")
				local x, y, z = getElementPosition(veh)
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(thePlayer)
				local dimension = getElementDimension(thePlayer)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (vehicleID) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
				setElementData(veh, "interior", interior)
				setElementData(veh, "dimension", dimension)
				outputChatBox(syntaxTable["s"].."Aracın park pozisyonu başarıyla ayarlandı.", thePlayer, 255, 255, 255, true)
				exports.vrp_logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == vehicleID) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if ( veh:getData("Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['vrp_cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.vrp_global:hasItem( owner, 2 ) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
				exports.vrp_logs:logMessage("[AVEHPOS] " .. getPlayerName( thePlayer ) .. " parked car #" .. vehicleID .. " at " .. x .. ", " .. y .. ", " .. z, 9)
			else
				outputChatBox("Vehicle not found.", thePlayer, 255, 128, 128 )
			end
		end
	end
end
addCommandHandler("avehpos", setVehiclePosition2, false, false)
addCommandHandler("apark", setVehiclePosition2, false, false)

function setVehiclePosition3(veh)
	if isElementWithinColShape( source, HospitalCol ) and getElementData( source, "faction" ) ~= 2 and not exports.vrp_integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only Los Santos Emergency Service is allowed to park their vehicles in front of the Hospital.", source, 255, 128, 128)
	elseif isElementWithinColShape( source, PershingSquareCol ) and getElementData( source, "faction" ) ~= 1  and not exports.vrp_integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only Los Santos Police Department is allowed to park their vehicles on Pershing Square.", source, 255, 128, 128)
	else
		local playerid = source:getData("dbid")
		local owner = veh:getData("owner")
		local dbid = veh:getData("dbid")
		local x, y, z = getElementPosition(veh)
		if (owner==playerid) or (exports.vrp_global:hasItem(source, 3, dbid)) or (exports.vrp_integration:isPlayerTrialAdmin(source) and exports.vrp_logs:logMessage("[AVEHPOS] " .. getPlayerName( source ) .. " parked car #" .. dbid .. " at " .. x .. ", " .. y .. ", " .. z, 9)) then
			if (dbid<0) then
				outputChatBox("This vehicle is not permanently spawned.", source, 255, 128, 128)
			else
				
				--setElementData(veh, "requires.vehpos")
				local rx, ry, rz = getVehicleRotation(veh)

				local interior = getElementInterior(source)
				local dimension = getElementDimension(source)

				local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
				setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
				setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
				setElementData(veh, "interior", interior)
				setElementData(veh, "dimension", dimension)
				outputChatBox(syntaxTable["s"].."Aracın park pozisyonu başarıyla ayarlandı.", source, 255, 255, 255, true)
				exports.vrp_logs:dbLog(thePlayer, 4, {  veh }, "PARK")
				for key, value in ipairs(destroyTimers) do
					if (tonumber(destroyTimers[key][2]) == dbid) then
						local timer = destroyTimers[key][1]

						if (isTimer(timer)) then
							killTimer(timer)
							table.remove(destroyTimers, key)
						end
					end
				end

				if ( veh:getData("Impounded") or 0 ) > 0 then
					local owner = getPlayerFromName( exports['vrp_cache']:getCharacterName( getElementData( veh, "owner" ) ) )
					if isElement( owner ) and exports.vrp_global:hasItem( owner, 2 ) then
						outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
					end
				end
			end
		else
			outputChatBox( "[-]	#8B0000Bu aracı park edemezsin.", source, 255, 128, 128 )
		end
	end
end
addEvent( "parkVehicle", true )
addEventHandler( "parkVehicle", getRootElement( ), setVehiclePosition3 )

function setVehiclePosition4(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if not veh or getElementData(thePlayer, "realinvehicle") == 0 then
		outputChatBox(syntaxTable["e"].."Bir araçta değilsin!", thePlayer, 255, 128, 128, true)
	else
		local playerid = getElementData(thePlayer, "dbid")
		local playerfl = getElementData(thePlayer, "factionleader")
		local playerfid = getElementData(thePlayer, "faction")
		local owner = veh:getData("owner")
		local dbid = veh:getData("dbid")
		local carfid = veh:getData("faction")
		if (playerfl == 1) and (playerfid==carfid) then
			local x, y, z = getElementPosition(veh)
			local rx, ry, rz = getVehicleRotation(veh)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local query = dbExec(mysql:getConnection(), "UPDATE vehicles SET x='" .. (x) .. "', y='" .. (y) .."', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='" .. (rx) .. "', currry='" .. (ry) .. "', currrz='" .. (rz) .. "', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "' WHERE id='" .. (dbid) .. "'")
			setVehicleRespawnPosition(veh, x, y, z, rx, ry, rz)
			setElementData(veh, "respawnposition", {x, y, z, rx, ry, rz}, false)
			setElementData(veh, "interior", interior)
			setElementData(veh, "dimension", dimension)
			outputChatBox(syntaxTable["s"].."Birlik aracının park pozisyonu başarıyla ayarlandı.", thePlayer, 255, 255, 255, true)

			local adminID = getElementData(thePlayer, "account:id")
		

			for key, value in ipairs(destroyTimers) do
				if (tonumber(destroyTimers[key][2]) == dbid) then
					local timer = destroyTimers[key][1]

					if (isTimer(timer)) then
						killTimer(timer)
						table.remove(destroyTimers, key)
					end
				end
			end

			if ( veh:getData("Impounded") or 0 ) > 0 then
				local owner = getPlayerFromName( exports['vrp_cache']:getCharacterName( getElementData( veh, "owner" ) ) )
				if isElement( owner ) and exports.vrp_global:hasItem( owner, 2 ) then
					outputChatBox("((SFT&R)) #5555 [SMS]: Your " .. getVehicleName(veh) .. " has been impounded. Head over to the impound to release it.", owner, 120, 255, 80)
				end
			end
		end
	end
end
addCommandHandler("fvehpos", setVehiclePosition4, false, false)
addCommandHandler("fpark", setVehiclePosition4, false, false)

function quitPlayer ( quitReason )
	if (quitReason == "Timed out") then -- if timed out
		if (isPedInVehicle(source)) then -- if in vehicle
			local vehicleSeat = getPedOccupiedVehicleSeat(source)
			if (vehicleSeat == 0) then	-- is in driver seat?
				local theVehicle = getPedOccupiedVehicle(source)
				local dbid = tonumber(getElementData(theVehicle, "dbid"))
				--------------------------------------------
				--Take the player's key / Crash fix -> Done by Anthony
				if exports.vrp_global:hasItem(theVehicle, 3, dbid) then
					exports.vrp_global:takeItem(theVehicle, 3, dbid)
					exports.vrp_global:giveItem(source, 3, dbid)
				end
				--------------------------------------------
				local passenger1 = getVehicleOccupant( theVehicle , 1 )
				local passenger2 = getVehicleOccupant( theVehicle , 2 )
				local passenger3 = getVehicleOccupant( theVehicle , 3 )
				if not (passenger1) and not (passenger2) and not (passenger3) then
					local vehicleFaction = tonumber(getElementData(theVehicle, "faction"))
					local playerFaction = tonumber(source:getData("faction"))
					if exports.vrp_global:hasItem(source, 3, dbid) or ((playerFaction == vehicleFaction) and (vehicleFaction ~= -1)) then
						if not isVehicleLocked(theVehicle) then -- check if the vehicle aint locked already
							lockUnlockOutside(theVehicle)
						end
						local engine = getElementData(theVehicle, "engine")
						if engine == 1 then -- stop the engine when its running
							setVehicleEngineState(theVehicle, false)
							setElementData(theVehicle, "engine", 0, false)
						end
					end
					setElementData(theVehicle, "handbrake", 1, false)
					setElementVelocity(theVehicle, 0, 0, 0)
					setElementFrozen(theVehicle, true)
				end
			end
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)

function detachVehicle(thePlayer)
	if isPedInVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
		local veh = getPedOccupiedVehicle(thePlayer)
		if getVehicleTowedByVehicle(veh) then
			detachTrailerFromVehicle(veh)
			outputChatBox("The trailer was detached.", thePlayer, 89, 158, 255)
		else
			outputChatBox("There is no trailer...", thePlayer, 255, 128, 128)
		end
	end
end
addCommandHandler("detach", detachVehicle)

safeTable = {}

function addSafe( dbid, x, y, z, rz, interior )
	local tempobject = createObject(2332, x, y, z, 0, 0, rz)
	setElementInterior(tempobject, interior)
	setElementDimension(tempobject, dbid + 20000)
	safeTable[dbid] = tempobject
end

function removeSafe( dbid )
	if safeTable[dbid] then
		destroyElement(safeTable[dbid])
		safeTable[dbid] = nil
	end
end

function getSafe( dbid )
	return safeTable[dbid]
end

local strToConvert = {
	["kilit"] = "lock",
	["motor"] = "motor",
	["vergi"] = "toplamvergi",
	["kemer"] = "seatbelt",
}

addCommandHandler("a",
	function(player, cmd, verb)
		if getElementData(player, "loggedin") == 1 then
			if not verb then
				outputChatBox("Komut Dizini: kilit, motor, vergi, kemer", player, 225, 225, 225, true)
			elseif strToConvert[verb] then
				executeCommandHandler(strToConvert[verb], player)
			end
		end
	end
)

function controlVehicleDoor(door, position)
	if not (isElement(source)) then
		return
	end
	
	if (isVehicleLocked(source)) then
		return
	end
	
	vehicle1x, vehicle1y, vehicle1z = getElementPosition ( source )
	player1x, player1y, player1z = getElementPosition ( client )
	if not (getPedOccupiedVehicle ( client ) == source) and not (getDistanceBetweenPoints2D ( vehicle1x, vehicle1y, player1x, player1y ) < 5) then
		return
	end
	
	local ratio = position/100
	if position == 0 then
		ratio = 0
	elseif position == 100 then
		ratio = 1
	end
	setVehicleDoorOpenRatio(source, door, ratio, 0.5)
end		
addEvent("vehicle:control:doors", true)
addEventHandler("vehicle:control:doors", getRootElement(), controlVehicleDoor)

function controlRamp(theVehicle)
	local playerVehicle = getPedOccupiedVehicle(client)
	
	if not (isElement(theVehicle) and theVehicle == playerVehicle) then
		outputChatBox("Bu düğmeyi kullanmak için araçta olmanız gerekir", client, 255, 128, 128)
		return
	end
	
	if not (exports['vrp_items']:hasItem(theVehicle, 117)) then
		outputChatBox("Bunu yapmadan önce araç envanterindeki öğeye ihtiyacınız var!", client, 255, 128, 128)
		return
	end

	if not (getElementData(theVehicle, "handbrake") == 1) or not isElementFrozen(theVehicle) then
		outputChatBox("Rampayı açmadan önce aracı el frenlemeniz gerekir.!", client, 255, 128, 128)
		return
	end
	
	if not (getElementModel(theVehicle) == 578) then
		outputChatBox("Bu araç bu rampa tipiyle uyumlu değil!", client, 255, 128, 128)
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if not (rampObject) or not (isElement(rampObject)) then
		if (getElementModel(theVehicle) == 578) then
			local vehiclePositionX, vehiclePositionY, vehiclePositionZ = getElementPosition(theVehicle)
			local vehicleRotationX, vehicleRotationY, vehicleRotationZ = getElementRotation(theVehicle)
		
			rampObject = createObject(16644, vehiclePositionX +0.37, vehiclePositionY -15.41, vehiclePositionZ -2.05, vehicleRotationX +180, vehicleRotationY +10, vehicleRotationZ + 90) 
			--attachElements( rampObject, theVehicle, 0.37, -15.45, -2.05, 180, 10, 90)
			attachElements( rampObject, theVehicle, 0.37, -15.4, -2.05, 180, 10, 90)
			setElementPosition(theVehicle, getElementPosition(theVehicle))
			exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", rampObject, false)
		end
	else
		destroyElement(rampObject)
		exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEvent("vehicle:control:ramp", true)
addEventHandler("vehicle:control:ramp", getRootElement(), controlRamp)

function checkRamp(sourcePlayer)
	local theVehicle = source
	if not (isElement(theVehicle)) then
		return
	end
	
	local rampObject = getElementData(theVehicle, "vehicle:ramp:object")
	if rampObject then
		destroyElement(rampObject)
		exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:ramp:object", nil, false)
	end
end
addEventHandler("vehicle:handbrake:lifted", getRootElement(), checkRamp)

function handleOdoMeterRequest(totalDistance, syncDistance)
	if not totalDistance then
		local theVehicle = getPedOccupiedVehicle(client)
		if theVehicle == source then
			local totDistance = getElementData(theVehicle,"odometer") or 0
			triggerClientEvent(client, "realism:distance", theVehicle, totDistance)			
		end
	else
		if not syncDistance then
			return
		end
		local theVehicle = getPedOccupiedVehicle(client)
		if theVehicle == source then
			local theSeat = getPedOccupiedVehicleSeat(client)
			if theSeat == 0 then
				local totDistance = getElementData(theVehicle,"odometer") or 0
				exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, 'odometer', totDistance + syncDistance, false )
			end
		end
	end
end
addEvent("realism:distance", true)
addEventHandler("realism:distance", getRootElement(), handleOdoMeterRequest)

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function saveVehicle(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	
	if isElement(source) and getElementType(source) == "vehicle" and dbid > 0 then
		--local owner = source:getData("owner")
		--if (owner~=-1) then
			local x, y, z = getElementPosition(source)
			local rx, ry, rz = getElementRotation(source)
			local fuel = source:getData("fuel")
			local engine = source:getData("engine")
			local odometer = source:getData("odometer") or 0
			local locked = isVehicleLocked(source) and 1 or 0		
			local lights = getVehicleOverrideLights(source)
			local sirens = getVehicleSirensOn(source) and 1 or 0
			local Impounded = source:getData("Impounded") or 0
			local handbrake = source:getData("handbrake") or 0
			local neon = source:getData("tuning.neon") or "N/A"
			local health = getElementHealth(source)
			local dimension = getElementDimension(source)
			local interior = getElementInterior(source)

			local wheel1, wheel2, wheel3, wheel4 = getVehicleWheelStates(source)
			local wheelState = toJSON( { wheel1, wheel2, wheel3, wheel4 } )
			
			local panel0 = getVehiclePanelState(source, 0)
			local panel1 = getVehiclePanelState(source, 1)
			local panel2 = getVehiclePanelState(source, 2)
			local panel3 = getVehiclePanelState(source, 3)
			local panel4 = getVehiclePanelState(source, 4)
			local panel5 = getVehiclePanelState(source, 5)
			local panel6 = getVehiclePanelState(source, 6)
			local panelState = toJSON( { panel0, panel1, panel2, panel3, panel4, panel5, panel6 } )
			
			local door0 = getVehicleDoorState(source, 0)
			local door1 = getVehicleDoorState(source, 1)
			local door2 = getVehicleDoorState(source, 2)
			local door3 = getVehicleDoorState(source, 3)
			local door4 = getVehicleDoorState(source, 4)
			local door5 = getVehicleDoorState(source, 5)
			local doorState = toJSON( { door0, door1, door2, door3, door4, door5 } )
			
			dbExec(mysql:getConnection(), "UPDATE vehicles SET `fuel`='" .. (fuel) ..
				"', `engine`='" .. (engine) ..
				"', `locked`='" .. (locked) ..
				"', `lights`='" .. (lights) ..
				"', `hp`='" .. (health) ..
				"', `sirens`='" .. (sirens) ..
				"', `Impounded`='" .. (tonumber(Impounded)) ..
				"', `handbrake`='" .. (tonumber(handbrake)) ..
				"', `currx`=" .. x .. 
				" , `curry`=" .. y ..
				" , `currz`=" .. z ..
				" , `currrx`=" .. rx ..
				" , `currry`=" .. ry ..
				" , `currrz`=" .. rz ..
				" WHERE id='" .. (dbid) .. "'")
			dbExec(mysql:getConnection(), "UPDATE vehicles SET `panelStates`='" .. (panelState) .. "', `wheelStates`='" .. (wheelState) .. "', `doorStates`='" .. (doorState) .. "', `hp`='" .. (health) .. "', sirens='" .. (sirens) .. "', Impounded='" .. (tonumber(Impounded)) .. "', handbrake='" .. (tonumber(handbrake)) .. "', `odometer`='"..(tonumber(odometer)).."', neon='"..tostring(neon).."', `lastUsed`=NOW() WHERE id='" .. (dbid) .. "'")
		--end
	end
end

local function saveVehicleOnExit(thePlayer, seat)
	saveVehicle(source)
end
addEventHandler("onVehicleExit", getRootElement(), saveVehicleOnExit)

function saveVehicleMods(source)
	local dbid = tonumber(source:getData("dbid")) or -1
	local owner = tonumber(source:getData("owner")) or -1
	if isElement(source) and getElementType(source) == "vehicle" and dbid >= 0 then -- and owner > 0 
		local col =  { getVehicleColor(source, true) }
		if source:getData("oldcolors") then
			col = unpack(source:getData("oldcolors"))
		end
		
		local color1 = toJSON( {col[1], col[2], col[3]} )
		local color2 = toJSON( {col[4], col[5], col[6]} )
		local color3 = toJSON( {col[7], col[8], col[9]} )
		local color4 = toJSON( {col[10], col[11], col[12]} )
		
		
		local hcol1, hcol2, hcol3 = getVehicleHeadLightColor( source )
		if source:getData("oldheadcolors") then
			hcol1, hcol2, hcol3 = unpack(source:getData("oldheadcolors"))
		end
		local headLightColors = toJSON( { hcol1, hcol2, hcol3 } )
		
		local upgrade0 = getElementData( source, "oldupgrade" .. 0 ) or getVehicleUpgradeOnSlot(source, 0)
		local upgrade1 = getElementData( source, "oldupgrade" .. 1 ) or getVehicleUpgradeOnSlot(source, 1)
		local upgrade2 = getElementData( source, "oldupgrade" .. 2 ) or getVehicleUpgradeOnSlot(source, 2)
		local upgrade3 = getElementData( source, "oldupgrade" .. 3 ) or getVehicleUpgradeOnSlot(source, 3)
		local upgrade4 = getElementData( source, "oldupgrade" .. 4 ) or getVehicleUpgradeOnSlot(source, 4)
		local upgrade5 = getElementData( source, "oldupgrade" .. 5 ) or getVehicleUpgradeOnSlot(source, 5)
		local upgrade6 = getElementData( source, "oldupgrade" .. 6 ) or getVehicleUpgradeOnSlot(source, 6)
		local upgrade7 = getElementData( source, "oldupgrade" .. 7 ) or getVehicleUpgradeOnSlot(source, 7)
		local upgrade8 = getElementData( source, "oldupgrade" .. 8 ) or getVehicleUpgradeOnSlot(source, 8)
		local upgrade9 = getElementData( source, "oldupgrade" .. 9 ) or getVehicleUpgradeOnSlot(source, 9)
		local upgrade10 = getElementData( source, "oldupgrade" .. 10 ) or getVehicleUpgradeOnSlot(source, 10)
		local upgrade11 = getElementData( source, "oldupgrade" .. 11 ) or getVehicleUpgradeOnSlot(source, 11)
		local upgrade12 = getElementData( source, "oldupgrade" .. 12 ) or getVehicleUpgradeOnSlot(source, 12)
		local upgrade13 = getElementData( source, "oldupgrade" .. 13 ) or getVehicleUpgradeOnSlot(source, 13)
		local upgrade14 = getElementData( source, "oldupgrade" .. 14 ) or getVehicleUpgradeOnSlot(source, 14)
		local upgrade15 = getElementData( source, "oldupgrade" .. 15 ) or getVehicleUpgradeOnSlot(source, 15)
		local upgrade16 = getElementData( source, "oldupgrade" .. 16 ) or getVehicleUpgradeOnSlot(source, 16)
		
		local paintjob =  source:getData("oldpaintjob") or getVehiclePaintjob(source)
		local variant1, variant2 = getVehicleVariant(source)
		
		local upgrades = toJSON( { upgrade0, upgrade1, upgrade2, upgrade3, upgrade4, upgrade5, upgrade6, upgrade7, upgrade8, upgrade9, upgrade10, upgrade11, upgrade12, upgrade13, upgrade14, upgrade15, upgrade16 } )
		dbExec(mysql:getConnection(), "UPDATE vehicles SET `upgrades`='" .. (upgrades) .. "', paintjob='" .. (paintjob) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', `headlights`='"..(headLightColors).."',variant1="..variant1..",variant2="..variant2.." WHERE id='" .. (dbid) .. "'")
	end
end

function addVehicleLogs(vehID, action, actor, clearPreviousLogs)
	if vehID and action then
		if clearPreviousLogs then
			if not dbExec(mysql:getConnection(), "DELETE FROM `vehicle_logs` WHERE `vehID`='"..tostring(vehID).. "'") then
				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `vehicle_logs`.")
				return false
			end
			if not dbExec(mysql:getConnection(), "DELETE FROM `logtable` WHERE `affected`='ve"..tostring(vehID).. ";'") then
				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `logtable`.")
				return false
			end
		end

		local adminID = nil
		if actor and isElement(actor) and getElementType(actor) == "player" then
		 	adminID = getElementData(actor, "account:id") 
		end
		
		local addLog = dbExec(mysql:getConnection(), "INSERT INTO `vehicle_logs` SET `vehID`= '"..tostring(vehID).."', `action` = '"..(action).."' "..(adminID and (", `actor` = '"..adminID.."' ") or "")) or false

		if not addLog then
			--outputDebugString("[VEHICLE MANAGER] Failed to add VEHICLE logs.")
			return false
		else
			return true
		end
	else
		--outputDebugString("[VEHICLE MANAGER] Lack of agruments #1 or #2 for the function addVEHICLELogs().")
		return false
	end
end

function getVehicleOwner(vehicle)
	local faction = tonumber(getElementData(vehicle, 'faction')) or 0
	if faction > 0 then
		return getTeamName(exports.vrp_pool:getElement('team', faction))
	else
		return call(getResourceFromName("vrp_cache"), "getCharacterName", getElementData(vehicle, "owner")) or "N/A"
	end
end

function toggleWindow(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	local theVehicle = getPedOccupiedVehicle(thePlayer)
	if theVehicle then
		if hasVehicleWindows(theVehicle) then
			if (getVehicleOccupant(theVehicle) == thePlayer) or (getVehicleOccupant(theVehicle, 1) == thePlayer) then
				if not (isVehicleWindowUp(theVehicle)) then
					exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 0, true)
					exports.vrp_global:sendLocalMeAction(thePlayer, "panelden aracın camını kapatır.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("setTintName", player)
						end
					end
				else
					exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "vehicle:windowstat", 1, true)
					exports.vrp_global:sendLocalMeAction(thePlayer, "panelden aracın camını açar.")
					for i = 0, getVehicleMaxPassengers(theVehicle) do
						local player = getVehicleOccupant(theVehicle, i)
						if (player) then
							triggerClientEvent(player, "updateWindow", theVehicle)
							triggerEvent("resetTintName", theVehicle, player)
						end
					end
				end
			end
		end
	end
end
addEvent("vehicle:togWindow", true)
addEventHandler("vehicle:togWindow", root, toggleWindow)
addCommandHandler("togwindow", toggleWindow)

addCommandHandler("aracpanel",
	function(player, cmd)
		if (getElementData(player, "loggedin") == 1) then
			local playerVehicles = {}
			for index, value in ipairs(getElementsByType("vehicle")) do
				if value:getData("owner") == player:getData("dbid") then
					if tonumber(value.dimension) == 62 then
						playerVehicles[#playerVehicles + 1] = value
					end
				end
			end
			triggerClientEvent(player, "showVehiclesPanel", player, playerVehicles)
		end
	end
)

function lockUnlock(element, state)
		if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		if getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle then
			triggerServerEvent("lockUnlockInsideVehicle", localPlayer, vehicle)
		elseif exports.vrp_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or (getElementData(localPlayer, "faction") > 0 and getElementData(localPlayer, "faction") == getElementData(vehicle, "faction")) then
			triggerServerEvent("lockUnlockOutsideVehicle", localPlayer, vehicle)
		end
	end
end

function fStretcher(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		if not (isVehicleLocked(vehicle)) then
			triggerServerEvent("stretcher:createStretcher", getLocalPlayer(), false, vehicle)
		end
	end
end

function fLook(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		triggerEvent("editdescription", getLocalPlayer())
	end
end

function fDoorControl(element, state)
	if (element) and (getElementType(element)=="vehicle") then
	vehicle = element
		openVehicleDoorGUI( vehicle )
	end
end

function parkTrailer(button, state)
	if (button=="left") then
		triggerServerEvent("parkVehicle", localPlayer, vehicle)
	end
end

function fillFuelTank(element, state)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		local _,_, value = exports.vrp_global:hasItem(localPlayer, 57)
		if value > 0 then
			triggerServerEvent("fillFuelTankVehicle", localPlayer, vehicle, value)
		else
			outputChatBox("This fuel can is empty...", 255, 0, 0)
		end
	end
end



addEvent("inactive:active_vehicle", true)
addEventHandler("inactive:active_vehicle", root,
	function(player, vehid)
		for index, value in ipairs(getElementsByType("vehicle")) do
			if value:getData('dbid') == vehid then
				value:setDimension(0)
			end
		end
	end
)

local donateAraclar = { [529]=true,[561]=true,[490]=true,[602]=true,[412]=true,[402]=true}

function arac_sat(thePlayer, cmd, targetPlayerName, kadar)
	if not targetPlayerName then
		outputChatBox("[!]#ffffff "..cmd.." [ID] [Miktar]",thePlayer,100,255,100,true)
	return end

	if not tonumber(kadar) then
		outputChatBox("[!]#ffffff "..cmd.." [ID] [Miktar]",thePlayer,100,255,100,true)
	return end

	local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
	local targetName = getPlayerName(thePlayer)
	local sourcePosX, sourcePosY, sourcePosZ = getElementPosition(thePlayer)
	local targetPosX, targetPosY, targetPosZ = getElementPosition(targetPlayer)
	local sourceInterior = getElementInterior(thePlayer)
	local targetInterior = getElementInterior(targetPlayer)
	local sourceDimension = getElementDimension(thePlayer)
	local targetDimension = getElementDimension(targetPlayer)
	local distance = getDistanceBetweenPoints3D(sourcePosX, sourcePosY, sourcePosZ, targetPosX, targetPosY, targetPosZ)
	if isPedInVehicle(thePlayer) then

		if distance <= 5 then
			local car = getPedOccupiedVehicle(thePlayer)
			if (donatearaclar[getElementModel(car)]) then
				outputChatBox("#99CCFF[!]#FFFFFF Özel bir aracı satamazsınız.", thePlayer, 0, 0, 0, true)
			return end

			if (targetPlayer==thePlayer) then
	           outputChatBox("#99CCFF[!]#FFFFFF Kendinize araç satamazsınız.", thePlayer, 0, 0, 0, true)
	       	return end

	       	if getElementData(targetPlayer, "aracSatis") then
	        	outputChatBox("#99CCFF[!]#FFFFFF Bu kişiye zaten araç satma isteği gönderilmiş.", thePlayer, 0, 0, 0, true)
	        return end

	        if getElementData(thePlayer, "aracSatiyormu") then
	        	outputChatBox("[!]#ffffff Zaten başka bir kişiye araç satma teklifi gönderilmiş.",thePlayer,100,255,100,true)
	        return end

			local theVehicle = getPedOccupiedVehicle(thePlayer)
			local pdbid = getElementData(thePlayer, "dbid")
			local dbid = getElementData(theVehicle, "dbid")
			local owner = getElementData(theVehicle, "owner")

			if owner == pdbid then
				outputChatBox("#99CCFF[!]#FFFFFF ".. targetPlayerName .. " isimli kişiye "..kadar.."$ karşılığında araç satma teklifi gönderdiniz.", thePlayer, 0, 0, 0, true)
	            outputChatBox("#99CCFF[!]#FFFFFF "..targetName.." isimli kişi size "..kadar.."$ karşılığında araç satmak istiyor. [/arac al] [/arac iptal]", targetPlayer, 0, 0, 0, true)
				setElementData(thePlayer, "aracSatiyormu", true)
				setElementData(targetPlayer, "aracSatis", true)
	    	    setElementData(targetPlayer, "aracSatis:kadar", tonumber(kadar))
	        	setElementData(targetPlayer, "aracSatis:satanPlayer", thePlayer)
			else
				outputChatBox("[!]#ffffff Sahibi olmadığınız aracı satamazsınız.",thePlayer,100,255,100,true)
			end
		else
			outputChatBox("[!]#ffffff Araç satmak istediğiniz kişi sizden uzakta.",thePlayer,100,100,255,true)
		end
	else
		outputChatBox("[!]#ffffff Herhangi bir araçta değilsiniz.",thePlayer,100,255,100,true)
	end
end
addCommandHandler("aracsat", arac_sat)

function arac_al (thePlayer, cmd, komut)
	if getElementData(thePlayer, "aracSatis") then
		if komut == "iptal" then
			local satanPlayer = getElementData(thePlayer, "aracSatis:satanPlayer")
		    outputChatBox("#99CCFF[!]#FFFFFF '" .. getPlayerName(thePlayer) .. "' isimli oyuncu, satışı onaylamadı.", satanPlayer, 0, 0, 0, true)
            setElementData(thePlayer, "aracSatis", false)
            setElementData(satanPlayer, "aracSatiyormu", false)
            outputChatBox("#99CCFF[!]#FFFFFF Araç almayı kabul etmediniz.", thePlayer, 0, 0, 0, true)
		end

		if komut == "al" then
			local satisFiyat = getElementData(thePlayer, "aracSatis:kadar")
            local satanPlayer = getElementData(thePlayer, "aracSatis:satanPlayer")

            setElementData(thePlayer, "aracSatis", false)
            setElementData(satanPlayer, "aracSatiyormu", false)

            if not isPedInVehicle(satanPlayer) then
            	outputChatBox("[!]#ffffff Satmak istediğiniz araçtan indiğiniz için satış iptal oldu.",satanPlayer,100,255,100,true)
            	outputChatBox("[!]#ffffff Satıcı araçtan indiği için satış iptal oldu.",thePlayer,100,255,100,true)
            return end

            local x, y, z = getElementPosition(satanPlayer)
			local tx, ty, tz = getElementPosition(thePlayer)
			local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
			local theVehicle = getPedOccupiedVehicle(satanPlayer)
            local pdbid = getElementData(satanPlayer, "dbid")
            local adbid = getElementData(thePlayer, "dbid")
			local dbid = getElementData(theVehicle, "dbid")
			local owner = getElementData(theVehicle, "owner")

			if owner == pdbid then

				if not (distance<=10) then
					outputChatBox("[!]#ffffff Satmak istediğiniz kişiden uzaklaştığınız için satış iptal oldu.",satanPlayer,100,255,100,true)
	            	outputChatBox("[!]#ffffff Satıcıdan uzaklaştığınız için satış iptal oldu.",thePlayer,100,255,100,true)
				return end

				if not exports.vrp_global:takeMoney(thePlayer, satisFiyat) then
	                outputChatBox("#99CCFF[!]#FFFFFF Aracı alabilecek kadar paranız bulunmuyor.", thePlayer, 0, 0, 0, true)
	                outputChatBox("#99CCFF[!]#FFFFFF Alıcının yeteri kadar parası olmadığı için satış iptal oldu.", satanPlayer, 0, 0, 0, true)
	            return end

	            outputChatBox("#99CCFF[!]#FFFFFF '" .. getPlayerName(thePlayer) .. "' isimli oyuncu araç satışını onayladı.", satanPlayer, 0, 0, 0, true)
	            outputChatBox("#99CCFF[!]#FFFFFF Başarı ile aracı satın aldınız.", thePlayer, 0, 0, 0, true)
	            exports.vrp_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
	             exports.vrp_global:giveMoney(satanPlayer, satisFiyat)
				dbExec(mysql:getConnection(), "UPDATE vehicles SET owner='" .. (adbid) .. "' WHERE id='" .. (dbid) .. "'")
				exports['vrp_items']:deleteAll(3,dbid)
				exports.vrp_global:giveItem(thePlayer, 3, dbid)
				exports["vrp_vehicle"]:reloadVehicle(dbid)
			end
		end
	end
end
addCommandHandler("arac", arac_al)

function parcalat_sistem(thePlayer, cmd)
	if isPedInVehicle(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		local owner = getElementData(theVehicle, "owner")
		local vergi = getElementData(theVehicle, "toplamvergi") or 0
		local dbid = getElementData(theVehicle, "dbid")
		local pdbid = getElementData(thePlayer, "dbid")
		if owner == pdbid then
			local car = getPedOccupiedVehicle(thePlayer)
			if (donatearaclar[getElementModel(car)]) then
				outputChatBox("#99CCFF[!]#FFFFFF Özel bir araca bu işlemi uygulayamazsınız.", thePlayer, 0, 0, 0, true)
			return end
			if owner <= 0 then return end
			if vergi == 0 then
				local para2 = getElementData(theVehicle, "carshop:cost") or 0
				local para = para2/3
				if dbExec(mysql:getConnection(),"UPDATE `vehicles` SET `deleted`='1' WHERE `id`='" .. (dbid) .. "'") then
					destroyElement(theVehicle)
					exports.vrp_global:giveMoney(thePlayer, para)
					exports.vrp_global:takeItem(thePlayer, 3, dbid)
					outputChatBox("[!]#ffffff "..dbid.." ID'li aracı başarı ile parçalattınız.",thePlayer,100,100,255,true)
					outputChatBox("[!]#ffffff "..exports.vrp_global:formatMoney((math.floor(para))).."$ kazandınız.",thePlayer,100,100,255,true)
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli oyuncu "..dbid.." ID'li aracı parçalattı.")
				else
					outputChatBox("[!]#ffffff Bir hata oluştu lütfen tekrar deneyiniz.",thePlayer,100,100,255,true)
				end
			else
				outputChatBox("[!]#ffffff Aracınızın vergi borcu olduğu için bu işlemi uygulayamazsınız.",thePlayer,100,100,255,true)
			end
		else
			outputChatBox("[!]#ffffff Bu aracın sahibi değilsiniz.",thePlayer,100,100,255,true)
		end
	end
end
addCommandHandler("parcalat", parcalat_sistem)