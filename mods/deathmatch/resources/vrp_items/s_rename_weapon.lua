--Added by Adams
function renameWeapon(player, item, id, serial, wepName, wepCalibre, wepDesc)
	local itemSlot = item
	if player then
		local itemSlot = getItems(player)
		for i, v in ipairs(itemSlot) do
			if v[2] == item[2] then
			takeItem(player, 115, item[2])
			giveItem(player, 115, tonumber(id)..":"..tostring(serial)..":"..tostring(wepName)..":"..tostring(wepCalibre)..":"..tostring(wepDesc))
			
			outputChatBox("Weapon description set for "..wepName..".", player, 0, 255, 0)
			--updateItemValue(player, i, tonumber(id)..":"..tostring(serial)..":"..tostring(wepName)..":"..tostring(wepCalibre)..":"..tostring(wepDesc))
			--outputChatBox(item[2], player)
			end
		end
	end
end
addEvent("renameWeapon", true)
addEventHandler("renameWeapon", getRootElement(), renameWeapon)