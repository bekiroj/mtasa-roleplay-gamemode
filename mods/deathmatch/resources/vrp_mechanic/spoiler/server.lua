addCommandHandler("spoilerler",
	function(player, cmd)
			if player:getData("spoiler:mechanic") then 
				exports["vrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "spoiler:gui", player, false, false, true)
		end
)

addEvent("mechanic:givespoiler", true)
addEventHandler("mechanic:givespoiler", root,	function(plr, upid,veh, price)

	exports.vrp_global:sendLocalMeAction(plr, "aracın arkasına geçerek spoilerları yavaşça tornavidayla sabitlemeye başlar.")
	exports.vrp_global:applyAnimation(plr, "CAR_CHAT", "car_talkm_loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)
	exports["vrp_progressbar"]:drawProgressBar("Spoiler", "Sabitleniyor..",plr, 255, 255, 255, 6000)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.vrp_global:takeMoney(plr, price)
	exports["vrp_infobox"]:addBox(plr, "success", "Başarıyla spoileri araca montelediniz.")
	exports['vrp_vehicle']:saveVehicleMods(veh)
	else
		exports["vrp_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

