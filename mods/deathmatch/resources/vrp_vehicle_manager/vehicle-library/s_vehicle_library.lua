mysql = exports.vrp_mysql

function getRealDoorType(doortype)
	if doortype == 1 or doortype == 2 then
		return doortype
	end
	return nil
end

function refreshCarShop()
	local theResource = getResourceFromName("vrp_vehicle_shop")
	if theResource then
		local hiddenAdmin = getElementData(client, "hiddenadmin")
		if getResourceState(theResource) == "running" then
			restartResource(theResource)
			outputChatBox("Carshops were restarted.", client, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.vrp_global:sendMessageToAdmins("[VEHICLE MANAGER]" .. getPlayerName(client) .. " restarted the carshops.")
			else
				exports.vrp_global:sendMessageToAdmins("[VEHICLE MANAGER] A hidden admin restarted the carshops.")
			end
			--exports.vrp_logs:logMessage("[STEVIE] " .. getElementData(client, "account:username") .. "/".. getPlayerName(client) .." restarted the gatekeepers." , 25)
			exports.vrp_logs:dbLog(client, 4, client, "RESETCARSHOP")
		elseif getResourceState(theResource) == "loaded" then
			startResource(theResource)
			outputChatBox("Carshops were started", client, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.vrp_global:sendMessageToAdmins("[VEHICLE MANAGER] " .. getPlayerName(client) .. " started the carshops.")
			else
				exports.vrp_global:sendMessageToAdmins("[VEHICLE MANAGER] A hidden admin started the carshops.")
			end
			exports.vrp_logs:dbLog(client, 4, client, "RESETCARSHOP")
		elseif getResourceState(theResource) == "failed to load" then
			outputChatBox("Carshop's could not be loaded (" .. getResourceLoadFailureReason(theResource) .. ")", client, 255, 0, 0)
		end
	end
end
addEvent("vehlib:refreshcarshops", true)
addEventHandler("vehlib:refreshcarshops", getRootElement(), refreshCarShop)

function sendLibraryToClient(ped)
	if source then 
		client = source
	end
	
	local vehs = {}
	local mQuery1 = nil
	local preparedQ = "SELECT `spawnto`, `id`, `vehmtamodel`, `vehbrand`, `vehmodel`, `vehyear`, `vehprice`, `vehtax`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`createdby`) AS 'createdby', `createdate`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`vehicles_shop`.`updatedby`) AS 'updatedby', `updatedate`, `notes`, `enabled` FROM `vehicles_shop`"
	if ped and isElement(ped) then
		local shopName = getElementData(ped, "carshop")
		if shopName == "grotti" then
			preparedQ = preparedQ.." WHERE `spawnto`='1' "
		elseif shopName == "JeffersonCarShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='2' "
		elseif shopName == "IdlewoodBikeShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='3' "
		elseif shopName == "SandrosCars" then
			preparedQ = preparedQ.." WHERE `spawnto`='4' "
		elseif shopName == "IndustrialVehicleShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='5' "
		elseif shopName == "BoatShop" then
			preparedQ = preparedQ.." WHERE `spawnto`='6' "
		end
	end
	preparedQ = preparedQ..""

	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					table.insert(vehs, value)
				end
				triggerClientEvent(client, "vehlib:showLibrary", client, vehs, ped)
			end
		end,
	{client}, mysql:getConnection(), preparedQ)
	
end
addEvent("vehlib:sendLibraryToClient", true)
addEventHandler("vehlib:sendLibraryToClient", getRootElement(), sendLibraryToClient)

function openVehlib(thePlayer)
	if exports.vrp_integration:isPlayerVCTMember(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) or exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer) or exports.vrp_integration:isPlayerVehicleConsultant(thePlayer) then
		triggerEvent("vehlib:sendLibraryToClient", thePlayer)
	end
end
addCommandHandler("vehlib",openVehlib )
addCommandHandler("vehiclelibrary",openVehlib)

function createVehicleRecord(data)
	if not data then
--		outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local enabled = "0"
	if data.enabled then
		enabled = "1"
	end

	data.doortype = getRealDoorType(data.doortype) or 'NULL'
	
	if not data.update then
		dbExec(mysql:getConnection(), "INSERT INTO vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', createdby='"..toSQL(getElementData(client, "account:id")).."', notes='"..toSQL(data["note"]).."', enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."', `doortype` = " .. data.doortype)
		if not mQuery1 then
			--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
			outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle in library.", client, 255,0,0)
			return false
		end
		sendLibraryToClient(client)
		outputChatBox("[VEHICLE MANAGER] New vehicle created in library.", client, 0,255,0)
		exports.vrp_logs:dbLog(client, 6, { client }, " Created new vehicle in library.")
		exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has created new vehicle in library.")
		return true
	else
		if data.copy then
			dbExec(mysql:getConnection(), "INSERT INTO vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', createdby='"..toSQL(getElementData(client, "account:id")).."', notes='"..toSQL(data["note"]).."' , enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."', `doortype` = " .. data.doortype)
			if not mQuery1 then
				--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createVehicleRecord / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Failed to create new vehicle in library.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] New vehicle created in library.", client, 0,255,0)
			exports.vrp_logs:dbLog(client, 6, { client }, " Created new vehicle in library.")
			exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has created new vehicle in library.")
			return true
		else
			local mQuery1 = dbExec(mysql:getConnection(), "UPDATE vehicles_shop SET vehmtamodel='"..toSQL(data["mtaModel"]).."', vehbrand='"..toSQL(data["brand"]).."', vehmodel='"..toSQL(data["model"]).."', vehyear='"..toSQL(data["year"]).."', vehprice='"..toSQL(data["price"]).."', vehtax='"..toSQL(data["tax"]).."', updatedby='"..toSQL(getElementData(client, "account:id")).."', notes='"..toSQL(data["note"]).."', updatedate=NOW(), enabled='"..toSQL(enabled).."', `spawnto`='"..toSQL(data["spawnto"]).."',`doortype` = " .. data.doortype .. " WHERE id='"..toSQL(data["id"]).."' ")
			if not mQuery1 then
				--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / UPDATEVEHICLE / DATABASE ERROR")
				outputChatBox("[VEHICLE MANAGER] Update vehicle #"..data.id.." from vehicle library failed.", client, 255,0,0)
				return false
			end
			sendLibraryToClient(client)
			outputChatBox("[VEHICLE MANAGER] You have updated vehicle #"..data.id.." from vehicle library.", client, 0,255,0)
			exports.vrp_logs:dbLog(client, 6, { client }, " Updated vehicle #"..data.id.." from library.")
			exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has updated vehicle #"..data.id.." in library.")
			return true
		end
	end
end
addEvent("vehlib:createVehicle", true)
addEventHandler("vehlib:createVehicle", getRootElement(), createVehicleRecord)

function getCurrentVehicleRecord(id)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local veh = {}
					veh.id = row.id
					veh.mtaModel = row.vehmtamodel
					veh.brand = row.vehbrand
					veh.model = row.vehmodel
					veh.price = row.vehprice
					veh.tax = row.vehtax
					veh.year = row.vehyear
					veh.enabled = row.enabled
					veh.update = true
					veh.spawnto = row.spawnto
					veh.doortype = getRealDoorType(tonumber(row.doortype))
					triggerClientEvent(client, "vehlib:showEditVehicleRecord", client, veh)
				end
			end
		end,
	{client}, mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id = '" .. (id) .. "' LIMIT 1")
end
addEvent("vehlib:getCurrentVehicleRecord", true)
addEventHandler("vehlib:getCurrentVehicleRecord", getRootElement(), getCurrentVehicleRecord)

function deleteVehicleFromLibraby(id)
	if not id then
		--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local mQuery1 = dbExec(mysql:getConnection(), "DELETE FROM vehicles_shop WHERE id='"..toSQL(id).."' ")
	if not mQuery1 then
		--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / DELETEVEHICLE / DATABASE ERROR")
		outputChatBox("[VEHICLE MANAGER] Deleted vehicle #"..id.." from vehicle library failed.", client, 255,0,0)
		return false
	end
	outputChatBox("[VEHICLE MANAGER] You have deleted vehicle #"..id.." from vehicle library.", client, 0,255,0)
	sendLibraryToClient(client)
	return true
end
addEvent("vehlib:deleteVehicle", true)
addEventHandler("vehlib:deleteVehicle", getRootElement(), deleteVehicleFromLibraby)

function loadCustomVehProperties(vehID, theVehicle)

	if not vehID or not tonumber(vehID) then
		return false
	else
		vehID = tonumber(vehID)
	end
	if not theVehicle or not isElement(theVehicle) or not getElementType(theVehicle) == "vehicle" then
		local allVehicles = getElementsByType("vehicle")
		for i, veh in pairs (allVehicles) do
			if tonumber(getElementData(veh, "dbid")) == vehID then
				theVehicle = veh
				break
			end
		end
	end

	if not theVehicle then
		return false
	end
	
	local toBeSet = {} 
	local customHandlings, baseHandlings = nil, nil
	local hasCustomInfo = false
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					toBeSet.brand = row.brand
					toBeSet.model = row.model
					toBeSet.year = row.year
					toBeSet.price = row.price
					toBeSet.tax = row.tax
					toBeSet.duration = row.duration
					toBeSet.doortype = getRealDoorType(tonumber(row.doortype))
					customHandlings = row.handling
					
					if row.brand and row.brand ~= "" then
						hasCustomInfo = true
						setElementData(theVehicle, "unique", true, true)
					end
					if toBeSet.brand then
						
						setElementData(theVehicle, "brand", toBeSet.brand)
						setElementData(theVehicle, "model", toBeSet.model)
						setElementData(theVehicle, "year", toBeSet.year)
						setElementData(theVehicle, "carshop:cost", toBeSet.price)
						setElementData(theVehicle, "carshop:taxcost", toBeSet.tax)
						setElementData(theVehicle, "vDoorType", toBeSet.doortype)
					end
				end
				if customHandlings then
					local h = fromJSON(customHandlings)
					if h then
						for i = 1, #handlings do
							if i ~= 29 then
								setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
							end
						end
					end
				end
					dbQuery(
						function(qh)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								for index, row in ipairs(res) do
									baseHandlings = row.handling
									toBeSet.price = row.vehprice
									toBeSet.tax = row.vehtax
									toBeSet.doortype = getRealDoorType(tonumber(row.doortype))
							
									setElementData(theVehicle, "carshop:cost", toBeSet.price)
									setElementData(theVehicle, "carshop:taxcost", toBeSet.tax)
									--setElementData(theVehicle, "vDoorType", toBeSet.doortype)
								
								end
							end
							if not customHandlings and baseHandlings and type(baseHandlings) == "string" then
								local h = fromJSON(baseHandlings)
								if h then
									for i = 1, #handlings do 
										if i ~= 29 then
											setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
										end
									end
								end
							end
						end,
					mysql:getConnection(), "SELECT `handling`, `vehprice`, `vehtax`, `doortype` FROM `vehicles_shop` WHERE `id` = '" .. (getElementData(theVehicle, "vehicle_shop_id")) .. "' AND `enabled`='1' LIMIT 1")
				
			else
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, row in ipairs(res) do
								
								toBeSet.brand = row.vehbrand
								toBeSet.model = row.vehmodel
								toBeSet.year = row.vehyear
								toBeSet.price = row.vehprice
								toBeSet.tax = row.vehtax
								toBeSet.doortype = getRealDoorType(tonumber(row.doortype))
								toBeSet.duration = row.duration
								if toBeSet.brand then
									setElementData(theVehicle, "brand", toBeSet.brand)
									setElementData(theVehicle, "model", toBeSet.model)
									setElementData(theVehicle, "year", toBeSet.year)
									setElementData(theVehicle, "carshop:cost", toBeSet.price)
									setElementData(theVehicle, "carshop:taxcost", toBeSet.tax)
									setElementData(theVehicle, "vDoorType", toBeSet.doortype)
								end
								baseHandlings = row.handling
							end
						end
						if baseHandlings and type(baseHandlings) == "string" then
							local h = fromJSON(baseHandlings)
							if h then
								for i = 1, #handlings do 
									if i ~= 29 then
										setVehicleHandling(theVehicle, handlings[i][1], h[i] or h[tostring(i)])
									end
								end
							end
						end
					end,
				mysql:getConnection(), "SELECT * FROM `vehicles_shop` WHERE `id` = '" .. (getElementData(theVehicle, "vehicle_shop_id")) .. "' AND `enabled`='1' LIMIT 1")
			end
		end,
	mysql:getConnection(), "SELECT * FROM `vehicles_custom` WHERE `id` = '" .. (vehID) .. "' LIMIT 1")

	
	return true
end
addEvent("vehlib:loadCustomVehProperties", true)
addEventHandler("vehlib:loadCustomVehProperties", root, loadCustomVehProperties)



function toSQL(stuff)
	return (stuff)
end

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles_shop AS e1 LEFT JOIN vehicles_shop AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function giveTempVctAccess(thePlayer, commandName, targetPlayer)
	if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) or exports.vrp_integration:isPlayerVehicleConsultant(thePlayer) then
		if not targetPlayer then
			outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick / ID] - Give player temporary VCT Admin.", thePlayer, 255, 194, 14)
			outputChatBox("Execute the cmd again to revoke the abilities. Abilities will be automatically gone after player relogs.", thePlayer, 200, 150, 0)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				outputChatBox("Player not found.",thePlayer, 255,0,0)
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
            if (logged==0) then
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				return false
			end
			
			if not exports.vrp_integration:isPlayerVCTMember(targetPlayer) and not exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
				outputChatBox("You can grant temporary VCT admin to a VCT member only.", thePlayer, 255, 0 , 0)
				return false
			end
			
			local dbid = getElementData(targetPlayer, "dbid")
			local hasVctAdmin = getElementData(targetPlayer, "hasVctAdmin")
			local thePlayerIdentity = exports.vrp_global:getPlayerFullIdentity(thePlayer)
			local targetPlayerIdentity = exports.vrp_global:getPlayerFullIdentity(targetPlayer)
			
			if not hasVctAdmin then
				if not (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) or exports.vrp_integration:isPlayerVehicleConsultant(thePlayer)) then
					outputChatBox("You can only revoke temporary VCT admin from someone, only Lead Admin and VCT Leader can grant someone this access.", thePlayer, 255, 0 , 0)
					return false
				end
				if setElementData(targetPlayer, "hasVctAdmin", true) then
					outputChatBox("You have given "..targetPlayerIdentity.." temporary VCT admin.", thePlayer, 0, 255, 0)
					outputChatBox(thePlayerIdentity.." has given you temporary VCT admin.", targetPlayer, 0, 255, 0)
					outputChatBox("TIP: VCT Admin grants you full access to perform all tasks in VCT.", targetPlayer, 255, 255, 0)
					exports.vrp_global:sendMessageToAdmins("[VCT] "..thePlayerIdentity.." has given " ..targetPlayerIdentity.. " temporary VCT admin.")
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName)
				end
			else
				if setElementData(targetPlayer, "hasVctAdmin", false) then
					outputChatBox("You have revoked from "..targetPlayerIdentity.." temporary VCT admin.", thePlayer, 255, 0, 0)
					outputChatBox(thePlayerIdentity.." has revoked from you temporary VCT admin.", targetPlayer, 255, 0, 0)
					exports.vrp_global:sendMessageToAdmins("[VCT] "..thePlayerIdentity.." has revoked from " .. targetPlayerIdentity .. " temporary VCT admin.")
				end
			end
		end
	end
end
addCommandHandler ( "givevctadmin", giveTempVctAccess )


function setMyEngineType(thePlayer, commandName, value)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not vehicle then
		outputChatBox("You are not in a vehicle", thePlayer, 255, 0, 0)
		return
	end
	local result = setVehicleHandling(vehicle, "engineType", tostring(value))
	outputChatBox("Result = "..tostring(result), thePlayer)
end
addCommandHandler ( "setenginetype", setMyEngineType )

function getMyEngineType(thePlayer, commandName)
	local vehicle = getPedOccupiedVehicle(thePlayer)
	if not vehicle then
		outputChatBox("You are not in a vehicle", thePlayer, 255, 0, 0)
		return
	end
	local handling = getVehicleHandling(vehicle)
	outputChatBox(tostring(handling.engineType), thePlayer)
end
addCommandHandler ( "getenginetype", getMyEngineType )