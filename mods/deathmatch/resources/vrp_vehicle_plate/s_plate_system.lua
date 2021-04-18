local mysql = exports.vrp_mysql

local serverRegFee = 2000

function getPlateList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.vrp_pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vrp_vehicle']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:clist", client, vehicleTable)
end
addEvent("vehicle-plate-system:list", true)
addEventHandler("vehicle-plate-system:list", getRootElement(), getPlateList)

function getRegisterList()
	local allVehicles = getElementsByType("vehicle")
	local vehicleTable = { }
	local playerDBID = getElementData(client,"dbid")
	if not playerDBID then
		return
	end
	for _,vehicleElement in ipairs( exports.vrp_pool:getPoolElementsByType("vehicle") ) do
		if (getElementData(vehicleElement, "owner")) and (tonumber(getElementData(vehicleElement, "owner")) == tonumber(playerDBID)) and exports['vrp_vehicle']:hasVehiclePlates(vehicleElement) then
			local vehicleID = getElementData(vehicleElement, "dbid")
			table.insert(vehicleTable, { vehicleID, vehicleElement } )
		end
	end
	triggerClientEvent(client, "vehicle-plate-system:rlist", client, vehicleTable)
end
addEvent("vehicle-plate-system:registerlist", true)
addEventHandler("vehicle-plate-system:registerlist", getRootElement(), getRegisterList)

function pedTalk(state)
	if (state == 1) then
	elseif (state == 2) then
		outputChatBox(source, "You lack of GCs to activate this feature.", 255,0,0)
	elseif (state == 3) then
	elseif (state == 4) then
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: No? Well I hope you change your mind later. Have a nice day!", 255, 255, 255, 10)
	elseif (state == 5) then
		exports.vrp_global:sendLocalText(source, " *Gabrielle McCoy begins inputting the information into her computer.", 255, 51, 102)
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: Alright, you should be good to go. Have a nice day!", 255, 255, 255, 10)
	elseif (state == 6) then
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: Hmmm. According to our records, that is already a registered license plate.", 255, 255, 255, 10)
	elseif (state == 7) then
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: Well, I'm sorry but your vehicle doesn't require a registered plate or papers.", 255, 255, 255, 10)
	elseif (state == 8) then
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: I'm sorry but are you the owner of this vehicle on papers?", 255, 255, 255, 10)
	end
end
addEvent("platePedTalk", true)
addEventHandler("platePedTalk", getRootElement(), pedTalk)

function setNewInfo(data, car)
	if not (data) or not (car) then
		outputChatBox("Internal Error", source, 255,0,0)
		return false
	end

	local tvehicle = exports.vrp_pool:getElement("vehicle", car)
	if not exports['vrp_vehicle']:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end

	local cquery = dbPoll(dbQuery(mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. data.."'"), -1)
	if (tonumber(cquery["no"]) > 0) then
		triggerEvent("platePedTalk", source, 6)
		return false
	end

	local accountID = getElementData(source, "account:id")
	credits = tonumber(getElementData(source, "credits"))
	if credits < 2 then
		triggerEvent("platePedTalk", source, 2)
		return false
	end

	dbExec(mysql:getConnection(), "UPDATE `accounts` SET `credits`=`credits`-2 WHERE `id`='"..accountID.."' ")
	dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `plate`='" .. data .. "' WHERE `id` = '" .. car .. "'")

	exports.vrp_anticheat:changeProtectedElementDataEx(tvehicle, "plate", data, true)
	setVehiclePlateText(tvehicle, data )

	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewPlates", true)
addEventHandler("sNewPlates", getRootElement(), setNewInfo)

function setNewReg(car)
	if not (car) then
		return false
	end

	local tvehicle = exports.vrp_pool:getElement("vehicle", car)
	if getElementData(source, "dbid") ~= getElementData(tvehicle, "owner") then
		triggerEvent("platePedTalk", source, 8)
		return false
	end
	
	if not exports['vrp_vehicle']:hasVehiclePlates(tvehicle) then
		triggerEvent("platePedTalk", source, 7)
		return false
	end

	if getElementData(tvehicle, "registered") == 0 then
		data = 1
	else
		data = 0
	end

	if not exports.vrp_global:takeMoney(source, data == 1 and 175 or 50) then
		exports.vrp_global:sendLocalText(source, "[English] Gabrielle McCoy says: Could I have $"..(data == 1 and 175 or 50).." please?", 255, 255, 255, 10)
	end

	exports.vrp_anticheat:changeProtectedElementDataEx(tvehicle, "registered", data, true)
	dbExec(mysql:getConnection(), "UPDATE vehicles SET registered='"..(data).."' WHERE id = '" .. (car) .. "'")
	triggerEvent("platePedTalk", source, 5)
end
addEvent("sNewReg", true)
addEventHandler("sNewReg", getRootElement(), setNewReg)

function givePaperToSellVehicle(thePlayer)
	source = thePlayer
	exports.vrp_global:takeMoney(thePlayer, 100)
	exports.vrp_global:giveItem(thePlayer, 173, 1)
end
addEvent("givePaperToSellVehicle", true)
addEventHandler("givePaperToSellVehicle", getResourceRootElement(), givePaperToSellVehicle)