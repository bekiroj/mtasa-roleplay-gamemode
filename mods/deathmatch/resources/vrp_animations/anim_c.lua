local anim = false
local localPlayer = getLocalPlayer()
local walkanims = { WALK_armed = true, WALK_civi = true, WALK_csaw = true, Walk_DoorPartial = true, WALK_drunk = true, WALK_fat = true, WALK_fatold = true, WALK_gang1 = true, WALK_gang2 = true, WALK_old = true, WALK_player = true, WALK_rocket = true, WALK_shuffle = true, Walk_Wuzi = true, woman_run = true, WOMAN_runbusy = true, WOMAN_runfatold = true, woman_runpanic = true, WOMAN_runsexy = true, WOMAN_walkbusy = true, WOMAN_walkfatold = true, WOMAN_walknorm = true, WOMAN_walkold = true, WOMAN_walkpro = true, WOMAN_walksexy = true, WOMAN_walkshop = true, run_1armed = true, run_armed = true, run_civi = true, run_csaw = true, run_fat = true, run_fatold = true, run_gang1 = true, run_old = true, run_player = true, run_rocket = true, Run_Wuzi = true }
local attachedRotation = false

function onRender()
	local forcedanimation = getElementData(localPlayer, "forcedanimation")

	if (getPedAnimation(localPlayer)) and not (forcedanimation==1) then
		local screenWidth, screenHeight = guiGetScreenSize()
		anim = true

		local block, style = getPedAnimation(localPlayer)
		if block == "ped" and walkanims[ style ] and not getKeyState("lalt") and not getKeyState("ralt") then
			local px, py, pz, lx, ly, lz = getCameraMatrix()
			setPedRotation( localPlayer, math.deg( math.atan2( ly - py, lx - px ) ) - 90 )
		end
	elseif not (getPedAnimation(localPlayer)) and (anim) then
		anim = false
		toggleAllControls(true, true, false)
	end

	local element = getElementAttachedTo(localPlayer)
	if element and getElementType( element ) == "vehicle" then
		if attachedRotation then
			local rx, ry, rz = getElementRotation( element )
			setPedRotation( localPlayer, rz + attachedRotation )
		else
			local rx, ry, rz = getElementRotation( element )
			attachedRotation = getPedRotation( localPlayer ) - rz
		end
	elseif attachedRotation then
		attachedRotation = false
	end
end
addEventHandler("onClientRender", root, onRender)

function stopAnimationFix()
	--if not getPedAnimation( localPlayer ) then
		setPedAnimation (localPlayer)
		triggerServerEvent("stopAnimationFix2", getRootElement(), localPlayer)
		local forcedanimation = getElementData(localPlayer, "forcedanimation")
		if not (forcedanimation==1) then
			triggerServerEvent("unbindAnimationStopKey", localPlayer)
		end
	--end
end
addEvent("stopAnimationFix", true)
addEventHandler( "stopAnimationFix", getRootElement(), stopAnimationFix )

bindKey("space", "down",
	function()
		stopAnimationFix()
	end
)

addEvent("anim_editor.start", true)
addEventHandler("anim_editor.start", root,
	function(_)
		details = _
		if details.state == true then
			setTimer(function() addEventHandler("onClientRender", root, renderPositions) end, 50, 1)
		else
			removeEventHandler("onClientRender", root, renderPositions)
		end
	end
)

local font = DxFont("assets/Roboto.ttf", 10)
local sx, sy = guiGetScreenSize()

function renderPositions()
    local x, y, z = getPedBonePosition(localPlayer, 3)
    -- Line 3d.
    dxDrawLine3D(x, y, z+0.1, x+1, y, z+0.1, tocolor(47,82,122,220), 2)
    dxDrawLine3D(x, y, z+0.1, x-1, y, z+0.1, tocolor(47,82,122,220), 2)
    dxDrawLine3D(x, y, z+0.1, x, y+1, z+0.1, tocolor(47,82,122,220), 2)
    dxDrawLine3D(x, y, z+0.1, x, y-1, z+0.1, tocolor(47,82,122,220), 2)
    local x, y, z = getElementPosition(localPlayer)
    dxDrawText("Seçilen animasyonun konumunu ayarlamak için yön tuşlarını kullanın.\nYüksekliği ayarlamak için num+ ve num- tuşlarını kullanın.", 0, 35, sx, sy, tocolor(255, 255, 255), 1, font, "center", "bottom")
    if getKeyState("arrow_l") then
        setElementPosition(localPlayer, x+0.05, y, z)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("arrow_r") then
        setElementPosition(localPlayer, x-0.05, y, z)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("arrow_u") then
        setElementPosition(localPlayer, x, y-0.05, z)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("arrow_d") then
        setElementPosition(localPlayer, x, y+0.05, z)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("num_add") then
        setElementPosition(localPlayer, x, y, z+0.05)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("num_sub") then
        setElementPosition(localPlayer, x, y, z-0.05)
        setElementRotation(localPlayer, 0, 0, getCameraRotation())
        setElementFrozen(localPlayer, true)
        setPedAnimation(localPlayer, details.body, details.part)
    elseif getKeyState("enter") or getKeyState("num_enter") or getKeyState("backspace") then
    	details.position = {x, y, z}
    	details.rotz = {localPlayer:getRotation():getZ()}
    	setElementFrozen(localPlayer, false)
       	triggerServerEvent("anim_editor.save", localPlayer, localPlayer, details)
    end
end

function rotFromCam(rzOffset)
	local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
	local deltaY,deltaX = fy-cy,fx-cx
	local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
	if deltaY >= 0 and deltaX <= 0 then -- 4 cwiartka
		rotZ = rotZ+180
	elseif deltaY <= 0 and deltaX <= 0 then -- 3 cwiartka
		rotZ = rotZ+180
	end
	return -rotZ+90 + rzOffset
end

function dirMove(a)
	local x = math.sin(math.rad(a))
	local y = math.cos(math.rad(a))
	return x,y
end

function getCameraRotation ()
	cam = Camera.matrix:getRotation():getZ()
	--cam2 = tonumber(string.format("%.0f",cam/90))*90

	--outputChatBox(cam)
	return tonumber(cam)
end
