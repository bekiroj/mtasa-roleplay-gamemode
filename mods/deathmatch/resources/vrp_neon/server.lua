addEvent("tuning->Neon", true)
addEventHandler("tuning->Neon", root, function(vehicle, neon)
	if vehicle then
		triggerClientEvent(root, "tuning->Neon", root, vehicle, neon)
	end
end)
local neonList = {
	["0"] = "null",
	["1"] = "white",
	["2"] = "blue",
	["3"] = "green",
	["4"] = "red",
	["5"] = "yellow",
	["6"] = "pink",
	["7"] = "orange",
	["8"] = "lightblue",
	["9"] = "rasta",
	["10"] = "ice"
}
addCommandHandler("setneon",
	function(player, cmd, vehID, color)
	if exports.vrp_integration:isPlayerDeveloper(player) then
			if not vehID or not color or not neonList[tostring(color)] then
				outputChatBox("[!]#ffffff /setneon [Araç ID] [Renk (1-10)]", player, 0, 0, 255, true)
				return
			end
			local vehicle = exports.vrp_pool:getElement('vehicle', vehID)
			if vehicle and isElement(vehicle) then
				local color = neonList[tostring(color)]
				if not color then return end
				if color == "null" then color = false end
				outputChatBox(color, player)
				setElementData(vehicle, "tuning.neon", color)
				
				triggerClientEvent(root, "delNeon", root, vehicle, false)
				triggerClientEvent(root, "addNeon", root, vehicle, color)
				outputChatBox("[!]#ffffff İşlem başarılı, araç rengi başarıyla değiştirildi.", player, 0, 255, 0, true)
			end
		end
	end
)