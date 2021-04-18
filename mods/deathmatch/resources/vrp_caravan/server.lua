

addCommandHandler("karavan" , function(plr ,cmd , arg1)

	if not arg1 then outputChatBox("KULLANIM : /"..cmd.. "[tak/cikar/kapi]",plr,254,194,14,true) return end

    if arg1 == "tak" then
        if not plr.vehicle then
            outputChatBox("[!]#ffffff Bir araçta değilsin!",plr,255,0,0,true)
		return end

		local caravan = getElementData(plr.vehicle , "Caravans") or false 

		if caravan then
			outputChatBox("[!]#ffffff Bu araçta bir karavan takılı zaten!",plr,255,0,0,true)
		return end
		
		local caravan = getNearestVehicle(plr , 10)

		if caravan == plr.vehicle then return end
		
		if not caravan or caravan.model ~= Karavan.carid then
			outputChatBox("[!]#ffffff Yakınınızda herhangi bir karavan yok!",plr,255,0,0,true)
		return end

		triggerClientEvent(plr , "karavan:ComponentPosition" , plr , plr.vehicle , caravan)
		
	elseif arg1 == "cikar" then

		if not plr.vehicle then
            outputChatBox("[!]#ffffff Bir araçta değilsin!",plr,255,0,0,true)
		return end

		local caravan = getElementData(plr.vehicle , "Caravans") or false 

		if not caravan then
			outputChatBox("[!]#ffffff Aracın arkasında bir caravan takılı değil!",plr,255,0,0,true)
		return end
		
		local attachedElements = getAttachedElements ( plr.vehicle )
		-- loop through the table of elements
		for i,v in ipairs ( attachedElements ) do
			-- detach the element from the vehicle
			detachElements ( v, plr.vehicle )
		end

		setElementData(plr.vehicle , "Caravans" , false)

		outputChatBox("[!]#ffffff Karavanı araçtan çıkardın!",plr,0,255,0,true)
	end
end)

addEvent("karavan:ComponentPosition" , true)
addEventHandler("karavan:ComponentPosition" , root , function(veh , caravan)
	attachElements(caravan , veh ,  0,-7.5,0.4,0,0,0 )
	setElementData(veh , "Caravans" , caravan)
	outputChatBox("[!]#ffffff Başarıyla arabanın arkasına karavan taktın!",source,0,255,0,true)
end)

function getNearestVehicle(player,distance)
	local lastMinDis = distance-0.0001
	local nearestVeh = false
	local px,py,pz = getElementPosition(player)
	local pint = getElementInterior(player)
	local pdim = getElementDimension(player)

	for _,v in pairs(getElementsByType("vehicle")) do
	--	local vint,vdim = getElementInterior(v),getElementDimension(v)
	--	if vint == pint and vdim == pdim then
		if not  player.vehicle or v ~= player.vehicle then 
			local vx,vy,vz = getElementPosition(v)
			local dis = getDistanceBetweenPoints3D(px,py,pz,vx,vy,vz)
			if dis < distance then
			--	if dis < lastMinDis then 
					lastMinDis = dis
					nearestVeh = v
			--	end
			end
		end
	--	end
	end
	return nearestVeh
end