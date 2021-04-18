local mysql = exports.vrp_mysql
local factionNameCache = {}
local searched = {}
local refreshCacheRate = 60 --Minutes
function getFactionNameFromId( id )
	if not id or not tonumber(id) then
		outputDebugString("Server cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if factionNameCache[id] then
		return factionNameCache[id]
	end
	
	local faction = exports["vrp_factions"]:getTeamFromFactionID(id)
	if faction then
		factionNameCache[id] = getTeamName(faction)
		return factionNameCache[id]
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					local factionName = value["name"]
					factionNameCache[id] = factionName
				end
			end
		end,
	mysql:getConnection(), "SELECT `name` FROM `factions` WHERE `id` = '" .. id .. "' LIMIT 1")

	return factionNameCache[id]
end

function requestFactionNameCacheFromServer(id)
	local found = getFactionNameFromId( id )
	outputDebugString("Server cache: Checked server's cache and responding to client")
	triggerClientEvent(client, "retrieveFactionNameCacheFromServer", client, found, id)
end
addEvent("requestFactionNameCacheFromServer", true)
addEventHandler("requestFactionNameCacheFromServer", root, requestFactionNameCacheFromServer)
