mysql = exports.vrp_mysql
local useShopsWithNoItems = false
local profitRate = tonumber(get( "profitRate" )) or 5

local skins = { { 211, 217 }, { 179 }, false, { 178 }, { 82 }, { 80, 81 }, { 28, 29 }, { 169 }, { 171, 172 }, { 142 }, { 171 }, { 171, 172 }, {71}, { 50 }, { 1 }, { 118 }, {118} }

function createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation, skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo, faction_belong, faction_access) 
	if not g_shops[shoptype] then
		outputDebugString("Trying to locate shop #" .. id .. " with invalid shoptype " .. shoptype)
		return
	end
	
	if shoptype == 17 then
		if tonumber(dimension) == 0 and tonumber(interior) == 0 then
			return false
		end
	end
	
	if not skin then
		skin = 0
		
		if shoptype == 3 then
			skin = 168
			-- needs differences for burgershot etc
			if interior == 5 then
				skin = 155
			elseif interior == 9 then
				skin = 167
			elseif interior == 10 then
				skin = 205
			end
			-- interior 17 = donut shop
		elseif shoptype == 16 then
			skin = 27
		else
			-- clothes, interior 5 = victim
			-- clothes, interior 15 = binco
			-- clothes, interior 18 = zip
			skin = skins[shoptype][math.random( 1, #skins[shoptype] )]
		end
	end 
	
	local ped = createPed(skin, x, y, z)
	setElementRotation(ped, 0, 0, rotation)
	setElementDimension(ped, dimension)
	setElementInterior(ped, interior)
	exports.vrp_pool:allocateElement(ped)
	
	if shoptype == 17 then
		setElementData(ped, "customshop", true)
	elseif shoptype == 18 or shoptype == 19 then --Faction Drop NPCs
		exports.vrp_anticheat:changeProtectedElementDataEx(ped, "faction_belong", faction_belong, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(ped, "faction_access", faction_access, true)
	end 
	
	setElementData(ped, "talk", 1, true)
	setElementData(ped, "name", pedName, true) 
	setElementData(ped, "shopkeeper", true)
		
	setElementFrozen(ped, true)
	
	setElementData(ped, "dbid", tonumber(id), true)
	setElementData(ped, "ped:type", "shop", false)
	setElementData(ped, "shoptype", shoptype, false)
	setElementData(ped, "rotation", rotation, false)
	setElementData(ped, "sPendingWage", sPendingWage, true)
	setElementData(ped, "sIncome", (shoptype == 14 and 0 or tonumber(sIncome)), true)
	setElementData(ped, "sCapacity", sCapacity, true)
	setElementData(ped, "currentCap", currentCap, true) 
	setElementData(ped, "sSales", sSales, true) 
	setElementData(ped, "sContactInfo", sContactInfo, true) 
end

function delNearbyGeneralshops(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Deleting Nearby Shop NPC(s):", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
			local pedType = getElementData(thePed, "ped:type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						if deleteGeneralShop(thePlayer, "delshop" , dbid) then
							--outputChatBox("   Deleted Shop with ID #" .. dbid .. " and type "..shoptype..".", thePlayer, 255, 126, 0)
							count = count + 1
						end
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   Deleted None.", thePlayer, 255, 126, 0)
		else
			outputChatBox("   Deleted "..count.." None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("delnearbyshops", delNearbyGeneralshops, false, false)
addCommandHandler("delnearbynpcs", delNearbyGeneralshops, false, false)

-- function createDynamic(x,y,z,interior,dimension,id,rotation,skin ~= -1 and skin, products)
	-- if not skin then
		-- skin = skins[8][math.random( 1, #skins[8] )]
	-- end
	-- local ped = createPed(skin, x, y, z)
	-- setElementDimension(ped, dimension)
	-- setElementInterior(ped, interior)
	-- exports.vrp_pool:allocateElement(ped)
	
	-- setElementData(ped, "shopkeeper", true)
	-- setElementFrozen(ped, true)
	-- setElementData(ped, "dbid", id, false)
	-- setElementData(ped, "ped:type", "shop", false)
	-- setElementData(ped, "shoptype", 0, false)
	-- setElementData(ped, "rotation", rotation, false)
-- end

function SmallestID()
    local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM shops AS e1 LEFT JOIN shops AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
    local result = dbPoll(query, -1)
    if result then
        return  tonumber(result[1]["nextID"]) or 1
    end
    return false
end

function createGeneralshop(thePlayer, commandName, shoptype, skin, ...)
	if exports.vrp_integration:isPlayerLeadAdmin(thePlayer) then
		local shoptype = tonumber(shoptype)
		if not shoptype or not g_shops[shoptype] then
			outputChatBox("KULLANIM: /" .. commandName .. " [shop type] [skin, -1 = random] [Firstname Lastname, -1 = random]", thePlayer, 255, 194, 14)
			for k, v in ipairs(g_shops) do
				outputChatBox("TYPE " .. k .. " = " .. v.name, thePlayer, 200, 200, 200)
			end
			return false
		end

		local skin = tonumber(skin)
		
		if not skin or skin == -1 then --Random
			skin = exports.vrp_global:getRandomSkin()
		end
		
		if skin then
			local ped = createPed(skin, 0, 0, 3)
			if not ped then
				outputChatBox("Invalid Skin.", thePlayer, 255, 0, 0)
				return
			else
				destroyElement(ped)
			end
		else
			skin = -1
		end
		
		local x, y, z = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		local interior = getElementInterior(thePlayer)
		local _, _, rotation = getElementRotation(thePlayer)
		
		if shoptype == 17 then
			if dimension == 0 and interior == 0 then
				outputChatBox("Custom shop must be created in a business interior.", thePlayer, 255, 0, 0)
				return false
			end
		end
		
		local pedName = table.concat({...}, "_") or false
		
		if not pedName or pedName=="" or (tonumber(pedName) and tonumber(pedName) == -1) then
			pedName = exports.vrp_global:createRandomMaleName()
			pedName = string.gsub(pedName, " ", "_")
		end
		
		local iCan, why = canIUseThisName(pedName)
		if not iCan then
			outputChatBox(why, thePlayer, 255, 0, 0)
			return false
		end
		
		local id = false
		id = dbExec(mysql:getConnection(), "INSERT INTO shops SET pedName='"..exports.vrp_global:toSQL(pedName).."', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', dimension='" .. (dimension) .. "', interior='" .. (interior) .. "', shoptype='" .. (shoptype) .. "', rotationz='" .. (rotation) .. "', skin='".. (skin).."' ")
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local id = res[1]['id']
					createShopKeeper(x,y,z,interior,dimension,id,tonumber(shoptype),rotation,skin ~= -1 and skin, 0, 0, 10, 0, "", pedName, {"", "", "", ""}, 0, 0)
				end
			end,
		mysql:getConnection(), "SELECT id FROM shops WHERE id = LAST_INSERT_ID()")
	end
end
addCommandHandler("makeshop", createGeneralshop, false, false)

function getNearbyGeneralshops(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Nearby Shop NPC(s):", thePlayer, 255, 126, 0)
		local count = 0
		
		local dimension = getElementDimension(thePlayer)
		
		for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
			local pedType = getElementData(thePed, "ped:type")
			if (pedType) then
				if (pedType=="shop") then
					local x, y = getElementPosition(thePed)
					local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
					local cdimension = getElementDimension(thePed)
					if (distance<=10) and (dimension==cdimension) then
						local dbid = getElementData(thePed, "dbid")
						local shoptype = getElementData(thePed, "shoptype")
						local pedName = getElementData(thePed, "name") or "Unnamed"
						outputChatBox("   Shop ID #" .. dbid .. ", type "..shoptype..", name: "..tostring(pedName):gsub("_", " "), thePlayer, 255, 126, 0)
						count = count + 1
					end
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyshops", getNearbyGeneralshops, false, false)
addCommandHandler("nearbynpcs", getNearbyGeneralshops, false, false)

function moveNPCshop(thePlayer, commandName, value)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
	
	if not tonumber(value) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Shop ID]", thePlayer, 255, 194, 14)
		return
	end

	local dimension = getElementDimension(thePlayer)

	local possibleShops = getElementsByType("ped", resourceRoot)
	local foundShop = false
		for _, shop in ipairs(possibleShops) do
			if getElementData(shop,"shopkeeper") and (tonumber(getElementData(shop, "dbid")) == tonumber(value)) then
				foundShop = shop
				break
			end
		end

	if not foundShop then 
		outputChatBox("No shop founded with ID #"..value, thePlayer, 255, 0, 0)
		return
	end

	local x, y, z = getElementPosition(thePlayer)
	local dim = getElementDimension(thePlayer)
	local int = getElementInterior(thePlayer)
	local rot, rot1, rot2 = getElementRotation(thePlayer)

	change = dbExec(mysql:getConnection(), "UPDATE shops SET x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', dimension='" .. (dim) .. "', interior='" .. (int) .. "', rotationz='" .. (rot2) .. "' WHERE id=".. (tonumber(value)))

	setElementPosition(foundShop, x, y, z)
	setElementDimension(foundShop, dim)
	setElementInterior(foundShop, int)
	setElementRotation(foundShop, rot, rot1, rot2)

	outputChatBox("Updated shop position.", thePlayer, 0, 255, 0)

	end
end
addCommandHandler("moveshop", moveNPCshop)
addCommandHandler("moveNPC", moveNPCshop)
addCommandHandler("movenpc", moveNPCshop)

function gotoShop(thePlayer, commandName, shopID)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not tonumber(shopID) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Shop ID]", thePlayer, 255, 194, 14)
		else
			local possibleShops = getElementsByType("ped", resourceRoot)
			local foundShop = false
			for _, shop in ipairs(possibleShops) do
				if getElementData(shop,"shopkeeper") and (tonumber(getElementData(shop, "dbid")) == tonumber(shopID)) then
					foundShop = shop
					break
				end
			end
			
			if not foundShop then
				outputChatBox("No shop founded with ID #"..shopID, thePlayer, 255, 0, 0)
				return false
			end
				
			local x, y, z = getElementPosition(foundShop)
			local dim = getElementDimension(foundShop)
			local int = getElementInterior(foundShop)
			local _, _, rot = getElementRotation(foundShop)
			startGoingToShop(thePlayer, x,y,z,rot,int,dim,shopID)
		end
	end
end
addCommandHandler("gotoshop", gotoShop, false, false)

function startGoingToShop(thePlayer, x,y,z,r,interior,dimension,shopID)
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
	outputChatBox(" You have teleported to shop ID#"..shopID, thePlayer)
end

function restoreGeneralShop(thePlayer, commandName, id)
    if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
        if not (id) then
            id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
            if not id then
                outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
                return false
            end
        end
        
        local dbid = id
        
        dbQuery(
            function(qh, thePlayer)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                         if not (row) then
                            outputChatBox("Shop ID #" .. dbid .. " isn't found in deleted shop database.", thePlayer, 255, 0, 0)
                            return false
                        end
                        
                        dbExec(mysql:getConnection(),"UPDATE `shops` SET `deletedBy` = '0' WHERE id='" .. (dbid) .. "' LIMIT 1")
                        loadOneShop(dbid)
                        outputChatBox("Restored shop with ID #" .. dbid .. ".", thePlayer, 0, 255, 0)
                    end
                end
            end,
        {thePlayer}, mysql:getConnection(), "SELECT `id` FROM `shops` WHERE `id`='"..tostring(dbid).."' AND `deletedBy` != '0'")
    end
end
addCommandHandler("restoreshop", restoreGeneralShop, false, false)
addCommandHandler("restorenpc", restoreGeneralShop, false, false)
addCommandHandler("restoreped", restoreGeneralShop, false, false)


function deleteGeneralShop(thePlayer, commandName, id)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			local counter = 0
			
			for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
				local pedType = getElementData(thePed, "ped:type")
				if (pedType) then
					if (pedType=="shop") then
						local dbid = getElementData(thePed, "dbid")
						if (tonumber(id)==dbid) then
							destroyElement(thePed)
							local adminID = getElementData(thePlayer,"account:id")
							dbExec(mysql:getConnection(),"UPDATE `shops` SET `deletedBy` = '"..tostring(adminID).."' WHERE id='" .. (dbid) .. "' LIMIT 1")
							--dbExec(mysql:getConnection(),"DELETE FROM shop_products WHERE npcID='" .. (dbid) .. "' ")
							--dbExec(mysql:getConnection(),"DELETE FROM shop_contacts_info WHERE npcID='" .. (dbid) .. "' ")
							outputChatBox("      Deleted shop with ID #" .. id .. ".", thePlayer, 0, 255, 0)
							counter = counter + 1
							setElementData(thePlayer, "shop:mostRecentDeleteShop",dbid, true )
						end
					end
				end
			end
			
			if (counter==0) then
				outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
				return false
			end
			return true
		end
	end
end
addCommandHandler("delshop", deleteGeneralShop, false, false)
addCommandHandler("deleteshop", deleteGeneralShop, false, false)

function removeGeneralShop(thePlayer, commandName, id)
    if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
        if not (id) then
            id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
            if not id then
                outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
                return false
            end
        end
        
        local dbid = id
        dbQuery(
            function(qh, thePlayer)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        if not (row) then
                            outputChatBox("Shop ID #" .. dbid .. " isn't found in deleted shop database, /delshop first.", thePlayer, 255, 0, 0)
                            return false
                        end
                        
                        
                        if dbExec(mysql:getConnection(),"DELETE FROM shops WHERE id='" .. (dbid) .. "' LIMIT 1") and    dbExec(mysql:getConnection(),"DELETE FROM shop_products WHERE npcID='" .. (dbid) .. "' ") and dbExec(mysql:getConnection(),"DELETE FROM shop_contacts_info WHERE npcID='" .. (dbid) .. "' ") then
                            outputChatBox("Removed shop ID #" .. dbid .. " from SQL.", thePlayer, 0, 255, 0)
                            setElementData(thePlayer, "shop:mostRecentDeleteShop",false, true )
                        else
                            outputChatBox("No shops with such an ID exists.", thePlayer, 255, 0, 0)
                        end
                    end
                end
            end,
        {thePlayer}, "SELECT `id` FROM `shops` WHERE `id`='"..tostring(dbid).."' AND `deletedBy` != '0'")
        
    end
end
addCommandHandler("removeshop", removeGeneralShop, false, false)
addCommandHandler("removenpc", removeGeneralShop, false, false)
addCommandHandler("removeped", removeGeneralShop, false, false)

function loadAllGeneralshops(res)
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local id = tonumber(row["id"]) 
                    local x = tonumber(row["x"])
                    local y = tonumber(row["y"])
                    local z = tonumber(row["z"])
                        
                    local dimension = tonumber(row["dimension"])
                    local interior = tonumber(row["interior"])
                    local shoptype = tonumber(row["shoptype"])
                    local rotation = tonumber(row["rotationz"])
                    local skin = tonumber(row["skin"])
                    local sPendingWage = tonumber(row["sPendingWage"])
                    local sIncome = tonumber(row["sIncome"])
                    local sCapacity = tonumber(row["sCapacity"])
                    local currentCap = 0
                    local sSales = row["sSales"]
                    local pedName = row["pedName"] or false

                    local sContactInfo = {row["sOwner"],row["sPhone"],row["sEmail"],row["sForum"]}
                    local faction_belong = tonumber(row["faction_belong"])
                    local faction_access = tonumber(row["faction_access"])
                    
                    createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo, faction_belong, faction_access)
                    
                end
            end
        end,
    mysql:getConnection(), "SELECT `shops`.`id` AS `id`, `x`, `y`, `z`, `dimension`, `interior`, `shoptype`, `rotationz`, `skin`, `sPendingWage`, `sIncome`, `sCapacity`, `sSales`, `pedName`, `sOwner`, `sPhone`, `sEmail`, `sForum`, `faction_belong`, `faction_access` FROM `shops` LEFT JOIN `shop_contacts_info` ON `shops`.`id` = `shop_contacts_info`.`npcID` WHERE `shops`.`deletedBy` = '0'")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllGeneralshops)

function loadOneShop(shopID)
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    local id = tonumber(row["id"]) 
                    local x = tonumber(row["x"])
                    local y = tonumber(row["y"])
                    local z = tonumber(row["z"])
                        
                    local dimension = tonumber(row["dimension"])
                    local interior = tonumber(row["interior"])
                    local shoptype = tonumber(row["shoptype"])
                    local rotation = tonumber(row["rotationz"])
                    local skin = tonumber(row["skin"])
                    local sPendingWage = tonumber(row["sPendingWage"])
                    local sIncome = tonumber(row["sIncome"])
                    local sCapacity = tonumber(row["sCapacity"])
                    local currentCap = 0
                    local sSales = row["sSales"]
                    local pedName = row["pedName"] or false

                    local sContactInfo = {row["sOwner"],row["sPhone"],row["sEmail"],row["sForum"]}
                    local faction_belong = tonumber(row["faction_belong"])
                    local faction_access = tonumber(row["faction_access"])
                    
                    createShopKeeper(x,y,z,interior,dimension,id,shoptype,rotation,skin ~= -1 and skin, sPendingWage, sIncome, sCapacity, currentCap, sSales, pedName, sContactInfo, faction_belong, faction_access)
                    
                end
            end
        end,
    mysql:getConnection(), "SELECT COUNT(*) as `currentCap` FROM `shop_products` WHERE `npcID` = '"..tostring(id).."' ")
    return true
end


function reloadGeneralShop(thePlayer, commandName, id)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (id) then
			id = getElementData(thePlayer, "shop:mostRecentDeleteShop") or false
			if not id then
				outputChatBox("KULLANIM: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
				return false
			end
		end
		
		if loadOneShop(id) then
			outputChatBox("Reloaded shop ID#"..id..".",thePlayer, 0,255,0)
		else
			outputChatBox("Reloaded shop ID#"..id..".",thePlayer, 255,0,0)
		end
	end
end
addCommandHandler("reloadshop", reloadGeneralShop, false, false)
addCommandHandler("reloadnpc", reloadGeneralShop, false, false)
addCommandHandler("reloadped", reloadGeneralShop, false, false)

function renamePed(thePlayer, commandName, id, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		if not tonumber(id) or not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Shop ID] [Firstname LastName]", thePlayer, 255, 194, 14)
			return false
		end
		id = math.floor(tonumber(id))
		local pedName = table.concat({...}, "_")
		
		if pedName == "" then
			outputChatBox("KULLANIM: /" .. commandName .. " [Shop ID] [Firstname LastName]", thePlayer, 255, 194, 14)
			return false
		end
		
		local iCan, why = canIUseThisName(pedName)
		if not iCan then
			outputChatBox(why, thePlayer, 255, 0, 0)
			return false
		end
		
		if not dbExec(mysql:getConnection(),"UPDATE `shops` SET `pedName`='"..tostring(pedName):gsub("'","''").."' WHERE `id`='"..tostring(id).."' ") then
			outputChatBox("Failed to rename this NPC, please contact Maxime.",thePlayer, 255,0,0)
			return false
		end
		
		for k, thePed in ipairs(getElementsByType("ped", resourceRoot)) do
			local pedType = getElementData(thePed, "ped:type")
			if (pedType) then
				if (pedType=="shop") then
					local dbid = getElementData(thePed, "dbid")
					if (tonumber(id)==dbid) then
						destroyElement(thePed)
					end
				end
			end
		end
		
		if loadOneShop(id) then
			outputChatBox("Renamed shop ID#"..id.." to '"..tostring(pedName):gsub("_"," ").."'.",thePlayer, 0,255,0)
		else
			outputChatBox("Failed to reload this NPC, please contact Maxime.",thePlayer, 255,0,0)
		end
	end
end
addCommandHandler("renameped", renamePed, false, false)
addCommandHandler("renamenpc", renamePed, false, false)
addCommandHandler("renameshop", renamePed, false, false)

local function getDiscount( player, shoptype )
	local discount = 1
	if shoptype == 7 and tonumber( getElementData( player, "faction" ) ) == 125 then
		discount = discount * 0.5
	elseif shoptype == 14 and tonumber( getElementData( player, "faction" ) ) == 30 then
		discount = discount * 0.5
	end

	return discount
end

function clickStoreKeeper()
    local success, currentUser = canIAccessThisShop(source, client)
    if not success then
        outputChatBox(currentUser.." is currently using this NPC, please wait a moment.", client, 255,0,0)
        return false
    end
    
    local shoptype = getElementData(source, "shoptype")
    local id = getElementData(source, "dbid")
    
    local race, gender = nil, nil
    if(shoptype == 5) then -- if its a clothes shop, we also need the players race
        gender = getElementData(client,"gender")
        race = getElementData(client,"race")
    end
    
    if tonumber(shoptype) == 17 then
        local products = {}
        dbQuery(
            function(qh, client, source)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, pRow in ipairs(res) do
                        table.insert(products, { id, pRow["pItemID"], pRow["pItemValue"], pRow["pDesc"], pRow["pPrice"], pRow["pDate"], pRow["pID"] } )
                    end
                    if setShopCurrentUser(source, client) then
                        triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, 0, products)
                    else
                        outputDebugString("setShopCurrentUser failed.")
                    end
                end
            end,
        {client, source}, mysql:getConnection(), "SELECT * FROM `shop_products` WHERE `npcID`='"..id.."' ORDER BY `pDate` DESC")
    elseif tonumber(shoptype) == 18 then --Faction Drop NPC - General Items
        
    elseif tonumber(shoptype) == 19 then -- Faction Drop NPC - WEAPONS
        local products = {}
        dbQuery(
            function(qh, client, source)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, pRow in ipairs(res) do
                        table.insert(products, pRow )
                    end
                    if setShopCurrentUser(source, client) then
                        triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, 0, products)
                    else
                        outputDebugString("setShopCurrentUser failed.")
                    end
                end
            end,
        {client, source}, mysql:getConnection(), "SELECT `npcID`, `pItemID`, `pItemValue`, `pDesc`, `pPrice`, `pDate`, `pID`, `pQuantity`, `pSetQuantity`, `pRestockInterval`, `pRestockedDate`, DATEDIFF((`pRestockedDate` + interval `pRestockInterval` day),NOW()) AS `pRestockIn` FROM `shop_products` WHERE `npcID`='"..id.."' ORDER BY `pID` DESC")
    else
        if setShopCurrentUser(source, client) then
            -- perk 8 = 20% discount in shops
            triggerClientEvent(client, "showGeneralshopUI", source, shoptype, race, gender, getDiscount(client, shoptype))
        else
            outputDebugString("setShopCurrentUser failed.")
        end
    end
    
end
addEvent("shop:keeper", true)
addEventHandler("shop:keeper", getResourceRootElement(), clickStoreKeeper)


function calcSupplyCosts(thePlayer, itemID, isWeapon, supplyCost)
    return supplyCost
end

function getInteriorOwner( dimension )
	if dimension == 0 then
		return nil, nil
	end
	
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["vrp_interiors"]:findProperty(source)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

-- source = the ped clicked
-- client = the player
-- this has no code for the out-of-date lottery.
addEvent("shop:buy", true)
addEventHandler( "shop:buy", resourceRoot, function( index )
	local shoptype = getElementData( source, "shoptype")
	local error = "S-" .. tostring( shoptype ) .. "-" .. tostring( getElementData( source, "dbid") )

	local shop = g_shops[ shoptype or -1 ]
	_G['shop'] = shop
	if not shop then
		outputChatBox("Error " .. error .. "-NE, report at https:/www.Valhallaroleplay.com.", client, 255, 0, 0 )
		return
	end
	
	local race = getElementData( client, "race" )
	local gender = getElementData( client, "gender" )
	updateItems( shoptype, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
	
	-- fetch the selected item
	local item = getItemFromIndex( shoptype, index )
	if not item then
		outputChatBox("Error " .. error .. "-NEI-" .. index .. ", report at https:/www.Valhallaroleplay.com.", client, 255, 0, 0 )
		return
	end
	
	if item.minimum_age and getElementData(client, "age") < item.minimum_age then
		outputChatBox( "Bu öğeyi satın alabilmek için " .. item.minimum_age .. " yaşından büyük olmalısın.", client, 255, 0, 0 )
		return
	end
	
		--[[Check if its a generic, and if they have approval yet
	if item.name == "Other" and item.itemID == 80 and not getElementData(client, "shop:generic:pending") then
		triggerClientEvent(client, "shop:generic:buy", client, index)
		return
	end]]
	
	-- check for monies
	local price = math.ceil( getDiscount( client, shoptype ) * item.price )
	if not exports.vrp_global:hasMoney( client, price ) then
		outputChatBox( "You lack the money to buy this " .. item.name .. ".", client, 255, 0, 0 )
		return
	end
	
	-- @@ -- 
	-- do some item-specific stuff, such as assigning a serial.
	-- @@ --
	local wonTheLottery = false
	local itemID, itemValue = item.itemID, item.itemValue or 1
	if itemID == 2 then
		local attempts = 0
			-- generate a larger phone number if we're totally out of numbers and/or too lazy to perform more than 20+ checks.
			attempts = attempts + 1
			itemValue = math.random(311111, attempts < 20 and 899999 or 8999999)
		
	elseif itemID == 68 then -- Lottery Tickets
		--[[
		if not exports.vrp_integration:isPlayerScripter(client) then
			outputChatBox( "This item is temporarily disabled by scripters.", client, 255, 0, 0 )
			return
		end
		]]
		local dimension = getElementDimension( source )
		local suppliesToTake = 0
		suppliesToTake = item.supplies or math.ceil( 3.5 * exports['vrp_items']:getItemWeight( itemID, itemValue ) )
		
		if not suppliesToTake then
			outputChatBox( "Error " .. error .. "-SE-I" .. index .. "-" .. tostring( suppliesToTake ) )
			return false
		end

		local success, why = solveSupplies(source, client, suppliesToTake, dimension)
		if not success then
			outputChatBox( why, client, 255, 0, 0 )
			return false
		end

		if not exports["vrp_lottery-system"]:canThisPlayerBuyTicket(client) then
			outputChatBox( "One player now can only buy one lottery ticket every 20 minutes.", client, 255, 0, 0 )
			outputChatBox( "You've already bought another lottery ticket not long ago, please try again later.", client, 255, 0, 0 )
			return false
		end

		local lotteryJackpot = exports['vrp_lottery-system']:getLotteryJackpot()
		if tonumber(lotteryJackpot) == -1 then
			outputChatBox( "Sorry, someone already won the lottery. Please wait for the next draw.", client, 255, 0, 0 )
			return
		elseif not exports.vrp_global:hasSpaceForItem( client, itemID, itemValue ) then
			outputChatBox("Your inventory is full.", client, 255, 0, 0)
		else
			local updatedJackpot = tonumber(lotteryJackpot) + math.ceil(price * 2 / 3)
			exports['vrp_lottery-system']:updateLotteryJackpot(updatedJackpot)
		
			local lotteryTicketNumber = 0
			local lotteryTicketNumber = getElementData(client, 'test:nextPickedLotteryNumber') or math.random(2,48) -- Pick a random number for the lottery ticket number between 2 and 48
			itemValue = tonumber(lotteryTicketNumber)
			
			if tonumber(lotteryTicketNumber) == tonumber(exports['vrp_lottery-system']:getLotteryNumber()) then
				setTimer(function(player, jp) exports['vrp_global']:giveMoney(player, jp) end, 100, 1, client, updatedJackpot)
				outputChatBox( "You won! Jackpot: $" .. exports.vrp_global:formatMoney(updatedJackpot) .. ".", client, 0, 255, 0 )

				exports['vrp_lottery-system']:lotteryDraw()

				for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
					if (getElementData(value, "loggedin")==1) then
						outputChatBox("[NEWS] " .. getPlayerName(client):gsub("_"," ") .. " won the lottery jackpot of $" .. exports.vrp_global:formatMoney(updatedJackpot) .. ".", value, 200, 100, 200)
					end
				end
				exports['vrp_lottery-system']:updateLotteryJackpot(-1)
				-- Timer to re-enable lottery 10 minutes after a ticket has been drawn.
				setTimer(function ()
					exports['vrp_lottery-system']:updateLotteryJackpot(0)
				end, 600000, 1)

				wonTheLottery = true
			else
				outputChatBox( "Sorry, your number did not get picked. You lost. You got number " .. lotteryTicketNumber .. ".", client, 255, 0, 0 )
			end
			lotteryTicketNumber = 0
		end
	elseif itemID == 115 or itemID == 116 then -- now here's the trick. If item.license is set, it checks for a gun license, if item.ammo is set it gives as much ammo
		if item.license and getElementData( client, "license.gun" ) ~= 1 then
			outputChatBox( "You lack a weapon license.", client, 255, 0, 0 )
			return
		else
			local w = itemValue
			if itemID == 115 then
				local serial = "1"
				if item.license then -- licensed weapon, thus needs a serial
					local characterDatabaseID = getElementData(client, "account:character:id")
					serial = exports.vrp_global:createWeaponSerial( 3, characterDatabaseID, characterDatabaseID )
				end
				itemValue = itemValue .. ":" .. serial .. ":" .. getWeaponNameFromID( itemValue )

--				addPurchaseLogs(tonumber(getElementData(source, "dbid")), client, tostring( getWeaponNameFromID( w ) ), itemValue, price, serial, "N/A", FORUM_AMMUNATION)
			elseif itemID == 116 then
				local amount = item.ammo or exports.vrp_weaponcap:getGTACap( itemValue ) or 1
				itemValue = itemValue .. ":" .. amount .. ":" .. getWeaponNameFromID( itemValue )

				--addPurchaseLogs(tonumber(getElementData(source, "dbid")), client, "Ammo for " .. tostring( getWeaponNameFromID( w ) ), amount .. " Ammo for " .. tostring( getWeaponNameFromID( w ) ), price, nil, "N/A", FORUM_AMMUNATION)
			end
		end
	end
	
	local dimension = getElementDimension( source )
	local suppliesToTake = 0
	
	if dimension > 0 then -- is even in any interior -- calculate the supplies amount /bekiroj
		--suppliesToTake = item.supplies or math.ceil(item.price/(profitRate*2)) or math.ceil( 3.5 * exports['vrp_items']:getItemWeight( itemID, itemValue ) )
		suppliesToTake = item.supplies or math.ceil( 3.5 * exports['vrp_items']:getItemWeight( itemID, itemValue ) )
		
		if not suppliesToTake then
			outputChatBox( "Error " .. error .. "-SE-I" .. index .. "-" .. tostring( suppliesToTake ) )
			return false
		end
		
		-- get the current supply count and check for enough supplies
		local success, why = solveSupplies(source, client, suppliesToTake, dimension)
		if not success then
			outputChatBox( why, client, 255, 0, 0 )
			return false
		end
	end
	
	if wonTheLottery or exports.vrp_global:giveItem( client, itemID, itemValue ) then
		-- Money
		local playerMoney = getElementData(client, "money")
		for i = 134, 134 do
			exports['vrp_items']:takeItem(client, i)
		end
		if tonumber(playerMoney) > 0 then
			exports.vrp_global:giveItem(client, 134, tonumber(playerMoney)-tonumber(price))
		end
		exports.vrp_global:takeMoney( client, price ) -- this is assumed not to fail as we checked with :hasMoney before.
		-- and now for what happens after buying?
		--outputChatBox( "You bought this " .. item.name .. " for $" .. exports.vrp_global:formatMoney( price ) .. ".", client, 0, 255, 0 )
		exports["vrp_infobox"]:addBox(client, "buy", "Başarıyla " ..item.name.." adlı ürünü "..exports.vrp_global:formatMoney( price ) .." TL'ye satın aldınız.")
		
		-- some post-buying things, item-specific
		if itemID == 2 then
			dbExec(mysql:getConnection(),"INSERT INTO `phones` (`phonenumber`, `boughtby`) VALUES ('"..tostring(itemValue).."', '"..(tostring(getElementData(client, "account:character:id") or 0)).."')")
			outputChatBox("Your number is #" .. itemValue .. ".", client, 255, 194, 14 )
		elseif itemID == 16 and item.fitting then -- it's a skin, so set it.
			setElementModel( client, itemValue )
			dbExec(mysql:getConnection(),"UPDATE characters SET skin = " .. ( itemValue ) .. " WHERE id = " .. (getElementData( client, "dbid" )) )
		elseif itemID == 114 then -- vehicle mods
			outputChatBox("To add this item to any vehicle, go into a garage and double-click the item while sitting inside.", client, 255, 194, 14 )
		elseif itemID == 115 then -- log weapon purchases
			exports.vrp_logs:dbLog( client, 36, client, "bought WEAPON - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.vrp_global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		elseif itemID == 116 then -- log weapon purchases
			exports.vrp_logs:dbLog( client, 36, client, "bought AMMO - " .. itemValue )
			
			local govMoney = math.floor( price / 2 )
			exports.vrp_global:giveMoney(getTeamFromName("Government of Los Santos"), govMoney)
			price = price - govMoney -- you'd obviously get less if the gov asks for percentage.
		end
		
		-- What's left undone? Giving shop owner money!
		
		if price > 0 and dimension > 0 then
			local currentIncome = tonumber(getElementData(source, "sIncome")) or 0
			setElementData(source, "sIncome", currentIncome + price, true)
			playBuySound(source)
			local playerGender = getElementData(client,"gender")
			local pedName = tostring(getElementData(source, "name"))
			if string.sub(pedName, 1, 8) == "userdata" then
				pedName = "The Storekeeper"
			end
			pedName = string.gsub(pedName,"_", " ")
			local playerName = getPlayerName(client):gsub("_", " ")
			if playerGender == 0 then
				triggerEvent('sendAme', client, "cüzdanından birkaç banknot alıyor, teslim ediyor "..pedName)
			else					
				triggerEvent('sendAme', client, "cüzdanından birkaç banknot alıyor, teslim ediyor "..pedName)
			end
			local r = getRealTime()
			local timeString = ("%02d/%02d/%04d %02d:%02d"):format(r.monthday, r.month + 1, r.year+1900, r.hour, r.minute)
			local ownerNoti = "A customer bought a "..item.name.." for $"..exports.vrp_global:formatMoney(price).."."
			local logString = "- "..timeString.." : A customer bought a "..item.name.." for $"..exports.vrp_global:formatMoney(price)..".\n"
			
			exports.vrp_global:sendLocalText(client, "* "..pedName.." gave "..playerName.." a "..item.name..".", 255, 51, 102, 30, {}, true)
			storeKeeperSay(client, "Here you are. And..", pedName)
			if playerGender == 0 then
				storeKeeperSay(client, "Thank you sir, Have a nice day!", pedName)
			else
				storeKeeperSay(client, "Thank you ma'ma, Have a nice day!", pedName)
			end
			
			--notifyAllShopOwners(source, ownerNoti.." Come and collect the money when you got time ;)")
			
			local previousSales = getElementData(source, "sSales") or ""
			logString = string.sub(logString..previousSales,1,5000)
			setElementData(source, "sSales", logString, true)
			dbExec(mysql:getConnection(),"UPDATE `shops` SET `sIncome` = `sIncome` + '" .. tostring(price) .. "', `sSales` = '"..logString:gsub("'","''").."' WHERE `id` = '"..tostring(getElementData(source,"dbid")).."'")
		end
	else
		outputChatBox( "You do not have enough space to carry this " .. item.name .. ".", client, 255, 0, 0 )
	end
end )

function solveSupplies(source, client, suppliesToTake, dimension)
	for key, interior in pairs(getElementsByType("interior")) do
		if getElementData(interior, "dbid") == dimension then
			local status = getElementData(interior, "status")
			local currentSupplies = status[6] or 0
			local ownerID = status[4]
			local interiorType = tonumber(status[1] or 2)
			if ownerID == getElementData(client, "dbid") then
				--suppliesToTake = suppliesToTake*profitRate
				--ownerPlayer = ownerID
				--outputChatBox( "Buying items from your own shop will not make you profit.", client, 255, 0, 0 )
			end
			local remainingSupplies = currentSupplies - suppliesToTake
			--outputDebugString(currentSupplies.."-"..suppliesToTake)
			--if remainingSupplies < 0 and (interiorType ~= 2) then 
			--	return false, "This item is out of stock."
			--else
				status[6] = remainingSupplies
				setElementData(interior, "status", status, true)
				if remainingSupplies < 50 and ownerID == getElementData(client, "dbid") then
					outputChatBox( "Supplies in your business #" .. dimension .. " are low. Fill 'em up. ((use /ordersupplies))", client, 255, 194, 14 )
				end
				
				-- take the outstanding supplies
				dbExec(mysql:getConnection(),"UPDATE `interiors` SET `supplies` = '"..remainingSupplies.."' WHERE id = " .. (dimension))
				
				return true, "Cool."
			--end
			--return false, "Error code 'ESDAFE1241', please report to Maxime"
		end
	end
end

globalSupplies = 0

function updateGlobalSupplies(value)
	globalSupplies = globalSupplies + value
	dbExec(mysql:getConnection(),"UPDATE settings SET value='" .. (tostring(globalSupplies)) .. "' WHERE name='globalsupplies'")
end
addEvent("updateGlobalSupplies", true)
addEventHandler("updateGlobalSupplies", getRootElement(), updateGlobalSupplies)

function handleSupplies(element, slot, event, worldItem)
    return false
end
addEventHandler("shop:handleSupplies", getRootElement(), handleSupplies)

function canIUseThisName(pedName)
    return true, "This name is cool"
end

function shopRemoteOrderSupplies(thePlayer, dim, weight)

	return success
end
addEvent("shop:shopRemoteOrderSupplies", true)
addEventHandler("shop:shopRemoteOrderSupplies", getRootElement(), shopRemoteOrderSupplies)

function resStart()
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                     globalSupplies = tonumber(row["value"]) or 0
                end
            end
        end,
    mysql:getConnection(), "SELECT value FROM settings WHERE name='globalsupplies' LIMIT 1")
end
addEventHandler("onResourceStart", getResourceRootElement(), resStart)