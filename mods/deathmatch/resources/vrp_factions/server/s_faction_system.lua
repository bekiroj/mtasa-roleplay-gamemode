mysql = exports.vrp_mysql

addEvent("onPlayerJoinFaction", false)
addEventHandler("onPlayerJoinFaction", getRootElement(),
	function(theTeam)
		return
	end
)

locations = { }
custom = { }

function getFactionName(factionID)
	local theTeam = getTeamFromFactionID(factionID)
	if theTeam then
		local name = getTeamName(theTeam)
		if name then
			name = tostring(name)
			return name
		end
	end
	return false
end
function getFactionType(factionID)
	local theTeam = getTeamFromFactionID(factionID)
	if theTeam then
		local ftype = tonumber(getElementData(theTeam, "type"))
		if ftype then
			return ftype
		end
	end
	return false
end

function getFactionFromName(factionName)
	for k,v in ipairs(exports.vrp_pool:getPoolElementsByType("team")) do
		if string.lower(getTeamName(v)) == string.lower(factionName) then
			return v
		end
	end
	return false
end
function getFactionIDFromName(factionName)
	local theTeam = getFactionFromName(factionName)
	if theTeam then
		local id = tonumber(getElementData(theTeam, "id"))
		if id then
			return id
		end
	end
	return false
end

function sendNotiToAllFactionMembers(fId, title, details, leaderOnly) --Maxime 2015.1.11
	local members = getAllPlayersFromFactionId(fId, true, leaderOnly)
	for i, member in ipairs(members) do
	end
end

function getTeamFromFactionID(factionID)
	if not tonumber(factionID) then
		return false
	else 
		factionID = tonumber(factionID)
	end
	return exports.vrp_pool:getElement("team", factionID)
end

function loadAllFactions(res)
	local counter = 0
	setElementData(resourceRoot, "DutyGUI", {})

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			
			Async:foreach(res,
				function(row)
					local id = tonumber(row.id)
					local name = row.name
					local money = tonumber(row.bankbalance)
					local factionType = tonumber(row.type)
					
					local theTeam = createTeam(tostring(name))
					if theTeam then
						exports.vrp_pool:allocateElement(theTeam, id)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "type", factionType, true)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "money", money, true)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "id", id, true)
						
						local factionRanks = {}
						local factionWages = {}
						for i = 1, 20 do
							factionRanks[i] = row['rank_'..i]
							factionWages[i] = tonumber(row['wage_'..i])
						end
						local motd = row.motd
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "ranks", factionRanks, true)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "wages", factionWages, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "motd", motd, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "note", row.note == nil and "" or row.note, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "fnote", row.fnote == nil and "" or row.fnote, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "phone", row.phone ~= nil and row.phone or nil, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "max_interiors", tonumber(row.max_interiors), false, true)
						setElementData(theTeam, "birlik_level", tonumber(row.level)) --Don't sync at all / Hypnos
						setElementData(theTeam, "birlik_onay", tonumber(row.onay)) --Don't sync at all / Hypnos

						custom[id] = {}
						locations[id] = {}
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									for index, row in ipairs(res) do
										local skins = fromJSON(tostring(row.skins)) or {}
										local locations = fromJSON(tostring(row.locations)) or {}
										local items = fromJSON(tostring(row.items)) or {}
										custom[id][tonumber(row.id)] = { row.id, row.name, skins, locations, items }
									end
								
								end
							end,
						mysql:getConnection(), "SELECT * FROM duty_custom WHERE factionid = ".. id .." ORDER BY id ASC")
						
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									for index, row in ipairs(res) do
										locations[id][tonumber(row.id)] = { row.id, row.name, row.x, row.y, row.z, row.radius, row.dimension, row.interior, row.vehicleid, row.model }
										if not tonumber(row.model) then
											createDutyColShape(row.x, row.y, row.z, row.radius, row.interior, row.dimension, id, row.id)
										end
									end
								end
							end,
						mysql:getConnection(), "SELECT * FROM duty_locations WHERE factionid = ".. id .." ORDER BY id ASC")
						
					end
				end,
				function()
					triggerEvent("Duty:updateDuty", root, custom)
					
					dbQuery(
						function(qh)
							local res, rows, err = dbPoll(qh, 0)
							local maxIndex = 0
							if rows > 0 then
								maxIndex = res[1].id
							end
							setElementData(resourceRoot, "maxlindex", maxIndex)
						end,
					mysql:getConnection(), "SELECT id FROM duty_locations ORDER BY id DESC LIMIT 0, 1")
					
					dbQuery(
						function(qh)
						local res, rows, err = dbPoll(qh, 0)
							local maxIndex = 0
							if rows > 0 then
								maxIndex = res[1].id
							end
							setElementData(resourceRoot, "maxcindex", maxIndex)
						end,
					mysql:getConnection(), "SELECT id FROM duty_custom ORDER BY id DESC LIMIT 0, 1")

					local citteam = createTeam("Citizen", 255, 255, 255)
					exports.vrp_pool:allocateElement(citteam, -1)
					
					setElementData(getResourceRootElement(getResourceFromName("vrp_factions")), "factionDuty", custom)
					setElementData(getResourceRootElement(getResourceFromName("vrp_factions")), "factionLocations", locations)
	
					local players = exports.vrp_pool:getPoolElementsByType("player")
					for k, thePlayer in ipairs(players) do
						if getElementData(thePlayer, "loggedin") == 1 then
							setPlayerTeam(thePlayer, exports.vrp_pool:getElement("team", (getElementData(thePlayer, "faction") or -1)) or citteam)
						end
					end
				end
			)
		end,
	mysql:getConnection(), "SELECT * FROM factions ORDER BY id ASC")
end
addEventHandler("onResourceStart", resourceRoot, loadAllFactions)

function hasPlayerAccessOverFaction(theElement, factionID)
	if (isElement(theElement)) then	-- Is the player online?
		local realFactionID = getElementData(theElement, "faction") or -1
		local factionLeaderStatus = getElementData(theElement, "factionleader") or 0
		if tonumber(realFactionID) == tonumber(factionID) then -- Is the player in the specific faction
			if tonumber(factionLeaderStatus) == 1 then -- Is the player a faction leader?
				return true
			end
		end
	end
	return false
end

function getPlayerFaction(playerName)
	local thePlayerElement = getPlayerFromName(playerName)
	local override = false
	if (thePlayerElement) then -- Player is online
		if (getElementData(thePlayerElement, "loggedin") ~= 1) then
			override = true
		else
			local playerFaction = getElementData(thePlayerElement, "faction")
			local playerFactionRank = getElementData(thePlayerElement, "factionrank")
			local playerFactionLeader = getElementData(thePlayerElement, "factionleader")
			local playerFactionPerks = getElementData(thePlayerElement, "factionPackages")
			
			return 0, playerFaction, playerFactionRank, playerFactionLeader, playerFactionPerks, thePlayerElement
		end
	end
	
	if (not thePlayerElement or override) then  -- Player is offline
		local accounts, characters = exports.vrp_account:getTableInformations()

		for index, row in ipairs(characters) do
			if row.charactername == playerName then
				return 1, tonumber(row["faction_id"]), tonumber(row["faction_rank"]), tonumber(row["faction_leader"]), (fromJSON(row["faction_perks"]) or { }), nil
			end
		end
	end
	
	return 2, -1, 20, 0, { }, nil 
end

function bindKeys()
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k, arrayPlayer in ipairs(players) do
		if not(isKeyBound(arrayPlayer, "F3", "down", showFactionMenu)) then
			bindKey(arrayPlayer, "F3", "down", showFactionMenu)
		end
	end
end

function bindKeysOnJoin()
	bindKey(source, "F3", "down", showFactionMenu)
end
addEventHandler("onResourceStart", getResourceRootElement(), bindKeys)
addEventHandler("onPlayerJoin", getRootElement(), bindKeysOnJoin)

function showFactionMenu(source)
	showFactionMenuEx(source)
end

function showFactionMenuEx(source, factionID, fromShowF)
	local logged = getElementData(source, "loggedin")
	
	if (logged==1) then
		local menuVisible = getElementData(source, "factionMenu")
		
		if (menuVisible==0) then
			local factionID = factionID or getElementData(source, "faction")
			
			if (factionID~=-1) then
				local theTeam = exports.vrp_pool:getElement("team", factionID)
				if theTeam then
					local memberUsernames = {}
					local memberRanks = {}
					local memberLeaders = {}
					local memberOnline = {}
					local memberLastLogin = {}
					local memberPerks = {}
					local factionRanks = getElementData(theTeam, "ranks")
					local factionWages = getElementData(theTeam, "wages")
					local motd = getElementData(theTeam, "motd")
					local note = hasPlayerAccessOverFaction(source, factionID) and getElementData(theTeam, "note")
					local fnote = getElementData(theTeam, "fnote")
					local vehicleIDs = {}
					local vehicleModels = {}
					local vehiclePlates = {}
					local vehicleLocations = {}
					local memberOnDuty = {}
					local phone = getElementData(theTeam, "phone")
					local memberPhones = phone and {} or nil
					if (motd == "") then motd = nil end
					dbQuery(
						function(qh, source)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								i = 1
								for index, row in ipairs(res) do
									local playerName = row.charactername
									memberUsernames[i] = playerName
									memberRanks[i] = row.faction_rank
									memberPerks[i] = type(row.faction_perks) == "string" and fromJSON(row.faction_perks) or { }
									if phone and row.faction_phone ~= nil and tonumber(row.faction_phone) then
										memberPhones[i] = ("%02d"):format(tonumber(row.faction_phone))
									end

									if (tonumber(row.faction_leader)==1) then
										memberLeaders[i] = true
									else
										memberLeaders[i] = false
									end
									
									local login = ""
									
									memberLastLogin[i] = tonumber(row.lastlogin)
									if getPlayerFromName(playerName) then
										local testingPlayer = getPlayerFromName(playerName)
										local onlineState = getElementData(testingPlayer, "loggedin")
										if (onlineState == 1) then
											memberOnline[i] = true
											
											local dutydata = getElementData(testingPlayer, "duty")
											if dutydata then
												if(tonumber(dutydata) > 0) then
													memberOnDuty[i] = true
												else
													memberOnDuty[i] = false	
												end
											end
										end
									else
										memberOnline[i] = false
										memberOnDuty[i] = false
									end
									i = i + 1
								end
								j = 1
								for index, value in ipairs(getElementsByType("vehicle")) do
									if value and isElement(value) and tonumber(value:getData("faction")) == tonumber(factionID) then
										vehicleIDs[j] = value:getData("dbid")
										vehiclePlates[j] = value:getData("plate") or getVehiclePlateText(value)
										local veh = exports.vrp_pool:getElement("vehicle", value:getData("dbid"))
										vehicleModels[j] = exports.vrp_global:getVehicleName(veh)
										if exports.vrp_global:hasItem(veh, 139) and getElementDimension(veh) == 0 and getElementInterior(veh) == 0 then
											vehicleLocations[j] = exports.vrp_global:getElementZoneName(veh) 
										else
											vehicleLocations[j] = "Bilinmiyor"
										end
										j = j + 1
									end
								end
								local theTeam = exports.vrp_pool:getElement("team", factionID)
								local birlikLevel = getElementData(theTeam, "birlik_level")
								local birlikOnay = getElementData(theTeam, "birlik_onay")
								setElementData(source, "factionMenu", 1, false)
								triggerClientEvent(source, "showFactionMenu", source, motd, memberUsernames, memberRanks, hasPlayerAccessOverFaction(source, factionID) and memberPerks or {}, memberLeaders, memberOnline, memberLastLogin, factionRanks,  factionWages, theTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, memberPhones, fromShowF, factionID, birlikLevel, birlikOnay, custom[tonumber(factionID)])
								
							end
						end,
					{source}, mysql:getConnection(), "SELECT charactername,  faction_rank, faction_perks, faction_leader, faction_phone, DATEDIFF(NOW(), lastlogin) AS lastlogin FROM characters WHERE faction_ID='" .. factionID .. "' ORDER BY faction_rank DESC, charactername ASC")
				end
			else
				outputChatBox("#575757Valhalla: #f4f4f4Herhangi bir birlikte bulunmuyorsunuz.", source, 255, 0, 0, true)
			end
		else
			triggerClientEvent(source, "hideFactionMenu", source)
		end
	end
end

-- // CALL BACKS FROM CLIENT GUI
function callbackUpdateRanks(ranks, wages)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	for key, value in ipairs(ranks) do
		ranks[key] = (ranks[key])
	end
	
	if (wages) then
		for i = 1, 20 do
			wages[i] = math.min(2500, math.max(0, tonumber(wages[i]) or 0))
		end
		
		dbExec(mysql:getConnection(), "UPDATE factions SET wage_1='" .. wages[1] .. "', wage_2='" .. wages[2] .. "', wage_3='" .. wages[3] .. "', wage_4='" .. wages[4] .. "', wage_5='" .. wages[5] .. "', wage_6='" .. wages[6] .. "', wage_7='" .. wages[7] .. "', wage_8='" .. wages[8] .. "', wage_9='" .. wages[9] .. "', wage_10='" .. wages[10] .. "', wage_11='" .. wages[11] .. "', wage_12='" .. wages[12] .. "', wage_13='" .. wages[13] .. "', wage_14='" .. wages[14] .. "', wage_15='" .. wages[15] .. "', wage_16='" .. wages[16] .. "', wage_17='" .. wages[17] .. "', wage_18='" .. wages[18] .. "', wage_19='" .. wages[19] .. "', wage_20='" .. wages[20] .. "' WHERE id='" .. factionID .. "'")
		exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "wages", wages, false)
	end
	
	dbExec(mysql:getConnection(), "UPDATE factions SET rank_1='" .. ranks[1] .. "', rank_2='" .. ranks[2] .. "', rank_3='" .. ranks[3] .. "', rank_4='" .. ranks[4] .. "', rank_5='" .. ranks[5] .. "', rank_6='" .. ranks[6] .. "', rank_7='" .. ranks[7] .. "', rank_8='" .. ranks[8] .. "', rank_9='" .. ranks[9] .. "', rank_10='" .. ranks[10] .. "', rank_11='" .. ranks[11] .. "', rank_12='" .. ranks[12] .. "', rank_13='" .. ranks[13] .. "', rank_14='" .. ranks[14] .. "', rank_15='" .. ranks[15] .. "', rank_16='" .. ranks[16] .. "', rank_17='" .. ranks[17] .. "', rank_18='" .. ranks[18] .. "', rank_19='" .. ranks[19] .. "', rank_20='" .. ranks[20] .. "' WHERE id='" .. factionID .. "'")
	exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "ranks", ranks, false)
	
	outputChatBox("Faction information updated successfully.", source, 0, 255, 0)
	showFactionMenu(source)
end
addEvent("cguiUpdateRanks", true )
addEventHandler("cguiUpdateRanks", getRootElement(), callbackUpdateRanks)


function callbackRespawnVehicles()
	local theTeam = getPlayerTeam(source)
	
	local factionCooldown = getElementData(theTeam, "cooldown")
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
		
	if not (factionCooldown) then
		for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("vehicle")) do
			local faction = getElementData(value, "faction")
			if (faction == factionID and not getVehicleOccupant(value, 0) and not getVehicleOccupant(value, 1) and not getVehicleOccupant(value, 2) and not getVehicleOccupant(value, 3) and not getVehicleTowingVehicle(value)) then
				respawnVehicle(value)
				setElementInterior(value, getElementData(value, "interior"))
				setElementDimension(value, getElementData(value, "dimension"))
				setVehicleLocked(value, true)
			end
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		local username = getPlayerName(source)
		for k, v in ipairs(teamPlayers) do
			outputChatBox(username:gsub("_"," ") .. " respawned all unoccupied faction vehicles.", v, 255, 194, 14)
		end

		setTimer(resetFactionCooldown, 60000, 1, theTeam)
		exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "cooldown", true, false)
	else
		outputChatBox("You currently cannot respawn your factions vehicles, Please wait a while.", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnVehicles", true )
addEventHandler("cguiRespawnVehicles", getRootElement(), callbackRespawnVehicles)

function resetFactionCooldown(theTeam)
	exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "cooldown")
end

function callbackRespawnOneVehicle(vehicleID)
	local theTeam = getPlayerTeam(source)
	local theTeamID = getElementData(theTeam, "id")
	local theVehicle = exports.vrp_pool:getElement("vehicle", tonumber(vehicleID))
	if not hasPlayerAccessOverFaction(source, theTeamID) then
		outputChatBox("Not allowed, sorry.", source, 255, 0, 0)
		return
	end
	if theVehicle then
		local theVehicleID = getElementData(theVehicle, "faction")
		if (theTeamID == theVehicleID and not getVehicleOccupant(theVehicle, 0) and not getVehicleOccupant(theVehicle, 1) and not getVehicleOccupant(theVehicle, 2) and not getVehicleOccupant(theVehicle, 3) and not getVehicleTowingVehicle(theVehicle)) then
			if isElementAttached(theVehicle) then
				detachElements(theVehicle)
			end
			exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, 'i:left')
			exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, 'i:right')
			exports.vrp_logs:dbLog(source, 6, theVehicle, "FACTIONRESPAWN")
			respawnVehicle(theVehicle)
			setElementInterior(theVehicle, getElementData(theVehicle, "interior"))
			setElementDimension(theVehicle, getElementData(theVehicle, "dimension"))
			setVehicleLocked(theVehicle, true)
			outputChatBox("Vehicle Respawned.", source, 0, 255, 0)
			local teamPlayers = getPlayersInTeam(theTeam)
			local playerName = getPlayerName(source)
			for k, v in ipairs(teamPlayers) do
				outputChatBox(playerName:gsub("_"," ") .. " respawned faction vehicle " .. vehicleID ..".", v, 255, 194, 14)
			end
		else
			outputChatBox("That vehicle is currently occupied.", source, 255, 0, 0)
		end
	else
		outputChatBox("Please select a vehicle you wish to respawn.", source, 255, 0, 0)
	end
end
addEvent("cguiRespawnOneVehicle", true)
addEventHandler("cguiRespawnOneVehicle", getRootElement(), callbackRespawnOneVehicle)

function callbackUpdateMOTD(motd)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET motd='" .. tostring((motd)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You changed your faction's MOTD to '" .. motd .. "'", client, 0, 255, 0)
			exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "motd", motd, false)
		else
			outputChatBox("Error 300000 - Report on Forums.", client, 255, 0, 0)
		end
	end
end
addEvent("cguiUpdateMOTD", true )
addEventHandler("cguiUpdateMOTD", getRootElement(), callbackUpdateMOTD)

function callbackUpdateNote(note)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) or not note then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET note='" .. tostring((note)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You successfully changed your faction's leader note.", client, 0, 255, 0)
			exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "note", note, false)
		else
			outputChatBox("Error 30000A - Report on mantis.", client, 255, 0, 0)
		end
	end
end
addEvent("faction:note", true )
addEventHandler("faction:note", getRootElement(), callbackUpdateNote)

function callbackUpdateFNote(fnote)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) or not fnote then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local theTeam = getPlayerTeam(client)
	if (factionID~=-1) then
		if dbExec(mysql:getConnection(), "UPDATE factions SET fnote='" .. tostring((fnote)) .. "' WHERE id='" .. factionID .. "'") then
			outputChatBox("You successfully changed your faction's faction-wide note.", client, 0, 255, 0)
			exports.vrp_anticheat:changeProtectedElementDataEx(theTeam, "fnote", fnote, false)
		else
			outputChatBox("Error 30000B - Report on mantis.", client, 255, 0, 0)
		end
	end
end
addEvent("faction:fnote", true )
addEventHandler("faction:fnote", getRootElement(), callbackUpdateFNote)

function callbackRemovePlayer(removedPlayerName)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end

	local targetFactionInfo = {getPlayerFaction(removedPlayerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Newp, not going to happen, sorry.", client)
		return
	end
	
	if dbExec(mysql:getConnection(), "UPDATE characters SET faction_id='-1', faction_leader='0', faction_rank='1', duty = 0 WHERE charactername='" .. (removedPlayerName) .. "'") then
		local theTeam = getPlayerTeam(client)
		local theTeamName = "None"
		if (theTeam) then
			theTeamName = getTeamName(theTeam)
		end
		
		local username = getPlayerName(client)
		

		local removedPlayer = getPlayerFromName(removedPlayerName)
		if (removedPlayer) then -- Player is online
			if (getElementData(client, "factionMenu")==1) then
				triggerClientEvent(removedPlayer, "hideFactionMenu", getRootElement())
			end
			outputChatBox(username:gsub("_"," ").. " removed you from the faction '" .. tostring(theTeamName) .. "'", removedPlayer, 255, 0, 0)
			setPlayerTeam(removedPlayer, getTeamFromName("Citizen"))
			exports.vrp_anticheat:changeProtectedElementDataEx(removedPlayer, "faction", -1, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(removedPlayer, "factionleader", 0, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "factionleader", 0, false)
			triggerEvent("duty:offduty", removedPlayer)
			--triggerClientEvent(removedPlayer, "updateFactionInfo", removedPlayer, -1, 1)
		end
		
		-- Send message to everyone in the faction
		local teamPlayers = getPlayersInTeam(theTeam)
		for k, v in ipairs(teamPlayers) do
			if (v ~= removedPlayer) then
				outputChatBox(username:gsub("_"," ") .. " kicked " .. removedPlayerName:gsub("_", " ") .. " from faction '" .. tostring(theTeamName) .. "'.", v, 255, 194, 14)
			end
		end

	else
		outputChatBox("Failed to remove " .. removedPlayerName:gsub("_", " ") .. " from the faction, Contact an admin.", source, 255, 0, 0)
	end
end
addEvent("cguiKickPlayer", true )
addEventHandler("cguiKickPlayer", getRootElement(), callbackRemovePlayer)

function callbackPerkEdit( perkIDTable, playerName)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Newp, not going to happen, sorry.", client)
		return
	end
	
	local jsonPerkIDTable = toJSON( perkIDTable )
	if dbExec(mysql:getConnection(), "UPDATE `characters` SET `faction_perks`='" .. (jsonPerkIDTable) .. "' WHERE `charactername`='" .. (playerName) .. "'") then
		outputChatBox(" Duty perks updated for "..playerName:gsub("_", " ")..".", client, 255, 0, 0)
		local targetPlayer = getPlayerFromName(playerName)
		if targetPlayer then
			setElementData(targetPlayer, "factionPackages", perkIDTable)
			outputChatBox(" Your duty perks have been updated by "..getPlayerName(client):gsub("_", " ") .. ".", targetPlayer, 255, 0, 0)
		end
	end
end
addEvent("faction:perks:edit", true)
addEventHandler("faction:perks:edit", getRootElement(), callbackPerkEdit)


function callbackToggleLeader(playerName, isLeader)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Newp, not going to happen, sorry.", client)
		return
	end
	
	if (isLeader) then -- Make player a leader
		local username = getPlayerName(client)
		if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader='1' WHERE charactername='" .. (playerName) .. "'") then

			-- Send message to everyone in the faction
			--exports.vrp_factions:sendNotiToAllFactionMembers(factionID, username:gsub("_", " ") .. " promoted " .. playerName:gsub("_", " ") .. " to leader of your faction '"..getTeamName(theTeam).."'.")
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "factionleader", 1, true)
			end
		else
			outputChatBox("Failed to promote " .. removedPlayerName:gsub("_", " ") .. " to faction leader, Contact an admin.", client, 255, 0, 0)
		end
	else
		local username = getPlayerName(client)
		if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader='0' WHERE charactername='" .. (playerName) .. "'") then
			
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				if (getElementData(client, "factionMenu")==1) then
					triggerClientEvent(thePlayer, "hideFactionMenu", getRootElement())
				end
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "factionleader", 0, true)
			end
			
			-- Send message to everyone in the faction
		--exports.vrp_factions:sendNotiToAllFactionMembers(factionID, username:gsub("_", " ") .. " demoted " .. playerName:gsub("_", " ") .. " from leader to member of your faction '"..getTeamName(theTeam).."'.")
		else
			outputChatBox("Failed to demote " .. removedPlayerName:gsub("_", " ") .. " from faction leader, Contact an admin.", client, 255, 0, 0)
		end
	end
end
addEvent("cguiToggleLeader", true )
addEventHandler("cguiToggleLeader", getRootElement(), callbackToggleLeader)

function callbackPromotePlayer(playerName, rankNum, oldRank, newRank)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Newp, not going to happen, sorry.", client)
		return
	end
	
	local username = getPlayerName(client)
	if dbExec(mysql:getConnection(), "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. (playerName) .. "'") then
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, set his rank
			exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "factionrank", rankNum, false)
		end
		
		-- Send message to everyone in the faction
		--exports.vrp_factions:sendNotiToAllFactionMembers(factionID, playerName:gsub("_", " ") .. " was promoted from '" .. oldRank .. "' to '" .. newRank .. "' by "..username:gsub("_", " ").." of '"..getTeamName(theTeam).."'")
	else
		outputChatBox("Failed to promote " .. removedPlayerName:gsub("_", " ") .. " in the faction, Contact an admin.", client, 255, 0, 0)
	end
end
addEvent("cguiPromotePlayer", true )
addEventHandler("cguiPromotePlayer", getRootElement(), callbackPromotePlayer)

function callbackDemotePlayer(playerName, rankNum, oldRank, newRank)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	local targetFactionInfo = {getPlayerFaction(playerName)}
	if targetFactionInfo[2] ~= factionID then
		outputChatBox("Newp, not going to happen, sorry.", client)
		return
	end
	
	local username = getPlayerName(client)
	local safename = (playerName)
	
	if dbExec(mysql:getConnection(), "UPDATE characters SET faction_rank='" .. rankNum .. "' WHERE charactername='" .. safename .. "'") then
		local thePlayer = getPlayerFromName(playerName)
		if(thePlayer) then -- Player is online, tell them
			exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "factionrank", rankNum, false)
		end
		
		-- Send message to everyone in the faction
		--exports.vrp_factions:sendNotiToAllFactionMembers(factionID, playerName:gsub("_", " ") .. " was demoted from '" .. oldRank .. "' to '" .. newRank .. "' by "..username:gsub("_", " ").." of '"..getTeamName(theTeam).."'")
	else
		outputChatBox("Failed to demote " .. removedPlayerName .. " in the faction, Contact an admin.", client, 255, 0, 0)
	end
end
addEvent("cguiDemotePlayer", true )
addEventHandler("cguiDemotePlayer", getRootElement(), callbackDemotePlayer)

function callbackQuitFaction()
	local username = getPlayerName(client)
	local safename = (username)
	local theTeam = getPlayerTeam(client)
	local theTeamName = getTeamName(theTeam)

	if theTeamName == "Los Santos Bus & Cab" then
		executeCommandHandler("quitjob", client)	
	elseif dbExec(mysql:getConnection(), "UPDATE characters SET faction_id='-1', faction_leader='0', duty = 0, faction_perks='{}' WHERE charactername='" .. safename .. "'") then
		exports["vrp_infobox"]:addBox(client, "success","'" .. theTeamName .. "' isimli birlikten çıkış yaptın.")
		exports.vrp_global:takeItem(client, 87)
		exports.vrp_global:takeItem(client, 87)
		exports.vrp_global:takeItem(client, 87)
		exports.vrp_global:takeItem(client, 86)
		exports.vrp_global:takeItem(client, 86)
		exports.vrp_global:takeItem(client, 86)
		exports.vrp_global:takeItem(client, 64)
		exports.vrp_global:takeItem(client, 64)
		exports.vrp_global:takeItem(client, 64)
		local newTeam = getTeamFromName("Citizen")
		setPlayerTeam(client, newTeam)
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "faction", -1, false)
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionrank", 1, false)
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionleader", 0, false)
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionphone", nil, false)
		exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionPackages", {}, false)
		triggerEvent("duty:offduty", client)
		local factionID = getElementData(theTeam, "id")
	else
		outputChatBox("Birlikten çıkış yapamadın, bir yetkiliyle iletişime geç.", client, 255, 0, 0)
	end
end
addEvent("cguiQuitFaction", true )
addEventHandler("cguiQuitFaction", getRootElement(), callbackQuitFaction)

function callbackInvitePlayer(invitedPlayer)
	local theTeam = getPlayerTeam(client)
	local factionID = getElementData(theTeam, "id")
	if not hasPlayerAccessOverFaction(client, factionID) then
		outputChatBox("Not allowed, sorry.", client)
		return
	end
	
	
	local invitedPlayerNick = getPlayerName(invitedPlayer)
	local safename = (invitedPlayerNick)
	
	local targetTeam = getPlayerTeam(invitedPlayer)
	if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
		outputChatBox("Player is already in a faction.", client, 255, 0, 0)
		return
	end
	
	if dbExec(mysql:getConnection(), "UPDATE characters SET faction_leader = 0, faction_id = " .. factionID .. ", faction_rank = 1 WHERE charactername='" .. safename .. "'") then
		local theTeam = getPlayerTeam(client)
		local theTeamName = getTeamName(theTeam)
		
		local targetTeam = getPlayerTeam(invitedPlayer)
		if (targetTeam~=nil) and (getTeamName(targetTeam)~="Citizen") then
			outputChatBox("Player is already in a faction.", client, 255, 0, 0)
		else
			setPlayerTeam(invitedPlayer, theTeam)
			exports.vrp_anticheat:changeProtectedElementDataEx(invitedPlayer, "faction", factionID, false)
			outputChatBox("Player " .. invitedPlayerNick:gsub("_", " ") .. " is now a member of faction '" .. tostring(theTeamName) .. "'.", client, 0, 255, 0)			
			if	(invitedPlayer) then
				triggerEvent("onPlayerJoinFaction", invitedPlayer, theTeam)
				exports.vrp_anticheat:changeProtectedElementDataEx(invitedPlayer, "factionrank", 1, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionphone", nil, false)
				outputChatBox("You were set to Faction '" .. tostring(theTeamName) .. "'.", invitedPlayer, 255, 194, 14)
			end
		end
	else
		outputChatBox("Player is already in a faction.", client, 255, 0, 0)
	end
end
addEvent("cguiInvitePlayer", true )
addEventHandler("cguiInvitePlayer", getRootElement(), callbackInvitePlayer)

function hideFactionMenu()
	exports.vrp_anticheat:changeProtectedElementDataEx(client, "factionMenu", 0, false)
end
addEvent("factionmenu:hide", true)
addEventHandler("factionmenu:hide", getRootElement(), hideFactionMenu)

function getFactionFinance(factionID)
	if not factionID then factionID = getElementData(client, "faction") end

	if hasPlayerAccessOverFaction(client, factionID) then
		local bankThisWeek = {}
		local bankPrevWeek = {}
		local transactions = {}
		local vehicles = {}
		local mostRecentWeek = 0
		local currentWeek = 0
		dbQuery(
			function(qh, client)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						local id = tonumber(row["id"])
						local amount = tonumber(row["amount"])
						local time = row["newtime"]
						local week = tonumber(row["week"])
						currentWeek = tonumber(row["currentWeek"])
						if week > mostRecentWeek then mostRecentWeek = week end
						if not transactions[week] then transactions[week] = {} end
						local type = tonumber(row["type"])
						local reason = row["reason"]
						if reason == nil then
							reason = ""
						end
						
						local from, to = "-", "-"
						if row["characterfrom"] then
							from = row["characterfrom"]:gsub("_", " ")
						elseif tonumber(row["from"]) then
							num = tonumber(row["from"]) 
							if num < 0 then
								from = getTeamName(exports.vrp_pool:getElement("team", -num)) or "-"
							elseif num == 0 and ( type == 6 or type == 7 ) then
								from = "Government"
							end
						end
						if row["characterto"] ~= nil then
							to = row["characterto"]:gsub("_", " ")
						elseif tonumber(row["to"]) and tonumber(row["to"]) < 0 then
							to = getTeamName(exports.vrp_pool:getElement("team", -tonumber(row["to"])))
						end
						
						if tostring(row["from"]) == tostring(-factionID) and amount > 0 then
							amount = amount - amount - amount
						end

						table.insert(transactions[week], { id = id, amount = amount, time = time, type = type, from = from, to = to, reason = reason, week = week })
					end
				end
				bankThisWeek = transactions[currentWeek] or {}
				bankPrevWeek = transactions[currentWeek-1] or {}

				local faction = getPlayerTeam(client)
				local bankmoney = exports.vrp_global:getMoney(faction)

	
				dbQuery(
					function(qh, client)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, row in ipairs(res) do
								local vehicleShopID = tonumber(row["vehicle_shop_id"])
								if vehicleShopID > 0 then
									table.insert(vehicles, vehicleShopID)
								end
							end
						end
						local vehiclesvalue = 0
						if not vehPrice then vehPrice = {} end
						for k,v in ipairs(vehicles) do
							if vehPrice[v] then
								local price = tonumber(vehPrice[v]) or 0
								vehiclesvalue = vehiclesvalue + price
								triggerClientEvent(client, "factionmenu:fillFinance", getResourceRootElement(), factionID, bankThisWeek, bankPrevWeek, bankmoney, vehiclesvalue)

							else
								dbQuery(
									function(qh, client)
										local res, rows, err = dbPoll(qh, 0)
										if rows > 0 then
											for index, row in ipairs(res) do
												local price = tonumber(row["vehprice"]) or 0
												vehPrice[v] = price
												vehiclesvalue = vehiclesvalue + price
											end
										end
										triggerClientEvent(client, "factionmenu:fillFinance", getResourceRootElement(), factionID, bankThisWeek, bankPrevWeek, bankmoney, vehiclesvalue)
									end,
								{client}, mysql:getConnection(), "SELECT vehprice FROM vehicles_shop WHERE id='"..(tostring(v)).."'")
							
							end
						end
					end,
				{client}, mysql:getConnection(), "SELECT vehicle_shop_id FROM vehicles WHERE faction='" .. (tostring(factionID)) .. "' AND deleted=0 AND chopped=0")
			end,
		{client}, mysql:getConnection(), "SELECT w.*, a.charactername as characterfrom, b.charactername as characterto,w.`time` - INTERVAL 1 hour as 'newtime', WEEKOFYEAR(w.`time` - INTERVAL 1 hour) as 'week', WEEKOFYEAR(CURDATE() - INTERVAL 1 hour) as 'currentWeek' FROM wiretransfers w LEFT JOIN characters a ON a.id = `from` LEFT JOIN characters b ON b.id = `to` WHERE ( `from` = '" .. (tostring(-factionID)) .. "' OR `to` = '" .. (tostring(-factionID)) .. "' ) ORDER BY id DESC")
	end
end
addEvent("factionmenu:getFinance", true)
addEventHandler("factionmenu:getFinance", getResourceRootElement(), getFactionFinance)


addEvent('factionmenu:setphone', true)
addEventHandler('factionmenu:setphone', root,
	function(playerName, number)
		local theTeam = getPlayerTeam(client)
		local factionID = getElementData(theTeam, "id")
		if not hasPlayerAccessOverFaction(client, factionID) then
			outputChatBox("Not allowed, sorry.", client)
			return
		end
		
		local targetFactionInfo = {getPlayerFaction(playerName)}
		if targetFactionInfo[2] ~= factionID then
			outputChatBox("Newp, not going to happen, sorry.", client)
			return
		end
		
		local username = getPlayerName(client)
		local safename = (playerName)
		
		if dbExec(mysql:getConnection(), "UPDATE characters SET faction_phone=" .. (tonumber(number) or "NULL") .. " WHERE charactername='" .. safename .. "'") then
			local thePlayer = getPlayerFromName(playerName)
			if(thePlayer) then -- Player is online, tell them
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "factionphone", tonumber(number) or nil, false)
			end
		end
	end)

function isLeapYear(year)
	return year%4==0 and (year%100~=0 or year%400==0)
end
local lastDayOfMonth = {31,28,31,30,31,30,31,31,30,31,30,31}
function fromDatetime(string)
	local split1 = exports.vrp_global:split(string, " ")
	local date = split1[1]
	local time = split1[2]

	local datesplit = exports.vrp_global:split(date, "-")
	local year = tonumber(datesplit[1])
	local month = tonumber(datesplit[2])
	local day = tonumber(datesplit[3])

	local timesplit = exports.vrp_global:split(date, ":")
	local hour = tonumber(timesplit[1])
	local minute = tonumber(timesplit[2])
	local second = tonumber(timesplit[3])

	--calculate yearday
	local prevdays = 0
	local addmonth = 1
	while true do
		if addmonth >= month then break end
		if addmonth == 2 and isLeapYear(year) then
			prevdays = prevdays + lastDayOfMonth[addmonth] + 1
		else
			prevdays = prevdays + lastDayOfMonth[addmonth]
		end
		addmonth = addmonth + 1
	end
	local yearday = prevdays + day

	local time = { year = year, month = month, day = day, hour = hour, minute = minute, second = second, yearday = yearday }
	return time
end
function getWeekNumFromYearDay(yearday)
	local weekNum = math.floor(yearday / 7)
	return weekNum
end

-- Hypnos'nın kıymetli elleri tarafından tamamiyle düzenlendi.

addEvent("fetchDutyInfo", true)
addEventHandler("fetchDutyInfo", resourceRoot, function(factionID)
	if not factionID then factionID = getElementData(client, "faction") end

	local elementInfo = getElementData(resourceRoot, "DutyGUI")
	elementInfo[client] = factionID
	setElementData(resourceRoot, "DutyGUI", elementInfo)

	triggerClientEvent(client, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID)
end)

addEvent("Duty:Grab", true)
addEventHandler("Duty:Grab", resourceRoot, function(factionID)
	if not factionID then factionID = getElementData(client, "faction") end

	local t = getAllowList(factionID)

	triggerClientEvent(client, "gotAllow", resourceRoot, t)
end)

addEvent("Duty:GetPackages", true)
addEventHandler("Duty:GetPackages", resourceRoot, function(factionID)
	factionID = tonumber(factionID)

	triggerClientEvent(client, "Duty:GotPackages", resourceRoot, custom[factionID])

	end)

function refreshClient(message, factionID, dontSendToClient)
	for k,v in pairs(getElementData(resourceRoot, "DutyGUI")) do
		if dontSendToClient then
			if v == factionID and k~=dontSendToClient then
				triggerClientEvent(k, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID, message)
			end
		else
			if v == factionID then
				triggerClientEvent(k, "importDutyData", resourceRoot, custom[tonumber(factionID)], locations[tonumber(factionID)], factionID, message)
			end
		end
	end
	local resource = getResourceRootElement(getResourceFromName("vrp_factions"))
	if resource then
		setElementData(resource, "factionDuty", custom)
		setElementData(resource, "factionLocations", locations)
	end
end

function disconnectThem()
	local t = getElementData(resourceRoot, "DutyGUI") 
	t[source] = nil
	setElementData(resourceRoot, "DutyGUI", t)
end
addEventHandler("onPlayerQuit", getRootElement(), disconnectThem)

function addDuty(dutyItems, finalLocations, dutyNewSkins, name, factionID, dutyID)
	local dutyItems = dutyItems or {}
	local finalLocations = finalLocations or {}
	local dutyNewSkins = dutyNewSkins or {}
	if dutyID == 0 then
		local index = getElementData(resourceRoot, "maxcindex")+1
		dbExec(mysql:getConnection(), "INSERT INTO duty_custom SET id="..index..", factionID="..(factionID)..", name='"..(name).."', skins='"..(toJSON(dutyNewSkins)).."', locations='"..(toJSON(finalLocations)).."', items='"..(toJSON(dutyItems)).."'")
		setElementData(resourceRoot, "maxcindex", index)
		custom[tonumber(factionID)][index] = { index, name, dutyNewSkins, finalLocations, dutyItems }
		refreshClient("> "..getPlayerName(client):gsub("_", " ")..": Added duty '"..name.."'.", factionID, false)
		exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Added duty "..name.." Database ID #"..index)
	else
		dbExec(mysql:getConnection(), "UPDATE duty_custom SET name='"..(name).."', skins='"..(toJSON(dutyNewSkins)).."', locations='"..(toJSON(finalLocations)).."', items='"..(toJSON(dutyItems)).."' WHERE id="..dutyID)
		table.remove(custom[tonumber(factionID)], dutyID)
		custom[tonumber(factionID)][dutyID] = { dutyID, name, dutyNewSkins, finalLocations, dutyItems }
		refreshClient("> "..getPlayerName(client):gsub("_", " ")..": Revised duty ID #"..dutyID..".", factionID, false)
		exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Revised duty "..name.." Database ID #"..dutyID)
	end
end
addEvent("Duty:AddDuty", true)
addEventHandler("Duty:AddDuty", resourceRoot, addDuty)

function addLocation(x, y, z, r, i, d, name, factionID, index)
	local interiorElement = exports.vrp_pool:getElement("interior", d) or d == 0
	if interiorElement then
		local interiorF = 0
		if isElement(interiorElement) then
			interiorStatus = getElementData(interiorElement, "status")
			interiorF = interiorStatus[7]
		end

		if tonumber(interiorF) == tonumber(factionID) or d == 0 then
			if not index then -- Index is used if the event is from a edit
				local newIndex = getElementData(resourceRoot, "maxlindex")+1
				dbExec(mysql:getConnection(), "INSERT INTO duty_locations SET id="..newIndex..", factionID="..(factionID)..", name='".. (name) .."', x="..(x)..", y="..(y)..", z="..(z)..", radius="..(r)..", dimension="..(d)..", interior="..(i))
				setElementData(resourceRoot, "maxlindex", newIndex)
				createDutyColShape(x, y, z, r, i, d, factionID, newIndex)
				locations[tonumber(factionID)][newIndex] = { newIndex, name, x, y, z, r, d, i, nil, nil }
				refreshClient("> "..getPlayerName(client):gsub("_", " ")..": Added location '"..name.."'.", factionID, false)
				exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Added location, Name:"..name.." Database ID:"..newIndex.." x:"..x.." y:"..y.." z:"..z.." radius:"..r.." interior:"..i.." dimension:"..d)
			else
				dbExec(mysql:getConnection(), "UPDATE duty_locations SET name='".. (name) .."', x="..(x)..", y="..(y)..", z="..(z)..", radius="..(r)..", dimension="..(d)..", interior="..(i).." WHERE id="..index)
				table.remove(locations[factionID], index)
				destroyDutyColShape(factionID, index)
				createDutyColShape(x, y, z, r, i, d, factionID, index)
				locations[tonumber(factionID)][index] = { index, name, x, y, z, r, d, i, nil, nil }
				refreshClient("> "..getPlayerName(client):gsub("_", " ")..": Revised location ID #"..index..".", factionID, false)
				exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Revised location ID #"..index.." x:"..x.." y:"..y.." z:"..z.." radius:"..r.." interior:"..i.." dimension:"..d)
			end
		else
			outputChatBox("The interior you entered must be owned by the faction to be added as a duty location.", client, 255, 0, 0)
		end
	else
		outputChatBox("Server could not find the interior you entered!", client, 255, 0, 0)
	end
end
addEvent("Duty:AddLocation", true)
addEventHandler("Duty:AddLocation", resourceRoot, addLocation)

function addVehicle(vehicleID, factionID)
	local element = exports.vrp_pool:getElement("vehicle", vehicleID)
	if element then
		if getElementData(element, "faction") == factionID then
		    local newIndex = getElementData(resourceRoot, "maxlindex")+1
			dbExec(mysql:getConnection(), "INSERT INTO duty_locations SET id="..newIndex..", factionID="..(factionID)..", name='VEHICLE', vehicleid="..(vehicleID)..", model="..getElementModel(element))
			setElementData(resourceRoot, "maxlindex", newIndex)
			locations[tonumber(factionID)][newIndex] = { newIndex, "VEHICLE", nil, nil, nil, nil, nil, nil, tonumber(vehicleID), getElementModel(element) }
			refreshClient("> "..getPlayerName(client):gsub("_", " ")..": Added vehicle #"..vehicleID..".", factionID, false)
			exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Added Vehicle #"..vehicleID.." Database ID:"..newIndex)
			--outputChatBox("Added vehicle "..vehicleID.." successfully.", client, 0, 255, 0)
		else
			outputChatBox("You can only add faction vehicles as duty locations.", client, 255, 0, 0)
		end
	else
		outputChatBox("Error finding your vehicle, did you type the ID in right?", client, 255, 0, 0)
	end
end
addEvent("Duty:AddVehicle", true)
addEventHandler("Duty:AddVehicle", resourceRoot, addVehicle)

function removeLocation(removeID, factionID)
	locations[tonumber(factionID)][tonumber(removeID)] = nil
	destroyDutyColShape(factionID, removeID)
	dbExec(mysql:getConnection(), "DELETE FROM duty_locations WHERE id="..removeID)
	exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Removed Location #"..removeID)
	--outputChatBox("Duty Location removed!", client, 0, 255, 0)

	refreshClient("> "..getPlayerName(client):gsub("_", " ")..": removed location "..removeID..".", factionID, client)
end
addEvent("Duty:RemoveLocation", true)
addEventHandler("Duty:RemoveLocation", resourceRoot, removeLocation)

function removeDuty(removeID, factionID)
	custom[tonumber(factionID)][tonumber(removeID)] = nil
	dbExec(mysql:getConnection(), "DELETE FROM duty_custom WHERE id="..removeID)
	exports.vrp_logs:dbLog(client, 35, "fa"..tostring(factionID), "Removed duty #"..removeID)
	--outputChatBox("Custom Duty Loadout removed!", client, 0, 255, 0)

	refreshClient("> "..getPlayerName(client):gsub("_", " ")..": removed duty "..removeID..".", factionID, client)
end
addEvent("Duty:RemoveDuty", true)
addEventHandler("Duty:RemoveDuty", resourceRoot, removeDuty)

function factionActive(thePlayer, commandName)
			takim = tonumber(getElementData(thePlayer, "faction"))
			if takim and takim > 0 then
				local takimveri = exports.vrp_pool:getElement("team", takim)
				local takimisim = getTeamName(takimveri)
				local takimoyunculari = getPlayersInTeam(takimveri)
				
				if #takimoyunculari == 0 then
					outputChatBox("#575757 Valhalla:#b9c9bf".. takimisim .."' maalesef oluşumunda hiç çevrimiçi oyuncu bulamadım.", thePlayer, 255, 255, 255, true)
				else
					local takimrutbe = getElementData(takimveri, "ranks")
					outputChatBox("'".. takimisim .."' oluşumunda bulunan çevrimiçi üyeler:", thePlayer, 255, 255, 255, true)
					for k, takimoyuncular in ipairs(takimoyunculari) do
						local oyuncurutbe = takimrutbe [ getElementData(takimoyuncular, "factionrank") ]
						outputChatBox("#575757 Valhalla: #b9c9bf  Karakter : #FFFFFF".. getPlayerName(takimoyuncular) .." #b9c9bf Rütbe : #FFFFFF".. oyuncurutbe .. " #b9c9bf Telefon : - #FFFFFF ", thePlayer, 255, 255, 255, true)
					end
				end
			else
				outputChatBox("#575757 Valhalla: #b9c9bf Herhangi bir oluşumda değilsiniz, lütfen oluşuma girdikten sonra tekrar deneyiniz.", thePlayer, 255, 255, 255, true)
			end
	end
addCommandHandler("birlikaktif", factionActive)

function birlikOnayla(thePlayer, commandName, factionID, onay)
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (factionID) or not (onay)  then
			outputChatBox("SYNTAX: /" .. commandName .. " [Birlik ID] [1 / 0]", thePlayer, 255, 194, 14)
		else
			factionID = tonumber(factionID)
			if factionID and factionID > 0 then
				local theTeam = exports.vrp_pool:getElement("team", factionID)
				if (theTeam) then
					dbExec(exports.vrp_mysql:getConnection(),"UPDATE factions SET onay='" .. tonumber(onay) .. "' WHERE id='" .. factionID .. "'")
					local oldName = getTeamName(theTeam)
					setElementData(theTeam, "birlik_onay", tonumber(onay))
					
					if tonumber(onay) == 1 then
						exports.vrp_global:sendMessageToAdmins(exports.vrp_global:getPlayerFullIdentity(thePlayer).." '" .. oldName .. "' isimli birliği onayladı!")
					elseif tonumber(onay) == 0 then
						exports.vrp_global:sendMessageToAdmins(exports.vrp_global:getPlayerFullIdentity(thePlayer).." '" .. oldName .. "' isimli birliği onayını kaldırdı!")
					end
				else
					outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Invalid Faction ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("birlikonay", birlikOnayla)