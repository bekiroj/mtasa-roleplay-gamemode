fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [509]=true, [510]=true, [481]=true }
enginelessVehicle = { [510]=true, [509]=true, [481]=true }

local font = exports.vrp_fonts:getFont("Modern", 18)


renderTimers = {}

function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 0, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end


local fuel = 0
local width, height = guiGetScreenSize()
function drawSpeedo()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (vehicle) then
		speed = exports.vrp_global:getVehicleVelocity(vehicle, getLocalPlayer())
		local x = width
		local y = height
		local ax, ay = x - 180, y/2
				
		dxDrawShadowText("Hız:", ax, ay-50, 5, 5, tocolor(230, 230, 230, 255), 1, font, "left", "top", false, false, false, true, false)
		dxDrawShadowText(tostring(math.floor(speed)).." km/s", ax+50, ay-50, 5, 5, tocolor(230, 230, 230, 180), 1, font, "left", "top", false, false, true, true, false)
		speed = speed - 100
		nx = x + math.sin(math.rad(-(speed)-150)) * 90
		ny = y + math.cos(math.rad(-(speed)-150)) * 90

	end
end


function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)

function drawFuel()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (vehicle) then
		local x = width
		local y = height

		local FuelPer = (fuel/exports["vrp_vehicle_fuel"]:getMaxFuel(vehicle))*100

		if FuelPer > 100 then
			FuelPer = fuel 
		end
		local ax, ay = x - 180, y/2
		dxDrawShadowText("Yakıt:", ax, ay-20, 5, 5, tocolor(230, 230, 230, 255), 1, font, "left", "top", false, false, false, true, false)
		dxDrawShadowText(tostring(math.floor(getElementData(vehicle, "fuel") or 0)).." lt", ax+75, ay-20, 5, 5, tocolor(230, 230, 230, 180), 1, font, "left", "top", false, false, true, true, false)
	end
end

function dxDrawShadowText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)

        dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
 
        dxDrawText(text, x1 - 2, y1, x2 - 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 2, x2, y2 - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)

        dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

function onVehicleEnter(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if seat == 0 and not (fuellessVehicle[id]) then
				createRender("drawFuel", drawFuel)
			end
			if not (enginelessVehicle[id]) then
				createRender("drawSpeedo", drawSpeedo)
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onVehicleEnter)

function onVehicleExit(thePlayer, seat)
	if (thePlayer==getLocalPlayer()) then
		if (seat<2) then
			local id = getElementModel(source)
			if seat == 0 and not (fuellessVehicle[id]) then
				destroyRender("drawFuel", drawFuel)
			end
			if not(enginelessVehicle[id]) then
				destroyRender("drawSpeedo", drawSpeedo)
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), onVehicleExit)

function hideSpeedo()
	destroyRender("drawSpeedo", drawSpeedo)
	destroyRender("drawFuel", drawFuel)
end

function removeSpeedo()
	if not (isPedInVehicle(getLocalPlayer())) then
		hideSpeedo()
	end
end
setTimer(removeSpeedo, 1000, 0)

local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()
distanceTraveled = 0
local syncTraveled = 0
local oX, oY, oZ
local carSync = false
local lastVehicle = nil

function setUp(startedResource)
	if(startedResource == getThisResource()) then
		oX,oY,oZ = getElementPosition(localPlayer)
	end
end
addEventHandler("onClientResourceStart",getRootElement(),setUp)

function monitoring()
	local x,y,z = getElementPosition(localPlayer)
	if(isPedInVehicle(localPlayer)) then
		local x,y,z = getElementPosition(localPlayer)
		local thisTime  = getDistanceBetweenPoints3D(x,y,z,oX,oY,oZ) -- / 2.1
		distanceTraveled = distanceTraveled + thisTime
		syncTraveled = syncTraveled + thisTime
	end
	oX = x
	oY = y
	oZ = z
end
addEventHandler("onClientRender",getRootElement(),monitoring)

function getDistanceTraveled()
	return distanceTraveled
end

function receiveDistanceSync( amount )
	if (isPedInVehicle(localPlayer)) then
		if (source == getPedOccupiedVehicle(localPlayer)) then
			distanceTraveled = amount or 0
			carSync = true
		end
	end
end
addEvent("realism:distance", true)
addEventHandler("realism:distance", getRootElement(), receiveDistanceSync)

function onResourceStart()
	if (isPedInVehicle(localPlayer)) then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if (theVehicle) then
			carSync = false
			triggerServerEvent("realism:distance", theVehicle)
		end
	end
	setTimer(stopCarSync, 1000, 0)
	setTimer(syncBack, 60000, 0)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), onResourceStart)

function syncBack(force)
	if (isPedInVehicle(localPlayer) or force) then
		local theVehicle = getPedOccupiedVehicle(localPlayer)
		if (theVehicle or force) then
			if carSync then
				local shit = force and lastVehicle or theVehicle
				if isElement(shit) then
					triggerServerEvent("realism:distance", shit, distanceTraveled, syncTraveled)
					syncTraveled = 0
				end
			end
		end
	end
end

function stopCarSync()
	if not (isPedInVehicle(localPlayer)) then
		if carSync then
			syncBack(true)
		end
		carSync = false
		distanceTraveled = 0
		syncTraveled = 0
	else
		lastVehicle = getPedOccupiedVehicle(localPlayer)
	end
end

function bikeSpeed(theVehicle)
    if getPedOccupiedVehicle(getLocalPlayer()) then
        if getVehicleType(theVehicle) == "Bike" then
            if getPedControlState("accelerate") then
				toggleControl("steer_forward", false)
			else
                toggleControl("steer_forward", true)
			end
			setTimer(bikeSpeed, 50, 1, theVehicle)
		else
			toggleControl("steer_forward", true)
		end
	else
		toggleControl("steer_forward", true)
    end
end
addEventHandler("onClientPlayerVehicleEnter", getLocalPlayer(), bikeSpeed)

local wCK, gCK, bClose

addEvent( "showCKList", true )
addEventHandler( "showCKList", getLocalPlayer(),
	function( names, data )
		if wCK then
			destroyElement( wCK )
			wCK = nil
			
			showCursor( false )
		else
			local sx, sy = guiGetScreenSize()
			local windowname = data == 2 and "In Remembrance of ..." or "Missing People"
			wCK = guiCreateWindow( sx / 2 - 125, sy / 2 - 250, 250, 500, "(( " .. windowname .. " ))", false )
			
			gCK = guiCreateGridList( 0.03, 0.04, 0.94, 0.88, true, wCK )
			local colName = guiGridListAddColumn( gCK, "Name", 0.93 )
			for key, name in pairs( names ) do
				local row = guiGridListAddRow( gCK )
				guiGridListSetItemText( gCK, row, colName, name:gsub("_", " "), false, false, false )
			end
			
			bClose = guiCreateButton( 0.03, 0.93, 0.94, 0.07, "Close", true, wCK )
			addEventHandler( "onClientGUIClick", bClose,
				function( button, state )
					if button == "left" and state == "up" then
						destroyElement( wCK )
						wCK = nil
						
						showCursor( false )
					end
				end, false
			)
			
			showCursor( true )
		end
	end
)

local lPlayer = getLocalPlayer()
local ckGUIState = nil
ax, ay = nil
ckBody = nil

function clickCKBody(button, state, absX, absY, wx, wy, wz, element)
	local lPlayer = source
	if getElementData(lPlayer, "exclusiveGUI") then
		return
	end
	if (button=="right") and (state=="down") then
		for k, v in pairs(getElementsByType("ped", getResourceRootElement())) do
			if isElementStreamedIn(v) and getElementHealth(v) == 0 then
				local x, y, z = getElementPosition(v)
				local distance = getDistanceBetweenPoints3D(wx, wy, wz, x, y, z)
				if (distance<=1.4) then
					if (ckGUIState == 1) then
						hideCKInfo()
					else
						showCursor(true)
						ax = absX
						ay = absY
						ckBody = v
						triggerServerEvent("ck:info", v)
						return
					end
				end
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickCKBody)

function showCKInfo(text, name)
	hideCKInfo()
	
	ckInfoWindow = guiCreateWindow(ax, ay, 350, 200, name and ( "A corpse (( " .. name .. " )) " ) or "A corpse of a dead body.", false)

	local txt1 = guiCreateMemo(0.05, 0.12, 0.89, 0.7, tostring(text), true, ckInfoWindow)
	guiSetFont(txt1, "default-bold-small")
	guiMemoSetReadOnly (txt1, true)

	local cbutton = guiCreateButton(0.05, 0.85, 0.87, 0.1, "Close Menu", true, ckInfoWindow)
	addEventHandler("onClientGUIClick", cbutton, hideCKInfo, false)
	
	ckGUIState = 1
end
addEvent("ck:show", true)
addEventHandler("ck:show", getRootElement(), showCKInfo)

function hideCKInfo()
	if ckGUIState == 1 then
		showCursor(false)
		destroyElement(ckInfoWindow)
		ckGUIState = 0
	end
end

local limitSpeed = { }
local ccEnabled = false
local theVehicle = nil
local targetSpeed = 0

function doCruiseControl()
    if not isElement(theVehicle) or not getVehicleEngineState(theVehicle) then
        deactivateCruiseControl()
        return false
    end
    local x,y = angle(theVehicle)
    if (x < 5) then
        local targetSpeedTmp = getElementSpeed(theVehicle)
        if (targetSpeedTmp > targetSpeed) then
            setPedControlState("accelerate",false)
        elseif (targetSpeedTmp < targetSpeed) then
            setPedControlState("accelerate",true)
        end
    end
end

function activateCruiseControl()
    addEventHandler("onClientRender", getRootElement(), doCruiseControl)
    ccEnabled = true
    bindMe()
end

function deactivateCruiseControl()
    removeEventHandler("onClientRender", getRootElement(), doCruiseControl)
    setPedControlState("accelerate",false)
    ccEnabled = false
    exports.vrp_hud:sendBottomNotification(localPlayer, "Hız Sabitleyici", "Hız sabitleyiciyi kapattınız.")
end

function applyCruiseControl()
	theVehicle = getPedOccupiedVehicle( getLocalPlayer() )
	if (theVehicle) then
		if (getVehicleOccupant(theVehicle) == getLocalPlayer()) then
			if (getVehicleEngineState ( theVehicle ) == true) then
				if (ccEnabled) then
					deactivateCruiseControl()
				else
					targetSpeed = getElementSpeed(theVehicle)
					if targetSpeed > 10 then
						if (getVehicleType(theVehicle) == "Automobile" or getVehicleType(theVehicle) == "Bike" or getVehicleType(theVehicle) =="Boat" or getVehicleType(theVehicle) == "Train" or getVehicleType(theVehicle) == "Plane" or getVehicleType(theVehicle) == "Helicopter") then
							exports.vrp_hud:sendBottomNotification(localPlayer, "Hız Sabitleme", "Hızı düşürmek için '-', arttırmak için '+'ya basın.")
							activateCruiseControl()
						end
					else
                        exports.vrp_hud:sendBottomNotification(localPlayer, "Hız Sabitleyici", "Hız sabitleyici, hızını korumak için kullanılabilir.")
					end
				end
            else
                exports.vrp_hud:sendBottomNotification(localPlayer, "Hız Sabitleyici", "Motor açık değil!")
			end
		end
	end
end
addEvent("realism:togCc", true)
addEventHandler("realism:togCc", root, applyCruiseControl)

addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), function(veh, seat)
    if (seat==0) then
        if (ccEnabled) then
            deactivateCruiseControl()
        end
    end
end)

function increaseCruiseControl()
    if (ccEnabled) then
        targetSpeed = targetSpeed + 5
        
        local tV = getPedOccupiedVehicle(getLocalPlayer()) 
        if (tV) then
            local maxSpeed = limitSpeed[getElementModel(tV)]
            if maxSpeed then 
                if targetSpeed > maxSpeed then
                    targetSpeed = maxSpeed
                end
            end
        end 
    end
end


function decreaseCruiseControl()
    if (ccEnabled) then
        targetSpeed = targetSpeed - 5
    end
end


function startAccel()
    if (ccEnabled) then
        deactivateCruiseControl()
    end
end


function stopAccel()
    if (ccEnabled) then
        deactivateCruiseControl()
    end
end


function restrictBikes(manual) 
    local tV = getPedOccupiedVehicle(getLocalPlayer()) 
    if (tV) then
        local maxSpeed = limitSpeed[getElementModel(tV)]
        if maxSpeed then 
            tS = exports.vrp_global:getVehicleVelocity(tV) 
            if tS > maxSpeed then 
                toggleControl("accelerate",false) 
            else 
                toggleControl("accelerate", true) 
            end 
        end
    end 
end


function bindMe()
    bindKey("brake_reverse", "down", stopAccel)
    bindKey("accelerate", "down", startAccel)
end

    function loadMe( startedRes )
        outputDebugString("cc loaded")
        bindKey("-", "down", decreaseCruiseControl)
        bindKey("num_sub", "down", decreaseCruiseControl)
        
        bindKey("=", "down", increaseCruiseControl)
        bindKey("num_add", "down", increaseCruiseControl)
        
        addCommandHandler("cc", applyCruiseControl)
        addCommandHandler("cruisecontrol", applyCruiseControl)

        addEventHandler("onClientRender", getRootElement(), restrictBikes)
        bindMe()
    end
addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()) , loadMe)

function isCcEnabled()
    return ccEnabled
end

function resourceStart()
	bindKey("c", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		applyCruiseControl()
	end) 
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStart)


local soundElement = { }

local beepingTrucksArray = -- Removed SAN vehicles because of Fields.
{ 
	[486] = true, -- Dozer
	[406] = true, -- Dumper
	[573] = true, -- Dune
	[455] = true, -- FlatBed
	[407] = true, -- FireTruck
	[427] = true, -- Enforcer
	[416] = true, -- Ambulance
	[578] = true, -- DFT
	[544] = true, -- Firetruck (Ladder)
	[456] = true, -- Yankee
	[414] = true, -- Mule
	[515] = true, -- RoadTrain
	[403] = true, -- LineRunner
	[514] = true, -- LineRunner (Tank Commando thing)
	[525] = true, -- Towtruck
	[443] = true  -- Packer
}

function isVehicleThatBeeps( vehicleModel )
	return beepingTrucksArray[getElementModel( vehicleModel )]
end

function doBeep()
	local localPlayer = getLocalPlayer( )

	local elementVehicle = getPedOccupiedVehicle ( localPlayer )
	
	if not elementVehicle then
		if getElementData( localPlayer, "backupbleepers:goingBackwards" ) then
			setElementData( localPlayer, "backupbleepers:goingBackwards", false )	
		end
		return false
	end
	if beepingTrucksArray[getElementModel(elementVehicle)] and (isObjectGoingBackwards(elementVehicle, true)) then
		setElementData( localPlayer, "backupbleepers:goingBackwards", true )
	elseif getElementData( localPlayer, "backupbleepers:goingBackwards" ) and not isObjectGoingBackwards(elementVehicle, true) then
		setElementData( localPlayer, "backupbleepers:goingBackwards", false )
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement( ),  -- getElementRoot() makes it trigger for every loaded resource...
	function() 
		setTimer( doBeep, 400, 0 ) 
	end 
)

addEventHandler ( "onClientElementDataChange", getRootElement(),
	function ( elementData )
	
		if elementData ~= "backupbleepers:goingBackwards" then
			return false
		end
		
		if not isVehicleThatBeeps( getPedOccupiedVehicle( source ) ) then
			return false
		end
		
		for idx, i in ipairs(getElementsByType( "player" )) do -- Looping through all players to attach the sound.
			local
				elementVehicle = getPedOccupiedVehicle ( i )
				
			if getElementData( i, "backupbleepers:goingBackwards" ) then -- if goingBackwards was set to true.
				if not soundElement[elementVehicle] then
					local x, y, z = getElementPosition(elementVehicle)
					soundElement[elementVehicle]  =  playSound3D( "components/TruckBackingUpBeep.mp3", x, y, z, true )
					attachElements( soundElement[elementVehicle], elementVehicle )
		
				end
			elseif not getElementData( i, "backupbleepers:goingBackwards" ) then -- if goingBackwards was set to false.
				if isElement(soundElement[elementVehicle]) then
					stopSound(soundElement[elementVehicle])
				end
				soundElement[elementVehicle] = nil
			end
		end
	end 
)

function isObjectGoingBackwards( theVehicle, second )
	if not theVehicle or not isElement (theVehicle) or not getVehicleOccupant ( theVehicle, 0 ) or not getPedControlState("brake_reverse") then
		return false
	end

	x, y, z = getElementVelocity ( theVehicle )
	z = ( function( a, b, c ) return c end ) ( getElementRotation ( theVehicle ) )
	local returnValue = false

	if x == 0 or y == 0 then
		return false
	end
	
	local xx, yy, zz = getElementRotation( theVehicle )
	
	if (xx == 90 or yy == 90) or (xx == 180 or yy == 180) or (xx == 270 or yy == 270) or (xx == 0 or yy == 0) then
		return false
	end
	
	if z > 0 and z < 90 and not (x < 0 and y > 0) then -- Front left
		--outputDebugString("a x:"..x.." y:"..y.." z:"..z)
		returnValue = true
	elseif z > 90 and  z < 180 and not (x < 0 and y < 0) then -- Back left
		--outputDebugString("B x:"..x.." y:"..y.." z:"..z)
		returnValue = true
	elseif  z > 180 and z < 270 and not (x > 0 and y < 0) then -- Back right
		--outputDebugString("c x:"..x.." y:"..y.." z:"..z)
		returnValue = true
	elseif  z > 270 and z < 360 and not (x > 0 and y > 0) then -- Back right
		--outputDebugString("d x:"..x.." y:"..y.." z:"..z)
		returnValue = true
	end  
	
	if not second then
		returnValue = isObjectGoingBackwards( theVehicle, true )
	end	
	
	return returnValue
end

local root = getRootElement()
local localPlayer = getLocalPlayer()
local PI = math.pi

local isEnabled = false
local wasInVehicle = isPedInVehicle(localPlayer)

local mouseSensitivity = 0.1
local rotX, rotY = 0,0
local mouseFrameDelay = 0
local idleTime = 2500
local fadeBack = false
local fadeBackFrames = 50
local executeCounter = 0
local recentlyMoved = false
local Xdiff,Ydiff

function toggleCockpitView ()
	if getElementData(localPlayer, "loggedin") ~= 1 then
		return false
	end

	if (not isEnabled) then
		if (getCameraTarget() == localPlayer or getCameraTarget() == getPedOccupiedVehicle(localPlayer))  then
			isEnabled = true
			addEventHandler ("onClientPreRender", root, updateCamera)
			addEventHandler ("onClientCursorMove",root, freecamMouse)
		end
	else --reset view
		isEnabled = false
		setCameraTarget (localPlayer, localPlayer)
		removeEventHandler ("onClientPreRender", root, updateCamera)
		removeEventHandler ("onClientCursorMove", root, freecamMouse)
	end
end

addCommandHandler("fp", toggleCockpitView)
addCommandHandler("cockpit", toggleCockpitView)

function updateCamera ()
	if (isEnabled) then
	
		local nowTick = getTickCount()
		
		-- check if the last mouse movement was more than idleTime ms ago
		if wasInVehicle and recentlyMoved and not fadeBack and startTick and nowTick - startTick > idleTime then
			recentlyMoved = false
			fadeBack = true
			if rotX > 0 then
				Xdiff = rotX / fadeBackFrames
			elseif rotX < 0 then
				Xdiff = rotX / -fadeBackFrames
			end
			if rotY > 0 then
				Ydiff = rotY / fadeBackFrames
			elseif rotY < 0 then
				Ydiff = rotY / -fadeBackFrames
			end
		end
		
		if fadeBack then
		
			executeCounter = executeCounter + 1
		
			if rotX > 0 then
				rotX = rotX - Xdiff
			elseif rotX < 0 then
				rotX = rotX + Xdiff
			end
		
			--if rotY > 0 then
			--	rotY = rotY - Ydiff
			--elseif rotY < 0 then
			--	rotY = rotY + Ydiff
			--end
		
			if executeCounter >= fadeBackFrames then
				fadeBack = false
				executeCounter = 0
			end
		
		end
		
		local camPosXr, camPosYr, camPosZr = getPedBonePosition (localPlayer, 6)
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (localPlayer, 7)
		local camPosX, camPosY, camPosZ = (camPosXr + camPosXl) / 2, (camPosYr + camPosYl) / 2, (camPosZr + camPosZl) / 2 - 0.2
		
		camPosZ = camPosZ + 0.2
		local roll = 0
		
		inVehicle = isPedInVehicle(localPlayer)
		
		-- note the vehicle rotation
		if inVehicle then
			local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
			
			--roll = ry
			--if rx > 90 and rx < 270 then
			--	roll = ry - 180
			--end
			
			--if not wasInVehicle then
			--	rotX = rotX + math.rad(rz) --prevent camera from rotation when entering a vehicle
			--	if rotY > -PI/15 then --force camera down if needed
			--		rotY = -PI/15 
			--	end
			--end
			
			cameraAngleX = rotX - math.rad(rz)
			cameraAngleY = rotY + math.rad(rx)
			
			if getPedControlState("vehicle_look_behind") or ( getPedControlState("vehicle_look_right") and getPedControlState("vehicle_look_left") ) then
				cameraAngleX = cameraAngleX + math.rad(180)
				--cameraAngleY = cameraAngleY + math.rad(180)
			elseif getPedControlState("vehicle_look_left") then
				cameraAngleX = cameraAngleX - math.rad(90)
				--roll = rx doesn't work out well
			elseif getPedControlState("vehicle_look_right") then
				cameraAngleX = cameraAngleX + math.rad(90)  
				--roll = -rx
			end
		else
			local rx, ry, rz = getElementRotation(localPlayer)
			
			if wasInVehicle then
				rotX = rotX - math.rad(rz) --prevent camera from rotating when exiting a vehicle
			end
			cameraAngleX = rotX
			cameraAngleY = rotY
		end
		
		wasInVehicle = inVehicle
		
		--Taken from the freecam resource made by eAi
		
		-- work out an angle in radians based on the number of pixels the cursor has moved (ever)
		
		local freeModeAngleZ = math.sin(cameraAngleY)
		local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
		local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

		-- calculate a target based on the current position and an offset based on the angle
		local camTargetX = camPosX + freeModeAngleX * 100
		local camTargetY = camPosY + freeModeAngleY * 100
		local camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Work out the distance between the target and the camera (should be 100 units)
		local camAngleX = camPosX - camTargetX
		local camAngleY = camPosY - camTargetY
		local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

		-- Calulcate the length of the vector
		local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

		-- Normalize the vector, ignoring the Z axis, as the camera is stuck to the XY plane (it can't roll)
		local camNormalizedAngleX = camAngleX / angleLength
		local camNormalizedAngleY = camAngleY / angleLength
		local camNormalizedAngleZ = 0

		-- We use this as our rotation vector
		local normalAngleX = 0
		local normalAngleY = 0
		local normalAngleZ = 1

		-- Perform a cross product with the rotation vector and the normalzied angle
		local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
		local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
		local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

		-- Update the target based on the new camera position (again, otherwise the camera kind of sways as the target is out by a frame)
		camTargetX = camPosX + freeModeAngleX * 100
		camTargetY = camPosY + freeModeAngleY * 100
		camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Set the new camera position and target
		setCameraMatrix (camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ, roll)
		--[[
		dxDrawText("fadeBack = "..tostring(fadeBack),400,200)
		dxDrawText("recentlyMoved = "..tostring(recentlyMoved),400,220)
		if executeCounter then dxDrawText("executeCounter = "..tostring(executeCounter),400,240) end
		dxDrawText("rotX = "..tostring(rotX),400,260)
		dxDrawText("rotY = "..tostring(rotY),400,280)
		if Xdiff then dxDrawText("Xdiff = "..tostring(Xdiff),400,300) end
		if Ydiff then dxDrawText("Ydiff = "..tostring(Ydiff),400,320) end
		if startTick then dxDrawText("startTick = "..tostring(startTick),400,340) end
		dxDrawText("nowTick = "..tostring(nowTick),400,360)
		]]
	end
end

function freecamMouse (cX,cY,aX,aY)
	
	--ignore mouse movement if the cursor or MTA window is on
	--and do not resume it until at least 5 frames after it is toggled off
	--(prevents cursor mousemove data from reaching this handler)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	startTick = getTickCount()
	recentlyMoved = true
	
	-- check if the mouse is moved while fading back, if so abort the fading
	if fadeBack then
		fadeBack = false
		executeCounter = 0
	end
	
	-- how far have we moved the mouse from the screen center?
	local width, height = guiGetScreenSize()
	aX = aX - width / 2 
	aY = aY - height / 2
	
	rotX = rotX + aX * mouseSensitivity * 0.01745
	rotY = rotY - aY * mouseSensitivity * 0.01745

	local pRotX, pRotY, pRotZ = getElementRotation (localPlayer)
	pRotZ = math.rad(pRotZ)
	
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
	-- limit the camera to stop it going too far up or down
	--if isPedInVehicle(localPlayer) then
		--[[if rotY < -PI / 2 then
			rotY = -PI / 2
		elseif rotY > -PI/2 then
			rotY = -PI/2
		end]]
	--else
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > PI / 2.1 then
			rotY = PI / 2.1
		end
	--end
end

radio = 0
lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

function saveRadio(station)
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	
	if (vehicle) then
		if getVehicleOccupant(vehicle) == getLocalPlayer() or getVehicleOccupant(vehicle, 1) == getLocalPlayer() then
			if not (lawVehicles[getElementModel(vehicle)]) then
				radio = station
				triggerServerEvent("sendRadioSync", getLocalPlayer(), station)
			else
				cancelEvent()
				radio = 0
				setRadioChannel(0)
			end
		else
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)

function syncRadio(station)
	removeEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
	setRadioChannel(tonumber(station))
	addEventHandler("onClientPlayerRadioSwitch", getLocalPlayer(), saveRadio)
end
addEvent("syncRadio", true)
addEventHandler("syncRadio", getRootElement(), syncRadio)

local wasSprinting
local function AntiBunny()
    local moveState = getPedMoveState(localPlayer)
    if moveState == "sprint" then
        wasSprinting = true
        return
    elseif wasSprinting and moveState == "jump" then
        setTimer(setPedAnimation, 50, 1, localPlayer, "ped", "FALL_collapse", -1, false, true, false, false)
    end
    wasSprinting = nil
end
--addEventHandler("onClientPreRender", root, AntiBunny)

copCars = {
[427] = true,
[490] = true,
[528] = true,
[523] = true,
[596] = true,
[597] = true,
[598] = true,
[599] = true,
[601] = true }

function onCopCarEnter(thePlayer, seat)
	if (seat < 2) and (thePlayer==getLocalPlayer()) then
		local model = getElementModel(source)
		if (copCars[model]) then
			setRadioChannel(0)
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onCopCarEnter)

function realisticWeaponSounds(weapon)
	local x, y, z = getElementPosition(getLocalPlayer())
	local tX, tY, tZ = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, tX, tY, tZ)
	
	if (distance<25) and (weapon>=22 and weapon<=34) then
		local randSound = math.random(27, 30)
		playSoundFrontEnd(randSound)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), realisticWeaponSounds)

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end


function angle(vehicle)
	local vx,vy,vz = getElementVelocity(vehicle)
	local modV = math.sqrt(vx*vx + vy*vy)
	
	if not isVehicleOnGround(vehicle) then return 0,modV end
	
	local rx,ry,rz = getElementRotation(vehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	
	local cosX = (sn*vx + cs*vy)/modV

	return math.deg(math.acos(cosX))*0.5, modV
end

local c_root = getRootElement()
local c_player = getLocalPlayer()
local c_lastspeed = 0
local c_speed = 0
local isplayernotjumpaway = true

-----------------------------
function getActualVelocity( element, x, y, z )
	return (x^2 + y^2 + z^2) ^ 0.5
end

-----------------------------
function updateDamage(c_veh)
	c_speed = getActualVelocity( c_veh, getElementVelocity( c_veh ) )
	if c_lastspeed - c_speed >= 0.25 and not isElementFrozen( c_veh ) then
		if (c_lastspeed - c_speed >= 0.35) then -- trigger throwing out of the vehicle
			local vehicle = getPedOccupiedVehicle(getLocalPlayer())
			local x, y, z = getElementPosition(getLocalPlayer())
			local nx, ny, nz
			local rz = getPedRotation(getLocalPlayer())

			nx = x + math.sin( math.rad( rz )) * 2
			ny = y + math.cos( math.rad( rz )) * 2
			nz = getGroundPosition(nx, ny, z)
			
			local bcollision, ex, ey, ez, element = processLineOfSight(x, y, z+1, nx, ny, nz+1, true, true, true, true, true, false, false, false, vehicle)
			if (bcollision) then
				ez = getGroundPosition(ex, ey, ez)
				if not getElementData(c_player, "seatbelt") and getVehicleType(vehicle) ~= "Train" then
					--triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, ex, ey, ez+1, vehicle)
				end
			else
				if not getElementData(c_player, "seatbelt") and getVehicleType(vehicle) ~= "Train" then
					--triggerServerEvent("crashThrowPlayerFromVehicle", vehicle, nx, ny, nz+1, vehicle)
				end
			end
		end
		c_lasthealth = getElementHealth(c_player) - 20*(c_lastspeed)
		if c_lasthealth <= 0 then
			c_lasthealth = 0
		end
		setElementHealth(c_player , c_lasthealth)
	end
	c_lastspeed = c_speed
end

function onJumpOut()
	isplayernotjumpaway = false
end

function onJumpFinished()

	isplayernotjumpaway = true
end

-----------------------------
addEventHandler( "onClientVehicleStartExit", c_root,onJumpOut)
addEventHandler( "onClientVehicleExit", c_root,onJumpFinished)
addEventHandler( "onClientRender", c_root,function  ( )
	if isPedInVehicle(c_player) then
		c_veh = getPedOccupiedVehicle(c_player)
		if c_veh then
			--local c_veh_driver = getVehicleOccupant ( c_veh, 0 )
			--if c_veh_driver == c_player then
				updateDamage(c_veh)
			--end
		end
	else
		c_speed = 0
		c_lastspeed = 0
	end
end
)

local l_beer = { }
local r_beer = { }
local deagle = { }
local isLocalPlayerdrinkingBool = false
function setdrinking(player, state, hand)
	setElementData(player,"drinking",state, false)
	if not (hand) or (hand == 0) then
		setElementData(player, "drinking:hand", 0, false)
	else
		setElementData(player, "drinking:hand", 1, false)
	end

	if (isElement(player)) then
		if (state) then
			playerExitsVehicle(player)
		else
			playerEntersVehicle(player)
		end
	end
end

function playerExitsVehicle(player)
	if (getElementData(player, "drinking")) then
		playerEntersVehicle(player)
		if (getElementData(player, "drinking:hand") == 1) then
			r_beer[player] = createbeerModel(player, 1543)
		else
			l_beer[player] = createbeerModel(player, 1543)
		end
	end
end

function playerEntersVehicle(player)
	if (l_beer[player]) then
		if (isElement( l_beer[player] )) then
			destroyElement( l_beer[player] )
		end
		l_beer[player] = nil
	end
	if (r_beer[player]) then
		if (isElement( r_beer[player] )) then
			destroyElement( r_beer[player] )
		end
		r_beer[player] = nil
	end
end

function removeSigOnExit()
	playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

function syncbeerette(state, hand)
	if (isElement(source)) then
		if (state) then
			setdrinking(source, true, hand)
		else
			setdrinking(source, false, hand)
		end
	end
end
addEvent( "realism:drinkingsync", true )
addEventHandler( "realism:drinkingsync", getRootElement(), syncbeerette, righthand )

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function ( startedRes )
		triggerServerEvent("realism:drinking.request", getLocalPlayer())
	end
);

function createbeerModel(player, modelid)
	if (l_beer[player] ~= nil) then
		local currobject = l_beer[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_beer[player] = nil
		end
	end
	
	local object = createObject(modelid, 0,0,0)

	setElementCollisionsEnabled(object, false)
	return object
end

function updateBeer()
	isLocalPlayerdrinkingBool = false
	-- left hand
	for thePlayer, theObject in pairs(l_beer) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerdrinkingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 36)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 170
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
		    moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end

	-- right hand
	for thePlayer, theObject in pairs(r_beer) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerdrinkingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 26)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 100
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		
			moveObject ( theObject, 1, bx, by, bz )
			setElementPosition(theObject, bx, by, bz)
			setElementRotation(theObject, 60, 30, r)
			setElementDimension(theObject, dim)
			setElementInterior(theObject, int)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), updateBeer)
addCommandHandler("mdri", createbeerModel)
addCommandHandler("dri", updateBeer)

function isLocalPlayerdrinking()
	return isLocalPlayerdrinkingBool
end

alarmless = { [592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [20]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [581]=true, [510]=true, [509]=true, [522]=true, [481]=true, [461]=true, [462]=true, [448]=true, [521]=true, [468]=true, [463]=true, [586]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [537]=true, [538]=true, [569]=true, [590]=true, [441]=true, [464]=true, [501]=true, [465]=true, [564]=true, [571]=true, [471]=true, [539]=true, [594]=true }
local localPlayer = getLocalPlayer()
local alarmtable = { [1] = {}, [2] = {} }
function resStart()
	for key, value in ipairs(getElementsByType("vehicle")) do
		setElementData(value, "alarm", nil, false)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resStart)

local oldTask = ""
local theVehicle = nil
function checkAlarm()
	task = getPedSimplestTask(getLocalPlayer())
	if task ~= oldTask then
		if theVehicle then
			if task == "TASK_SIMPLE_CAR_OPEN_LOCKED_DOOR_FROM_OUTSIDE" then
				triggerServerEvent("onVehicleRemoteAlarm", theVehicle, getLocalPlayer())
				theVehicle = nil
			elseif task == "TASK_SIMPLE_PLAYER_ON_FOOT" or task == "TASK_SIMPLE_CAR_GET_IN" then
				theVehicle = nil
			end
		end
		oldTask = task
	end
end
addEventHandler("onClientRender", getRootElement(), checkAlarm)

function carAlarm()
	local alarm = getElementData(source, "alarm")
	if not alarm then
		alarmtable[1][source] = setTimer(doCarAlarm, 1000, 20, source)
		setElementData(source, "alarm", 1, false)
		alarmtable[2][source] = setTimer(resetAlarm, 11000, 1, source)
		triggerServerEvent("alarmDistrict", localPlayer, district)
	end
end
addEvent("startCarAlarm", true)
addEventHandler("startCarAlarm", getRootElement(), carAlarm)

function updateCar(thePlayer)
	if thePlayer == getLocalPlayer() then
		theVehicle = source
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), updateCar)

function resetAlarm(vehicle)
	setElementData(vehicle, "alarm", nil, false)
end

function doCarAlarm(vehicle)
	if isElement(vehicle) then
		if (isVehicleLocked(vehicle) == false) then
			setElementData(vehicle, "alarm", nil, false)
			if (isTimer(alarmtable[1][vehicle])) then
				killTimer(alarmtable[1][vehicle])
			end
			if (isTimer(alarmtable[2][vehicle])) then
				killTimer(alarmtable[2][vehicle])
			end
			alarmtable[2][vehicle] = nil
			alarmtable[1][vehicle] = nil
			return
		end
		local x, y, z = getElementPosition(vehicle)
		local vDim = getElementDimension(vehicle)
		local vInt = getElementInterior(vehicle)
		local px, py, pz = getElementPosition(localPlayer)
		local pDim = getElementDimension(localPlayer)
		local pInt = getElementDimension(localPlayer)
		
		if pDim == vDim and pInt == vInt and getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 90 then
		if exports['vrp_global']:hasItem(vehicle, 130) == true then
			local sound = playSound3D("components/sounds/horn.wav", x, y, z)
			setElementDimension( sound, vDim )
			setElementInterior( sound, vInt )
			
			if getVehicleOverrideLights( vehicle ) ~= 2 then	-- if the current state isn't 'force on'
				setVehicleOverrideLights( vehicle, 2 )			-- force the lights on
			else
				setVehicleOverrideLights( vehicle, 1 )			-- otherwise, force the lights off
			end
		end
		end
	end
end


local l_cigar = { }
local r_cigar = { }
local deagle = { }
local isLocalPlayerSmokingBool = false
function setSmoking(player, state, hand)
	setElementData(player,"smoking",state, false)
	if not (hand) or (hand == 0) then
		setElementData(player, "smoking:hand", 0, false)
	else
		setElementData(player, "smoking:hand", 1, false)
	end

	if (isElement(player)) then
		if (state) then
			playerExitsVehicle(player)
		else
			playerEntersVehicle(player)
		end
	end
end

function playerExitsVehicle(player)
	if (getElementData(player, "smoking")) then
		playerEntersVehicle(player)
		if (getElementData(player, "smoking:hand") == 1) then
			r_cigar[player] = createCigarModel(player, 3027)
		else
			l_cigar[player] = createCigarModel(player, 3027)
		end
	end
end

function playerEntersVehicle(player)
	if (l_cigar[player]) then
		if (isElement( l_cigar[player] )) then
			destroyElement( l_cigar[player] )
		end
		l_cigar[player] = nil
	end
	if (r_cigar[player]) then
		if (isElement( r_cigar[player] )) then
			destroyElement( r_cigar[player] )
		end
		r_cigar[player] = nil
	end
end

function removeSigOnExit()
	playerExitsVehicle(source)
end
addEventHandler("onPlayerQuit", getRootElement(), removeSigOnExit)

function syncCigarette(state, hand)
	if (isElement(source)) then
		if (state) then
			setSmoking(source, true, hand)
		else
			setSmoking(source, false, hand)
		end
	end
end
addEvent( "realism:smokingsync", true )
addEventHandler( "realism:smokingsync", getRootElement(), syncCigarette, righthand )

addEventHandler( "onClientResourceStart", getResourceRootElement(),
	function ( startedRes )
		triggerServerEvent("realism:smoking.request", getLocalPlayer())
	end
);

function createCigarModel(player, modelid)
	if (l_cigar[player] ~= nil) then
		local currobject = l_cigar[player]
		if (isElement(currobject)) then
			destroyElement(currobject)
			l_cigar[player] = nil
		end
	end
	
	local object = createObject(modelid, 0,0,0)

	setElementCollisionsEnabled(object, false)
	return object
end

function updateCig()
	isLocalPlayerSmokingBool = false
	-- left hand
	for thePlayer, theObject in pairs(l_cigar) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerSmokingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 36)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 170
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360
		    exports.vrp_bone_attach:attachElementToBone(theObject,thePlayer,11,0.03,0.02,0.13,0,180,0)
		end
	end

	-- right hand
	for thePlayer, theObject in pairs(r_cigar) do
		if (isElement(thePlayer)) then
			if (thePlayer == getLocalPlayer()) then
				isLocalPlayerSmokingBool = true
			end
			local bx, by, bz = getPedBonePosition(thePlayer, 26)
			local x, y, z = getElementPosition(thePlayer)
			local r = getPedRotation(thePlayer)
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			local r = r + 100
			if (r > 360) then
				r = r - 360
			end
			
			local ratio = r/360

			exports.vrp_bone_attach:attachElementToBone(theObject,thePlayer,12,0,0.02,0.13,0,180,0)
		
			--moveObject ( theObject, 1, bx, by, bz )
			--setElementPosition(theObject, bx + 0.01, by + 0.09, bz + 0.06)
			--setElementRotation(theObject, 180, 360, r - 40)
			--setElementDimension(theObject, dim)
			--setElementInterior(theObject, int)
		end
	end
end
addEventHandler("onClientPreRender", getRootElement(), updateCig)

function isLocalPlayerSmoking()
	return isLocalPlayerSmokingBool
end

local heli = nil

function updateRotor()
	if isElement(heli) then
		if not getVehicleEngineState( heli ) and getHelicopterRotorSpeed( heli ) > 0 then
			local new = getHelicopterRotorSpeed( heli ) - 0.0012
			setHelicopterRotorSpeed( heli, math.max( 0, new ) )
		end
	else
		disableRotorUpdate()
	end
end

function disableRotorUpdate()
	if heli then
		heli = nil
		removeEventHandler( "onClientPlayerVehicleExit", getLocalPlayer(), disableRotorUpdate )
		removeEventHandler( "onClientPreRender", getRootElement(), updateRotor ) -- Pre
	end
end

function enableRotorUpdate( theVehicle )
	if getVehicleType( theVehicle ) == "Helicopter" then
		heli = theVehicle
		
		addEventHandler( "onClientPlayerVehicleExit", getLocalPlayer(), disableRotorUpdate )
		addEventHandler( "onClientPreRender", getRootElement(), updateRotor ) -- Pre
	end
end
addEventHandler( "onClientPlayerVehicleEnter", getLocalPlayer(), enableRotorUpdate )

local noReloadGuns = { [25]=true, [33]=true, [34]=true, [35]=true, [36]=true, [37]=true }
function isGun(id) return getSlotFromWeapon(id) >= 2 and getSlotFromWeapon(id) <= 7 end

savedAmmo = { }
local handled = true

function weaponAmmo(prevSlot, currSlot)
	cleanupUI()
	triggerEvent("checkReload", source)
end
addEventHandler("onClientPlayerWeaponSwitch", getLocalPlayer(), weaponAmmo)

function disableAutoReload(weapon, ammo, ammoInClip)
	if (ammoInClip==1)  and not getElementData(getLocalPlayer(), "deagle:reload") and not getElementData(getLocalPlayer(), "scoreboard:reload") then
		triggerEvent("i:s:w:r", getLocalPlayer())
		triggerEvent("checkReload", source)
	elseif (ammoInClip==0) then
		-- panic?
		--outputChatBox("We never ever should get this, comprende?")
	else
		cleanupUI()
	end
end
addEventHandler("onClientPlayerWeaponFire", getLocalPlayer(), disableAutoReload)

local newfont = dxCreateFont ( ":vrp_fonts/files/Roboto.ttf" , 12)

function drawText()
	local scrWidth, scrHeight = guiGetScreenSize()
	dxDrawText("Klavyeden 'R' tuşuna basarak mermini yenileyebilirsin.", 0, 0, scrWidth, scrHeight, tocolor(255, 255, 255, 170), 0.8, newfont, "center", "bottom")
end

function checkReloadStatus ()
	local weaponID = getPedWeapon(getLocalPlayer())
	if  getPedAmmoInClip (getLocalPlayer()) == 1 and isGun(weaponID) then -- getElementData(source, "r:cf:"..tostring(weaponID)) or 
		if not handled then
			handled = true
		end
		--triggerServerEvent("addFakeBullet", getLocalPlayer(), weaponID, getPedTotalAmmo(getLocalPlayer()))
		--toggleControl ( "fire", false )
	else
		cleanupUI(false)
	end
end
addEvent("checkReload", true)
addEventHandler("checkReload", getRootElement(), checkReloadStatus)
setTimer(checkReloadStatus, 500, 0)

function cleanupUI(bplaySound)
	if (bplaySound) then
		playSound("components/sounds/reload.wav")
		setTimer(playSound, 400, 1, "components/sounds/reload.wav")
	end
	removeEventHandler("onClientRender", getRootElement(), drawText)
	handled = false
end
addEvent("cleanupUI", true)
addEventHandler("cleanupUI", getRootElement(), cleanupUI)

-- bekiroj
function playSoundHandbrake(state)
	if state == "off" then
		local sound = playSound(":vrp_resources/hb_off.mp3")
		if sound then
			setSoundVolume(sound , 1)
		end
	else
		local sound = playSound(":vrp_resources/hb_on.mp3")
		if sound then
			setSoundVolume(sound , 0.3)
		end
	end
end
addEvent( "playSoundHandbrake", true )
addEventHandler( "playSoundHandbrake", root,  playSoundHandbrake)

local function checkVelocity(veh)
	local x, y, z = getElementVelocity(veh)
	return math.abs(x) < 0.05 and math.abs(y) < 0.05 and math.abs(z) < 0.05
end

-- exported
-- commandName is optional
function doHandbrake(commandName)
	if isPedInVehicle ( localPlayer ) then
		local playerVehicle = getPedOccupiedVehicle ( localPlayer )
		if (getVehicleOccupant(playerVehicle, 0) == localPlayer) then
			-- vehicle doesn't move and its in a custom interior; custom (officially mapped) interiors would otherwise suffer from no-handbrake and vehicles falling through
			local override = getElementDimension(playerVehicle) > 0 and checkVelocity(playerVehicle)

			triggerServerEvent("vehicle:handbrake", playerVehicle, override, commandName)
		end
	end
end
addCommandHandler('kickstand', doHandbrake)
addCommandHandler('handbrake', doHandbrake)
addCommandHandler('anchor', doHandbrake)

--Cancel everything else but handbrake when player hit G. /bekiroj
function playerPressedKey(button, press)
	if button == "g" and (press) then -- Only output when they press it down
		doHandbrake()
		cancelEvent()
	end
end

function resourceStartBindG()
	bindKey("g", "down", playerPressedKey)
end
addEventHandler("onClientResourceStart", resourceRoot, resourceStartBindG)

addEventHandler('onClientVehicleStartExit', root,
	function(player)
		if player == localPlayer and not isVehicleLocked(source) and getPedControlState('handbrake') then
			setPedControlState('handbrake', false)
		end
	end)

local lawVehicles = { [427]=true, [528]=true, [523]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true, [503]=true, [502]=true } -- 503 and le 502 are le high persuit buffalo's
local enabled = false

local counter = 0
local radarTimer = nil

local function policeRadar( )
	if enabled then
		local x, y, z = getElementPosition( getLocalPlayer( ) )
		local dimension = getElementDimension( getLocalPlayer( ) )
		
		local maxdist = 200
		
		for _, theVehicle in ipairs( getElementsByType( "vehicle" ) ) do
			if isElementStreamedIn( theVehicle ) and getElementDimension( theVehicle ) == dimension then
				if lawVehicles[ getElementModel( theVehicle ) ] then
					local dist = getDistanceBetweenPoints3D( x, y, z, getElementPosition( theVehicle ) )
					if dist < maxdist then
						maxdist = dist
					end
				end
			end
		end
		
		if maxdist < 200 then
			if maxdist < 50 or ( maxdist < 100 and ( counter == 0 or counter == 2 ) ) or counter == 0 then
				playSound( "components/sounds/policebeep.mp3" )
			end
		end
		counter = ( counter + 1 ) % 4
	end
end

addEventHandler( "onClientPlayerVehicleEnter", getLocalPlayer( ),
	function( )
		enabled = false
	end
)

addEventHandler( "onClientPlayerVehicleExit", getLocalPlayer( ),
	function( )
		enabled = false
	end
)

addEventHandler( "onClientResourceStart", getResourceRootElement(), 
	function( )
		radarTimer = setTimer( policeRadar, 500, 0 )
	end
)

addEvent( "enablePoliceRadar", true )
addEventHandler( "enablePoliceRadar", getLocalPlayer( ),
	function( )
		enabled = true
	end
)

blackMales = {[0] = true, [7] = true, [14] = true, [15] = true, [16] = true, [17] = true, [18] = true, [20] = true, [21] = true, [22] = true, [24] = true, [25] = true, [28] = true, [35] = true, [36] = true, [50] = true, [51] = true, [66] = true, [67] = true, [78] = true, [79] = true, [80] = true, [83] = true, [84] = true, [102] = true, [103] = true, [104] = true, [105] = true, [106] = true, [107] = true, [134] = true, [136] = true, [142] = true, [143] = true, [144] = true, [156] = true, [163] = true, [166] = true, [168] = true, [176] = true, [180] = true, [182] = true, [183] = true, [185] = true, [220] = true, [221] = true, [222] = true, [249] = true, [253] = true, [260] = true, [262] = true }
whiteMales = {[23] = true, [26] = true, [27] = true, [29] = true, [30] = true, [32] = true, [33] = true, [34] = true, [35] = true, [36] = true, [37] = true, [38] = true, [43] = true, [44] = true, [45] = true, [46] = true, [47] = true, [48] = true, [50] = true, [51] = true, [52] = true, [53] = true, [58] = true, [59] = true, [60] = true, [61] = true, [62] = true, [68] = true, [70] = true, [72] = true, [73] = true, [78] = true, [81] = true, [82] = true, [94] = true, [95] = true, [96] = true, [97] = true, [98] = true, [99] = true, [100] = true, [101] = true, [108] = true, [109] = true, [110] = true, [111] = true, [112] = true, [113] = true, [114] = true, [115] = true, [116] = true, [120] = true, [121] = true, [122] = true, [124] = true, [127] = true, [128] = true, [132] = true, [133] = true, [135] = true, [137] = true, [146] = true, [147] = true, [153] = true, [154] = true, [155] = true, [158] = true, [159] = true, [160] = true, [161] = true, [162] = true, [164] = true, [165] = true, [170] = true, [171] = true, [173] = true, [174] = true, [175] = true, [177] = true, [179] = true, [181] = true, [184] = true, [186] = true, [187] = true, [188] = true, [189] = true, [200] = true, [202] = true, [204] = true, [206] = true, [209] = true, [212] = true, [213] = true, [217] = true, [223] = true, [230] = true, [234] = true, [235] = true, [236] = true, [240] = true, [241] = true, [242] = true, [247] = true, [248] = true, [250] = true, [252] = true, [254] = true, [255] = true, [258] = true, [259] = true, [261] = true, [264] = true, [272] = true }
asianMales = {[49] = true, [57] = true, [58] = true, [59] = true, [60] = true, [117] = true, [118] = true, [120] = true, [121] = true, [122] = true, [123] = true, [170] = true, [186] = true, [187] = true, [203] = true, [210] = true, [227] = true, [228] = true, [229] = true, [294] = true}
blackFemales = {[9] = true, [10] = true, [11] = true, [12] = true, [13] = true, [40] = true, [41] = true, [63] = true, [64] = true, [69] = true, [76] = true, [91] = true, [139] = true, [148] = true, [190] = true, [195] = true, [207] = true, [215] = true, [218] = true, [219] = true, [238] = true, [243] = true, [244] = true, [245] = true, [256] = true, [304] = true }
whiteFemales = {[12] = true, [31] = true, [38] = true, [39] = true, [40] = true, [41] = true, [53] = true, [54] = true, [55] = true, [56] = true, [64] = true, [75] = true, [77] = true, [85] = true, [86] = true, [87] = true, [88] = true, [89] = true, [90] = true, [91] = true, [92] = true, [93] = true, [129] = true, [130] = true, [131] = true, [138] = true, [140] = true, [145] = true, [150] = true, [151] = true, [152] = true, [157] = true, [172] = true, [178] = true, [192] = true, [193] = true, [194] = true, [196] = true, [197] = true, [198] = true, [199] = true, [201] = true, [205] = true, [211] = true, [214] = true, [216] = true, [224] = true, [225] = true, [226] = true, [231] = true, [232] = true, [233] = true, [237] = true, [243] = true, [246] = true, [251] = true, [257] = true, [263] = true, [298] = true }
asianFemales = {[38] = true, [53] = true, [54] = true, [55] = true, [56] = true, [88] = true, [141] = true, [169] = true, [178] = true, [224] = true, [225] = true, [226] = true, [263] = true}

local localPlayer = getLocalPlayer()

function doVision()

	local tV = getPedOccupiedVehicle(getLocalPlayer()) 
	if not (tV) then
		removeEventHandler("onClientRender", getRootElement(), doVision)
		return
	end
	local px, py, pz = getElementPosition(localPlayer)
	-- vehicles
	for key, value in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(value) and (isElementOnScreen(value)) and (tV~=value) then
			local x, y, z = getElementPosition(value)
			
			if (isLineOfSightClear(px, py, pz, x, y, z, true, false, false, true, false, false, true, tV)) then
				local tx, ty = getScreenFromWorldPosition(x, y, z, 5000, false)
				
				if (tx) then
					dxDrawLine(tx, ty, tx+150, ty+150, tocolor(255, 255, 255, 200), 2, false) 
					local realName = exports.vrp_global:getVehicleName(value)
					local mtaName = getVehicleName(value)
					local plate = getElementData(value, "show_plate") == 1 and ("Plate: "..getElementData(value,"plate").." | ") or ""
					local line2 = plate.."(("..mtaName.."))"
					local scale = 0.8
					local size = dxGetTextWidth(realName, scale, "bankgothic") + 170
					local size2 = dxGetTextWidth(line2, scale, "bankgothic") + 170
					if size2 > size then size = size2 end
					dxDrawLine(tx+150, ty+150, tx+size, ty+150,  tocolor(255, 255, 255, 200), 2, false)
					dxDrawText(realName, tx+150, ty+10, tx+size, ty+260, tocolor(255, 255, 255, 200), scale, "bankgothic", "center", "center")
					dxDrawText(line2, tx+150, ty+70, tx+size, ty+260, tocolor(255, 255, 255, 200), scale, "bankgothic", "center", "center")
				end
			end
		end
	end
	
	-- players
	for key, value in ipairs(getElementsByType("player")) do
		if isElementStreamedIn(value) and (isElementOnScreen(value)) and (localPlayer~=value) and tV ~= getPedOccupiedVehicle(value) then
			local x, y, z = getPedBonePosition(value, 6)
			local skin = getElementModel(value)
			local recon = getElementData(value, "reconx") or getElementAlpha(value) ~= 255
			if (isLineOfSightClear(px, py, pz, x, y, z, true, false, false, true, false, false, true, tV)) then
				local text

				-- needs fixing
				if (blackMales[skin]) then text = "Black Male"
				elseif (whiteMales[skin]) then text = "White Male"
				elseif (asianMales[skin]) then text = "Asian Male"
				elseif (blackFemales[skin]) then text = "Black Female"
				elseif (whiteFemales[skin]) then text = "White Female"
				elseif (asianFemales[skin]) then text = "Asian Female"
				else text = "White Male"
				end
				
				local tx, ty = getScreenFromWorldPosition(x, y, z+0.2, 5000, false)
				
				if (tx) and not (recon) then
					dxDrawLine(tx, ty, tx+150, ty-150, tocolor(255, 255, 255, 200), 2, false)
					local size = dxGetTextWidth(text, 1, "bankgothic") -- + 170
					dxDrawLine(tx+150, ty-150, tx+size, ty-150,  tocolor(255, 255, 255, 200), 2, false)
					dxDrawText(text, tx+150, ty-180, tx+size, ty-160, tocolor(255, 255, 255, 200), 1, "bankgothic", "center", "bottom")
				end
			end
		end
	end
end


function applyVision(thePlayer, seat, setVehicle)
	if setVehicle then
		source = setVehicle
	end
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==497 or getElementModel(source)==487) then
			local playerFaction = getElementData(source, "faction")
			local vehID = getElementData(source, "dbid")
			if (playerFaction == 1 or playerFaction == 2 or playerFaction == 45 or playerFaction == 59 or vehID == 8772) then	
				if (seat == 0 or seat == 1) then
					addEventHandler("onClientRender", getRootElement(), doVision)
				end
			end
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), applyVision)

function removeVision(thePlayer, seat)
	if (thePlayer==localPlayer) then
		if (getElementModel(source)==497 or getElementModel(source)==487) then
			local playerFaction = getElementData(source, "faction")
			if (playerFaction == 1 or playerFaction == 2 or playerFaction == 45) then	
				if (seat == 0 or seat == 1) then
					removeEventHandler("onClientRender", getRootElement(), doVision)
				end
			end
		end
	end
end
addEventHandler("onClientVehicleExit", getRootElement(), removeVision)

addEventHandler( "onClientResourceStart", getResourceRootElement( ),
    function ( startedRes )
		local setVehicle = getPedOccupiedVehicle( getLocalPlayer() )
		if setVehicle then
        applyVision(getLocalPlayer(), 0, setVehicle)
		end
    end
);

local localPlayer = getLocalPlayer()
local sounds = { }

function createSiren(thePlayer, seat)
	if (getVehicleSirensOn(source) and (seat==0)) then
		local x, y, z = getElementPosition(source)
		local px, py, pz = getElementPosition(localPlayer)
		
		if (getDistanceBetweenPoints3D(x, y, z, px, py, pz)<25) then
			local sound = playSound3D("components/sounds/siren.wav", x, y, z, true)
			setSoundVolume(sound, 0.6)
			
			for i = 1, 20 do
				if (sounds[i]==nil) then
					sounds[i] = { }
					sounds[i][1] = source
					sounds[i][2] = sound
					break
				end
			end
		end
	end
end
--addEventHandler("onClientVehicleExit", getRootElement(), createSiren)

function destroySiren(thePlayer, seat)
	if (seat==0) then
		local key = 0
		for i = 1, 20 do
			if (sounds[i]~=nil) then
				if (sounds[i][1]==source) then
					key = i
					break
				end
			else
				break
			end
		end
		
		if (key>0) then
			local sound = sounds[key][2]
			stopSound(sound)
			table.remove(sounds, key)
		end
	end
end
--addEventHandler("onClientVehicleEnter", getRootElement(), destroySiren)

info = { 
	["wheels/wheel_gn1.dff"] = 1082,
	["wheels/wheel_gn2.dff"] = 1085,
	["wheels/wheel_gn3.dff"] = 1096,
	["wheels/wheel_gn4.dff"] = 1097,
	["wheels/wheel_gn5.dff"] = 1098,
	["wheels/wheel_lr1.dff"] = 1077,
	["wheels/wheel_lr2.dff"] = 1083,
	["wheels/wheel_lr3.dff"] = 1078,
	["wheels/wheel_lr4.dff"] = 1076,
	["wheels/wheel_lr5.dff"] = 1084,
	["wheels/wheel_or1.dff"] = 1025,
	["wheels/wheel_sr1.dff"] = 1079,
	["wheels/wheel_sr2.dff"] = 1075,
	["wheels/wheel_sr3.dff"] = 1074,
	["wheels/wheel_sr4.dff"] = 1081,
	["wheels/wheel_sr5.dff"] = 1080,
	["wheels/wheel_sr6.dff"] = 1073,
}

addEvent("vehicle_rims", true)
addEventHandler('vehicle_rims', root,
    function(value)
      if getElementData(getLocalPlayer(), "vehicle_rims") == "0" then 
            if value == "0" then
                  for k,v in pairs(info) do
                        engineRestoreModel(v)
                  end
            end
            return false
      end
      for k,v in pairs(info) do
            downloadFile(k)
      end
    end
)

addEventHandler("onClientFileDownloadComplete", resourceRoot,
 function(file, success)
      if success then
            dff = engineLoadDFF ( file, info[file])
            engineReplaceModel ( dff, info[file])
      end
 end )

local seatbeltalert = { [1] = {}, [2] = {}, [3] = {} }

function resStart()
	for key, value in ipairs(getElementsByType("vehicle")) do
		setElementData(value, "seatbeltwarning", nil)
		triggerServerEvent("onVehicleSeatbeltWarning", value)
	end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resStart)

function seatBeltWarning()
	local seatbeltwarning = getElementData(source, "seatbeltwarning")
	if not seatbeltwarning then
		seatbeltalert[1][source] = setTimer(doCarSeatBelt, 1000, 20, source)
		setElementData(source, "seatbeltwarning", 1)
		seatbeltalert[2][source] = setTimer(resetSeatBelt, 21000, 1, source)
	end
end
addEvent("startSeatBeltWarning", true)
addEventHandler("startSeatBeltWarning", getRootElement(), seatBeltWarning)

function resetSeatBelt(vehicle)
	if isElement(vehicle) then
		setElementData(vehicle, "seatbeltwarning", nil)
	end
end

function destroyImage(vehicle)
	while isElement(image) do
		destroyElement(image)
	end
	if isTimer(seatbeltalert[3][vehicle]) then
		killTimer(seatbeltalert[3][vehicle])
	end
end

function doCarSeatBelt(vehicle)	
	if isElement(vehicle) then
	local driver = getVehicleOccupant(vehicle, 0)
	local passenger1 = getVehicleOccupant(vehicle, 1)
	local passenger2 = getVehicleOccupant(vehicle, 2)
	local passenger3 = getVehicleOccupant(vehicle, 3)
	local windowState = getElementData(vehicle, "vehicle:windowstat") or 1

		if driver and passenger1 then
			if (getElementData(driver, "seatbelt") and getElementData(passenger1, "seatbelt")) then
				setElementData(vehicle, "seatbeltwarning", nil)
				if (isTimer(seatbeltalert[1][vehicle])) then
					killTimer(seatbeltalert[1][vehicle])
				end
				if (isTimer(seatbeltalert[2][vehicle])) then
					killTimer(seatbeltalert[2][vehicle])
				end
				if isTimer(seatbeltalert[3][vehicle]) then
					killTimer(seatbeltalert[3][vehicle])
				end
				seatbeltalert[3][vehicle] = nil
				seatbeltalert[2][vehicle] = nil
				seatbeltalert[1][vehicle] = nil
				return
			end
		elseif driver and not passenger1 then
			if (getElementData(driver, "seatbelt")) then
				setElementData(vehicle, "seatbeltwarning", nil)
				if (isTimer(seatbeltalert[1][vehicle])) then
					killTimer(seatbeltalert[1][vehicle])
				end
				if (isTimer(seatbeltalert[2][vehicle])) then
					killTimer(seatbeltalert[2][vehicle])
				end
				if isTimer(seatbeltalert[3][vehicle]) then
					killTimer(seatbeltalert[3][vehicle])
				end
				seatbeltalert[3][vehicle] = nil
				seatbeltalert[2][vehicle] = nil
				seatbeltalert[1][vehicle] = nil
				return
			end
		end
		
		if getVehicleEngineState ( vehicle ) == false then
			setElementData(vehicle, "seatbeltwarning", nil)
			if (isTimer(seatbeltalert[1][vehicle])) then
				killTimer(seatbeltalert[1][vehicle])
			end
			if (isTimer(seatbeltalert[2][vehicle])) then
				killTimer(seatbeltalert[2][vehicle])
			end
			if isTimer(seatbeltalert[3][vehicle]) then
				killTimer(seatbeltalert[3][vehicle])
			end
			seatbeltalert[3][vehicle] = nil
			seatbeltalert[2][vehicle] = nil
			seatbeltalert[1][vehicle] = nil
			return
		end
		
		local x, y, z = getElementPosition(vehicle)
		local vDim = getElementDimension(vehicle)
		local vInt = getElementInterior(vehicle)
		local px, py, pz = getElementPosition(localPlayer)
		local pDim = getElementDimension(localPlayer)
		local pInt = getElementDimension(localPlayer)
		
		if driver == localPlayer or passenger1 == localPlayer then
			if not isElement(image) then
				local x, y = guiGetScreenSize()
				--image = guiCreateStaticImage(x - 180, y - 140.5, 64, 64, "kemer.png", false)
				seatbeltalert[3][vehicle] = setTimer(destroyImage, 500, 1, vehicle)
			end
		end

		if pDim == vDim and pInt == vInt and getDistanceBetweenPoints3D(x, y, z, px, py, pz) <= 30 then
			local sound = playSound3D("seatbelt/seatbeltwarning.wav", x, y, z)
			if (windowState == 1) and not (localPlayer == driver or localPlayer == passenger1 or localPlayer == passenger2 or localPlayer == passenger3) then
				setSoundVolume(sound, 0.1)
			end
			for i = 2, 5 do
				if doesVehicleHaveDoorOpen(vehicle) then
					setSoundVolume(sound, 0.8)
				end
			end
			setElementDimension( sound, vDim )
			setElementInterior( sound, vInt )
		end
	end
end


function doesVehicleHaveDoorOpen(vehicle)
	local isDoorOpen = false
	for i=0,5 do
		local doorState = getVehicleDoorState(vehicle, i)
		if doorState == 1 or doorState == 3 or doorState == 4 then
			isDoorOpen = true
		end
	end
 
	return isDoorOpen
end

addEventHandler("onClientVehicleExit", getRootElement(), function(thePlayer)
	if isElement(image) then
		destroyElement(image)
	end
	if isTimer(seatbeltalert[3][source]) then
		killTimer(seatbeltalert[3][source])
	end
	if isTimer(seatbeltalert[2][source]) then
		killTimer(seatbeltalert[2][source])
	end
	if isTimer(seatbeltalert[1][source]) then
		killTimer(seatbeltalert[1][source])
	end
end)

local screenSize = Vector2( guiGetScreenSize() )

function getScreenRotationFromWorldPosition( targetX, targetY, targetZ )
    -- Get camera position and rotation
    local camX, camY, _, lookAtX, lookAtY = getCameraMatrix()
    local camRotZ = math.atan2 ( ( lookAtX - camX ), ( lookAtY - camY ) )

    -- Calc direction to
    local dirX = targetX - camX
    local dirY = targetY - camY

    -- Calc rotation to
    local dirRotZ = math.atan2(dirX,dirY)

    -- Calc relative rotation to
    local relRotZ = dirRotZ - camRotZ

    -- Return rotation in degrees
    return math.deg(relRotZ)
end

setTimer(
         function()
			for key, value in ipairs(getElementsByType("player"), root, true) do
				local rot = getPedCameraRotation(value)
				local x, y, z = getElementPosition(value)
				local sx, sy = getScreenFromWorldPosition ( x, y, z )
				local sxx, syy = guiGetScreenSize()
				local vx = x + math.sin(math.rad(rot)) * 10
				local vy = y + math.cos(math.rad(rot)) * 10
				local _, _, vz = getWorldFromScreenPosition ( sxx, syy, 1 )
				if getElementData(value, "kafa") == 1 then
				
				else
				setPedAimTarget(value, vx, vy, vz )
				setPedLookAt(value, vx, vy, vz)
			end
			end
         end
, 2500, 0)

function active ()
	if getElementData(localPlayer, "kafa") == 1 then
	 setElementData(localPlayer, "kafa", 0)
	 outputChatBox("[!]#ffffff Kafa çevirme açık.", 0, 255, 0, true)
	else
	setElementData(localPlayer, "kafa", 1)
	outputChatBox("[!]#ffffff Kafa çevirme kapalı.", 255, 0, 0, true)
	end
end
addCommandHandler("kafa", active)
addCommandHandler("head", active)