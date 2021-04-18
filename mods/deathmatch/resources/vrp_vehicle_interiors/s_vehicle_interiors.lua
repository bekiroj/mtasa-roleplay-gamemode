-- // Militan tarafından baştan kodlandı.
local vehicles = { }
local vehicleInteriorGates = { }

local customVehInteriors = {
	--model,x,y,z,rx,ry,rz,interior
	--1: Andromada
	[1] = {
		{14548,-445.39999,87.3,1226.80005,13,0,0,1},
		{3069,-445.39999,111.2,1224.69995,0,0,0,1}
	},
	--2: Shamal
	[2] = {
		{2924,2.4000000953674,34.400001525879,1202.0999755859,0,0,0,1}
	},
	--3: AT-400
	[3] = {
		{14548,-388.89999, 86.6, 1226.80005,13,0,0,1},
		{7191,-391.10001, 110.2, 1226.69995,0,0,270,1},
		{7191,-391.10001, 110.2, 1230.19995,0,0,270,1},
		{7191,-411.79999,62.6,1226.69995,0,0,270,1},
		{7191,-365.89999,62.6,1226.69995,0,0,90,1},
		{7191,-373.89999,62.6,1229.40002,0,0,90,1},
	},
	
	--4: Ambulance
	[4] = {
		{ 1698, 2002.0, 2285.0, 1010.0,0,0,0,30 },
		{ 1698, 2003.36, 2285.0, 1010.0,0,0,0,30 },
		{ 1698, 2004.72, 2285.0, 1010.0,0,0,0,30 },
		{ 1698, 2002.0, 2288.3, 1010.0,0,0,0,30 },
		{ 1698, 2003.36, 2288.3, 1010.0,0,0,0,30 },
		{ 1698, 2004.72, 2288.3, 1010.0,0,0,0,30 },
		{ 3386, 2001.58, 2285.75, 1010.1, 0.0, 0.0, 180.0, 30 },
		{ 3388, 2001.58, 2284.8, 1010.1, 0.0, 0.0, 180.0, 30 },
		{ 2146, 2003.3, 2286.4, 1010.6,0,0,0,30 },
		{ 16000, 2001.3, 2281.0, 1007.5, 0.0, 0.0, 270.0, 30 },
		{ 16000, 2005.4, 2281.0, 1007.5, 0.0, 0.0, 90.0, 30},
		{ 18049, 2006.0, 2279.5, 1013.05, 0.0, 0.0, 90.0, 30 },
		{ 2639, 2005.0, 2285.55, 1010.7, 0.0, 0.0, 90.0, 30 },
		{ 3791, 2005.3, 2288.25, 1012.4, 270.0, 0.0, 90.0, 30 },
		{ 2174, 2001.7, 2286.74, 1010.1, 0.0, 0.0, 90.0, 30 },
		{ 2690, 2001.41, 2287.0, 1011.25, 0.0, 0.0, 90.0, 30 },
		{ 2163, 2001.3, 2286.84, 1011.9, 0.0, 0.0, 90.0, 30 },
		{ 1789, 2005.1, 2284.1, 1010.7, 0.0, 0.0, 270.0, 30 },
		{ 1369, 2001.85, 2283.85, 1010.7, 0.0, 0.0, 90.0, 30 },
		{ 3384, 2001.9, 2288.85, 1011.1, 0.0, 0.0, 180.0, 30 },
		{ 3395, 2005.3, 2288.32, 1010.05,0,0,0,30 },
		{ 11469, 2008.6, 2294.5, 1010.1, 0.0, 0.0, 90.0, 30 },
		{ 2154, 2001.55, 2289.75, 1010.0, 0.0, 0.0, 90.0, 30 },
		{ 2741, 2001.4, 2289.65, 1012.0, 0.0, 0.0, 90.0, 30 },
		{ 2685, 2001.35, 2289.65, 1011.5, 0.0, 0.0, 90.0, 30 },
		{ 18056, 2005.4, 2290.4, 1011.9, 0.0, 0.0, 180.0, 30 },
		{ 2688, 2001.4, 2283.85, 1012.0, 0.0, 0.0, 90.0, 30 },
		{ 2687, 2005.35, 2286.0, 1012.0, 0.0, 0.0, 270.0, 30 },
		{ 16000, 2006.5, 2290.0, 1020.0, 0.0, 180.0, 180.0, 30 },
		{ 16000, 1991.0, 2283.4, 1016.0, 0.0, 90.0, 0.0, 30 },
		{ 16000, 2015.7, 2283.4, 1016.0, 0.0, 270.0, 0.0, 30 },
		{ 1719, 2005.0, 2284.1, 1010.6, 0.0, 0.0, 270.0, 30 },
		{ 1718, 2005.1, 2284.1, 1010.73, 0.0, 0.0, 270.0, 30 },
		{ 1785, 2005.1, 2284.1, 1010.95, 0.0, 0.0, 270.0, 30 },
		{ 1783, 2005.05, 2284.1, 1010.4, 0.0, 0.0, 270.0, 30 },
	},
	--5: Swat Van (Enforcer)
	[5] = {
		{ 3055, 1385.01465, 1468.0957, 9.85458, 90, 179.995, 90, 31 },
		{ 3055, 1382.08594, 1468.05762, 10.29892, 0, 0, 90, 31 },
		{ 3055, 1384.2841, 1479.1, 10.29892, 0, 0, 0, 31 },
		{ 3055, 1387, 1468.06836, 10.29892, 0, 0, 270, 31 },
		{ 14851, 1375.6611, 1460.15, 8.13512, 0, 0, 270.005, 31 },
		{ 11631, 1386.30005, 1467.69922, 11.1, 0, 0, 270.011, 31 },
		{ 1958, 1382.60742, 1468.5813, 10.61344, 0, 0, 268.727, 31 },
		{ 2606, 1382.19995, 1468.80005, 11.9, 0, 0, 90, 31 },
		{ 2372, 1381.69678, 1465.41614, 10.69246, 89.616, 246.464, 203.536, 31 },
		{ 2008, 1382.7217, 1468.5098, 9.84762, 0, 0, 90, 31 },
		{ 3055, 1389.25, 1466.50684, 10.29892, 0, 0, 0, 31 },
		{ 3055, 1379.95996, 1466.51758, 10.29892, 0, 0, 0, 31 },
		{ 2606, 1382.19995, 1468.80005, 11.4, 0, 0, 90, 31 },
		{ 2227, 1381.81018, 1468.55676, 10.05617, 0, 0, 90, 31 },
		{ 2007, 1382.6, 1467.49, 9.37511, 0, 0, 90.126, 31 },
		{ 3055, 1382.57715, 1468.05005, 13.12, 90, 179.995, 270, 31 },
		{ 3055, 1387.60449, 1468.04883, 13.10289, 90, 179.995, 269.995, 31 },
		{ 3793, 1382.41406, 1465.85791, 11.38892, 0.033, 270.033, 229.963, 31 },
		{ 3793, 1382.41943, 1464.76172, 11.38892, 0.027, 270.033, 229.96, 31 },
		{ 2372, 1381.71094, 1466.51123, 10.69246, 89.615, 246.462, 203.533, 31 },
		{ 3055, 1389.56055, 1464.15857, 10.29892, 0, 0, 0, 31 },
		{ 3055, 1379.94934, 1464.15662, 10.29892, 0, 0, 0, 31 },
		{ 3055, 1383.59509, 1464.13318, 12.09403, 0, 0, 0, 31 },
		{ 3055, 1383.54785, 1466.52832, 14.6, 0, 0, 0, 31 },
		{ 7707, 1383.73743, 1464.10437, 10.9326, 0, 0, 90, 31 },
		{ 2372, 1383.83582, 1463.23877, 10.58514, 89.615, 246.462, 291.867, 31 },
		{ 14792, 1376.2998, 1485.55, 11.3, 0, 0, 90, 31 },
		{ 1808, 1382.5, 1470.30005, 9.8, 0, 0, 90, 31 },
		{ 2133, 1382.80005, 1471.09998, 9.9, 0, 0, 90, 31 },
		{ 2149, 1382.59998, 1471.19995, 11.1, 0, 0, 90, 31 },
		{ 3055, 1382.08594, 1475.89001, 10.29892, 0, 0, 90, 31 },
		{ 3055, 1386.8994, 1475.7998, 10.29892, 0, 0, 90, 31 },
		{ 3055, 1382.57715, 1475.88, 13.10289, 90, 179.995, 270, 31 },
		{ 3055, 1387.60449, 1475.88, 13.10289, 90, 179.995, 269.995, 31 },
		{ 1703, 1382.80005, 1472, 9.8, 0, 0, 90, 31 },
		{ 1719, 1386.59998, 1478.09998, 11.9, 0, 0, 90, 31 },
		{ 3055, 1385.01465, 1475, 9.85458, 90, 179.995, 90, 31 },
		{ 2133, 1386.2998, 1475.2, 9.9, 0, 0, 270, 31 },
		{ 2133, 1386.2998, 1474.2, 9.9, 0, 0, 270, 31 },
		{ 2133, 1386.2998, 1473.2, 9.9, 0, 0, 270, 31 },
		{ 2133, 1386.2998, 1472.2, 9.9, 0, 0, 270, 31 },
		{ 2133, 1386.2998, 1471.2, 9.9, 0, 0, 270, 31 },
		{ 2133, 1386.2998, 1470.2, 9.9, 0, 0, 270, 31 },
		{ 2737, 1382.2305, 1476, 12, 0, 0, 90, 31 },
		{ 2267, 1386.85, 1473, 11.9, 0, 0, 270, 31 },
		{ 1714, 1385.4, 1467.3, 9.9, 0, 0, 90, 31 },
		{ 1714, 1383.6, 1469.4, 9.9, 0, 0, 270, 31 },
		{ 2167, 1382.2, 1474.9, 9.85, 0, 0, 90, 31 },
		{ 2167, 1382.2, 1475.8, 9.85, 0, 0, 90, 31 },
		{ 2167, 1382.2, 1476.7, 9.85, 0, 0, 90, 31 },
		{ 2167, 1382.2, 1477.6, 9.85, 0, 0, 90, 31 },
		{ 2167, 1382.2, 1478.5, 9.85, 0, 0, 90, 31 },
		{ 2257, 1382.2, 1473.4, 12.4, 0, 0, 90, 31 },
		{ 2258, 1386.88, 1468, 12, 0, 0, 270, 31 },
	},

}

-- check all existing vehicles for interiors
addEventHandler("onResourceStart", resourceRoot,
	function()
		for key, value in ipairs( getElementsByType( "vehicle" ) ) do
			add(value)
		end
	end
)

-- cleanup code
addEventHandler("onElementDestroy", root,
	function()
		if vehicles[ source ] then
			destroyElement( vehicles[ source ] )
			vehicles[ source ] = nil
		end
	end
)

addEventHandler( "onResourceStop", resourceRoot,
	function()
		for key, value in ipairs( getElementsByType( "vehicle" ) ) do
			if getElementData( value, "entrance" ) then
				setElementData( value, "entrance", false )
			end
		end
	end
)

-- code to create the pickup and set properties
local function addInterior( vehicle, targetx, targety, targetz, targetinterior )
	local intpickup = createPickup( targetx, targety, targetz, 3, 1318 )
	setElementDimension( intpickup, getElementData( vehicle, "dbid" ) + 20000 )
	setElementInterior( intpickup, targetinterior )
	
	vehicles[ vehicle ] = intpickup
	setElementData( vehicle, "entrance", true )
end

-- exported, called when a vehicle is created
function add( vehicle )
	if getElementModel( vehicle ) == 519 then -- Shamal
		local dbid = tonumber(getElementData(vehicle, "dbid"))
		local dim = dbid+20000

		--create custom objects
		for k,v in ipairs(customVehInteriors[2]) do
			local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementInterior(object, v[8])
			setElementDimension(object, dim)
		end

		--add cockpit door		
		local gate = exports["vrp_gate_manager"]:createGate(2924,1,34.5,1199.8000488281,0,0,180,-0.30000001192093,34.5,1199.8000488281,0,0,180,1,dim,0,30,9,tostring(dbid),2)
		table.insert(vehicleInteriorGates, gate)

		addInterior( vehicle,  2.609375, 33.212890625, 1199.6, 1 )
		--addInterior( vehicle, 3.8, 23.1, 1199.6, 1 )
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 2)
		attachElements(marker, vehicle, -2, 3.5, -2)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)
		
		local shape = createColSphere(1.7294921875, 35.7333984375, 1200.3044433594, 1.5)
		setElementInterior(shape, 1)
		setElementDimension(shape, dim)
		addEventHandler("onColShapeHit", shape, hitCockpitShape)
		addEventHandler("onColShapeLeave", shape, leaveCockpitShape)
		
		return true, 1 -- interior id
	elseif getElementModel( vehicle ) == 577 then -- AT-400
		local dbid = tonumber(getElementData(vehicle, "dbid"))
		local dim = dbid+20000

		--create custom objects
		local addY = 0
		for i = 1,14 do
			table.insert(customVehInteriors[3], {1562, -384.60001, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -385.39999, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -386.20001, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -393.29999, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -392.5, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -391.70001, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -389.79999, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -389, 65.1+addY, 1225.5, 0, 0, 0,1})
			table.insert(customVehInteriors[3], {1562, -388.20001, 65.1+addY, 1225.5, 0, 0, 0,1})			
			addY = addY + 2.8
		end
			
		for k,v in ipairs(customVehInteriors[3]) do
			local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementInterior(object, v[8])
			setElementDimension(object, dim)
			if(v[1] == 1562) then --add pillows to jet seats
				local object2 = createObject(1563,v[2],v[3],v[4],v[5],v[6],v[7])
				setElementInterior(object2, v[8])
				setElementDimension(object2, dim)
				attachElements(object2, object, 0, 0.35, 0.54)
			end
		end
	
		addInterior( vehicle, -391.79999, 58, 1225.80005, 1 )
		
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 2)
		attachElements(marker, vehicle, -4.5, 19, 2.7)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)
		
		local shape = createColSphere(-388.79999, 53.9, 1225.80005, 1.5)
		setElementInterior(shape, 1)
		setElementDimension(shape, dim)
		addEventHandler("onColShapeHit", shape, hitCockpitShape)
		addEventHandler("onColShapeLeave", shape, leaveCockpitShape)
		
		return true, 1
	elseif getElementModel(vehicle) == 592 then --Andromada
		--create the andromada interior
		local dim = tonumber(getElementData(vehicle, "dbid")) + 20000
		for k,v in ipairs(customVehInteriors[1]) do
			local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementInterior(object, v[8])
			setElementDimension(object, dim)
		end
		addInterior(vehicle,  -445.29999, 113.1, 1226.19995, 1)
		
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 5)
		attachElements(marker, vehicle, 0, -23, -2.2)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)

		return true, 1

	elseif getElementModel( vehicle ) == 508 then --Journey
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 1)
		attachElements(marker, vehicle, 2, 0, 0)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)		
		addInterior( vehicle, 1.9, -3.2, 999.4, 2 )
		return true, 2
	elseif getElementModel( vehicle ) == 484 then
		addInterior( vehicle, 1.9, -3.2, 999.4, 2 )
		return true, 2
	elseif getElementModel( vehicle ) == 416 then -- Ambulance
		local dim = tonumber(getElementData(vehicle, "dbid")) + 20000
		for k,v in ipairs(customVehInteriors[4]) do
			local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementInterior(object, v[8])
			setElementDimension(object, dim)
		end
		addInterior( vehicle, 2003.3, 2284.2, 1011.1, 30 )
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 1)
		attachElements(marker, vehicle, 0, -4, 0)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)	
		return true, 30
	elseif getElementModel( vehicle ) == 427 then -- Enforcer
		local dim = tonumber(getElementData(vehicle, "dbid")) + 20000
		for k,v in ipairs(customVehInteriors[5]) do
			local object = createObject(v[1],v[2],v[3],v[4],v[5],v[6],v[7])
			setElementInterior(object, v[8])
			setElementDimension(object, dim)
		end
		addInterior( vehicle, 1384.8, 1464.7, 11, 31 )
		local x,y,z = getElementPosition(vehicle)
		local marker = createColSphere(x, y, z, 1)
		attachElements(marker, vehicle, 0, -4, 0)
		addEventHandler("onColShapeHit", marker, hitVehicleEntrance)
		addEventHandler("onColShapeLeave", marker, leaveVehicleEntrance)
		return true, 31
	else
		return false
	end
end

function hitCockpitShape(hitElement, matchingDimension)
	--outputDebugString("hitCockpitShape()")
	if matchingDimension and getElementType(hitElement) == "player" then
		bindKey(hitElement, "enter_exit", "down", enterCockpitByKey)
		bindKey(hitElement, "enter_passenger", "down", enterCockpitByKey)
	end
end
function leaveCockpitShape(hitElement, matchingDimension)
	--outputDebugString("leaveCockpitShape()")
	if matchingDimension and getElementType(hitElement) == "player" then
		unbindKey(hitElement, "enter_exit", "down", enterCockpitByKey)
		unbindKey(hitElement, "enter_passenger", "down", enterCockpitByKey)
	end
end
function enterCockpitByKey(thePlayer, key, keyState)
	unbindKey(thePlayer, "enter_exit", "down", enterCockpitByKey)
	unbindKey(thePlayer, "enter_passenger", "down", enterCockpitByKey)
	fadeCamera(thePlayer, false)
	local dbid = getElementDimension(thePlayer) - 20000
	local vehicle
	for value in pairs( vehicles ) do
		if getElementData( value, "dbid" ) == dbid then
			vehicle = value
			break
		end
	end
	if vehicle then
		local allowed = false
		local model = getElementModel(vehicle)
		if(model == 577 or model == 519) then --AT-400 & Shamal
			if(getElementData(thePlayer, "duty_admin") == 1 or exports.vrp_global:hasItem(thePlayer, 3, tonumber(dbid)) or (getElementData(thePlayer, "faction") > 0 and getElementData(thePlayer, "faction") == getElementData(vehicle, "faction"))) then
				allowed = true
			end
		end
		if allowed then
			local seat
			if(key == "enter_exit") then
				seat = 0
			elseif(key == "enter_passenger") then
				seat = 1
			end
			if seat then
				local result = warpPedIntoVehicle(thePlayer, vehicle, seat)
				if result then
					setElementInterior(thePlayer, getElementInterior(vehicle))
					setElementDimension(thePlayer, getElementDimension(vehicle))
					triggerEvent("texture-system:loadCustomTextures", thePlayer)
					fadeCamera(thePlayer, true)
				end
			else
				--outputDebugString("no seat")
			end
		end
	end
end

function hitVehicleEntrance(hitElement, matchingDimension)
	--outputDebugString("hitVehicleEntrance()")
	if matchingDimension and getElementType(hitElement) == "player" then
		--outputDebugString("matching")
		local vehicle = getElementAttachedTo(source)
		if vehicles[ vehicle ] then
			--outputDebugString("found veh")
			if not isVehicleLocked( vehicle ) then
				
				triggerClientEvent(hitElement, "vehicle_interiors:showInteriorGUI", vehicle)
			end
		end
	end
end
function leaveVehicleEntrance(hitElement, matchingDimension)
	--outputDebugString("leaveVehicleEntrance()")
	if matchingDimension and getElementType(hitElement) == "player" then
		triggerClientEvent(hitElement, "vehicle_interiors:hideInteriorGUI", hitElement)
	end
end

-- enter over right click menu
function teleportTo( player, x, y, z, dimension, interior, freeze )
	fadeCamera( player, false, 1 )
	
	setTimer(
		function( player )
			setElementDimension( player, dimension )
			setElementInterior( player, interior )
			setCameraInterior( player, interior )
			setElementPosition( player, x, y, z )
			
			triggerEvent( "onPlayerInteriorChange", player )
			
			setTimer( fadeCamera, 1000, 1, player, true, 2 )
			
			if freeze then 
				triggerClientEvent( player, "usedElevator", player ) -- DISABLED because the event was buggged for an unknown reason on client side / MAXIME
				setElementFrozen( player, true )
				setPedGravity( player, 0 )
			end
		end, 1000, 1, player
	)
end

addEvent( "enterVehicleInterior", true )
addEventHandler( "enterVehicleInterior", root,
	function( vehicle )
		--outputDebugString("enterVehicleInterior")
		if vehicles[ vehicle ] then
			if isVehicleLocked( vehicle ) then
				outputChatBox( "You try the door handle, but it seems to be locked.", source, 255, 0, 0 )
			else
				local model = getElementModel(vehicle)
				if(model == 577 or model == 592) then --texture change
					triggerClientEvent(source, "vehicle_interiors:changeTextures", vehicle, model)
				end
				
				if(model == 592) then --Andromada (for vehicles)
					if(isPedInVehicle(source)) then
						if(getPedOccupiedVehicleSeat(source) == 0) then
							local pedVehicle = getPedOccupiedVehicle(source)
							setElementData(pedVehicle, "health", getElementHealth(pedVehicle), false)
							for i = 0, getVehicleMaxPassengers( pedVehicle ) do
								local p = getVehicleOccupant( pedVehicle, i )
								if p then
									triggerClientEvent( p, "CantFallOffBike", p )
								end
							end
							local exit = vehicles[ vehicle ]
							local x, y, z = getElementPosition(exit)
							setTimer(warpVehicleIntoInteriorfunction, 500, 1, pedVehicle, getElementInterior(exit), getElementDimension(exit), x, y, z)	
						end
						return
					end
				end

				local exit = vehicles[ vehicle ]
				local x, y, z = getElementPosition(exit)
				local targetInt, targetDim = getElementInterior(exit), getElementDimension(exit)
				local teleportArr = { x, y, z, targetInt, targetDim, 0, 0 }
				setElementInterior(source, targetInt)
				setElementDimension(source, targetDim)
				triggerClientEvent(source, "setPlayerInsideInterior2", vehicle, teleportArr, false)
			end
		end
	end
)

function warpVehicleIntoInteriorfunction(vehicle, interior, dimension, x, y, z, rz)
	if isElement(vehicle) then
		local offset = getElementData(vehicle, "groundoffset") or 2
		
		setElementPosition(vehicle, x, y, z  - 1 + offset)
		setElementInterior(vehicle, interior)
		setElementDimension(vehicle, dimension)
		setElementVelocity(vehicle, 0, 0, 0)
		setElementAngularVelocity(vehicle, 0, 0, 0)
		setVehicleRotation(vehicle, 0, 0, 0)
		--setElementRotation(vehicle, rz or 0, 0, 0, "ZYX")
		setTimer(setElementAngularVelocity, 50, 2, vehicle, 0, 0, 0)			
		setElementHealth(vehicle, getElementData(vehicle, "health") or 1000)
		setElementData(vehicle, "health")
		setElementFrozen(vehicle, true)
					
		setTimer(setElementFrozen, 1000, 1, vehicle, false)
			
		for i = 0, getVehicleMaxPassengers( vehicle ) do
			local player = getVehicleOccupant( vehicle, i )
			if player then
				setElementInterior(player, interior)
				setCameraInterior(player, interior)
				setElementDimension(player, dimension)
				setCameraTarget(player)
				
				triggerEvent("onPlayerInteriorChange", player)
				setElementData(player, "realinvehicle", 1, false)
			end
		end
	end
end


function enterVehicleInteriorByMarker(hitElement, matchingDimension)
	if(matchingDimension and getElementType(hitElement) == "player") then
		if not isPedInVehicle(hitElement) then
			local exiting = getElementData(hitElement, "vehint.exiting")
			if not exiting then
				local vehicle = getElementAttachedTo(source)
				if vehicles[ vehicle ] then
					if not isVehicleLocked( vehicle ) then
						local model = getElementModel(vehicle)
						if(model == 577 or model == 592) then --texture change
							triggerClientEvent(hitElement, "vehicle_interiors:changeTextures", vehicle, model)
						end
						
						local exit = vehicles[ vehicle ]
						local x, y, z = getElementPosition(exit)
						local teleportArr = { x, y, z, getElementInterior(exit), getElementDimension(exit), 0, 0 }
						triggerClientEvent(hitElement, "setPlayerInsideInterior2", vehicle, teleportArr, false)
					end
				end
			else
				--outputDebugString("exiting")
			end
		end
	end
end

function leaveVehIntMarker(hitElement, matchingDimension)
	if(getElementType(hitElement) == "player") then
		setElementData(hitElement, "vehint.exiting", false, false)
	end
end

function leaveInterior( player )
	local dim = getElementDimension( player ) - 20000
	for value in pairs( vehicles ) do
		if getElementData( value, "dbid" ) == dim then
			if isVehicleLocked( value ) then
				outputChatBox( "You try the door handle, but it seems to be locked.", player, 255, 0, 0 )
			else
				if(getElementData(value, "airport.gate.connected")) then
					local gateID = tonumber(getElementData(value, "airport.gate.connected"))
					local teleportArr = exports["vrp_sfia"]:getDataForExitingConnectedPlane(gateID, value)
					if teleportArr then
						setElementInterior(player, teleportArr[4])
						setElementDimension(player, teleportArr[5])
						triggerClientEvent(player, "setPlayerInsideInterior2", player, teleportArr, false)
						return
					end
				end
				
				local x, y, z = getElementPosition( value )
				local xadd, yadd, zadd = 0, 0, 2
				
				if (getElementModel(value) == 454) then -- Tropic
					xadd, yadd, zadd = 0, 0, 4
				elseif (getElementModel(value) == 508) then -- Journey
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,0.5
							break
						end
					end
				elseif (getElementModel(value) == 519) then -- Shamal
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,1.5
							break
						end
					end
				elseif (getElementModel(value) == 577) then -- AT-400
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,1.5
							break
						end
					end
				elseif (getElementModel(value) == 592) then -- Andromada
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,2
							break
						end
					end
					if(isPedInVehicle(player)) then
						if(getPedOccupiedVehicleSeat(player) == 0) then
							local pedVehicle = getPedOccupiedVehicle(player)
							setElementData(pedVehicle, "health", getElementHealth(pedVehicle), false)
							for i = 0, getVehicleMaxPassengers( pedVehicle ) do
								local p = getVehicleOccupant( pedVehicle, i )
								if p then
									triggerClientEvent( p, "CantFallOffBike", p )
								end
							end
							local rz,ry,rx = getElementRotation(value, "ZYX")
							local rot = 0
							if(rz >= 180) then
								rot = rz - 180
							else
								rot = rz + 180
							end
							
							setTimer(warpVehicleIntoInteriorfunction, 500, 1, pedVehicle, getElementInterior(value), getElementDimension(value), x+xadd, y+yadd, z+zadd, rot)	
						end
						return
					end
				elseif (getElementModel(value) == 416) then -- Ambulance
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,0.5
							break
						end
					end
				elseif (getElementModel(value) == 427) then -- Enforcer
					local attached = getAttachedElements(value)
					for k,v in ipairs(attached) do
						if(getElementType(v) == "colshape") then
							x,y,z = getElementPosition(v)
							xadd,yadd,zadd = 0,0,0.5
							break
						end
					end

				end			
				--setElementData(player, "vehint.exiting", true, false)
				local teleportArr = { x + xadd, y + yadd, z + zadd, getElementInterior(value), getElementDimension(value) }
				
				setElementInterior(player, teleportArr[4])
				setElementDimension(player, teleportArr[5])
				triggerClientEvent(player, "setPlayerInsideInterior2", player, teleportArr, false)
				return
			end
		end
	end
end

-- cancel picking up our pickups
function isInPickup( thePlayer, thePickup, distance )
	if not isElement(thePickup) then return false end
	
	local ax, ay, az = getElementPosition(thePlayer)
	local bx, by, bz = getElementPosition(thePickup)
	
	return getDistanceBetweenPoints3D(ax, ay, az, bx, by, bz) < ( distance or 2 ) and getElementInterior(thePlayer) == getElementInterior(thePickup) and getElementDimension(thePlayer) == getElementDimension(thePickup)
end

function isNearExit( thePlayer, theVehicle )
	return isInPickup( thePlayer, vehicles[ theVehicle ] )
end

function checkLeavePickup( player, pickup )
	if isElement( player ) then
		if isInPickup( player, pickup ) then
			setTimer( checkLeavePickup, 500, 1, player, pickup )
		else
			unbindKey( player, "f", "down", leaveInterior )
		end
	end
end

addEventHandler( "onPickupHit", resourceRoot, 
	function( player )
		bindKey( player, "f", "down", leaveInterior )
		
		setTimer( checkLeavePickup, 500, 1, player, source )
		
		cancelEvent( )
	end
)

-- make sure we blow
addEventHandler( "onVehicleRespawn", root,
	function( blown )
		if blown and vehicles[ source ] then
			local dim = getElementData( source ) + 20000
			for k, v in ipairs( getElementsByType( "player" ) ) do
				if getElementDimension( v ) == dim then
					killPed( v, 0 )
				end
			end
		end
	end
)

function vehicleKnock(veh)
	local player = source
	if (player) then
		local tpd = getElementDimension(player)
		if (tpd > 20000) then
			local vid = tpd - 20000
			for key, value in ipairs( getElementsByType( "vehicle" ) ) do
				if getElementData( value, "dbid" ) == vid then
					exports.vrp_global:sendLocalText(player, " *" .. getPlayerName(player):gsub("_"," ") .. " begins to knock on the vehicle.", 255, 51, 102)
					exports.vrp_global:sendLocalText(value, " * Knocks can be heard coming from inside the vehicle. *      ((" .. getPlayerName(player):gsub("_"," ") .. "))", 255, 51, 102)
				end
			end
		else
			if vehicles[veh] then
				local exit = vehicles[veh]

				if (exit) then
					exports.vrp_global:sendLocalText(player, " *" .. getPlayerName(player):gsub("_"," ") .. " begins to knock on the vehicle.", 255, 51, 102)
					exports.vrp_global:sendLocalText(exit, " * Knocks can be heard coming from the outside. *      ((" .. getPlayerName(player):gsub("_"," ") .. "))", 255, 51, 102)
				end
			end
		end
	end
end
addEvent("onVehicleKnocking", true)
addEventHandler("onVehicleKnocking", getRootElement(), vehicleKnock)

function enterVehicle(thePlayer, seat, jacked)
	local model = getElementModel(source)
	if(model == 519 or model == 577) then --Shamal & AT-400
		if vehicles[source] then
			--[[local x,y,z = getElementPosition(source)
			local px,py,pz = getElementPosition(thePlayer)
			if(getDistanceBetweenPoints3D(x,y,z,px,py,pz) < 3) then
				if not isVehicleLocked(source) then
					--outputDebugString("not locked")
					local exit = vehicles[source]
					local x, y, z = getElementPosition(exit)
					local teleportArr = { x, y, z, getElementInterior(exit), getElementDimension(exit), 0, 0 }
					triggerClientEvent(thePlayer, "setPlayerInsideInterior2", source, teleportArr, 0)
				end
			else
				outputDebugString("too far away: "..tostring(getDistanceBetweenPoints3D(x,y,z,px,py,pz)))
			end--]]
			cancelEvent()
		end	
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), enterVehicle)
function exitVehicle(thePlayer, seat, jacked, door)
	--outputDebugString("onVehicleStartExit")
	if(getElementModel(source) == 519) then --Shamal
		if vehicles[source] then
			removePedFromVehicle(thePlayer)
			local teleportArr = { 1.7294921875, 35.7333984375, 1200.3044433594, 1, tonumber(getElementData(source, "dbid"))+20000, 0, 0 }
			fadeCamera(thePlayer, false)
			triggerClientEvent(thePlayer, "setPlayerInsideInterior2", source, teleportArr, false)
			fadeCamera(thePlayer, true)
			cancelEvent()
		end
	elseif(getElementModel(source) == 577) then --AT-400
		if vehicles[source] then
			removePedFromVehicle(thePlayer)
			local teleportArr = { -388.79999, 53.9, 1225.80005, 1, tonumber(getElementData(source, "dbid"))+20000, 0, 0 }
			fadeCamera(thePlayer, false)
			triggerClientEvent(thePlayer, "setPlayerInsideInterior2", source, teleportArr, false)
			fadeCamera(thePlayer, true)
			cancelEvent()
		end
	end
end
addEventHandler("onVehicleStartExit", getRootElement(), exitVehicle)

function seeThroughWindows(thePlayer, nx, ny, nz) -- This is for /windows
	local dim = getElementDimension(thePlayer)
	if (getElementData(thePlayer, "isInWindow") == false or not getElementData(thePlayer, "isInWindow")) and dim > 20000 then
		outputChatBox("Viewing through windows", thePlayer)

		local id = dim - 20000
		local vehicle = exports.vrp_pool:getElement("vehicle", tonumber(id))
		local x, y, z = getElementPosition(vehicle)
		local vehdim = getElementDimension(vehicle)
		local vehint = getElementInterior(vehicle)
		local dim = getElementDimension(thePlayer)
		local int = getElementInterior(thePlayer)
		local px, py, pz = getElementPosition(thePlayer)
		setElementData(thePlayer, "isInWindow", true) -- Got to set a bunch of element data so he can return safely into normal mode
		setElementData(thePlayer, "isInWindow:vehID", id)
		setElementData(thePlayer, "isInWindow:dim", dim)
		setElementData(thePlayer, "isInWindow:int", int)
		setElementData(thePlayer, "isInWindow:x", px)
		setElementData(thePlayer, "isInWindow:y", py)
		setElementData(thePlayer, "isInWindow:z", pz)
		setElementData(thePlayer, "isInWindow:initialdim", vehdim)
		setElementData(thePlayer, "isInWindow:initialint", vehint)
		
		setElementInterior(thePlayer, vehint)
		setElementDimension(thePlayer, vehdim)

		setElementPosition(thePlayer, x, y, z+1)
		setElementAlpha(thePlayer, 0)
		local zoffset = 3 -- Basic offset, exceptions below
		if getVehicleModelFromName( getVehicleName( vehicle ) ) == 577 then zoffset = 8 end -- AT-400 is big! 
		attachElements(thePlayer, vehicle, 0, 0, zoffset)
	elseif getElementData(thePlayer, "isInWindow") == true then -- This is if he's already in window mode
		outputChatBox("Viewing back into interior", thePlayer)
		detachElements(thePlayer)
		setElementData(thePlayer, "isInWindow", false)
		local returndim = getElementData(thePlayer, "isInWindow:dim")
		local returnint = getElementData(thePlayer, "isInWindow:int")
		local px = getElementData(thePlayer, "isInWindow:x")
		local py = getElementData(thePlayer, "isInWindow:y")
		local pz = getElementData(thePlayer, "isInWindow:z")
		setElementPosition(thePlayer, px, py, pz)
		setElementInterior(thePlayer, returnint)
		setElementDimension(thePlayer, returndim)
		setElementAlpha(thePlayer, 255)
	end
end
addEvent("seeThroughWindows", true)
addEventHandler("seeThroughWindows", getRootElement(), seeThroughWindows)

function updateView(thePlayer) -- This checks if the vehicle changed dim/int. If it did, it returns the player back into normal position so his int/dim is not fucked up. He will need to type /windows again.
	if getElementData(thePlayer, "isInWindow") == true then
		local id = getElementData(thePlayer, "isInWindow:vehID")
		local vehicle = exports.vrp_pool:getElement("vehicle", tonumber(id))
		local x, y, z = getElementPosition(vehicle)
		local dim = getElementDimension(vehicle)
		local int = getElementInterior(vehicle)

		if int ~= getElementData(thePlayer, "isInWindow:initialint") and dim ~= getElementData(thePlayer, "isInWindow:initialdim") then
			triggerEvent("seeThroughWindows", getRootElement(), thePlayer)
		end
	end
end
addEvent("updateWindowsView", true)
addEventHandler("updateWindowsView", getRootElement(), updateView)