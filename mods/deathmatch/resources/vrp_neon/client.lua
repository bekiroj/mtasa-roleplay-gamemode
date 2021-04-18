local availableNeons = {
	["white"] = 5764,
	["blue"] = 5681,
	["green"] = 18448,
	["red"] = 18215,
	["yellow"] = 18214,
	["pink"] = 18213,
	["orange"] = 14399,
	["lightblue"] = 14400,
	["rasta"] = 14401,
	["ice"] = 14402
}
local neonList = {
	["white"] = "Beyaz Neon",
	["blue"] = "Mavi Neon",
	["green"] = "Yeşil Neon",
	["red"] = "Kırmızı Neon",
	["yellow"] = "Sarı Neon",
	["pink"] = "Mor Neon",
	["orange"] = "Turuncu Neon",
	["lightblue"] = "Açık Mavi Neon",
	["rasta"] = "Gökkuşağı Neon",
	["ice"] = "Buz Rengi Neon"
}
local convert_number = {
	["white"] = "1",
	["blue"] = "2",
	["green"] = "3",
	["red"] = "4",
	["yellow"] = "5",
	["pink"] = "6",
	["orange"] = "7",
	["lightblue"] = "8",
	["rasta"] = "9",
	["ice"] = "10"
}
 vehicleNeon = {}
local neonCommandTimer

addEvent("tuning->Neon", true)
addEventHandler("onClientResourceStart", resourceRoot, function()
	for neonName, replaceModel in pairs(availableNeons) do
		local neonCOL = engineLoadCOL("neons/neonCollision.col")
		local neonDFF = engineLoadDFF("neons/" .. neonName .. ".dff")
		
		engineReplaceModel(neonDFF, replaceModel)
		engineReplaceCOL(neonCOL, replaceModel)
	end
	
	for _, vehicle in ipairs(getElementsByType("vehicle", root, true)) do
		if getElementData(vehicle, "tuning.neon") then
			if getElementData(vehicle, "vehicle.neon.active") then
				addNeon(vehicle, getElementData(vehicle, "tuning.neon"), true)
			end
		end
	end
end)
addCommandHandler("neon",
	function()
		if isTimer(neonCommandTimer) then
		return
	end
	
	neonCommandTimer = setTimer(function() end, 2000, 1)
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if vehicle then
		if getVehicleOccupant(vehicle, 0) == localPlayer then
			local neonColor = getElementData(vehicle, "tuning.neon") or false
			
			if neonColor then
				local neonActive = getElementData(vehicle, "vehicle.neon.active") or false
				
				if not neonActive then
					triggerServerEvent("tuning->Neon", localPlayer, vehicle, neonColor)
					setElementData(vehicle, "vehicle.neon.active", true)
				else
					triggerServerEvent("tuning->Neon", localPlayer, vehicle, false)
					setElementData(vehicle, "vehicle.neon.active", false)
				end
			end
		end
	end
	end
)
bindKey("n", "down", function()
	if isTimer(neonCommandTimer) then
		return
	end
	
	neonCommandTimer = setTimer(function() end, 2000, 1)
	
	local vehicle = getPedOccupiedVehicle(localPlayer)
	
	if vehicle then
	
		if getVehicleOccupant(vehicle, 0) == localPlayer then
			local neonColor = getElementData(vehicle, "tuning.neon") or false

			if neonColor then
				local neonActive = getElementData(vehicle, "vehicle.neon.active") or false
				
				if not neonActive then
					triggerServerEvent("tuning->Neon", localPlayer, vehicle, neonColor)
					setElementData(vehicle, "vehicle.neon.active", true)
				else
					triggerServerEvent("tuning->Neon", localPlayer, vehicle, false)
					setElementData(vehicle, "vehicle.neon.active", false)
				end
			end
		end
	end
end)

addEventHandler("tuning->Neon", root, function(vehicle, neon)
	if isElement(vehicle) then
	
		if neon then
			addNeon(vehicle, neon, true)
		else
			if vehicleNeon[vehicle] then
				if vehicleNeon[vehicle]["object.1"] and vehicleNeon[vehicle]["object.2"] then
					destroyElement(vehicleNeon[vehicle]["object.1"])
					destroyElement(vehicleNeon[vehicle]["object.2"])
					vehicleNeon[vehicle] = nil
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "vehicle" then
		if getElementData(source, "vehicle.neon.active") then
			local neonColor = getElementData(source, "tuning.neon") or false
			
			if neonColor then
				addNeon(source, neonColor, true)
			end
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "vehicle" then
		if vehicleNeon[source] then
			if isElement(vehicleNeon[source]["object.1"]) then
				destroyElement(vehicleNeon[source]["object.1"])
			end
			
			if isElement(vehicleNeon[source]["object.2"]) then
				destroyElement(vehicleNeon[source]["object.2"])
			end
			
			vehicleNeon[source] = nil
		end
	end
end)

addEventHandler("onClientElementDestroy", root, function()
	if getElementType(source) == "vehicle" then
		if vehicleNeon[source] then
			if isElement(vehicleNeon[source]["object.1"]) then
				destroyElement(vehicleNeon[source]["object.1"])
			end
			
			if isElement(vehicleNeon[source]["object.2"]) then
				destroyElement(vehicleNeon[source]["object.2"])
			end
			
			vehicleNeon[source] = nil
		end
	end
end)

addCommandHandler("neon",
	function(cmd)
		if getElementData(localPlayer, "loggedin") == 1 and localPlayer.vehicle then
			if tonumber(localPlayer.vehicle:getData("owner")) == tonumber(localPlayer:getData("account:charselect:id")) then
				if localPlayer.vehicle:getData("tuning.neon") then
					triggerEvent("neon->showList", localPlayer, localPlayer.vehicle:getData("dbid"))
				end
			end
		end
	end
)

addEvent("neon->showList", true)
addEventHandler("neon->showList", root,
	function(vehID)
		if isElement(neonGUI) then return end	
		neonGUI = guiCreateWindow(0, 0, 400, 500, "Araç Neon Sistemi - Valhalla", false)
		--guiWindowSetSizable(neonGUI, false)
		exports.vrp_global:centerWindow(neonGUI)
		gridlist = guiCreateGridList(9, 21, 400, 185, false, neonGUI)
		guiGridListAddColumn(gridlist, "Neon Rengi", 0.85)
		for i, v in pairs(neonList) do
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, v, false, false)
			guiGridListSetItemData(gridlist, row, 1, i, false, false)
		end
		guiGridListSetSortingEnabled(gridlist, false)
		image = guiCreateStaticImage(9, 210, 400, 606/3, "images/neon1.jpg", false, neonGUI)
		vehicleID = guiCreateEdit(85, 425, 560, 28, "", false, neonGUI)
		if vehID then
			guiSetEnabled(vehicleID, false)
			guiSetText(vehicleID, vehID)
		end
		label = guiCreateLabel(4, 425, 81, 28, "Araba ID:", false, neonGUI)
		guiSetFont(label, "default-bold-small")
		guiLabelSetHorizontalAlign(label, "center", false)
		guiLabelSetVerticalAlign(label, "center")
		ok = guiCreateButton(9, 455, 190, 32, "Satın Al ( 15TL )", false, neonGUI)
		if vehID then
			guiSetText(ok, "Değiştir ( 1,000$ )")
		end
		close = guiCreateButton(210, 455, 200, 31, "Arayüzü Kapat", false, neonGUI)
		--guiSetInputEnabled(true)
		addEventHandler('onClientGUIClick', root,
			function(b)
				if (b == "left") then
					if (source == gridlist) then
						local selectedNeon = guiGridListGetSelectedItem(gridlist)
						if not selectedNeon or selectedNeon == -1 then return end
						local neonIndex = guiGridListGetItemData(gridlist, selectedNeon, 1)
						guiStaticImageLoadImage(image, "images/neon"..convert_number[neonIndex]..".jpg")
					elseif (source == close) then
						destroyElement(neonGUI)
						guiSetInputEnabled(false)
						showCursor(false)
					elseif (source == ok) then
						if guiGetText(vehicleID) == "" or not tonumber(guiGetText(vehicleID)) then
							outputChatBox("[!]#ffffff Aracınızın ID numarasını hatalı girdiniz.", 255, 0, 0, true)
							return
						end
						local vehicleID = guiGetText(vehicleID)
						local selectedNeon = guiGridListGetSelectedItem(gridlist)
						local neonIndex = guiGridListGetItemData(gridlist, selectedNeon, 1)
						if not selectedNeon or selectedNeon == -1 then
							outputChatBox("[!]#ffffff Herhangi bir neon rengi seçmediniz.", 255, 0, 0, true)
							return
						end
						guiSetInputEnabled(false)
						showCursor(false)
						destroyElement(neonGUI)
						triggerServerEvent("market->addVehicleNeon", localPlayer, localPlayer, vehicleID, neonIndex)
					end
				end
			end
		)
	end
)


addEventHandler("onClientRender", root, function()
	for vehicle, neon in pairs(vehicleNeon) do
		if neon["object.1"] and neon["object.2"] then
			attachElements(neon["object.1"], vehicle, 0.8, 0, neon["object.zOffset"])
			attachElements(neon["object.2"], vehicle, -0.8, 0, neon["object.zOffset"])
		end
	end
end)

function addNeon(vehicle, neon, setDefault)
	
	if not availableNeons[neon] then return end

	if not vehicleNeon[vehicle] then
		vehicleNeon[vehicle] = {}
	end
	
	if setDefault then
		vehicleNeon[vehicle]["oldNeonID"] = availableNeons[neon]
	end

	vehicleNeon[vehicle]["neon"] = neon
	
	if vehicleNeon[vehicle]["object.1"] or vehicleNeon[vehicle]["object.2"] then
		if availableNeons[neon] then
			setElementModel(vehicleNeon[vehicle]["object.1"], availableNeons[neon])
			setElementModel(vehicleNeon[vehicle]["object.2"], availableNeons[neon])
		else
			destroyElement(vehicleNeon[vehicle]["object.1"])
			destroyElement(vehicleNeon[vehicle]["object.2"])
		end
	else
		local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)

		vehicleNeon[vehicle]["object.1"] = createObject(availableNeons[neon], 0, 0, 0)
		vehicleNeon[vehicle]["object.2"] = createObject(availableNeons[neon], 0, 0, 0)
		setObjectScale(vehicleNeon[vehicle]["object.1"], 0)
		setObjectScale(vehicleNeon[vehicle]["object.2"], 0)
		setElementInterior(vehicleNeon[vehicle]["object.1"], (getElementInterior(localPlayer) or 0))
		setElementDimension(vehicleNeon[vehicle]["object.1"], (getElementDimension(localPlayer) or 0))
		setElementInterior(vehicleNeon[vehicle]["object.2"], (getElementInterior(localPlayer) or 0))
		setElementDimension(vehicleNeon[vehicle]["object.2"], (getElementDimension(localPlayer) or 0))

		setElementPosition(vehicleNeon[vehicle]["object.1"], vehicleX, vehicleY, vehicleZ)
		setElementPosition(vehicleNeon[vehicle]["object.2"], vehicleX, vehicleY, vehicleZ)
	end
	
	vehicleNeon[vehicle]["object.zOffset"] = -0.5
end
addEvent("addNeon", true)
addEventHandler("addNeon", root, addNeon)

function removeNeon(vehicle, previewMode)
	if vehicleNeon[vehicle] then
		triggerServerEvent("tuning->Neon", localPlayer, vehicle, false)
	end
	
	
	if not previewMode then
		setElementData(vehicle, "tuning.neon", false)
		setElementData(vehicle, "vehicle.neon.active", false)
	end
end
addEvent("delNeon", true)
addEventHandler("delNeon", root, removeNeon)

function saveNeon(vehicle, neon)
	setElementData(vehicle, "tuning.neon", neon)
	setElementData(vehicle, "vehicle.neon.active", false)
	
	triggerServerEvent("tuning->Neon", localPlayer, vehicle, neon)
end

function restoreOldNeon(vehicle)
	if vehicle then
		local neonColor = getElementData(vehicle, "tuning.neon") or false
		local neonActivated = getElementData(vehicle, "vehicle.neon.active") or false
		
		if vehicleNeon[vehicle] then
			if vehicleNeon[vehicle]["object.1"] and vehicleNeon[vehicle]["object.2"] then
				local neonModel = availableNeons[vehicleNeon[vehicle]["oldNeonID"]]
				
				if neonModel then
					setElementModel(vehicleNeon[vehicle]["object.1"], neonModel)
					setElementModel(vehicleNeon[vehicle]["object.2"], neonModel)
				else
					destroyElement(vehicleNeon[vehicle]["object.1"])
					destroyElement(vehicleNeon[vehicle]["object.2"])
					vehicleNeon[vehicle] = nil
				end
			end
		end
		
		if neonColor then
			if neonActivated then
				triggerServerEvent("tuning->Neon", localPlayer, vehicle, neonColor)
			end
		end
	end
end
