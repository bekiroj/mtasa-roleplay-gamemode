--MAXIME
local myInteriorsToDraw = {}
local myDrawnInteriorBlips = {}
local refreshRate = 5 -- minutes
function getAllMyInteriors()
	clearMyDrawnInteriorBlips()
	myInteriorsToDraw = {}
	for key, interior in ipairs(getElementsByType("interior")) do
		if isElement(interior) then
			local status = getElementData(interior, "status")
			if tonumber(status[4]) == getElementData(localPlayer, "dbid") then
				local entrance = getElementData(interior, "entrance")
				if tonumber(entrance[4]) == 0 and tonumber(entrance[5]) == 0 then
					table.insert(myInteriorsToDraw, {tonumber(entrance[1]), tonumber(entrance[2]), tonumber(entrance[3]), tonumber(status[1])})
					--outputDebugString("myInteriorsToDraw")
				else
					locateMyParentInteriorInWorldMap(interior, tonumber(status[1]))
				end
			end
		end
	end
end

function locateMyParentInteriorInWorldMap(theInterior, myInteriorType)
	if not isElement(theInterior) then
		return false
	end

	local entrance = getElementData(theInterior, "entrance")
	if tonumber(entrance[4]) ~= 0 and tonumber(entrance[5]) ~= 0 then
		local nextInterior = getInteriorFromID(tonumber(entrance[5]))
		if nextInterior and isElement(nextInterior) then
			locateMyParentInteriorInWorldMap(nextInterior, myInteriorType)
		else
			return false
		end
	else
		local status = getElementData(theInterior, "status")
		if tonumber(status[4]) == getElementData(localPlayer, "dbid") then
			return false
		end
		
		table.insert(myInteriorsToDraw, {tonumber(entrance[1]), tonumber(entrance[2]), tonumber(entrance[3]), myInteriorType} )
	end
end

function getInteriorFromID(intID)
	for key, interior in ipairs(getElementsByType("interior")) do
		if interior and isElement(interior) and getElementData(interior, "dbid") == tonumber(intID) then
			return interior
		end
	end
	return false
end

local timerDraw = nil
function drawAllMyInteriorBlips()
	if timerDraw and isElement(timerDraw) and isTimer(timerDraw) then
		killTimer(timerDraw)
		timerDraw = nil
	end
	timerDraw = setTimer(function ()
		getAllMyInteriors()
		for i, interior in pairs(myInteriorsToDraw) do
			local icon = nil

			if interior[4] == 1 then
				icon = 32
			else
				icon = 31
			end
			
			local blip = createBlip(interior[1], interior[2], interior[3], icon )
			if blip then
				table.insert(myDrawnInteriorBlips, blip)
				--outputDebugString("Interior blip drew.")
			end
		end
	end, 5000, 1)
end
addEvent("drawAllMyInteriorBlips", true)
addEventHandler("drawAllMyInteriorBlips", localPlayer, drawAllMyInteriorBlips)

function clearMyDrawnInteriorBlips()
	if #myDrawnInteriorBlips > 0 then
		for i, blip in pairs(myDrawnInteriorBlips) do
			if isElement(blip) then
				destroyElement(blip)
			end
		end
	end
end


function blipRefresher()
	drawAllMyInteriorBlips()
	setTimer(function()
		drawAllMyInteriorBlips()
	end, refreshRate*1000*60, 0)
end
addEventHandler("onClientResourceStart", resourceRoot, blipRefresher)