mysql = exports.vrp_mysql

addEvent("addFriend", true)
addEventHandler("addFriend", getRootElement(), function(player) new_addFriend(client, player) end)

-- FRISKING
function friskShowItems(player)
	triggerEvent("subscribeToInventoryChanges",source,player)
	triggerClientEvent(source,"showInventory",source,player)
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)

-- CUFFS
function toggleCuffs(cuffed, player)
	if (cuffed) then
		toggleControl(player, "fire", false)
		toggleControl(player, "sprint", false)
		toggleControl(player, "jump", false)
		toggleControl(player, "next_weapon", false)
		toggleControl(player, "previous_weapon", false)
		toggleControl(player, "accelerate", false)
		toggleControl(player, "brake_reverse", false)
		toggleControl(player, "aim_weapon", false)
	else
		toggleControl(player, "fire", true)
		toggleControl(player, "sprint", true)
		toggleControl(player, "jump", true)
		toggleControl(player, "next_weapon", true)
		toggleControl(player, "previous_weapon", true)
		toggleControl(player, "accelerate", true)
		toggleControl(player, "brake_reverse", true)
		toggleControl(player, "aim_weapon", true)
	end
end

-- RESTRAINING
function restrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	local dbid = getElementData( player, "dbid" )
	
	setTimer(toggleCuffs, 200, 1, true, player)
	
	outputChatBox("You have been restrained by " .. username:gsub("_", " ") .. ".", player)
	outputChatBox("You restrained " .. targetPlayerName:gsub("_", " ") .. ".", source)
	setElementData(player, "restrain", 1, true)
	setElementData(player, "restrainedObj", restrainedObj, true)
	setElementData(player, "restrainedBy", getElementData(source, "dbid"), true)
	dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 1, restrainedby = " .. (getElementData(source, "dbid")) .. ", restrainedobj = " .. (restrainedObj) .. " WHERE id = " .. (dbid) )
	
	exports.vrp_global:takeItem(source, restrainedObj)

	if (restrainedObj==45) then -- If handcuffs.. give the key
		exports['vrp_items']:deleteAll(47, dbid)
		exports.vrp_global:giveItem(source, 47, dbid)
	end
	exports.vrp_global:removeAnimation(player)
end
addEvent("restrainPlayer", true)
addEventHandler("restrainPlayer", getRootElement(), restrainPlayer)

function unrestrainPlayer(player, restrainedObj)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been unrestrained by " .. username:gsub("_", " ") .. ".", player)
	outputChatBox("You removed " .. targetPlayerName:gsub("_", " ") .. "'s restraints.", source)
	
	setTimer(toggleCuffs, 200, 1, false, player)
	
	setElementData(player, "restrain", 0)
	setElementData(player, "restrainedBy")
	setElementData(player, "restrainedObj")
	
	local dbid = getElementData(player, "dbid")
	if (restrainedObj==45) then -- If handcuffs.. take the key
		exports['vrp_items']:deleteAll(47, dbid)
	end
	exports.vrp_global:giveItem(source, restrainedObj, 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET cuffed = 0, restrainedby = 0, restrainedobj = 0 WHERE id = " .. (dbid) )
	
	exports.vrp_global:removeAnimation(player)
end
addEvent("unrestrainPlayer", true)
addEventHandler("unrestrainPlayer", getRootElement(), unrestrainPlayer)

-- BLINDFOLDS
function blindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have been blindfolded by " .. username .. ".", player)
	outputChatBox("You blindfolded " .. targetPlayerName .. ".", source)
	
	exports.vrp_global:takeItem(source, 66) -- take their blindfold
	setElementData(player, "blindfold", 1)
	dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 1 WHERE id = " .. (getElementData( player, "dbid" )) )
	fadeCamera(player, false)
end
addEvent("blindfoldPlayer", true)
addEventHandler("blindfoldPlayer", getRootElement(), blindfoldPlayer)

function removeblindfoldPlayer(player)
	local username = getPlayerName(source)
	local targetPlayerName = getPlayerName(player)
	
	outputChatBox("You have had your blindfold removed by " .. username .. ".", player)
	outputChatBox("You removed " .. targetPlayerName .. "'s blindfold.", source)
	
	exports.vrp_global:giveItem(source, 66, 1) -- give the remove the blindfold
	setElementData(player, "blindfold")
	dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 0 WHERE id = " .. (getElementData( player, "dbid" )) )
	fadeCamera(player, true)
end
addEvent("removeBlindfold", true)
addEventHandler("removeBlindfold", getRootElement(), removeblindfoldPlayer)


-- STABILIZE
function stabilizePlayer(player)
	local found, slot, itemValue = exports.vrp_global:hasItem(source, 70)
	if found then
		if itemValue > 1 then
			exports['vrp_items']:updateItemValue(source, slot, itemValue - 1)
		else
			exports.vrp_global:takeItem(source, 70, itemValue)
		end
		
		local username = getPlayerName(source)
		local targetPlayerName = getPlayerName(player)
	
	
		outputChatBox("You have been stabilized by " .. username .. ".", player)
		outputChatBox("You stabilized " .. targetPlayerName .. ".", source)
		triggerEvent("onPlayerStabilize", player)
	end
end
addEvent("stabilizePlayer", true)
addEventHandler("stabilizePlayer", getRootElement(), stabilizePlayer)