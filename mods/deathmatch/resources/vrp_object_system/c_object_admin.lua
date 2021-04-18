function getNearbyObjects(commandName)
	if exports.vrp_integration:isPlayerAdmin(getLocalPlayer()) then
		outputChatBox("Nearby worldobjects:", 255, 126, 0)
		local count = 0
		
		for index, nearbyObject in ipairs( exports.vrp_global:getNearbyElements(getLocalPlayer(), "object") ) do
			local dbid = getElementData(nearbyObject, "object:dbid")
			if dbid then
				local objectID = getElementModel(nearbyObject)
				local objectX, objectY, objectZ = getElementPosition(nearbyObject)
			
				
				if (objectID) then
					outputChatBox(" Object ID "..dbid.." (Model: "..objectID.." PosX: ".. round2(objectX, 2) ..", PosY: ".. round2(objectY, 2) ..", PosZ: ".. round2(objectZ, 2) ..")", 255, 126, 0)
					count = count + 1
				end
			end
		end
		
		if (count==0) then
			outputChatBox("   None.", 255, 126, 0)
		end
	end
end
addCommandHandler("nearbywo", getNearbyObjects, false, false)

function round2(num, idp)
  return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

function fixes()
	setTimer(function()
		setOcclusionsEnabled( false ) -- to fix the object streaming issue (extreme low draw distance) / maxime
	end, 10000, 1)
end
addEventHandler("onClientResourceStart", resourceRoot, fixes)

