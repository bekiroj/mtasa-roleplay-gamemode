-- // Militan tarafından yeniden kodlandı.
mysql = exports.vrp_mysql
local streams = {}
function fetchStation()
	streams = {
		[0] = { "Radio Off", "" },
	}
	local count = 0
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(streams, {row["station_name"], row["source"] } )
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `radio_stations` WHERE `enabled`='1' ORDER BY `id` ASC")
end

function resourceStart()
	fetchStation()
	setTimer(fetchStation, RADIO_SERVER_REFRESHRATE, 0)
end
addEventHandler("onResourceStart", resourceRoot, resourceStart)

function getStreams()
	return streams
end

function sendStationsToClient()
	if streams and #streams > 0 then
		outputDebugString("Server: sending "..(#streams).." stations to client.")
		triggerClientEvent(source, "getStationsFromServer", source, streams)
	end
end
addEvent("sendStationsToClient", true)
addEventHandler("sendStationsToClient", root, sendStationsToClient)

function forceSyncStationsToAllclients()
	local stations = fetchStation()
	local syncedClients, failedClients = 0, 0
	if stations and tonumber(stations) and tonumber(stations) > 0 then
		for i, player in pairs(getElementsByType("player")) do
			if triggerClientEvent(player, "getStationsFromServer", player, streams) then
				syncedClients = syncedClients + 1
			else
				failedClients = failedClients + 1
			end
		end
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", stations.." radio station(s) have been successfully synced to "..syncedClients.." online clients ("..failedClients.." failed).")
	else
		exports.vrp_hud:sendBottomNotification(client, "Radio Station Manager", "Could not synced any radio stations.")
	end
end
addEvent("forceSyncStationsToAllclients", true)
addEventHandler("forceSyncStationsToAllclients", root, forceSyncStationsToAllclients)