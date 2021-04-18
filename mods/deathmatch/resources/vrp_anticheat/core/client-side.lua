local localPlayer = getLocalPlayer()
local timer = false
local kills = 0

function checkDM(killer)
	if (killer==localPlayer) then
		kills = kills + 1
		
		if (kills>=3) then
			triggerServerEvent("alertAdminsOfDM", localPlayer, kills)
		end
		
		if not (timer) then
			timer = true
			setTimer(resetDMCD, 120000, 1)
		end
	end
end
addEventHandler("onClientPlayerWasted", getRootElement(), checkDM)

function resetDMCD()
	kills = 0
	timer = false
end

function setEld(thePlayer, index, newvalue, sync)
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
		setElementdata(thePlayer, index, newvalue)
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		return setElementdata(thePlayer, index, newvalue)
	end
	return triggerServerEvent("anticheat:changeEld", thePlayer, index, newvalue, sync2, nosyncatall)
end