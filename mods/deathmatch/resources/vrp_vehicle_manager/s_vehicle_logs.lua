local mysql = exports.vrp_mysql
	
function addVehicleLogs(vehID, action, actor, clearPreviousLogs)
	if vehID and action then
		if clearPreviousLogs then
			if not dbExec(mysql:getConnection(), "DELETE FROM `vehicle_logs` WHERE `vehID`='"..tostring(vehID).. "'") then
--				outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `vehicle_logs`.")
				return false
			end
			if not dbExec(mysql:getConnection(), "DELETE FROM `logtable` WHERE `affected`='ve"..tostring(vehID).. ";'") then
				--outputDebugString("[VEHICLE MANAGER] Failed to clean previous logs #"..vehID.." from `logtable`.")
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

