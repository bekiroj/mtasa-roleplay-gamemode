local distance = 50

function sendToNearByClients(root, message)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['vrp_freecam']:isPlayerFreecamEnabled(root) then return end
	
	local shownto = 0
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < ( distance or 20 ) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				triggerClientEvent(nearbyPlayer,"onClientAme", root, message)
				table.insert(affectedPlayers, nearbyPlayer)
				shownto = shownto + 1
				if nearbyPlayer~=root then
					outputConsole(message, nearbyPlayer)
				end
			end
		end
	end
	
	outputChatBox(message, root)
	
	if shownto > 0  then 
		exports.vrp_logs:dbLog(root, 40, affectedPlayers, message)
		return true, affectedPlayers
	else
		return false, false
	end
	
end
addEvent("sendToNearByClients", true)
addEventHandler("sendToNearByClients", getRootElement(), sendToNearByClients)

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name")
	return string.gsub(name, "_", " ")
end