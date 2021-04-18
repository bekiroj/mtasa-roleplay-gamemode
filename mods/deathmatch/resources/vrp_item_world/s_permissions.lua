
function getItemPropertiesData(object)
	if not object then return end

	local creatorName
	local creator = tonumber(getElementData(object, "creator")) or 0
	if creator > 0 then
		creatorName = exports.vrp_global:getCharacterNameFromID(creator)
	end

	if creatorName then
		triggerClientEvent(client, "item-world:fillItemPropertiesGUI", getResourceRootElement(), object, creatorName)
	end
end
addEvent("item-world:getItemPropertiesData", true)
addEventHandler("item-world:getItemPropertiesData", getResourceRootElement(), getItemPropertiesData)

function saveItemProperties(object, use, useData, move, moveData, pickup, pickupData)
	--blind save
	if not object or not isElement(object) then return end
	if getElementParent(getElementParent(object)) == getResourceRootElement(getResourceFromName("vrp_item_world")) then
		local id = tonumber(getElementData(object, "id"))
		if id then
			use = tonumber(use) or 1
			move = tonumber(move) or 1
			pickup = tonumber(pickup) or 1
			useData = toJSON(useData or {})
			moveData = toJSON(moveData or {})
			pickupData = toJSON(pickupData or {})
			local itemName = exports['vrp_items']:getItemName(tonumber(getElementData(object, "itemID")), getElementData(object, "itemValue"))

			local permissions = {use = use, move = move, pickup = pickup, useData = fromJSON(useData), moveData = fromJSON(moveData), pickupData = fromJSON(pickupData)}
			exports.vrp_anticheat:changeProtectedElementDataEx(object, "worlditem.permissions", permissions)

			local result = dbExec(mysql:getConnection(), "UPDATE `worlditems` SET `perm_use`="..use..", `perm_move`="..move..", `perm_pickup`="..pickup..", `perm_use_data`='"..(useData).."', `perm_move_data`='"..(moveData).."', `perm_pickup_data`='"..(pickupData).."' WHERE id="..id..";")
			if result then
				outputChatBox("Saved properties for '"..tostring(itemName).."'.", client, 0,255,0)
			else
				outputChatBox("Failed to save properties for '"..tostring(itemName).."'.", client, 255,0,0)
				outputChatBox("If the problem persists, please make a bug report.", client, 255,0,0)
			end
		end
	end
end
addEvent("item-world:saveItemProperties", true)
addEventHandler("item-world:saveItemProperties", getResourceRootElement(), saveItemProperties)