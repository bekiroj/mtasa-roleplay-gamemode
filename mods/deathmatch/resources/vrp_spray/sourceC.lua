
local acikmi = false
renkler = {}
local screenW, screenH = guiGetScreenSize()

    function paneldx ()
	if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
	if acikmi then
	local oyuncudim = getElementDimension(getLocalPlayer())
	if (oyuncudim > 0) then
	renkler[1] = tocolor(255, 255, 255, 170)
	renkler[2] = tocolor(255, 255, 255, 170)
	renkler[3] = tocolor(255, 255, 255, 170)
	renkler[4] = tocolor(255, 255, 255, 170)
	renkler[5] = tocolor(255, 255, 255, 170)
	renkler[6] = tocolor(255, 255, 255, 170)
	
	if mouse(screenW * 0.8328, screenH * 0.3733, screenW * 0.1594, screenH * 0.0433) then
	renkler[1] = tocolor(255, 255, 255, 255)
	elseif mouse(screenW * 0.8328, screenH * 0.4433, screenW * 0.1594, screenH * 0.0433) then
	renkler[2] = tocolor(255, 255, 255, 255)
	elseif mouse(screenW * 0.8328, screenH * 0.5133, screenW * 0.1594, screenH * 0.0433) then
	renkler[3] = tocolor(255, 255, 255, 255)
	elseif mouse(screenW * 0.8328, screenH * 0.5833, screenW * 0.1594, screenH * 0.0433) then
	renkler[4] = tocolor(255, 255, 255, 255)
	elseif mouse(screenW * 0.8328, screenH * 0.6517, screenW * 0.1594, screenH * 0.0433) then
	renkler[5] = tocolor(255, 255, 255, 255)
	elseif mouse(screenW * 0.8328, screenH * 0.7200, screenW * 0.1594, screenH * 0.0433) then
	renkler[6] = tocolor(255, 255, 255, 255)
	end
        dxDrawRectangle(screenW * 0.8328, screenH * 0.3117, screenW * 0.1594, screenH * 0.4717, tocolor(0, 0, 0, 170), false)
        dxDrawText("Arac Boyama Sistemi", screenW * 0.8328, screenH * 0.26, screenW * 0.9898, screenH * 0.4117, tocolor(255, 255, 255, 255), 1.00, "default-bold", "center", "center", true, true, true, true, true)
        dxDrawLine((screenW * 0.8328) - 1, screenH * 0.3550, screenW * 0.9922, screenH * 0.3550, tocolor(233, 0, 0, 170), 1, false)
        y =  0.3117
        dxDrawRectangle(screenW * 0.8328, screenH * y, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		dxDrawLine((screenW * 0.8328) - 1, screenH * 0.3550, screenW * 0.9922, screenH * 0.3550, tocolor(233, 0, 0, 170), 1, false)
		-- renk 1
        dxDrawRectangle(screenW * 0.8328, screenH * 0.3733, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		-- renk 2
        dxDrawRectangle(screenW * 0.8328, screenH * 0.4433, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		-- renk 3
        dxDrawRectangle(screenW * 0.8328, screenH * 0.5133, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		-- renk 4
        dxDrawRectangle(screenW * 0.8328, screenH * 0.5833, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		-- renk Kaydet
        dxDrawRectangle(screenW * 0.8328, screenH * 0.6517, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		-- renk Kapat
        dxDrawRectangle(screenW * 0.8328, screenH * 0.7200, screenW * 0.1594, screenH * 0.0433, tocolor(0, 0, 0, 170), false)
		
		
        dxDrawText("Renk - 1", screenW * 0.8328, screenH * 0.3750, screenW * 0.9898, screenH * 0.4117, renkler[1], 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Renk - 2", screenW * 0.8328, screenH * 0.51, screenW * 0.9898, screenH * 0.4117, renkler[2], 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Far Renk", screenW * 0.8328, screenH * 0.65, screenW * 0.9898, screenH * 0.4117, renkler[3], 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Renk - 4", screenW * 0.8328, screenH * 0.79, screenW * 0.9898, screenH * 0.4117, renkler[4], 1.00, "default-bold", "center", "center", false, false, false, false, false)
        
		dxDrawText("Kaydet", screenW * 0.8328, screenH * 0.93, screenW * 0.9898, screenH * 0.4117, renkler[5], 1.00, "default-bold", "center", "center", false, false, false, false, false)
        dxDrawText("Kapat", screenW * 0.8328, screenH * 1.07, screenW * 0.9898, screenH * 0.4117, renkler[6], 1.00, "default-bold", "center", "center", false, false, false, false, false)
    end
	end
	end
	end


function ackapa (_,state)
if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
local oyuncudim = getElementDimension(getLocalPlayer())
	if (oyuncudim > 0) then
if acikmi == false then
showCursor(true)
addEventHandler("onClientRender", root, paneldx)
acikmi = true
else
showCursor(false)
removeEventHandler("onClientRender", root, paneldx)
acikmi = false
end
   end
end
end
addCommandHandler("renkler", ackapa)

addEventHandler("onClientClick",root,function(button,state)
if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
if button == "left" and state == "down" and acikmi then
if mouse(screenW * 0.8328, screenH * 0.7200, screenW * 0.1594, screenH * 0.0433) then
    showCursor(false)
    removeEventHandler("onClientRender", root, paneldx)
    acikmi = false
elseif mouse(screenW * 0.8328, screenH * 0.6517, screenW * 0.1594, screenH * 0.0433) then	
 showCursor(false)
    removeEventHandler("onClientRender", root, paneldx)
    acikmi = false
elseif mouse(screenW * 0.8328, screenH * 0.3733, screenW * 0.1594, screenH * 0.0433) then -- renk 1
if exports.vrp_colorblender:isPickerOpened("renk1") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk2") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk3") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk4") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
    exports.vrp_colorblender:openPicker("renk1", string.format("#%02X%02X%02X", 0, 0, 0) , "Renk - 1")
elseif mouse(screenW * 0.8328, screenH * 0.4433, screenW * 0.1594, screenH * 0.0433) then -- renk 2  exports.vrp_colorblender:openPicker("renk2", string.format("#%02X%02X%02X", 0, 0, 0) , "Renk - 2")
if exports.vrp_colorblender:isPickerOpened("renk1") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk2") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk3") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk4") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
  exports.vrp_colorblender:openPicker("renk2", string.format("#%02X%02X%02X", 0, 0, 0) , "Renk - 2")
elseif mouse(screenW * 0.8328, screenH * 0.5133, screenW * 0.1594, screenH * 0.0433) then -- renk 3
if exports.vrp_colorblender:isPickerOpened("renk1") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk2") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk3") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk4") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
    exports.vrp_colorblender:openPicker("renk3", string.format("#%02X%02X%02X", 0, 0, 0) , "Far Rengi")	
elseif mouse(screenW * 0.8328, screenH * 0.5833, screenW * 0.1594, screenH * 0.0433) then -- renk 4
if exports.vrp_colorblender:isPickerOpened("renk1") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk2") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk3") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
if exports.vrp_colorblender:isPickerOpened("renk4") then outputChatBox("Zaten bir pencere açık.", 255, 0 ,0) return end
    exports.vrp_colorblender:openPicker("renk4", string.format("#%02X%02X%02X", 0, 0, 0) , "Renk - 4")	
elseif mouse(screenW * 0.8328, screenH * 0.6517, screenW * 0.1594, screenH * 0.0433) then -- kaydet

elseif mouse(screenW * 0.8328, screenH * 0.7200, screenW * 0.1594, screenH * 0.0433) then -- Kapat

         end
      end
   end
end)

function mouse ( x, y, width, height )
if ( not isCursorShowing( ) ) then
return false
end
local sx, sy = guiGetScreenSize ( )
local cx, cy = getCursorPosition ( )
local cx, cy = ( cx * sx ), ( cy * sy )
if ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) then
return true
else
return false
end
end


function boyasec (renk, hex, r, g, b)
if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
    if renk == 'renk1' then
        setElementData(getLocalPlayer(), "modifiye:rgb1", {r,g,b})
		local renkler = getElementData(getLocalPlayer(), "modifiye:rgb1")  	
	end	
    if renk == 'renk2' then
        setElementData(getLocalPlayer(), "modifiye:rgb2", {r,g,b})
		local renkler = getElementData(getLocalPlayer(), "modifiye:rgb2")  
		if  (exports.vrp_global:takeMoney(getLocalPlayer(),2000)) then
		
		end
	end	
	if renk == 'renk3' then
        setElementData(getLocalPlayer(), "modifiye:far", {r,g,b})	
		local renkler = getElementData(getLocalPlayer(), "modifiye:far") 
      end    
   end	
end
addEventHandler("onColorPickerOK", root, boyasec)

 function arabarenk1 (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
   aracim = getNearVeh()
   if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
		if source == localPlayer and weapon == 41 and hitElement then
			if weapon == 41 and isElement(hitElement) and getElementType(hitElement) == "vehicle"  then
			if aracim then
			local orjRenkler1, orjRenkler2, orjRenkler3, orjRenkler4, orjRenkler5, orjRenkler6, orjRenkler7, orjRenkler8, orjRenkler9, orjRenkler10, orjRenkler11, orjRenkler12 = getVehicleColor(hitElement, true)
			local renkler = getElementData(getLocalPlayer(), "modifiye:rgb1")
			
			renkler1 =  renkler[1]
			renkler2 =  renkler[2]
			renkler3 =  renkler[3]
			
			triggerServerEvent("arabarenk1", localPlayer,hitElement ,renkler1,renkler2,renkler3)

            end
         end
      end
   end
end

addEventHandler("onClientPlayerWeaponFire",getRootElement(), arabarenk1)

 function arabarenk2 (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
   aracim = getNearVeh()
   if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
		if source == localPlayer and weapon == 41 and hitElement then
			if weapon == 41 and isElement(hitElement) and getElementType(hitElement) == "vehicle"  then
			if aracim then
			local orjRenkler1, orjRenkler2, orjRenkler3, orjRenkler4, orjRenkler5, orjRenkler6, orjRenkler7, orjRenkler8, orjRenkler9, orjRenkler10, orjRenkler11, orjRenkler12 = getVehicleColor(hitElement, true)
			local renk2 = getElementData(getLocalPlayer(), "modifiye:rgb2") 
			
			renkler4 =  renk2[1] or 0
			renkler5 =  renk2[2] or 0
			renkler6 =  renk2[3] or 0
			
			triggerServerEvent("arabarenk2", localPlayer,hitElement ,renkler4,renkler5,renkler6)

            end
         end
      end
   end
end

addEventHandler("onClientPlayerWeaponFire",getRootElement(), arabarenk2)

 function farrenk (weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
   aracim = getNearVeh()
   if (getElementData(getLocalPlayer(), "tamirci" ) == 1) then
		if source == localPlayer and weapon == 41 and hitElement then
			if weapon == 41 and isElement(hitElement) and getElementType(hitElement) == "vehicle"  then
			if aracim then
			local orjRenkler1, orjRenkler2, orjRenkler3, orjRenkler4, orjRenkler5, orjRenkler6, orjRenkler7, orjRenkler8, orjRenkler9, orjRenkler10, orjRenkler11, orjRenkler12 = getVehicleColor(hitElement, true)
			local farrenk = getElementData(getLocalPlayer(), "modifiye:far") or 0
			
			renkler7 =  farrenk[1]
			renkler8 =  farrenk[2]
			renkler9 =  farrenk[3]
			triggerServerEvent("farrenk", localPlayer, hitElement ,renkler7,renkler8,renkler9)

            end
         end
      end
   end
end

addEventHandler("onClientPlayerWeaponFire",getRootElement(), farrenk)

function getNearVeh()
  for k,v in ipairs(getElementsByType("vehicle")) do
    if getDistanceFromElement(localPlayer,v) <= 3 then
        return v
    end
  end
end

function getDistanceFromElement(from, to)
	if not from or not to then return end
	local x, y, z = getElementPosition(from)
	local x1, y1, z1 = getElementPosition(to)
	return getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
end
