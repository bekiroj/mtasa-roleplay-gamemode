local sx, sy = guiGetScreenSize()
local font = dxCreateFont("files/Roboto.ttf", 10)
local preview = exports["vrp_object_preview"]

local categoryIndex = 0
local lastClick = 0
local currentRow, maxRow = 1, 12
local selectedWearable = 0

local shownWShop = false;
local setPosition = false;

local shopPed = createPed(28, 204.00390625, -41.6708984375, 1001.8046875);
setElementRotation(shopPed, 0, 0, 178.98376464844)
shopPed:setData("nametag", true)
shopPed.frozen = true
shopPed.dimension = 29
shopPed.interior = 1

addEventHandler("onClientClick", root,
	function(b,s,_,_,_,_,_,element)
		if element and element.type == "ped" and element == shopPed then
			if b == "right" then
				if not shownWShop then
					tempObject = createObject(1239, 0, 0, 0);
					tempObject.interior = localPlayer.interior
					tempObject.dimension = localPlayer.dimension
					preview_element = preview:createObjectPreview(tempObject,0,0,0,sx/2-500/2+200,sy/2-500/2,500,500,false,true)
					shownWShop = true
				end
			end
		end
	end
)

addEventHandler("onClientRender", root,
	function()
		if not shownWShop then return end
		w, h = 530, 395
		x, y = sx/2-w/2, sy/2-h/2
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
		x, y, w, h = x+2, y+2, w-4, h-4
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
		dxDrawRectangle(x, y, w, 25, tocolor(0, 0, 0, 80))
		dxDrawText("Aksesuar Mağazası - Valhalla", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")

		y, h = y+26, h-28
		x, w = x+2, w-4
		x, y, w, h = x+2, y+2, w-4, h-4
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 60))
		
		
		local index = 0
		for i = 1, 13 do
			if i % 2 ~= 0 then
				dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 160))
			else
				dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 120))
			end
			if isInSlot(x, y+(index*25), w, 25) then
				dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 50))
			end
			index = index + 1
		end
		local index = 0
		
		local latestRow = currentRow + maxRow - 1
		for count, value in pairs(getWearables()) do
			maxRow = 4
			
			if isInSlot(x, y+(index*25), w, 25) then
				dxDrawText("♦ "..value['name'], x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
				if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
					lastClick = getTickCount()
					if categoryIndex ~= count then
						categoryIndex = count
						currentRow = 1
						selectedWearable = 0
					else
						categoryIndex = 0
					end
				end
			else
				dxDrawText("♦ "..value['name'], x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(225, 225, 225), 1, font, "left", "center")
			end
			if categoryIndex == count then
				for id, data in ipairs(value['list']) do
					if id >= currentRow and id <= latestRow then
						id = id - currentRow + 1
						index = index + 1
						if isInSlot(x, y+(index*25), w, 25) then
							dxDrawText("- ("..id..") "..data['dff'].." ["..data['price'].."$]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
							if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
								lastClick = getTickCount()
								selectedWearable = id
								price = data['price']
								tempObject.model = tonumber(data["modelid"])
							end
						else
							if selectedWearable == id  then
								dxDrawText("- ("..id..") "..data['dff'].." ["..data['price'].."$]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(85, 155, 255), 1, font, "left", "center")
							else
								dxDrawText("- ("..id..") "..data['dff'].." ["..data['price'].."$]", x+5, y+(index*25), w+5, 25+(y+(index*25)), tocolor(255, 255, 255), 1, font, "left", "center")
							end
						end
					end
				end
			end
			index = index + 1
		end
		y = y+(13*25)+6
		w = w/2-4
		dxDrawRectangle(x, y, w, 25, tocolor(85, 155, 255, 100))
		dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
		if isInSlot(x, y, w, 25) then
			dxDrawRectangle(x, y, w, 25, tocolor(85, 155, 255, 50))
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount();
				if selectedWearable ~= 0 then
					triggerServerEvent("wearable.buyItem", localPlayer, localPlayer, tempObject.model, price);
					shownWShop = false;
					currentRow = 1;
					selectedWearable = 0;
					categoryIndex = 0;
					if preview_element then
						preview:destroyObjectPreview(preview_element);
						destroyElement(tempObject)
					end
				end
			end
		end
		dxDrawText("Aksesuarı Satın Al", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
		
		x = x+w+4
		dxDrawRectangle(x, y, w, 25, tocolor(232, 65, 24, 100))
		dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
		if isInSlot(x, y, w, 25) then
			dxDrawRectangle(x, y, w, 25, tocolor(232, 65, 24, 50))
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount();
				shownWShop = false;
				currentRow = 1;
				selectedWearable = 0;
				categoryIndex = 0;
				if preview_element then
					preview:destroyObjectPreview(preview_element);
					destroyElement(tempObject)
				end
				
			end
		end
		dxDrawText("Arayüzü Kapat", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
	end
);

addEventHandler("onClientResourceStop", resourceRoot,
	function()
		if preview_element then
			preview:destroyObjectPreview(preview_element);
		end
	end
)

bindKey("mouse_wheel_down", "down", 
	function()
		if categoryIndex ~= 0 and shownWShop then
			if not getElementData(localPlayer, "loggedin") == 1 then return end

			if currentRow < #getWearables()[categoryIndex]['list'] - (maxRow - 1) then
				currentRow = currentRow + 1
			end
		end
	end
)

bindKey("mouse_wheel_up", "down", 
	function()
		if categoryIndex ~= 0 and shownWShop then
			if not getElementData(localPlayer, "loggedin") == 1 then return end
			if currentRow > 1 then
				currentRow = currentRow - 1
			end
		end
	end
)

bindKey("pgdn", "down", 
	function()
		if categoryIndex ~= 0 and shownWShop then
			if not getElementData(localPlayer, "loggedin") == 1 then return end

			if currentRow < #getWearables()[categoryIndex]['list'] - (maxRow - 1) then
				currentRow = currentRow + 1
			end
		end
	end
);

bindKey("pgup", "down", 
	function()
		if categoryIndex ~= 0 and shownWShop then
			if not getElementData(localPlayer, "loggedin") == 1 then return end
			if currentRow > 1 then
				currentRow = currentRow - 1
			end
		end
	end
);

function isInSlot(xS, yS, wS, hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end