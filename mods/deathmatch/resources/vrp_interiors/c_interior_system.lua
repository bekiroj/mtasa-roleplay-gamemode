gInteriorName, gOwnerName, gBuyMessage, gBizMessage = nil

timer = nil

intNameFont = "default-bold" --AngryBird
BizNoteFont = guiCreateFont( ":vrp_hud/fonts/Roboto.ttf", 21 ) or "default-bold"

-- Message on enter
function showIntName(name, ownerName, inttype, cost, ID, bizMsg)
	bizMessage = bizMsg
	if (isElement(gInteriorName) and guiGetVisible(gInteriorName)) then
		if timer and isTimer(timer) then
			killTimer(timer)
			timer = nil 
		end
		
		destroyElement(gInteriorName)
		gInteriorName = nil
		
		if isElement(gOwnerName) then
			destroyElement(gOwnerName)
			gOwnerName = nil
		end
			
		if (gBuyMessage) then
			destroyElement(gBuyMessage)
			gBuyMessage = nil
		end
		
		if (gBizMessage) then
			destroyElement(gBizMessage)
			gBizMessage = nil
		end
		
	end
	if name == "None" then
		return
	elseif name then
		if (inttype==3) then -- Interior name and Owner for rented
			gInteriorName = guiCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			guiSetFont(gInteriorName,intNameFont)
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
			
			if (exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "duty_admin") == 1) or exports.vrp_global:hasItem(getLocalPlayer(), 4, ID) then
				gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Rented by: " .. tostring(ownerName), true)
				guiSetFont(gOwnerName, "default")
				guiLabelSetHorizontalAlign(gOwnerName, "center", true)
				guiSetAlpha(gOwnerName, 0.0)
			end
		
		else -- Interior name and Owner for the rest
			--outputDebugString((name or "nil").." - "..(tostring(bizMsg) or "nil"))
			if bizMessage then 
				gInteriorName = guiCreateLabel(0.0, 0.80, 1.0, 0.3, tostring(name), true)
				gBizMessage = guiCreateLabel(0.0, 0.864, 1.0, 0.3, tostring(bizMessage), true)
				guiLabelSetHorizontalAlign(gBizMessage, "center", true)
				guiSetAlpha(gBizMessage, 0.0)
				guiSetFont(gBizMessage, BizNoteFont)
			else
				gInteriorName = guiCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			end
			guiSetFont(gInteriorName, intNameFont)
			guiLabelSetHorizontalAlign(gInteriorName, "center", true)
			guiSetAlpha(gInteriorName, 0.0)
			if (exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "duty_admin") == 1) or exports.vrp_global:hasItem(getLocalPlayer(), 4, ID) or exports.vrp_global:hasItem(getLocalPlayer(), 5, ID) then
				gOwnerName = guiCreateLabel(0.0, 0.90, 1.0, 0.3, "Mülk Sahibi: " .. tostring(ownerName), true)
				guiSetFont(gOwnerName, "default")
				guiLabelSetHorizontalAlign(gOwnerName, "center", true)
				guiSetAlpha(gOwnerName, 0.0)
			end
		end
		if (ownerName=="None") and (inttype==3) then -- Unowned type 3 (rentable)
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Kiralamak için E tuşuna basın "..exports.vrp_pool:getServerMoneyType(localPlayer) .. tostring(exports.vrp_global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		elseif (ownerName=="None") and (inttype<2) then -- Unowned any other type
			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, "Satın almak için E tuşuna basın "..exports.vrp_pool:getServerMoneyType(localPlayer) .. tostring(exports.vrp_global:formatMoney(cost)) .. ".", true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			guiSetAlpha(gBuyMessage, 0.0)
		else
			local msg = "İçeri girmek için E tuşuna basın"

			gBuyMessage = guiCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			guiSetFont(gBuyMessage, "default")
			guiLabelSetHorizontalAlign(gBuyMessage, "center", true)
			--guiSetAlpha(gBuyMessage, 0.0)
		end
		
		timer = setTimer(fadeMessage, 50, 20, true)
	end
end
addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", getRootElement(), showIntName)

function fadeMessage(fadein)
	local alpha = guiGetAlpha(gInteriorName)
	
	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		guiSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			guiSetAlpha(gOwnerName, newalpha)
		end
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if gBizMessage then
			guiSetAlpha(gBizMessage, newalpha)
		end
		
		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 15000, 1)
		end
	elseif (alpha) then
		local newalpha = alpha - 0.05
		guiSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			guiSetAlpha(gOwnerName, newalpha)
		end
		
		if (gBuyMessage) then
			guiSetAlpha(gBuyMessage, newalpha)
		end
		
		if (gBizMessage) then
			guiSetAlpha(gBizMessage, newalpha)
		end
		
		if(newalpha<=0.0) then
			destroyElement(gInteriorName)
			gInteriorName = nil
			
			if isElement(gOwnerName) then
				destroyElement(gOwnerName)
				gOwnerName = nil
			end
			
			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end
			
			if (gBizMessage) then
				destroyElement(gBizMessage)
				gBizMessage = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)
		
		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	-- spawn the new ones
	for key, value in ipairs(interiors) do
		createBlipAtXY(interiors[key][1], interiors[key][2], interiors[key][3])
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", getRootElement(), createBlipsFromTable)

function createBlipAtXY(inttype, x, y)
	if inttype == 3 then inttype = 0 end
	createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", getRootElement(), createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= 'number' then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)
		
		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", getRootElement(), removeBlipAtXY)

------ OLD
--[[local wBizNote, wRightClick, ax, ay = nil
local house = nil
local houseID = nil
local sx, sy = guiGetScreenSize( )
function showHouseMenu( )
	guiSetInputEnabled(true)
	showCursor(true)
	ax = math.max( math.min( sx - 160, ax - 75 ), 10 )
	ay = math.max( math.min( sx - 210, ay - 100 ), 10 )
	wRightClick = guiCreateWindow(ax, ay, 150, 200, (getElementData(house, "name") or ("Interior ID #"..tostring( houseID ))), false)
	guiWindowSetSizable(wRightClick, false)
	
	bLock = guiCreateButton(0.05, 0.13, 0.9, 0.1, "Lock/Unlock", true, wRightClick)
	addEventHandler("onClientGUIClick", bLock, lockUnlockHouse, false)
	
	bKnock = guiCreateButton(0.05, 0.27, 0.9, 0.1, "Knock on Door", true, wRightClick)
	addEventHandler("onClientGUIClick", bKnock, knockHouse, false)
	
	if hasKey(houseID) then
		bBizNote = guiCreateButton(0.05, 0.41, 0.9, 0.1, "Edit Greeting Msg", true, wRightClick)
		addEventHandler("onClientGUIClick", bBizNote, function()
			local width, height = 506, 103
			local sx, sy = guiGetScreenSize()
			local posX = (sx/2)-(width/2)
			local posY = (sy/2)-(height/2)
			wBizNote = guiCreateWindow(posX,posY,width,height,"Edit Business Greeting Message - "..(getElementData(house, "name") or ("Interior ID #"..tostring( houseID ))),false)
			local eBizNote = guiCreateEdit(9,22,488,40,"",false,wBizNote)
			local bRemove = guiCreateButton(9,68,163,28,"Remove",false,wBizNote)
			local bSave = guiCreateButton(172,68,163,28,"Save",false,wBizNote)
			local bCancel = guiCreateButton(335,68,163,28,"Cancel",false,wBizNote)
			addEventHandler("onClientGUIClick", bRemove, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bSave, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID, guiGetText(eBizNote)) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bCancel, function()
				if wBizNote then
					destroyElement(wBizNote)
					wBizNote = nil
				end
			end, false)
			
		end, false)
		
		bCloseMenu = guiCreateButton(0.05, 0.55, 0.9, 0.1, "Close Menu", true, wRightClick)
	else
		bCloseMenu = guiCreateButton(0.05, 0.41, 0.9, 0.1, "Close Menu", true, wRightClick)
	end
	
	addEventHandler("onClientGUIClick", bCloseMenu, hideHouseMenu, false)
end]]

-- \\ Chaos
local house = nil
local houseID = nil
function showHouseMenu( absX, absY )
	rightclick = exports.vrp_rightclick
	
	rcMenu = rightclick:create(getElementData(house, "name") or ("Interior ID #"..tostring( houseID )))
	local row = { }
	
	row.lock = rightclick:addRow("Kilitle/Kilidi Aç")
	addEventHandler("onClientGUIClick", row.lock, lockUnlockHouse, false)
	
	row.knock = rightclick:addRow("Kapıyı Çal")
	addEventHandler("onClientGUIClick", row.knock, knockHouse, false)
	
	if hasKey(houseID) then
		row.note = rightclick:addRow("Bir Mesaj Bırak")
		addEventHandler("onClientGUIClick", row.note, function()
			guiSetInputEnabled(true)
			local width, height = 506, 103
			local sx, sy = guiGetScreenSize()
			local posX = (sx/2)-(width/2)
			local posY = (sy/2)-(height/2)
			wBizNote = guiCreateWindow(posX,posY,width,height,"Edit Business Greeting Message - "..(getElementData(house, "name") or ("Interior ID #"..tostring( houseID ))),false)
			local eBizNote = guiCreateEdit(9,22,488,40,"",false,wBizNote)
			local bRemove = guiCreateButton(9,68,163,28,"Remove",false,wBizNote)
			local bSave = guiCreateButton(172,68,163,28,"Save",false,wBizNote)
			local bCancel = guiCreateButton(335,68,163,28,"Cancel",false,wBizNote)
			addEventHandler("onClientGUIClick", bRemove, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bSave, function()
				if triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(), getLocalPlayer(), houseID, guiGetText(eBizNote)) then
					hideHouseMenu()
				end
			end, false)
			
			addEventHandler("onClientGUIClick", bCancel, function()
				if wBizNote then
					destroyElement(wBizNote)
					wBizNote = nil
				end
			end, false)
			
		end, false)
	end

	local interiorStatus = getElementData(house, "status")
	local interiorType = interiorStatus[INTERIOR_TYPE] or 2
	if interiorType>=0 and interiorType<3 then
		--row.mailbox = rightclick:addRow("Mailbox")
		--addEventHandler("onClientGUIClick", row.mailbox, function(button)
		--	if button=="left" and not getElementData(getLocalPlayer(), "exclusiveGUI") then
		--		triggerServerEvent( "openFreakinInventory", getLocalPlayer(), house, absX, absY )
		--	end
		--end, false)
	end

end

local lastKnocked = 0
function knockHouse()
	local tick = getTickCount( )
	if tick - lastKnocked > 5000 then
		triggerServerEvent("onKnocking", getLocalPlayer(), house)
		hideHouseMenu()
		lastKnocked = tick
	else
		outputChatBox("Tekrar çalmadan önce biraz bekle!.", 255, 0, 0)
	end
end

function lockUnlockHouse( )
	local tick = getTickCount( )
	if tick - lastKnocked > 2000 then
		local px, py, pz = getElementPosition(getLocalPlayer())
		local interiorEntrance = getElementData(house, "entrance")
		local interiorExit = getElementData(house, "exit")
		local x, y, z = getElementPosition(house)
		if getDistanceBetweenPoints3D(interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
		elseif getDistanceBetweenPoints3D(interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID )
		end
		hideHouseMenu()
	end
end

function hideHouseMenu( )
	--[[if wRightClick then
		destroyElement( wRightClick )
		wRightClick = nil
		showCursor( false )
	end]]
	if wBizNote then
		destroyElement(wBizNote)
		wBizNote = nil
	end
	house = nil
	houseID = nil
	guiSetInputEnabled(false)
	showCursor(false)
end

-- local function hasKey( key )
	-- return exports.vrp_global:hasItem(getLocalPlayer(), 4, key) or exports.vrp_global:hasItem(getLocalPlayer(), 5,key)
-- end

function hasKey( key )
	if exports.vrp_global:hasItem(getLocalPlayer(), 4, key) or exports.vrp_global:hasItem(getLocalPlayer(), 5,key) then
		return true, false
	else
		if getElementData(getLocalPlayer(), "duty_admin") == 1 then
			return true, true
		else
			return false, false
		end
	end
	return false, false
end

function clickHouse(button, state, absX, absY, wx, wy, wz, e)
	--outputDebugString(tostring(e))
	if (button == "right") and (state=="down") and not e then
		if getElementData(getLocalPlayer(), "exclusiveGUI") then
			return
		end
		
		local element, id = nil, nil
		local px, py, pz = getElementPosition(getLocalPlayer())
		local x, y, z = nil
		local interiorres = getResourceRootElement(getResourceFromName("vrp_interiors"))
		local elevatorres = getResourceRootElement(getResourceFromName("vrp_elevators"))

		for key, value in ipairs(getElementsByType("pickup")) do
			if isElementStreamedIn(value) then
				x, y, z = getElementPosition(value)
				local minx, miny, minz, maxx, maxy, maxz
				local offset = 4
				
				minx = x - offset
				miny = y - offset
				minz = z - offset
				
				maxx = x + offset
				maxy = y + offset
				maxz = z + offset
				
				if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
					local dbid = getElementData(getElementParent( value ), "dbid")
					if getElementType(getElementParent( value )) == "interior" then -- house found
						element = getElementParent( value )
						id = dbid
						break
					elseif  getElementType(getElementParent( value ) ) == "elevator" then
						-- it's an elevator
						if getElementData(value, "dim") and getElementData(value, "dim")  ~= 0 then
							element = getElementParent( value )
							id = getElementData(value, "dim")
							break
						elseif getElementData( getElementData( value, "other" ), "dim")  and getElementData( getElementData( value, "other" ), "dim")  ~= 0 then
							element = value
							id = getElementData( getElementData( value, "other" ), "dim")
							break
						end
					end
				end
			end
		end
		
		if element then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
				ax, ay = getScreenFromWorldPosition(x, y, z, 0, false)
				if ax then
					hideHouseMenu()
					house = element
					houseID = id
					showHouseMenu(absX, absY)
				end
			else
				--outputChatBox("You are too far away from this house.", 255, 0, 0)
			end
		else
			hideHouseMenu()
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickHouse, true)

addEvent("playerKnock", true)
addEventHandler("playerKnock", root,
	function(x, y, z)
		outputChatBox(" * Kapıdan gelen darbeler duyulabilir. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		local sound = playSound3D("knocking.mp3", x, y, z)
		setSoundMaxDistance(sound, 20)
		setElementDimension(sound, getElementDimension(localPlayer))
		setElementInterior(sound, getElementInterior(localPlayer))
	end
)

addEvent("doorUnlockSound", true)
addEventHandler("doorUnlockSound", root,
	function(x, y, z)
		local sound = playSound3D("doorUnlockSound.mp3", x, y, z)
		setSoundMaxDistance(sound, 20)
		setElementDimension(sound, getElementDimension(localPlayer))
		setElementInterior(sound, getElementInterior(localPlayer))
	end
)

addEvent("doorLockSound", true)
addEventHandler("doorLockSound", root,
	function(x, y, z)
		--outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		local sound = playSound3D("doorLockSound.mp3", x, y, z)
		setSoundMaxDistance(sound, 20)
		setElementDimension(sound, getElementDimension(localPlayer))
		setElementInterior(sound, getElementInterior(localPlayer))
	end
)

addEvent("doorGoThru", true)
addEventHandler("doorGoThru", root,
	function(x, y, z)
		--outputChatBox(" * Knocks can be heard coming from the door. *      ((" .. getPlayerName(source):gsub("_"," ") .. "))", 255, 51, 102)
		local sound = playSound3D("doorGoThru.mp3", x, y, z)
		setSoundMaxDistance(sound, 20)
		setElementDimension(sound, getElementDimension(localPlayer))
		setElementInterior(sound, getElementInterior(localPlayer))
		setSoundVolume(sound, 0.5)
	end
)

local cache = { }
function findProperty(thePlayer, dimension)
	local dbid = dimension or getElementDimension( thePlayer )
	if dbid > 0 then
		if cache[ dbid ] then
			return unpack( cache[ dbid ] )
		end
		-- find the entrance and exit
		local entrance, exit = nil, nil
		for key, value in pairs(getElementsByType( "pickup", getResourceRootElement() )) do
			if getElementData(value, "dbid") == dbid then
				entrance = value
				break
			end
		end
		
		if entrance then
			cache[ dbid ] = { dbid, entrance }
			return dbid, entrance
		end
	end
	cache[ dbid ] = { 0 }
	return 0
end

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

--
local inttimer = nil
--MAXIME NEW MELTHOD
addEvent( "setPlayerInsideInterior", true )
addEventHandler( "setPlayerInsideInterior", getRootElement( ),
	function( targetLocation, targetInterior, furniture)
		if not furniture then
			furniture = true
		end
		engineSetAsynchronousLoading ( false, true )
		setTimer(function()
			triggerServerEvent("onPlayerInteriorChange", getLocalPlayer(), 0, 0, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		end, (getElementData(localPlayer, "antifalling") == "1" and 8000 or 4000), 1)
		for i = 0, 4 do
    		setInteriorFurnitureEnabled(i, furniture and true or false)
		end
	end
)




addEvent( "setPlayerInsideInterior2", true )
addEventHandler( "setPlayerInsideInterior2", getRootElement( ),
	function( targetLocation, targetInterior, furniture)
		if inttimer then
			return
		end

		if targetLocation[INTERIOR_DIM] ~= 0 then
			setGravity(0)
		end
		if not furniture then
			furniture = true
		end
		for i = 0, 4 do
    		setInteriorFurnitureEnabled(i, furniture and true or false)
		end
		
		setElementFrozen(getLocalPlayer(), true)
		setElementPosition(getLocalPlayer(), targetLocation[INTERIOR_X], targetLocation[INTERIOR_Y], targetLocation[INTERIOR_Z], true)

		--setElementInterior(getLocalPlayer(), 3)
		--setElementDimension(getLocalPlayer(), 6)
		
		setCameraInterior(targetLocation[INTERIOR_INT])
		
		if targetLocation[INTERIOR_ANGLE] then
			setPedRotation(getLocalPlayer(), targetLocation[INTERIOR_ANGLE])
		end
		
		triggerServerEvent("onPlayerInteriorChange", getLocalPlayer(), 0, 0, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		inttimer = setTimer(onPlayerPutInInteriorSecond, 1000, 1, targetLocation[INTERIOR_DIM], targetLocation[INTERIOR_INT])
		engineSetAsynchronousLoading ( false, true )
		
		-- if tonumber(targetLocation[INTERIOR_DIM]) == 0 then
			-- updateLightStatus(1)
		-- else --shit
			-- outputDebugString(tostring(getElementData(targetInterior, "isLightOn")))
			-- updateLightStatus(getElementData(targetInterior, "isLightOn")) 
			-- outputChatBox("'/toglight' to switch on/off the lights in this interior")
		-- end
		
		if false and targetInterior then
			local adminnote = tostring(getElementData(targetInterior, "adminnote"))
			if string.sub(tostring(adminnote),1,8) ~= "userdata" and adminnote ~= "\n" and getElementData(getLocalPlayer(), "duty_admin") == 1 then
				outputChatBox("[INT MONITOR]: "..adminnote:gsub("\n", " ").."[..]", 255,0,0)
				outputChatBox("'/checkint "..getElementData(targetInterior, "dbid").." 'for details.",255,255,0)
			end
		end
	end
)

addCommandHandler("getcamint", function (cmd)
	local camInt = getCameraInterior()
	outputChatBox("camInt="..tostring(camInt))
end)
addCommandHandler("setcamint", function (cmd, arg)
	if arg then
		arg = tonumber(arg) or 0
		setCameraInterior(arg)
	else
		outputChatBox("specify interior world")
	end
end)

function onPlayerPutInInteriorSecond(dimension, interior)
	setCameraInterior(interior)
	
	local safeToSpawn = true
	if(getResourceFromName("vrp_object_system"))then
		safeToSpawn = exports['vrp_object_system']:isSafeToSpawn()
	end
	
	if (safeToSpawn) then
		inttimer = nil
		if isElement(getLocalPlayer()) then
			setTimer(onPlayerPutInInteriorThird, 1000, 1)
		end
	else
		setTimer(onPlayerPutInInteriorSecond, 1000, 1, dimension, interior)
	end
end

function onPlayerPutInInteriorThird()
	setGravity(0.008)
	setElementFrozen(getLocalPlayer(), false)
	engineSetAsynchronousLoading ( true, false )
end

function cPKnock()
	if (getElementDimension(getLocalPlayer()) > 20000) then
		triggerServerEvent("onVehicleKnocking", getLocalPlayer())
	else
		triggerServerEvent("onKnocking", getLocalPlayer(), 0)
	end
end
addCommandHandler("knock", cPKnock)

local starttime = false
local function updateIconAlpha( )
	local time = getTickCount( ) - starttime
	-- if time > 20000 then
		-- removeIcon( )
	-- else
		time = time % 1000
		local alpha = 0
		if time < 500 then
			alpha = time / 500
		else
			alpha = 1 - ( time - 500 ) / 500
		end
		
		guiSetAlpha(help_icon, alpha)
		guiSetAlpha(icon_label_shadow, alpha)
		guiSetAlpha(icon_label, alpha)
	--end
end

function showLoadingProgress(stats_numberOfInts, delayTime)
	if help_icon then
		removeIcon()
	end
	local title = stats_numberOfInts.." interiors(ETA: "..string.sub(tostring((tonumber(delayTime)-5000)/(60*1000)), 1, 3).." minutes) are being loaded. Don't panic if your house hasn't appeared yet. "
	local screenwidth, screenheight = guiGetScreenSize()
	help_icon = guiCreateStaticImage(screenwidth-25,6,20,20,"icon.png",false)
	icon_label_shadow = guiCreateLabel(screenwidth-829,11,800,20,title,false)
	guiSetFont(icon_label_shadow,"default-bold-small")
	guiLabelSetColor(icon_label_shadow,0,0,0)
	guiLabelSetHorizontalAlign(icon_label_shadow,"right",true)
	
	icon_label = guiCreateLabel(screenwidth-830,10,800,20,title,false)
	guiSetFont(icon_label,"default-bold-small")
	guiLabelSetHorizontalAlign(icon_label,"right",true)
	
	starttime = getTickCount( )
	updateIconAlpha( )
	addEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )
	
	setTimer(function () 
		if help_icon then
			removeIcon()
		end
	end, delayTime+10000 , 1)
end
addEvent("interior:showLoadingProgress",true)
addEventHandler("interior:showLoadingProgress",getRootElement(),showLoadingProgress)
--addCommandHandler("fu",showLoadingProgress)

function removeIcon()
	removeEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )
	destroyElement(icon_label_shadow)
	destroyElement(icon_label)
	destroyElement(help_icon)
	icon_label_shadow, icon_label, help_icon = nil
end

local purchaseProperty = {
    button = {},
    window = {},
    label = {},
    rad = {}
}

setElementData(localPlayer, "exclusiveGUI", false)
function purchasePropertyGUI(interior, cost, isHouse, isRentable, neighborhood)
	if isElement(purchaseProperty.window[1]) then
		closePropertyGUI()
	end

	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return false
	end

	local intID = getElementData(interior, "dbid")
	local viewstate = getElementData( getLocalPlayer(), "viewingInterior" )
	if viewstate==1 then
		triggerServerEvent("endViewPropertyInterior", getLocalPlayer(), getLocalPlayer(), intID)
		return
	end
	showCursor(true)

	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)

	purchaseProperty.window[1] = guiCreateWindow(607, 396, 499, 199, "Mülk Satın Alma Arayüzü", false)
	guiWindowSetSizable(purchaseProperty.window[1], false)
	guiSetAlpha(purchaseProperty.window[1], 0.89)
	exports.vrp_global:centerWindow(purchaseProperty.window[1])

	local margin = 13
	local btnW = 113
	local btnPosX = margin

	local btnTextSet = {"Mülkü Satın Al", "Banka Yoluyla Al"}
	if getElementData(localPlayer, "faction") ~= -1 and getElementData(localPlayer, "factionleader") == 1 then
		btnTextSet = {"Mülkü \nkendine al", "Mülkü \nbirliğe al"}
		if exports.vrp_global:hasItem(localPlayer, 262, 1) then
			btnTextSet[1] = "Token ile Al"
		end
	end
	purchaseProperty.button[1] = guiCreateButton(btnPosX, 145, btnW, 43, btnTextSet[1], false, purchaseProperty.window[1])
	guiSetProperty(purchaseProperty.button[1], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[2] = guiCreateButton(btnPosX, 145, btnW, 43, btnTextSet[2], false, purchaseProperty.window[1])
	guiSetProperty(purchaseProperty.button[2], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[4] = guiCreateButton(btnPosX, 145, btnW, 43, "Mülkü Görüntüleme", false, purchaseProperty.window[1])
	guiSetProperty(purchaseProperty.button[4], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[3] = guiCreateButton(btnPosX, 145, btnW, 43, "Kapat", false, purchaseProperty.window[1])
	guiSetProperty(purchaseProperty.button[3], "NormalTextColour", "FFAAAAAA")
	
	purchaseProperty.label[2] = guiCreateLabel(110, 44, 315, 20, "Ödeme yöntemini seçerek mülkü satın alabilirsiniz.", false, purchaseProperty.window[1])
	purchaseProperty.label[3] = guiCreateLabel(20, 70, 88, 15, "Mülk İsmi:", false, purchaseProperty.window[1])
	purchaseProperty.label[6] = guiCreateLabel(20, 90, 93, 15, "Mahalle:", false, purchaseProperty.window[1])
	purchaseProperty.label[4] = guiCreateLabel(20, 110, 100, 15, "Fiyat:", false, purchaseProperty.window[1])
	purchaseProperty.label[5] = guiCreateLabel(250, 110, 73, 15, "Vergi:", false, purchaseProperty.window[1])
	purchaseProperty.label[11] = guiCreateLabel(20, 130, 315, 15, "Alacağınız mülkün içinde mobilya olsun mu?", false, purchaseProperty.window[1]) -- Furniture

	purchaseProperty.label[7] = guiCreateLabel(110, 70, 400, 15, "", false, purchaseProperty.window[1]) -- Name
	purchaseProperty.label[9] = guiCreateLabel(110, 90, 400, 15, "", false, purchaseProperty.window[1]) -- Area
    purchaseProperty.label[8] = guiCreateLabel(110, 110, 91, 15, "", false, purchaseProperty.window[1]) -- Cost
    purchaseProperty.label[10] = guiCreateLabel(323, 110, 98, 15, "", false, purchaseProperty.window[1]) -- Tax
	
	--guiSetFont(purchaseProperty.label[1], "default-bold-small")
	guiSetFont(purchaseProperty.label[2], "default-bold-small")
	guiSetFont(purchaseProperty.label[3], "default-bold-small")
	guiSetFont(purchaseProperty.label[4], "default-bold-small")
	guiSetFont(purchaseProperty.label[5], "default-bold-small")
	guiSetFont(purchaseProperty.label[6], "default-bold-small")

	purchaseProperty.rad[1] = guiCreateRadioButton(245, 128, 50, 20, "Evet", false, purchaseProperty.window[1])
    purchaseProperty.rad[2] = guiCreateRadioButton(295, 128, 50, 20, "Hayır", false, purchaseProperty.window[1])
    guiRadioButtonSetSelected(purchaseProperty.rad[1], true)

	addEventHandler("onClientGUIClick", purchaseProperty.button[3], closePropertyGUI, false) 

	addEventHandler( "onClientGUIClick" ,purchaseProperty.button[1],
	function()
		local btnText = guiGetText(purchaseProperty.button[1])
		if btnText == "Mülkü Satın Al" then
			triggerServerEvent("buypropertywithcash", getLocalPlayer(), getLocalPlayer(), interior, cost, isHouse, isRentable, guiRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		elseif btnText == "Token ile Al" then
			triggerServerEvent("buypropertywithtoken", getLocalPlayer(), getLocalPlayer(), interior, cost, isHouse, isRentable, guiRadioButtonGetSelected(purchaseProperty.rad[1]))
		else
			btnTextSet = {"Mülkü Satın Al", "Banka Yoluyla Al"}
			if exports.vrp_global:hasItem(localPlayer, 262, 1) then
				btnTextSet[1] = "Token ile Al"
			end
			guiSetText(purchaseProperty.button[1], btnTextSet[1])
			guiSetText(purchaseProperty.button[2], btnTextSet[2])
		end
	end, false)
	
	addEventHandler( "onClientGUIClick" ,purchaseProperty.button[2],
	function()
		local btnText = guiGetText(purchaseProperty.button[2])
		if btnText == "Banka Yoluyla Al" then
			triggerServerEvent("buypropertywithbank", getLocalPlayer(), getLocalPlayer(), interior, cost, isHouse, isRentable, guiRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		else
			if isRentable then
				outputChatBox("Şu anda kiralanabilir nitelikte olamaz.", 255, 0, 0)
			else
				triggerServerEvent("buypropertyForFaction", getLocalPlayer(), interior, cost, isHouse)
				closePropertyGUI()
			end
		end
	end, false)

	addEventHandler( "onClientGUIClick" ,purchaseProperty.button[4],
	function()
		triggerServerEvent("viewPropertyInterior", getLocalPlayer(), getLocalPlayer(), intID)
		closePropertyGUI()
	end, false)

	

    local interiorName = getElementData(interior, "name")
	if isHouse then
		local theTax = exports.vrp_payday:getPropertyTaxRate(0)
		purchaseProperty.label[1] = guiCreateLabel(50, 26, 419, 18, "Lütfen bu özellik hakkında aşağıdaki bilgileri doğrulayın.", false, purchaseProperty.window[1])
		guiLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		taxtax = cost * theTax
		guiSetText(purchaseProperty.label[10], ""..exports.vrp_pool:getServerMoneyType(localPlayer) ..exports.vrp_global:formatMoney(taxtax).."")
	elseif isRentable then
		guiSetText(purchaseProperty.window[1], "Kiralık Mülk")
		purchaseProperty.label[1] = guiCreateLabel(50, 26, 419, 18, "Lütfen bu kiralanabilir mülk ile ilgili aşağıdaki bilgileri doğrulayın.", false, purchaseProperty.window[1])
		guiLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		guiSetVisible(purchaseProperty.label[5], false)
		guiSetText(purchaseProperty.label[4], "Saatlik Kesilen Ücret:")
	else
		local theTax = exports.vrp_payday:getPropertyTaxRate(1)
		guiSetText(purchaseProperty.window[1], "Satılık İşyeri")
		purchaseProperty.label[1] = guiCreateLabel(50, 26, 419, 18, "Lütfen bu işletme mülküyle ilgili aşağıdaki bilgileri doğrulayın.", false, purchaseProperty.window[1])
		guiLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		taxtax = cost * theTax
		guiSetText(purchaseProperty.label[10], ""..exports.vrp_pool:getServerMoneyType(localPlayer) ..exports.vrp_global:formatMoney(taxtax).."")
	end
	guiSetText(purchaseProperty.label[9], neighborhood)
	guiSetText(purchaseProperty.label[7], tostring(interiorName))
	guiSetText(purchaseProperty.label[8], ""..exports.vrp_pool:getServerMoneyType(localPlayer) ..exports.vrp_global:formatMoney(cost).."")
end
addEvent( "openPropertyGUI", true )
addEventHandler( "openPropertyGUI", getRootElement( ), purchasePropertyGUI)

function closePropertyGUI()
	destroyElement(purchaseProperty.window[1])
	showCursor(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	closeStartBuying()
end

local GUIEditor = {
    button = {},
    window = {}
}
function startBuyingForFaction(byBank, interior, cost, isHouse, isRentable)
	--[[
	if getElementData(localPlayer, "faction") ~= -1 and getElementData(localPlayer, "factionleader") == 1 then
		guiSetEnabled(purchaseProperty.window[1], false)
	    GUIEditor.window[1] = guiCreateWindow(642, 385, 409, 173, "Do you want to purchase this property for your faction or for yourself?", false)
	    guiWindowSetSizable(GUIEditor.window[1], false)
	    exports.vrp_global:centerWindow(GUIEditor.window[1])

	    GUIEditor.button[1] = guiCreateButton(16, 34, 376, 34, "I'm buying this for myself (using my money)", false, GUIEditor.window[1])
	    addEventHandler("onClientGUIClick", GUIEditor.button[1], function ()
	    	if source == GUIEditor.button[1] then
	    		triggerServerEvent(byBank and "buypropertywithbank" or "buypropertywithcash", getLocalPlayer(), getLocalPlayer(), interior, cost, isHouse, isRentable)
	    		closePropertyGUI()
	    	end
	    end)
	    GUIEditor.button[2] = guiCreateButton(16, 78, 376, 34, "I'm buying this for faction (using faction bank)", false, GUIEditor.window[1])
	    addEventHandler("onClientGUIClick", GUIEditor.button[2], function ()
	    	if source == GUIEditor.button[2] then
	    		triggerServerEvent(byBank and "buypropertywithbank" or "buypropertywithcash", getLocalPlayer(), getLocalPlayer(), interior, cost, isHouse, isRentable, getElementData(localPlayer, "faction"))
	    		closePropertyGUI()
	    	end
	    end)
	    GUIEditor.button[3] = guiCreateButton(17, 122, 376, 34, "No, I changed my mind.", false, GUIEditor.window[1])   
	    addEventHandler("onClientGUIClick", GUIEditor.button[3], function ()
	    	if source == GUIEditor.button[3] then
	    		closeStartBuying()
	    	end
	    end)
	end
	]]
end

function closeStartBuying()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then
		destroyElement(GUIEditor.window[1])
		GUIEditor.window[1] = nil
		if purchaseProperty.window[1] and isElement(purchaseProperty.window[1]) then
			guiSetEnabled(purchaseProperty.window[1], true)
		end
	end
end