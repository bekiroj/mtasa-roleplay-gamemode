addCommandHandler("kornalar",
	function(player, cmd)
			if player:getData("korna:mechanic") then 
				exports["vrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "korna:gui", player, false, false, true)
		end
)

addEvent("mechanic:givekorna", true)
addEventHandler("mechanic:givekorna", root,	function(plr, upid,veh, price)

	exports.vrp_global:sendLocalMeAction(plr, "etrafında bulunan raftan bir havalı korna alır.")
	if exports["vrp_items"]:giveItem(plr, upid, 1) then
	exports.vrp_global:takeMoney(plr, price)
	exports["vrp_infobox"]:addBox(plr, "buy", "Envanterinize bir adet Havalı Korna geldi.")
	else
		exports["vrp_infobox"]:addBox(plr, "error", "Envanterinde yeterli alan yok.")
	end
end)

