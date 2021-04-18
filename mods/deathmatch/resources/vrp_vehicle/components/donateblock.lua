local donateAraclar = { [529]=true,[561]=true,[490]=true,[602]=true,[412]=true,[402]=true}

addEventHandler("onVehicleStartEnter" , root , function(player)
	
    local model 	= source.model
    local owner 	= source:getData("owner")
	local seat  	= getPedOccupiedVehicleSeat(player)
	
	if exports.vrp_integration:isPlayerDeveloper(player) then 
	return end
	
	if seat == 0 then		
	
		if donateAraclar[model] and owner ~= player:getData("dbid") then
			exports["vrp_infobox"]:addBox(player, "error", "Donate araçları sadece sahipleri kullanabilir.")
			cancelEvent()
		end

	end
	
end)