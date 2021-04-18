function editVehicle(thePlayer, commandName)
	if exports.vrp_integration:isPlayerVehicleConsultant(thePlayer) or exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) or exports.vrp_integration:isPlayerVCTMember(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer) or false
		if not theVehicle then
			outputChatBox( "You must be in a vehicle.", thePlayer, 255, 194, 14)
			return false
		end
		
		local vehID = getElementData(theVehicle, "dbid") or false
		if not vehID or vehID < 0 then	
			outputChatBox("This vehicle can not have custom properties.", thePlayer, 255, 194, 14)
			return false
		end
		
		local veh = {}
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						if row then
							veh.id = row.id
							veh.brand = row.brand
							veh.model = row.model
							veh.price = row.price
							veh.tax = row.tax
							veh.handling = row.handling
							veh.notes = row.notes
							veh.doortype = getRealDoorType(row.doortype)
						end
						
					end
				end
				triggerClientEvent(thePlayer, "vehlib:handling:editVehicle", thePlayer, veh)
			end,
		mysql:getConnection(), "SELECT * FROM `vehicles_custom` WHERE `id` = '" .. (vehID) .. "' LIMIT 1" )
		
		
		--exports["vrp_vehicle"]:reloadVehicle(tonumber(vehID))
		exports.vrp_logs:dbLog(thePlayer, 4, { theVehicle, thePlayer }, commandName)
		return true
	end
end
addCommandHandler("editvehicle", editVehicle)
addCommandHandler("editveh", editVehicle)

function createUniqueVehicle(data, existed)
	if not data then
		--outputDebugString("VEHICLE MANAGER / createUniqueVehicle / NO DATA RECIEVED FROM CLIENT")
		return false
	end

	data.doortype = getRealDoorType(data.doortype) or 'NULL'
	
	local vehicle = exports.vrp_pool:getElement("vehicle", tonumber(data.id))


	if not existed then
		--outputDebugString(data.id)
		local mQuery1 = dbExec(mysql:getConnection(), "INSERT INTO `vehicles_custom` SET `id`='"..(data["id"]).."', `brand`='"..(data["brand"]).."', `model`='"..(data["model"]).."', `year`='"..(data["year"]).."', `price`='"..(data["price"]).."', `tax`='"..(data["tax"]).."', `createdby`='"..(getElementData(client, "account:id")).."', `notes`='"..(data["note"]).."', `doortype` = " .. data.doortype)
		if not mQuery1 then
			--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / createUniqueVehicle / DATABASE ERROR")
			outputChatBox("[VEHICLE MANAGER] Failed to create unique vehicle.", client, 255,0,0)
			return false
		end
		outputChatBox("[VEHICLE MANAGER] Unique vehicle created.", client, 0,255,0)
		exports.vrp_logs:dbLog(client, 6, { client }, " Created unique vehicle #"..data.id..".")
		exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has created new unique vehicle #"..data.id..".")
		exports["vrp_vehicle"]:reloadVehicle(tonumber(data.id))
		addVehicleLogs(tonumber(data.id), 'editveh: ' .. topicLink, client)
		return true
	else
		local mQuery1 = dbExec(mysql:getConnection(), "UPDATE `vehicles_custom` SET `brand`='"..(data["brand"]).."', `model`='"..(data["model"]).."', `year`='"..(data["year"]).."', `price`='"..(data["price"]).."', `tax`='"..(data["tax"]).."', `updatedby`='"..(getElementData(client, "account:id")).."', `notes`='"..(data["note"]).."', `updatedate`=NOW(), `doortype` = " .. data.doortype .. "  WHERE `id`='"..(data["id"]).."' ")
		if not mQuery1 then
			--String("VEHICLE MANAGER / VEHICLE LIB / createUniqueVehicle / DATABASE ERROR")
			outputChatBox("[VEHICLE MANAGER] Update unique vehicle #"..data.id.." failed.", client, 255,0,0)
			return false
		end
		
		outputChatBox("[VEHICLE MANAGER] You have updated unique vehicle #"..data.id..".", client, 0,255,0)
		exports.vrp_logs:dbLog(client, 6, { client }, " Updated unique vehicle #"..data.id..".")
		exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has updated unique vehicle #"..data.id..".")
		exports["vrp_vehicle"]:reloadVehicle(tonumber(data.id))
		return true
	end
end
addEvent("vehlib:handling:createUniqueVehicle", true)
addEventHandler("vehlib:handling:createUniqueVehicle", getRootElement(), createUniqueVehicle)

function resetUniqueVehicle(vehID)
	if not vehID or not tonumber(vehID) then
		--outputDebugString("VEHICLE MANAGER / resetUniqueVehicle / NO DATA RECIEVED FROM CLIENT")
		return false
	end
	
	local mQuery1 = dbExec(mysql:getConnection(), "DELETE FROM `vehicles_custom` WHERE `id`='"..(vehID).."' ")
	if not mQuery1 then
		--outputDebugString("VEHICLE MANAGER / VEHICLE LIB / resetUniqueVehicle / DATABASE ERROR")
		outputChatBox("[VEHICLE MANAGER] Remove unique vehicle #"..vehID.." failed.", client, 255,0,0)
		return false
	end
	outputChatBox("[VEHICLE MANAGER] You have removed unique vehicle #"..vehID..".", client, 0,255,0)
	exports.vrp_logs:dbLog(client, 6, { client }, " Removed unique vehicle #"..vehID..".")
	exports.vrp_global:sendMessageToAdmins("[vehicle_manager]: "..getElementData(client, "account:username").." has removed unique vehicle #"..vehID..".")
	exports["vrp_vehicle"]:reloadVehicle(tonumber(vehID))

	local vehicle = exports.vrp_pool:getElement("vehicle", tonumber(vehID))
	addVehicleLogs(tonumber(vehID), 'editveh reset: ' .. topicLink, client)
	return true
end
addEvent("vehlib:handling:resetUniqueVehicle", true)
addEventHandler("vehlib:handling:resetUniqueVehicle", getRootElement(), resetUniqueVehicle)

---HANDLINGS
function openUniqueHandling(vehdbid, existed)
	if exports.vrp_integration:isPlayerVehicleConsultant(client) or exports.vrp_integration:isPlayerSeniorAdmin(client) then
		local theVehicle = getPedOccupiedVehicle(client) or false
		if not theVehicle then
			outputChatBox( "You must be in a vehicle.", client, 255, 194, 14)
			return false
		end
		
		local vehID = getElementData(theVehicle, "dbid") or false
		if not vehID or vehID < 0 then	
			outputChatBox("This vehicle can not have custom properties.", client, 255, 194, 14)
			return false
		end
		
		if existed then
			
			triggerClientEvent(client, "veh-manager:handling:edithandling", client, 1)
		else
			triggerClientEvent(client, "veh-manager:handling:edithandling", client, 1)
		end
		
		return true
	end
end
addEvent("vehlib:handling:openUniqueHandling", true)
addEventHandler("vehlib:handling:openUniqueHandling", getRootElement(), openUniqueHandling)
