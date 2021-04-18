wLicense, licenseList, bAcceptLicense, bCancel, bBuyLicense = nil
local Johnson = createPed(211, 1103.41796875, -768.2490234375, 976.25158691406)
setPedRotation(Johnson, 206)
setElementDimension(Johnson, 84)
setElementInterior(Johnson, 5)
setElementData( Johnson, "talk", 1, false )
setElementData( Johnson, "name", "Gamze Avcı", false )
setPedAnimation ( Johnson, "FOOD", "FF_Sit_Look", -1, true, false, false )
local dominick = createPed(187,  1108.599609375, -767.2998046875, 976.59997558594)
local sx, sy = guiGetScreenSize()
local selectedLicense = 0
local lastClick = 0
local cost = {
	["car"] =  550,
	["bike"] =  300,
	["boat"] =  950,
	["fishing"] =  250,
}
function showLicenseWindow()
	  local saat = getElementData(getLocalPlayer(), "hoursplayed")
		if saat < 1 then
				outputChatBox("[!] #FFFFFF2 Saat ve üzeri oyuncular ehliyet alabilir.", 255, 0, 0, true)
		else
	triggerServerEvent("onLicenseServer", localPlayer)

	selectedLicense = 0
	addEventHandler("onClientRender", root, renderLicenseWindow)
	showCursor(true)
end
end
addEvent("onLicense", true)
addEventHandler("onLicense", getRootElement(), showLicenseWindow)



local font = exports.vrp_fonts:getFont("Roboto", 10)
function renderLicenseWindow()
	local vehiclelicense = getElementData(localPlayer, "license.car")
	local bikelicense = getElementData(localPlayer, "license.bike")
	local boatlicense = getElementData(localPlayer, "license.boat")
	local pilotlicense = getElementData(localPlayer, "license.pilot")
	local fishlicense = getElementData(localPlayer, "license.fish")

	w, h = 350, 240
	x, y = sx/2-w/2, sy/2-h/2

	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
	w, h = w-4, h-4
	x, y = x+2, y+2
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
	dxDrawRectangle(x, y, w, 25, tocolor(0, 0, 0, 80))
	dxDrawText("Ehliyet Lisans Başvurusu", x, y, w+x, 25+y, tocolor(235, 235, 235), 1, font, "center", "center")
	y = y + 27
	local index = 0
	for i = 1, 7 do
		if i % 2 ~= 0 then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 160))
		else
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 120))
		end
		if isInSlot(x, y+(index*25), w, 25) then
			dxDrawRectangle(x, y+(index*25), w, 25, tocolor(0, 0, 0, 50))
		end
		
		index = index + 1
		newY = y+(index*25)
	end
	cacheArray = {}
	if (vehiclelicense~=1) then
		table.insert(cacheArray, {"Araç Ehliyeti", cost["car"]})
	end
	if (bikelicense~=1) then
		table.insert(cacheArray, {"Motor Ehliyeti", cost["bike"]})
	end
	if (boatlicense~=1) then
		table.insert(cacheArray, {"Bot Ehliyeti", cost["boat"]})
	end
	local index = 0
	for i, value in ipairs(cacheArray) do
		if isInSlot(x, y+(index*25), w, 25) then
			dxDrawText(value[1].." ("..value[2].." $)", x, y+(index*25), w+x, 25+y+(index*25), tocolor(85, 155, 255), 1, font, "center", "center")
			if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
				lastClick = getTickCount()
				selectedLicense = i
			end
		else
			if selectedLicense == i then
				dxDrawText(value[1].." ("..value[2].." $)", x, y+(index*25), w+x, 25+y+(index*25), tocolor(85, 155, 255), 1, font, "center", "center")
			else
				dxDrawText(value[1].." ("..value[2].." $)", x, y+(index*25), w+x, 25+y+(index*25), tocolor(255, 255, 255), 1, font, "center", "center")
			end
		end			
		index = index + 1
	end
	y = newY+5
	w = w/2
	dxDrawRectangle(x, y, w, 25, tocolor(85, 155, 255, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if isInSlot(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(85, 155, 255, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount();
			if selectedLicense ~= 0 then
				license = selectedLicense
				licensecost = cacheArray[license][2]
				if exports.vrp_global:hasMoney(localPlayer, licensecost) then
					if (license == 1) then
						if getElementData(localPlayer, "license.car") < 0 then
							--exports.hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.car") .. " hours before being able to obtain a " .. licensetext .. "." )
						elseif (getElementData(localPlayer,"license.car")==0) then
							triggerServerEvent("payFee", localPlayer, licensecost, "an automotive driver's license")
							createlicenseTestIntroWindow() -- take the drivers theory test.
							removeEventHandler("onClientRender", root, renderLicenseWindow)
							showCursor(false)
						elseif(getElementData(localPlayer,"license.car")==3) then
							initiateDrivingTest()
						end
					elseif (license == 2) then
						if getElementData(localPlayer, "license.bike") < 0 then
							--exports.hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.bike") .. " hours before being able to obtain a " .. licensetext .. "." )
						elseif (getElementData(localPlayer,"license.bike")==0) then
							triggerServerEvent("payFee", localPlayer, licensecost, "a motorbike driver's license")
							createlicenseBikeTestIntroWindow() -- take the drivers theory test.
							removeEventHandler("onClientRender", root, renderLicenseWindow)
							showCursor(false)
						elseif(getElementData(localPlayer,"license.bike")==3) then
							initiateBikeTest()
						end
					elseif (license == 3) then
						if getElementData(localPlayer, "license.boat") < 0 then
							--exports.hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.boat") .. " hours before being able to obtain a " .. licensetext .. "." )
						elseif (getElementData(localPlayer,"license.boat")==0) then
							triggerServerEvent("payFee", localPlayer, licensecost, "an boat driver's license")
							createlicenseBoatTestIntroWindow() -- boat theory test
							removeEventHandler("onClientRender", root, renderLicenseWindow)
							showCursor(false)
						end
					end
				else
					exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Ehliyeti almak için yeterli paranız yok. Fiyat: $"..licensecost)
				end
			else
				exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Lütfen listeden ehliyet tipini seçiniz." )
			end
		end
	end
	dxDrawText("Sınava Gir", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
	
	x = x+w
	dxDrawRectangle(x, y, w, 25, tocolor(232, 65, 24, 100))
	dxDrawRectangle(x+2, y+2, w-4, 21, tocolor(0, 0, 0, 100))
	if isInSlot(x, y, w, 25) then
		dxDrawRectangle(x, y, w, 25, tocolor(232, 65, 24, 50))
		if getKeyState("mouse1") and lastClick+200 <= getTickCount() then
			lastClick = getTickCount();
			removeEventHandler("onClientRender", root, renderLicenseWindow)
			showCursor(false)
		end
	end
	dxDrawText("Arayüzü Kapat", x, y, w+x, 25+y, tocolor(255, 255, 255), 1, font, "center", "center")
end

function isInSlot(xS, yS, wS, hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end

local gui = {}
function showRecoverLicenseWindow()
	closeRecoverLicenseWindow()
	showCursor(true)
	local vehiclelicense = getElementData(localPlayer, "license.car")
	local bikelicense = getElementData(localPlayer, "license.bike")
	local boatlicense = getElementData(localPlayer, "license.boat")
	local pilotlicense = getElementData(localPlayer, "license.pilot")
	local fishlicense = getElementData(localPlayer, "license.fish")

	local width, height = 300, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	gui.wLicense= guiCreateWindow(x, y, width, height, "Kayıp Ehliyet Çıkartma", false)
	
	gui.licenseList = guiCreateGridList(0.05, 0.05, 0.9, 0.8, true, gui.wLicense)
	gui.column = guiGridListAddColumn(gui.licenseList, "Ehliyet Tipi", 0.6)
	gui.column2 = guiGridListAddColumn(gui.licenseList, "Fiyat", 0.3)
	
	gui.row = guiGridListAddRow(gui.licenseList)
	guiGridListSetItemText(gui.licenseList, gui.row, gui.column, "Araba Ehliyeti", false, false)
	guiGridListSetItemText(gui.licenseList, gui.row, gui.column2, (cost["car"]/10) .. " $", true, false)

	gui.row2 = guiGridListAddRow(gui.licenseList)
	guiGridListSetItemText(gui.licenseList, gui.row2, gui.column, "Motor Ehliyeti", false, false)
	guiGridListSetItemText(gui.licenseList, gui.row2, gui.column2, (cost["bike"]/10).." $", true, false)

	gui.row3 = guiGridListAddRow(gui.licenseList)
	guiGridListSetItemText(gui.licenseList, gui.row3, gui.column, "Bot Ehliyeti", false, false)
	guiGridListSetItemText(gui.licenseList, gui.row3, gui.column2, (cost["boat"]/10).." $", true, false)
	
	--[[
	gui.row4 = guiGridListAddRow(gui.licenseList)
	guiGridListSetItemText(gui.licenseList, gui.row4, gui.column, "Fishing Permit", false, false)
	guiGridListSetItemText(gui.licenseList, gui.row4, gui.column2, "$"..cost["fishing"]/10, true, false)
	]]
	
	gui.bRecover = guiCreateButton(0.05, 0.85, 0.45, 0.1, "Başvur", true, gui.wLicense)
	gui.bCancel = guiCreateButton(0.5, 0.85, 0.45, 0.1, "İptal", true, gui.wLicense)
	triggerEvent("hud:convertUI", localPlayer, gui.wLicense)
	
	addEventHandler("onClientGUIClick", gui.bRecover, function()
		local row, col = guiGridListGetSelectedItem(gui.licenseList)
		if (row==-1) or (col==-1) then
			exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Lütfen, ehliyet tipini seçiniz!" )
			return false
		end
		
		local licensetext = guiGridListGetItemText(gui.licenseList, guiGridListGetSelectedItem(gui.licenseList), 1)
		local licensecost = 0
		
		if (licensetext=="Car License") then
			if vehiclelicense~= 1 then
				exports.vrp_hud:sendBottomNotification(localPlayer, getElementData(dominick, "name"), "Sorry, we are unable to locate a license for you in our records. Please meet agent Zehra Yildiz in the other room." )
				return false
			end
			triggerServerEvent("license:recover", localPlayer, licensetext, cost["car"]/10, 133, getElementData(dominick, "name"))
		end
		if (licensetext=="Bike License") then
			if bikelicense~= 1 then
				exportsvrp_.hud:sendBottomNotification(localPlayer, getElementData(dominick, "name"), "Sorry, we are unable to locate a license for you in our records. Please meet agent Zehra Yildiz in the other room." )
				return false
			end
			triggerServerEvent("license:recover", localPlayer, licensetext, cost["bike"]/10, 153, getElementData(dominick, "name"))
		end
		if (licensetext=="Boat License") then
			if boatlicense~= 1 then
				exports.vrp_hud:sendBottomNotification(localPlayer, getElementData(dominick, "name"), "Sorry, we are unable to locate a license for you in our records. Please meet agent Zehra Yildiz in the other room." )
				return false
			end
			triggerServerEvent("license:recover", localPlayer, licensetext, cost["boat"]/10, 155, getElementData(dominick, "name"))
		end
		if (licensetext=="Fishing Permit") then
			if fishlicense~= 1 then
				exports.vrp_hud:sendBottomNotification(localPlayer, getElementData(dominick, "name"), "Sorry, we are unable to locate a license for you in our records. Please meet agent Zehra Yildiz in the other room." )
				return false
			end
			triggerServerEvent("license:recover", localPlayer, licensetext, cost["fishing"]/10, 154, getElementData(dominick, "name"))
		end
	end, false)
	
	addEventHandler("onClientGUIClick", gui.bCancel, function()
		closeRecoverLicenseWindow()
	end, false)
end
addEvent("showRecoverLicenseWindow", true)
addEventHandler("showRecoverLicenseWindow", root, showRecoverLicenseWindow)

function closeRecoverLicenseWindow()
	if gui.wLicense and isElement(gui.wLicense) then
		destroyElement(gui.wLicense)
		gui.wLicense = nil
		showCursor(false)
	end
end

function acceptLicense(button, state)
	if (button=="left") then
		if (source==bAcceptLicense) or (source==bBuyLicense)then
			local row, col = guiGridListGetSelectedItem(licenseList)
			if (row==-1) or (col==-1) then
				exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Lütfen, listeden ehliyet tipiniz seçiniz!" )
				return false
			end
			
			local license = 0
			local licensetext = guiGridListGetItemText(licenseList, guiGridListGetSelectedItem(licenseList), 1)
			local licensecost = 0
			
			if (licensetext=="Araba Ehliyeti") then
				license = 1
				licensecost = cost["car"]
			end
			if (licensetext=="Motor Ehliyeti") then
				license = 2
				licensecost = cost["bike"]
			end
			if (licensetext=="Bot Ehliyeti") then
				license = 3
				licensecost = cost["boat"]
			end
			if (licensetext=="Fishing Permit") then
				license = 5
				licensecost = cost["fishing"]
			end
			
			if license <= 0 then
				return false
			end
			
			if (source==bAcceptLicense) then
				if not exports.vrp_global:hasMoney( localPlayer, licensecost ) then
					exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Ehliyeti almak için yeterli paranız yok. Fiyat: $"..licensecost)
					return false
				end
			end
				
			if source==bAcceptLicense then
				if (license == 1) then
					if  getElementData(localPlayer, "license.car") < 0 then
						exports.vrp_hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.car") .. " hours before being able to obtain a " .. licensetext .. "." )
					elseif (getElementData(localPlayer,"license.car")==0) then
						triggerServerEvent("payFee", localPlayer, licensecost, "an automotive driver's license")
						createlicenseTestIntroWindow() -- take the drivers theory test.
						destroyElement(licenseList)
						destroyElement(bAcceptLicense)
						destroyElement(bCancel)
						destroyElement(wLicense)
						wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
						showCursor(false)
					elseif(getElementData(localPlayer,"license.car")==3) then
						initiateDrivingTest()
					end
				elseif (license == 2) then
					if getElementData(localPlayer, "license.bike") < 0 then
						exports.vrp_hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.bike") .. " hours before being able to obtain a " .. licensetext .. "." )
					elseif (getElementData(localPlayer,"license.bike")==0) then
						triggerServerEvent("payFee", localPlayer, licensecost, "a motorbike driver's license")
						createlicenseBikeTestIntroWindow() -- take the drivers theory test.
						destroyElement(licenseList)
						destroyElement(bAcceptLicense)
						destroyElement(bCancel)
						destroyElement(wLicense)
						wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
						showCursor(false)
					elseif(getElementData(localPlayer,"license.bike")==3) then
						initiateBikeTest()
					end
				elseif (license == 3) then
					if getElementData(localPlayer, "license.boat") < 0 then
						exports.vrp_hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.boat") .. " hours before being able to obtain a " .. licensetext .. "." )
					elseif (getElementData(localPlayer,"license.boat")==0) then
						triggerServerEvent("payFee", localPlayer, licensecost, "an boat driver's license")
						createlicenseBoatTestIntroWindow() -- boat theory test
						destroyElement(licenseList)
						destroyElement(bAcceptLicense)
						destroyElement(bCancel)
						destroyElement(wLicense)
						wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
						showCursor(false)
					end
				elseif (license == 5) then
					if getElementData(localPlayer, "license.fish") < 0 then
						exports.vrp_hud:sendBottomNotification(localPlayer, "Department of Motor Vehicles", "You need to wait another " .. -getElementData(localPlayer, "license.fish") .. " hours before being able to obtain a " .. licensetext .. "." )
					elseif (getElementData(localPlayer,"license.fish")==0) then
						triggerServerEvent("payFee", localPlayer, licensecost, "a fishing permit")
						triggerServerEvent("acceptFishLicense", localPlayer)
						destroyElement(licenseList)
						destroyElement(bAcceptLicense)
						destroyElement(bCancel)
						destroyElement(wLicense)
						wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
						showCursor(false)
					end
				end
			elseif source==bBuyLicense then
				if license == 1 then
					triggerServerEvent("acceptCarLicense", localPlayer, true)
					closewLicense()
				elseif license == 2 then
					triggerServerEvent("acceptBikeLicense", localPlayer, true)
					closewLicense()
				elseif license == 3 then
					triggerServerEvent("acceptBoatLicense", localPlayer, true)
					closewLicense()
				elseif license == 5 then
					triggerServerEvent("acceptFishLicense", localPlayer, true)
					closewLicense()
				end
			end
		end
	end
end

function cancelLicense(button, state)
	if (source==bCancel) and (button=="left") then
		destroyElement(licenseList)
		destroyElement(bAcceptLicense)
		destroyElement(bCancel)
		destroyElement(wLicense)
		wLicense, licenseList, bAcceptLicense, bCancel = nil, nil, nil, nil
		showCursor(false)
	end
end

function closewLicense()
	if wLicense and isElement(wLicense) then
		destroyElement(wLicense)
		wLicense = nil
		showCursor(false)
	end
end

bindKey( "accelerate", "down",
	function( )
		local veh = getPedOccupiedVehicle( getLocalPlayer( ) )
		if veh and getVehicleOccupant( veh ) == getLocalPlayer( ) then
			if isElementFrozen( veh ) and getVehicleEngineState( veh ) then
				if getVehicleType(veh) == 'veh' or getVehicleType(veh) == 'Bike' then
					exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Motorun ayaklığını indirmeniz gerekmektedir. /kickstand yazarak indirebilirsiniz." )
				elseif getVehicleType(veh) == 'Boat' then
					exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Çapanızı geri çekmeniz gerekmektedir. /anchor yazarak geri çekebilirsiniz." )
				else
					exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Aracınızın el freni kaldırılmış. /handbrake yazarak indirebilirsiniz." )
				end
			elseif not getVehicleEngineState( veh ) then
				exports.vrp_hud:sendBottomNotification(localPlayer, "Motorlu Taşıtlar Departmanı", "Aracınızın motoru çalışmamaktadır. 'J' tuşuna basarak motoru çalıştırabilirsiniz." )
			end
		end
	end
)