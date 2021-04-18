local syntaxTable = {
	["s"] = "#00a8ff[Valhalla]#ffffff ",
	["e"] = "#e84118[Valhalla]#ffffff ",
	["w"] = "#fbc531[Valhalla]#ffffff ",
}

addEvent("skinshop-system:buySkin", true)
addEventHandler("skinshop-system:buySkin", root,
	function(player, skinID, price)
		if exports["vrp_global"]:hasMoney(player, tonumber(price)) then
			exports["vrp_global"]:takeMoney(player, tonumber(price))
			outputChatBox(syntaxTable["s"].."Kıyafet başarıyla satın alındı.",player,255,255,255,true)
			exports["vrp_global"]:giveItem(player, 16, tonumber(skinID))
			setElementModel(player, tonumber(skinID))
		end
	end
)