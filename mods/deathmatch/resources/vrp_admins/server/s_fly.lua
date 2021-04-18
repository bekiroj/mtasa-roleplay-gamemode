function fly(thePlayer, commandName)
	local veh = getPedOccupiedVehicle(thePlayer)
	if exports.vrp_global:isStaffOnDuty(thePlayer) then
		if veh then return end
		triggerClientEvent(thePlayer, "onClientFlyToggle", thePlayer)
	end
end
addCommandHandler("fly", fly, false, false)