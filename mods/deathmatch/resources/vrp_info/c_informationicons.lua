-- scripted by Jesse
local sx, sy = guiGetScreenSize()
local pickupsCache = {}

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		--create first details
		for index, value in ipairs(getElementsByType("pickup")) do
			if not pickupsCache[value] then
				if isElementStreamedIn(value) and source.dimension == localPlayer.dimension then
					createCache(value)
				end
			end
		end
		setTimer(drawnPickupText, 7, 0)
	end
)

addEventHandler("onClientElementStreamIn", root,
    function()
        if source.type == "pickup" then
        	if source.dimension == localPlayer.dimension then
            	createCache(source)
            end
        end
    end
)

addEventHandler("onClientElementStreamOut", root,
    function()
        if source.type == "pickup" then
        	if source.dimension == localPlayer.dimension then
           		destroyCache(source)
           	end
        end
    end
)

local allowedModels = {
	[1239] = true,
	[1318] = true,
	[1274] = true
}

function createCache(pickup)
 	if pickup and isElement(pickup) and allowedModels[getElementModel(pickup)] then
		x, y, z = getElementPosition(pickup)
		pickupsCache[pickup] = {
			["position"] = {x, y, z},
			["name"] = (getElementData(pickup, "informationicon:information") or ""),
		}
	end
end

function destroyCache(pickup)
	if pickup and isElement(pickup) then
		pickupsCache[pickup] = nil
	end
end

function drawnPickupText()
	local cx,cy,cz = getCameraMatrix()
	for pickup, value in pairs(pickupsCache) do
		if not isElement(pickup) then
			pickupsCache[pickup] = nil
			break
		end
		local x, y, z = unpack(value.position)
		local information_text = value.name
		if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= 20 then
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if isLineOfSightClear(cx, cy, cz, x, y, z, true, true, true, true, true, false, false) then
				if (px and py) then
					dxDrawText(RemoveHEXColorCode(information_text), px+1, py, px+1, py, tocolor(0, 0, 0, 215), 1, "default-bold", "center", "center", false, false, false, true)
					dxDrawText(RemoveHEXColorCode(information_text), px-1, py, px-1, py, tocolor(0, 0, 0, 215), 1, "default-bold", "center", "center", false, false, false, true)
					dxDrawText(RemoveHEXColorCode(information_text), px, py+1, px, py+1, tocolor(0, 0, 0, 215), 1, "default-bold", "center", "center", false, false, false, true)
					dxDrawText(RemoveHEXColorCode(information_text), px, py-1, px, py-1, tocolor(0, 0, 0, 215), 1, "default-bold", "center", "center", false, false, false, true)

					dxDrawText(information_text, px, py, px, py, tocolor(255, 255, 255, 235), 1, "default-bold", "center", "center", false, false, false, true)
				end
			end
		end
	end
end

function RemoveHEXColorCode( s )
    return s:gsub( '#%x%x%x%x%x%x', '' ) or s
end