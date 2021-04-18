function updateClientTime(hour, minute)
	if getElementDimension(localPlayer) == 0 then
		setTime(hour, minute)
	else
		setTime(12, 0)
	end
end
addEvent ( "updateClientTime", true )
addEventHandler ( "updateClientTime", getRootElement(), updateClientTime )

function doStuff(commandName, time)
	if not tostring(time) or tostring(time) == nil then
		outputChatBox("SYNTAX: /settime [Day or Night]", 255, 194, 14)
		return
	end

	if getElementDimension(getLocalPlayer()) == 0 then
		outputChatBox("You cannot use this command while outside.", 255, 0, 0)
		return
	end

	if string.lower(tostring(time)) == "day" then
		setTime(12, 0)

		outputChatBox("Client time set to day, interior objects will appear brighter.", 0, 255, 0)
	elseif string.lower(tostring(time)) == "night" then
		setTime(0, 0)

		outputChatBox("Client time set to night, interior objects will appear darker.", 0, 255, 0)
	else
		outputChatBox("SYNTAX: /settime [Day or Night]", 255, 194, 14)
	end 
end
addCommandHandler("settime", doStuff)