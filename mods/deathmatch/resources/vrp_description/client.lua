--MAXIME
local vehiculars = { }
local localPlayer = getLocalPlayer()
local viewDistance = 20
local heightOffset = 1.4
local refreshingInterval = 1
local showing = false
local timerRefresh = nil
local fonte = dxCreateFont ( ":vrp_fonts/components/Cargo_Two_SF.ttf" , 18 )
local fontElement = dxCreateFont(":vrp_fonts/components/FontAwesome.ttf", 9)
local noPlateVehs = {
	[481] = "BMX",
	[509] = "Bike",
	[510] = "Mountain Bike",
}

function bindVD()
	bindKey ( "ralt", "down", togglePinVD )
	addEventHandler("onClientRender", getRootElement(), showText)
end
addEventHandler ( "onClientResourceStart", resourceRoot, bindVD )

function removeVD ( key, keyState )
	--local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	--local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	--if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			return false
		end
		if showing then
			--removeEventHandler ( "onClientRender", getRootElement(), showText )
			showing = false
		end
	--end
end

function showNearbyVehicleDescriptions()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			if showing then
				--removeEventHandler ( "onClientRender", getRootElement(), showText )
				showing = false
			end
		end
		
		if not showing then
			for index, nearbyVehicle in ipairs( exports.vrp_global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
				if isElement(nearbyVehicle) then
					vehiculars[index] = nearbyVehicle
				end
			end
			
			showing = true
		end
	end
end

function togglePinVD()
	local enableOverlayDescription = getElementData(localPlayer, "enableOverlayDescription")
	local enableOverlayDescriptionVeh = getElementData(localPlayer, "enableOverlayDescriptionVeh")
	if enableOverlayDescription ~= "0" and enableOverlayDescriptionVeh ~= "0" then
		local enableOverlayDescriptionVehPin = getElementData(localPlayer, "enableOverlayDescriptionVehPin")
		if enableOverlayDescriptionVehPin == "1" then
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "0")
			if isTimer(timerRefresh) then
				killTimer(timerRefresh)
				timerRefresh = nil
			end
			if showing then
				--removeEventHandler ( "onClientRender", getRootElement(), showText )
				showing = false
			end
		else
			setElementData(localPlayer, "enableOverlayDescriptionVehPin", "1")
			timerRefresh = setTimer(refreshNearByVehs, 1000*refreshingInterval, 0)
			
			if not showing then
				for index, nearbyVehicle in ipairs( exports.vrp_global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
					if isElement(nearbyVehicle) and (getElementDimension(nearbyVehicle) == getElementDimension(localPlayer)) then
						vehiculars[index] = nearbyVehicle
					end
				end
				--addEventHandler("onClientRender", getRootElement(), showText)
				showing = true
			end
		end
	end
end

function showText()
	if not showing then
		if getKeyState('lalt') then
			showNearbyVehicleDescriptions()
		end
		return false
	end
	if not getKeyState('lalt') and getElementData(localPlayer, "enableOverlayDescriptionVehPin") ~= "1" then
		removeVD()
		return
	end
	for i = 1, #vehiculars, 1 do
		local theVehicle = vehiculars[i]
		if isElement(theVehicle) then
			local x,y,z = getElementPosition(theVehicle)			
			local cx,cy,cz = getCameraMatrix()
			if getDistanceBetweenPoints3D(cx,cy,cz,x,y,z) <= viewDistance then --Within radius viewDistance
				local px,py,pz = getScreenFromWorldPosition(x,y,z+heightOffset,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then				
					local toBeShowed = ""
					local vehicleBrand = ""
					local fontWidth = 90
					local toBeAdded = ""
					local lines = 0
					local textColor = tocolor(255,255,255,255)
					if getElementData(theVehicle, "carshop") then
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel")
							year = getElementData(theVehicle, "year")
							local line = year.." "..brand.." "..model
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							vehicleBrand = line
							--[[
							if toBeShowed == "" then
								toBeShowed = toBeShowed..line.."\n"
								lines = lines + 1
							else
								toBeShowed = toBeShowed.."-~-\n"..line.."\n"
								lines = lines + 2
							end]]
						else
							--[[if toBeShowed == "" then
								toBeShowed = toBeShowed..getVehicleName(theVehicle).."\n"
								lines = lines + 1
							else
								toBeShowed = toBeShowed.."-~-\n"..getVehicleName(theVehicle).."\n"
								lines = lines + 2
							end]]
							vehicleBrand = line
						end
						local price = getElementData(theVehicle, "carshop:cost") or 0
						local taxes = getElementData(theVehicle, "carshop:taxcost") or 0
						toBeShowed = toBeShowed.."Fiyat: "..exports.vrp_global:formatMoney(price).."$\n Vergi: "..exports.vrp_global:formatMoney(taxes) .. "$"
						lines = lines+ 1
					else
						--GET DESCRIPTIONS + SIZE
						local descToBeShown = ""
						local job = getElementData(theVehicle, "job")
						if job == 1 then
							descToBeShown = ""
							lines = lines + 1
						else
							for j = 1, 15 do
								local desc = getElementData(theVehicle, "description:"..j)
								if desc and desc ~= "" and desc ~= "\n" and desc ~= "\t" then
									local len = dxGetTextWidth(desc)
									if len > fontWidth then
										fontWidth = len
									end
									descToBeShown = descToBeShown..desc.."\n"
									lines = lines + 1
								end				
							end
						end
						
						if descToBeShown ~= "" then
							descToBeShown = "-~-\n"..descToBeShown
							lines = lines + 1
						end
					
						
						local brand, model, year = false, false, false
						brand = getElementData(theVehicle, "brand") or false
						if brand then
							model = getElementData(theVehicle, "maximemodel")
							year = getElementData(theVehicle, "year")
							
							local line = year.." "..brand
							
							-- toBeShowed = toBeShowed..line.."\n"
							-- lines = lines + 1
							vehicleBrand = line
							
							local len = dxGetTextWidth(vehicleBrand)
							if len > fontWidth then
								fontWidth = len
							end
							
						end
						
						--GET VIN+PLATE
						local plate = ""
						local vin = getElementData(theVehicle, "dbid")
						if vin < 0 then
							plate = getVehiclePlateText(theVehicle)
						else
							plate = getElementData(theVehicle, "plate")
						end

						--Following edited by Adams 27/01/14 to accomodate VIN/PLATE hiding.
						--[[
						if not noPlateVehs[getElementModel(theVehicle)] then
							if getElementData(theVehicle, "show_plate") == 0 then
								if getElementData(localPlayer, "duty_admin") == 1 then
									toBeShowed = toBeShowed.."((Plaka: "..plate.."))\n"
									lines = lines + 1
								else
									--toBeShowed = toBeShowed.."* NO PLATE *\n"
								end
							else
								toBeShowed = toBeShowed.."Plaka: "..plate.."\n"
								lines = lines + 1
							end
						end
						]]
						
						toBeShowed = toBeShowed.."ID: "..vin
						lines = lines + 1
						

						--GET IMPOUND
						if (exports["vrp_vehicle"]:isVehicleImpounded(theVehicle)) then
							local days = getRealTime().yearday-getElementData(theVehicle, "Impounded")
							toBeShowed = toBeShowed.."\n".."Çekili: " .. days .. " gündür çekili."
							lines = lines + 1
						end

						local vowner = getElementData(theVehicle, "owner") or -1
						local vfaction = getElementData(theVehicle, "faction") or -1
						if vowner == getElementData(localPlayer, "account:id") or exports.vrp_global:isStaffOnDuty(localPlayer) or exports.vrp_integration:isPlayerScripter(localPlayer) or exports.vrp_integration:isPlayerVCTMember(localPlayer) then
							toBeShowed = toBeShowed.."\nListe ID: "..(getElementData(theVehicle, "vehicle_shop_id") or "None")
							lines = lines + 1

							local ownerName = 'Devlet'
							if vowner > 0 then
								ownerName = exports.vrp_cache:getCharacterNameFromID(vowner)
							elseif vfaction > 0 then
								ownerName = exports.vrp_cache:getFactionNameFromId(vfaction)
							end
							local line = "\nSahibi: "..(ownerName or "Yükleniyor..")
							local len = dxGetTextWidth(line)
							if len > fontWidth then
								fontWidth = len
							end
							toBeShowed = toBeShowed..line
							lines = lines + 1

--Activity / MAXIME
							local protectedText, inactiveText = nil
							if vowner > 0 then 
								local protected, details = true, true, true--exports['vrp_vehicle']:isProtected(theVehicle) 
					            if protected then
					                textColor = tocolor(0, 255, 0,255)
					                -- protectedText = "[Inactivity protection remaining: "..details.."]"
					                -- local toBeAdded = "\n"..protectedText
									toBeShowed = toBeShowed..toBeAdded
									local len = dxGetTextWidth(toBeAdded)
									if len > fontWidth then
										fontWidth = len
									end
									lines = lines + 1
								else
					                local active, details2, secs = true, true, true --exports['vrp_vehicle']:isActive(theVehicle)
					                if active and (powner == getElementData(localPlayer, "dbid") or exports.vrp_integration:isPlayerStaff(localPlayer)) then
					                    --textColor = tocolor(150,150,150,255)
					                    inactiveText = "[Aktif | "
					                    -- local owner_last_login = getElementData(theVehicle, "owner_last_login")
										if owner_last_login and tonumber(owner_last_login) then
											local owner_last_login_text, owner_last_login_sec = exports.vrp_datetime:formatTimeInterval(owner_last_login)
											-- inactiveText = inactiveText.." Owner last seen "..owner_last_login_text.." "
										else
											-- inactiveText = inactiveText.." Owner last seen is irrelevant | "
										end
					                    local lastused = getElementData(theVehicle, "lastused")
										if lastused and tonumber(lastused) then
											local lastusedText, lastusedSeconds = exports.vrp_datetime:formatTimeInterval(lastused)
											-- inactiveText = inactiveText.."Last used "..lastusedText.."]"
										else
											-- inactiveText = inactiveText.."Last used is irrelevant]"
										end
						                -- local toBeAdded = "\n"..inactiveText
										-- toBeShowed = toBeShowed..toBeAdded
										local len = dxGetTextWidth(toBeAdded)
										if len > fontWidth then
											fontWidth = len
										end
										lines = lines + 1
									elseif not active then
										textColor = tocolor(150,150,150,255)
					                    -- inactiveText = "["..details2.."]"
						                -- local toBeAdded = "\n"..inactiveText
										-- toBeShowed = toBeShowed..toBeAdded
										local len = dxGetTextWidth(toBeAdded)
										if len > fontWidth then
											fontWidth = len
										end
										lines = lines + 1
					                end
					            end
						    end
						end
						if getElementData(theVehicle, "Satilik") then
					            textColor = tocolor(255,0,0,255)
					            inactiveText = "[SATILIK]"
								local toBeAdded = "\n"..inactiveText
								toBeShowed = toBeShowed..toBeAdded
								local len = dxGetTextWidth(toBeAdded)
								if len > fontWidth then
									fontWidth = len
								end
							lines = lines + 1
						end
						toBeShowed = toBeShowed.."\n"..descToBeShown
					end
					
					if fontWidth < 90 then
						fontWidth = 90
					end

					-- PLAKA (bekiroj)
					if not noPlateVehs[getElementModel(theVehicle)] then
						if not (getElementData(theVehicle, "show_plate") == 0) then
							local plate = getElementData(theVehicle, "plate") or ""
							if getElementData(theVehicle, "carshop") then
								plate = "SATILIK"
							end
							if getElementData(theVehicle, "faizkilidi") then
							plate = "Faiz Kiliti"
							renk1, renk2, renk3 = 255, 0, 0
							buyukluk = 0.50
							else
							renk1, renk2, renk3 = 8, 54, 139
							buyukluk = 0.65
							end
							local vehID = getElementData(theVehicle, "dbid")
							local vehFactionID = getElementData(theVehicle, "faction")
							dxDrawImage(px - 70, py-130, 150, 35, "plaka.png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
							dxDrawText(plate, px-70+5, py-255, px-90+175, py+33, tocolor(0, 0, 0, 255), buyukluk, fonte, "center", "center", false, false, false, false, false)
						end
					end
					
					local textColor2 = tocolor(255,255,255,200)
					local marg = 20
					local oneLineHeight = dxGetFontHeight(1, fontElement)
					local fontHeight = oneLineHeight * (lines - 1)
					px = px-(fontWidth/2)
					local recuzunluk = nil
					local uzunluk = dxGetTextWidth(vehicleBrand,1,fontElement)
					local uzunluk2 = dxGetTextWidth(toBeShowed,1,fontElement)
					recuzunluk = uzunluk
					if uzunluk2 > uzunluk then
						recuzunluk = uzunluk2
					end	
					
					local renk = tocolor(0, 0, 0, 200) -- rectangle renkleri
						if getElementData(theVehicle, "carshop") then
						exports.vrp_draw:gradient(px - 7.5, py+marg - 100,(recuzunluk + marg),65,0,0,0,255,false,true)
						exports.vrp_draw:gradient(px - 7.5, py+marg - 100,(recuzunluk + marg),24+(fontHeight+marg-7),0,0,0,255,false,true)
						dxDrawText(vehicleBrand, px + 5.5, py+marg-95, px +fontWidth+ 5.5, (py + 2000), textColor2, 1, fontElement, "center") -- burası
						else
						exports.vrp_draw:gradient(px - 7.5, py+marg - 100,(recuzunluk + marg),24,0,0,0,255,false,true)
						exports.vrp_draw:gradient(px - 7.5, py+marg - 100,(recuzunluk + marg),24+(fontHeight+marg-7),0,0,0,255,false,true)
						dxDrawText(vehicleBrand, px + 5.5, py+marg-95, px +fontWidth+ 5.5, (py + 2000), textColor2, 1, fontElement, "center") -- burası
						end
					local own = getElementData(theVehicle,"owner")
					if own == -2 then
						dxDrawText(getVehicleName(theVehicle), px + 5.5, py+marg-95, px + fontWidth + 5.5, (py + 2000), textColor2, 1, fontElement, "center")
					end
					
					dxDrawText(toBeShowed, px+10, py+marg-75, px + fontWidth, (py + fontHeight)+24, textColor2, 1, fontElement, "center")
				end
			end
		end
	end
end



--MAXIME
local descriptionLines = {}

function showEditDescription()
	if not exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		return
	end
	if getPedOccupiedVehicle(getLocalPlayer()) then
		local theVehicle = getPedOccupiedVehicle(getLocalPlayer())
		local dbid = getElementData(theVehicle, "dbid")
		local factionid = getElementData(theVehicle, "faction")
		if exports.vrp_global:hasItem(getLocalPlayer(), 3, dbid) or exports.vrp_global:hasItem(theVehicle, 3, dbid) or getElementData(getLocalPlayer(), "faction") == factionid or exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) and getElementData(getLocalPlayer(), "duty_admin") == 1 then
			if dbid > 0 then
				local scrWidth, scrHeight = guiGetScreenSize()
				local x = scrWidth/2 - (441/2)
				local y = scrHeight/2 - (212/2)
				showCursor(true)
				wEditDescription = guiCreateWindow(x,y,441,212,"Edit Vehicle Description",false)
				guiWindowSetSizable(wEditDescription, false)
				guiSetInputEnabled(true)
				description1 = getElementData(theVehicle, "description:1")
				description2 = getElementData(theVehicle, "description:2")
				description3 = getElementData(theVehicle, "description:3")
				description4 = getElementData(theVehicle, "description:4")
				description5 = getElementData(theVehicle, "description:5")
				descriptionLines[1] = guiCreateEdit(10,23,422,26,description1,false,wEditDescription)
				descriptionLines[2] = guiCreateEdit(9,51,422,26,description2,false,wEditDescription)
				descriptionLines[3] = guiCreateEdit(9,79,422,26,description3,false,wEditDescription)
				descriptionLines[4] = guiCreateEdit(9,107,422,26,description4,false,wEditDescription)
				descriptionLines[5] = guiCreateEdit(9,135,422,26,description5,false,wEditDescription)
				bSave = guiCreateButton(10,165,210,40,"Save",false,wEditDescription)
				bClose = guiCreateButton(220,165,210,40,"Close",false,wEditDescription)
				addEventHandler("onClientGUIClick", bSave, saveEditDescription)
				addEventHandler("onClientGUIClick", bClose, closeEditDescription)
			else
				exports.vrp_hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You cannot set descriptions on temporary vehicles.")
			end
		else
			exports.vrp_hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You are not the owner of this vehicle.")
		end
	else
		exports.vrp_hud:sendBottomNotification(getLocalPlayer(), "Vehicle Description", "You must be in the vehicle you wish to change the description of.")
	end
end
--addCommandHandler("ed", showEditDescription, false, false)
--addCommandHandler("editdescription", showEditDescription, false, false)
addEvent("editdescription", true)
addEventHandler("editdescription", getRootElement(), showEditDescription)

function saveEditDescription(button, state)
	if (source==bSave) and (button=="left") then
		local savedDescriptions = { }
		savedDescriptions[1] = guiGetText(descriptionLines[1])
		savedDescriptions[2] = guiGetText(descriptionLines[2])
		savedDescriptions[3] = guiGetText(descriptionLines[3])
		savedDescriptions[4] = guiGetText(descriptionLines[4])
		savedDescriptions[5] = guiGetText(descriptionLines[5])
		triggerServerEvent("saveDescriptions", getLocalPlayer(), savedDescriptions, getPedOccupiedVehicle(getLocalPlayer()))
		closeEditDescription()
	end
end

function closeEditDescription()
	destroyElement(wEditDescription)
	eLine1, eLine2, eLine3, eLine4, eLine5, bSave, bClose, wEditDescription = nil, nil, nil, nil, nil, nil, nil
	showCursor(false)
	guiSetInputEnabled(false)
end


function refreshNearByVehs()

	for index, nearbyVehicle in ipairs( exports.vrp_global:getNearbyElements(getLocalPlayer(), "vehicle") ) do
		if isElement(nearbyVehicle) then
			vehiculars[index] = nearbyVehicle
		end
	end
	removeEventHandler ( "onClientRender", getRootElement(), showText )
	addEventHandler("onClientRender", getRootElement(), showText)

end
