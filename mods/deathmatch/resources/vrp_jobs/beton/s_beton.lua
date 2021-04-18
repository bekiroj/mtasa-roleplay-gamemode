local miktar = 350
function betonparaVer(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 375
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 400
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 425
	end
	exports.vrp_global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("betonparaVer", true)
addEventHandler("betonparaVer", getRootElement(), betonparaVer)

function betonBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setVehicleLocked(pedVeh, false)
	setElementPosition(thePlayer, 2338.080078125, -2056.8310546875, 13.548931121826)
	setElementRotation(thePlayer, 0, 0, 91.822357177734)
end
addEvent("betonBitir", true)
addEventHandler("betonBitir", getRootElement(), betonBitir)

function betonAnti(thePlayer, seat, door)
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	if vehicleModel == 524 and vehicleJob == 14 then
	   	if seat ~= 0 then
	    	cancelEvent()
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.",thePlayer, 255, 0, 0, true)
	   	elseif seat == 0 then
	   		if playerJob ~= 14 then
	   			cancelEvent()
	   			outputChatBox("[!] #FFFFFFBu araca binmek meslekte olmanız gerekmektedir.", thePlayer, 255, 0, 0, true)
	   		end
	   	end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), betonAnti)