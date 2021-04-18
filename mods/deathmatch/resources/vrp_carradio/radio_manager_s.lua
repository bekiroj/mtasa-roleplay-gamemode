----MAXIME
function addPurchaseHistory(thePlayer, perkName, cost)
	return true
end

function fetchStations()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if type(row["owner"]) == "string" then
						table.insert(donorStations, row )
					else
						table.insert(defaultStations, row )
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `id`, `station_name`, `source`, (SELECT `username` FROM `accounts` WHERE `accounts`.`id`=`owner`) AS `owner`, `register_date`, `expire_date`, `enabled`, `order` FROM `radio_stations` WHERE (`expire_date` IS NULL) OR (`expire_date` > NOW()) ORDER BY `order` ")
	return defaultStations, donorStations
end

function openRadioManager()
	if source then
		client = source
	end
	local defaultStations, donorStations = fetchStations()
	triggerClientEvent(client, "openRadioManager", client, defaultStations, donorStations)
end
addEvent("openRadioManager", true)
addEventHandler("openRadioManager", root, openRadioManager)

function createNewStation(name, ip, donorStation)
	if name and ip then
		if donorStation then
		
			addPurchaseHistory(client, "Purchased new radio station (Name: '"..name.."', URL: '"..ip.."')", 10)
			local smallestID = SmallestID()
			dbExec(mysql:getConnection(),"INSERT INTO `radio_stations` SET `id`='"..smallestID.."', `station_name`='"..exports.vrp_global:toSQL(name).."', `source`='"..exports.vrp_global:toSQL(ip).."', `order`='"..smallestID.."', `owner`='"..getElementData(client, "account:id").."', `expire_date`=(NOW() + interval 30 day) ")
			exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "New radio station has been successfully created! (Name: "..name..", URL: "..ip..")")
			setElementData(client, "gui:ViewingRadioManager", true, true)
			forceUpdateClientsGUI()
		else
			local smallestID = SmallestID()
			dbExec(mysql:getConnection(),"INSERT INTO `radio_stations` SET `id`='"..smallestID.."', `station_name`='"..exports.vrp_global:toSQL(name).."', `source`='"..exports.vrp_global:toSQL(ip).."', `order`='"..smallestID.."' ")
			exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "New radio station has been successfully created! (Name: "..name..", URL: "..ip..")")
			forceUpdateClientsGUI()
		end
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not create new radio station.")
	end
end
addEvent("createNewStation", true)
addEventHandler("createNewStation", root, createNewStation)

function editStation(id, name, ip)
	if id and name and ip and dbExec(mysql:getConnection(),"UPDATE `radio_stations` SET `station_name`='"..exports.vrp_global:toSQL(name).."', `source`='"..exports.vrp_global:toSQL(ip).."' WHERE `id`='"..id.."' ") then
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Updated radio station #"..id.." successfully!")
		forceUpdateClientsGUI()
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not update radio station #"..id)
	end
end
addEvent("editStation", true)
addEventHandler("editStation", root, editStation)

function deleteStation(id)
	if id and dbExec(mysql:getConnection(),"DELETE FROM `radio_stations` WHERE `id`='"..id.."' ") then
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Deleted radio station #"..id..".")
		forceUpdateClientsGUI()
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not delete radio station #"..id..".")
	end
end
addEvent("deleteStation", true)
addEventHandler("deleteStation", root, deleteStation)

function togStation(id, state)
	if id and state and dbExec(mysql:getConnection(),"UPDATE `radio_stations` SET `enabled`='"..(state == "Activated" and "1" or "0").."' WHERE `id`='"..id.."' ") then
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Radio station #"..id.." has been "..state.."!")
		forceUpdateClientsGUI()
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not update radio station #"..id)
	end
end
addEvent("togStation", true)
addEventHandler("togStation", root, togStation)

function moveStationPosition(id, name, order, movingUp, donorStation)
	if id and tonumber(id) and order and tonumber(order)  then
		id = tonumber(id)
		order = tonumber(order)
		if donorStation then
			
			addPurchaseHistory(client, "Moved radio station position (Name: '"..name.."', Direction: '"..(movingUp and "Up" or "Down").."')", 1)
		end
		
		
		
		if movingUp then
			if order < 2 then
				exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "This radio station is already on top.")
				return false
			end
			if dbExec(mysql:getConnection(),"UPDATE `radio_stations` SET `order`=`order`-1 WHERE `id`='"..(id).."' ") then
				forceUpdateClientsGUI()
				exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Radio station '"..name.."' has been moved up!")
			else
				exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not move radio station.")
			end
		else
			if dbExec(mysql:getConnection(),"UPDATE `radio_stations` SET `order`=`order`+1 WHERE `id`='"..(id).."' ") then
				forceUpdateClientsGUI()
				exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Radio station '"..name.."' has been moved down!")
			else
				exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not move radio station.")
			end
		end
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not move radio station's position.")
	end
end
addEvent("moveStationPosition", true)
addEventHandler("moveStationPosition", root, moveStationPosition)

function renewStation(station, duration)
	if station and duration and tonumber(duration) then
		local id = station[1]
		local cost = nil
		if duration == 7 then
			cost = 3
		elseif duration == 30 then
			cost = 10
		elseif duration == 90 then
			cost = 25
		else
			exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not renew radio station #"..id)
			return false
		end
		
		
		addPurchaseHistory(client, "Renewed radio station (ID: '"..id.."', Name: '"..station[2].."', Duration: '"..duration.." days')", cost)
		
		if not dbExec(mysql:getConnection(),"UPDATE `radio_stations` SET `expire_date`=(`expire_date` + interval "..duration.." day) WHERE `id`='"..(id).."' ") then
			return false
		end
		
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "You have successfully renewed Radio Station ID#"..id.."!")
		forceUpdateClientsGUI()
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not renew radio station #"..id)
	end
end
addEvent("renewStation", true)
addEventHandler("renewStation", root, renewStation)

function forceUpdateClientsGUI()
	local defaultStations, donorStations = fetchStations()
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "gui:ViewingRadioManager") then
			triggerClientEvent(player, "openRadioManager", player, defaultStations, donorStations)
		end
	end
end

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM radio_stations AS e1 LEFT JOIN radio_stations AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end
