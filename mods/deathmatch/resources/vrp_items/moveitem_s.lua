local function canAccessElement( player, element )
	if getElementData(player, "dead") == 1 then
		return false
	end
	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--

local function output(from, to, itemID, itemValue, evenIfSamePlayer)
	if from == to and not evenIfSamePlayer then
		return false
	end
	
	-- player to player
	if getElementType(from) == "player" and getElementType(to) == "player" then
		--exports.vrp_global:sendLocalMeAction( from, "gives " .. getPlayerName( to ):gsub("_", " ") .. " a " .. getItemName( itemID, itemValue ) .. "." )
		exports.vrp_global:sendLocalMeAction(from, "sağ elinde bulunan ".. getItemName( itemID, itemValue ).." isimli öğeyi "..getPlayerName( to ):gsub("_", " ").." kişisine verir.")
	-- player to item
	elseif getElementType(from) == "player" then
		local name = getName(to)
		if itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  from, "puts an ATM card into the "..name.."." )
		else
			triggerEvent('sendAme',  from, "puts a " .. getItemName( itemID, itemValue ) .. " inside the ".. name .."." )
		end
	-- item to player
	elseif getElementType(to) == "player" then
		local name = getName(from)
		if itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  to, "takes an ATM from the "..name.."." )
		else
			triggerEvent('sendAme',  to, "takes a " .. getItemName( itemID, itemValue ) .. " from the ".. name .."." )
									local veh = getPedOccupiedVehicle(source)
			if veh then
			local dbid = getElementData(veh,"dbid")
			--exports["vrp_log"]:logKayit(dbid,getPlayerName( source ) , getItemName( itemID,itemValue )  ,name, "Aldi")
			end
		end
	end
	
	if itemID == 2 then
		triggerClientEvent(to, "phone:clearAllCaches", to, itemValue)
		triggerClientEvent(from, "phone:clearAllCaches", from, itemValue)
	end

	return true
end
function x_output_wrapper( ... ) return output( ... ) end

--

	

local function moveToElement( element, slot, ammo, event ) 
	if not canAccessElement( source, element ) then
		outputChatBox("You cannot access this inventory at the moment.", source, 255, 0, 0)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end 
	
	local name = getName(element)
			
	if not ammo then  
		local item = getItems( source )[ slot ]
		if item then
			-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
			if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
				local hoursPlayedFrom = getElementData( source, "hoursplayed" )
				local hoursPlayedTo = 99
				if isElement(element) and getElementType(element) == "player" then
					hoursPlayedTo = getElementData( element, "hoursplayed" ) 
				end
				
				if not exports.vrp_global:isStaffOnDuty(source) and not exports.vrp_global:isStaffOnDuty(element) then
					if hoursPlayedFrom < 10 then
						outputChatBox("You require 10 hours of playing time to move a "..getItemName( item[1] ).." to a "..name..".", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					
					if hoursPlayedTo < 10 then
						outputChatBox(string.gsub(getPlayerName(element), "_", " ").." requires 10 hours of playing time to receive a "..getItemName( item[1] ).." from you.", source, 255, 0, 0)
						outputChatBox("You require 10 hours of playing time to receive a "..getItemName( item[1] ).." from "..string.gsub(getPlayerName(source), "_", " ")..".", element, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
				end
				--outputDebugString(hoursPlayedFrom.." "..hoursPlayedTo)
			end
		
			if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
				--[[if item[1] == 121 and not getElementData(element,"customshop") then-- supplies box
					triggerEvent("shop:handleSupplies", source, element, slot, event)
					return true
				end]] -- Removed by MAXIME 
				if getElementData(element,"customshop") then
					
					triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
					return true
				end
				triggerClientEvent( source, event or "finishItemMove", source )
				return false
			end
				
			if not (getElementModel( element ) == 2942) and not hasSpaceForItem( element, item[1], item[2] ) then --Except for ATM Machine / MAXIME
				outputChatBox( "The inventory is full.", source, 255, 0, 0 )
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.vrp_global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.vrp_global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
						outputChatBox("You can't put your duty weapon in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 116) then -- Ammo
					local ammoDetails = exports.vrp_global:explode( ":", item[2]  )
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then -- /duty
						outputChatBox("You can't put your duty ammo in a " .. name .. " while being on duty.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 179 and getElementType(element) == "vehicle") then --vehicle texture
					outputDebugString("vehicle texture")
					local vehID = getElementData(element, "dbid")
					local veh = element
					if(exports.vrp_global:isStaffOnDuty(source) or exports.vrp_integration:isPlayerScripter(source) or exports.vrp_global:hasItem(source, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.vrp_factions:isPlayerInFaction(source, getElementData(veh, "faction"))) ) then
						outputDebugString("access granted")
						local itemExploded = exports.vrp_global:explode(";", item[2])
						local url = itemExploded[1]
						local texName = itemExploded[2]
						if url and texName then
							local res = exports["vrp_item_texture"]:addVehicleTexture(source, veh, texName, url)
							if res then
								takeItemFromSlot(source, slot)
								outputDebugString("success")
								outputChatBox("success", source)
							else
								outputDebugString("item-system/s_move_items: Failed to add vehicle texture")
							end
							triggerClientEvent(source, event or "finishItemMove", source)
							return
						end
					end
				end
				
				if (item[1] == 137 or item[1] == 572 or item[1] == 580 or item[1] == 589 or item[1] == 590 or item[1] == 581 or item[1] == 556 or item[1] == 557 or item[1] == 558 or item[1] == 559 or item[1] == 555 or item[1] == 64 or item[1] == 571 or item[1] == 570 or item[1] == 568 or item[1] == 569 or item[1] == 573 or item[1] == 574 or item[1] == 575 or item[1] == 134 or item[1] == 576) or item[1] == 577 then -- Snake cam
					outputChatBox("Bu eşyayı başka bir kişiye & bölgeye veya araca aktaramazsın.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return		
				elseif item[1] == 138 then
					if not exports.vrp_integration:isPlayerAdmin(source) then
						outputChatBox("It requires an admin to move this item.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					
				--[[elseif item[1] == 115 then
				if not exports.vrp_global:isStaffOnDuty(source) and not exports.vrp_global:isStaffOnDuty(element) then
					if hoursPlayedFrom < 10 then
						outputChatBox("You require 10 hours of playing time to move a "..getItemName( item[1] ).." to a "..name..".", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
				
				if not exports.vrp_integration:isPlayerAdmin(source) then
						outputChatBox("Birisine silah göndermek istiyorsun bunun için admin çağır.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end]]--
				elseif item[1] == 139 then
					if not exports.vrp_integration:isPlayerTrialAdmin(source) then
						outputChatBox("It requires a trial administrator to move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end
				
				if (item[1] == 333) then -- uyusturucu
				if (getElementType(element) == "object") and (getElementType(source) == "player") then
				if getElementData(element, "sahibi") ~= getElementData(source, "dbid") or getElementData(element, "yetisiyor") == true then 
				return false
				end
				local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						 konum = getElementPosition(element)
				x,y,z = getElementPosition(element)
				triggerEvent ( "saksiyazdir", source, source, x,y,z, element)
				triggerClientEvent( source, event or "finishItemMove", source )
				end
				end

				
					if getElementType( element ) == "object" then
						local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						if elementItemID then
							if elementItemID == 166 then --video player
								if item[1] ~= 165 then --if item being moved to video player is not a valid video item
									exports.vrp_hud:sendBottomNotification(source, "Video Player", "That is not a valid disc.")
									triggerClientEvent( source, event or "finishItemMove", source )
									return									
								end
							end
						end
						if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
							if countItems( source, item[1], item[2] ) < 2 then
								outputChatBox("You can't place your only key to that safe in the safe.", source, 255, 0, 0)
								triggerClientEvent( source, event or "finishItemMove", source )
								return
							end
						end
					end
					
					local success, reason = moveItem( source, element, slot )
					if not success then
						if not elementItemID then elementItemID = getElementData(element, "itemID") end
						local fakeReturned = false
						if elementItemID then
							if elementItemID == 166 then --video system
								exports.vrp_hud:sendBottomNotification(source, "Video Player", "There is already a disc inside. Eject old disc first.")
								fakeReturned = true
							end
						end
						if not fakeReturned then --only check by model IDs if we didnt already find a match on itemID
							if getElementModel(element) == 2942 then
								exports.vrp_hud:sendBottomNotification(source, "ATM Machine", "There is another ATM stuck inside the ATM machine's slot. Right-click for interactions.")
							end
						end
						outputDebugString( "Item Moving failed: " .. tostring( reason ))
					else
						if getElementModel(element) == 2942 then
							exports.vrp_bank:playAtmInsert(element)
						elseif item[1] == 165 then --video disc
							if exports.vrp_clubtec:isVideoPlayer(element) then
								--triggerEvent("sendAme",  source, "ejects a disc from the video player." )
								for key, value in ipairs(getElementsByType("player")) do
									if getElementDimension(value)==getElementDimension(element) then
										triggerEvent("fakevideo:loadDimension", value)
									end
								end
							end
						end
						--exports.vrp_logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
						--exports.vrp_logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
						doItemGiveawayChecks( source, item[1] )
						output(source, element, item[1], item[2])
					end
				if getElementType( element ) == "vehicle" then
              --  exports["vrp_log"]:logKayit(getElementID(element),getPlayerName( source ) , getItemName( item[1],item[2] )  ,name,"Koydu")
                exports.vrp_logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
                elseif getElementType( element ) == "player" then
                -- exports["vrp_log"]:logKayitt(getElementID(source),getPlayerName( element ) , getItemName( item[1],item[2] )  ,getPlayerName(source),"Aldı")
               -- exports["vrp_log"]:logKayit(getElementID(element),getPlayerName( source ) , getItemName( item[1],item[2] )  ,getPlayerName(element),"Verdi")
                end			
				end
		end
	else -- IF AMMO
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
		else
			if tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("You can't put your weapons in a " .. name .. " while being on duty.", source, 255, 0, 0)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("You can't put this spray can into a " .. name .. ".", source, 255, 0, 0)
			else
				if slot == -100 then 	
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						--exports.vrp_logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( slot ) .. " - " .. ammo, 17)
						exports.vrp_logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.vrp_global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.vrp_global:sendMessageToAdmins("[items\moveToElement] Possible duplication of gun from '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						--exports.vrp_logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo .. " BLOCKED DUE POSSIBLE DUPING", 17)
						exports.vrp_logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " -  #" .. getElementID(element) .. " - BLOCKED DUE POSSIBLE DUPING" )
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					exports.vrp_global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						--exports.vrp_logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo, 17)
						exports.vrp_logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -slot)
					end
				end
			end
		end
	end
	outputDebugString("moveToElement")
	triggerClientEvent( source, event or "finishItemMove", source )
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if true then
		return outputDebugString("[ITEM] moveWorldItemToElement / Disabled ")
	end

	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end
	
	local id = tonumber(getElementData( item, "id" ))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_move_items)",source,255,0,0)
		destroyElement(element)
		return
	end
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	local name = getName(element)
	
	-- ANTI ALT-ALT  MAXIME
	--31 -> 43  = DRUGS
	if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
		outputChatBox(getItemName(itemID).." can only moved directly from your inventory to this "..name..".", source, 255, 0, 0)
		return false
	end

	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
	end
	
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return
	end
	
	if itemID == 138 then
		if not exports.vrp_integration:isPlayerAdmin(source) then
			outputChatBox("Only a full admin can move this item.", source, 255, 0, 0)
			return
		end
	end

	if itemID == 169 then
		--outputChatBox("Nay.")
		return
	end

	if giveItem( element, itemID, itemValue ) then
		--[[
		if itemID == 166 then --video player
			local videoplayerDisc = exports.vrp_clubtec:getVideoPlayerCurrentVideoDisc(item) or 2
			local videoplayerObject = nil
			local dimensionPlayers = {}
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(item) then
					table.insert(dimensionPlayers,value)
				end
			end			
			triggerClientEvent(dimensionPlayers, "fakevideo:removeOne", source, videoplayerDisc, itemValue, videoplayerObject)
		end	
		--]]

		output(source, element, itemID, itemValue, true)
		--exports.vrp_logs:logMessage( getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element), 17)
		exports.vrp_logs:dbLog( source, 39, source, getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element))
		dbExec(mysql:getConnection(), "DELETE FROM worlditems WHERE id='" .. id .. "'")
		
		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )

		if itemID == 166 then --video player
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(source) then
					triggerEvent("fakevideo:loadDimension", value)
				end
			end			
		end
	else
		outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if false then
		return outputDebugString("[ITEM] moveFromElement / Disabled ")
	end
	
	if not canAccessElement( source, element ) then
		return false
	end
	local item = getItems( element )[slot]
	if not canPickup(source, item) then
		outputChatBox("You can not move this item. Contact an admin via F2.", source, 255, 0, 0)
		return 
	end
	
	
	local name = getName(element)
	
	if item and item[3] == index then
		-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
		
		if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
			local hoursPlayedTo = nil
			
			if isElement(source) and getElementType(source) == "player" then
				hoursPlayedTo = getElementData( source, "hoursplayed" ) 
			end
			
			if not exports.vrp_global:isStaffOnDuty(source) and not exports.vrp_global:isStaffOnDuty(element) then
				if hoursPlayedTo < 10 then
					outputChatBox("You require 10 hours of playing time to receive a "..getItemName( item[1] ).." from a "..name..".", source, 255, 0, 0)
					triggerClientEvent( source, "forceElementMoveUpdate", source )
					triggerClientEvent( source, "finishItemMove", source )
					return false
				end
			end
		end



		if not hasSpaceForItem( source, item[1], item[2] ) then
			outputChatBox( "The inventory is full.", source, 255, 0, 0 )
		else
		if not exports.vrp_integration:isPlayerTrialAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117 or item[1] == 140) then
			outputChatBox( "Please contact an admin via F2 to move this item.", source, 255, 0, 0 )
		elseif not exports.vrp_integration:isPlayerAdmin(source) and (item[1] == 138) then
			outputChatBox("This item requires a regular admin to be moved.", source, 255, 0, 0)
		elseif not exports.vrp_integration:isPlayerTrialAdmin(source) and (item[1] == 139) then
			outputChatBox("This item requires an admin to be moved.", source, 255, 0, 0)
		elseif item[1] > 0 then			
			if moveItem( element, source, slot ) then
				output( element, source, item[1], item[2])
				exports.vrp_logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				doItemGivenChecks(source, tonumber(item[1]))
			end
		elseif item[1] == -100 then
			local armor = math.max( 0, ( ( getElementData( source, "faction" ) == 1 or ( getElementData( source, "faction" ) == 3 and ( getElementData( source, "factionrank" ) == 4 or getElementData( source, "factionrank" ) == 5 or getElementData( source, "factionrank" ) == 13 ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )
			
			if armor == 0 then
				outputChatBox( "You can't wear any more armor.", source, 255, 0, 0 )
			else
				output( element, source, item[1])
				takeItemFromSlot( element, slot )
				
				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end
				
				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				--exports.vrp_logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ), 17)
				exports.vrp_logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ))
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1])
			if ammo < item[2] then
				exports.vrp_global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				--exports.vrp_logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ), 17)
				exports.vrp_logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ))
			else
				exports.vrp_global:giveWeapon( source, -item[1], item[2] )
				--exports.vrp_logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
				exports.vrp_logs:dbLog(source, 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	end
	elseif item then
		outputDebugString( "Index mismatch: " .. tostring( item[3] ) .. " " .. tostring( index ) )
	end
	outputDebugString("moveFromElement")
	triggerClientEvent( source, "finishItemMove", source )
end
addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )

function getName(element)
	if getElementModel( element ) == 2942 then
		return "ATM Machine"
	elseif getElementModel( element ) == 2147 then
		return "fridge" 
	elseif getElementModel(source) == 3761 then
		return "shelf"
	end

	if getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("vrp_item_world")) then
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		--local itemValue = getElementData(element, "itemValue")
		if itemID == 166 then --video player
			return "video player"
		end
	end

	if getElementType( element ) == "vehicle" then
		--[[local brand, model, year = (getElementData(element, "brand") or false), false, false
		
		if brand then
			model = getElementData(element, "maximemodel") or ""
			year = getElementData(element, "year") or ""
			return brand.." "..model.." "..year
		end
		
		local mtamodel = getElementModel(element)
		return getVehicleNameFromModel(mtamodel)]]
		return exports.vrp_global:getVehicleName(element)
	end

	if getElementType( element ) == "interior" then
		return getElementData(element, "name").."'s Mailbox"
	end
	
	if getElementType( element ) == "player" then
		return "player" 
	end
	
	return "safe"
end
