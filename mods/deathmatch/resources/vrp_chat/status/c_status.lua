-- @bekiroj 18 temmuz 2020
local textsToDraw = {}
local font = exports.vrp_fonts:getFont("Roboto", 10)
local fontHeight = 20
local characteraddition = 50
local statusColor = {145, 145, 145}

function addStatus(message)
	local infotable = {source,message,1}
	for i,k in pairs(textsToDraw) do
		if k[1] == source then
			removeStatus(k)
		end
	end

	for i,infotable in ipairs(textsToDraw) do
		if infotable[1] == source then
			infotable[3] = infotable[3] + 1
			notfirst = true
		end
	end
	local infotable = {source,message,-1}
	table.insert(textsToDraw,infotable)

end

function removeStatus(infotable)
	for i,v in ipairs(textsToDraw) do
		if v[1] == infotable[1] and v[2] == infotable[2] then
			table.remove(textsToDraw,i)
			break
		end
	end
end

function getStatusTextsToRemove()
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			removeStatus(v)
		end
	end
end

function clearStatusTexts(source)
	for i,v in ipairs(textsToDraw) do
		if v[1] == source then
			removeStatus(v)
		end
	end
end
addEvent("clearStatus", true)
addEventHandler("clearStatus", getRootElement(), clearStatusTexts)

function displayStatus()
	for i,infotable in ipairs(textsToDraw) do
		local camPosXl, camPosYl, camPosZl = getPedBonePosition (infotable[1], 6)
		local camPosXr, camPosYr, camPosZr = getPedBonePosition (infotable[1], 7)
		local x,y,z = (camPosXl + camPosXr) / 2, (camPosYl + camPosYr) / 2, (camPosZl + camPosZr) / 2
		--local posx,posy = getScreenFromWorldPosition(x,y,z+0.25)
		local cx,cy,cz = getCameraMatrix()
		local px,py,pz = getElementPosition(infotable[1])
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,px,py,pz)
		local posx,posy = getScreenFromWorldPosition(x,y,z+0.020*distance+0.10)
		local blocking = getPedOccupiedVehicle(getLocalPlayer()) or getPedOccupiedVehicle(infotable[1]) or nil
		if posx and distance <= 45 and isLineOfSightClear(cx,cy,cz,px,py,pz,true,true,false,true,false,true,true, blocking) then -- change this when multiple ignored elements can be specified
			local width = dxGetTextWidth(infotable[2],1,font)
			
			dxDrawRectangle(posx - (12 + (0.5 * width)), posy - 2, width + 23, 19, tocolor(20, 20, 20, 200))
		    dxDrawRectangle(posx - (12 + (0.5 * width)), posy + 16, width + 23, 1, tocolor(145, 145, 145, 255))

			dxDrawRectangle(posx - (3 + (0.5 * width)),posy - 2,width + 5,19,tocolor(0,0,0,10))
			dxDrawRectangle(posx - (6 + (0.5 * width)),posy - 2,width + 11,19,tocolor(0,0,0,40))
	    	dxDrawRectangle(posx - (8 + (0.5 * width)),posy - 1,width + 15,17,tocolor(0,0,0,10))
	        dxDrawRectangle(posx - (10 + (0.5 * width)),posy - 1,width + 19,17,tocolor(0,0,0,40))
	        dxDrawRectangle(posx - (10 + (0.5 * width)),posy + 1,width + 19,13,tocolor(0,0,0,10))
			dxDrawRectangle(posx - (12 + (0.5 * width)),posy + 1,width + 23,13,tocolor(0,0,0,40))
		    dxDrawRectangle(posx - (12 + (0.5 * width)),posy + 4,width + 23,7,tocolor(0,0,0,10))

			-- dxDrawText(infotable[2],posx - (0.5 * width),posy - (infotable[3] * fontHeight),posx - (0.5 * width),posy - (infotable[3] * fontHeight),tocolor(unpack(statusColor)),1,"default-bold","left","top",false,false,false)
			dxDrawText(infotable[2], posx - (0.5 * width), posy, posx - (0.5 * width), posy - (i * fontHeight), tocolor(145, 145, 145, 255), 1, font, "left", "top", false, false, false)
		end
	end
end
addEvent("onClientStatus", true)
addEventHandler("onClientStatus",getRootElement(),addStatus)

addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()), function()
	addEventHandler("onClientPlayerQuit",getRootElement(),getStatusTextsToRemove)
	--addEventHandler("onClientRender",getRootElement(),displayStatus)
	setTimer(displayStatus, 0, 0)
end)