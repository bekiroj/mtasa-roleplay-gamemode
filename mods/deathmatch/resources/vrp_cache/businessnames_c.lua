--MAXIME
local businessNameCache = {}
local searched = {}
local refreshCacheRate = 10 --Minutes
function getBusinessNameFromID( id )
	if not id or not tonumber(id) then
		outputDebugString("Client cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if businessNameCache[id] then
		outputDebugString("Client cache: businessName found in cache - "..businessNameCache[id]) 
		return businessNameCache[id]
	end
	
	outputDebugString("Client cache: businessName not found in cache. Searching in all current online players.")
	for i, player in pairs(getElementsByType("player")) do
		if id == getElementData(player, "dbid") then
			businessNameCache[id] = exports.vrp_global:getPlayerName(player)
			outputDebugString("Client cache: businessName found in current online players. - "..businessNameCache[id]) 
			return businessNameCache[id]
		end
	end
	
	if not searched[id] or getTickCount() - searched[id] > refreshCacheRate*1000*60 then
		searched[id] = getTickCount()
		outputDebugString("Client cache: Username not found in all current online players. Requesting for server's cache.")
		triggerServerEvent("requestBusinessNameCacheFromServer", localPlayer, id)
	else 
		outputDebugString("Client cache: Previously requested for server's cache but not found. Searching cancelled.")
		return false
	end

	return "Loading.."
end

function retrieveBusinessNameCacheFromServer(businessName, id)
	outputDebugString("Client cache: Retrieving data from server and adding to client's cache.")
	if businessName and id then
		businessNameCache[id] = businessName
	end
end
addEvent("retrieveBusinessNameCacheFromServer", true)
addEventHandler("retrieveBusinessNameCacheFromServer", root, retrieveBusinessNameCacheFromServer)