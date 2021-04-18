addEvent("ipbagla",true)
addEventHandler("ipbagla",root,function(plr,target)
if not exports["vrp_items"]:hasItem(plr,46) then outputChatBox("[!]#ffffff Maalesef üzerinizde ip yok.",plr,255,100,100,true) return end
		local target, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(plr, target)
		local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
	if target then
		if getElementData(target, "ipbagli") then
			outputChatBox("[!]#ffffff Bağlamaya çalıştığınız kişi zaten bağlı.",plr,255,100,100,true)
		return end

		if getElementData(plr, "ipbagli") then
			outputChatBox("[!]#ffffff İp ile bağlanmışken başka birisini bağlayamazsınız.",plr,255,100,100,true)
		return end

		exports.vrp_global:sendLocalMeAction(plr, "Şahsın sağ ve sol ellerini birleştirerek ip ile sıkıca bağlar.")
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin ellerini bağladınız.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi ellerinizi bağladı.",target,100,100,255,true)
		exports.vrp_handcuff:kelepcele(target, "ipver")
		exports["vrp_items"]:takeItem(plr, 46)
	end
end)


addEvent("ipcoz",true)
addEventHandler("ipcoz",root,function(plr,target)
	if not getElementData(target, "ipbagli") then outputChatBox("[!]#ffffff İpini çözmeye çalıştığınız kişinin elleri bağlı değil",plr,255,100,100,true) return end

	local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
		
	if target then
		if getElementData(plr, "ipbagli") then
			outputChatBox("[!]#ffffff İp ile bağlanmışken başka birisini bağlayamazsınız.",plr,255,100,100,true)
		return end

		exports.vrp_global:sendLocalMeAction(plr, "Şahsın bileklerindeki ipi keserek çözer.")
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin ellerini çözdünüz.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi ellerinizi çözdü.",target,100,100,255,true)
		exports.vrp_handcuff:kelepcele(target, "ipal")
	end
end)