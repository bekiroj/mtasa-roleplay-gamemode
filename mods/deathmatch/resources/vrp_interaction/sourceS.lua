function lockUnlockInside(vehicle)
	local model = getElementModel(vehicle)
	local owner = getElementData(vehicle, "owner")
	local dbid = getElementData(vehicle, "dbid")
	local seat = getPedOccupiedVehicleSeat(source)
	if  seat > 0 then
		outputChatBox("#575757Valhalla:#ffffff Aracın şoför koltuğunda olmanız gerekli",source,255,100,100,true)
	return end
	if ( getElementData(vehicle, "Impounded") or 0 ) == 0 then
		if not exports.vrp_global:hasItem( source, 3, dbid ) then
			if (getElementData(source, "realinvehicle") == 1) then
				local locked = isVehicleLocked(vehicle)
			end
		end
	else
		outputChatBox("(( You can't lock impounded vehicles. ))", source, 255, 195, 14)
	end
end
addEvent("lockUnlockInsideVehicle", true)
addEventHandler("lockUnlockInsideVehicle", getRootElement(), lockUnlockInside)


addEvent("ustara", true)
addEventHandler("ustara",root,function(plr,target)
	triggerClientEvent(target,"pd:ustAramaOnayGUI",target,plr,target)
end)

function karakterDegistirmeEvent()
	exports.vrp_global:sendLocalText(source, "- "..getPlayerName(source):gsub("_", " ").." adlı oyuncu karakter değiştirme ekranına gitme isteği gönderdi. (20 saniye içerisinde gidecek.)", 255, 255, 255, 10)
end
addEvent("karakterDegistirmeStart", true)
addEventHandler("karakterDegistirmeStart", root, karakterDegistirmeEvent)

function karakterDegistirmeEvent()
	exports.vrp_global:sendLocalText(source, "- "..getPlayerName(source):gsub("_", " ").." adlı oyuncu karakter değiştirme ekranına gitti. (kendi isteğiyle.)", 255, 255, 255, 10)
end
addEvent("karakterDegistirme", true)
addEventHandler("karakterDegistirme", root, karakterDegistirmeEvent)
