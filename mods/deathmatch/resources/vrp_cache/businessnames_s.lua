local mysql = exports.vrp_mysql
local businessNameCache = {}
local searched = {}
local refreshCacheRate = 60
function getBusinessNameFromID( id )
	if not id or not tonumber(id) then
		outputDebugString("Server cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if businessNameCache[id] then
		return businessNameCache[id]
	end
	
	outputDebugString("Server cache: businessName not found in cache. Searching in all current online players.")
	for i, player in pairs(exports.vrp_pool:getPoolElementsByType('player')) do
		if id == getElementData(player, "dbid") then
			businessNameCache[id] = exports.vrp_global:getPlayerName(player)
			return businessNameCache[id]
		end
	end
	
	if searched[id] then
		return false
	end
	searched[id] = true
		setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	outputDebugString("Server cache: businessName does not exist in database.")
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					businessName = string.gsub(value["businessname"], "_", " ")
					businessNameCache[id] = businessName
				end
			end
		end,
	mysql:getConnection(), "SELECT `title` AS `businessname` FROM `businesses` WHERE `id` = '" .. (id) .. "' LIMIT 1")

	return businessNameCache[id]
end

function requestBusinessNameCacheFromServer(id)
	local found = getBusinessNameFromID( id )
	outputDebugString("Server cache: Checked server's cache and responding to client")
	triggerClientEvent(client, "retrieveBusinessNameCacheFromServer", client, found, id)
end
addEvent("requestBusinessNameCacheFromServer", true)
addEventHandler("requestBusinessNameCacheFromServer", root, requestBusinessNameCacheFromServer)
