mysql = exports.vrp_mysql
--[[
x loadItems(obj) -- loads all items (caching)
x sendItems(obj, to) -- sends the items to the player
x clearItems(obj) -- clears all items from the player

x giveItem(obj, itemID, itemValue, nosqlupdate) -- gives an item
x takeItem(obj, itemID, itemValue = nil) -- takes the item, or if nil/false, the first one with the same item ID
x takeItemFromSlot(obj, slot, nosqlupdate) -- ...
x updateItemValue(obj, slot, itemValue) -- updates the object's item value

x moveItem(from, to, slot) -- moves an item from any inventory to another (was on from's specified slot before, true if successful, internally only updates the owner in the DB and modifies the arrays

x hasItem(obj, itemID, itemValue = nil ) -- returns true if the player has that item
x hasSpaceForItem(obj, itemID, itemValue) -- returns true if you can put more stuff in
x countItems(obj, itemID, itemValue) -- counts how often a player has that item

x getItems(obj) -- returns an array of all items in { slot = { itemID, itemValue } } table
x getCarriedWeight(obj) -- returns the current weight an element carries
x getMaxWeight(obj) -- returns the maximum weight the element is capable holding of

x deleteAll(itemID, itemValue) -- deletes all instances of that item
]]--

local drugList = {[30]=" gram", [31]=" gram", [32]=" gram", [33]=" gram", [34]=" gram", [35]=" ml(s)", [36]=" tablet", [37]=" gram", [38]=" gram", [39]=" gram", [40]=" ml", [41]=" tab", [42]=" shroom", [43]=" tablet"}

local saveditems = {}
local tempitems = {}
local subscribers = {}

-- util function for sendItems
local function itemconv( arr )
	if not arr then
		--outputDebugString("ITEM-SYSTEM / ITEM MANAGEMENT / itemconv / NO TABLE FOUND")
		return false
	end
	local brr = { }
	for k, v in ipairs( arr ) do
		brr[k] = {v[1], tostring(v[2]), tostring(v[3]), tonumber(v[4])}
	end
	return toJSON(brr)
end

-- send items to a player
local function sendItems( element, to, noload )
	if not noload then
		loadItems( element )
	end
	if isElement(to) and isElement(element) then
		triggerClientEvent( to, "recieveItems", element, itemconv( saveditems[ element ] ) )
	end
end

-- notify all subscribers on inventory change
local function notify( element, noload )
	if subscribers[ element ] then
		for subscriber in pairs( subscribers[ element ] ) do
			sendItems( element, subscriber, noload )
		end

	end
end

function updateProtection(item, faction, slot, element)
	local success, error = loadItems( element )
	if success then
		if saveditems[element][slot] then
			saveditems[element][slot][4] = faction
			notify( element )
		end
	end
end

-- Free Items Table as neccessary
local function destroyInventory( )
	saveditems[source] = nil
	notify( source )
	
	
	-- clear subscriptions
	--[[if type(subscribers) == "table" then
		for key, value in pairs( subscribers ) do
			if value[ source ] then
				value[ source ] = nil
			end
		end
	end--]]
	
	subscribers[source] = nil
end

addEventHandler( "onElementDestroy", getRootElement(), destroyInventory )
addEventHandler( "onPlayerQuit", getRootElement(), destroyInventory )
addEventHandler( "savePlayer", getRootElement(),
	function( reason )
		if reason == "Change Character" then
			destroyInventory()
		end
	end
)

-- subscribe from inventory changes
local function subscribeChanges( element )
	sendItems( element, source )
	if not subscribers[ element ] then subscribers[ element ] = {} end
	subscribers[ element ][ source ] = true
end

addEvent( "subscribeToInventoryChanges", true )
addEventHandler( "subscribeToInventoryChanges", getRootElement(), subscribeChanges )

-- Send items without subscription
local function sendCurrentInventory( element )
	sendItems( element, source )
end

addEvent( "sendCurrentInventory", true )
addEventHandler( "sendCurrentInventory", getRootElement(), sendCurrentInventory )

-- remove from inventory changes list
local function unsubscribeChanges( element )
	subscribers[ element ][ source ] = nil
	triggerClientEvent( source, "recieveItems", element )
end

addEvent( "unsubscribeFromInventoryChanges", true )
addEventHandler( "unsubscribeFromInventoryChanges", getRootElement(), subscribeChanges )

-- returns the 'owner' column content
local function getID(element)
	if getElementType(element) == "player" then -- Player
		return getElementData(element, "dbid")
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return getElementData(element, "dbid")
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("vrp_item_world")) then -- World Item
		return getElementData(element, "id")
	elseif getElementType(element) == "object" then -- Safe
		return getElementDimension(element)
	elseif getElementType(element) == "ped" then -- Ped
		return getElementData(element, "dbid")
	else
		return 0
	end
end

function getElementID(element)
	return getID(element)
end

-- returns the 'type' column content
local function getType(element)
	if getElementType(element) == "player" then -- Player
		return 1
	elseif getElementType(element) == "vehicle" then -- Vehicle
		return 2
	elseif getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("vrp_item_world")) then -- World Item
		return 3
	elseif getElementType(element) == "object" then -- Safe
		return 4
	elseif getElementType(element) == "ped" then -- Ped
		return 5
	else
		return 255
	end
end

function loadItems( element, force )
	if not isElement( element ) then
		return false, "No element"
	elseif not getID( element ) then
		return false, "Invalid Element ID"
	elseif force or not saveditems[ element ] then
		saveditems[ element ] = {}
		dbQuery(
			function(qh, element)
				local result, rows, err = qh:poll(0)
				if rows > 0 and isElement(element) then
					local count = 0
					for i,row in pairs(result) do
						count = count + 1
						if (tonumber( row.itemID ) and tonumber( row.itemValue ) or row.itemValue and tonumber( row.index ) and tonumber( row.protected )) then
						saveditems[element][count] = { tonumber( row.itemID ), tonumber( row.itemValue ) or row.itemValue, tonumber( row.index ), tonumber( row.protected ), tonumber(row.hak) }
						end
					end
					
					if not subscribers[ element ] then
						subscribers[ element ] = {}
						if getElementType( element ) == "player" then
							subscribers[ element ][ element ] = true
						end
					end
					notify( element, true )
					if (getElementType(element) == 'player') then
						triggerEvent("updateLocalGuns", element)
					end
					return true
				else
					notify( element, true )
					return false, "MySQL-Error"
				end
			end,
		{element}, mysql:getConnection(), "SELECT * FROM items WHERE type = " .. getType( element ) .. " AND owner = " .. getID( element ) .. " ORDER BY `index` ASC")
		return true
	else
		return true
	end
end

-- load items for all logged in players on resource start
function itemResourceStarted( )
	if getID( source ) then
		loadItems( source )
	end
end
addEvent( "itemResourceStarted", true )
addEventHandler( "itemResourceStarted", getRootElement( ), itemResourceStarted )

-- clear all items for an element
function clearItems( element, onlyifnosqlones )
	if saveditems[element] then
		if onlyifnosqlones and #saveditems[element] > 0 then
			return false
		else
			while #saveditems[ element ] > 0 do
				takeItemFromSlot( element, 1 )
			end
			
			saveditems[ element ] = nil
			notify( element, true )

			source = element
			destroyInventory()
			if (getElementType(element) == 'player') then
				triggerEvent("updateLocalGuns", element)
			end
		end
	end
	return true
end

function giveItem( element, itemID, itemValue, itemIndex, isThisFromSplittingOrAdminCmd )
	local success, error = loadItems( element )
	if success then
		if not hasSpaceForItem( element, itemID, itemValue ) then
			return false, "Inventory is Full."
		end
		
		if isThisFromSplittingOrAdminCmd then
			if drugList[itemID] then
				if not tonumber(itemValue) or tonumber(itemValue) < 1 then
					return false, "Drug value must be numberic and meant to be in grams."
				else
					itemValue = tostring(itemValue)..drugList[itemID]
				end
			end
		end
		
		if not itemIndex then
			local result = dbExec(mysql:getConnection(), "INSERT INTO items (type, owner, itemID, itemValue) VALUES (" .. getType( element ) .. "," .. getID( element ) .. "," .. itemID .. ",'" .. (itemValue) .. "')" )
			if result then
				dbQuery(
					function(qh, element)
						local res, rows, err = dbPoll(qh, -1)
						
						if rows > 0 then
							saveditems[element][ #saveditems[element] + 1 ] = { itemID, itemValue, res[1].index, 0 }
							local itemID = res[1].itemID
							local itemIndex = res[1].index
							local itemValue = res[1].itemValue
							if itemID == 178 then
								local bInfo = split(tostring(res[1].itemValue), ':')
								local bID = bInfo[3]
								if not bID then
									dbExec(mysql:getConnection(), "INSERT INTO books SET title='".. (res[1].itemValue) .."', author='Unknown', book='The begining of something great...'")
									dbQuery(
										function(qh)
											local res, rows, err = dbPoll(qh, -1)
											if rows > 0 then
												bookIndex = res[1]['id']
												itemValue = itemValue .. ":" .. "Unknown" .. ":" .. tostring(bookIndex)
												dbExec(mysql:getConnection(),"UPDATE items SET `itemValue`='".. (itemValue) .. "' WHERE `index`=".. tonumber(itemIndex) .."")
											end
										end,
									mysql:getConnection(), "SELECT `id` FROM books WHERE `id` = LAST_INSERT_ID()")									
								end
							end
							
							notify( element, true )
							if (getElementType(element) == 'player') then
								if tonumber(itemID) == 115 or tonumber(itemID) == 116 and (getElementType(element) == 'player') then
									triggerEvent("updateLocalGuns", element)
								end
								doItemGivenChecks(element, tonumber(itemID))
							end
						end
					end,
				{element}, mysql:getConnection(), "SELECT `index`, `itemID`, `itemValue` FROM items WHERE `index`=LAST_INSERT_ID() LIMIT 1") 
			end
			return true
		else
			saveditems[element][ #saveditems[element] + 1 ] = { itemID, itemValue, itemIndex, 0 }
			notify( element, true )
			if (getElementType(element) == 'player') then
				if tonumber(itemID) == 115 or tonumber(itemID) == 116 and (getElementType(element) == 'player') then
					triggerEvent("updateLocalGuns", element)
				end
				doItemGivenChecks(element, tonumber(itemID))
			end
		end
		return true
	else
		outputDebugString("loadItems error: " .. error)
		return false, "loadItems error: " .. error
	end
end
-- takes an item from the element
function takeItem(element, itemID, itemValue)
	local success, error = loadItems( element )
	if success then
		local success, slot = hasItem(element, itemID, itemValue)
		if success then
			takeItemFromSlot(element, slot)
			if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
				triggerEvent("updateLocalGuns", element)
			end
			return true
		else
			return false, "Element doesn't have this item"
		end
	else
		return false, "loadItems error: " .. error
	end
end

-- permanently removes an item from an element
function takeItemFromSlot(element, slot, nosqlupdate)
	local success, error = loadItems( element )
	if success then
		if saveditems[element][slot] then
			local itemID = saveditems[element][slot][1]
			local itemValue = saveditems[element][slot][2]
			local index = saveditems[element][slot][3]
			
			local success = true
			if not nosqlupdate and index then
				local result = dbExec(mysql:getConnection(), "DELETE FROM items WHERE `index` = '" .. index .. "' LIMIT 1" )
				if not result then
					success = false
				end
			end
			if success then
				-- shift following items from id to id-1 items
				table.remove( saveditems[element], slot )
				notify( element )
				if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then
					triggerEvent("updateLocalGuns", element)
				end
				return true
			end
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end

-- updates the item value
function updateItemValue(element, slot, itemValue)
	local success, error = loadItems( element )
	if success then
		if saveditems[element][slot] then
			local itemValue = tonumber(itemValue) or tostring(itemValue)
			if itemValue then
				local itemIndex = saveditems[element][slot][3]
				local result = dbExec(mysql:getConnection(),  "UPDATE items SET `itemValue` = '" .. ( tostring( itemValue ) ) .. "' WHERE `index` = " .. itemIndex )
				if result then
					saveditems[element][slot][2] = itemValue
					notify( element )
					return true
				else
					return false, "MySQL-Query failed."
				end
			else
				return false, "Invalid ItemValue"
			end
		else
			return false, "Slot does not exist."
		end
	else
		return false, "loadItems error: " .. error
	end
end
addEvent("updateItemValue", true)
addEventHandler("updateItemValue", getRootElement(), updateItemValue)

-- moves an item from any element to another element
function moveItem2(from, to, slot)
	moveItem(from, to, slot)
end

function moveItem(from, to, slot)
	local success, error = loadItems( from )
	if success then
		local success, error = loadItems( to )
		if success then
			if saveditems[from] and saveditems[from][slot] then
				if hasSpaceForItem(to, saveditems[from][slot][1], saveditems[from][slot][2]) then
					local itemIndex = saveditems[from][slot][3]
					if itemIndex then
						local itemID = saveditems[from][slot][1]
						if itemID == 48 or itemID == 126 or itemID == 60 or itemID == 103 then
							return false, "Bu itemi taşıyamazsınız"
						else
							local query = dbExec(mysql:getConnection(),  "UPDATE items SET type = " .. getType(to) .. ", owner = " .. getID(to) .. " WHERE `index` = " .. itemIndex )
							if query then
								
								local itemValue = saveditems[from][slot][2]
								--CHECK FOR DUPLICATED GUN
								if itemID == 115 then -- guns
									local target = from
									if getElementType(to) == "player" then
										target = to
									end
									if isThisGunDuplicated(itemValue, target) then
										takeItemFromSlot(from, slot, false)
										outputChatBox("#575757Valhalla: #ffffffFazla uyanık olma Query was here :P.", target, 255, 0, 0, true)
										return false, "Silah ID#"..itemIndex.." çoğaltma tespit edildi."
									end
								end
								
								-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
								--31 -> 43  = DRUGS
								if ( (itemID >= 31) and (itemID <= 43) ) or itemBannedByAltAltChecker[itemID] then
									if itemID == 150 then
										if getElementModel(from) == 2942 or getElementModel(to) == 2942 then
											takeItemFromSlot(from, slot, true)
											giveItem(to, itemID, itemValue, itemIndex)
											return true
										end
									end
									
									local hoursPlayedFrom = getElementData( from, "hoursplayed" ) or 99
									local hoursPlayedTo = getElementData( to, "hoursplayed" ) or 99
									
									if not exports.vrp_global:isStaffOnDuty(to) and not exports.vrp_global:isStaffOnDuty(from) then
										if hoursPlayedFrom < 10 then
											outputChatBox("#575757Valhalla: #ffffff"..getItemName( itemID ).." isimli eşyayı "..getName(to).."'a transfer edebilmek için 10 saat oynaman olması gerekmektedir.", from, 255, 0, 0, true)
											return false, "Item transferi engellendi, < 10 saat"
										end
										
										if hoursPlayedTo < 10 then
											outputChatBox("#575757Valhalla: #ffffff"..getItemName( itemID ).." isimli eşyayı "..getName(from).." size transfer edebilmesi için 10 saat oynaması olması gerekmektedir.", to, 255, 0, 0, true)
											return false, "Item transferi engellendi, < 10 saat"
										end
									end
								end
			
								
								if itemID == 134 then -- MONEY
									if takeItemFromSlot(from, slot, true) then
										if exports.vrp_global:giveMoney(to, tonumber(itemValue)) then
											return true
										end
									end
								else
									if takeItemFromSlot(from, slot, true) then
										if giveItem(to, itemID, itemValue, itemIndex) then
											return true
										end
									end
								end
							else
								return false, "MySQL-Query failed."
							end
						end
					else
						return false, "Item does not exist."
					end
				else
					return false, "Target does not have Space for Item."
				end
			else
				return false, "Slot does not exist."
			end
		else
			return false, "loadItems(to) error: " .. error
		end
	else
		return false, "loadItems(from) error: " .. error
	end
end

-- checks if the element has that specific item
function hasItem(element, itemID, itemValue)
	local success = false
	if not saveditems[element] then
		success, error = loadItems( element )
	else
		success = true
	end
	if success then
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
				return true, key, value[2], value[3]
			end
		end
		return false
	else
		return false, "loadItems error: " .. error
	end
end

-- checks if the element has space for adding a new item
function hasSpaceForItem(element, itemID, itemValue)
	local success, error = loadItems( element )
	if success then
		local carriedWeight = getCarriedWeight(element) or false
		local itemWeight = getItemWeight(itemID, itemValue or 1) or false
		local maxWeight = getMaxWeight(element) or false
		--outputChatBox(itemWeight)
		if carriedWeight and itemWeight and maxWeight then
			return carriedWeight + itemWeight <= maxWeight
		else
			return false, "Can't get carriedWeight or itemWeight or maxWeight"
		end
	else
		return false, "loadItems error: " .. error
	end
end

-- count all instances of that object
function countItems( element, itemID, itemValue )
	local success, error = loadItems( element )
	if success then
		local count = 0
		for key, value in pairs(saveditems[element]) do
			if value[1] == itemID and ( not itemValue or itemValue == value[2] ) then
				count = count + 1
			end
		end
		return count
	else
		return 0, "loadItems error: " .. error
	end
end

-- returns a list of all items of that element
function getItems(element)
	loadItems( element )
	return saveditems[element]
end


-- returns the current weight an element carries
function getCarriedWeight(element)
	local success, error = getItems( element )
	if success then
		local weight = 0
		for key, value in ipairs(saveditems[element]) do
			weight = weight + getItemWeight(value[1], value[2])
		end
		return weight
	else
		return 1000000, "loadItems error: " .. error -- Obviously too large to pick anything further up :o Yet if it fails that might even be good since we assume "if not loaded, can't happen"
	end
end	

-- returns the number of available item slots for that element
local function isTruck( element )
	if getElementType( element ) == "Trailer" then
		return true
	end
	local model = getElementModel( element )
	return model == 498 or model == 609 or model == 499 or model == 524 or model == 455 or model == 414 or model == 443 or model == 456
end	
	
local function isSUV( element )
	local model = getElementModel( element )
	return model == 482 or model == 440 or model == 418 or model == 413 or model == 400 or model == 489 or model == 579 or model == 459 or model == 582
end


function getMaxWeight(element)
	if getElementType( element ) == "player" then
		return getPlayerMaxCarryWeight( element )
	elseif getElementType( element ) == "vehicle" then
		if getID( element ) < 0 then
			return -1
		elseif getVehicleType( element ) == "BMX" then
			return 1
		elseif getVehicleType( element ) == "Bike" then
			return 10
		elseif isSUV( element ) then
			return 75
		elseif isTruck( element ) then
			return tonumber(exports["vrp_jobs"]:getTruckCapacity(element)) or 120
		else
			return 20
		end
	elseif (getElementType( element ) == "object") and (getElementModel(element) == 2942) then --ATM machine / MAXIME
		return 0.1
	elseif (getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("vrp_item_world"))) then -- World Item
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		if itemID == 166 then --video system
			return 0.1
		end
		return getElementModel(element) == 2147 and 50 or getElementModel(element) == 3761 and 100 or 10
	else
		return 20
	end
end

-- delete all instances of an item
function deleteAll( itemID, itemValue )
	if itemID then
		-- make sure it's erased from the db
		if itemValue then
			dbExec(mysql:getConnection(), "DELETE FROM items WHERE itemID = " .. itemID .. " AND itemValue = '" .. ( tostring( itemValue ) ) .. "'" ) 
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid = " .. itemID .. " AND itemvalue = '" .. ( tostring( itemValue ) ) .. "'" ) 
		else
			dbExec(mysql:getConnection(), "DELETE FROM items WHERE itemID = " .. itemID )
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE itemid = " .. itemID )
		end
		
		-- delete from all storages
		if saveditems then
			for value in pairs( saveditems ) do
				if isElement( value ) then
					while exports.vrp_global:hasItem( value, itemID, itemValue ) do
						exports.vrp_global:takeItem( value, itemID, itemValue )
					end
				end
			end
		end

		-- remove world items
		local objects = getElementsByType('object', getResourceRootElement(getResourceFromName('vrp_item_world')))
		if objects then
			
			for k, v in ipairs(objects) do
				local this = false
				if itemValue then
					this = getElementData(v, 'itemID') == itemID and tostring(getElementData(v, 'itemValue')) == tostring(itemValue)
				else
					this = getElementData(v, 'itemID') == itemID
				end

				if this then
					destroyElement(v)
				end
			end
			
		else
			-- outputDebugString('deleteAll() - item-world not loaded')
		end

		return true
	else
		return false
	end
end

function deleteAllItemsWithinInt( intID , dayOld, CLEANUPINT )
	if not dayOld then dayOld = 0 end
	if intID then
		local row = {}
		local query2 = false
		local success = false
		if CLEANUPINT ~= "CLEANUPINT" then
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							Async:foreach(getElementsByType("object", getResourceRootElement(getResourceFromName("vrp_item_world"))), function(value)
								if isElement( value ) then
									if tonumber(getElementData( value, "id" )) == tonumber(row["id"]) then
										destroyElement( value )
									end
								end
							end)
						end
					end
				end,
			mysql:getConnection(), "SELECT `id` FROM `worlditems` WHERE `dimension` = '" .. ( tostring( intID ) ) .. "' AND DATEDIFF(NOW(), creationdate) >= '"..( tostring( dayOld ) ) .."' AND `itemID` != 81 AND `itemID` != 103 AND protected = 0" ) 
			if dbExec(mysql:getConnection(),"DELETE FROM `worlditems` WHERE `dimension` = '" .. ( tostring( intID ) ) .. "' AND DATEDIFF(NOW(), creationdate) >= '"..( tostring( dayOld ) ) .."' AND `itemID` != 81 AND `itemID` != 103 AND protected = 0" ) then
				success = true
			end
		else
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						for index, row in ipairs(res) do
							Async:foreach(getElementsByType("object", getResourceRootElement(getResourceFromName("vrp_item_world"))), function(value)
								if isElement( value ) then
									if tonumber(getElementData( value, "id" )) == tonumber(row["id"]) then
										destroyElement( value )
									end
								end
							end)
						end
					end
				end,
			mysql:getConnection(), "SELECT `id` FROM `worlditems` WHERE `dimension` = '" .. ( tostring( intID ) ) .. "'" ) 
			if dbExec(mysql:getConnection(),"DELETE FROM `worlditems` WHERE `dimension` = '" .. ( tostring( intID ) ) .. "'" ) then
				success = true
			end
		end
		
		
		if success then
			return true
		else
			return false
		end
	else
		return false
	end
end
addCommandHandler("loadoneinventory",
	function(thePlayer, commandName, targetName)
		if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
			if not (targetName) then
				return outputChatBox("|| Valhalla || /" .. commandName .. " [Oyuncu İsmi/ID]", thePlayer, 255, 194, 14)
			end
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetName)
			if not targetPlayer then
				return outputChatBox("#575757Valhalla: #ffffffKişi bulunamadı.", thePlayer, 255, 0, 0, true)
			end
			loadItems(targetPlayer, true)
			outputChatBox("#575757Valhalla: #ffffffKişinin envanteri başarıyla yüklendi.", thePlayer, 0, 255, 0, true)
		end
	end
)

addCommandHandler( "fixinventory", 
	function( element )
		sendItems( element, element )
		if (getElementType(element) == 'player') then
			triggerEvent("updateLocalGuns", element)
		end
	end
)