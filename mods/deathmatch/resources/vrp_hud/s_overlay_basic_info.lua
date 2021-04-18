function showStats(thePlayer, commandName, targetPlayerName)
	local showPlayer = thePlayer
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and targetPlayerName then
		targetPlayer = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
		if targetPlayer then
			if getElementData(targetPlayer, "loggedin") == 1 then
				thePlayer = targetPlayer
			else
				outputChatBox("Kullanici oyunda degil.", showPlayer, 255, 0, 0)
				return
			end
		else
			return
		end
	end
	
	local isOverlayDisabled = getElementData(showPlayer, "hud:isOverlayDisabled")
	--LICNESES
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
	--local pilotlicense = getElementData(thePlayer, "license.pilot")
	local fishlicense = getElementData(thePlayer, "license.fish")
	local gunlicense = getElementData(thePlayer, "license.gun")
	local gun2license = getElementData(thePlayer, "license.gun2")
	if (carlicense==1) then
		carlicense = "Var"
	elseif (carlicense==3) then
		carlicense = "Test Aşamasında"
	else
		carlicense = "Yok"
	end
	if (bikelicense==1) then
		bikelicense = "Var"
	elseif (bikelicense==3) then
		bikelicense = "Test Aşamasında"
	else
		bikelicense = "Yok"
	end
	if (boatlicense==1) then
		boatlicense = "Var"
	else
		boatlicense = "Yok"
	end
	
	local pilotLicenses = {}
	local pilotlicense = ""
	local maxShow = 5
	local numAdded = 0
	local numOverflow = 0
	local typeratings = 0
	for k,v in ipairs(pilotLicenses) do
		local licenseID = v[1]
		local licenseValue = v[2]
		local licenseName = v[3]
		if licenseID == 7 then --if typerating
			if licenseValue then
				typeratings = typeratings + 1
			end
		else
			if numAdded >= maxShow then
				numOverflow = numOverflow + 1
			else
				if numAdded == 0 then
					pilotlicense = pilotlicense..tostring(licenseName)
				else
					pilotlicense = pilotlicense..", "..tostring(licenseName)
				end
				numAdded = numAdded + 1
			end
		end
	end
	if(numAdded == 0) then
		pilotlicense = "Hayir"
	else
		if numOverflow > 0 then
			pilotlicense = pilotlicense.." (+"..tostring(numOverflow+typeratings)..")"
		else
			if typeratings > 0 then
				pilotlicense = pilotlicense.." (+"..tostring(typeratings)..")"
			else
				pilotlicense = pilotlicense.."."
			end
		end
	end
	
	if (fishlicense==1) then
		fishlicense = "Var"
	else
		fishlicense = "Yok"
	end
	if (gunlicense==1) then
		gunlicense = "Var"
	else
		gunlicense = "Yok"
	end
	if (gun2license==1) then
		gun2license = "Var"
	else
		gun2license = "Yok"
	end
	--VEHICLES
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	local carids = ""
	local numcars = 0
	local printCar = ""
	for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("vehicle")) do
		local owner = tonumber(getElementData(value, "owner"))

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			carids = carids .. id .. ", "
			numcars = numcars + 1
			exports.vrp_anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.vrp_datetime:now(), true)
		end
	end
	printCar = numcars .. "/" .. getElementData(thePlayer, "maxvehicles")

	-- PROPERTIES
	local properties = ""
	local numproperties = 0
	for key, value in ipairs(getElementsByType("interior")) do
		local interiorStatus = getElementData(value, "status")
		
		if interiorStatus[4] and interiorStatus[4] == dbid and getElementData(value, "name") then
			local id = getElementData(value, "dbid")
			properties = properties .. id .. ", "
			numproperties = numproperties + 1
			--Update owner last login / MAXIME 2015.01.07
			exports.vrp_anticheat:changeProtectedElementDataEx(value, "owner_last_login", exports.vrp_datetime:now(), true)
		end
	end

	if (properties=="") then properties = "Yok  " end
	if (carids=="") then carids = "Yok  " end
	--FETCH ABOVE
	local hoursplayed = getElementData(thePlayer, "hoursplayed")
	local info = {}
	if isOverlayDisabled then
	else
		info = {
			{getPlayerName(thePlayer):gsub("_", " ")},
			{""},
			{"Araba Ehliyeti: " .. carlicense},
			{"Motor Ehliyeti: " .. bikelicense},
			{"Araclar (" .. printCar .. "): " .. string.sub(carids, 1, string.len(carids)-2)},
			{"Evler (" .. numproperties .. "/"..(getElementData(thePlayer, "maxinteriors") or 10).."): " .. string.sub(properties, 1, string.len(properties)-2)},
			{"Bu karakterinizde: " .. hoursplayed .. " saat geçirdiniz."},
		}
	end
	--CAREER
	local job = getElementData(thePlayer, "job") or 0
	if job == 0 then
		if isOverlayDisabled then
		else
		end
	else
		local jobName = exports["vrp_jobs"]:getJobTitleFromID(job)
		local joblevel = getElementData(thePlayer, "jobLevel") or 1
		local jobProgress = getElementData(thePlayer, "jobProgress") or 0
		if isOverlayDisabled then
			outputChatBox("   - Skill Level: "..joblevel, showPlayer)
			outputChatBox("   - Progress: "..jobProgress, showPlayer)
		else
			--table.insert(info, {" Career: "..jobName})
			--table.insert(info, {"   - Skill Level: "..joblevel})
			--table.insert(info, {"   - Progress: "..jobProgress})
		end
	end
	--CARRIED
	local carried = "Taşınan Ağırlık: "..("%.2f/%.2f" ):format( exports["vrp_items"]:getCarriedWeight( thePlayer ), exports["vrp_items"]:getMaxWeight( thePlayer ) ).." kg(s)"
	if isOverlayDisabled then
		outputChatBox( carried, showPlayer)
	else
		table.insert(info, {carried})
	end
	--FINANCE
	local currentGC = getElementData(thePlayer,"bakiye") or 0
	local bankmoney = getElementData(thePlayer, "bankmoney") or 0
	local money = getElementData(thePlayer, "money") or 0
	if isOverlayDisabled then
	else
		table.insert(info, {""})
		table.insert(info, {"Meslek: "..exports["vrp_jobs"]:getJobTitleFromID(job)..""})
		table.insert(info, {"Cüzdan: $"..exports.vrp_global:formatMoney(money)})
		table.insert(info, {"Bankadaki Para: $"..exports.vrp_global:formatMoney(bankmoney)})
		table.insert(info, {"Bakiye: "..exports.vrp_global:formatMoney(currentGC) .. " $ "})

		local carried = "Taşınan Ağırlık: "..("%.2f/%.2f" ):format( exports["vrp_items"]:getCarriedWeight( thePlayer ), exports["vrp_items"]:getMaxWeight( thePlayer ) ).." kg(s)"
		table.insert(info, {""})
		table.insert(info, {""})
		--table.insert(info, {"                                            Kullanıcı Bilgileri"})
	end
	
	if not isOverlayDisabled then
		triggerClientEvent(showPlayer, "hudOverlay:drawOverlayTopRight", showPlayer, info ) 
	end
end
addCommandHandler("stats", showStats, false, false)
addEvent("showStats", true)
addEventHandler("showStats", root, showStats)
