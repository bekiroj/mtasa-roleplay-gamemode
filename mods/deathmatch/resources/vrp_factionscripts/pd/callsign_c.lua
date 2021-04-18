function callsignrender ()
local localX, localY, localZ = getElementPosition(localPlayer)
	local vehicles = getElementsByType("vehicle", getRootElement(), true)
	if #vehicles > 0 then
		for i = 1, #vehicles do
			local vehicle = vehicles[i]
			if isElement(vehicle) and getElementData(vehicle, "callsign") then
				local numberPlate = getVehiclePlateText(vehicle)
				if numberPlate then
					local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
					local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(vehicle)
					vehicleZ = vehicleZ + maxZ + 0.15
					vehicleZ	= vehicleZ -2
					if isLineOfSightClear(vehicleX, vehicleY, vehicleZ, localX, localY, localZ, true, false, false, true, false, false, false,localPlayer) then
						local screenX, screenY = getScreenFromWorldPosition(vehicleX, vehicleY, vehicleZ)
						if screenX and screenY then
							local distance = getDistanceBetweenPoints3D(vehicleX, vehicleY, vehicleZ, localX, localY, localZ)
							if distance < 50 then
								local distMul = 1 - distance / 100
								local alphaMul = 1 - distance / 50
								local sx = 50 
								local sy = 50 
								local x = screenX - sx / 2
								local y = screenY - sy / 2
								dxDrawText(getElementData(vehicle, "callsign"), x, y , x + sx, 0, tocolor(255, 255, 255, 255 ), 1, "default-bold", "center", "top")
							end
						end
					end
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,callsignrender)
