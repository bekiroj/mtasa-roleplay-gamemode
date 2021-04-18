local shopPed = createPed(240, 1878.3759765625, -2457.20703125, 13.579086303711,91.811401367188)
setElementFrozen(shopPed,true)
setElementDimension(shopPed, 31)
setElementInterior(shopPed, 27)
setElementData(shopPed,"nametag",1)
setElementData(shopPed,"furniture:ped",true)

local key = 1--selectedRow
local showShop = false
local selectedCategory = 1
local lastClick = 0
function pedDamage()
	if(getElementData(source, "furniture:ped")) then
		cancelEvent()
	end
end
addEventHandler("onClientPedDamage",  getRootElement(), pedDamage)

function PedClick(button, state, absX, absY, wx, wy, wz, element)
	if element and getElementData(element,"furniture:ped") then
		if state == "down" and button == "right" and showShop == false then
			local x, y, z = getElementPosition(getLocalPlayer())
			if getDistanceBetweenPoints3D(x, y, z, wx, wy, wz) <= 4 then
				showShop = true
				loadGui()
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), PedClick, true)

function loadGui()
	selectedCategory = 1
	key = 1
	addEventHandler("onClientClick",root,clickShop)
	bindKey("a","down",backKey)--geri
	bindKey("arrow_l","down",backKey)--geri
	bindKey("arrow_r","down",nextKey)--ileri
	bindKey("enter","down",orderFurniture)

	bindKey("arrow_u","down",backCategory)--yukarı
	bindKey("arrow_d","down",nextCategory)--aşağı
	showCursor(true)
	bindKey("d","down",nextKey)--ileri
	bindKey("backspace","down",closePanel)
	addEventHandler("onClientRender",root,drawnShop)
end
function closePanel()
	removeEventHandler("onClientClick",root,clickShop)
	removeEventHandler("onClientRender",root,drawnShop)
	showShop = false
	showCursor(false)
	unbindKey("a","down",backKey)--geri
	
	unbindKey("enter","down",orderFurniture)	
	unbindKey("arrow_l","down",backKey)--geri
	unbindKey("arrow_r","down",nextKey)--ileri
	
	unbindKey("d","down",nextKey)--ileri

	unbindKey("arrow_u","down",backCategory)--yukarı
	unbindKey("arrow_d","down",nextCategory)--aşağı
	
	unbindKey("backspace","down",closePanel)
end

function backKey()
	if key <= 1 then
		return
	end
	key = key - 1
end

function orderFurniture()
	
		lastClick = getTickCount()
		if #myFurnitures + 1 > 10 then 
			outputChatBox("[!]#ffffff Maximum 10 mobilya alabilirsin!",255,0,0,true)
			return
		end
		if exports["vrp_global"]:hasMoney(localPlayer,furnitures[selectedCategory][key].price) then
			triggerServerEvent("furniture:takeMoney",localPlayer,localPlayer,furnitures[selectedCategory][key].price)
			triggerServerEvent("Furnitures->insert", localPlayer, getElementData(localPlayer, "dbid"), furnitures[selectedCategory][key].model)
			myFurnitures[#myFurnitures + 1] = {}
		else
			outputChatBox("[!]#ffffff Bu mobilyayı alacak kadar yeterli paranız yok!",255,0,0,true)
		end
end

function backCategory()
	if selectedCategory <= 1 then
		return
	end
	selectedCategory = selectedCategory -1
	key = 1
end

function nextCategory()
	if selectedCategory >= #furnitures then
		return
	end
	selectedCategory = selectedCategory + 1
	key = 1
end

function nextKey()
	if key >= #furnitures[selectedCategory] then
		return
	end
	key = key + 1
end

local sx, sy = guiGetScreenSize()
local font = dxCreateFont("files/5.ttf",10)
local font_small = dxCreateFont("files/5.ttf",9)
local font_big = dxCreateFont("files/5.ttf",50)
function drawnShop()
	x,y,w,h = sx/2-650/2-100,sy/2-450/2,650,450
	dxDrawRectangle(x+w+30,y,170,h,tocolor(0,0,0,130))
	dxDrawRectangle(x+w+34,y+4,170-8,h-8,tocolor(10,10,10,150))
	dxDrawRectangle(x+w+34,y+4,170-8,20,tocolor(35,35,35,120))
	dxDrawText(" Kategoriler ve Yardım",x+w+43,y+4,170-8+(x+w+43),20+(y+4),tocolor(255,255,255),1,font_small,"left","center",false,false,false,true)

	
		for i,v in ipairs(furnitures) do
			if isInSlot(x+w+43,y+3+23.5*i,dxGetTextWidth(v.name,1,font_small),15) then
				if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
					lastClick = getTickCount()
					selectedCategory = i
					key = 1
				end
			end
			if selectedCategory ~= i then
				dxDrawText(v.name,x+w+43,y+3+23*i,170-8+(x+w+43),23+(y+23*i),tocolor(255,255,255),1,font_small,"left","center",false,false,false,true)
			else
				dxDrawText(" "..v.name,x+w+43,y+3+23*i,170-8+(x+w+43),23+(y+23*i),tocolor(unpack(color["rgb"])),1,font_small,"left","center",false,false,false,true)
			end
		end
	

	dxDrawRectangle(x,y,w,h,tocolor(0,0,0,130))
	dxDrawRectangle(x+4,y+4,w-8,h-8,tocolor(10,10,10,150))
	dxDrawRectangle(x+4,y+4,w-8,20,tocolor(35,35,35,120))
	tx,ty,tw,th = x+4,y+4,w-8,20
	dxDrawText("  "..color["hex"].."Valhalla#ffffff - Mobilya Mağazası",tx,ty,tw+tx,th+ty,tocolor(255,255,255),1,font,"center","center",false,false,false,true)

	dxDrawText("",x+20,y,w+x+20,h+y,tocolor(255,255,255),1,font_big,"left","center")
	

	dxDrawText("",x-20,y,w+x-20,h+y,tocolor(255,255,255),1,font_big,"right","center")
	
	if key >= 0 then
		src = "furnitures/"..furnitures[selectedCategory][key].model..".png"
		if furnitures[selectedCategory][key].isRenderable then
			dxDrawImage(x+w/2-128,y+h/2-128,256,256,src)
		end
		if not furnitures[selectedCategory][key].isRenderable then text = " Resim yok" else if furnitures[selectedCategory][key].isModding then text = "" else text = "" end end
		if furnitures[selectedCategory][key].isModding then text2 = " Modlu obje" else text2 = "" end
		dxDrawText(" Mobilya Adı: "..furnitures[selectedCategory][key].name.."\n "..furnitures[selectedCategory][key].price.."\n"..text..text2,x+w/2-250/2,y+h-86,250+(x+w/2-250/2),40+(y+h-86),tocolor(255,255,255),1,font,"center","bottom")
	end
	
	drawButton("Satın al",x+w/2-200/2-200,y+h-50,200,30,color["hex"].."aa",false, false, false, nil, true)
	
	drawButton("Vazgeç",x+w/2-200/2+200,y+h-50,200,30,"#c0392baa",false, false, false, nil, true)
	
end

function clickShop(button, state)
	if button == "left" and state == "down" then
		for i,v in ipairs(furnitures) do
			if isInSlot(x+w+43,y+3+23.5*i,dxGetTextWidth(v.name,1,font_small),15) then
				
				selectedCategory = i
				key = 1
				return
				
			end
		end
	
		if isInSlot(x+20,y+w/2-120,dxGetTextWidth("",1,font_big),60) then	
			if key <= 1 then
			else
				key = key -1
			end
		end

		if isInSlot(x+w-50,y+w/2-120,dxGetTextWidth("",1,font_big),60) then
			if key >= #furnitures[selectedCategory] then
			
			else
				key = key + 1
			end	
		end
		
		if isInSlot(x+w/2-200/2-200,y+h-50,200,30) then
			if #myFurnitures + 1 > 10 then 
				outputChatBox("[!]#ffffff Maximum 10 mobilya alabilirsin!",255,0,0,true)
				return
			end
			if exports["vrp_global"]:hasMoney(localPlayer,furnitures[selectedCategory][key].price) then
				triggerServerEvent("furniture:takeMoney",localPlayer,localPlayer,furnitures[selectedCategory][key].price)
				triggerServerEvent("Furnitures->insert", localPlayer, getElementData(localPlayer, "dbid"), furnitures[selectedCategory][key].model)
				myFurnitures[#myFurnitures + 1] = {}
			else
				outputChatBox("[!]#ffffff Bu mobilyayı alacak kadar yeterli paranız yok!",255,0,0,true)
			end
			return
		end
		if isInSlot(x+w/2-200/2+200,y+h-50,200,30) then
			closePanel()
			return
		end
	end
end

function isInSlot(x, y, w, h)
	local cX, cY = getCursorPosition()
	cX, cY = cX * sx, cY * sy
	if isInBox2(x, y, w, h, cX, cY) then
		return true
	else
		return false
	end
end
function isInBox2(dX, dY, dSZ, dM, eX, eY)
    if(eX >= dX and eX <= dX+dSZ and eY >= dY and eY <= dY+dM) then
        return true
    else
        return false
    end
end