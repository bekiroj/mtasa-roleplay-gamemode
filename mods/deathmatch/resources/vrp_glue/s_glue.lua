	
function gluePlayer(slot, vehicle, x, y, z, rotX, rotY, rotZ)
	--outputDebugString('s_glue / gluePlayer / ' .. getPlayerName(client) .. ' ' .. getElementData(vehicle, "dbid"))
	exports.vrp_logs:logMessage("[/GLUE] " .. getElementData(source, "account:username") .. "/".. getPlayerName(source) .." glued to #".. getElementData(vehicle, "dbid") .. " - " .. getElementModel(vehicle), 4)

	attachElements(source, vehicle, x, y, z, rotX, rotY, rotZ)
	setElementRotation(source, rotX, rotY, rotZ)
	setPedWeaponSlot(source, slot)
end
addEvent("gluePlayer",true)
addEventHandler("gluePlayer",getRootElement(),gluePlayer)

function ungluePlayer()
	--outputDebugString('s_glue / ungluePlayer / ' .. getPlayerName(client))
	detachElements(source)
end
addEvent("ungluePlayer",true)
addEventHandler("ungluePlayer",getRootElement(),ungluePlayer)

function glueVehicle(attachedTo, x, y, z, rotX, rotY, rotZ)
	outputDebugString("M7!")
	if getElementModel(attachedTo) == 525 then
		return false
	end
	attachElements(source, attachedTo, x, y, z, rotX, rotY, rotZ)
	setElementCollisionsEnabled(source, false)
	exports.vrp_logs:logMessage("[/GLUE] " .. getElementData(client, "account:username") .. "/".. getElementData(source, "dbid") .." glued to #".. getElementData(attachedTo, "dbid") .. " - " .. getElementModel(attachedTo), 4)
end
addEvent("glueVehicle",true)
addEventHandler("glueVehicle",getRootElement(),glueVehicle)

function unglueVehicle()
	setElementCollisionsEnabled(source, true)
	setElementFrozen(source, true)
	local x, y, z = getElementPosition(source)
	detachElements(source)
	setElementPosition(source, x, y, z+0.1)
	setTimer(setElementFrozen, 1000, 1, source, false)
end
addEvent("unglueVehicle",true)
addEventHandler("unglueVehicle",getRootElement(),unglueVehicle)

function getNearby(e)
	local t = {}
	local x, y, z = getElementPosition(e)
	for k, v in ipairs(getElementsByType"player") do
		local dist = getDistanceBetweenPoints3D(x, y, z, getElementPosition(v))
		if dist < 100 then
			table.insert(t, getPlayerName(v) .. ' ' .. math.floor(dist))
		end
	end
	return table.concat(t, ', ')
end

addEventHandler("onTrailerAttach", root,
	function(truck)
		outputDebugString('s_glue / onTrailerAttach / ' .. getElementData(source, "dbid") .. ' to ' .. getElementData(truck, "dbid"))
		outputDebugString('s_glue / nearby: ' .. getNearby(source))
		
		
		--Make trailers damage proof
		if getElementModel(source) == 611 then
			setVehicleDamageProof(source, true)
			outputDebugString("WAKKA WAKKA")
		end
	end)

addEventHandler("onTrailerDetach", root,
	function(truck)
		outputDebugString('s_glue / onTrailerDetach / ' .. getElementData(source, "dbid") .. ' to ' .. getElementData(truck, "dbid"))
		outputDebugString('s_glue / nearby: ' .. getNearby(source))
	end)
	
--If it respawns, set it back to collisions enabled so shit doesn't bug
addEventHandler("onVehicleRespawn", root,
	function(exploded)
		if getElementType(source) == "vehicle" then
			if setElementCollisionsEnabled(source, true) then
				outputDebugString("Veh ".. getElementData(source, "dbid") .." set to collisions enabled. Love from Adams.")
			else
				outputDebugString("Veh ".. getElementData(source, "dbid") .." failed to have its collisions set. Sorry, from Adams.")
			end
		end
	end)