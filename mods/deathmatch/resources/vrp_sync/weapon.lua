aimfps = 60
maxfps = 100

function aimSync()
	if isPedAiming(getLocalPlayer()) then
		setFPSLimit(aimfps)
	else
		setFPSLimit(maxfps)
	end
end
setTimer(aimSync, 50, 0)

function isPedAiming (thePedToCheck)
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" or isPedDoingGangDriveby(thePedToCheck) then
				return true
			end
		end
	end
	return false
end
