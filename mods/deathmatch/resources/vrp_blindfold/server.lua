addEvent("gozbagla",true)
addEventHandler("gozbagla",root,function(plr,target)
if not exports["vrp_items"]:hasItem(plr,66) then outputChatBox("[!]#ffffff Maalesef üzerinizde bandaj yok.",plr,255,100,100,true) return end
		local target, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(plr, target)
		local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
	if target then
		if getElementData(target, "gözbandajı") then
			outputChatBox("[!]#ffffff Gözünü bağlamaya çalıştığınız kişinin zaten gözleri bağlı",plr,255,100,100,true)
		return end
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin gözlerini bağladınız.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi gözlerinizi bağladı.",target,100,100,255,true)
		fadeCamera(target, false)
		setElementData(target, "gözbandajı",true)
		exports["vrp_items"]:takeItem(plr, 66)
	end
end)


addEvent("gozcoz",true)
addEventHandler("gozcoz",root,function(plr,target)
	if not getElementData(target, "gözbandajı") then outputChatBox("[!]#ffffff Gözlerini çözmeye çalıştığınız kişinin gözleri bağlı değil",plr,255,100,100,true) return end
		local x,y,z = getElementPosition(plr)
	local x2,y2,z2 = getElementPosition(target)
	if getDistanceBetweenPoints3D(x,y,z,x2,y2,z2) > 3 then
		outputChatBox("[!]#ffffff Şahıs çok uzağınızda.",plr,255,100,100,true)
	return end
		if target then
			
		outputChatBox("[!]#ffffff ["..getPlayerName(target).."] adlı kişinin gözlerini çözdünüz.",plr,100,100,255,true)
		outputChatBox("[!]#ffffff ["..getPlayerName(plr).."] adlı kişi gözlerinizi çözdü.",target,100,100,255,true)
		fadeCamera(target, true)
		setElementData(target, "gözbandajı",nil)
		
		end
end)