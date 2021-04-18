function getAllGates(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer) then
		if table.concat({...}, " ") ~= "" then
			outputChatBox("SYNTAX: /"..commandName.." - Open Gates Manager", thePlayer, 255, 194, 14)
		else
			local gatesList = {}
			local mQuery1 = nil
			dbQuery(
				function(qh, thePlayer)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							table.insert(gatesList, { row["id"], tostring(row["objectID"]), row["gateType"], row["gateSecurityParameters"], row["creator"], row["createdDate"], row["adminNote"], row["autocloseTime"], row["movementTime"], row["objectInterior"], row["objectDimension"], row["startX"], row["startY"], row["startZ"], row["startRX"], row["startRY"], row["startRZ"], row["endX"], row["endY"], row["endZ"], row["endRX"], row["endRY"], row["endRZ"] } )
						end
						triggerClientEvent(thePlayer, "createGateManagerWindow", thePlayer, gatesList, getElementData( thePlayer, "account:username" ))
					end
				end,
			{thePlayer}, mysql:getConnection(), "SELECT * FROM `gates` ORDER BY `createdDate` DESC")
		end
	end
end
addCommandHandler("gates", getAllGates)

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM gates AS e1 LEFT JOIN gates AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

function addGate(thePlayer, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24)
	local mQuery1 = nil
	local smallestID = SmallestID()
	
	if not a22 then
		a22 = false
	else
		a22 = tostring(a22)
		if string.len(a22) < 2 then
			a22 = false
		elseif a22 == "none" then
			a22 = false
		else
			a22 = (a22)
		end
	end
	if not tonumber(a23) then
		a23 = false
	else
		a23 = (tostring(a23))
	end
	if not tonumber(a24) then
		a24 = false
	else
		a24 = (tostring(a24))
	end

	mQuery1 = dbExec(mysql:getConnection(), "INSERT INTO `gates` (`id`, `objectID`, `startX`, `startY`, `startZ`, `startRX`, `startRY`, `startRZ`, `endX`, `endY`, `endZ`, `endRX`, `endRY`, `endRZ`, `gateType`, `gateSecurityParameters`, `autocloseTime`, `movementTime`, `objectInterior`, `objectDimension`, `creator`, `adminNote`, `sound`, `triggerDistance`, `triggerDistanceVehicle`) VALUES ('"..tostring(smallestID).."', '".. (a1) .."', '".. (a2) .."', '".. (a3) .."', '".. (a4) .."', '".. (a5) .."', '".. (a6) .."', '".. (a7) .."', '".. (a8) .."', '".. (a9) .."', '".. (a10) .."', '".. (a11) .."', '".. (a12) .."', '".. (a13) .."', '".. (a14) .."', '".. (a15) .."', '".. (a16) .."', '".. (a17) .."', '".. (a18) .."', '".. (a19) .."', '".. (a20) .."', '".. (a21) .."', "..(a22 and "'"..a22.."'" or "NULL")..", "..(a23 and "'"..a23.."'" or "NULL")..", "..(a24 and "'"..a24.."'" or "NULL")..")")

	if mQuery1 then 
		outputChatBox("[GATEMANAGER] Sucessfully added gate!", thePlayer, 0,255,0)
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
		--delOneGate(smallestID)
		loadOneGate(smallestID)
		getAllGates(thePlayer, "gates")
	else
		outputChatBox("[GATEMANAGER] Failed to add gate. Please check the inputs again.", thePlayer, 255,0,0)
	end
end
addEvent("addGate", true)
addEventHandler("addGate", getRootElement(), addGate)

function saveGate(thePlayer, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10,a11, a12, a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24, a25)
		local mQuery1 = nil

		if not a23 then
			a23 = false
		else
			a23 = tostring(a23)
			if string.len(a23) < 2 then
				a23 = false
			elseif a23 == "none" then
				a23 = false
			else
				a23 = (a23)
			end
		end
		if not tonumber(a24) then
			a24 = false
		else
			a24 = (tostring(a24))
		end
		if not tonumber(a25) then
			a25 = false
		else
			a25 = (tostring(a25))
		end

		mQuery1 = dbExec(mysql:getConnection(), "UPDATE `gates` SET `objectID` = '".. (a1) .."', `startX` = '".. (a2) .."', `startY` = '".. (a3) .."', `startZ` = '".. (a4) .."', `startRX` = '".. (a5) .."', `startRY` = '".. (a6) .."', `startRZ` = '".. (a7) .."', `endX` = '".. (a8) .."', `endY` = '".. (a9) .."', `endZ` = '".. (a10) .."', `endRX` = '".. (a11) .."', `endRY` = '".. (a12) .."', `endRZ`= '".. (a13) .."', `gateType` = '".. (a14) .."', `gateSecurityParameters`= '".. (a15) .."', `autocloseTime` = '".. (a16) .."', `movementTime` = '".. (a17) .."', `objectInterior` = '".. (a18) .."', `objectDimension` = '".. (a19) .."', `creator` = '".. (a20) .."', `adminNote` = '".. (a21) .."', `sound` = "..(a23 and "'"..a23.."'" or "NULL")..", `triggerDistance` = "..(a24 and "'"..a24.."'" or "NULL")..", `triggerDistanceVehicle` = "..(a25 and "'"..a25.."'" or "NULL").." WHERE `id` = '".. (a22) .."'")
		
		if mQuery1 then 
			outputChatBox("[GATEMANAGER] Sucessfully saved gate!", thePlayer, 0,255,0)
			resetGateSound(theGate)
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
			delOneGate(tonumber(a22))
			loadOneGate(tonumber(a22))
			getAllGates(thePlayer, "gates")
		else
			outputChatBox("[GATEMANAGER] Failed to modify gate. Please check the inputs again.", thePlayer, 255,0,0)
		end
end
addEvent("saveGate", true)
addEventHandler("saveGate", getRootElement(), saveGate)

function delGate(thePlayer, commandName, gateID)
	if exports.vrp_integration:isPlayerAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer) then
		if not tonumber(gateID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Gate ID]", thePlayer, 255, 194, 14)
		else
			local mQuery1 = nil
			mQuery1 = dbExec(mysql:getConnection(), "DELETE FROM `gates` WHERE `id` = '".. (gateID) .."'")
			
			if mQuery1 then 
				outputChatBox("[GATEMANAGER] Sucessfully deleted gate!", thePlayer, 0,255,0)
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
				delOneGate(tonumber(gateID))
				if string.lower(commandName) ~= "delgate" then
					getAllGates(thePlayer, "gates")
				end
			else
				outputChatBox("[GATEMANAGER] Gate doesn't exist.", thePlayer, 255,0,0)
			end
		end
	end
end
addEvent("delGate", true)
addEventHandler("delGate", getRootElement(), delGate)
addCommandHandler("delgate",delGate)

function reloadGates(thePlayer)
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
		local theResource = getThisResource()
		if restartResource(theResource) then
			outputChatBox("[GATEMANAGER] All gates have been reloaded successfully!", thePlayer, 0, 255, 0)
			if hiddenAdmin == 0 then
				exports.vrp_global:sendMessageToAdmins("[GATEMANAGER]: "..adminTitle.." ".. getPlayerName(thePlayer):gsub("_", " ") .. " has reloaded all gates.")
			else
				exports.vrp_global:sendMessageToAdmins("[GATEMANAGER]: A hidden admin has has reloaded all gates.")
			end
			--getAllGates(thePlayer, "gates")
		else
			outputChatBox("[GATEMANAGER]: Error! Failed to restart resource. Please notify scripters!", thePlayer, 255, 0, 0)
		end
end
addEvent("reloadGates", true)
addEventHandler("reloadGates", getRootElement(), reloadGates)

function gotoGate(thePlayer, commandName, gateID, x, y, z , rot, int, dim)
	if exports.vrp_integration:isPlayerAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer) then
		if not tonumber(gateID) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Gate ID]", thePlayer, 255, 194, 14)
		else
			local gateID1, x1, y1, z1, rot1, int1, dim1 = nil
			if not tonumber(dim) then
				dbQuery(
					function(qh, thePlayer)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							for index, row in ipairs(res) do
								x1 = row["startX"]
								y1 = row["startY"]
								z1 = row["startZ"]
								rot1 = row["startRX"]
								int1 = row["objectInterior"]
								dim1 = row["objectDimension"]
								startGoingToGate(thePlayer, x1,y1,z1,rot1,int1,dim1, gateID)
							end
						else
							outputChatBox("[GATEMANAGER]: Gate doesn't exist.", thePlayer, 255, 0, 0)
						end
					end,
				{thePlayer}, mysql:getConnection(), "SELECT `startX` , `startY`, `startZ` , `startRX`, `objectInterior`, `objectDimension` FROM `gates` WHERE `id` = '".. (gateID) .."'")
				
			else
				--To be continued.
			end
		end
	end
end
addEvent("gotoGate", true)
addEventHandler("gotoGate", getRootElement(), gotoGate)
addCommandHandler("gotogate", gotoGate)

function startGoingToGate(thePlayer, x,y,z,r,interior,dimension,gateID)
	-- Maths calculations to stop the player being stuck in the target
	x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
	y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
	
	setCameraInterior(thePlayer, interior)
	
	if (isPedInVehicle(thePlayer)) then
		local veh = getPedOccupiedVehicle(thePlayer)
		setElementAngularVelocity(veh, 0, 0, 0)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
		setElementInterior(veh, interior)
		setElementDimension(veh, dimension)
		setElementPosition(veh, x, y, z + 1)
		warpPedIntoVehicle ( thePlayer, veh ) 
		setTimer(setElementAngularVelocity, 50, 20, veh, 0, 0, 0)
	else
		setElementPosition(thePlayer, x, y, z)
		setElementInterior(thePlayer, interior)
		setElementDimension(thePlayer, dimension)
	end
	outputChatBox(" You have teleported to gate ID#"..gateID, thePlayer)
end

function getNearByGates(thePlayer, commandName)
	if not (exports.vrp_integration:isPlayerAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		outputChatBox("Only Super Admin and above can access /"..commandName..".",thePlayer, 255,0,0)
		return false
	end
	
	local posX, posY, posZ = getElementPosition(thePlayer)
	outputChatBox("Nearby Gates:", thePlayer, 255, 126, 0)
	local count = 0
	
	local dimension = getElementDimension(thePlayer)
	for k, theGate in ipairs(getElementsByType("object", getResourceRootElement(getThisResource()))) do
		local x, y = getElementPosition(theGate)
		local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
		local cdimension = getElementDimension(theGate)
		if (distance<=10) and (dimension==cdimension) then
			local dbid = tonumber(getElementData(theGate, "gate:id"))
			local desc = getElementData(theGate, "gate:desc") or "No Description"
			outputChatBox("   Gate ID #" .. dbid .. " - "..desc, thePlayer, 255, 126, 0)
			count = count + 1
		end
	end
	
	if (count==0) then
		outputChatBox("   None.", thePlayer, 255, 126, 0)
	end
	
	
	--[[
	if not tonumber(gateID) then 
		outputChatBox("SYNTAX: /" .. commandName .. " [Gate ID]", thePlayer, 255, 194, 14)
	end
	
	gateID = math.floor(tonumber(gateID))
	
	local targetGate = nil
	for key, value in ipairs(getElementsByType("object", getResourceRootElement(getThisResource()))) do
		if tonumber(getElementData(value, "gate:id")) == gateID then
			targetGate = value
			break
		end
	end
	
	if targetGate then
		destroyElement(targetGate)
	end]]
end
addCommandHandler("nearbygates", getNearByGates)

function delOneGate(gateID)
	local theGate = getGateElementFromID(gateID)
	if theGate then
		resetGateSound(theGate)
		destroyElement(theGate)
	end
end

function getGateElementFromID(id)
	id = tonumber(id)
	if not id then return false end
	for k, theGate in ipairs(getElementsByType("object", getResourceRootElement(getThisResource()))) do
		local dbid = tonumber(getElementData(theGate, "gate:id"))
		if(dbid == id) then
			return theGate
		end
	end
	return false
end