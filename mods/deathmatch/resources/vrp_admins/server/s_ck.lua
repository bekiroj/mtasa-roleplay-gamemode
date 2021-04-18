
-- /CK
function ckPlayer(thePlayer, commandName, targetPlayer, ...)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if not (targetPlayer) or not (...) then
			outputChatBox("* Valhalla * /" .. commandName .. " [Player Partial Nick / ID] [Cause of Death]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					info = table.concat({...}, " ")
					local query = dbExec(mysql:getConnection(), "UPDATE `characters` SET `cked`='1', `ck_info`='" .. (tostring(info)) .. "', `death_date`=NOW() WHERE `id` = " .. getElementData(targetPlayer, "dbid")) -- bekiroj
					
					local x, y, z = getElementPosition(targetPlayer)
					local skin = getPedSkin(targetPlayer)
					local rotation = getPedRotation(targetPlayer)
					local look = getElementData(targetPlayer, "look")
					local desc = look[5]
					call( getResourceFromName( "vrp_realism" ), "addCharacterKillBody", x, y, z, rotation, skin, getElementData(targetPlayer, "dbid"), targetPlayerName, getElementInterior(targetPlayer), getElementDimension(targetPlayer), getElementData(targetPlayer, "age"), getElementData(targetPlayer, "race"), getElementData(targetPlayer, "weight"), getElementData(targetPlayer, "height"), desc, info, getElementData(targetPlayer, "gender"))
					
					local id = getElementData(targetPlayer, "account:id")
					showCursor(targetPlayer, false)
					outputChatBox("Your character was CK'ed by " .. getPlayerName(thePlayer) .. ".", targetPlayer, 255, 194, 14)
					showChat(targetPlayer, false)
					outputChatBox("You have CK'ed ".. targetPlayerName ..".", thePlayer, 255, 194, 1)
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "CK with reason: "..(tostring(info)))
					triggerClientEvent("showCkWindow", targetPlayer)
				end
			end
		end
	end
end
addCommandHandler("ck", ckPlayer)

-- /UNCK
function unckPlayer(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if not (...) then
			outputChatBox("* Valhalla * /" .. commandName .. " [Full Player Name]", thePlayer, 255, 194, 14)
		else
			local targetPlayer = table.concat({...}, "_")
			local result = dbQuery(mysql:getConnection(), "SELECT id, account FROM characters WHERE charactername='" .. (tostring(targetPlayer)) .. "' AND cked > 0")
			
			if (mysql:num_rows(result)>1) then
				outputChatBox("Too many results - Please enter a more exact name.", thePlayer, 255, 0, 0)
			elseif (mysql:num_rows(result)==0) then
				outputChatBox("Player does not exist or is not CK'ed.", thePlayer, 255, 0, 0)
			else
				local row = mysql:fetch_assoc(result)
				local dbid = tonumber(row["id"]) or 0
				local account = tonumber(row["account"])
				dbExec(mysql:getConnection(),"UPDATE characters SET cked='0' WHERE id = " .. dbid .. " LIMIT 1")
				
				-- bekiroj all peds for him
				for key, value in pairs( getElementsByType( "ped" ) ) do
					if isElement( value ) and getElementData( value, "ckid" ) then
						if getElementData( value, "ckid" ) == dbid then
							destroyElement( value )
						end
					end
				end
				
				-- check to see if the player is online and fix his character
				for _, player in ipairs(getElementsByType("player")) do
					local accountID = getElementData(player, "account:id")
					if accountID == account then
						triggerEvent("updateCharacters", player)
						break
					end
				end
				
				outputChatBox(targetPlayer .. " is no longer CK'ed.", thePlayer, 0, 255, 0)
				--exports.vrp_logs:logMessage("[/UNCK] " .. getElementData(thePlayer, "account:username") .. "/".. getPlayerName(thePlayer) .." UNCK'ED ".. targetPlayer , 4)
				exports.vrp_logs:dbLog(thePlayer, 4, "ch"..row["id"], "UNCK")
			end
			mysql:free_result(result)
		end
	end
end
addCommandHandler("unck", unckPlayer)
