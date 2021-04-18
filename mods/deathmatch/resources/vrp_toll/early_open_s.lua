function canAccessEarlyZone(theVehicle, thePlayer)
	if theVehicle and getElementData(theVehicle, "lspd:siren") then
		return true
	end
	return false and tonumber(pValue) == 1
end