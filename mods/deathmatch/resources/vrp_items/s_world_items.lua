-- Item protection
function isProtected(player, item)
	if not isElement(item) then
		if item then
			local team = getPlayerTeam(player)
			if item[4] ~= 0 and (team and getElementData(team, "id") ~= item[4]) then
				return true
			end
			return false
		end
	else
		local protected = getElementData(item, "protected")
		local team = getPlayerTeam(player)
		if not protected or (team and getElementData(team, "id") == protected) then
			return false
		end
		return true
	end
end

function canPickup(player, item)
	if isWatchingTV(player) then
		return false
	elseif isProtected(player, item) then
		if isElement(item) then
			if getElementDimension(item) > 0 and (hasItem(player, 4, getElementDimension(item)) or hasItem(player, 5, getElementDimension(item))) then
				return true
			end
		end
		return false
	else
		if isElement(item) then
			if exports['vrp_item_world']:can(player, "pickup", item) then
				return true
			else
				return false
			end
		end
	end
	return true
end
function canMove(player, item)
	if isWatchingTV(player) then
		return false
	elseif isProtected(player, item) then
		if isElement(item) then
			if getElementDimension(item) > 0 and (hasItem(player, 4, getElementDimension(item)) or hasItem(player, 5, getElementDimension(item))) then
				return true
			end
		end
		return false
	else
		if isElement(item) then
			if exports['vrp_item_world']:can(player, "move", item) then
				return true
			else
				return false
			end
		end
	end
	return true
end

function protectItem(faction, item, slot)
	--[[if getElementParent(getElementParent(source)) ~= getResourceRootElement(getResourceFromName("item-world")) then
		return
	end]]
	if getElementData(source, "itemID") then
		local itemID = getElementData(source, "itemID")
		local index = getElementData( source, "id" )
	    if itemID == 169 then --disable for keypadlock / maxime
	      	return false
	    end
		
		if type(faction) == "number" and exports.vrp_global:isStaffOnDuty(client) then
			local protected = getElementData(source, "protected")
			local out = 0
			if protected then
				exports.vrp_anticheat:changeProtectedElementDataEx(source, "protected", false)
				outputChatBox("Unset", client, 0, 255, 0)
				out = 0
			else
				exports.vrp_anticheat:changeProtectedElementDataEx(source, "protected", faction)
				outputChatBox("Set to " .. faction .. " - if you want a different faction, /itemprotect [faction id or -100]", client, 255, 0, 0)
				out = faction
			end
			result = dbExec(mysql:getConnection(), "UPDATE worlditems SET protected = " .. faction .. " WHERE id = " .. index )
		end
	else

		if type(faction) == "number" and exports.vrp_global:isStaffOnDuty(client) then
			local protected = item[4]
			if protected ~= 0 and protected ~= nil then
				updateProtection(item, 0, slot, source)
				outputChatBox("Unset", client, 0, 255, 0)
				out = 0
			else
				updateProtection(item, faction, slot, source)
				outputChatBox("Set to " .. faction .. " - if you want a different faction, /itemprotect [faction id or -100]", client, 255, 0, 0)
				out = faction
			end
			result = dbExec(mysql:getConnection(), "UPDATE items SET `protected` = " .. out .. " WHERE `index` = " .. tonumber(item[3]) )
		end
	end
end
addEvent("protectItem", true)
addEventHandler("protectItem", root, protectItem)


-- This is simply to MANAGE world items. Not to create them.
local badges = getBadges()
local masks = getMasks()

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment / MAXIME
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM worlditems AS e1 LEFT JOIN worlditems AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

--MAXIME
function dropItemOnDead(itemID,itemValue, x, y, z, ammo, keepammo)

end
addEvent("dropItemOnDead", true)
addEventHandler("dropItemOnDead", getRootElement(), dropItemOnDead)
	
disableCanDropPick = false
function toggleDropPick(player, cmd, state)
	if exports.vrp_integration:isPlayerScripter(player) then
		disableCanDropPick = not disableCanDropPick
		outputChatBox("Droppick is "..(disableCanDropPick and "Disabled." or "Enabled."), player)
	end
end
addCommandHandler("togpick" ,toggleDropPick)

function dropItem(itemID, x, y, z, ammo, keepammo)
	if disableCanDropPick then
		outputChatBox("Item dropping is currently disabled. While our scripters are investigating the issue.", source, 255, 0, 0)
		triggerClientEvent( source, "finishItemDrop", source )
		return
	end

	if isWatchingTV(source) or isPedDead(source) or getElementData(source, "injuriedanimation") then
		triggerClientEvent( source, "finishItemDrop", source )
		return false
	end
	
	
	
	local interior = getElementInterior(source)
	local dimension = getElementDimension(source)
	
	local rz2 = getPedRotation(source)
	
	if not ammo then
		local itemSlot = itemID
		local itemID, itemValue = unpack( getItems( source )[ itemSlot ] )
		
		--ANTI ALT-ALT / MAXIME
		if not exports.vrp_global:isStaffOnDuty(source) then
			if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
				local hoursPlayedFrom = getElementData( source, "hoursplayed" )
				if hoursPlayedFrom < 10 then
					outputChatBox("You require 10 hours of playing time to drop a "..getItemName( itemID )..".", source, 255, 0, 0)
					triggerClientEvent( source, "finishItemDrop", source )
					return 
				end
			end
		end
		
		if itemID == 162 then
			hoursPlayed = getElementData( source, "hoursplayed" )
			--outputDebugString("Check")
			if hoursPlayed < 9999999 then
				outputChatBox("Bu nesneyi yere atmaniz sunucu tarafindan yasaklanmistir.", source, 255, 0, 0)
				exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere Body Armor atmaya calisti.")
				return
				triggerClientEvent( source, "finishItemDrop", source )
			else
				exports.vrp_global:takeMoney(source, itemValue)
			end
		end
		
		if itemID == 56 then
			hoursPlayed = getElementData( source, "hoursplayed" )
			--outputDebugString("Check")
			if hoursPlayed < 9999999 then
				outputChatBox("Bu nesneyi yere atmaniz sunucu tarafindan yasaklanmistir.", source, 255, 0, 0)
				exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere Yüz Maskesi atmaya calisti.")
				return
				triggerClientEvent( source, "finishItemDrop", source )
			else
				exports.vrp_global:takeMoney(source, itemValue)
			end
		end
		
		if itemID == 134 then
			hoursPlayed = getElementData( source, "hoursplayed" )
			--outputDebugString("Check")
			if hoursPlayed < 9999999 then
				outputChatBox("Bu nesneyi yere atmaniz sunucu tarafindan yasaklanmistir.", source, 255, 0, 0)
				outputChatBox("Yetkililere bunu yapmaya calistigin bildirildi.", source, 255, 0, 0)
				exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere para atmaya calisti.")
				return
				triggerClientEvent( source, "finishItemDrop", source )
			else
				exports.vrp_global:takeMoney(source, itemValue)
			end
		end
		
		if itemID == 254 then
			hoursPlayed = getElementData( source, "hoursplayed" )
			--outputDebugString("Check")
			if hoursPlayed < 9999999 then
				outputChatBox("#575757Valhalla: #ffffffMalesef, bu eşyayı yere atamazsınız.", source, 255, 0, 0, true)
				--outputChatBox("Yetkililere bunu yapmaya calistigin bildirildi.", source, 255, 0, 0)
				--exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere para atmaya calisti.")
				return
				triggerClientEvent( source, "finishItemDrop", source )
			else
				exports.vrp_global:takeMoney(source, itemValue)
			end
		end
		
		if itemID == 116 then
			hoursPlayed = getElementData( source, "hoursplayed" )
			--outputDebugString("Check")
			if hoursPlayed < 9999999 then
				outputChatBox("Bu nesneyi yere atmaniz sunucu tarafindan yasaklanmistir.", source, 255, 0, 0)
				outputChatBox("Yetkililere bunu yapmaya calistigin bildirildi.", source, 255, 0, 0)
				exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere mermi atmaya calisti.")
				return
				triggerClientEvent( source, "finishItemDrop", source )
			else
				exports.vrp_global:takeMoney(source, itemValue)
			end
		end
			
		if itemID == 115 then
			local val = exports.vrp_global:explode(":", itemValue)
			setElementData(source, "attachingWeapon" .. val[1], false, true)
			print(toJSON(val[1]))
			triggerEvent("destroyWeaponModel", source, tonumber(val[1]))
			--triggerClientEvent( source, "st.updateWeapons", source )
			--outputChatBox("Bu nesneyi yere atmaniz sunucu tarafindan yasaklanmistir. // PedroLanges", source, 255, 0, 0)
			--exports.vrp_global:sendMessageToAdmins("|| Valhalla || BUG Koruma > ".. getPlayerName(client) .. ", Yere silah atmaya calisti.")
			--return
			triggerClientEvent( source, "finishItemDrop", source )
		end
		
		local weaponBlock = false

		if itemID == 2 then
			--triggerClientEvent(source,"phone:clearAllCaches", source, itemValue)
		end


		if ( itemID == 115) then -- Weapons
			local itemCheckExplode = exports.vrp_global:explode(":", itemValue)
			-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
			local weaponDetails = exports.vrp_global:retrieveWeaponDetails( itemCheckExplode[2]  )
			if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
				outputChatBox("You cannot drop your duty gun, sorry.", source, 255, 0, 0)
				weaponBlock = true
			end
			
			if isThisGunDuplicated(itemValue, source) then
				takeItemFromSlot( source, itemSlot )
				outputChatBox("The weapon has dropped was duplicated by bug abuser. And can not be used anymore. We're sorry to delete it now.", source, 255,0,0)
				triggerClientEvent( source, "finishItemDrop", source )
				return false
			end
		elseif ( itemID == 116) then -- Ammo
			local ammoDetails = exports.vrp_global:explode( ":", itemValue  )
			local checkString = string.sub(ammoDetails[3], -4)
			if (checkString == " (D)")  then -- /duty
				outputChatBox("You cannot drop your duty gun ammo, sorry.", source, 255, 0, 0)
				weaponBlock = true
			end
		end
	
		if itemID == 573 or itemID == 574 or itemID == 580 or itemID == 589 or itemID == 590 or itemID == 581 or itemID == 134 or itemID == 556 or itemID == 557 or itemID == 558 or itemID == 559 or itemID == 555 or itemID == 228 or itemID == 57 or itemID == 17 or itemID == 45 or itemID == 64 or itemID == 16 or itemID == 575 or itemID == 576 or itemID == 577 or itemID == 569 or itemID == 570 or itemID == 571 or itemID == 572 or itemID == 60 or itemID == 137 or itemID == 138 or itemID == 115 or itemID == 116 or itemID == 175 and not exports.vrp_integration:isPlayerAdmin(source) then
			outputChatBox( "#575757Valhalla: #ffffffBu eşya yere atılamaz.", source, 255, 0, 0, true)
		elseif ( itemID == 81 or itemID == 103 ) and dimension == 0 then
			outputChatBox( "#575757Valhalla: #ffffffBu öğeyi bir ev/işyeri içine bırakmanız gerekiyor.", source, 255, 0, 0, true)
		elseif (weaponBlock) then
			-- Do nothing
		elseif itemID == 139 then
			outputChatBox("#575757Valhalla: #ffffffBu eşya yere atılamaz.", source, 255, 0, 0, true)
		else
			--[[if not (hasItem(source, itemID)) then
				local haxStr = getPlayerName(source) .. " ".. getPlayerIP(source) .." tried to duplicate item " ..tostring(itemID) .." C0x0000003[BETA]"
				outputDebugString(haxStr)
				exports.vrp_logs:logMessage(haxStr, 32)
				exports.vrp_global:sendMessageToAdmins("AdmWrn: " .. haxStr)		
			end]]

			local keypadDoorInterior = nil
			if itemID == 48 and countItems( source, 48 ) == 1 then
				if getCarriedWeight( source ) > 10 - getItemWeight( 48, 1 ) then
					triggerClientEvent( source, "finishItemDrop", source )
					return
				end
			elseif itemID == 134 then
				if not exports.vrp_global:takeMoney(source, itemValue) then
					outputDebugString(getPlayerName(source) .. ' (' .. getPlayerSerial(source) .. ') tried dropping money he doesnt have')

					while exports['vrp_items']:takeItem(source, 134) do
					end

					local amount = exports.vrp_global:getMoney(source)
					if amount > 0 then
						exports.vrp_global:giveItem(source, 134, amount)
					end

					triggerClientEvent( source, "finishItemDrop", source )
					return
				end
			elseif (itemID == 147) then -- Picture Frame
				local dimension = getElementDimension(source)
				if dimension > 0 or (exports.vrp_integration:isPlayerDeveloper(source) and exports.vrp_global:isAdminOnDuty(source)) or exports.vrp_integration:isPlayerScripter(source) then
					local split = exports.vrp_global:explode(";", itemValue)
					local url = split[1]
					local texture = split[2]
					if url and texture then
						if exports['vrp_textures']:newTexture(source, url, texture) then
							takeItem ( source, 147, itemValue )
						end
						triggerClientEvent( source, "finishItemDrop", source )
						return
					end
				end
			elseif itemID == 169 then --Keypad Door Lock / Maxime
				local maxRange = 10
				local doorOutside = nil
				local doorInside = nil
				local validInterior = false
				local validDropper = false
				local interiorName = "Unknown"
				local isIntLocked = true
				--check if int is existed and int is owned by dropper / Maxime
				for key, interior in ipairs(getElementsByType("interior")) do
					if isElement(interior) and getElementData(interior, "dbid") == tonumber(itemValue) then
						validInterior = true
						interiorName = getElementData(interior, "name")
						local status = getElementData(interior, "status")
						isIntLocked = status[3]
						if tonumber(status[4]) == getElementData(source, "dbid") then
							validDropper = true
							doorOutside = getElementData(interior, "entrance")
							doorInside = getElementData(interior, "exit")
							keypadDoorInterior = interior
							break
						end
					end
				end

				if not validInterior then
					exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "The interior that this device is made for is no longer existed. Thus far this device is not usable anymore.")
					triggerClientEvent( source, "finishItemDrop", source )
					return false
				end

				if not validDropper then
					exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "Interior '"..interiorName.."' is no longer owned by you. Thus far this device is not usable anymore.")
					triggerClientEvent( source, "finishItemDrop", source )
					return false
				end

				--check if the interior is unlocked / maxime
				if isIntLocked then
					exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "Interior '"..interiorName.."' is locked, please unlock it first.")
					triggerClientEvent( source, "finishItemDrop", source )
					return false
				end

				-- Making sure the interior door is valid / maxime
				if not doorOutside or not doorInside then
					exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "Interior '"..interiorName.."' is defected, please notify scripters.")
					triggerClientEvent( source, "finishItemDrop", source )
					return false
				end

				-- check if the devide is placed outside within maxRange / maxime
				if interior == doorOutside[4] and dimension == doorOutside[5] then
					if getDistanceBetweenPoints3D(x,y,z,doorOutside[1], doorOutside[2], doorOutside[3]) > maxRange then
						exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "This device can only be installed within "..math.floor(maxRange/2).." meters from its out-door.")
						triggerClientEvent( source, "finishItemDrop", source )
						return false
					end
				-- check if the devide is placed inside within maxRange / maxime
				elseif interior == doorInside[4] and dimension == tonumber(itemValue) then
					if getDistanceBetweenPoints3D(x,y,z,doorInside[1], doorInside[2], doorInside[3]) > maxRange then
						exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "This device can only be installed within "..math.floor(maxRange/2).." meters from its in-door.")
						triggerClientEvent( source, "finishItemDrop", source )
						return false
					end
				else
					exports.vrp_hud:sendBottomNotification(source, getItemName( itemID, itemValue ), "This device can only be installed within "..math.floor(maxRange/2).." meters from its door.")
					triggerClientEvent( source, "finishItemDrop", source )
					return false
				end
			end
			
			local smallestID = SmallestID() -- MAXIME
			
			local insert = dbExec(mysql:getConnection(), "INSERT INTO worlditems SET id='"..tostring(smallestID).."', itemid='" .. itemID .. "', itemvalue='" .. ( itemValue) .. "', creationdate = NOW(), x = " .. x .. ", y = " .. y .. ", z= " .. z .. ", dimension = " .. dimension .. ", interior = " .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if insert then
				local id = smallestID--mysql:insert_id()
				
				-- Animation
				exports.vrp_global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
				
				if getPedOccupiedVehicle(source) then
					if getElementModel(getPedOccupiedVehicle(source)) == 490 then
					end
				else
					toggleAllControls( source, true, true, true )
				end
				
				triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
				-- Create Object
				local modelid = getItemModel(tonumber(itemID), itemValue)
				
				if (itemID==80) then
					local text = tostring(itemValue)
					local text2 = tostring(itemValue)
					local pos = text:find( ":" )
					local pos2 = text:find( ":" )
					if (pos) then
						text = text:sub( pos+1 )
						modelid = text
					end
					if (pos2) then
						name = text2:sub( 1, pos-1 )
					end
				elseif (itemID==178) then
					local yup = split(itemValue, ":")
					name = ("book titled ".. yup[1].." by ".. yup[2])
				end
				
				if itemID == 134 then
					outputChatBox("" .. exports.vrp_global:formatMoney(itemValue) .. "$ yere bırakır.", source, 255, 194, 14)
				elseif (itemID == 80) and tostring(itemValue):find( ":" ) then
					outputChatBox("" .. name .. " yere bırakır.", source, 255, 194, 14)
				else
					outputChatBox("" .. getItemName( itemID, itemValue ) .. " yere bırakır.", source, 255, 194, 14)
				end

				
				local rx, ry, rz, zoffset = getItemRotInfo(itemID)
				local obj = exports['vrp_item_world']:createItem(id, itemID, itemValue, modelid, x, y, z + zoffset - 0.05, rx, ry, rz+rz2)
				exports.vrp_pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				if (itemID==76) then
					moveObject(obj, 200, x, y, z + zoffset, 90, 0, 0)
				else
					moveObject(obj, 200, x, y, z + zoffset)
				end

				local objScale = getItemScale(tonumber(itemID))
				if objScale then
					setObjectScale(obj, objScale)
				end
				local objDoubleSided = getItemDoubleSided(tonumber(itemID))
				if objDoubleSided then
					setElementDoubleSided(obj, objDoubleSided)
				end
				local objTexture = getItemTexture(tonumber(itemID), itemValue)
				if objTexture then
					for objTexKey, objTexVal in ipairs(objTexture) do
						exports['vrp_item_texture']:addTexture(obj, objTexVal[2], objTexVal[1])
					end
				end
				
				exports.vrp_anticheat:changeProtectedElementDataEx(obj, "creator", getElementData(source, "dbid"), false)

				local permissions = { use = 1, move = 1, pickup = 1, useData = {}, moveData = {}, pickupData = {} }
				exports.vrp_anticheat:changeProtectedElementDataEx(obj, "worlditem.permissions", permissions)
				
				--TAKE WAY WHAT HAS DROPPED
				if itemID ~= 134 then
					takeItemFromSlot( source, itemSlot )
				end
				
				--exports.vrp_logs:logMessage( getElementData(source, "account:username").."\\"..getPlayerName(source) .. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( itemID ) .. " - " .. itemValue, 17)
				exports.vrp_logs:dbLog(source, 39, source, getPlayerName(source) .. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( itemID ) .. " - " .. itemValue )
				doItemGiveawayChecks(source, itemID, itemValue)

				--misc post-spawn itemID conditionals
				
				if itemID == 169 then --Keypad Door Lock / maxime
					triggerEvent("installKeypad", source, obj, keypadDoorInterior)
				end
				
				--SEND ME FOR WHAT HAS BEEN DROPPED
				if itemID == 134 then
					triggerEvent('sendAme', source, "" .. exports.vrp_global:formatMoney(itemValue) .. "$ bırakır.")
				elseif (itemID==80 or itemID==178) and tostring(itemValue):find( ":" ) then
					triggerEvent('sendAme', source, "" .. name .. " yere bırakır.")
				else
					triggerEvent('sendAme', source, "" .. getItemName( itemID, itemValue ) .. " yere bırakır.")
				end
			end
		end
	else
		if tonumber(getElementData(source, "duty")) > 0 then
			outputChatBox("#575757Valhalla: #ffffffSilahlarınızı görev başındayken bırakamazsınız.", source, 255, 0, 0, true)
		elseif tonumber(getElementData(source, "job")) == 4 and itemID == 41 then
			outputChatBox("#575757Valhalla: #ffffffBu sprey kutusunu bırakamazsın.", source, 255, 0, 0, true)
		else
		
			
			if ammo <= 0 then
				triggerClientEvent( source, "finishItemDrop", source )
				return
			end
			
			--[[local totalAmmoPosessed = exports.vrp_global:getWeaponCount(source, itemID) 
			if (totalAmmoPosessed < ammo) then
				local haxStr = getPlayerName(thePlayer) .. " ".. getPlayerIP(thePlayer) .." tried to duplicate weapon " .. tokenweapon .. " with " .. ammo .." ammo C0x0000003[BETA]"
				outputDebugString(haxStr)
				exports.vrp_logs:logMessage(haxStr, 32)
				exports.vrp_global:sendMessageToAdmins("AdmWrn: " .. haxStr)		
			end]]
			
			outputChatBox("" .. ( getWeaponNameFromID( itemID ) or "Body Armor" ) .. " yere bırakır.", source, 255, 194, 14)
			
			-- Animation
			exports.vrp_global:applyAnimation(source, "CARRY", "putdwn", 500, false, false, true)
							
			if getPedOccupiedVehicle(source) then
				if getElementModel(getPedOccupiedVehicle(source)) == 490 then
				end
			else
				toggleAllControls( source, true, true, true )
			end
			
			triggerClientEvent(source, "onClientPlayerWeaponCheck", source)	
			if itemID == 100 then
				z = z + 0.1
				setPedArmor(source, 0)
			end
			
			local smallestID = SmallestID() -- MAXIME
			
			local query = dbExec(mysql:getConnection(), "INSERT INTO worlditems SET id='"..tostring(smallestID).."', itemid=" .. -itemID .. ", itemvalue=" .. ammo .. ", creationdate=NOW(), x=" .. x .. ", y=" .. y .. ", z=" .. z+0.1 .. ", dimension=" .. dimension .. ", interior=" .. interior .. ", rz = " .. rz2 .. ", creator=" .. getElementData(source, "dbid"))
			if query then
				local id = smallestID
				
				exports.vrp_global:takeWeapon(source, itemID)
				if keepammo then
					exports.vrp_global:giveWeapon(source, itemID, keepammo)
				end
				
				local modelid = 2969
				-- MODEL ID
				if (itemID==100) then
					modelid = 1242
				elseif (itemID==42) then
					modelid = 2690
				else
					modelid = weaponmodels[itemID]
				end
				
				local obj = exports['vrp_item_world']:createItem(id, -itemID, ammo, modelid, x, y, z - 0.4, 75, -10, rz2)
				exports.vrp_pool:allocateElement(obj)
				
				setElementInterior(obj, interior)
				setElementDimension(obj, dimension)
				
				moveObject(obj, 200, x, y, z+0.1)
				
				exports.vrp_anticheat:changeProtectedElementDataEx(obj, "creator", getElementData(source, "dbid"), false)
				
				triggerEvent('sendAme', source, "" .. getItemName( -itemID ) .. " yere bırakır.")
				
				triggerClientEvent(source, "saveGuns", source, getPlayerName(source))
				
				--exportslogs:logMessage( getElementData(source, "account:username").."\\"..getPlayerName(source) .. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( -itemID ) .. " - " .. ammo, 17)
				exports.vrp_logs:dbLog(source, 39, source, getPlayerName(source).. " -> ~World #" .. getElementID(obj) .. " - " .. getItemName( -itemID ) .. " - " .. ammo)
			end
		end
	end

	triggerClientEvent( source, "finishItemDrop", source )
end
addEvent("dropItem", true)
addEventHandler("dropItem", getRootElement(), dropItem)

function doItemGiveawayChecks(player, itemID, itemValue)
	local source = player
	local mask = masks[itemID]
	if mask and getElementData(source, mask[1]) and not hasItem(source, itemID) then
		triggerEvent('sendAme', source, mask[3] .. ".")
		exports.vrp_anticheat:changeProtectedElementDataEx(source, mask[1])
	end

	--Cellphone
	if itemID == 2 then
		triggerClientEvent(source,"phone:clearAllCaches", source, itemValue)
	end
	
	-- Clothes
	local requiredClothesValue = getElementModel(source) .. (getElementData(source, 'clothing:id') and (':' .. getElementData(source, 'clothing:id')) or '')
	if itemID == 16 and not hasItem(source, 16, tonumber(requiredClothesValue) or requiredClothesValue) then
	--if itemID == 16 and not hasItem(source, 16, getPedSkin(source)) then
		local gender = getElementData(source,"gender")
		local race = getElementData(source,"race")
		
		if (gender==0) then -- MALE
			if (race==0) then -- BLACK
				setElementModel(source, 80)
			elseif (race==1 or race==2) then -- WHITE
				setElementModel(source, 252)
			end
		elseif (gender==1) then -- FEMALE
			if (race==0) then -- BLACK
				setElementModel(source, 139)
			elseif (race==1) then -- WHITE
				setElementModel(source, 138)
			elseif (race==2) then -- ASIAN
				setElementModel(source, 140)
			end
		end
		--dbExec(mysql:getConnection(),  "UPDATE characters SET skin = '" .. (getElementModel(source)) .. "' WHERE id = '" .. (getElementData( source, "dbid" )).."'" )
		exports.vrp_anticheat:changeProtectedElementDataEx(source, 'clothing:id', nil, true)
		dbExec(mysql:getConnection(),  "UPDATE characters SET skin = '" .. (getElementModel(source)) .. "', clothingid = NULL WHERE id = '" .. (getElementData( source, "dbid" )).."'" )
	end
	
	-- Badges
	local badge = badges[itemID]
	if badge and getElementData(source, badge[1]) and not hasItem(source, itemID, removeOOC(getElementData(source, badge[1]))) then
		triggerEvent('sendAme', source, " " .. badge[2] .. " isimli badgesini üzerindeki kıyafet/ceket'in sol üst kısmından tutarak çıkartır.")
		exports.vrp_anticheat:changeProtectedElementDataEx(source, badge[1])
		exports.vrp_global:updateNametagColor(source)
	end
	
	-- Riot Shield
	if itemID == 76 and shields[source] and not hasItem(source, 76) then
		destroyElement(shields[source])
		shields[source] = nil
	end
	
	-- MP3-player
	if itemID == 19 and not hasItem(source, itemID) then
		triggerClientEvent(source, "realism:mp3:off", source)
	end

	if itemID == 90 then -- Helmet
		--triggerEvent("artifacts:remove", source, source, "helmet")
	elseif itemID == 26 then -- Gas mask
		--triggerEvent("artifacts:remove", source, source, "gasmask")
	elseif itemID == 160 then -- briefcase
		--triggerEvent("artifacts:remove", source, source, "briefcase")
	elseif itemID == 48 then --backpack
		--triggerEvent("artifacts:remove", source, source, "backpack")
	elseif itemID == 162 then --body armour
		--triggerEvent("artifacts:remove", source, source, "kevlar")
	elseif itemID == 163 then --duffle bag
		--triggerEvent("artifacts:remove", source, source, "dufflebag")
	elseif itemID == 164 then --medical bag
		--triggerEvent("artifacts:remove", source, source, "medicbag")
	elseif itemID == 111 then
		triggerClientEvent(source, "item:updateclient", source)
	elseif itemID == 171 then -- Biker Helmet
		--triggerEvent("artifacts:remove", source, source, "bikerhelmet")
	elseif itemID == 172 then -- Full Face Helmet
		--triggerEvent("artifacts:remove", source, source, "fullfacehelmet")
	end
end

function doItemGivenChecks(player, itemID, itemValue)
	if itemID == 2 then --cellphone
		triggerClientEvent(player,"phone:clearAllCaches", player, itemValue)
	elseif itemID == 48 then --backpack
		--triggerEvent("artifacts:add", player, player, "backpack")
	elseif itemID == 162 then --body armour
		--triggerEvent("artifacts:add", player, player, "kevlar")
	elseif itemID == 163 then --duffle bag
		--triggerEvent("artifacts:add", player, player, "dufflebag")
	elseif itemID == 164 then --medical bag
		--triggerEvent("artifacts:add", player, player, "medicbag")
	elseif itemID == 111 then
		setPlayerHudComponentVisible( player, 'radar', true )
	end
end

local function moveItem(item, x, y, z)
	if true then
		return outputDebugString("[ITEM] moveItem / Disabled ")
	end


	if isWatchingTV(source) or isPedDead(source) or getElementData(source, "injuriedanimation") then
		return false
	end

	local itemID = getElementData(item, "itemID")

	if itemID == 169 then -- Keypad Door Lock / maxime
		return false
	end

	--ANTI ALT-ALT / MAXIME
	if not exports.vrp_global:isStaffOnDuty(source) then
		if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
			outputChatBox(getItemName( itemID ).." can't be moved this way.", source, 255, 0, 0)
			return false
		end
	end
	
	local id = getElementData(item, "id")
	if not ( z ) then
		destroyElement(item)
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id = " .. (id))
		return
	end
	
	
	if not canMove(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	-- fridges and shelves can't be moved
	if not exports.vrp_integration:isPlayerTrialAdmin(source) and (itemID == 81 or itemID == 103) then
		return
	end
	
	if itemID == 138 then
		if not exports.vrp_integration:isPlayerAdmin(source) then
			outputChatBox("Only a Lead+ admin can move this item.", source, 255, 0, 0)
			return
		end
	end
	
	if itemID == 139 and not exports.vrp_integration:isPlayerTrialAdmin(source) then
		outputChatBox("Only a Super+ admin can move this item.", source, 255, 0, 0)
		return
	end
	
	-- check if no-one is standing on the item (should be cancelled client-side), but just in case
	for key, value in ipairs(getElementsByType("player")) do
		if getPedContactElement(value) == item then
			return
		end
	end
	
	local result = dbExec(mysql:getConnection(), "UPDATE worlditems SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. " WHERE id = " .. getElementData( item, "id" ) )
	if result then
		if itemID > 0 then
			local rx, ry, rz, zoffset = getItemRotInfo(itemID)
			z = z + zoffset
		elseif itemID == 100 then
			z = z + 0.1
		end
		setElementPosition(item, x, y, z)
	end
end
addEvent("moveItem", true)
addEventHandler("moveItem", getRootElement(), moveItem)

addEvent('item:move:save', true)
addEventHandler('item:move:save', root,
	function(x, y, z, rx, ry, rz)
		local reset = function()
			setElementPosition(source, getElementPosition(source))
			setElementRotation(source, getElementRotation(source))
		end
		if exports.vrp_global:isStaffOnDuty(client) or exports.vrp_integration:isPlayerDeveloper(client) or exports.vrp_integration:isPlayerScripter(client) then
			if not canPickup(client, source) then
				outputChatBox("You can not move this item. Contact an admin via F2.", client, 255, 0, 0)
				reset()
				return
			end

			local itemID = getElementData(source, "itemID")
			if itemID == 138 and not exports.vrp_integration:isPlayerDeveloper(client) then
				outputChatBox("Only a Lead+ admin can move this item.", client, 255, 0, 0)
				reset()
				return
			end
			
			if itemID == 139 and not exports.vrp_integration:isPlayerDeveloper(client) then
				outputChatBox("Only a Super+ admin can move this item.", client, 255, 0, 0)
				reset()
				return
			end


			if dbExec(mysql:getConnection(), "UPDATE worlditems SET x = " .. x .. ", y = " .. y .. ", z = " .. z .. ", rx = " .. rx .. ", ry = " .. ry .. ", rz = " .. rz .. " WHERE id = " .. getElementData( source, "id" ) ) then
				setElementPosition(source, x, y, z)

				setElementRotation(source, rx, ry, rz)

				outputChatBox('Saved item position for item #' .. getElementData( source, 'id' ) .. '.', client, 0, 255, 0)
			end
		else
			reset()
		end
	end)

local function rotateItem(item, rz)
	if not exports.vrp_integration:isPlayerTrialAdmin(source) then
		return
	end
	
	local id = getElementData(item, "id")
	if not rz then
		destroyElement(item)
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id = " .. (id))
		return
	end
	
	local rx, ry, rzx = getElementRotation(item)
	rz = rz + rzx
	local result = dbExec(mysql:getConnection(), "UPDATE worlditems SET rz = " .. rz .. " WHERE id = " .. (id) )
	if result then
		setElementRotation(item, rx, ry, rz)
	end
end
addEvent("rotateItem", true)
addEventHandler("rotateItem", getRootElement(), rotateItem)

function pickupItem(object, leftammo)
	if disableCanDropPick then
		outputChatBox("Item picking up is currently disabled. While our scripters are investigating the issue.", source, 255, 0, 0)
		return outputDebugString("[ITEM] pickupItem / disabled ")
	end
	
	if not isElement(object) then
		return outputDebugString("[ITEM] pickupItem / item is not an object.")
	end

	local x, y, z = getElementPosition(source)
	local ox, oy, oz = getElementPosition(object)
	
	if not (getDistanceBetweenPoints3D(x, y, z, ox, oy, oz)<10) then
		outputDebugString("Distance between Player and Pickup too large")
		return false
	end

	if getElementData(object, "transfering") then
		return outputDebugString("[ITEM] pickupItem / canceled / item is being transferred.")
	end
	outputDebugString("[ITEM] pickupItem / Running ")
	exports.vrp_anticheat:setEld(object, "transfering", true, "none") --No sync at all.
	--if true then return end
	-- Inventory Tooltip
	if (getResourceFromName("vrp_tooltips"))then
		triggerClientEvent(source,"tooltips:showHelp",source,14)
	end
	
	-- Animation
	
	local id = tonumber(getElementData(object, "id"))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_world_items)",source,255,0,0)
		destroyElement(object)
		return
	end
	
	local itemID = getElementData(object, "itemID")
	if not canPickup(source, object) then
		outputChatBox("#575757Valhalla: #ffffffBu öğeyi alamazsınız. F2 ile bir yetkiliye başvurun.", source, 255, 0, 0, true)
		exports.vrp_anticheat:changeEld(object, "transfering", nil)
		return
	end
	local itemValue = getElementData(object, "itemValue") or 1

	--ANTI ALT-ALT / MAXIME
	if ((itemID >= 31) and itemID <= 43) or itemBannedByAltAltChecker[itemID] then
		local hoursPlayedTo = getElementData( source, "hoursplayed" ) 
		if hoursPlayedTo and hoursPlayedTo < 10 and not exports.vrp_global:isStaffOnDuty(source) then
			outputChatBox("#575757Valhalla: #ffffff"..getItemName( itemID ).." yerden alabilmek için 10 saat oynaman olmalıdır.", source, 255, 0, 0, true)
			exports.vrp_anticheat:changeEld(object, "transfering", nil)
			return false
		end
		local creator = getElementData(object, "creator") or 0
		local picker = getElementData(source, "dbid")
		if creator ~= picker then
			local accountCreator = exports.vrp_cache:getAccountFromCharacterId(creator)
			if tonumber(accountCreator.id) == getElementData(source, "account:id") then
				outputChatBox("#575757Valhalla: #ffffffVarlıkların aynı hesaptaki karakterleri veya bir oyuncunun sahip olduğu çoklu hesaplar arasında aktarılması kesinlikle yasaktır! ", source, 255, 0, 0, true)
				exports.vrp_global:sendMessageToAdmins("[ANTI-ALT->ALT]: Detected illegal assets transferring on account name '"..getElementData(source, "account:username").."'.")
				exports.vrp_global:sendMessageToAdmins("[ANTI-ALT->ALT]: Suspect is trying to transfer a "..getItemName( itemID ).." between alternatives.")
				exports.vrp_logs:dbLog(source, 5, {object}, "TRIED TO ALT-ALT " .. getItemName( itemID ) .. " between alternatives.")
				exports.vrp_anticheat:changeEld(object, "transfering", nil)
				return false
			end
		end
	end
	
	if itemID == 115 then
		if isThisGunDuplicated(itemValue, source) then
			destroyElement(object)
			dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
			outputChatBox("#575757Valhalla: #ffffffSilah çoğaltılması tespit edilerek silahınız silindi, üzgünüz.", source, 255,0,0, true)
			return false
		end
	end
	
	if itemID == 138 then
		if not exports.vrp_integration:isPlayerAdmin(source) then
			outputChatBox("#575757Valhalla: #ffffffBu öğeyi sadece bir yetkili alabilir.", source, 255, 0, 0, true)
			exports.vrp_anticheat:changeEld(object, "transfering", nil)
			return false
		end
	end
	
	if itemID == 139 and not exports.vrp_integration:isPlayerTrialAdmin(source) then
		outputChatBox("#575757Valhalla: #ffffffBu öğeyi sadece bir yetkili alabilir.", source, 255, 0, 0, true)
		exports.vrp_anticheat:changeEld(object, "transfering", nil)
		return false
	end
	
	--[[ This block is currently doing nothing but preventing you from picking up generic item so I disabled it./ Maxime
	if (itemID==80) then
		local text2 = itemValue
		local pos2 = text2:find( ":" )
		if (pos2) then
			name = text2:sub( 1, pos2-1 )
		end
	end
	]]
	
	exports.vrp_global:applyAnimation(source, "CARRY", "liftup", 600, false, true, true)
	if itemID > 0 then
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
		while #getItems(object) > 0 do -- This one is suspicious / maxime
			moveItem2(object, source, 1)
			outputDebugString("Moved something, atleast trying to")
		end
	else
		if itemID == -100 then
			dbExec(mysql:getConnection(),  "DELETE FROM worlditems WHERE id='" .. id .. "'")
			setPedArmor(source, itemValue)
		else
			if leftammo and itemValue > leftammo then
				itemValue = itemValue - leftammo
				exports.vrp_anticheat:changeProtectedElementDataEx(object, "itemValue", itemValue)
				dbExec(mysql:getConnection(), "UPDATE worlditems SET itemvalue=" .. itemValue .. " WHERE id=" .. id)
				itemValue = leftammo
			else
				dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
			end
			exports.vrp_global:giveWeapon(source, -itemID, itemValue, true)
		end
	end

	exports.vrp_logs:dbLog(source, 39, {object}, "~World #" ..getElementID(object) .. "->" .. getPlayerName(source) .. " - " ..getItemName(itemID).. " - " ..itemValue)
	destroyElement(object)
	
	if itemID == 134 then -- money
		exports.vrp_global:giveMoney(source, itemValue)
		outputChatBox("" .. exports.vrp_global:formatMoney(itemValue) .. "$ alır.", source, 255, 194, 14)
		triggerEvent('sendAme', source, "" .. exports.vrp_global:formatMoney(itemValue) .. "$ alır.")
	elseif itemID == 178 then
		local yup = split(itemValue, ":")
		giveItem(source, itemID, itemValue)
		triggerEvent('sendAme', source, "" .. getItemDescription( itemID, itemValue ) .. " alır.")
	else
		giveItem(source, itemID, itemValue)
		outputChatBox("" .. getItemName( itemID, itemValue ) .. " alır.", source, 255, 194, 14)
		triggerEvent('sendAme', source, "" .. getItemName( itemID, itemValue ) .. " alır.")
	end
	doItemGivenChecks(source, itemID, itemValue)
	triggerClientEvent(source, "item:updateclient", source)

end
addEvent("pickupItem", true)
addEventHandler("pickupItem", getRootElement(), pickupItem)

function removeItemTransferingState()
	for i, object in pairs(exports.vrp_pool:getPoolElementsByType("object")) do
		exports.vrp_anticheat:changeEld(object, "transfering", nil)
	end
end
addEventHandler("onResourceStop", resourceRoot, removeItemTransferingState)
