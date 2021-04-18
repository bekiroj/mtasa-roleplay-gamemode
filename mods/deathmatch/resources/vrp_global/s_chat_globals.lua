MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

oocState = getElementData(getRootElement(),"globalooc:state") or 0

function getOOCState()
	return oocState
end

function setOOCState(state)
	oocState = state
	setElementData(getRootElement(),"globalooc:state", state, false)
end

function changeWarnStyle(thePlayer, commandName)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		local warnStyle = getElementData(thePlayer, "wrn:style")
		local wrnStyleString
		if warnStyle == 1 then
			warnStyle = 0
			wrnStyleString = "Style changed to chat box"
		else
			warnStyle = 1
			wrnStyleString = "Style changed to side bar"
		end
		local dbid = getElementData(thePlayer, "account:id")
		local query = dbExec(mysql:getConnection(), "UPDATE accounts SET warn_style='".. warnStyle .."' WHERE id = '" .. dbid .. "'")
		if query then
			exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "wrn:style", warnStyle)
			outputChatBox(wrnStyleString, thePlayer, 0, 255, 0)
		else
			outputChatBox("MYSQL-ERROR-0069, Please report on the mantis.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("changewarnstyle", changeWarnStyle, false, false)

--MAXIME
function sendMessageToAdmins(message,showToOffDutyAdmins)
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
			if showToOffDutyAdmins or (getElementData(thePlayer, "duty_admin") == 1) then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["vrp_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

--MAXIME
function sendMessageToSupporters(message, showToOffDutyGMs)
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if (exports.vrp_integration:isPlayerSupporter(thePlayer)) then
			if showToOffDutyGMs or getElementData(thePlayer, "duty_supporter") == 1 then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["vrp_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end

--MAXIME
function sendMessageToStaff(message,showToOffDutyStaff)
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		if exports.vrp_integration:isPlayerStaff(thePlayer) then
			if showToOffDutyStaff or getElementData(thePlayer, "duty_admin") == 1 or getElementData(thePlayer, "duty_supporter") == 1 then
				if getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3" then
					exports["vrp_reports"]:showToAdminPanel(message, thePlayer, 255,0,0)
				else
					if getElementData(thePlayer, "wrn:style") == 1 then
						triggerClientEvent(thePlayer, "sendWrnMessage", thePlayer, message)
					else
						outputChatBox(message, thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end


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
		matchPlayer = exports.vrp_pool:getElement("player", tonumber(partialNick))
		candidates = { matchPlayer }
	else -- Look for player nicks
		local players = exports.vrp_pool:getPoolElementsByType("player")
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
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Kullanıcı bulunamadı.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox( #candidates .. " players matching:", thePlayer, 255, 194, 14)
				for _, arrayPlayer in ipairs( candidates ) do
					outputChatBox("  (" .. tostring( getElementData( arrayPlayer, "playerid" ) ) .. ") " .. getPlayerName( arrayPlayer ), thePlayer, 255, 255, 0)
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



function sendLocalText(root, message, r, g, b, distance, exclude, useFocusColors, ignoreDeaths, useHex)
	if not useHex then
		useHex = false
	end
	exclude = exclude or {}
	local affectedPlayers = { }
	local x, y, z = getElementPosition(root)
	
	if getElementType(root) == "player" and exports['vrp_freecam']:isPlayerFreecamEnabled(root) then return end
	
	for index, nearbyPlayer in ipairs(getElementsByType("player")) do
		if isElement(nearbyPlayer) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < ( distance or 20 ) then
			local logged = getElementData(nearbyPlayer, "loggedin")
			if not exclude[nearbyPlayer] and (ignoreDeaths or not isPedDead(nearbyPlayer)) and logged==1 and getElementDimension(root) == getElementDimension(nearbyPlayer) then
				local r2, g2, b2 = r, g, b
				if useFocusColors then
					local focus = getElementData(nearbyPlayer, "focus")
					if type(focus) == "table" then
						for player, color in pairs(focus) do
							if player == root then
								r2, g2, b2 = unpack(color)
							end
						end
					end
				end
				
				outputChatBox(message, nearbyPlayer, r2, g2, b2, true)
				table.insert(affectedPlayers, nearbyPlayer)
			end
		end
	end
	
	if getElementType(root) == "player" and #affectedPlayers > 0 then -- TV SHOW!
		exports['vrp_freecam']:add(affectedPlayers)
	end
	return true, affectedPlayers
end
addEvent("sendLocalText", true)
addEventHandler("sendLocalText", getRootElement(), sendLocalText)

function sendLocalMeAction(thePlayer, message, fromPlayer, ignoreDeaths)
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message:gsub("#%x%x%x%x%x%x", "")
	end
	local name = getPlayerName(thePlayer) or getElementData(thePlayer, "name")
	if not fromPlayer then
		fromPlayer = thePlayer
	end
	local state, affectedPlayers = sendLocalText(thePlayer, (fromPlayer and "#B899CE ").."* " ..  string.gsub(name, "_", " ") .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message:gsub('"([^"]-)"', '#ffffff"%1#ffffff"#B899CE'), 255, 51, 102, 30, {}, true, ignoreDeaths, true)
	return state, affectedPlayers
end
addEvent("sendLocalMeAction", true)
addEventHandler("sendLocalMeAction", getRootElement(), sendLocalMeAction)

function sendLocalDoAction(thePlayer, message, ignoreDeaths)
	if string.find(message, "#%x%x%x%x%x%x") then
		message = message:gsub("#%x%x%x%x%x%x", "")
	end
	local state, affectedPlayers = sendLocalText(thePlayer, "#7EC7AA* " .. message:gsub('"([^"]-)"', '#ffffff"%1#ffffff"#7EC7AA') .. "  ((" .. getPlayerName(thePlayer):gsub("_", " ") .. "))", 255, 51, 102, 30, {}, true, ignoreDeaths)
	return state, affectedPlayers
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name") or getElementData(p, "rpp.npc.name")
	return string.gsub(name, "_", " ")
end