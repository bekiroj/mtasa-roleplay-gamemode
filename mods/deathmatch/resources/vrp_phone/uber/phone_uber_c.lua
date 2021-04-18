local sx, sy = guiGetScreenSize()
local uberGUIs = {}

shownUber = false
function toggleUber(bool)
	if (bool == true) then
		createUberGUI()
		addEventHandler("onClientGUIClick", root, clickUberFunctions)
		addEventHandler("onClientRender", root, checkMyWaiter)
		shownUber = true
	else
		for k,v in ipairs(uberGUIs) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		if shownUber then
			removeEventHandler("onClientGUIClick", root, clickUberFunctions)
			removeEventHandler("onClientRender", root, checkMyWaiter)
		end
		shownUber = false
	end
end

function createUberGUI()
	y = 45
	uberGUIs[1] = guiCreateButton(40,388+y,185,30,"",false,wPhoneMenu)
	guiSetAlpha(uberGUIs[1],0)

	uberGUIs[2] = guiCreateLabel(40, 330+y, 185, 20, "Aktif Uber Çalışanı: N/A", false, wPhoneMenu)
	setTimer(
		function()
			guiSetText(uberGUIs[2], "Aktif Uber Çalışanı: "..#getElementData(root, "uberPersonels"))
		end,
	2000, 1)
	uberGUIs[3] = guiCreateLabel(40, 355+y, 185, 20, "", false, wPhoneMenu)
end

function checkMyWaiter()
	uberTable = getElementData(root, "uberWaiters")
	for index, value in pairs(uberTable) do
		if localPlayer == index then
			guiSetText(uberGUIs[3], "Uber kaydın oluşturuldu.")
		else
			guiSetText(uberGUIs[3], "")
		end
	end
end

function clickUberFunctions(state)
	if state == "left" then
		if source == uberGUIs[1] then
			if checkForMeUber(localPlayer) then
				outputChatBox("Zaten sistemden bir uber aracı istemişsiniz!", 255, 0, 0, true)
				return
			end
			x, y, z = getElementPosition(localPlayer)
			dim, int = getElementDimension(localPlayer), getElementInterior(localPlayer)
			if (tonumber(dim) == 0 and tonumber(int) == 0) then
				triggerServerEvent("uber-system:requestNewUberVehicle", localPlayer, localPlayer, x, y, z)
				guiSetText(uberGUIs[3], "Uber kaydın oluşturuluyor..")
			end
		end
	end
end

function checkForMeUber(player)
	uberTable = getElementData(root, "uberWaiters")
	for index, value in pairs(uberTable) do
		if player == index then
			return true--already uber
		else
			return false
		end
	end
	return false
end


