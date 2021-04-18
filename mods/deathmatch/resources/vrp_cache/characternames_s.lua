local mysql = exports.vrp_mysql
local characterNameCache = {}
local searched = {}
local refreshCacheRate = 60 --Minutes
function getCharacterNameFromID( id )
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if characterNameCache[id] then
		return characterNameCache[id]
	end
	
	for i, player in pairs(exports.vrp_pool:getPoolElementsByType('player')) do
		if id == getElementData(player, "dbid") then
			characterNameCache[id] = exports.vrp_global:getPlayerName(player)
			return characterNameCache[id]
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
	
	local _, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.id == id then
			local characterName = string.gsub(value["charactername"], "_", " ")
			characterNameCache[id] = characterName
			return characterNameCache[id]
		end
	end
	return false
end

function requestCharacterNameCacheFromServer(id)
	local found = getCharacterNameFromID( id )
	outputDebugString("Server cache: Checked server's cache and responding to client")
	triggerClientEvent(client, "retrieveCharacterNameCacheFromServer", client, found, id)
end
addEvent("requestCharacterNameCacheFromServer", true)
addEventHandler("requestCharacterNameCacheFromServer", root, requestCharacterNameCacheFromServer)
