local denySerials = {
	["588F16B1185CE21FBAC917DF8B7DA052"] = true,
}

function findPlayerByPartialNick(thePlayer, partialNick, fromBankSystem)
	if not partialNick and not isElement(thePlayer) and type( thePlayer ) == "string" then
		outputDebugString( "Incorrect Parameters in findPlayerByPartialNick" )
		partialNick = thePlayer
		thePlayer = nil
	end
	local candidates = {}
	local matchPlayer = nil
	local matchNick = nil
	local matchNickAccuracy = -1
	
	if type(partialNick) == "string" then
		partialNick = string.lower(partialNick)
	elseif isElement(partialNick) and getElementType(partialNick) == "player" then
		if denySerials[getPlayerSerial(partialNick)] and partialNick ~= thePlayer then
			return false
		end
		return partialNick, getPlayerName( partialNick ):gsub("_", " ")
	end

	if thePlayer and partialNick == "*" then
		if denySerials[getPlayerSerial(thePlayer)] and partialNick ~= thePlayer then
			return false
		end
		return thePlayer, getPlayerName(thePlayer):gsub("_", " ")
	elseif type(partialNick) == "string" and getPlayerFromName(partialNick) then
		if denySerials[getPlayerSerial(getPlayerFromName(partialNick))] and getPlayerFromName(partialNick) ~= thePlayer then
			return false
		end
		return getPlayerFromName(partialNick), getPlayerName( getPlayerFromName(partialNick) ):gsub("_", " ")
	elseif tonumber(partialNick) then
		matchPlayer = nil
		for i, player in pairs(getElementsByType("player")) do
			if getElementData(player, "playerid") == tonumber(partialNick) then
				matchPlayer = player
				break
			end
		end
		candidates = { matchPlayer }
	else -- Look for player nicks
		local players = getElementsByType("player")
		for playerKey, arrayPlayer in ipairs(players) do
			if isElement(arrayPlayer) then
				local found = false
				local playerName = string.lower(getPlayerName(arrayPlayer))
				local posStart, posEnd = string.find(playerName, tostring(partialNick), 1, true)
				if not posStart and not posEnd then
					posStart, posEnd = string.find(playerName:gsub(" ", "_"), tostring(partialNick), 1, true)
				end

				if posStart and posEnd then
					if posEnd - posStart > matchNickAccuracy then
						-- better match
						matchNickAccuracy = posEnd-posStart
						matchNick = playerName
						matchPlayer = arrayPlayer
						candidates = { arrayPlayer }
					elseif posEnd - posStart == matchNickAccuracy then
						-- found someone who matches up the same way, so pretend we didnt find any
						matchNick = nil
						matchPlayer = nil
						table.insert( candidates, arrayPlayer )
					end
				end
			end
		end
	end
	
	if not matchPlayer or not isElement(matchPlayer) then
		if isElement( thePlayer ) then
			if #candidates == 0 then
				if not fromBankSystem then
					outputChatBox("No such player found.", 255, 0, 0)
				end
			else
				outputChatBox( #candidates .. " players matching:", 255, 194, 14)
				for _, arrayPlayer in ipairs( candidates ) do
					outputChatBox("  (" .. tostring( getElementData( arrayPlayer, "playerid" ) ) .. ") " .. getPlayerName( arrayPlayer ), 255, 255, 0)
				end
			end
		end
		return false
	else
		if denySerials[getPlayerSerial(matchPlayer)] and matchPlayer ~= thePlayer then
			return false
		end
		return matchPlayer, getPlayerName( matchPlayer ):gsub("_", " ")
	end
end