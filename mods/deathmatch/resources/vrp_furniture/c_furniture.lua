--!!!
for i = 2, 4 do
    setInteriorFurnitureEnabled(i, false)
end
--!!!


Furnitures = {}
local hifiBoxes = {}
local sX, sY = guiGetScreenSize()
local lastClick = 0
local showEditInterface = false
local show_hifi = false
local selectedFurniture = nil
local selectedHifi = nil

local font_bold = dxCreateFont("files/1.ttf",11)
local font_default = dxCreateFont("files/2.ttf",8)
local fontA = dxCreateFont("files/5.ttf",9)
local actions = {
	{" Mobilyayı Düzenle", false, "Furnitures.editFurniture()"},
	{" Mobilyayı Kaldır", false, "Furnitures.pickUpFurniture()"},
	{" Menüyü Kapat",false,"Furnitures.closeMenu()"}
}
local lastClick = 0
local hifiAnim = "+"
local hifiYoffset = 0
local hifiXoffset = 0
local hifiZoffset = {}
local showHifiIcon = true
local hifiImages = {}
local img = dxCreateTexture("files/hifinote.png")
local hifiStoreTable = {}
local white = tocolor(255,255,255,255)
function dxDrawImage3D(x,y,z,w,h,m,c,r,...)
        local lx, ly, lz = x+w, y+h, (z+tonumber(r or 0)) or z
	return dxDrawMaterialLine3D(x,y,z, lx, ly, lz, m, h, c or white, ...)
end
local font3 = dxCreateFont("files/5.ttf",12)
function Furnitures.draw()
	if getElementData(localPlayer, "Furniture->isFurnitureOnHand") and selectedFurniture then
		local x, y, z = getElementPosition(selectedFurniture)
		local wX, wY = getScreenFromWorldPosition(x, y, z)
		if wX and wY then
			dxDrawText("Mobilyayı yerleştirmek için '"..color["hex"].."E#ffffff' bas \n"..color["hex"].." #ffffffMouse ile basılı tutarak yerini ayarla.",wX, wY, wX, wY, tocolor(255, 255, 255, 255), 1, font3, "center", "center", false ,false, false, true)
		end
		dxDrawRectangle(sX - 190, sY - 80, 165, 60, tocolor(0, 0, 0, 150))
		dxDrawImage(sX - 190, sY - 80, 64, 64, "files/pgdn.png")
		dxDrawImage(sX - 190 + 66, sY - 80, 64, 64, "files/pgup.png")
		dxDrawImage(sX - 190 + 130, sY - 65, 32, 32, "files/ud_icon.png",90,0,0)
	
		if moveHandle then
		local screenx, screeny, worldx, worldy, worldz = getCursorPosition()
        local px, py, pz = getCameraMatrix()
        local hit, x, y, z, elementHit = processLineOfSight ( px, py, pz, worldx, worldy, worldz )
			if lastClick+50 <= getTickCount() then
				lastClick = getTickCount()
				--setElementPosition(selectedFurniture,x,y,z)
				triggerServerEvent("Furnitures->setPos",localPlayer,localPlayer,selectedFurniture,{x,y,z,Furnitures.getRotation()})
			end
		end
		
	end
	
hifiXoffset = 0
	
	dim2 = getElementDimension(localPlayer)
	dim2 = tonumber(dim2)
	int2 = getElementInterior(localPlayer)
	int2 = tonumber(int2)
	

	if not selectedFurniture then return end

	if getKeyState("arrow_u") then
		local x, y, z, rx, ry, rz = getElementPosition(selectedFurniture)
		--if z > 1.5 then return end
		setElementPosition(selectedFurniture, x, y, z + 0.01)
	end
	if getKeyState("arrow_d") then
		local x, y, z, rx, ry, rz = getElementPosition(selectedFurniture)
		--if z < - 1.5 then return end
		setElementPosition(selectedFurniture, x, y, z - 0.01)
	end	
	--
	if not showEditInterface then return end
	
	local x, y, z = getElementPosition(selectedFurniture)
	local wX, wY = getScreenFromWorldPosition(x, y, z)
	if getDistanceFromElement(localPlayer, selectedFurniture) < 4 then
		if wX and wY then
			dxDrawRectangle(wX - 170/2, wY - 150/2, 170, 110, tocolor(0, 0, 0, 120))
			dxDrawRectangle(wX - 170/2, wY - 150/2, 170, 20, tocolor(0, 0, 0, 170))
			dxDrawRectangle(wX - 170/2, wY - 150/2+20, 170, 2, tocolor(unpack(color["rgb"])))
			for i = 0, #actions - 1 do
				dxDrawRectangle(wX - 170/2, wY - 150/2 + i * 24 + 26, 170, 20, tocolor(0, 0, 0, 120))
		
				dxDrawText(actions[i + 1][1], wX - 170/2+5, wY - 150/2 + i * 24 + 24, 170 + wX - 170/2+5, 20 + wY - 150/2 + i * 24 + 26, tocolor(255, 255, 255, 255), 1, fontA, "left", "center", false ,false, false, true)
				dxDrawText("Mobilya Yönetimi",wX - 170/2, wY - 150/2, 170 + wX - 170/2, 20 + wY - 150/2,tocolor(255,255,255,255),1,font_bold,"center","center",false,false,true,true)
			end	
		end
	else
		setElementData(selectedFurniture, "Furniture->used", false)
		selectedFurniture = nil
		showEditInterface = false
	end
end
addEventHandler("onClientRender", root, Furnitures.draw)

function nearByID()
	dim,int = tonumber(getElementDimension(localPlayer)), tonumber(getElementInterior(localPlayer))
	for k,v in ipairs(getElementsByType("object")) do
		dim2,int2 = tonumber(getElementDimension(v)), tonumber(getElementInterior(v))
		if (dim2 == dim) and (int2 == int) and tonumber(getElementModel(v)) == 2100 then
			return getElementData(v,"dbid")
		else
			return 0
		end
	end
end
function Furnitures.editFurniture()
	local data = {}
	--setElementAlpha(localPlayer,255)
	--setFreecamDisabled()
	--setCameraTarget(localPlayer)
	triggerServerEvent("Furnitures->attachFurniture", localPlayer, localPlayer, selectedFurniture, data)
	showEditInterface = false
end
function Furnitures.closeMenu()
		setElementData(selectedFurniture, "Furniture->used", false)
		selectedFurniture = nil
		showEditInterface = false
end

function Furnitures.pickUpFurniture()
	if #myFurnitures + 1 > 10 then 
		outputChatBox("Bu objeden daha fazla koyamazsınız!",255,0,0)
		return
	end
	if showed_myFurnitures then
		myFurnitures = {}
		load_my_furnitures()
	end
	triggerServerEvent("Furnitures->destroyFurniture", localPlayer, localPlayer, selectedFurniture)
	selectedFurniture = nil
	showEditInterface = false
end

function Furnitures.openHifi()
	showEditInterface = false
	show_hifi = true
end
local hifi_scroll = 0
local selectedHifiKey = 0
local maxHifiShow = 9
local font1 = dxCreateFont("files/5.ttf",9.7)
function Furnitures.drawHifi()
	if not show_hifi or not selectedHifi then return end
	dxDrawRectangle(sX/2 - 400/2-4, sY/2 - 170/2-6-4, 400+8, 186+8, tocolor(0, 0, 0, 120))
	dxDrawRectangle(sX/2 - 400/2, sY/2 - 170/2-6, 400, 186, tocolor(10,10,10,150))
	baslik = color["hex"].."Valhalla#ffffff HI-FI"
	dxDrawRectangle(sX/2 - 400/2, sY/2 - 170/2-6, dxGetTextWidth(baslik,0.97,font1)+20, 20, tocolor(10,10,10,150))
	dxDrawText(baslik,sX/2 - 400/2+4, sY/2 - 170/2-6, dxGetTextWidth(baslik,0.97,font1)+24, 20+(sY/2 - 170/2-6),tocolor(255,255,255),1,font1,"left","center",false,false,false,true)
	dxDrawRectangle(sX/2 - 400/2, sY/2 - 170/2-6+19, dxGetTextWidth(baslik,1,font1)+20, 1, tocolor(unpack(color["rgb"])))
	
	if selectedHifiKey > 0 then
		dxDrawText("Çalan Kanal: "..color["hex"]..radio_channels[selectedHifiKey][1] or "n/a",sX/2 - 400/2+4, sY/2 - 170/2-6+25, dxGetTextWidth(baslik,0.97,font1)+24, 20+(sY/2 - 170/2-6+25),tocolor(255,255,255),1,font1,"left","top",false,false,false,true)
	else
		dxDrawText("Çalan Kanal: "..color["hex"].."n/a",sX/2 - 400/2+4, sY/2 - 170/2-6+25, dxGetTextWidth(baslik,0.97,font1)+24, 20+(sY/2 - 170/2-6+25),tocolor(255,255,255),1,font1,"left","top",false,false,false,true)
	end
	-- Channel List
	dxDrawRectangle(sX/2 - 400/2 + 396-150, sY/2 - 170/2, 150, 170, tocolor(0, 0, 0, 120))
	local line = 0
	for k, v in ipairs(radio_channels) do
		line = line + 1
		if (k > hifi_scroll and line < maxHifiShow) then
			dxDrawRectangle(sX/2 - 400/2 + 396-150, sY/2 - 170/2 + (k-1) * 22, 150, 20, tocolor(0, 0, 0, 120))
			if selectedHifiKey == k then
				dxDrawText(v[1],sX/2 - 400/2 + 396-150, sY/2 - 170/2 + (k-1) * 22, 150 + sX/2 - 400/2 + 396-150, 20 + sY/2 - 170/2 + (k-1) * 22,tocolor(unpack(color["rgb"])),1,font_default,"center","center",false,false,true,true)
			else
				dxDrawText(v[1],sX/2 - 400/2 + 396-150, sY/2 - 170/2 + (k-1) * 22, 150 + sX/2 - 400/2 + 396-150, 20 + sY/2 - 170/2 + (k-1) * 22,tocolor(255,255,255,255),1,font_default,"center","center",false,false,true,true)
			end
		end
	end
	
	drawButton("Sesi Kapat",sX/2 - 400/2, sY/2 - 170/2 + 100,150,20,"#eb4d4baa",false, false, false, nil, true)
	drawButton("Paneli Kapat",sX/2 - 400/2, sY/2 - 170/2 + 125,150,20,"#74b9ffaa",false, false, false, nil, true)
	--dxDrawRectangle(sX/2 - 400/2, sY/2 - 170/2 + 100, dxGetTextWidth("Sesi Kapat       ",1,font_bold)+5, 20, tocolor(255, 0, 0, 120)) -- Stop
	--dxDrawText("Sesi Kapat",sX/2 - 400/2+5, sY/2 - 170/2 + 100, dxGetTextWidth("Sesi Kapat",1,font_bold)+5, 20,tocolor(255,255,255),1,font_bold,"left","top")

	--dxDrawRectangle(sX/2 - 400/2, sY/2 - 170/2 + 100+25, dxGetTextWidth("Sesi Kapat       ",1,font_bold)+5, 20, tocolor(0, 0, 255, 120)) -- Stop
	--dxDrawText("Paneli Kapat",sX/2 - 400/2+5, sY/2 - 170/2 + 100+25, dxGetTextWidth("Sesi Kapat",1,font_bold)+5, 25,tocolor(255,255,255),1,font_bold,"left","top")

	--[[
	local row = 0
	for k, v in ipairs(getElementsByType("object")) do
		if tonumber(getElementDimension(v)) == tonumber(getElementDimension(localPlayer)) and tonumber(getElementModel(v)) == 2100 then
			row = row + 1
			local distance = getDistanceFromElement(selectedHifi, v)
			if distance/30 < 1 then
				local color = tocolor(255, 255, 255, 120)
				if distance/30 <= 0.6 then
					color = tocolor(138, 218, 140, 120)
				else
					color = tocolor(205, 55, 55, 120)
				end
				dxDrawRectangle(sX/2 - 400/2 + 20, sY/2 - 170/2 + (row - 1) * 22 + 20, 170, 20, tocolor(0, 0, 0, 120))
				dxDrawRectangle(sX/2 - 400/2 + 20, sY/2 - 170/2 + (row - 1) * 22 + 20, distance/30 * 170, 20, color)
				dxDrawText("Kanal: #"..row,sX/2 - 400/2 + 20, sY/2 - 170/2 + (row - 1) * 22 + 20, 170 + sX/2 - 400/2 + 20, 20 + sY/2 - 170/2 + (row - 1) * 22 + 20,tocolor(255,255,255,255),1,font_default,"center","center",false,false,true,true)
			end
		end
	end
	]]
end
addEventHandler("onClientRender", root, Furnitures.drawHifi)


function Furnitures.click(button, state, _, _, _, _, _, element)
	if button == "right" and state == "down" then
		if element and isElement(element) then
			if getElementData(element, "Furnitures->isFurniture") then
				 if getElementData(element, "Furnitures->owner") == getElementData(localPlayer, "dbid") then
					showEditInterface = true
					if #actions == 4 then
						table.remove(actions, 4)
					end
					if getElementModel(element) == 2100 then
					
						selectedHifi = element
						table.insert(actions, {" Hifi Yönetimi", false, "Furnitures.openHifi()"})
					elseif getElementModel(element) == 2482 then
						selectedObject = element
						table.insert(actions, {"Raf Yönetimi", false, "Furnitures.openWeaponController()"})
					end
					selectedFurniture = element
					setElementData(selectedFurniture, "Furniture->used", true)
					myFurnitures = {}
					load_my_furnitures()
				 end
			end
		end
	end
	if getElementData(localPlayer, "Furniture->isFurnitureOnHand") then
		if button == "left" and state == "down" and selectedFurniture then
			moveHandle = true
			return
			
		elseif button == "left" and state == "up" then
			moveHandle = false
			
			return
		end
	end
	if button == "left" and state == "down" and showEditInterface then
		local x, y, z = getElementPosition(selectedFurniture)
		local wX, wY = getScreenFromWorldPosition(x, y, z)
		for i = 0, #actions - 1 do
			if isInBox(wX - 170/2, wY - 150/2 + i * 24 + 26, 170, 20) then
				loadstring(actions[i + 1][3])()
				return
			end
		end	
	
	end
	if button == "left" and state == "down" and show_hifi and selectedHifi then
		if isInBox(sX/2 - 400/2, sY/2 - 170/2 + 100, dxGetTextWidth("Sesi Kapat       ",1,font_bold)+5, 20) then -- Stop
			local data = getElementData(selectedHifi, "Furnitures->Hifi")
			if tonumber(data.state) == 0 then 
				outputChatBox("Hi-fi zaten kapalı.",255,0,0)
				return
			end
			selectedHifiKey = 0
			for k, v in ipairs(getElementsByType("object")) do
				if tonumber(getElementDimension(v)) == tonumber(getElementDimension(localPlayer)) and tonumber(getElementModel(v)) == 2100 then
					local data = {id = k}
					triggerServerEvent("Furnitures->removeSound", localPlayer, localPlayer, data, selectedHifi)
				end
			end
			setElementData(selectedHifi, "Furnitures->Hifi", {channel = 1, state = 0})
			return
		end
		if isInBox(sX/2 - 400/2, sY/2 - 170/2 + 100+25, dxGetTextWidth("Menüyü Kapat       ",1,font_bold)+5, 20) then
		
			show_hifi = false
			return
		end
		for k, v in ipairs(radio_channels) do

			if isInBox(sX/2 - 400/2 + 396-150, sY/2 - 170/2 + (k-1) * 22, 150, 20) then
				selectedHifiKey = k
				for k, v in ipairs(getElementsByType("object")) do
					if tonumber(getElementDimension(v)) == tonumber(getElementDimension(localPlayer)) and tonumber(getElementModel(v)) == 2100 then
						local x, y, z = getElementPosition(v)
						triggerServerEvent("Furnitures->removeSound", localPlayer, localPlayer, {id = k})
						--
					
						local distance = getDistanceFromElement(selectedHifi, v)
						local data = {id = k, x, y, z, getElementDimension(v), getElementInterior(v), distance, k, tonumber(getElementData(selectedHifi, "Furnitures->Hifi").channel)}
				
						triggerServerEvent("Furnitures->playSound",	localPlayer, localPlayer, data, selectedHifi)
					end
				end
				setElementData(selectedHifi, "Furnitures->Hifi", {channel = k, state = 1})
			end
		end
	end
end
addEventHandler("onClientClick", root, Furnitures.click)


local soundBoxes = {}
local hifiState = {}
addEvent("Furnitures->playSoundC", true)
addEventHandler("Furnitures->playSoundC", root, function(data,object)
	local sound = playSound3D(tostring(radio_channels[data[8]][2]), data[1], data[2], data[3])
	if sound then

	end
	setElementDimension(sound, data[4])
	setElementInterior(sound, data[5])

	soundBoxes[data[7]] = sound
	x,y,z = getElementPosition(object)
	
	table.insert(hifiBoxes,{data.id,{x,y,z}})
	hifiState[data.id] = true

end)

addEvent("Furnitures->removeSoundC", true)
addEventHandler("Furnitures->removeSoundC", root, function(data,object)
	local key = tonumber(data.id)
	if isElement(soundBoxes[key]) then destroyElement(soundBoxes[key]) end
	
	table.remove(hifiBoxes,key)
	hifiState[data.id] = false
end)
function disableArrows(key,state)
	if selectedFurniture then
		if key == "arrow_r" or key == "arrow_l" or key == "arrow_u" or key == "arrow_d" then
			cancelEvent()
		end
	end
end
addEventHandler("onClientKey",root,disableArrows)
function Furnitures.onKey(key, state)
	if getElementData(localPlayer, "Furniture->isFurnitureOnHand") and key == "lshift" and state then
		cancelEvent()
	end
	if show_hifi then
		if key == "mouse_wheel_down" or key == "pgdn" then
			if hifi_scroll < #radio_channels - maxHifiShow then
				hifi_scroll = hifi_scroll + 1		
			end
		end
		if key == "mouse_wheel_up" or key == "pgup" then
			if hifi_scroll > 0 then
				hifi_scroll = hifi_scroll - 1		
			end
		end
	end
	if selectedFurniture then
		if key == "mouse_wheel_up" or key == "arrow_r" and state then
			local rx, ry, rz = getElementRotation(selectedFurniture)
			local plus = 1
			if getKeyState("lshift") then
				plus = 2
			end
			setElementRotation(selectedFurniture, rx, ry, rz + plus)
		end	
		if key == "mouse_wheel_down" or key == "arrow_l" and state then
			local rx, ry, rz = getElementRotation(selectedFurniture)
			local plus = 1
			if getKeyState("lshift") then
				plus = 2
			end
			setElementRotation(selectedFurniture,rx, ry, rz - plus)
		end
	end
	if key == "e" and state and selectedFurniture and getElementData(localPlayer, "Furniture->isFurnitureOnHand") then
		local _x, _y, _z = getElementPosition(selectedFurniture)
		local _, _, _rot = getElementRotation(selectedFurniture)
		local _int, _dim = getElementInterior(selectedFurniture),getElementDimension(selectedFurniture)
		local data = {x = _x, y = _y, z = _z, int = _int, dim = _dim, rot = _rot}
		triggerServerEvent("Furnitures->drop", localPlayer, localPlayer, selectedFurniture, _x,_y,_z,_int,_dim,_rot)
		setElementData(selectedFurniture, "Furniture->used", false)
		setElementData(localPlayer, "Furniture->isFurnitureOnHand", false)
		selectedFurniture = nil
	end
	if not selectedFurniture then return end
	if key == "pgup" or key == "pgdn" and state then cancelEvent() end
end
addEventHandler("onClientKey", root, Furnitures.onKey)
function Furnitures.getRotation()
	cam = Camera.matrix:getRotation():getZ()
	cam2 = tonumber(string.format("%.0f",cam/90))*90--90 ve katları
	return cam or 0
end


function isInBox(xS,yS,wS,hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sX, cursorY*sY
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

addEvent("Furnitures->receiveElement", true)
addEventHandler("Furnitures->receiveElement", root, function(element)
	selectedFurniture = element
	setElementRotation(selectedFurniture,0,0,Furnitures.getRotation())
end)

function getDistanceFromElement(from, to)
	if not from or not to then return end
	local x, y, z = getElementPosition(from)
	local x1, y1, z1 = getElementPosition(to)
	return getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
end
local showDrawn = false
local showState = "first"

function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end


--bundan sonrasını ekle.

addEvent("createFurnObject",true)
addEventHandler("createFurnObject",root,function(data)
	if data["placed"] == 1 then

		local obj = createObject(data["model"], data["x"],data["y"],data["z"], 0, 0, data["rot"])
		
		setElementData(obj,"furnObject",true)
		setElementData(obj, "Furnitures->isFurniture", true)
		setElementData(obj, "Furnitures->id", data["id"])
		setElementData(obj, "Furnitures->owner", data["owner"])
		setElementData(obj, "Furnitures->Hifi", {channel = 1, state = 0})
		setElementData(obj, "Furnitures->data", data["allData"])
		setElementDimension(obj, data["dimension"])
		setElementInterior(obj, data["interior"])
		setElementDoubleSided(obj, true)
		--outputChatBox("furniture created succesfuly.")
	end
end)

addEvent("destroyFurnObject",true)
addEventHandler("destroyFurnObject",root,function(int,dim)
	for k,v in ipairs(getElementsByType("object")) do
		int2,dim2 = getElementInterior(v),getElementDimension(v)
		if (int == int2) and (dim == dim2) then
			destroyElement(v)
			--outputChatBox("furniture removed succesfuly.")
		end
	end
end)

function Furnitures.openWeaponController()
	if selectedObject and isElement(selectedObject) then
		local object = createObject(355, 0, 0, 0)
		
		setElementDimension(object, getElementDimension(selectedObject))
		setElementInterior(object, getElementInterior(selectedObject))
		attachElements(object, selectedObject, 0.4, -0.2, 1.1, 90, -10, 180)
		outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."AK-47 markalı silah başarıyla masaya bırakıldı.", 255, 255, 255, true)
	end
end