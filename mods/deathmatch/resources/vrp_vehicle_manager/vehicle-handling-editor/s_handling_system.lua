-- OKAROSA
mysql = exports.vrp_mysql
local driveTestTimeSec = 1*60 -- SECONDS
local driveTestTimeVehLibSec = 30*60 --SECONDS
local vehLibTest = {}
vehLibTest.int, vehLibTest.dim, vehLibTest.x, vehLibTest.y, vehLibTest.z, vehLibTest.rot =  0, 400, 1428.71484375, -2593.26953125, 13.273954391479, 270

local dealerPlaces = {
	["grotti"] = {},
	["JeffersonCarShop"] = {},
	["IdlewoodBikeShop"] = {},
	["SandrosCars"] = {},
	["IndustrialVehicleShop"] = {},
	["BoatShop"] = {},
}
dealerPlaces["grotti"].int, dealerPlaces["grotti"].dim, dealerPlaces["grotti"].x, dealerPlaces["grotti"].y, dealerPlaces["grotti"].z, dealerPlaces["grotti"].rot = 0, 0, 523.51953125, -1286.2919921875, 16.925954818726, 309.75823974609
dealerPlaces["JeffersonCarShop"].int, dealerPlaces["JeffersonCarShop"].dim, dealerPlaces["JeffersonCarShop"].x, dealerPlaces["JeffersonCarShop"].y, dealerPlaces["JeffersonCarShop"].z, dealerPlaces["JeffersonCarShop"].rot = 0, 0, 2124.986328125, -1126.1943359375, 25.361940383911, 351.9560546875
dealerPlaces["IdlewoodBikeShop"].int, dealerPlaces["IdlewoodBikeShop"].dim, dealerPlaces["IdlewoodBikeShop"].x, dealerPlaces["IdlewoodBikeShop"].y, dealerPlaces["IdlewoodBikeShop"].z, dealerPlaces["IdlewoodBikeShop"].rot = 0, 0, 1885.306640625, -1840.1572265625, 13.23556137085, 255.51647949219
dealerPlaces["SandrosCars"].int, dealerPlaces["SandrosCars"].dim, dealerPlaces["SandrosCars"].x, dealerPlaces["SandrosCars"].y, dealerPlaces["SandrosCars"].z, dealerPlaces["SandrosCars"].rot = 0, 0, 2118.1103515625, -2128.248046875, 13.452997207642, 32.043975830078
dealerPlaces["IndustrialVehicleShop"].int, dealerPlaces["IndustrialVehicleShop"].dim, dealerPlaces["IndustrialVehicleShop"].x, dealerPlaces["IndustrialVehicleShop"].y, dealerPlaces["IndustrialVehicleShop"].z, dealerPlaces["IndustrialVehicleShop"].rot = 0, 0, 2109.900390625, -2100.8876953125, 13.205016136169, 129.36264038086
dealerPlaces["BoatShop"].int, dealerPlaces["BoatShop"].dim, dealerPlaces["BoatShop"].x, dealerPlaces["BoatShop"].y, dealerPlaces["BoatShop"].z, dealerPlaces["BoatShop"].rot = 0, 0, 174.587890625, -1939.248046875, -0.15370398759842, 206

local startDriveTestConvo = {
	"Alright, let's do it!", 
	"Ok, let's go!", 
	"Let's roll. What are you waiting for?", 
	"Don't be shy, just try it.", 
	"I bet you'd like it, let's go!"
}
local finishDriveTestConvo = {
	"So, what do you think?", 
	"Not bad, huh?", 
	"You should definitely order this one!", 
	"So..?", 
	"Worth to spend on, huh?"
}
local orderVehicleConvo = {
	"Alright, we'll sms you as soon as we have this model in stock.", 
}

local dealershipPed = {}
function createDebekirojPCs(which)
	--GROTTI PED
	if which == getThisResource() or which == "Christopher Jackson" then
		--outputDebugString("Created")
		dealershipPed[1] = createPed( 147, 527.6103515625, -1293.4130859375, 17.2421875 )
		setPedRotation( dealershipPed[1], 0 )
		setElementDimension( dealershipPed[1], 0)
		setElementInterior( dealershipPed[1] , 0 )
		setElementData( dealershipPed[1], "talk", 1, true )
		setElementData( dealershipPed[1], "name", "Christopher Jackson", true )
		setElementData( dealershipPed[1], "carshop", "grotti", true )
		setPedAnimation ( dealershipPed[1], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[1], true)
	end
	if which == getThisResource() or which == "William Martinez" then
		--outputDebugString("Created")
		dealershipPed[2] = createPed( 17, 520.4482421875, -1284.4833984375, 17.2421875 )
		setPedRotation( dealershipPed[2], 215.87640380859 )
		setElementDimension( dealershipPed[2], 0)
		setElementInterior( dealershipPed[2] , 0 )
		setElementData( dealershipPed[2], "talk", 1, true )
		setElementData( dealershipPed[2], "name", "William Martinez", true )
		setElementData( dealershipPed[2], "carshop", "grotti", true )
		setPedAnimation ( dealershipPed[2], "GANGS", "leanIDLE" , -1, true, false, false )
		setElementFrozen(dealershipPed[2], true)
	end
	
	--JEFFERSON PED
	if which == getThisResource() or which == "Joseph Moore" then
		--outputDebugString("Created")
		dealershipPed[3] = createPed( 28, 2131.64453125, -1123.9873046875, 25.413467407227 )
		setPedRotation( dealershipPed[3], 82.066375732422 )
		setElementDimension( dealershipPed[3], 0)
		setElementInterior( dealershipPed[3] , 0 )
		setElementData( dealershipPed[3], "talk", 1, true )
		setElementData( dealershipPed[3], "name", "Joseph Moore", true )
		setElementData( dealershipPed[3], "carshop", "JeffersonCarShop", true )
		setPedAnimation ( dealershipPed[3], "GANGS", "leanIDLE" , -1, true, false, false )
		setElementFrozen(dealershipPed[3], true)
	end
	if which == getThisResource() or which == "Brandon Harris" then
		--outputDebugString("Created")
		dealershipPed[4] = createPed( 66, 2118.0244140625, -1125.4140625, 25.304183959961 )
		setPedRotation( dealershipPed[4], 264.10162353516 )
		setElementDimension( dealershipPed[4], 0)
		setElementInterior( dealershipPed[4] , 0 )
		setElementData( dealershipPed[4], "talk", 1, true )
		setElementData( dealershipPed[4], "name", "Brandon Harris", true )
		setElementData( dealershipPed[4], "carshop", "JeffersonCarShop", true )
		setPedAnimation ( dealershipPed[4], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[4], true)
	end
	
	--IGS BIKE PED
	if which == getThisResource() or which == "Jacob Jones" then
		--outputDebugString("Created")
		dealershipPed[5] = createPed( 143, 1882.861328125, -1843.5009765625, 13.572708129883 )
		setPedRotation( dealershipPed[5], 360 )
		setElementDimension( dealershipPed[5], 0)
		setElementInterior( dealershipPed[5] , 0 )
		setElementData( dealershipPed[5], "talk", 1, true )
		setElementData( dealershipPed[5], "name", "Jacob Jones", true )
		setElementData( dealershipPed[5], "carshop", "IdlewoodBikeShop", true )
		setPedAnimation ( dealershipPed[5], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[5], true)
	end
	if which == getThisResource() or which == "James Thomas" then
		--outputDebugString("Created")
		dealershipPed[6] = createPed( 23, 1886.6220703125, -1844.0029296875, 13.571912765503 )
		setPedRotation( dealershipPed[6], 352 )
		setElementDimension( dealershipPed[6], 0)
		setElementInterior( dealershipPed[6] , 0 )
		setElementData( dealershipPed[6], "talk", 1, true )
		setElementData( dealershipPed[6], "name", "James Thomas", true )
		setElementData( dealershipPed[6], "carshop", "IdlewoodBikeShop", true )
		setPedAnimation ( dealershipPed[6], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[6], true)
	end
	
	--SANDROSCARS PED
	if which == getThisResource() or which == "Ryan Martin" then
		--outputDebugString("Created")
		dealershipPed[7] = createPed( 30, 2112.4951171875, -2132.220703125, 13.6328125 )
		setPedRotation( dealershipPed[7], 269.64431762695 )
		setElementDimension( dealershipPed[7], 0)
		setElementInterior( dealershipPed[7] , 0 )
		setElementData( dealershipPed[7], "talk", 1, true )
		setElementData( dealershipPed[7], "name", "Ryan Martin", true )
		setElementData( dealershipPed[7], "carshop", "SandrosCars", true )
		setPedAnimation ( dealershipPed[7], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[7], true)
	end
	if which == getThisResource() or which == "James Jackson" then
		--outputDebugString("Created")
		dealershipPed[8] = createPed( 73, 2112.2451171875, -2127.640625, 13.6328125 )
		setPedRotation( dealershipPed[8], 269.64431762695 )
		setElementDimension( dealershipPed[8], 0)
		setElementInterior( dealershipPed[8] , 0 )
		setElementData( dealershipPed[8], "talk", 1, true )
		setElementData( dealershipPed[8], "name", "James Jackson", true )
		setElementData( dealershipPed[8], "carshop", "SandrosCars", true )
		setPedAnimation ( dealershipPed[8], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[8], true)
	end
	
	--INDUSTRIAL PED
	if which == getThisResource() or which == "John Garcia" then
		--outputDebugString("Created")
		dealershipPed[9] = createPed( 16, 2116.90234375, -2090.86328125, 13.554370880127 )
		setPedRotation( dealershipPed[9], 142.99200439453 )
		setElementDimension( dealershipPed[9], 0)
		setElementInterior( dealershipPed[9] , 0 )
		setElementData( dealershipPed[9], "talk", 1, true )
		setElementData( dealershipPed[9], "name", "John Garcia", true )
		setElementData( dealershipPed[9], "carshop", "IndustrialVehicleShop", true )
		setPedAnimation ( dealershipPed[9], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[9], true)
	end
	if which == getThisResource() or which == "William White" then
		--outputDebugString("Created")
		dealershipPed[10] = createPed( 27, 2120.048828125, -2092.8984375, 13.546875 )
		setPedRotation( dealershipPed[10], 146.20004272461 )
		setElementDimension( dealershipPed[10], 0)
		setElementInterior( dealershipPed[10] , 0 )
		setElementData( dealershipPed[10], "talk", 1, true )
		setElementData( dealershipPed[10], "name", "William White", true )
		setElementData( dealershipPed[10], "carshop", "IndustrialVehicleShop", true )
		setPedAnimation ( dealershipPed[10], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[10], true)
	end
	
	--BOAT PED
	if which == getThisResource() or which == "Nicholas Davis" then
		--outputDebugString("Created")
		dealershipPed[11] = createPed( 101, 174.39082336426, -1928.7536621094, 3.2781250476837 )
		setPedRotation( dealershipPed[11], 168.58502197266 )
		setElementDimension( dealershipPed[11], 0)
		setElementInterior( dealershipPed[11] , 0 )
		setElementData( dealershipPed[11], "talk", 1, true )
		setElementData( dealershipPed[11], "name", "Nicholas Davis", true )
		setElementData( dealershipPed[11], "carshop", "BoatShop", true )
		setPedAnimation ( dealershipPed[11], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[11], true)
	end
	if which == getThisResource() or which == "Anthony Anderson" then
		--outputDebugString("Created")
		dealershipPed[12] = createPed( 97, 163.45254516602, -1931.322265625, 4.1581702232361 )
		setPedRotation( dealershipPed[12], 62.971862792969 )
		setElementDimension( dealershipPed[12], 0)
		setElementInterior( dealershipPed[12] , 0 )
		setElementData( dealershipPed[12], "talk", 1, true )
		setElementData( dealershipPed[12], "name", "Anthony Anderson", true )
		setElementData( dealershipPed[12], "carshop", "BoatShop", true )
		setPedAnimation ( dealershipPed[12], "COP_AMBIENT", "Coplook_loop" , -1, true, false, false )
		setElementFrozen(dealershipPed[12], true)
	end
end
--addEventHandler("onResourceStart",getResourceRootElement(getThisResource()),createDebekirojPCs)

 --Setting upon editing
function setHandling(theVehicle, saveToSQL, maxVelocityS, accelerationS, engineInertiaS, lowerLimitS, suspensionBiasS, suspensionForceS, suspensionDampingS, steeringLockS, driveTypeS, massWeightS, dragCoeffS, brakeForceS, brakeBiasS, tracMultiplyS, tracBiasS, centerOfMass)
	if theVehicle then
		setVehicleHandling(theVehicle, "maxVelocity", tonumber(maxVelocityS))
		setVehicleHandling(theVehicle, "engineAcceleration", tonumber(accelerationS))
		setVehicleHandling(theVehicle, "engineInertia", tonumber(engineInertiaS))
		setVehicleHandling(theVehicle, "suspensionLowerLimit", tonumber(lowerLimitS))
		setVehicleHandling(theVehicle, "suspensionFrontRearBias", tonumber(suspensionBiasS))
		setVehicleHandling(theVehicle, "suspensionForceLevel", tonumber(suspensionForceS))
		setVehicleHandling(theVehicle, "suspensionDamping", tonumber(suspensionDampingS))
		setVehicleHandling(theVehicle, "steeringLock", tonumber(steeringLockS))
		setVehicleHandling(theVehicle, "driveType", tostring(driveTypeS))
		setVehicleHandling(theVehicle, "mass", tonumber(massWeightS))
		setVehicleHandling(theVehicle, "dragCoeff", tonumber(dragCoeffS))
		setVehicleHandling(theVehicle, "brakeBias", tonumber(brakeBiasS))
		setVehicleHandling(theVehicle, "brakeDeceleration", tonumber(brakeForceS))
		setVehicleHandling(theVehicle, "tractionMultiplier", tonumber(tracMultiplyS))
		setVehicleHandling(theVehicle, "tractionBias", tonumber(tracBiasS))
		setVehicleHandling(theVehicle, "centerOfMass", centerOfMass)
	end
	
	saveHandling(theVehicle, saveToSQL, client)
end
addEvent("handlingSystem:setHandling", true)
addEventHandler("handlingSystem:setHandling", getRootElement(), setHandling)

--Resetting the handling from editor
function resetHandling(theVehicle, mode)
	if theVehicle and (mode == 1 or mode == 0) then
		if mode == 0 then
			setVehicleHandling(theVehicle, true)
			triggerClientEvent(client, "veh-manager:handling:edithandling", client, mode)
		elseif mode == 1 then
			deleteUniqueHandling(theVehicle, client)
		end
	end
end
addEvent("handlingSystem:resetHandling", true)
addEventHandler("handlingSystem:resetHandling", getRootElement(), resetHandling)

function deleteUniqueHandling(theVehicle, player)
	local dbid = getElementData(theVehicle, "dbid") 
	if dbid and tonumber(dbid) then
		--CHECK IF EXISTED
		local existed = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM `vehicles_custom` WHERE `id` = '" .. (dbid) .. "' LIMIT 1" ), -1) or false
		if existed and existed.id then
			existed = true
		else
			existed = false
		end		
		
		if existed then
			local mQuery1 = dbExec(mysql:getConnection(), "UPDATE `vehicles_custom` SET `handling`='', `updatedby`='"..getElementData(player,"account:id").."', `updatedate`=NOW() WHERE `id`='"..toSQL(dbid).."' ")
			exports.vrp_logs:dbLog(player, 6, { player, theVehicle }, " Reset unique handling for vehicle #"..dbid..".")
			exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(player, "account:username").." has reset unique handling for vehicle #"..dbid..".")
			exports["vrp_vehicle"]:reloadVehicle(tonumber(dbid))
			outputChatBox("[VEHICLE MANAGER] You have reset unique handling for vehicle #"..dbid..".", player, 0,255,0)

		else
			exports["vrp_vehicle"]:reloadVehicle(tonumber(dbid))
			outputChatBox("[VEHICLE MANAGER] You have reset unique handling for vehicle #"..dbid..".", player, 0,255,0)
		end
	end
end


function saveHandling(theVehicle1, saveToSQL, who)
	if not theVehicle1 then
		return false
	end
	local h = getVehicleHandling(theVehicle1)
	local sHandling = toJSON( {h[handlings[1][1]], h[handlings[2][1]], h[handlings[3][1]], h[handlings[4][1]], h[handlings[5][1]], h[handlings[6][1]], h[handlings[7][1]], h[handlings[8][1]], h[handlings[9][1]], h[handlings[10][1]], h[handlings[11][1]], h[handlings[12][1]], h[handlings[13][1]], h[handlings[14][1]], h[handlings[15][1]], h[handlings[16][1]], h[handlings[17][1]], h[handlings[18][1]], h[handlings[19][1]], h[handlings[20][1]], h[handlings[21][1]], h[handlings[22][1]], h[handlings[23][1]], h[handlings[24][1]], h[handlings[25][1]], h[handlings[26][1]], h[handlings[27][1]], h[handlings[28][1]], h[handlings[29][1]], tonumber(h[handlings[30][1]]), h[handlings[31][1]], h[handlings[32][1]], h[handlings[33][1]] } )
	
	if saveToSQL == 0 then -- SAVE TO ALL INSTANCES
		local id = getElementData(theVehicle1, "vehicle_shop_id")
		if not id then
			return false
		end
		dbExec(mysql:getConnection(), "UPDATE `vehicles_shop` SET `handling`='"..toSQL(sHandling).."', `updatedby`='"..getElementData(who, "account:id").."', `updatedate`=NOW() WHERE `id`='"..tostring(id).."' ")	
		outputChatBox("You have changed handlings of all instances of vehicle shop id #"..id, who)
		exports.vrp_logs:dbLog(who, 6, { who }, "CHANGED HANDLINGS OF ALL INSTANCES OF VEHICLE SHOP ID #"..id)
		exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(who, "account:username").." has changed handlings of all instances of vehicle shop id #"..id)

	elseif saveToSQL == 1 then --SAVE TO 1 INSTANCE (UNIQUE)
		local dbid = getElementData(theVehicle1, "dbid")
		if not dbid or not tonumber(dbid) then
			--outputDebugString("saveHandling failed.")
			return false
		end
		dbQuery(
			function(qh, who)
				local res, rows, err = dbPoll(qh, 0)
				if res > 0 then
					local row = res[1]
					local veh = exports.vrp_pool:getElement('vehicle', tonumber(dbid))

					if not row or not row.id then -- NOT EXISTED
						if not dbExec(mysql:getConnection(), "INSERT INTO `vehicles_custom` SET `id`='"..tostring(dbid).."', `handling`='"..toSQL(sHandling).."', `createdby`='"..getElementData(who, "account:id").."', `createdate`=NOW()  ")	then
							--outputDebugString("saveHandling failed. / DATABASE ERROR")
							return false
						else
							exports["vrp_vehicle"]:reloadVehicle(tonumber(dbid))
						end
					else --EXISTED
						if not dbExec(mysql:getConnection(), "UPDATE `vehicles_custom` SET `handling`='"..toSQL(sHandling).."', `updatedby`='"..getElementData(who, "account:id").."', `updatedate`=NOW() WHERE `id`='"..tostring(dbid).."' ")	then
							return false
						else
							exports["vrp_vehicle"]:reloadVehicle(tonumber(dbid))
						end
					end
					
					outputChatBox("You have saved unique handlings for vehicle id #"..dbid, who)
					exports.vrp_logs:dbLog(who, 6, { who, theVehicle1 }, " SAVED UNIQUE HANDLINGS FOR VEHICLE ID #"..dbid)
					exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(who, "account:username").." saved unique handlings for vehicle id #"..dbid)
				end
			end,
		{who}, mysql:getConnection(), "SELECT * FROM `vehicles_custom` WHERE `id` = '" .. (dbid) .. "' LIMIT 1")
	end
end


function reloadAllInstancesOf(vehicle_shop_id)
	local count = 0
	if vehicle_shop_id and tonumber(vehicle_shop_id) then
		vehicle_shop_id = tonumber(vehicle_shop_id)
		for i, veh in pairs(getElementsByType("vehicle")) do
			local dbid = getElementData(veh, "dbid")
			local shopid = getElementData(veh, "vehicle_shop_id")
			if dbid and shopid and dbid > 0 and shopid > 0 and shopid == vehicle_shop_id then
				exports["vrp_vehicle"]:reloadVehicle(tonumber(dbid))
				outputChatBox("[VEHICLE MANAGER] Vehicle ID#"..dbid.." reloaded.", client)
				outputChatBox(vehicle_shop_id, client)
				count = count + 1
			end
		end
	end
	outputChatBox("You have reloaded "..count.." instances of vehicle shop id #"..vehicle_shop_id.." in game.", client)
	exports.vrp_logs:dbLog(client, 6, { client }, "RELOADED "..count.." INSTANCES OF VEHICLE SHOP ID #"..vehicle_shop_id.." IN GAME")
	exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has reloaded "..count.." instances of vehicle shop id #"..vehicle_shop_id.." in game.")
end
addEvent("vehicle_manager:handling:reloadAllInstancesOf", true)
addEventHandler("vehicle_manager:handling:reloadAllInstancesOf", getRootElement(), reloadAllInstancesOf)


local availableDim = {}
local timerTestDrive = {}
function getAvailableDimForTestVeh(veh)
	local dim = nil
	for i = 1, 5000 do
		if (availableDim[i]==nil) then
			availableDim[i] = veh
			dim = i
			break
		end
	end
	return dim
end

function freeDimForTestVeh(veh, thePed)
	if thePed then
		destroyElement(veh)

		destroyElement(thePed)
	end
	if (veh) then
		for i = 1, #availableDim do
			if availableDim[i] == veh then
				availableDim[i] = nil
				if timerTestDrive[veh] and isTimer(timerTestDrive[veh]) then
					killTimer(timerTestDrive[veh])
				end
				destroyElement(veh)
				break
			end
		end
	end
end

local Tables = {
	['vehicles_shop'] = {},
}

addEventHandler('onResourceStart', resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						Tables['vehicles_shop'][#Tables['vehicles_shop'] + 1] = row_info
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `vehicles_shop`")
	end
)

function getInfoFromVehShopID(vehShopID)
	if not vehShopID then
		--outputDebugString("VEHICLE MANAGER / HANDLING / getMtaModelFromVehShopID / NO vehShopID FOUND")
		return false
	end
	
	--local query = dbQuery(exports.vrp_mysql:getConnection(), "SELECT * FROM `vehicles_shop` WHERE `id` ='"..vehShopID.."'")	
	--local result = dbPoll(query, -1)
	--if result then
	--	return result or false
	--end
	for index, value in ipairs(Tables['vehicles_shop']) do
		if value.id == vehShopID then
			return Tables['vehicles_shop'][index]
		end
	end
	return false
end

function createTestVehicle(vehShopID, thePed, fromVehLib)
	if not client or not getElementType(client) == "player" then
		--outputDebugString("You're fucked.")
		return false
	end

	if not fromVehLib then
		if exports.vrp_global:takeMoney(client, 25) then
			exports.vrp_global:sendLocalText(client, "* "..exports.vrp_global:getPlayerName(client).." gives "..getElementData(thePed, "name").." some money.", 255, 51, 102, 30, {}, true)
		else
			triggerEvent("shop:storeKeeperSay", client, client, "Could I have $25 please?" , getElementData(thePed, "name"))
			return false
		end
	end
	
	exports.vrp_global:fadeToBlack(client)
	
	local vehShopData = getInfoFromVehShopID(vehShopID)
	if not vehShopData then
		--outputDebugString("VEHICLE MANAGER / HANDLING / CREATE TEST VEHICLE / FAILED TO FETCH VEHSHOP DATA")
		return false
	end
	local vehicleID = tonumber(vehShopData.vehmtamodel)
	local plate = tostring( getElementData(client, "account:id") )
	if #plate < 8 then
		plate = " " .. plate
		while #plate < 8 do
			plate = string.char(math.random(string.byte('A'), string.byte('Z'))) .. plate
			if #plate < 8 then
			end
		end
	end
	
	local destination = vehLibTest
	if not fromVehLib and thePed then
		local location = getElementData(thePed, "carshop")
		destination = dealerPlaces[location]
		--outputDebugString(dealerPlaces[location].int)
	else
		thePed = false
	end
	
	local int, dim = destination.int, destination.dim
	local x, y, z = destination.x, destination.y, destination.z --destination.rot---2063, -112.1552734375, 35.010520935059
	local r = destination.rot
	
	local veh = createVehicle(vehicleID, x, y, z , 0, 0, 180, plate)
	if not (veh) then
		outputChatBox("Invalid Vehicle ID.", client, 255, 0, 0)
		return false
	end
	
	local timeLimited = nil
	
	if fromVehLib then
		dim = getAvailableDimForTestVeh(veh)
		timeLimited = driveTestTimeVehLibSec
	else
		timeLimited = driveTestTimeSec
		--WRAP DEALER NPC INSIDE TESTING CAR
		removePedFromVehicle(thePed)
		warpPedIntoVehicle2(thePed, veh, 1)
	end
	setElementInterior(veh, int)
	setElementDimension(veh, dim)
	setElementRotation(veh, 0, 0, r)
	
	--SAVE PLAYER POS BEFORE MOVING TO TEST DRIVE
	local px, py, pz = getElementPosition(client)
	local rx, ry, rz = getElementRotation(client)
	local savepos = {getElementInterior(client),getElementDimension(client), px, py, pz , rx, ry, rz}
	
	--WRAP PLAYER INTO TEST CAR
	removePedFromVehicle(client)
	exports.vrp_anticheat:changeProtectedElementDataEx(client, "realinvehicle", 0, false)
	warpPedIntoVehicle3(client, veh)

	--ALLOCATE TEMP VEH ID
	totalTempVehicles = totalTempVehicles + 1
	local dbid = (-totalTempVehicles)
	exports.vrp_pool:allocateElement(veh, dbid)
	
	setVehicleOverrideLights(veh, 1)
	setVehicleEngineState(veh, false)
	setVehicleFuelTankExplodable(veh, false)
	setVehicleVariant(veh, exports['vrp_vehicle']:getRandomVariant(getElementModel(veh)))
	
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "dbid", dbid)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "fuel", exports["vrp_vehicle_fuel"]:getMaxFuel(veh), false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "Impounded", 0)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "faction", -1)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "owner", -1, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "job", 0, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "handbrake", 0, true)
	--Custom properties
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "brand", vehShopData.vehbrand, true)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "model", vehShopData.vehmodel, true)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "year", vehShopData.vehyear, true)
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "vehicle_shop_id", vehShopData.id, true)
	
	exports.vrp_anticheat:changeProtectedElementDataEx(veh, "isTestDriveCar", client)
	
	exports['vrp_vehicle_interiors']:add( veh )
	
	exports.vrp_anticheat:changeProtectedElementDataEx(client, "testdrivepos", savepos , false)
	triggerClientEvent(client, "veh-manager:handling:testdrivetimerGUI", client, veh, timeLimited, thePed)
	
	--Load Handlings
	loadHandlingToVeh(veh, vehShopData.handling)
	
	if not fromVehLib then
		local ran = math.random(1, #startDriveTestConvo)
		triggerEvent("shop:storeKeeperSay", client, client, startDriveTestConvo[ran] , getElementData(thePed, "name"))
		triggerClientEvent(client, "veh-manager:handling:edithandling", client, 2)
	else
		triggerClientEvent(client, "veh-manager:handling:edithandling", client, 0)
	end
	--outputDebugString(timeLimited)
	if timerTestDrive[veh] and isTimer(timerTestDrive[veh]) then
		killTimer(timerTestDrive[veh])
	end
	timerTestDrive[veh] = setTimer(function()
		finishTestDrive(veh, thePed)
	end, 1000*timeLimited, 1)
end
addEvent("vehicle_manager:handling:createTestVehicle", true)
addEventHandler("vehicle_manager:handling:createTestVehicle", root, createTestVehicle)

function loadHandlingToVeh(veh, handlingTable)
	if type(handlingTable) ~= "string" then
		return false
	end
	local h = fromJSON(handlingTable)
	if veh and handlingTable and h then
		setVehicleHandling(veh, handlings[1][1], h[1])
		setVehicleHandling(veh, handlings[2][1], h[2])
		setVehicleHandling(veh, handlings[3][1], h[3])
		setVehicleHandling(veh, handlings[4][1], h[4])
		setVehicleHandling(veh, handlings[5][1], h[5])
		setVehicleHandling(veh, handlings[6][1], h[6])
		setVehicleHandling(veh, handlings[7][1], h[7])
		setVehicleHandling(veh, handlings[8][1], h[8])
		setVehicleHandling(veh, handlings[9][1], h[9])
		setVehicleHandling(veh, handlings[10][1], h[10])
		setVehicleHandling(veh, handlings[11][1], h[11])
		setVehicleHandling(veh, handlings[12][1], h[12])
		setVehicleHandling(veh, handlings[13][1], h[13])
		setVehicleHandling(veh, handlings[14][1], h[14])
		setVehicleHandling(veh, handlings[15][1], h[15])
		setVehicleHandling(veh, handlings[16][1], h[16])
		setVehicleHandling(veh, handlings[17][1], h[17])
		setVehicleHandling(veh, handlings[18][1], h[18])
		setVehicleHandling(veh, handlings[19][1], h[19])
		setVehicleHandling(veh, handlings[20][1], h[20])
		setVehicleHandling(veh, handlings[21][1], h[21])
		setVehicleHandling(veh, handlings[22][1], h[22])
		setVehicleHandling(veh, handlings[23][1], h[23])
		setVehicleHandling(veh, handlings[24][1], h[24])
		setVehicleHandling(veh, handlings[25][1], h[25])
		setVehicleHandling(veh, handlings[26][1], h[26])
		setVehicleHandling(veh, handlings[27][1], h[27])
		setVehicleHandling(veh, handlings[28][1], h[28])
		--setVehicleHandling(veh, handlings[29][1], h[29]) -- I don't know why this isn't working in 1.4. Temporarily disable this stat / oKarosa
		setVehicleHandling(veh, handlings[30][1], h[30])
		setVehicleHandling(veh, handlings[31][1], h[31])
		setVehicleHandling(veh, handlings[32][1], h[32])
		setVehicleHandling(veh, handlings[33][1], h[33])
		
	end
end

function finishTestDrive(veh, thePed, orderFinish, forSpawn)

	if orderFinish then
		triggerEvent("vehicle_manager:handling:orderVehicle", client, getElementData(veh,"vehicle_shop_id") , thePed)
	end
	
	local anyPlayer = nil
	if timerTestDrive[veh] and isTimer(timerTestDrive[veh]) then
		killTimer(timerTestDrive[veh])
	end
	local found = false
	for i = 0, getVehicleMaxPassengers( veh ) do
		local player = getVehicleOccupant( veh, i )
		if player then
			anyPlayer = player
			removePedFromVehicle(player)
			exports.vrp_anticheat:changeProtectedElementDataEx(player, "realinvehicle", 0, false)
			local savedpos = getElementData(player, "testdrivepos") or false
			if savedpos and (not forSpawn or player ~= client) then
				--outputDebugString(savedpos[3]..", "..savedpos[4]..", "..savedpos[5])
				setCameraInterior(player, savedpos[1])
				setElementInterior(player, savedpos[1])
				setElementDimension(player, savedpos[2])
				setElementPosition(player, savedpos[3], savedpos[4], savedpos[5], true)
				setElementRotation(player, savedpos[6], savedpos[7], savedpos[8])
				setTimer(function ()
					exports.vrp_global:fadeFromBlack(player)
				end, 2000, 1)
				found = true
				break
			end
			---
		end
	end
	
	if not found and not forSpawn then
		local savedpos = getElementData(client, "testdrivepos") or false
		if savedpos then
			setCameraInterior(client, savedpos[1])
			setElementInterior(client, savedpos[1])
			setElementDimension(client, savedpos[2])
			setElementPosition(client, savedpos[3], savedpos[4], savedpos[5], true)
			setElementRotation(client, savedpos[6], savedpos[7], savedpos[8])
			setTimer(function ()
				exports.vrp_global:fadeFromBlack(client)
			end, 2000, 1)
		end
	end
	
	if thePed and anyPlayer and not orderFinish and not forSpawn then
		local ran = math.random(1, #finishDriveTestConvo)
		triggerEvent("shop:storeKeeperSay", anyPlayer, anyPlayer, finishDriveTestConvo[ran] , getElementData(thePed, "name"))
	end
	freeDimForTestVeh(veh, thePed)
end
addEvent("vehicle_manager:handling:finishTestDrive", true)
addEventHandler("vehicle_manager:handling:finishTestDrive", root, finishTestDrive)

function orderVehicle(vehShopID, thePed)
	--outputDebugString(vehShopID)
	--outputDebugString(getElementData(thePed,"carshop"))
	exports.vrp_anticheat:changeProtectedElementDataEx(source, "carshop:grotti:orderedvehicle:"..getElementData(thePed,"carshop"), tonumber(vehShopID), true)
	local ran = math.random(1, #orderVehicleConvo)
	triggerEvent("shop:storeKeeperSay", source, source, orderVehicleConvo[ran] , getElementData(thePed, "name"))
end
addEvent("vehicle_manager:handling:orderVehicle", true)
addEventHandler("vehicle_manager:handling:orderVehicle", root, orderVehicle)

function cancelOrderVehicle(shopname)
	if shopname then
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "carshop:grotti:orderedvehicle:"..shopname, false, true)
	else
	--[[
		for i, v in pairs(exports["vrp_vehicle_shop"]:getCarShops()) do
			exports.vrp_anticheat:changeProtectedElementDataEx(client, "carshop:grotti:orderedvehicle:"..(v.name), false)
		end
		]]
	end
end
addEvent("vehicle_manager:handling:orderVehicle:cancel", true)
addEventHandler("vehicle_manager:handling:orderVehicle:cancel", root, cancelOrderVehicle)


local function enterVehicle ( player, seat, jacked ) --WHEN A PLAYER ENTERS A TEST DRIVE VEHICLE, BLOCK IT
    local testCar = getElementData(source, "isTestDriveCar")
	if testCar and (testCar ~= player) then
        cancelEvent()
    end
end
addEventHandler ( "onVehicleStartEnter", getRootElement(), enterVehicle )


local function exitVehicle ( player, seat, jacked ) --WHEN A PLAYER EXITS A TEST DRIVE VEHICLE, BLOCK IT
    if getElementData(source, "isTestDriveCar") then
        cancelEvent()
    end
end
addEventHandler ( "onVehicleStartExit", getRootElement(), exitVehicle )

function warpPedIntoVehicle3(thePlayer, theVehicle)
	warpPedIntoVehicle2(thePlayer, theVehicle, 0)
	local x, y, z = getElementPosition(theVehicle)
	setElementPosition(thePlayer, x+2, y, z)
end