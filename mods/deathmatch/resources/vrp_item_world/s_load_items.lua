function loadOneWorldItem(id1)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local id = tonumber(row["id"])
					local itemID = tonumber(row["itemid"])
					local itemValue = tonumber(row["itemvalue"]) or row["itemvalue"]
					local x = tonumber(row["x"])
					local y = tonumber(row["y"])
					local z = tonumber(row["z"])
					local dimension = tonumber(row["dimension"])
					local interior = tonumber(row["interior"])
					local rx2 = tonumber(row["rx"]) or 0
					local ry2 = tonumber(row["ry"]) or 0
					local rz2 = tonumber(row["rz"]) or 0
					local creator = tonumber(row["creator"])
					local createdDate = tostring(row["creationdate"])
					local protected = tonumber(row["protected"])
					local permUse = tonumber(row["perm_use"])
					local permMove = tonumber(row["perm_move"])
					local permPickup = tonumber(row["perm_pickup"])
					local permUseData = fromJSON(type(row["perm_use_data"])== "string" and row["perm_use_data"] or "")
					local permMoveData = tonumber(row["perm_use_data"])
					local permPickupData = tonumber(row["perm_pickup_data"])
					if itemID < 0 then -- weapon
						itemID = -itemID
						local modelid = 2969
						-- MODEL ID
						if itemValue == 100 then
							modelid = 1242
						elseif itemValue == 42 then
							modelid = 2690
						else
							modelid = weaponmodels[itemID]
						end
					
						local obj = createItem(id, -itemID, itemValue, modelid, x, y, z - 0.1, 75, -10, rz2)
						exports.vrp_pool:allocateElement(obj)
						setElementDimension(obj, dimension)
						setElementInterior(obj, interior)
						exportsvrp_.anticheat:changeProtectedElementDataEx(obj, "creator", creator)
						exports.vrp_anticheat:changeProtectedElementDataEx(obj, "createdDate", createdDate)
						
						if protected and protected ~= 0 then
							exports.vrp_anticheat:changeProtectedElementDataEx(obj, "protected", protected)
						end
					else
						local modelid = exports['vrp_items']:getItemModel(itemID, itemValue)
						
						if (itemID==80) then
							local text = tostring(itemValue)
							local pos = text:find( ":" )
							if (text) and (pos) then
								text = text:sub( pos+1 )
								if tonumber(text) then
									modelid = tonumber(text)
								else
									modelid = 1241
								end
							end
						end
						
						local rx, ry, rz, zoffset = exports['vrp_items']:getItemRotInfo(itemID)
						local obj = createItem(id, itemID, itemValue, modelid, x, y, z + ( zoffset or 0 ), rx+rx2, ry+ry2, rz+rz2)
						
						if isElement(obj) then
							exports.vrp_pool:allocateElement(obj, itemID, true)
							setElementDimension(obj, dimension)
							setElementInterior(obj, interior)
							exports.vrp_anticheat:changeProtectedElementDataEx(obj, "creator", creator)
							exports.vrp_anticheat:changeProtectedElementDataEx(obj, "createdDate", createdDate)
							
							if protected and protected ~= 0 then
								exports.vrp_anticheat:changeProtectedElementDataEx(obj, "protected", protected)
							end

							local permissions = { use = permUse, move = permMove, pickup = permPickup, useData = permUseData, moveData = permMoveData, pickupData = permPickupData }
							anticheat:changeProtectedElementDataEx(obj, "worlditem.permissions", permissions)
						else
							outputDebugString(id .. "/" .. itemID .. "/" .. itemValue .. "/" .. modelid)
						end
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `id`, `itemid`, `itemvalue`, `x`, `y`, `z`, `dimension`, `interior`, `rx`, `ry`, `rz`, `creator`, `creationdate`, `protected`, `perm_use`, `perm_move`, `perm_pickup`, `perm_use_data`, `perm_move_data`, `perm_pickup_data` FROM `worlditems` WHERE `id`='"..id1.."' ")
end


function loadWorldItems(res)
	local ticks = getTickCount( )

	dbExec(exports.vrp_mysql:getConnection(), "DELETE FROM `worlditems` WHERE `protected`='0' AND `itemID` NOT IN(81, 103, 169) AND ( (DATEDIFF(NOW(), creationdate) > 30 ) OR (DATEDIFF(NOW(), creationdate) > 7 AND `itemID` = 72) ) " )
	
	-- actually load items
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadOneWorldItem(row.id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `id` FROM `worlditems`")
	setTimer(restartResource, timerDelay+60000, 1, getResourceFromName("vrp_item_texture")) -- Restart item texture resource 60 seconds after all world items loading done. / Maxime
end
addEventHandler("onResourceStart", resourceRoot, loadWorldItems)