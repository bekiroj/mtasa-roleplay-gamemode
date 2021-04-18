addCommandHandler("jantlar",
	function(player, cmd)
			if player:getData("wheel:mechanic") then 
				exports["vrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "jant:gui", player, false, false, true)
		end
)


addCommandHandler("jantbug",
	function(player)
		player:setData("wheel:mechanic", nil)
	end
)

addEvent("mechanic:givewheel", true)
addEventHandler("mechanic:givewheel", root,	function(plr, upid,veh, price)

	exports.vrp_global:sendLocalMeAction(plr, "eğilerek aracın jantlarını yavaşça montelemeye başlar.")
	exports.vrp_global:applyAnimation(plr, "CAR", "Fixn_Car_Loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)
	exports["vrp_progressbar"]:drawProgressBar("Jant", "Monte ediliyor..",plr, 255, 255, 255, 6000)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.vrp_global:takeMoney(plr, price)
	exports["vrp_infobox"]:addBox(plr, "success", "Başarıyla jantı araca montelediniz.")
	exports.vrp_global:applyAnimation(plr, "CAR", "Fixn_Car_Out", 6000, false, true, false)
	
	exports['vrp_vehicle']:saveVehicleMods(veh)
	else
		exports["vrp_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

