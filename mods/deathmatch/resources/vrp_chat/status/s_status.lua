local distance1 = 100

function sendStatus( thePlayer, commandName, ... )
	if not (...) then
		triggerClientEvent("clearStatus", getRootElement(), thePlayer)
		removeElementData(thePlayer, "isStatusShowing")
		return
	end

	setElementData(thePlayer, "isStatusShowing", true)
	local name = getPlayerName(thePlayer)
	local message = table.concat({...}, " ")
	if string.len(message) > 90 then
		outputChatBox("#575757Valhalla:#f9f9f9 Verdiğiniz /status durumu 50 karakteri geçiyor, lütfen daha kısa bir şeyler bulun.", thePlayer, 255, 0, 0, true)
		outputChatBox("[-]#f9f9f9 Sizin girmiş olduğunuz karakter sayısı: "..string.len(message), thePlayer, 50, 255, 255, true)
		return
	end	
	
	exports["vrp_infobox"]:addBox(thePlayer, "success", "Başarılı bir şekilde /status durumunu etkinleştirdiniz.")
	local state, affectedPlayers = sendToNearByClientsStatus(thePlayer, "" .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message.."")
	return state, affectedPlayers
end
addCommandHandler("status", sendStatus)


addEvent("sendStatus", true)
addEventHandler("sendStatus", getRootElement(),
	function(message)
		return sendToNearByClientsStatus(source, "" .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message.."")
	end)

function sendToNearByClientsStatus(root, message)
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['vrp_freecam']:isPlayerFreecamEnabled(root) then return end
	
	for k, v in pairs(exports.vrp_pool:getPoolElementsByType("player")) do
		triggerClientEvent(v,"onClientStatus", root, message)
	end

end
addEvent("sendToNearByClientsStatus", true)
addEventHandler("sendToNearByClientsStatus", getRootElement(), sendToNearByClientsStatus)