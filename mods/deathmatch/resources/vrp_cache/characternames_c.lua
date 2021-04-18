--MAXIME
local characterNameCache = {}
local characterIDCache = {}
local searched = {}
local refreshCacheRate = 10 --Minutes
function getCharacterNameFromID( id )
	if not id or not tonumber(id) then
		outputDebugString("Client cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if characterNameCache[id] then
		outputDebugString("Client cache: characterName found in cache - "..characterNameCache[id]) 
		return characterNameCache[id]
	end
	
	outputDebugString("Client cache: characterName not found in cache. Searching in all current online players.")
	for i, player in pairs(getElementsByType("player")) do
		if id == getElementData(player, "dbid") then
			characterNameCache[id] = exports.vrp_global:getPlayerName(player)
			outputDebugString("Client cache: characterName found in current online players. - "..characterNameCache[id]) 
			return characterNameCache[id]
		end
	end
	
	if not searched[id] or getTickCount() - searched[id] > refreshCacheRate*1000*60 then
		searched[id] = getTickCount()
		outputDebugString("Client cache: Username not found in all current online players. Requesting for server's cache.")
		triggerServerEvent("requestCharacterNameCacheFromServer", localPlayer, id)
	else 
		outputDebugString("Client cache: Previously requested for server's cache but not found. Searching cancelled.")
		return false
	end

	return "Loading.."
end

function retrieveCharacterNameCacheFromServer(characterName, id)
	outputDebugString("Client cache: Retrieving data from server and adding to client's cache.")
	if characterName and id then
		characterNameCache[id] = characterName
	end
end
addEvent("retrieveCharacterNameCacheFromServer", true)
addEventHandler("retrieveCharacterNameCacheFromServer", root, retrieveCharacterNameCacheFromServer)

function getCharacterIDFromName( name )
	if not name then
		outputDebugString("Client cache: name is empty.")
		return false
	else
		name = tostring(name):gsub(" ", "_")
	end
	
	if characterIDCache[name] then
		outputDebugString("Client cache: characterID found in cache - "..characterIDCache[name]) 
		return characterNameCache[id]
	end
	
	outputDebugString("Client cache: characterID not found in cache. Searching in all current online players.")
	for i, player in pairs(getElementsByType("player")) do
		if name == getPlayerName(player) then
			characterIDCache[name] = tonumber(getElementData(player, "dbid"))
			outputDebugString("Client cache: characterID found in current online players. - "..characterIDCache[name]) 
			return characterIDCache[name]
		end
	end
	
	if searched[name] then
		outputDebugString("Client cache: Previously requested for server's cache but not found. Searching cancelled.")
		return false
	end
	searched[name] = true
	
	outputDebugString("Client cache: characterID not found in all current online players. Requesting for server's cache.")
	triggerServerEvent("requestCharacterIDCacheFromServer", localPlayer, name)
	
	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	return "Loading.."
end

function retrieveCharacterIDCacheFromServer(characterName, id)
	outputDebugString("Client cache: Retrieving data from server and adding to client's cache.")
	if characterName and id then
		characterIDCache[characterName] = id
	end
end
addEvent("retrieveCharacterIDCacheFromServer", true)
addEventHandler("retrieveCharacterIDCacheFromServer", root, retrieveCharacterIDCacheFromServer)