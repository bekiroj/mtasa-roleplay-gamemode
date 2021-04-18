local sx, sy = guiGetScreenSize()
myFurnitures = {}

local awesomeFont = dxCreateFont("files/5.ttf",10)
local awesomeFontM = dxCreateFont("files/5.ttf",9)

local selectedItem = 0
local showTexture = false
local currentRow = 1
local latestRow = 1
local maxRow = math.floor(sx/90)

local activeTab = "homepage"
local activeAltTab = false
local activeTabS = {{" Ana sayfa","homepage"}, {" Mobilyalar","furn"}, {" Kaplamalar","texs"}}
local activeAltTabs = {
	["homepage"] = {},
	["furn"] = {},
	["texs"] = {
		{"Duvar Kaplamaları", "walltexs"},
		{"Taban/Tavan Kaplamaları", "floortexs"},
		{"Kapı Kaplamaları", "doortexs"},
	}
}

local s_color = {84, 160, 255}
local hex = "#54a0ff"

local showed_myFurnitures = false
local requested = false
local selected_furniture = 0
local lastClick = 0

local AlphaArray = {}
for i=0, 99 do
	AlphaArray[i] = 0
end
local TextAlphaArray = {}
for i=0, 999 do
	TextAlphaArray[i] = 0
end

function draw()
	if not showed_myFurnitures then return end
	
	if getElementInterior(localPlayer) == 0 and getElementDimension(localPlayer) == 0 then
		executeCommandHandler("editor")
		return
	end

	mx,my,mw,mh = 0, sy-150, sx, 150
	dxDrawRectangle(mx,my,mw,mh,tocolor(25,25,25,240))
	dxDrawRectangle(mx,my,mw,30,tocolor(35,35,35,230))

	tabRowHeight = 0
	altTabHeight = 0
	for k,v in pairs(activeTabS) do
		text = v[1]
		if activeTab == v[2] then
		
			dxDrawText(text,mx+10+tabRowHeight,my+5,mw,30,tocolor(s_color[1],s_color[2],s_color[3]),1,awesomeFont,"left","top")
			
			
			for index, row in ipairs(activeAltTabs[v[2]]) do
				if activeAltTab == row[2] then
					dxDrawText(row[1],mx+15+tabRowHeight+(dxGetTextWidth(text,1,awesomeFont))+altTabHeight,my+5,mw,30,tocolor(s_color[1],s_color[2],s_color[3]),1,awesomeFontM,"left","top")
				else
					dxDrawText(row[1],mx+15+tabRowHeight+(dxGetTextWidth(text,1,awesomeFont))+altTabHeight,my+5,mw,30,tocolor(225,225,225,225),1,awesomeFontM,"left","top")
				end

				altTabHeight = altTabHeight + 10 + dxGetTextWidth(row[1], 1, awesomeFontM)
			end

		else
			dxDrawText(text,mx+10+tabRowHeight,my+5,mw,30,tocolor(255,255,255),1,awesomeFont,"left","top")
		end
		tabRowHeight = tabRowHeight + 15 + dxGetTextWidth(text,1,awesomeFont)
	end
	if activeTab == "homepage" then
		dxDrawText("Mobilya Yönetimi:\nMobilya mağazasından aldığınız mobilyaları burada evinize yerleştirebilirsiniz.\nEvinizdeki duvara, tabana, tavana ve kapılara kaplama yapabilirsiniz.\nMobilyayı yerleştirirken fare ile tıkladığınız yerde konumlanır.", mx+10, my+40, mw, mh, tocolor(255, 255, 255), 1, awesomeFont, "left", "top")
	elseif activeTab == "furn" then
		for index, value in ipairs(myFurnitures) do
			if fileExists("furnitures/"..(value.model)..".png") then
				dxDrawImage(mx+25+((index-1)*86),my+30,84,84,"furnitures/"..(value.model)..".png")
			end
			dxDrawRectangle(mx+25+((index-1)*86),my+114,84,20,tocolor(20,20,20,160))
			
			if selected_furniture == index then
				dxDrawText(findNameByModel(tonumber(value.model)),mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
				dxDrawText(findNameByModel(tonumber(value.model)),mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(s_color[1],s_color[2],s_color[3]),1,awesomeFontM,"center","center")
			else
				dxDrawText(findNameByModel(tonumber(value.model)),mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
				dxDrawText(findNameByModel(tonumber(value.model)),mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
			end
		end
	elseif activeTab == "texs" then
		if activeAltTab then
			latestRow = currentRow + maxRow - 1
			-- left
			dxDrawRectangle(mx, my+30, 20, mh-15, tocolor(30, 30, 30, 120))
			dxDrawText("", mx, my+30, 20+mx, mh-15+(my+30), tocolor(255, 255, 255), 1, awesomeFont, "center", "center")
			--right
			dxDrawRectangle(sx-20, my+30, 20, mh-15, tocolor(30, 30, 30, 120))
			dxDrawText("", sx-20, my+30, 20+sx-20, mh-15+(my+30), tocolor(255, 255, 255), 1, awesomeFont, "center", "center")
			
			for index, value in ipairs(textures[activeAltTab]) do

				if index >= currentRow and index <= latestRow then
					index = index - currentRow + 1
					if fileExists(value[1]) then
						dxDrawImage(mx+25+((index-1)*86),my+30,84,84,value[1])
					end
					dxDrawRectangle(mx+25+((index-1)*86),my+114,84,20,tocolor(20,20,20,160))
					
					if selected_furniture == index then
						dxDrawText(value.price.."$",mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
						dxDrawText(value.price.."$",mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(s_color[1],s_color[2],s_color[3]),1,awesomeFontM,"center","center")
					else
						dxDrawText(value.price.."$",mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
						dxDrawText(value.price.."$",mx+25+((index-1)*86),my+114,84+(mx+25+((index-1)*86)),20+(my+114),tocolor(255,255,255,255),1,awesomeFontM,"center","center")
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender", root, draw)

function onClientClick(button, state)
	if button == "left" and state == "down" and showed_myFurnitures then
		
		mx,my,mw,mh = 0, sy-150, sx, 150
		tabRowHeight = 0
		altTabHeight = 0

		for k,v in pairs(activeTabS) do
			text = v[1]
			
			if activeTab == v[2] then
				for index, row in ipairs(activeAltTabs[v[2]]) do
					if isInBox(mx+15+tabRowHeight+(dxGetTextWidth(text,1,awesomeFont))+altTabHeight,my+5,dxGetTextWidth(row[1], 1, awesomeFontM),30) then
						activeAltTab = row[2]
						currentRow = 1
					end
					altTabHeight = altTabHeight + 10 + dxGetTextWidth(row[1], 1, awesomeFontM)
				end
			end
			if isInBox(mx+10+tabRowHeight-2,my,dxGetTextWidth(text,1,awesomeFont)+4,30) then
				activeTab = v[2]
			end
			
			tabRowHeight = tabRowHeight + 15 + dxGetTextWidth(text,1,awesomeFont)
		end
		if activeTab == "furn" then
			for index, value in ipairs(myFurnitures) do
				if isInBox(mx+25+((index-1)*86),my+114,84,20) then
					if selected_furniture ~= index then
						selected_furniture = index
					else
						if getElementData(localPlayer, "Furniture->isFurnitureOnHand") then
							outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Zaten bir mobilyayı düzenliyorsun.", 255, 255, 255, true)
							return
						end
						if tonumber(myFurnitures[selected_furniture].model) == 2224 and getFurnituresCount(2224, getElementDimension(localPlayer)) > 0 then
							outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Bu objeyi koyma limitine geldiniz!", 255, 255, 255, true)
							return
						end
						if tonumber(myFurnitures[selected_furniture].model) == 2232 and getFurnituresCount(2232, getElementDimension(localPlayer)) + 1 > 4 then
							outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Bu objeyi koyma limitine geldiniz!", 255, 255, 255, true)
							return
						end
						triggerServerEvent("Furnitures->create", localPlayer, localPlayer, myFurnitures[selected_furniture])
						table.remove(myFurnitures, selected_furniture)
						selected_furniture = -1
					end
				end
			end
		elseif activeTab == "texs" and activeAltTab then
			if isInBox(sx-20, my+30, 20, mh-15) then-- sağa
				if currentRow < #textures[activeAltTab] - (maxRow - 1) then
					currentRow = currentRow + 1
				end
				return
			end
			if isInBox(mx, my+30, 20, mh-15) then-- sola
				if currentRow > 1 then
					currentRow = currentRow - 1
				end
				return
			end
			for index, value in ipairs(textures[activeAltTab]) do

				if isInBox(mx+25+((index-1)*86),my+30,84,84) then
					executeCommandHandler("editor")
					openTextureEditor(value[1],0,value.price)
				end
			end
		end
	end
end
addEventHandler("onClientClick", root, onClientClick)



addCommandHandler("editor", function(command)
	dimension = getElementDimension(localPlayer)
	if exports.vrp_global:hasItem ( localPlayer, 4, dimension ) then
		x,y,z = getElementPosition(localPlayer)
		interior,dimension = tonumber(getElementInterior(localPlayer)),tonumber(getElementDimension(localPlayer))
		if not showed_myFurnitures then
			--setElementAlpha(localPlayer,0)
			--maxlimit = {x-25,y-25,z-60,x+25,y+25,z+25}
			--setFreecamEnabled(x,y,z+5,maxlimit,interior,dimension)

			showed_myFurnitures = true
			myFurnitures = {}
			load_my_furnitures()
		else
			--setElementAlpha(localPlayer,255)
			--setFreecamDisabled()
			--setCameraTarget(localPlayer)
			showed_myFurnitures = false
			selected_furniture = 0
			myFurnitures = {}
			if isElement(window) then destroyElement(window) end
			if isElement(texW) then  destroyElement(texW) end
		end
	end
end)

addEvent("closeTexPanel",true)
addEventHandler("closeTexPanel",root,function() 
	showTexture = false
	selectedItem = 0

end)

addEvent("openTexPanel",true)
addEventHandler("openTexPanel",root,function() 
	showTexture = true

end)

function getFurnituresCount(model, dimension)
	if model and dimension then
		local count = 0
		for k, v in ipairs(getElementsByType("object")) do
			if tonumber(getElementDimension(v)) == tonumber(dimension) and tonumber(getElementModel(v)) == tonumber(model) then
				count = count + 1
			end
		end
		return count
	end
end

function load_my_furnitures()
	triggerServerEvent("Furnitures->loadMyFurnitures", localPlayer, getElementData(localPlayer, "dbid"))
end
load_my_furnitures()
setElementData(localPlayer, "Furniture->isFurnitureOnHand",false)
addEvent("GetMyFurnitures", true)
addEventHandler("GetMyFurnitures", root, function(data)
	myFurnitures = {}
	myFurnitures = data
	requested = true
end)

function findNameByModel(model)
	for i=1, #furnitures do
		for i2, v in ipairs(furnitures[i]) do
			if tonumber(v.model) == model then
				return v.name
			end
		end
	end
	return false
end

function isInBox(xS,yS,wS,hS)
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