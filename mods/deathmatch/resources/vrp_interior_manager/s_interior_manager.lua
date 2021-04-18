local mysql = exports.vrp_mysql

function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports.vrp_anticheat:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end

function getAllInts(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerAdmin( thePlayer ) then
		local interiorsList = {}
		local mQuery1 = nil
		
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						table.insert(interiorsList, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], '', row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"], row['fowner'] } )
					end
					triggerClientEvent(thePlayer, "createIntManagerWindow", thePlayer, interiorsList, getElementData( thePlayer, "account:username" ))
				end
			end,
		{thePlayer}, mysql:getConnection(), "SELECT factions.name AS fowner, interiors.id AS iID, interiors.type AS type, interiors.name AS name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id LEFT JOIN factions ON interiors.faction=factions.id ORDER BY interiors.createdDate DESC")
	end
end
addCommandHandler("interiors", getAllInts)
addCommandHandler("ints", getAllInts)
addEvent("interiorManager:openit", true)
addEventHandler("interiorManager:openit", getRootElement(), getAllInts)

function delIntCmd(thePlayer, intID )
	executeCommandHandler ( "delint", thePlayer, intID )
end
addEvent("interiorManager:delint", true)
addEventHandler("interiorManager:delint", getRootElement(), delIntCmd)

function disableInt(thePlayer, intID )
	executeCommandHandler ( "toggleinterior", thePlayer, intID )
end
addEvent("interiorManager:disableInt", true)
addEventHandler("interiorManager:disableInt", getRootElement(), disableInt)

function gotoInt(thePlayer, intID )
	executeCommandHandler ( "gotohouse", thePlayer, intID )
end
addEvent("interiorManager:gotoInt", true)
addEventHandler("interiorManager:gotoInt", getRootElement(), gotoInt)

function restoreInt(thePlayer, intID )
	executeCommandHandler ( "restoreInt", thePlayer, intID )
end
addEvent("interiorManager:restoreInt", true)
addEventHandler("interiorManager:restoreInt", getRootElement(), restoreInt)

function removeInt(thePlayer, intID )
	executeCommandHandler ( "removeint", thePlayer, intID )
end
addEvent("interiorManager:removeInt", true)
addEventHandler("interiorManager:removeInt", getRootElement(), removeInt)
  
function forceSellInt(thePlayer, intID )
	executeCommandHandler ( "fsell", thePlayer, intID )
end
addEvent("interiorManager:forceSellInt", true)
addEventHandler("interiorManager:forceSellInt", getRootElement(), forceSellInt)

function openAdminNote(thePlayer, intID )
	executeCommandHandler ( "checkint", thePlayer, intID )
end
addEvent("interiorManager:openAdminNote", true)
addEventHandler("interiorManager:openAdminNote", getRootElement(), openAdminNote)

function interiorSearch(thePlayer, keyword )
	if keyword and keyword ~= "" and keyword ~= "Search..." then
		local interiorsResultList = {}
		local mQuery1 = nil
		dbQuery(
			function(qh, thePlayer)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						table.insert(interiorsResultList, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["disabled"], row["deleted"], '', row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"], row['fowner'] } )
					end
					triggerClientEvent(thePlayer, "interiorManager:FetchSearchResults", thePlayer, interiorsResultList, getElementData( thePlayer, "account:username" ))
				end
			end,
		{thePlayer}, mysql:getConnection(), "SELECT factions.name AS fowner, interiors.id AS iID, interiors.type AS type, interiors.name AS name, cost, charactername, username, cked, locked, supplies, safepositionX, disabled, deleted, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id LEFT JOIN factions ON interiors.faction=factions.id WHERE interiors.id LIKE '%"..keyword.."%' OR interiors.name LIKE '%"..keyword.."%' OR factions.name LIKE '%"..keyword.."%' OR cost LIKE '%"..keyword.."%' OR charactername LIKE '%"..keyword.."%' OR username LIKE '%"..keyword.."%' OR interiors.creator LIKE '%"..keyword.."%' ORDER BY interiors.createdDate DESC")
	end
end
addEvent("interiorManager:Search", true)
addEventHandler("interiorManager:Search", getRootElement(), interiorSearch)

function checkInt(thePlayer, commandName, intID)
	if exports.vrp_integration:isPlayerTrialAdmin( thePlayer ) then 
		if not tonumber(intID) or (tonumber(intID) <= 0 ) or (tonumber(intID) % 1 ~= 0 ) then
			intID = getElementDimension(thePlayer)
			if intID == 0 then
				outputChatBox( "You must be inside an interior.", thePlayer, 255, 194, 14)
				outputChatBox("Or use SYNTAX: /"..commandName.." [Interior ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		dbQuery(
			function(qh, thePlayer)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local result = {}
					for index, row in ipairs(res) do
						table.insert(result, { row["iID"], row["type"], row["name"], row["cost"], row["charactername"], row["username"], row["cked"], row["DiffDate"], row["locked"], row["supplies"], row["safepositionX"], row["safepositionY"], row["safepositionZ"], row["disabled"], row["deleted"], '', row["iCreatedDate"],row["iCreator"], row["`interiors`.`x`"], row["`interiors`.`y`"], row["`interiors`.`z`"], row['fowner'] } )
					end
					dbQuery(
						function(qh, thePlayer)
							local res, rows, err = dbPoll(qh, 0)
							if rows > 0 then
								local result2 = {}
								for index, row2 in ipairs(res) do
									table.insert(result2, { row2["date"], row2["action"], row2["adminname"], row2["logid"], row2["intID"]} )
								end
								dbQuery(
									function(qh, thePlayer)
										local res, rows, err = dbPoll(qh, 0)
										if rows > 0 then
											local notes = {}
											for index, row2 in ipairs(res) do
												row2.creatorname = formatCreator(row2.creatorname, row2.creator)
												table.insert(notes, row2 )
											end
										end
										triggerClientEvent(thePlayer, "createCheckIntWindow", thePlayer, result, exports.vrp_global:getPlayerAdminTitle(thePlayer), result2, notes)
									end,
								{thePlayer}, mysql:getConnection(), "SELECT n.id, n.note, a.username AS creatorname, n.date, n.creator FROM interior_notes n LEFT JOIN accounts a ON n.creator=a.id WHERE n.intid="..intID.." ORDER BY n.date DESC")
							end
						end,
					{thePlayer}, mysql:getConnection(), "SELECT `interior_logs`.`date` AS `date`, `interior_logs`.`intID` as `intID`, `interior_logs`.`action` AS `action`, `accounts`.`username` AS `adminname`, `interior_logs`.`log_id` AS `logid` FROM `interior_logs` LEFT JOIN `accounts` ON `interior_logs`.`actor` = `accounts`.`id` WHERE `interior_logs`.`intID` = '"..intID.."' ORDER BY `interior_logs`.`date` DESC")
				end
			end,
		{thePlayer}, mysql:getConnection(), "SELECT factions.name AS fowner, interiors.id AS iID, interiors.type AS type, interiors.name AS name, cost, charactername, username, cked, locked, supplies, safepositionX,safepositionY, safepositionZ, disabled, deleted, interiors.createdDate AS iCreatedDate, interiors.creator AS iCreator, DATEDIFF(NOW(), lastused) AS DiffDate, interiors.x, interiors.y, interiors.y FROM interiors LEFT JOIN characters ON interiors.owner = characters.id LEFT JOIN accounts ON characters.account = accounts.id LEFT JOIN factions ON interiors.faction=factions.id WHERE interiors.id = '"..intID.."' ORDER BY interiors.createdDate DESC")
	end
end
addCommandHandler("checkint", checkInt)
addCommandHandler("checkinterior", checkInt)
addEvent("interiorManager:checkint", true)
addEventHandler("interiorManager:checkint", getRootElement(), checkInt)

function formatCreator(creator, creatorId)
	if creator and creatorId then
		if creator == nil then
			if creatorId == "0" then
				return "SYSTEM"
			else
				return "N/A"
			end
		else
			return creator
		end
	else
		return "N/A"
	end
end

function saveAdminNote(intID, adminNote, noteId )
	if not intID or not adminNote then
		outputChatBox("Internal Error!", source, 255,0,0)
		return false
	end

	if string.len(adminNote) > 500 then
		outputChatBox("Admin note has failed to add. Reason: Exceeded 500 characters.", source, 255, 0, 0)
		return false
	end

	if noteId then
		if dbExec(mysql:getConnection(),"UPDATE interior_notes SET note='"..(adminNote).."', creator="..getElementData(source, "account:id").." WHERE id ="..noteId.." AND intid="..intID) then
			outputChatBox("You have successfully updated admin note entry #"..noteId.." on interior #"..intID..".", source, 0, 255,0)
			addInteriorLogs(intID, "Modified admin note entry #"..noteId, source)
			return true
		end
	else
		--outputChatBox("INSERT INTO interior_notes SET note='"..(adminNote).."', creator="..getElementData(source, "account:id")..", intid="..intID )
		local insertedId = dbExec(mysql:getConnection(),"INSERT INTO interior_notes SET note='"..(adminNote).."', creator="..getElementData(source, "account:id")..", intid="..intID ) 
		if insertedId then
			outputChatBox("You have successfully added a new admin note entry #"..insertedId.." to interior #"..intID..".", source, 0, 255,0)
			addInteriorLogs(intID, "Added new admin note entry #"..insertedId, source)
			return true
		end
	end
end
addEvent("interiorManager:saveAdminNote", true)
addEventHandler("interiorManager:saveAdminNote", getRootElement(), saveAdminNote)

function restock(thePlayer, commandName, intID, amount)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not intID or not tonumber(intID) or tonumber(intID)%1~=0 then
			amount = 100
			intID = getElementDimension(thePlayer)
			if intID == 0 then
				outputChatBox( "You must be inside an interior to restock. Or use SYNTAX: /" .. commandName .. " [Interior ID] [Amount 1~300]", thePlayer, 255, 194, 14 )
				return false
			end
		else
			if not amount or not tonumber(amount) or tonumber(amount)%1~=0 or tonumber(amount) < 1 or tonumber(amount) > 300 then
				outputChatBox( "SYNTAX: /" .. commandName .. " [Interior ID] [Amount 1~300]", thePlayer, 255, 194, 14 )
				outputChatBox( "Restocks businesses with supplies.", thePlayer, 255, 100, 0 )
				return false
			end
		end
		local possibleInteriors = getElementsByType("interior")
		for _, interior in ipairs(possibleInteriors) do
			if tonumber(intID) == getElementData(interior, "dbid") then
				if not exports.vrp_integration:isPlayerAdmin(thePlayer) then
					local success, msg1, msg2 = exports["vrp_job-system-trucker"]:remoteOrderSupplies(thePlayer, intID, amount, true)
					--outputChatBox(msg1,thePlayer, 255, 194, 14)
					outputChatBox(msg2,thePlayer, 255, 194, 14)
					if success then
						return true
					else
						return false
					end
				else
					local amount2 = getElementData(interior, "status")[6] + tonumber(amount)
					local mQuery1 = dbExec(mysql:getConnection(),"UPDATE `interiors` SET `supplies` = '"..amount2.."' WHERE `id` = '"..intID.."'") or false
					if not mQuery1 then
						outputChatBox( "Failed to restock "..getElementData(interior, "name").." (ID#"..intID.."), Database error!", thePlayer, 255, 0, 0 )
						return false
					end
					--exports["interiors"]:reloadOneInterior(tonumber(intID))
					outputChatBox( getElementData(interior, "name").." (ID#"..intID..") has been restocked with "..amount.." supplies.", thePlayer, 0, 255, 0 )
					local adminUsername = getElementData(thePlayer, "account:username")
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
					local adminID = getElementData(thePlayer, "account:id")
					if hiddenAdmin == 0 then
						exports.vrp_global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ").. " ("..adminUsername..") has restocked "..getElementData(interior, "name").." (ID#"..intID..") with "..amount.." of supplies.")
					else
						exports.vrp_global:sendMessageToAdmins("[INTERIOR]: A hidden admin has has restocked "..getElementData(interior, "name").." (ID#"..intID..") with "..amount.." of supplies.")
					end
					local addLog = dbExec(mysql:getConnection(),"INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(intID).."', '"..commandName:gsub("'","''").." with "..amount.." supplies', '"..adminID.."')") or false
					if not addLog then
						outputDebugString("Failed to add interior logs.")
					end
					return true
				end
			end
		end
	end
end
addCommandHandler("restock", restock, false, false)

function setInteriorFaction(thePlayer, cmd, ...)
	if exports.vrp_integration:isPlayerAdmin(thePlayer) then

		if not (...) then
			outputChatBox("SYNTAX: /" .. cmd .. " [Faction Name or Faction ID]", thePlayer, 255, 194, 14 )
			return
		end

		local dim = getElementDimension(thePlayer)
		if dim < 1 then
			outputChatBox("You must be inside an interior to perform this action.", thePlayer, 255, 0, 0 )
			return
		end

		local clue = table.concat({...}, " ")
		local theFaction = nil
		if tonumber(clue) then
			theFaction = exports.vrp_pool:getElement("team", tonumber(clue))
		else
			theFaction = exports.vrp_factions:getFactionFromName(clue)
		end

		if not theFaction then
			outputChatBox("No faction found.", thePlayer, 255, 0, 0 )
			return
		end

		local dbid, entrance, exit, interiorType, interiorElement = exports['vrp_interiors']:findProperty( thePlayer )
		if not isElement(interiorElement) then
			outputChatBox("No interior found here.", thePlayer, 255, 0, 0 )
			return
		end

		local can , reason = exports.vrp_global:canFactionBuyInterior(theFaction)
		if not can then
			outputChatBox(reason, thePlayer, 255, 0, 0 )
			return 
		end

		local factionId = getElementData(theFaction, "id")
		local factionName = getTeamName(theFaction)
		local intName = getElementData(interiorElement, "name")

		if not dbExec(mysql:getConnection(), "UPDATE interiors SET owner='-1', faction='"..factionId.."', locked=0 WHERE id='" .. dbid .. "'") then
			outputChatBox("Internal Error.", thePlayer, 255, 0, 0 )
			return
		end

		call( getResourceFromName( "vrp_items" ), "deleteAll", interiorType == 1 and 5 or 4, dbid )
		exports.vrp_global:giveItem(thePlayer, interiorType == 1 and 5 or 4, dbid)

		exports.vrp_logs:dbLog(thePlayer, 37, { "in"..tostring(dbid) } , "SETINTFACTION INTERIOR ID#"..dbid.." TO FACTION '"..factionName.."'")
		exports['vrp_interiors']:realReloadInterior(tonumber(dbid))
		triggerClientEvent(thePlayer, "createBlipAtXY", thePlayer, entrance[INTERIOR_TYPE], entrance[INTERIOR_X], entrance[INTERIOR_Y])
		exports.vrp_global:sendMessageToAdmins("[INTERIOR] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." transferred the ownership of interior '"..intName.."' ID #"..dbid.." to faction '"..factionName.."'.")
		return true
	end
end
addCommandHandler("setintfaction", setInteriorFaction, false, false)

function setInteriorToMyFaction(thePlayer, cmd)
	local factionId = getElementData(thePlayer, "faction")
	local factionLeader = getElementData(thePlayer, "factionleader")

	if not factionId or not factionLeader or factionId < 1 or factionLeader < 1 then
		outputChatBox("You must be a faction leader to perform this action.", thePlayer, 255, 0, 0 )
		return
	end

	local dim = getElementDimension(thePlayer)
	if dim < 1 then
		outputChatBox("You must be inside an interior to perform this action.", thePlayer, 255, 0, 0 )
		return
	end

	local theFaction = exports.vrp_pool:getElement("team", tonumber(factionId))
	if not theFaction then
		outputChatBox("No faction found.", thePlayer, 255, 0, 0 )
		return
	end

	local dbid, entrance, exit, interiorType, interiorElement = exports['vrp_interiors']:findProperty( thePlayer )
	if not isElement(interiorElement) then
		outputChatBox("No interior found here.", thePlayer, 255, 0, 0 )
		return
	end

	local charId = getElementData(thePlayer, "dbid")
	local intStatus = getElementData(interiorElement, "status")
	local intName = getElementData(interiorElement, "name")
	local factionName = getTeamName(theFaction)

	if intStatus[INTERIOR_OWNER] ~= charId then
		outputChatBox("You must own this interior to perform this action.", thePlayer, 255, 0, 0 )
		return
	end

	local can , reason = exports.vrp_global:canPlayerFactionBuyInterior(thePlayer)
	if not can then
		outputChatBox(reason, thePlayer, 255, 0, 0 )
		return 
	end

	if not dbExec(mysql:getConnection(), "UPDATE interiors SET owner='-1', faction='"..factionId.."', locked=0 WHERE id='" .. dbid .. "'") then
		outputChatBox("Internal Error.", thePlayer, 255, 0, 0 )
		return
	end

	call( getResourceFromName( "vrp_items" ), "deleteAll", interiorType == 1 and 5 or 4, dbid )
	exports.vrp_global:giveItem(thePlayer, interiorType == 1 and 5 or 4, dbid)

	exports.vrp_logs:dbLog(thePlayer, 37, { "in"..tostring(dbid) } , "SETINTTOMYFACTION INTERIOR ID#"..dbid.." TO FACTION '"..factionName.."'")
	exports['vrp_interiors']:realReloadInterior(tonumber(dbid))
	triggerClientEvent(thePlayer, "createBlipAtXY", thePlayer, entrance[INTERIOR_TYPE], entrance[INTERIOR_X], entrance[INTERIOR_Y])
	exports.vrp_global:sendMessageToAdmins("[INTERIOR] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." transferred the ownership of interior '"..intName.."' ID #"..dbid.." to his faction '"..factionName.."'.")
	return true
end
addCommandHandler("setinttomyfaction", setInteriorToMyFaction, false, false)