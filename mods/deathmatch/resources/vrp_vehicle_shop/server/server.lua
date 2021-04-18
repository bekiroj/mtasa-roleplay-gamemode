local spawnedShopVehicles = {}
local global = exports.vrp_global
local mysql = exports.vrp_mysql
local currentYear = getRealTime().year+1900
local self = {}
local vehicles_random = {}

thread:setPriority("low")
addEventHandler("onResourceStart", resourceRoot,
	function()

		self.createCarshops()
		setTimer(function() restartResource(getThisResource()) end, 1000*60*30, 0)
	end
);

function SmallestID()
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

local randomVehiclesTable = {}
local spawnedShopVehicles = {}
local blocking = {}

function self.startWizard()
	for i, veh in pairs(spawnedShopVehicles) do
		if veh[1] and isElement(veh[1]) and getElementType(veh[1]) == "vehicle" then
			destroyElement(veh[1])
			destroyElement(veh[2])
		end
	end


	thread:foreach(shops, function(v)
		dealerID = v.id
		
		local vehicleData = self.randomVehicle(dealerID)
		if vehicleData then
			local letter1 = string.char(math.random(65,90))
			local letter2 = string.char(math.random(65,90))
			local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
			local model = tonumber(vehicleData.vehmtamodel)
			
			local vehicle = createVehicle( model , v[1], v[2], v[3], v[4], v[5], v[6], plate  )
			local vehBrand = vehicleData["vehbrand"]
			local vehModel = vehicleData["vehmodel"]
			local vehPrice = tonumber(vehicleData["vehprice"])
			local vehTax = tonumber(vehicleData["vehtax"])
			local vehYear = tonumber(vehicleData["vehyear"])
			local odometer = 0
			

			if not (vehicle ) then
				outputDebugString("failed to spawn a "..data[1])
			else
				setElementInterior(vehicle, v[4])
				setElementDimension(vehicle, v[5])
				setVehicleLocked( vehicle, true )
				setTimer(setElementFrozen, 180, 1, vehicle, true )
				setVehicleDamageProof( vehicle, true )
				setVehicleVariant(vehicle, exports['vrp_vehicle']:getRandomVariant(getElementModel(vehicle)))
				v["vehicle"] = vehicle

				local x = v[1] - ( ( math.cos ( math.rad (  v[6] ) ) ) * 1.5 )
				local y = v[2] - ( ( math.sin ( math.rad (  v[6] ) ) ) * 1.5 )
	
				table.insert(spawnedShopVehicles, {vehicle, tempPickup})

				
				setElementData(v["vehicle"], "brand", vehBrand, true)
				setElementData(v["vehicle"], "model", vehModel, true)
				setElementData(v["vehicle"], "year", vehYear, true)
				setElementData(v["vehicle"], "odometer", odometer , true)
				setElementData(v["vehicle"], "carshop:cost", vehPrice , true)
				setElementData(v["vehicle"], "carshop", dealerID, true)
				setElementData(v["vehicle"], "dbid", -1, true)
				setElementData(v["vehicle"], "vehicle_shop_id", tonumber(vehicleData["id"]))
			
				for i = 1, 5, 1 do
					setElementData(v["vehicle"], "description:" .. i, "", true)
				end
				
			end
		end
	end)
end

function carshop_blockEnterVehicle(thePlayer)
	local isCarShop = getElementData(source, "carshop")
	if (isCarShop) then
		local costCar = getElementData(source, "carshop:cost")
		
		local payByCash = true
		local payByBank = true
		
		if not exports.vrp_global:hasMoney(thePlayer, costCar) or costCar == 0 then
			payByCash = false
		end
		
		local money = getElementData(thePlayer, "bankmoney") - costCar
		if money < 0 or costCar == 0 then
			payByBank = false
		end
		
		triggerClientEvent(thePlayer, "carshop:buyCar", source, costCar, payByCash, payByBank)
	end
	cancelEvent()
end
--addEventHandler( "onVehicleEnter", getResourceRootElement(), carshop_blockEnterVehicle)
--addEventHandler( "onVehicleStartEnter", getResourceRootElement(), carshop_blockEnterVehicle)

function carshop_buyVehicle(paymentMethod)
	if not client then
		return false
	end
	
	local isCarshopVehicle = getElementData(source, "carshop")
	if not isCarshopVehicle then
		return false
	end
	
	local isOverlayDisabled = getElementData(client, "hud:isOverlayDisabled")
	
	if not exports.vrp_global:canPlayerBuyVehicle(client) then
		if isOverlayDisabled then 
			outputChatBox("Azami araç sayısına zaten ulaştınız.", client, 0, 255, 0)
		else
			exports.vrp_hud:sendBottomNotification(client, "Maksimum araç limiti", "Azami araç sayısına zaten ulaştınız. Ayrıntılar için /stats")
		end
		return false
	end
	
	
	
	local costCar = getElementData(source, "carshop:cost")
	if (paymentMethod == "cash") then
		if not exports.vrp_global:hasMoney(client, costCar) or costCar == 0 then
			if isOverlayDisabled then
				outputChatBox("Bu arkadaş için elinizde yeterli para yok..", client, 0, 255, 0)
			else
				exports.vrp_hud:sendBottomNotification(client, "Para her zaman bir problemdir..", "Bu arkadaş için elinizde yeterli para yok..")
			end
			return false
		else
			exports.vrp_global:takeMoney(client, costCar)
		end
	elseif (paymentMethod == "bank") then
		local money = getElementData(client, "bankmoney") - costCar
		if money < 0 or costCar == 0 then
			if isOverlayDisabled then 
				outputChatBox("Banka hesabınızda bu arkadaş için yeterli para yok..", client, 0, 255, 0)
			else
				exports.vrp_hud:sendBottomNotification(client, "Para her zaman bir problemdir..", "Banka hesabınızda bu arkadaş için yeterli para yok...")
			end
		else
			setElementData(client, "bankmoney", money, false)
			dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney=" .. ((tonumber(money) or 0)) .. " WHERE id=" .. (getElementData( client, "dbid" )))
		end
	elseif (paymentMethod == "token") then
		if exports.vrp_global:hasItem(client, 263, 1) then
			exports.vrp_global:takeItem(client, 263, 1)
		else
			return false
		end
	else
		return false
	end
	
	local dbid = getElementData(client, "account:character:id")
	local modelID = getElementModel(source)
	local x, y, z = getElementPosition(source)
	local rx, ry, rz = getElementRotation(source)
	local odometer = 0
	local col = { getVehicleColor(source) }
	local color1 = toJSON( {col[1], col[2], col[3]} )
	local color2 = toJSON( {col[4], col[5], col[6]} )
	local color3 = toJSON( {col[7], col[8], col[9]} )
	local color4 = toJSON( {col[10], col[11], col[12]} )
	local letter1 = string.char(math.random(65,90))
	local letter2 = string.char(math.random(65,90))
	local var1, var2 = getVehicleVariant(source)
	local plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
	local locked = 1
	local vehShopID = getElementData(source, "vehicle_shop_id") or 0
	local smallestID = SmallestID()	
	local insert = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET id='"..(smallestID).."', model='" .. (modelID) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='" .. (rx) .. "', roty='" .. (ry) .. "', rotz='" .. (rz) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='-1', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (rz) .. "', locked='" .. (locked) .. "',variant1="..var1..",variant2="..var2..",description1='', description2='', description3='',description4='',description5='', creationDate=NOW(), createdBy='-1', vehicle_shop_id='"..(vehShopID).."',odometer='".. (odometer).."'")
	
	call( getResourceFromName( "vrp_items" ), "deleteAll", 3, smallestID )
	exports.vrp_global:giveItem( client, 3, smallestID )		

	destroyElement(source)					
	exports['vrp_vehicle']:reloadVehicle(smallestID)

	outputChatBox("Aracı başarıyla satın aldınız, belirli bir alana /park yapmayı unutmayın.", client, 255, 255, 255, true)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyVehicle)

local vehicleColors
function getRandomVehicleColor( vehicle )
	if not vehicleColors then
		vehicleColors = { }
		local file = fileOpen( "vehiclecolors.conf", true )
		while not fileIsEOF( file ) do
			local line = fileReadLine( file )
			if #line > 0 and line:sub( 1, 1 ) ~= "#" then
				local model = tonumber( gettok( line, 1, string.byte(' ') ) )
				if not vehicleColors[ model ] then
					vehicleColors[ model ] = { }
				end
				vehicleColors[ model ][ #vehicleColors[ model ] + 1 ] = {
					tonumber( gettok( line, 2, string.byte(' ') ) ),
					tonumber( gettok( line, 3, string.byte(' ') ) ) or nil,
				}
			end
		end
		fileClose( file )
	end
	
	local colors = vehicleColors[ getElementModel( vehicle ) ]
	if colors then
		return unpack( colors[ math.random( 1, #colors ) ] )
	end
end

function fileReadLine( file )
	local buffer = ""
	local tmp
	repeat
		tmp = fileRead( file, 1 ) or nil
		if tmp and tmp ~= "\r" and tmp ~= "\n" then
			buffer = buffer .. tmp
		end
	until not tmp or tmp == "\n" or tmp == ""
	
	return buffer
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if text then
		if string.len(text) > 128 then
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end

function self.createCarshops()
	randomVehiclesTable = shops
	thread:query("SELECT * FROM `vehicles_shop` WHERE `enabled` = '1'",
		function(res, rows, err)
			for index, value in ipairs(res) do
				if not vehicles_random[value.spawnto] then
					vehicles_random[value.spawnto] = {}
				end
				table.insert(vehicles_random[value.spawnto], value )
			end
			self.startWizard()
		end
	)
end

function self.randomVehicle(shopID)
	if shopID and tonumber(shopID) then
		if #vehicles_random[shopID] > 0 then
			local ran = math.random( 1, #vehicles_random[shopID] )
			return vehicles_random[shopID][ran]
		else
			return false
		end
	end
end