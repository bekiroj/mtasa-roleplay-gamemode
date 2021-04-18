gFactionWindow,gFactionWindow2,loadingLabel ,gMemberGrid, gMOTDLabel, colName, colRank, colWage, colDuty, colLastLogin, --[[colLocation,]] colLeader, colOnline, colPhone, gButtonKick, gButtonPromote, gButtonDemote, gButtonEditRanks, gButtonEditMOTD, gButtonInvite, gButtonLeader, gButtonQuit, gButtonExit, wConfirmQuit, eNote = nil
theMotd, theTeam, arrUsernames, arrRanks, arrPerks, arrLeaders, arrOnline, arrFactionRanks, --[[arrLocations,]] arrFactionWages, arrLastLogin, membersOnline, membersOffline, gButtonRespawn, gButtonPerk = nil
tabVehicles, gVehicleGrid, colVehID, colVehModel, colVehPlates, colVehLocation, gButtonVehRespawn, gButtonAllVehRespawn, gButtonYes, gButtonNo, showrespawnUI = nil
local tmpPhone = nil
local promotionWindow = {}
local promotionButton = {}
local promotionLabel = {}
local promotionRadio = {}

local function checkF3( )
	if not f3state and getKeyState( "f3" ) then
		hideFactionMenu( )
	else
		f3state = getKeyState( "f3" )
	end
end

function getTeamFromFactionID(factionID)
	if not tonumber(factionID) then
		return false
	end
	for i, faction in pairs(getElementsByType("team")) do
		if(tonumber(getElementData(faction, "id")) == tonumber(factionID)) then
			outputDebugString(factionID.."-"..getTeamName(faction))
			return faction
		end
	end
	return false
end

addEvent("birlik:panel",true)
addEventHandler("birlik:panel",root,function(motd, memberUsernames, memberRanks, memberPerks, memberLeaders, memberOnline, memberLastLogin, --[[memberLocation,]] factionRanks, factionWages, factionTheTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, membersPhone, fromShowF, factionID, birlikseviye,birlikonay)
		if not gFactionWindow2 then
		triggerEvent( 'hud:blur', resourceRoot, 9, false, 0.5, nil )
		local thePlayer = getLocalPlayer()
		theTeam = factionTheTeam
		local teamName = getTeamName(theTeam)
		gFactionWindow2 = guiCreateWindow(0.1, 0.25, 0.85, 0.525, tostring(teamName), true)
		loadingLabel = guiCreateLabel(0, 0, 1, 1, "Birlik Verileri Yükleniyor..", true, gFactionWindow)
		guiLabelSetHorizontalAlign(loadingLabel, "center", true)
        guiLabelSetVerticalAlign(loadingLabel, "center",true)
		zaman = setTimer(function()
		destroyElement(loadingLabel)
		destroyElement(gFactionWindow2)
		showFactionMenu(motd, memberUsernames, memberRanks, memberPerks, memberLeaders, memberOnline, memberLastLogin, --[[memberLocation,]] factionRanks, factionWages, factionTheTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, membersPhone, fromShowF, factionID, birlikseviye,birlikonay)
		end, 1000,1)
		--showFactionMenu(motd, memberUsernames, memberRanks, memberPerks, memberLeaders, memberOnline, memberLastLogin, --[[memberLocation,]] factionRanks, factionWages, factionTheTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, membersPhone, fromShowF, factionID, birlikseviye,birlikonay)
		end
end)

function showFactionMenu(motd, memberUsernames, memberRanks, memberPerks, memberLeaders, memberOnline, memberLastLogin, --[[memberLocation,]] factionRanks, factionWages, factionTheTeam, note, fnote, vehicleIDs, vehicleModels, vehiclePlates, vehicleLocations, memberOnDuty, towstats, phone, membersPhone, fromShowF, factionID, birlikseviye,birlikonay)
	if (not isElement(gFactionWindow)) then
		invitedPlayer = nil
		arrUsernames = memberUsernames
		arrRanks = memberRanks
		arrLeaders = memberLeaders
		arrPerks = memberPerks
		arrOnline = memberOnline
		arrLastLogin = memberLastLogin
		factionID1 = factionID
		--arrLocations = memberLocation
		arrFactionRanks = factionRanks
		arrFactionWages = factionWages
		financeLoaded = false
		
		if (motd) == nil then motd = "" end
		theMotd = motd
		tmpPhone = phone
	
	
		local thePlayer = getLocalPlayer()
		theTeam = factionTheTeam
		local teamName = getTeamName(theTeam)
		local playerName = getPlayerName(thePlayer)
		triggerEvent( 'hud:blur', resourceRoot, 9, false, 0.5, nil )
		gFactionWindow = guiCreateWindow(0.1, 0.25, 0.85, 0.525, tostring(teamName), true)
		local width, height = guiGetSize(gFactionWindow, false)
		if height < 500 then
			guiSetSize(gFactionWindow, width, 500, false)
			local posx, posy = guiGetPosition(gFactionWindow, false)
			local screenx, screeny = guiGetScreenSize( )
			guiSetPosition(gFactionWindow, posx, (screeny - 500) / 2, false)
		end
		guiWindowSetSizable(gFactionWindow, false)
		guiSetInputEnabled(true)
		
		tabs = guiCreateTabPanel(0, 0.04, 1, 1, true, gFactionWindow)
		tabOverview = guiCreateTab("Genel Bakış", tabs)
		guiSetFont(tabs, "default-small")
		-- Make members list
		gMemberGrid = guiCreateGridList(0.01, 0.015, 0.8, 0.905, true, tabOverview)
		guiSetFont(gMemberGrid, "default-small")
		colName = guiGridListAddColumn(gMemberGrid, "İsim", 0.20)
		
		colRank = guiGridListAddColumn(gMemberGrid, "Rütbe", 0.20)
		colOnline = guiGridListAddColumn(gMemberGrid, "Durum", 0.115)
		colLastLogin = guiGridListAddColumn(gMemberGrid, "Son Giriş", 0.13)
		colLeader = guiGridListAddColumn(gMemberGrid, "Seviye", 0.06)
		
		local factionType = tonumber(getElementData(theTeam, "type"))
		
		if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
			--colLocation = guiGridListAddColumn(gMemberGrid, "Location", 0.12)
			colWage = guiGridListAddColumn(gMemberGrid, "Ücret ($)", 0.06)
		--else
			--colLocation = guiGridListAddColumn(gMemberGrid, "Location", 0.1)
		end

		if phone then
			colPhone = guiGridListAddColumn(gMemberGrid, "Telefon Numarası.", 0.08)
		end
		
		local factionID = getElementData(factionTheTeam, "id")
		local factionPackages = getFactionPackages(factionID)
		if factionPackages and factionType >= 2 then
			colDuty = guiGridListAddColumn(gMemberGrid, "Görev", 0.06)
		end
		local oyuncu_birlik = getPlayerTeam(getLocalPlayer())
		local birlik_seviye = getElementData(oyuncu_birlik, "birlik_level")
		
		birlikSeviyesiLbl = guiCreateLabel(0.83, 0.04, 0.16, 0.05, "Birlik Seviyesi: "..birlik_seviye.."", true, gFactionWindow)
		guiLabelSetVerticalAlign(birlikSeviyesiLbl, "center")
		guiSetFont(birlikSeviyesiLbl, "default-bold-small")
			if birlikonay == 1 then
				onaydurum = "Var"
			else
				onaydurum = "Yok"
			end
		onay = guiCreateLabel(0.90, 0.04, 0.16, 0.05, "Birlik Onayı: "..onaydurum, true, gFactionWindow)
		guiLabelSetVerticalAlign(onay, "center")
		guiSetFont(onay, "default-bold-small")
		local localPlayerIsLeader = nil
		local counterOnline, counterOffline = 0, 0
		
		for k, v in ipairs(memberUsernames) do
			local row = guiGridListAddRow(gMemberGrid)
			guiGridListSetItemText(gMemberGrid, row, colName, string.gsub(tostring(memberUsernames[k]), "_", " "), false, false)
			
			local theRank = tonumber(memberRanks[k])
			local rankName = factionRanks[theRank]
			guiGridListSetItemText(gMemberGrid, row, colRank, tostring(rankName), false, false)
			guiGridListSetItemData(gMemberGrid, row, colRank, tostring(theRank))
			
			local login = "Asla"
			if (not memberLastLogin[k]) then
				login = "Asla"
			else
				if (memberLastLogin[k]==0) then
					login = "Bugün"
				elseif (memberLastLogin[k]==1) then
					login = tostring(memberLastLogin[k]) .. " gün önce"
				else
					login = tostring(memberLastLogin[k]) .. " gün önce"
				end
			end
			guiGridListSetItemText(gMemberGrid, row, colLastLogin, login, false, false)
			--guiGridListSetItemText(gMemberGrid, row, colLocation, memberLocation[k], false, false)

			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				local rankWage = factionWages[theRank]
				guiGridListSetItemText(gMemberGrid, row, colWage, tostring(rankWage), false, true)
			end
			
			if (memberOnline[k]) then
				guiGridListSetItemText(gMemberGrid, row, colOnline, "Aktif", false, false)
				guiGridListSetItemColor(gMemberGrid, row, colOnline, 0, 255, 0)
				counterOnline = counterOnline + 1
			else
				guiGridListSetItemText(gMemberGrid, row, colOnline, "Deaktif", false, false)
				guiGridListSetItemColor(gMemberGrid, row, colOnline, 255, 0, 0)
				counterOffline = counterOffline + 1
			end

			if (memberLeaders[k]) then
				guiGridListSetItemText(gMemberGrid, row, colLeader, "Lider", false, false)
			else
				guiGridListSetItemText(gMemberGrid, row, colLeader, "Üye", false, false)
			end
			
			-- Check if this is the local player
			if (tostring(memberUsernames[k])==playerName) then
				localPlayerIsLeader = memberLeaders[k]
			elseif fromShowF then
				localPlayerIsLeader = fromShowF
			end
			
			if colDuty then
				if memberOnDuty[k] then
					guiGridListSetItemText(gMemberGrid, row, colDuty, "Görevde", false, false)
					guiGridListSetItemColor(gMemberGrid, row, colDuty, 0, 255, 0)
				else
					guiGridListSetItemText(gMemberGrid, row, colDuty, "Görevde Değil", false, false)
					guiGridListSetItemColor(gMemberGrid, row, colDuty, 255, 0, 0)
				end
			end

			if phone and colPhone then
				if membersPhone[k] then
					guiGridListSetItemText(gMemberGrid, row, colPhone, tostring(phone) .. "-" .. tostring(membersPhone[k]), false, true)
				else
					guiGridListSetItemText(gMemberGrid, row, colPhone, "", false, true)
				end
			end
		end
		
		membersOnline = counterOnline
		membersOffline = counterOffline
		
		-- Update the window title
		guiSetText(gFactionWindow, tostring(teamName) .. " (" .. counterOnline .. " of " .. (counterOnline+counterOffline) .. " Çevrimiçi Üyeler)")
		
		-- Make the buttons
		if (localPlayerIsLeader) then
			gButtonKick = guiCreateButton(0.825, 0.076, 0.16, 0.06, "Üyeyi Uzaklaştır", true, tabOverview)
			gButtonLeader = guiCreateButton(0.825, 0.1526, 0.16, 0.06, "Lider Durumunu Değiştir", true, tabOverview)
			gButtonPromote = guiCreateButton(0.825, 0.2292, 0.16, 0.06, "Üyeyi Tanıt / İndir", true, tabOverview)
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				gButtonEditRanks = guiCreateButton(0.825, 0.3058, 0.16, 0.06, "Dereceleri ve Ücretleri Düzenle", true, tabOverview)
			else
				gButtonEditRanks = guiCreateButton(0.825, 0.3058, 0.16, 0.06, "Sıralamaları Düzenle", true, tabOverview)
			end
			
			gButtonEditMOTD = guiCreateButton(0.825, 0.3824, 0.16, 0.06, "MOTD'yi Düzenle", true, tabOverview)
			gButtonInvite = guiCreateButton(0.825, 0.459, 0.16, 0.06, "Üyeyi Davet Et", true, tabOverview)
			gButtonRespawnui = guiCreateButton(0.825, 0.5356, 0.16, 0.06, "Yeniden Doğmuş Araçlar", true, tabOverview)

			local _y = 0.6122
			if phone then
				gAssignPhone = guiCreateButton(0.825, _y, 0.16, 0.06, "Telefon Numarası.", true, tabOverview)
				addEventHandler("onClientGUIClick", gAssignPhone, btPhoneNumber, false)	
				_y = _y + 0.6122 - 0.5356
			end

			if factionPackages and factionType >= 2 then
				gButtonPerk = guiCreateButton(0.825, _y, 0.16, 0.06, "Görev Özelliklerini Yönet", true, tabOverview)
				addEventHandler("onClientGUIClick", gButtonPerk, btButtonPerk, false)
			end
			
			addEventHandler("onClientGUIClick", gButtonKick, btKickPlayer, false)
			addEventHandler("onClientGUIClick", gButtonLeader, btToggleLeader, false)
			addEventHandler("onClientGUIClick", gButtonPromote, btPromotePlayer, false)	
			addEventHandler("onClientGUIClick", gButtonEditRanks, btEditRanks, false)
			addEventHandler("onClientGUIClick", gButtonEditMOTD, btEditMOTD, false)
			addEventHandler("onClientGUIClick", gButtonInvite, btInvitePlayer, false)
			addEventHandler("onClientGUIClick", gButtonRespawnui, showrespawn, false)
			
			tabVehicles = guiCreateTab("(Leader) Vehicles", tabs)
		
			gVehicleGrid = guiCreateGridList(0.01, 0.015, 0.8, 0.905, true, tabVehicles)
		
			colVehID = guiGridListAddColumn(gVehicleGrid, "ID (VIN)", 0.1)
			colVehModel = guiGridListAddColumn(gVehicleGrid, "Model", 0.30)
			colVehPlates = guiGridListAddColumn(gVehicleGrid, "Plaka", 0.1)
			colVehLocation = guiGridListAddColumn(gVehicleGrid, "Lokasyon", 0.4)
			gButtonVehRespawn = guiCreateButton(0.825, 0.076, 0.16, 0.06, "Araç Yenile", true, tabVehicles)
			gButtonAllVehRespawn = guiCreateButton(0.825, 0.1526, 0.16, 0.06, "Tüm Araçları Yenile", true, tabVehicles)

			for index, vehID in ipairs(vehicleIDs) do
				local row = guiGridListAddRow(gVehicleGrid)
				guiGridListSetItemText(gVehicleGrid, row, colVehID, tostring(vehID), false, true)
				guiGridListSetItemText(gVehicleGrid, row, colVehModel, tostring(vehicleModels[index]), false, false)
				guiGridListSetItemText(gVehicleGrid, row, colVehPlates, tostring(vehiclePlates[index]), false, false)
				guiGridListSetItemText(gVehicleGrid, row, colVehLocation, tostring(vehicleLocations[index]), false, false)
			end
			addEventHandler("onClientGUIClick", gButtonVehRespawn, btRespawnOneVehicle, false)
			addEventHandler("onClientGUIClick", gButtonAllVehRespawn, showrespawn, false)
			
			tabNote = guiCreateTab("(Lider) Not", tabs)
			eNote = guiCreateMemo(0.01, 0.02, 0.98, 0.87, note or "", true, tabNote)
			gButtonSaveNote = guiCreateButton(0.79, 0.90, 0.2, 0.08, "Kaydet", true, tabNote)
			addEventHandler("onClientGUIClick", gButtonSaveNote, btUpdateNote, false)

			-- towstats
			if towstats then
				tabTowstats = guiCreateTab("(Lider) Towstats", tabs)
				gTowGrid = guiCreateGridList(0.01, 0.015, 0.8, 0.905, true, tabTowstats)

				local totals = {[0] = 0, [-1] = 0, [-2] = 0, [-3] = 0, [-4] = 0}
				local colName = guiGridListAddColumn(gTowGrid, 'İsim', 0.2)
				local colRank = guiGridListAddColumn(gTowGrid, 'Rütbe', 0.2)
				local cols = {
					[0] = guiGridListAddColumn(gTowGrid, 'bu hafta', 0.1),
					[-1] = guiGridListAddColumn(gTowGrid, 'geçen hafta', 0.1),
					[-2] = guiGridListAddColumn(gTowGrid, '2 hafta önce', 0.1),
					[-3] = guiGridListAddColumn(gTowGrid, '3 hafta önce', 0.1),
					[-4] = guiGridListAddColumn(gTowGrid, '4 hafta önce', 0.1)
				}

				for k, v in ipairs(memberUsernames) do
					local row = guiGridListAddRow(gTowGrid)
					guiGridListSetItemText(gTowGrid, row, colName, v:gsub("_", " "), false, false)

					local theRank = tonumber(memberRanks[k])
					local rankName = factionRanks[theRank]
					guiGridListSetItemText(gTowGrid, row, colRank, tostring(rankName), false, false)
			
					local stats = towstats[v] or {}
					for week, col in pairs(cols) do
						guiGridListSetItemText(gTowGrid, row, col, tostring(stats[week] or ""), false, true)
						totals[week] = totals[week] + (stats[week] or 0)
					end
				end

				local row = guiGridListAddRow(gTowGrid)
				guiGridListSetItemText(gTowGrid, row, colName, "Totals", true, false)
				for week, col in pairs(cols) do
					guiGridListSetItemText(gTowGrid, row, col, tostring(totals[week] or 0), true, true)
				end
			end

			-- for faction-wide note
			tabFNote = guiCreateTab("Not", tabs)
			fNote = guiCreateMemo(0.01, 0.02, 0.98, 0.87, fnote or "", true, tabFNote)
			guiMemoSetReadOnly(fNote, false)
			gButtonSaveFNote = guiCreateButton(0.79, 0.90, 0.2, 0.08, "Kaydet", true, tabFNote)
			addEventHandler("onClientGUIClick", gButtonSaveFNote, btUpdateFNote, false)

			tabFinance = guiCreateTab("(Lider) Finans", tabs)
			addEventHandler("onClientGUITabSwitched", tabFinance, loadFinance)

			if factionType >= 2 then
				tabDuty = guiCreateTab("(Lider) Duty Ayarları", tabs)
				addEventHandler("onClientGUITabSwitched", tabDuty, createDutyMain)
			end

		else -- for faction-wide note
			tabFNote = guiCreateTab("Note", tabs)
			fNote = guiCreateMemo(0.01, 0.02, 0.98, 0.87, fnote or "", true, tabFNote)
			guiMemoSetReadOnly(fNote, true)
		end
			
			gButtonQuit = guiCreateButton(0.825, 0.7834, 0.16, 0.06, "Birlikten Ayrılma", true, tabOverview)
			gButtonExit = guiCreateButton(0.825, 0.86, 0.16, 0.06, "Arayüzü Kapat", true, tabOverview)
			gMOTDLabel = guiCreateLabel(0.015, 0.935, 0.95, 0.15, tostring(motd), true, tabOverview)
			guiSetFont(gMOTDLabel, "default-small")
			
			addEventHandler("onClientGUIClick", gButtonQuit, btQuitFaction, false)
			addEventHandler("onClientGUIClick", gButtonExit, hideFactionMenu, false)

			guiSetEnabled(gButtonQuit, getElementData(getLocalPlayer(), 'faction') == getElementData(factionTheTeam, 'id'))

			addEventHandler("onClientRender", getRootElement(), checkF3)
			f3state = getKeyState( "f3" )
			showCursor(true)
	else
		hideFactionMenu()
		showCursor(false)
	end
	
end
addEvent("showFactionMenu", true)
addEventHandler("showFactionMenu", getRootElement(), showFactionMenu)

function showrespawn()
	local sx, sy = guiGetScreenSize() 
	
	showrespawnUI = guiCreateWindow(sx/2 - 150,sy/2 - 50,300,100,"Araça Yenileme", false)
	local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"İhtilaf araçlarını yeniden canlandırmak istediğinizden emin misiniz?",true,showrespawnUI)
	guiLabelSetHorizontalAlign (lQuestion,"center",true)
	gButtonRespawn = guiCreateButton(0.1,0.65,0.37,0.23,"Evet",true,showrespawnUI)
	gButtonNo = guiCreateButton(0.53,0.65,0.37,0.23,"Hayır",true,showrespawnUI)

			addEventHandler("onClientGUIClick", gButtonRespawn, btRespawnVehicles, false)
			addEventHandler("onClientGUIClick", gButtonNo, btRespawnVehicles, false)
end
addEvent("showrespawn",true)
addEventHandler("showrespawn", getRootElement(), showrespawn)

-- BUTTON EVENTS

-- RANKS/WAGES

lRanks = { }
tRanks = { }
tRankWages = { }
wRanks = nil
bRanksSave, bRanksClose = nil

function btEditRanks(button, state)
	if (source==gButtonEditRanks) and (button=="left") and (state=="up") then
		local factionType = tonumber(getElementData(theTeam, "type"))
		lRanks = { }
		tRanks = { }
		tRankWages = { }
		
		guiSetInputEnabled(true)
		
		local wages = (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7)  -- Added Mechanic type \ Adams
		local width, height = 400, 540
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)
		
		wRanks = guiCreateWindow(x, y, width, height, "Dereceler ve Ücretler", false)
		
		local y = 0
		for i=1, 20 do
			y = ( y or 0 ) + 23
			lRanks[i] = guiCreateLabel(0.05 * width, y + 3, 0.4 * width, 20, "Rank #" .. i .. " Unvan ve Ücret: ", false, wRanks)
			guiSetFont(lRanks[i], "default-bold-small")
			tRanks[i] = guiCreateEdit(0.4 * width, y, ( wages and 0.33 or 0.55 ) * width, 20, arrFactionRanks[i], false, wRanks)
			if wages then
				tRankWages[i] = guiCreateEdit(0.75 * width, y, 0.2 * width, 20, tostring(arrFactionWages[i]), false, wRanks)
			end
		end
		
		bRanksSave = guiCreateButton(0.05, 0.900, 0.9, 0.045, "Kaydet!", true, wRanks)
		bRanksClose = guiCreateButton(0.05, 0.950, 0.9, 0.045, "Arayüzü Kapat", true, wRanks)
		
		addEventHandler("onClientGUIClick", bRanksSave, saveRanks, false)
		addEventHandler("onClientGUIClick", bRanksClose, closeRanks, false)
	end
end

function saveRanks(button, state)
	if (source==bRanksSave) and (button=="left") and (state=="up") then
		local found = false
		local isNumber = true
		for key, value in ipairs(tRanks) do
			if (string.find(guiGetText(tRanks[key]), ";")) or (string.find(guiGetText(tRanks[key]), "'")) then
				found = true
			end
		end
		
		local factionType = tonumber(getElementData(theTeam, "type"))
		if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
			for key, value in ipairs(tRankWages) do
				if not (tostring(type(tonumber(guiGetText(tRankWages[key])))) == "number") then
					isNumber = false
				end
			end
		end
		
		if (found) then
			outputChatBox("[!] #f4f4f4Sıralamalarınız geçersiz karakterler içeriyor, lütfen aşağıdaki gibi karakterler içermediğinden emin olun '@.;", 255, 0, 0, true)
		elseif not (isNumber) then
			outputChatBox("!] #f4f4f4Ücretleriniz sayı değil, lütfen bir sayı girdiğinizden ve para birimi simgesi olmadığından emin olun.", 255, 0, 0, true)
		else
			local sendRanks = { }
			local sendWages = { }
			
			for key, value in ipairs(tRanks) do
				sendRanks[key] = guiGetText(tRanks[key])
			end
			
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				for key, value in ipairs(tRankWages) do
					sendWages[key] = guiGetText(tRankWages[key])
				end
			end
			
			hideFactionMenu()
			if (factionType==2) or (factionType==3) or (factionType==4) or (factionType==5) or (factionType==6) or (factionType==7) then -- Added Mechanic type \ Adams
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks, sendWages)
			else
				triggerServerEvent("cguiUpdateRanks", getLocalPlayer(), sendRanks)
			end
		end
	end
end

function closeRanks(button, state)
	if (source==bRanksClose) and (button=="left") and (state=="up") then
		if (wRanks) then
			destroyElement(wRanks)
			lRanks, tRanks, tRankWages, wRanks, bRanksSave, bRanksClose = nil, nil, nil, nil, nil, nil
			guiSetInputEnabled(false)
		end
	end
end

-- MOTD
wMOTD, tMOTD, bUpdate, bMOTDClose = nil
function btEditMOTD(button, state)
	if (source==gButtonEditMOTD) and (button=="left") and (state=="up") then
		if not (wMOTD) then
			local width, height = 300, 200
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)
			
			wMOTD = guiCreateWindow(x, y, width, height, "Günün mesajı", false)
			tMOTD = guiCreateEdit(0.1, 0.2, 0.85, 0.1, tostring(theMotd), true, wMOTD)
			
			guiSetInputEnabled(true)
			
			bUpdate = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Güncelleme!", true, wMOTD)
			addEventHandler("onClientGUIClick", bUpdate, sendMOTD, false)
			
			bMOTDClose= guiCreateButton(0.1, 0.775, 0.85, 0.15, "Arayüzü Kapat", true, wMOTD)
			addEventHandler("onClientGUIClick", bMOTDClose, closeMOTD, false)
		else
			guiBringToFront(wMOTD)
		end
	end
end

function closeMOTD(button, state)
	if (source==bMOTDClose) and (button=="left") and (state=="up") then
		if (wMOTD) then
			destroyElement(wMOTD)
			wMOTD, tMOTD, bUpdate, bMOTDClose = nil, nil, nil, nil
		end
	end
end

function sendMOTD(button, state)
	if (source==bUpdate) and (button=="left") and (state=="up") then
		local motd = guiGetText(tMOTD)
		
		local found1 = string.find(motd, ";")
		local found2 = string.find(motd, "'")
		
		if (found1) or (found2) then
			outputChatBox("[!] #f4f4f4Mesajınız geçersiz karakterler içeriyor.", 255, 0, 0, true)
		else
			guiSetText(gMOTDLabel, tostring(motd))
			theMOTD = motd -- Store it clientside
			triggerServerEvent("cguiUpdateMOTD", getLocalPlayer(), motd)
		end
	end
end

-- NOTE
function btUpdateNote(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("faction:note", getLocalPlayer(), guiGetText(eNote))
	end
end

-- FACTION NOTE
function btUpdateFNote(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("faction:fnote", getLocalPlayer(), guiGetText(fNote))
	end
end

-- INVITE
wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil
function btInvitePlayer(button, state)
	if (source==gButtonInvite) and (button=="left") and (state=="up") then
		if not (wInvite) then
			local width, height = 300, 200
			local scrWidth, scrHeight = guiGetScreenSize()
			local x = scrWidth/2 - (width/2)
			local y = scrHeight/2 - (height/2)
			
			wInvite = guiCreateWindow(x, y, width, height, "Oyuncu Davet Et", false)
			tInvite = guiCreateEdit(0.1, 0.2, 0.85, 0.1, "Kısmi Oyuncu Adı", true, wInvite)
			addEventHandler("onClientGUIChanged", tInvite, checkNameExists)
					
			lNameCheck = guiCreateLabel(0.1, 0.325, 0.8, 0.3, "Oyuncu bulunamadı veya çoklu bulundu.", true, wInvite)
			guiSetFont(lNameCheck, "default-bold-small")
			guiLabelSetColor(lNameCheck, 255, 0, 0)
			guiLabelSetHorizontalAlign(lNameCheck, "center")
			
			guiSetInputEnabled(true)
			
			bInvite = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Davet et!", true, wInvite)
			guiSetEnabled(bInvite, false)
			addEventHandler("onClientGUIClick", bInvite, sendInvite, false)
			
			bCloseInvite = guiCreateButton(0.1, 0.775, 0.85, 0.15, "Arayüzü Kapat", true, wInvite)
			addEventHandler("onClientGUIClick", bCloseInvite, closeInvite, false)
		else
			guiBringToFront(wInvite)
		end
	end
end

function closeInvite(button, state)
	if (source==bCloseInvite) and (button=="left") and (state=="up") then
		if (wInvite) then
			destroyElement(wInvite)
			wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil, nil, nil, nil, nil, nil
		end
	end
end

function sendInvite(button, state)
	if (source==bInvite) and (button=="left") and (state=="up") then
		triggerServerEvent("cguiInvitePlayer", getLocalPlayer(), invitedPlayer)
	end
end

function checkNameExists(theEditBox)
	local found = nil
	local foundstr = ""
	local count = 0
	
	local players = getElementsByType("player")
	for key, value in ipairs(players) do
		local username = string.lower(tostring(getPlayerName(value)))
		if (string.find(username, string.lower(tostring(guiGetText(theEditBox))))) and (guiGetText(theEditBox)~="") then
			count = count + 1
			found = value
			foundstr = username
		end
	end
	
	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
		guiMemoSetReadOnly(tInvite, true)
		guiSetEnabled(bInvite, false)
	elseif (count==1) then
		guiSetText(lNameCheck, "Player Found. ("..foundstr..")")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		invitedPlayer = found
		guiMemoSetReadOnly(tInvite, false)
		guiSetEnabled(bInvite, true)
	elseif (count==0) then
		guiSetText(lNameCheck, "Oyuncu bulunamadı veya çoklu bulundu.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
		guiMemoSetReadOnly(tInvite, true)
		guiSetEnabled(bInvite, false)
	end
	guiLabelSetHorizontalAlign(lNameCheck, "center")
end

function btQuitFaction(button, state)
	if (button=="left") and (state=="up") and (source==gButtonQuit) then
		local numLeaders = 0
		local isLeader = false
		local localUsername = getPlayerName(getLocalPlayer())
		
		for k, v in ipairs(arrUsernames) do -- Find the player
			if (v==localUsername) then -- Found
				isLeader = arrLeaders[k]
			end
		end
		
		for k, v in ipairs(arrLeaders) do
			numLeaders = numLeaders + 1
		end
		
		--if (numLeaders==1) and (isLeader) then
			--outputChatBox("You must promote someone to lead this faction before quitting. You are the only leader.", 255, 0, 0)
		--else
			local sx, sy = guiGetScreenSize() 
			wConfirmQuit = guiCreateWindow(sx/2 - 125,sy/2 - 50,250,100,"Ayrılma Teyidi", false)
			local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,"Gerçekten ayrılmak istiyor musun " .. getTeamName(theTeam) .. "?",true,wConfirmQuit)
			guiLabelSetHorizontalAlign (lQuestion,"center",true)
			local bYes = guiCreateButton(0.1,0.65,0.37,0.23,"Evet",true,wConfirmQuit)
			local bNo = guiCreateButton(0.53,0.65,0.37,0.23,"Hayır",true,wConfirmQuit)
			addEventHandler("onClientGUIClick", getRootElement(), 
				function(button)
					if button=="left" and ( source == bYes or source == bNo ) then
						if source == bYes then
							hideFactionMenu()
							triggerServerEvent("cguiQuitFaction", getLocalPlayer())
						end
						if wConfirmQuit then
							destroyElement(wConfirmQuit)
							wConfirmQuit = nil
						end
					end
				end
			)
		--end
	end
end

function btKickPlayer(button, state)
	if (button=="left") and (state=="up") and (source==gButtonKick) then
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
			
		--if (playerName==getPlayerName(getLocalPlayer())) then
			--outputChatBox("You cannot kick yourself, quit instead.", thePlayer)
		--[[else]]if (playerName~="") then
			local row = guiGridListGetSelectedItem(gMemberGrid)
			guiGridListRemoveRow(gMemberGrid, row)
			
			local theTeamName = getTeamName(theTeam)
			
			outputChatBox("You removed " .. playerName:gsub("_", " ") .. " from the faction '" .. tostring(theTeamName) .. "'.", 0, 255, 0)
			triggerServerEvent("cguiKickPlayer", getLocalPlayer(), playerName)
		else
			outputChatBox("Please select a member to kick.")
		end
	end
end

function btButtonPerk(button, state)
	if (button=="left") and (state=="up") and (source==gButtonPerk) then
		local bPerkActivePlayer = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1)
		local playerName = string.gsub(bPerkActivePlayer, " ", "_")
		if (playerName == "") then
			outputChatBox("Please select a member to manage.")
			return
		end
		triggerServerEvent("Duty:GetPackages", resourceRoot, factionID1)
	end
end

wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
function gotPackages(factionPackages)
	bPerkChkTable = { }
	local bPerkActivePlayer = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1)
	local playerName = string.gsub(bPerkActivePlayer, " ", "_")
			
	guiSetInputEnabled(true)
	
	local width, height = 500, 540
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wPerkWindow = guiCreateWindow(x, y, width, height, "İhtilaf avantajları "..playerName, false)
	
	local factionPerks = false
	for k, v in ipairs(arrUsernames) do -- Find the player
		if (v==playerName) then -- Found
			factionPerks = arrPerks[k]
			--outputDebugString(getElementType(factionPerks))
			--outputDebugString(tostring(factionPerks))
		end
	end
	
	if not factionPerks then
		outputChatBox("Yükleme başarısız "..playerName.. " hizip avantajları")
		factionPerks = { }
	end
	
	local y = 0
	for index, factionPackage in pairs ( factionPackages ) do
		y = ( y or 0 ) + 20
		local tmpChk = guiCreateCheckBox(0.05 * width, y + 3, 0.4 * width, 17, factionPackage[2], false, false, wPerkWindow)
		guiSetFont(tmpChk, "default-bold-small")
		setElementData(tmpChk, "factionPackage:ID", factionPackage[1], false)
		setElementData(tmpChk, "factionPackage:selected", bPerkActivePlayer, false)
		
		for index, permissionID in pairs(factionPerks) do
			--outputDebugString(tostring(factionPackage["grantID"]) .. " vs "..tostring(permissionID))
			if (permissionID == factionPackage[1]) then
				--outputDebugString("win!")
				guiCheckBoxSetSelected (tmpChk, true)
			end
		end
		
		table.insert(bPerkChkTable, tmpChk)
	end
	
	bPerkSave = guiCreateButton(0.05, 0.900, 0.9, 0.045, "Kaydet", true, wPerkWindow)
	bPerkClose = guiCreateButton(0.05, 0.950, 0.9, 0.045, "Kapat", true, wPerkWindow)
	addEventHandler("onClientGUIClick", bPerkSave, 
		function (button, state)
			if (source == bPerkSave) and (button=="left") and (state=="up") then
				if (wPerkWindow) then
					local collectedPerks = { }
					for _, checkBox in ipairs ( bPerkChkTable ) do
						if ( guiCheckBoxGetSelected( checkBox ) ) then
							table.insert(collectedPerks, getElementData(checkBox, "factionPackage:ID") or -1 )
						end
					end
					
					triggerServerEvent("faction:perks:edit", getLocalPlayer(), collectedPerks, playerName)
					destroyElement(wPerkWindow)
					wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
					guiSetInputEnabled(false)
				end
			end
		end
	, false)
	addEventHandler("onClientGUIClick", bPerkClose, 
		function (button, state)
			if (source == bPerkClose) and (button=="left") and (state=="up") then
				if (wPerkWindow) then
					destroyElement(wPerkWindow)
					wPerkWindow, bPerkSave, bPerkClose, bPerkChkTable, bPerkActivePlayer = nil
					guiSetInputEnabled(false)
				end
			end
		end
	, false)
end
addEvent("Duty:GotPackages", true)
addEventHandler("Duty:GotPackages", resourceRoot, gotPackages)

function btRespawnOneVehicle(button, state)
	if button == "left" and state == "up" then
		local vehID = guiGridListGetItemText(gVehicleGrid, guiGridListGetSelectedItem(gVehicleGrid), 1)
		if vehID then
			triggerServerEvent("cguiRespawnOneVehicle", getLocalPlayer(), vehID)
		else
			outputChatBox("Please select a vehicle to respawn.", 255, 0, 0)
		end
	end
end

function btToggleLeader(button, state)
	if (button=="left") and (state=="up") and (source==gButtonLeader) then
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
		local currentLevel = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 5)

		if (playerName==getPlayerName(getLocalPlayer())) then
			outputChatBox("You cannot un-leader yourself.", thePlayer)
		elseif (playerName~="") then
			local row = guiGridListGetSelectedItem(gMemberGrid)
			
			if (currentLevel=="Leader") then
				guiGridListSetItemText(gMemberGrid, row, tonumber(colLeader), "Member", false, false)
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				triggerServerEvent("cguiToggleLeader", getLocalPlayer(), playerName, false) -- false = not leader
			else
				guiGridListSetItemText(gMemberGrid, row, tonumber(colLeader), "Leader", false, false)
				guiGridListSetSelectedItem(gMemberGrid, 0, 0)
				triggerServerEvent("cguiToggleLeader", getLocalPlayer(), playerName, true) -- true = leader
			end
		else
			outputChatBox("Lider arasında geçiş yapmak için lütfen bir üye seçin.")
		end
	end
end


-- PHONE
local wPhone, tPhone
function btPhoneNumber(button, state)
	if (button=="left") and (state=="up") and (source==gAssignPhone) then
		local row = guiGridListGetSelectedItem(gMemberGrid)
		local playerName = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1)
		if playerName ~= "" then
			local currentPhone = guiGridListGetItemText(gMemberGrid, row, colPhone):gsub(tmpPhone .. "%-", "")

			if not (wPhone) then
				local width, height = 300, 200
				local scrWidth, scrHeight = guiGetScreenSize()
				local x = scrWidth/2 - (width/2)
				local y = scrHeight/2 - (height/2)
				
				wPhone = guiCreateWindow(x, y, width, height, "Telefon Numarası", false)
				tPhone = guiCreateEdit(0.3, 0.325, 0.85, 0.1, currentPhone, true, wPhone)
				guiSetProperty(tPhone, "ValidationString","[0-9]{0,2}")

				local tPre = guiCreateLabel(0.1, 0.325, 0.18, 0.1, tostring(tmpPhone) .. " -", true, wPhone)
				guiLabelSetHorizontalAlign(tPre, "right")
				guiSetFont(tPre, "default-bold-small")
				guiLabelSetVerticalAlign(tPre, "center")

				guiCreateLabel(0.1, 0.2, 0.8, 0.08, "İçin telefon numarası " .. playerName .. ":", true, wPhone)

				guiSetInputEnabled(true)
				
				bSet = guiCreateButton(0.1, 0.6, 0.85, 0.15, "Telefon not ata.", true, wPhone)
				addEventHandler("onClientGUIClick", bSet, setPhoneNumber, false)
				
				bClosePhone = guiCreateButton(0.1, 0.775, 0.85, 0.15, "Arayüzü Kapat", true, wPhone)
				addEventHandler("onClientGUIClick", bClosePhone, closePhone, false)


				addEventHandler("onClientGUIChanged", tPhone, function(element)
					guiSetEnabled(bSet, guiGetText(element) == "" or (#guiGetText(element) == 2 and type(tonumber(guiGetText(element))) == 'number' and numberIsUnused(tonumber(guiGetText(element)))))
					end, false)
			else
				guiBringToFront(wPhone)
			end
		else
			outputChatBox("Lider arasında geçiş yapmak için lütfen bir üye seçin.")
		end
	end
end

function closePhone(button, state)
	if (wPhone) then
		destroyElement(wPhone)
		wPhone = nil
	end
end

function setPhoneNumber(button, state)
	local text = guiGetText(tPhone)
	local num = tonumber(text)

	if text == "" then
		guiGridListSetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), colPhone, "", false, false)
	elseif #text and num then
		guiGridListSetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), colPhone, tostring(tmpPhone) .. "-" .. ("%02d"):format(num), false, true)
	else
		return "Geçersiz format"
	end
	local playerName = guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1):gsub(" ", "_")

	triggerServerEvent("factionmenu:setphone", getLocalPlayer(), playerName, num)
	closePhone(button, state)
end

function numberIsUnused(number)
	local testText = tostring(tmpPhone) .. "-" .. ("%02d"):format(number)
	for i = 0, guiGridListGetRowCount(gMemberGrid) do
		if guiGridListGetItemText(gMemberGrid, i, colPhone) == testText and i ~= guiGridListGetSelectedItem(gMemberGrid) then
			return false
		end
	end
	return true
end

--

function btPromotePlayer(button, state)
	if (button=="left") and (state=="up") and (source==gButtonPromote) then
		local row = guiGridListGetSelectedItem(gMemberGrid)
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
		local currentRank = guiGridListGetItemText(gMemberGrid, row, 2)
		if (playerName~="") then
			local currRankNumber = tonumber( guiGridListGetItemData(gMemberGrid, row, colRank) )
			promotionWindow[1] = guiCreateWindow(0.3887,0.2383,0.1713,0.5834,"Oyuncuyu Tanıt / İndir",true)
			guiWindowSetSizable(promotionWindow[1], false)
			promotionLabel[1] = guiCreateLabel(0.0427,0.058,0.9145,0.044,"Lütfen Player_Name'in yeni sıralamasını seçin",true,promotionWindow[1])
			promotionRadio[20] = guiCreateRadioButton(0.047,0.1071,0.9145,0.0402,"Generic Rank 20",true,promotionWindow[1])
			promotionRadio[19] = guiCreateRadioButton(0.047,0.1473,0.9145,0.0402,"Generic Rank 19",true,promotionWindow[1])
			promotionRadio[18] = guiCreateRadioButton(0.047,0.1875,0.9145,0.0402,"Generic Rank 18",true,promotionWindow[1])
			promotionRadio[17] = guiCreateRadioButton(0.047,0.2277,0.9145,0.0402,"Generic Rank 17",true,promotionWindow[1])
			promotionRadio[16] = guiCreateRadioButton(0.047,0.2679,0.9145,0.0402,"Generic Rank 16",true,promotionWindow[1])
			promotionRadio[15] = guiCreateRadioButton(0.047,0.308,0.9145,0.0402,"Generic Rank 15",true,promotionWindow[1])
			promotionRadio[14] = guiCreateRadioButton(0.047,0.3482,0.9145,0.0402,"Generic Rank 14",true,promotionWindow[1])
			promotionRadio[13] = guiCreateRadioButton(0.047,0.3884,0.9145,0.0402,"Generic Rank 13",true,promotionWindow[1])
			promotionRadio[12] = guiCreateRadioButton(0.047,0.4286,0.9145,0.0402,"Generic Rank 12",true,promotionWindow[1])
			promotionRadio[11] = guiCreateRadioButton(0.047,0.4688,0.9145,0.0402,"Generic Rank 11",true,promotionWindow[1])
			promotionRadio[10] = guiCreateRadioButton(0.047,0.5089,0.9145,0.0402,"Generic Rank 10",true,promotionWindow[1])
			promotionRadio[9] = guiCreateRadioButton(0.047,0.5491,0.9145,0.0402,"Generic Rank 9",true,promotionWindow[1])
			promotionRadio[8] = guiCreateRadioButton(0.047,0.5893,0.9145,0.0402,"Generic Rank 8",true,promotionWindow[1])
			promotionRadio[7] = guiCreateRadioButton(0.047,0.6295,0.9145,0.0402,"Generic Rank 7",true,promotionWindow[1])
			promotionRadio[6] = guiCreateRadioButton(0.047,0.6696,0.9145,0.0402,"Generic Rank 6",true,promotionWindow[1])
			promotionRadio[5] = guiCreateRadioButton(0.047,0.7098,0.9145,0.0402,"Generic Rank 5",true,promotionWindow[1])
			promotionRadio[4] = guiCreateRadioButton(0.047,0.75,0.9145,0.0402,"Generic Rank 4",true,promotionWindow[1])
			promotionRadio[3] = guiCreateRadioButton(0.047,0.7902,0.9145,0.0402,"Generic Rank 3",true,promotionWindow[1])
			promotionRadio[2] = guiCreateRadioButton(0.047,0.8304,0.9145,0.0402,"Generic Rank 2",true,promotionWindow[1])
			promotionRadio[1] = guiCreateRadioButton(0.047,0.8705,0.9145,0.0402,"Generic Rank 1",true,promotionWindow[1])
			promotionButton[1] = guiCreateButton(0.0427,0.9107,0.4231,0.067,"Save",true,promotionWindow[1])
			promotionButton[2] = guiCreateButton(0.5214,0.9107,0.4231,0.067,"Close",true,promotionWindow[1])
			guiRadioButtonSetSelected(promotionRadio[currRankNumber], true)
			guiSetText(promotionLabel[1], "Lütfen yeni " .. playerName:gsub("_"," ") .. "'ın yeni rütbesini seçin.")
			for i = 1, 20 do
				guiSetText(promotionRadio[i], "Rütbe " .. i .. ": " .. arrFactionRanks[i])
			end
			addEventHandler("onClientGUIClick", promotionButton[1], savePromotion, false)
			addEventHandler("onClientGUIClick", promotionButton[2], closePromotion, false)
		else
			outputChatBox("Lütfen tanıtmak / indirmek için bir üye seçin.", 255, 0, 0)
		end
	end
end

function savePromotion(button, state)
	if button == "left" and state == "up" and source == promotionButton[1] then
		local newRank = 0
		for key, value in ipairs(promotionRadio) do
			if isElement(value) then
				if guiRadioButtonGetSelected(value) then
					newRank = key
					break
				end
			end
		end
		local row = guiGridListGetSelectedItem(gMemberGrid)
		local playerName = string.gsub(guiGridListGetItemText(gMemberGrid, guiGridListGetSelectedItem(gMemberGrid), 1), " ", "_")
		local currRankNumber = tonumber(guiGridListGetItemData(gMemberGrid, row, colRank))
		if newRank == currRankNumber then
			outputChatBox("You must select a new rank to make the player", 255, 0, 0)
			closePromotion("left", "up")
		elseif newRank > currRankNumber then
			guiGridListSetItemData(gMemberGrid, row, colRank, tostring(newRank))
			triggerServerEvent("cguiPromotePlayer", getLocalPlayer(), playerName, newRank, arrFactionRanks[currRankNumber], arrFactionRanks[newRank])
			guiGridListSetSelectedItem(gMemberGrid, row, colRank)
			closePromotion("left", "up")
		elseif newRank < currRankNumber then
			guiGridListSetItemData(gMemberGrid, row, colRank, tostring(newRank))
			triggerServerEvent("cguiDemotePlayer", getLocalPlayer(), playerName, newRank, arrFactionRanks[currRankNumber], arrFactionRanks[newRank])
			guiGridListSetSelectedItem(gMemberGrid, row, colRank)
			closePromotion("left", "up")
		else
			outputChatBox("FAC-PRMO-ERROR-0001 - Please report on the forums.", 255, 0, 0)
		end
	end
end

function closePromotion(button, state)
	if button == "left" and state == "up" then
		destroyElement(promotionWindow[1])
	end
end

function reselectItem(grid, row, col)
	guiGridListSetSelectedItem(grid, row, col)
end

function hideFactionMenu()
	showCursor(false)
	guiSetInputEnabled(false)
	
	if (gFactionWindow) then
		destroyElement(gFactionWindow)
	end
	if isTimer(zaman) then
		killTimer(zaman)
	end
	if (isElement(gFactionWindow2)) then
		destroyElement(gFactionWindow2)
	end
	
	if (isElement(loadingLabel)) then
		destroyElement(loadingLabel)
	end
	

	
	gFactionWindow, gMemberGrid,gFactionWindow2,loadingLabel = nil
	triggerServerEvent("factionmenu:hide", getLocalPlayer())
	
	if (wInvite) then
		destroyElement(wInvite)
		wInvite, tInvite, lNameCheck, bInvite, bInviteClose, invitedPlayer = nil, nil, nil, nil, nil, nil
	end

	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end
	
	if (wMOTD) then
		destroyElement(wMOTD)
		wMOTD, tMOTD, bUpdate, bMOTDClose = nil, nil, nil, nil
	end
	
	if (wRanks) then
		destroyElement(wRanks)
		lRanks, tRanks, tRankWages, wRanks, bRanksSave, bRanksClose = nil, nil, nil, nil, nil, nil
	end
	
	--[[if (showrespawn) then
		destroyElement(showrespawn)
		gButtonRespawn, bButtonNo = nil, nil

	end]]--
	local t = getElementData(resourceRoot, "DutyGUI") or {}
	if t[getLocalPlayer()] then
		t[getLocalPlayer()] = nil
		setElementData(resourceRoot, "DutyGUI", t)
	end
	
	if isElement(tabDuty) then
		destroyElement(tabDuty)
	end

	if isElement(promotionWindow[1]) then
		destroyElement(promotionWindow[1])
	end
	triggerEvent( 'hud:blur', resourceRoot, 'off' )
	-- Clear variables (should reduce lag a tiny bit clientside)
	gFactionWindow, gMemberGrid, gMOTDLabel, colName, colRank, colWage, colLastLogin, --[[colLocation,]] colLeader, colOnline, gButtonKick, gButtonPromote, gButtonDemote, gButtonEditRanks, gButtonEditMOTD, gButtonInvite, gButtonLeader, gButtonQuit, gButtonExit = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	theMotd, theTeam, arrUsernames, arrRanks, arrLeaders, arrOnline, arrFactionRanks, --[[arrLocations,]] arrFactionWages, arrLastLogin, membersOnline, membersOffline = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
	removeEventHandler("onClientRender", getRootElement(), checkF3)
end
addEvent("hideFactionMenu", true)
addEventHandler("hideFactionMenu", getRootElement(), hideFactionMenu)

function resourceStopped()
	showCursor(false)
	guiSetInputEnabled(false)

	setElementData(getLocalPlayer(), "savedLocations", false)
	setElementData(getLocalPlayer(), "savedSkins", false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStopped)

function btRespawnVehicles(button, state)
	if (button=="left") then
		if source == gButtonRespawn then
			hideFactionMenu()
			destroyElement(showrespawnUI)
			triggerServerEvent("cguiRespawnVehicles", getLocalPlayer())
		elseif source == gButtonNo then
			hideFactionMenu()
			destroyElement(showrespawnUI)
		end
	end
end

function loadFinance()
	if source == tabFinance then
		if not financeLoaded then	
			local label = guiCreateLabel(0,0,1,1,"Loading...",true,tabFinance)
			guiLabelSetHorizontalAlign(label, "center", false)
			guiLabelSetVerticalAlign(label, "center")
			triggerServerEvent("factionmenu:getFinance", getResourceRootElement())
		end
	end
end

function fillFinance(factionID, bankThisWeek, bankPrevWeek, bankmoney, vehiclesvalue, propertiesvalue)
	financeLoaded = true
	for k,v in ipairs(getElementChildren(tabFinance)) do
		destroyElement(v)
	end

	local financeTabs = guiCreateTabPanel(10, 36, 1048, 346, false, tabFinance)

	--[[
	financeCombo = guiCreateComboBox(12, 8, 123, 70, "This week", false, tabFinance)
	guiComboBoxAddItem(financeCombo, "This week")
	guiComboBoxAddItem(financeCombo, "Last week") 
	--]]

	tabWeeklyStatement = guiCreateTab("Haftalık Açıklama", financeTabs)

		weeklyStatementGridlist = guiCreateGridList(13, 11, 395, 298, false, tabWeeklyStatement)
		statementColText = guiGridListAddColumn(weeklyStatementGridlist, "", 0.4)
		statementColLast = guiGridListAddColumn(weeklyStatementGridlist, "Geçen hafta", 0.25)
		statementColThis = guiGridListAddColumn(weeklyStatementGridlist, "Bu hafta", 0.25)

		assetsGridlist = guiCreateGridList(639, 11, 395, 298, false, tabWeeklyStatement)
		guiGridListAddColumn(assetsGridlist, "Varlıklar", 0.65)
		guiGridListAddColumn(assetsGridlist, "Değer", 0.25)

		local row = guiGridListAddRow(assetsGridlist)
		guiGridListSetItemText(assetsGridlist, row, 1, "Banka Hesabı", false, false)
		if not bankmoney then bankmoney = 0 end
		guiGridListSetItemText(assetsGridlist, row, 2, "$"..tostring(exports.vrp_global:formatMoney(bankmoney)), false, false)
		local row = guiGridListAddRow(assetsGridlist)
		guiGridListSetItemText(assetsGridlist, row, 1, "Araç", false, false)
		if not vehiclesvalue then vehiclesvalue = 0 end
		guiGridListSetItemText(assetsGridlist, row, 2, "$"..tostring(exports.vrp_global:formatMoney(vehiclesvalue)), false, false)
		local row = guiGridListAddRow(assetsGridlist)
		guiGridListSetItemText(assetsGridlist, row, 1, "Mülker", false, false)
		if not propertiesvalue then propertiesvalue = 0 end
		guiGridListSetItemText(assetsGridlist, row, 2, "$"..tostring(exports.vrp_global:formatMoney(propertiesvalue)), false, false)

		local row = guiGridListAddRow(assetsGridlist)
		guiGridListSetItemText(assetsGridlist, row, 1, "Toplam", false, false)
		guiGridListSetItemText(assetsGridlist, row, 2, "$"..tostring(exports.vrp_global:formatMoney(bankmoney+vehiclesvalue+propertiesvalue)), false, false)

        local label1 = guiCreateLabel(413, 10, 156, 30, "İhtilaf finansı bilgileri en fazla 2 hafta öncesine dayanır.", false, tabWeeklyStatement)
        	guiSetFont(label1, "default-small")
        	guiLabelSetHorizontalAlign(label1, "left", true)

        local label2 = guiCreateLabel(413, 292, 156, 15, "Ayrıntıları göstermek için bir satırı çift tıklayın.", false, tabWeeklyStatement)
        	guiSetFont(label2, "default-small")

	tabTransactions = guiCreateTab("Transactions", financeTabs)
		transactionsGridlist = guiCreateGridList(0, 0, 1, 1, true, tabTransactions)
		local transactionColumns = {
			{ "ID", 0.09 },
			{ "Type", 0.03 },
			{ "From", 0.2 },
			{ "To", 0.2 },
			{ "Amount", 0.07 },
			{ "Date", 0.1 },
			{ "Week", 0.03 },
			{ "Reason", 0.24 }
		}
		for key, value in ipairs(transactionColumns) do
			guiGridListAddColumn(transactionsGridlist, value[1], value[2] or 0.1)
		end

	thisWeek = {
		["income"] = 0,
		["expenses"] = 0,
		["profit"] = 0,
		
		["incomingTransfers"] = 0,
		["deposits"] = 0,
		["budget"] = 0,
		
		["outgoingTransfers"] = 0,
		["withdrawals"] = 0,
		["wages"] = 0,
		["fuel"] = 0,
		["repair"] = 0,
	}
	lastWeek = {
		["income"] = 0,
		["expenses"] = 0,
		["profit"] = 0,
		
		["incomingTransfers"] = 0,
		["deposits"] = 0,
		["budget"] = 0,
		
		["outgoingTransfers"] = 0,
		["withdrawals"] = 0,
		["wages"] = 0,
		["fuel"] = 0,
		["repair"] = 0,
	}

	for k,v in ipairs(bankThisWeek) do
		local amount
		--[[
		if v.to == -factionID then
			amount = v.amount
		elseif v.from == -factionID then
			amount = -v.amount
		else
			amount = v.amount
		end
		--]]
		amount = v.amount

		if v.type == 0 then --withdraw personal
			
		elseif v.type == 1 then --deposit personal

		elseif v.type == 2 then --transfer from personal to personal
			thisWeek.incomingTransfers = thisWeek.incomingTransfers + amount
			thisWeek.income = thisWeek.income + amount
		elseif v.type == 3 then --transfer from business to personal
			thisWeek.outgoingTransfers = thisWeek.outgoingTransfers + amount
			thisWeek.expenses = thisWeek.expenses + amount
		elseif v.type == 4 then --withdraw business
			thisWeek.withdrawals = thisWeek.withdrawals + amount
			thisWeek.expenses = thisWeek.expenses + amount
		elseif v.type == 5 then --deposit business
			thisWeek.deposits = thisWeek.deposits + amount
			thisWeek.income = thisWeek.income + amount
		elseif v.type == 6 then --wage/state benefits
			thisWeek.wages = thisWeek.wages + amount
			thisWeek.expenses = thisWeek.expenses + amount
		elseif v.type == 7 then --everything in payday except wage/state benefits

		elseif v.type == 8 then --faction budget
			thisWeek.budget = thisWeek.budget + amount
			thisWeek.income = thisWeek.income + amount
		elseif v.type == 9 then --fuel
			thisWeek.fuel = thisWeek.fuel + amount
			thisWeek.expenses = thisWeek.expenses + amount
		elseif v.type == 10 then --repair
			thisWeek.repair = thisWeek.repair + amount
			thisWeek.expenses = thisWeek.expenses + amount
		end

	end
	for k,v in ipairs(bankPrevWeek) do
		local amount = 0
		if v.to == -factionID then
			amount = v.amount
		elseif v.from == -factionID then
			amount = -v.amount
		end

		if v.type == 0 then --withdraw personal
			
		elseif v.type == 1 then --deposit personal

		elseif v.type == 2 then --transfer from personal to personal
			lastWeek.incomingTransfers = lastWeek.incomingTransfers + amount
			lastWeek.income = lastWeek.income + amount
		elseif v.type == 3 then --transfer from business to personal
			lastWeek.outgoingTransfers = lastWeek.outgoingTransfers + amount
			lastWeek.expenses = lastWeek.expenses + amount
		elseif v.type == 4 then --withdraw business
			lastWeek.withdrawals = lastWeek.withdrawals + amount
			lastWeek.expenses = lastWeek.expenses + amount
		elseif v.type == 5 then --deposit business
			lastWeek.deposits = lastWeek.deposits + amount
			lastWeek.income = lastWeek.income + amount
		elseif v.type == 6 then --wage/state benefits
			lastWeek.wages = lastWeek.wages + amount
			lastWeek.expenses = lastWeek.expenses + amount
		elseif v.type == 7 then --everything in payday except wage/state benefits

		elseif v.type == 8 then --faction budget
			lastWeek.budget = lastWeek.budget + amount
			lastWeek.income = lastWeek.income + amount
		elseif v.type == 9 then --fuel
			lastWeek.fuel = lastWeek.fuel + amount
			lastWeek.expenses = lastWeek.expenses + amount
		elseif v.type == 10 then --repair
			lastWeek.repair = lastWeek.repair + amount
			lastWeek.expenses = lastWeek.expenses + amount
		end
	end

	lastWeek.profit = lastWeek.income + lastWeek.expenses
	thisWeek.profit = thisWeek.income + thisWeek.expenses

	insertStatement = {
		--varName, text, subinfo, transaction types
		{"income", "Income", { {"incomingTransfers", "Incoming Transfers", false, {[2]=true}}, {"deposits", "Bank Deposits", false, {[5]=true}}, {"budget", "Budget", false, {[8]=true}}, }, false },
		{"expenses", "Expenses", { {"outgoingTransfers", "Outgoing Transfers", false, {[3]=true}}, {"withdrawals", "Bank Withdrawals", false, {[4]=true}}, {"wages", "Wages", false, {[6]=true}}, {"fuel", "Fuel", false, {[9]=true}}, {"repair", "Repairs", false, {[10]=true}}, }, false },
		{"profit", "Profit", false, false},
	}

	for k,v in ipairs(insertStatement) do
		local rowVar = v[1]
		local rowText = v[2]
		local rowSub = v[3]

		local row = guiGridListAddRow(weeklyStatementGridlist)
		guiGridListSetItemText(weeklyStatementGridlist, row, statementColText, rowText, false, false)
		guiGridListSetItemData(weeklyStatementGridlist, row, statementColText, rowVar)
		guiGridListSetItemText(weeklyStatementGridlist, row, statementColLast, "$"..tostring(exports.vrp_global:formatMoney(lastWeek[rowVar])), false, false)
		guiGridListSetItemText(weeklyStatementGridlist, row, statementColThis, "$"..tostring(exports.vrp_global:formatMoney(thisWeek[rowVar])), false, false)

		if lastWeek[rowVar] > 0 then
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 0, 148, 0)
		elseif lastWeek[rowVar] < 0 then
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 171, 0, 0)
		else
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 122, 122, 122)
		end
		if thisWeek[rowVar] > 0 then
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 0, 255, 0)
		elseif thisWeek[rowVar] < 0 then
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 255, 0, 0)
		else
			guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 255, 255, 255)
		end
	end

	addEventHandler("onClientGUIDoubleClick", weeklyStatementGridlist, function()
		local selectedRow, selectedCol = guiGridListGetSelectedItem(weeklyStatementGridlist)
		local rowvar = guiGridListGetItemData(weeklyStatementGridlist, selectedRow, 1)
		local parent = false
		local rows = false
		local transTypes = false
		if rowvar then
			for k,v in ipairs(insertStatement) do
				if v[1] == rowvar then
					parent = true
					rows = v[3]
					transTypes = v[4]
					thisText = v[2]
					break
				elseif v[3] then
					for k2,v2 in ipairs(v[3]) do
						if v2[1] == rowvar then
							parent = true
							rows = v2[3]
							transTypes = v2[4]
							thisText = v2[2]
							break
						end
					end
					if parent then break end
				end
			end
		else
			rows = insertStatement
		end
		if rows then
			if tabStatementDetails then
				guiDeleteTab(tabStatementDetails, financeTabs)
				tabStatementDetails = nil
			end
			guiGridListClear(weeklyStatementGridlist)
			local row = guiGridListAddRow(weeklyStatementGridlist)
			if parent then
				guiGridListSetItemText(weeklyStatementGridlist, row, statementColText, "...", false, false)
			end
			for k,v in ipairs(rows) do
				local rowVar = v[1]
				local rowText = v[2]
				local rowSub = v[3]

				local row = guiGridListAddRow(weeklyStatementGridlist)
				guiGridListSetItemText(weeklyStatementGridlist, row, statementColText, rowText, false, false)
				guiGridListSetItemData(weeklyStatementGridlist, row, statementColText, rowVar)
				guiGridListSetItemText(weeklyStatementGridlist, row, statementColLast, "$"..tostring(exports.vrp_global:formatMoney(lastWeek[rowVar])), false, false)
				guiGridListSetItemText(weeklyStatementGridlist, row, statementColThis, "$"..tostring(exports.vrp_global:formatMoney(thisWeek[rowVar])), false, false)

				if lastWeek[rowVar] > 0 then
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 0, 148, 0)
				elseif lastWeek[rowVar] < 0 then
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 171, 0, 0)
				else
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColLast, 122, 122, 122)
				end
				if thisWeek[rowVar] > 0 then
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 0, 255, 0)
				elseif thisWeek[rowVar] < 0 then
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 255, 0, 0)
				else
					guiGridListSetItemColor(weeklyStatementGridlist, row, statementColThis, 255, 255, 255)
				end				
			end
		elseif transTypes then
			--outputDebugString("transTypes")
			if tabStatementDetails then
				guiDeleteTab(tabStatementDetails, financeTabs)
				tabStatementDetails = nil
			end
			--if not tabStatementDetails then
				tabStatementDetails = guiCreateTab("Details: "..tostring(thisText), financeTabs)
				transactionDetailsGridlist = guiCreateGridList(0, 0, 1, 1, true, tabStatementDetails)
				local transactionColumns = {
					{ "ID", 0.09 },
					{ "Type", 0.03 },
					{ "From", 0.2 },
					{ "To", 0.2 },
					{ "Amount", 0.07 },
					{ "Date", 0.1 },
					{ "Week", 0.03 },
					{ "Reason", 0.24 }
				}
				for key, value in ipairs(transactionColumns) do
					guiGridListAddColumn(transactionDetailsGridlist, value[1], value[2] or 0.1)
				end				
			--end
			for k,v in ipairs(bankThisWeek) do
				if transTypes[v.type] then
					local row = guiGridListAddRow(transactionDetailsGridlist)
					guiGridListSetItemText(transactionDetailsGridlist, row, 1, tostring(v.id), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 2, tostring(v.type), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 3, tostring(v.from), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 4, tostring(v.to), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 5, tostring(exports.vrp_global:formatMoney(v.amount)), false, false)
					if v.amount > 0 then
						guiGridListSetItemColor(transactionDetailsGridlist, row, 5, 0, 255, 0)
					elseif v.amount < 0 then
						guiGridListSetItemColor(transactionDetailsGridlist, row, 5, 255, 0, 0)
					end
					guiGridListSetItemText(transactionDetailsGridlist, row, 6, tostring(v.time), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 7, tostring(v.week), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 8, tostring(v.reason), false, false)
				end
			end
			for k,v in ipairs(bankPrevWeek) do
				if transTypes[v.type] then
					local row = guiGridListAddRow(transactionDetailsGridlist)
					guiGridListSetItemText(transactionDetailsGridlist, row, 1, tostring(v.id), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 2, tostring(v.type), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 3, tostring(v.from), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 4, tostring(v.to), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 5, tostring(exports.vrp_global:formatMoney(v.amount)), false, false)
					if v.amount > 0 then
						guiGridListSetItemColor(transactionDetailsGridlist, row, 5, 0, 255, 0)
					elseif v.amount < 0 then
						guiGridListSetItemColor(transactionDetailsGridlist, row, 5, 255, 0, 0)
					end
					guiGridListSetItemText(transactionDetailsGridlist, row, 6, tostring(v.time), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 7, tostring(v.week), false, false)
					guiGridListSetItemText(transactionDetailsGridlist, row, 8, tostring(v.reason), false, false)
				end
			end
			guiSetSelectedTab(financeTabs, tabStatementDetails)
		end
	end, false)

	for k,v in ipairs(bankThisWeek) do
		local row = guiGridListAddRow(transactionsGridlist)
		guiGridListSetItemText(transactionsGridlist, row, 1, tostring(v.id), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 2, tostring(v.type), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 3, tostring(v.from), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 4, tostring(v.to), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 5, tostring(exports.vrp_global:formatMoney(v.amount)), false, false)
		if v.amount > 0 then
			guiGridListSetItemColor(transactionsGridlist, row, 5, 0, 255, 0)
		elseif v.amount < 0 then
			guiGridListSetItemColor(transactionsGridlist, row, 5, 255, 0, 0)
		end
		guiGridListSetItemText(transactionsGridlist, row, 6, tostring(v.time), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 7, tostring(v.week), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 8, tostring(v.reason), false, false)
	end
	for k,v in ipairs(bankPrevWeek) do
		local row = guiGridListAddRow(transactionsGridlist)
		guiGridListSetItemText(transactionsGridlist, row, 1, tostring(v.id), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 2, tostring(v.type), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 3, tostring(v.from), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 4, tostring(v.to), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 5, tostring(exports.vrp_global:formatMoney(v.amount)), false, false)
		if v.amount > 0 then
			guiGridListSetItemColor(transactionsGridlist, row, 5, 0, 255, 0)
		elseif v.amount < 0 then
			guiGridListSetItemColor(transactionsGridlist, row, 5, 255, 0, 0)
		end
		guiGridListSetItemText(transactionsGridlist, row, 6, tostring(v.time), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 7, tostring(v.week), false, false)
		guiGridListSetItemText(transactionsGridlist, row, 8, tostring(v.reason), false, false)
	end

end
addEvent("factionmenu:fillFinance", true)
addEventHandler("factionmenu:fillFinance", getResourceRootElement(), fillFinance)

--[[
	Transaction Types:
	0: Withdraw Personal
	1: Deposit Personal
	2: Transfer from Personal to Personal
	3: Transfer from Business to Personal
	4: Withdraw Business
	5: Deposit Business
	6: Wage/State Benefits
	7: everything in payday except Wage/State Benefits
	8: faction budget
	9: fuel
	10: repair
]]

-- Made by Hypnos for anadolu roleplay, 18 mayıs.
Duty = {
    gridlist = {},
    button = {},
    label = {}
}

customEditID = 0
locationEditID = 0

-- 35 for logs
function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end

function beginLoad()
	guiGridListAddRow(Duty.gridlist[1])
	guiGridListSetItemText(Duty.gridlist[1], 0, 2, "Loading", false, false)

	guiGridListAddRow(Duty.gridlist[2])
	guiGridListSetItemText(Duty.gridlist[2], 0, 1, "Loading", false, false)

	guiGridListAddRow(Duty.gridlist[3])
	guiGridListSetItemText(Duty.gridlist[3], 0, 1, "Loading", false, false)

	--[[guiGridListAddRow(Duty.gridlist[4])
	guiGridListSetItemText(Duty.gridlist[4], 0, 1, "Loading", false, false)]]

	triggerServerEvent("fetchDutyInfo", resourceRoot, factionID1)
end

function importData(custom, locations, factionID, message)
	if not isElement(gFactionWindow) then
		return
	end
	customg = custom
	locationsg = locations
	factionIDg = factionID 
	forceDutyClose = true
	forceLocationClose = true
	if locationEditID == 0 then
		forceLocationClose = false
	end
	if customEditID == 0 then
		forceDutyClose = false
	end
	guiGridListClear( Duty.gridlist[1] )
	guiGridListClear( Duty.gridlist[2] )
	guiGridListClear( Duty.gridlist[3] )
	for k,v in pairs(custom) do
		local row = guiGridListAddRow(Duty.gridlist[2])

		guiGridListSetItemText(Duty.gridlist[2], row, 1, tostring(v[1]), false, true)
		guiGridListSetItemText(Duty.gridlist[2], row, 2, v[2], false, false)
		t = {}
		for key, val in pairs(v[4]) do
			table.insert(t, key)
		end
		guiGridListSetItemText(Duty.gridlist[2], row, 3, table.concat(t, ", "), false, false)
		if customEditID == tonumber(v[1]) then
			forceDutyClose = false
		end
	end
	for k,v in pairs(locations) do
		if not v[10] then
			local row = guiGridListAddRow(Duty.gridlist[1])

			guiGridListSetItemText(Duty.gridlist[1], row, 1, tostring(v[1]), false, true)
			guiGridListSetItemText(Duty.gridlist[1], row, 2, tostring(v[2]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 3, tostring(v[6]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 4, tostring(v[8]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 5, tostring(v[7]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 6, tostring(v[3]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 7, tostring(v[4]), false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 8, tostring(v[5]), false, false)
		else
			local row = guiGridListAddRow(Duty.gridlist[3])

			guiGridListSetItemText(Duty.gridlist[3], row, 1, tostring(v[1]), false, true)
			guiGridListSetItemText(Duty.gridlist[3], row, 2, tostring(v[9]), false, true)
			guiGridListSetItemText(Duty.gridlist[3], row, 3, getVehicleNameFromModel(v[10]), false, false)
			--[[table.insert(vehlocal, tostring(v[10]), v[11])
			table.remove(locations, k)]]
		end
		if locationEditID == tonumber(v[1]) then
			forceLocationClose = false
		end
	end
	if forceLocationClose or forceDutyClose then
		outputChatBox(message, 255, 0, 0)
		if forceDutyClose then
			if DutyCreate.window[1] then
				destroyElement(DutyCreate.window[1])
			end
			if DutyLocations.window[1] then
				destroyElement(DutyLocations.window[1])
			end
			if DutySkins.window[1] then
				destroyElement(DutySkins.window[1])
			end
		end
		if forceLocationClose then
			if DutyLocationMaker.window[1] then
				destroyElement(DutyLocationMaker.window[1])
			end
		end
	end
end
addEvent("importDutyData", true)
addEventHandler("importDutyData", resourceRoot, importData)

function refreshUI()
	guiGridListClear( Duty.gridlist[1] )
	guiGridListClear( Duty.gridlist[2] )
	guiGridListClear( Duty.gridlist[3] )
	for k,v in pairs(customg) do
		local row = guiGridListAddRow(Duty.gridlist[2])

		guiGridListSetItemText(Duty.gridlist[2], row, 1, tostring(v[1]), false, true)
		guiGridListSetItemText(Duty.gridlist[2], row, 2, v[2], false, false)
		t = {}
		for key, val in pairs(v[4]) do
			table.insert(t, key)
		end
		guiGridListSetItemText(Duty.gridlist[2], row, 3, table.concat(t, ", "), false, false)
	end
	for k,v in pairs(locationsg) do
		if not v[10] then
			local row = guiGridListAddRow(Duty.gridlist[1])

			guiGridListSetItemText(Duty.gridlist[1], row, 1, tostring(v[1]), false, true)
			guiGridListSetItemText(Duty.gridlist[1], row, 2, v[2], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 3, v[6], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 4, v[8], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 5, v[7], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 6, v[3], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 7, v[4], false, false)
			guiGridListSetItemText(Duty.gridlist[1], row, 8, v[5], false, false)
		else
			local row = guiGridListAddRow(Duty.gridlist[3])

			guiGridListSetItemText(Duty.gridlist[3], row, 1, tostring(v[1]), false, true)
			guiGridListSetItemText(Duty.gridlist[3], row, 2, tostring(v[9]), false, true)
			guiGridListSetItemText(Duty.gridlist[3], row, 3, getVehicleNameFromModel(v[10]), false, false)
			--[[table.insert(vehlocal, tostring(v[10]), v[11])
			table.remove(locations, k)]]
		end
	end
end

function processLocationEdit()
	local r, c = guiGridListGetSelectedItem ( Duty.gridlist[1] )
	if r >= 0 then
		local x = guiGridListGetItemText ( Duty.gridlist[1], r, 6 )
		local y = guiGridListGetItemText ( Duty.gridlist[1], r, 7 )
		local z = guiGridListGetItemText ( Duty.gridlist[1], r, 8 )
		local rot = guiGridListGetItemText ( Duty.gridlist[1], r, 3 )
		local i = guiGridListGetItemText ( Duty.gridlist[1], r, 4 )
		local d = guiGridListGetItemText ( Duty.gridlist[1], r, 5 )
		local name = guiGridListGetItemText ( Duty.gridlist[1], r, 2 )
		locationEditID = tonumber(guiGridListGetItemText ( Duty.gridlist[1], r, 1 ))
		createDutyLocationMaker(x, y, z, rot, i, d, name)
	end
end

function processDutyEdit()
	local r, c = guiGridListGetSelectedItem ( Duty.gridlist[2] )
	if r >= 0 then
		local id = guiGridListGetItemText(Duty.gridlist[2], r, 1)
		customEditID = tonumber(id)
		createDuty()
	end
end

function createDutyMain()
	if isElement(Duty.gridlist[1]) then
		beginLoad()
		return
	end
    Duty.gridlist[1] = guiCreateGridList(0.0047, 0.046, 0.3, 0.89, true, tabDuty)
    guiGridListAddColumn(Duty.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(Duty.gridlist[1], "Name", 0.2)
    guiGridListAddColumn(Duty.gridlist[1], "Radius", 0.1)
    guiGridListAddColumn(Duty.gridlist[1], "Interior", 0.1)
    guiGridListAddColumn(Duty.gridlist[1], "Dimension", 0.12)
    guiGridListAddColumn(Duty.gridlist[1], "X", 0.1)
    guiGridListAddColumn(Duty.gridlist[1], "Y", 0.1)
    guiGridListAddColumn(Duty.gridlist[1], "Z", 0.1)

    Duty.button[1] = guiCreateButton(0.005, 0.939, 0.09, 0.0504, "Konum Ekle", true, tabDuty)
    guiSetProperty(Duty.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[1], createDutyLocationMaker, false)

    Duty.label[1] = guiCreateLabel(0.0059, 0.0076, 0.2625, 0.03, "Görev Yerleri", true, tabDuty)
    guiLabelSetHorizontalAlign(Duty.label[1], "center", false)
    Duty.button[2] = guiCreateButton(0.1, 0.939, 0.099, 0.0504, "Konumu Kaldır", true, tabDuty)
    guiSetProperty(Duty.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[2], removeLocation, false)

    Duty.button[3] = guiCreateButton(0.205, 0.939, 0.099, 0.0504, "Görev Konumunu Düzenle", true, tabDuty)
    guiSetProperty(Duty.button[3], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[3], processLocationEdit, false)
    addEventHandler("onClientGUIDoubleClick", Duty.gridlist[1], processLocationEdit, false)

    Duty.gridlist[2] = guiCreateGridList(0.66, 0.046, 0.3, 0.89, true, tabDuty)
    guiGridListAddColumn(Duty.gridlist[2], "ID", 0.3)
    guiGridListAddColumn(Duty.gridlist[2], "Name", 0.3)
    guiGridListAddColumn(Duty.gridlist[2], "Locations", 0.3)

    Duty.label[2] = guiCreateLabel(0.68, 0.0076, 0.2636, 0.03, "Görev Avantajları", true, tabDuty)
    guiLabelSetHorizontalAlign(Duty.label[2], "center", false)
    Duty.button[4] = guiCreateButton(0.66, 0.939, 0.09, 0.0504, "Yeni görev ekle", true, tabDuty)
    guiSetProperty(Duty.button[4], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[4], createDuty, false)

    Duty.button[5] = guiCreateButton(0.765, 0.939, 0.09, 0.0504, "Görevi Kaldır", true, tabDuty)
    guiSetProperty(Duty.button[5], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[5], removeDuty, false)

    Duty.button[6] = guiCreateButton(0.869, 0.939, 0.09, 0.0504, "Görev Perklerini Düzenle", true, tabDuty)
    guiSetProperty(Duty.button[6], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[6], processDutyEdit, false)
    addEventHandler("onClientGUIDoubleClick", Duty.gridlist[2], processDutyEdit, false)

    Duty.gridlist[3] = guiCreateGridList(0.3355, 0.046, 0.282, 0.472, true, tabDuty)
    guiGridListAddColumn(Duty.gridlist[3], "ID", 0.1)
    guiGridListAddColumn(Duty.gridlist[3], "Vehicle ID", 0.4)
    guiGridListAddColumn(Duty.gridlist[3], "Vehicle", 0.5)

    Duty.label[3] = guiCreateLabel(0.325, 0.0076, 0.2886, 0.03, "Görevli Araç Konumları", true, tabDuty)
    guiLabelSetHorizontalAlign(Duty.label[3], "center", false)
    Duty.button[8] = guiCreateButton(0.3355, 0.5304, 0.1, 0.0504, "Görev Aracı Ekle", true, tabDuty)
    guiSetProperty(Duty.button[8], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", Duty.button[8], createVehicleAdd, false)

    Duty.button[9] = guiCreateButton(0.5177, 0.5304, 0.1, 0.0504, "Görev Aracını Kaldır", true, tabDuty)
    guiSetProperty(Duty.button[9], "NormalTextColour", "FFAAAAAA")    
    addEventHandler("onClientGUIClick", Duty.button[9], removeVehicle, false)

   --[[Duty.gridlist[4] = guiCreateGridList(0.3355, 0.6, 0.282, 0.35, true, tabDuty) Was going to be for logs but meh UCP.
    guiGridListAddColumn(Duty.gridlist[4], "ID", 0.1)
    guiGridListAddColumn(Duty.gridlist[4], "Name", 0.3)
    guiGridListAddColumn(Duty.gridlist[4], "Action", 0.5)]]

    beginLoad()
end

DutyCreate = {
    label = {},
    button = {},
    window = {},
    gridlist = {},
    edit = {}
}
function grabDetails(dutyID)
	triggerServerEvent("Duty:Grab", resourceRoot, factionID1)

	guiGridListAddRow(DutyCreate.gridlist[1])
	guiGridListSetItemText(DutyCreate.gridlist[1], 0, 2, "Yükleniyor", false, false)

	guiGridListAddRow(DutyCreate.gridlist[2])
	guiGridListSetItemText(DutyCreate.gridlist[2], 0, 2, "Yükleniyor", false, false)

	guiGridListAddRow(DutyCreate.gridlist[3])
	guiGridListSetItemText(DutyCreate.gridlist[3], 0, 1, "Yükleniyor", false, false)

	guiGridListAddRow(DutyCreate.gridlist[4])
	guiGridListSetItemText(DutyCreate.gridlist[4], 0, 1, "Yükleniyor", false, false)		
end

function isItemAllowed(id)
	for k,v in pairs(allowListg) do
		if tonumber(id) == tonumber(v[1]) then
			return true
		end
	end
	return false
end

function populateDuty(allowList)
	dutyItems = { }
	allowListg = allowList
	guiGridListClear( DutyCreate.gridlist[1] )
	guiGridListClear( DutyCreate.gridlist[2] )
	guiGridListClear( DutyCreate.gridlist[3] )
	guiGridListClear( DutyCreate.gridlist[4] )

	if customEditID ~= 0 then
		dutyItems = customg[customEditID][5]
		for k,v in pairs(customg[customEditID][5]) do
			if tonumber(v[2]) >= 0 then -- Items
				local row = guiGridListAddRow(DutyCreate.gridlist[4])
	
				guiGridListSetItemText(DutyCreate.gridlist[4], row, 1, exports["vrp_items"]:getItemName(v[2]), false, false) -- Item Name
				guiGridListSetItemText(DutyCreate.gridlist[4], row, 2, tostring(v[2]), false, true) -- Item ID
				guiGridListSetItemData(DutyCreate.gridlist[4], row, 1, { v[1], tonumber(v[2]), v[3] })

				if not isItemAllowed(v[1]) then
					guiGridListSetItemColor(DutyCreate.gridlist[4], row, 1, 255, 0, 0)
					guiGridListSetItemColor(DutyCreate.gridlist[4], row, 2, 255, 0, 0)
				end
			else -- Weapons
				local row = guiGridListAddRow(DutyCreate.gridlist[3])
				if tonumber(v[2]) == -100 then
					guiGridListSetItemText(DutyCreate.gridlist[3], row, 1, "Armor", false, false) -- Weapon Name
					guiGridListSetItemText(DutyCreate.gridlist[3], row, 2, tostring(v[3]), false, false) -- Ammo
					guiGridListSetItemData(DutyCreate.gridlist[3], row, 2, { v[1], tonumber(v[2]), v[3], v[4] })
				else
					guiGridListSetItemText(DutyCreate.gridlist[3], row, 1, exports["vrp_items"]:getItemName(v[2]), false, false) -- Weapon Name
					guiGridListSetItemText(DutyCreate.gridlist[3], row, 2, tostring(v[3]), false, false) -- Ammo
					guiGridListSetItemData(DutyCreate.gridlist[3], row, 2, { v[1], tonumber(v[2]), v[3], v[4] })
				end

				if not isItemAllowed(v[1]) then
					guiGridListSetItemColor(DutyCreate.gridlist[3], row, 1, 255, 0, 0)
					guiGridListSetItemColor(DutyCreate.gridlist[3], row, 2, 255, 0, 0)
				end
			end
		end
		guiSetText(DutyCreate.edit[3], customg[customEditID][2])
	end

	for k,v in pairs(allowList) do
		if tonumber(v[2]) >= 0 then -- Items
			if customEditID == 0 or (customEditID ~= 0 and not customg[customEditID][5][tostring(v[1])]) then
				local row = guiGridListAddRow(DutyCreate.gridlist[2])

				guiGridListSetItemText(DutyCreate.gridlist[2], row, 1, exports["vrp_items"]:getItemName(v[2]), false, false)
				guiGridListSetItemText(DutyCreate.gridlist[2], row, 2, exports["vrp_items"]:getItemDescription(v[2], v[3]), false, false)
				guiGridListSetItemData(DutyCreate.gridlist[2], row, 1, { v[1], tonumber(v[2]), v[3] })
			end
		else -- Weapons
			if customEditID == 0 or (customEditID ~= 0 and not customg[customEditID][5][tostring(v[1])]) then
				local row = guiGridListAddRow(DutyCreate.gridlist[1])
				if tonumber(v[2]) == -100 then
					guiGridListSetItemText(DutyCreate.gridlist[1], row, 1, "Armor", false, false)
					guiGridListSetItemText(DutyCreate.gridlist[1], row, 2, v[3], false, false)
					guiGridListSetItemData(DutyCreate.gridlist[1], row, 1, { v[1], tonumber(v[2]), v[3] })
				else
					guiGridListSetItemText(DutyCreate.gridlist[1], row, 1, exports["vrp_items"]:getItemName(v[2]), false, false)
					guiGridListSetItemText(DutyCreate.gridlist[1], row, 2, v[3], false, false)
					guiGridListSetItemData(DutyCreate.gridlist[1], row, 1, { v[1], tonumber(v[2]), v[3] })
				end
			end
		end
	end

end
addEvent("gotAllow", true)
addEventHandler("gotAllow", resourceRoot, populateDuty)

function populateLocations()
	if customEditID == 0 then
		tempLocations = getElementData(getLocalPlayer(), "savedLocations") or {}
	else
		tempLocations = getElementData(getLocalPlayer(), "savedLocations") or customg[customEditID][4]
	end

	for k,v in pairs(locationsg) do
		if not tempLocations[v[1]] then 
			local row = guiGridListAddRow(DutyLocations.gridlist[1])

			guiGridListSetItemText(DutyLocations.gridlist[1], row, 1, tostring(v[1]), false, true)
			guiGridListSetItemText(DutyLocations.gridlist[1], row, 2, tostring(v[2]), false, false)
		end
	end

	for k,v in pairs(tempLocations) do
		local row = guiGridListAddRow(DutyLocations.gridlist[2])

		guiGridListSetItemText(DutyLocations.gridlist[2], row, 1, tostring(k), false, true)
		guiGridListSetItemText(DutyLocations.gridlist[2], row, 2, tostring(v), false, false)
	end
end

function populateSkins()
	if customEditID == 0 then
		dutyNewSkins = getElementData(getLocalPlayer(), "savedSkins") or {}
	else
		dutyNewSkins = getElementData(getLocalPlayer(), "savedSkins") or customg[customEditID][3]
	end

	for k,v in pairs(dutyNewSkins) do
		local row = guiGridListAddRow(DutySkins.gridlist[1])

		guiGridListSetItemText(DutySkins.gridlist[1], row, 1, tostring(v[1]), false, false)
		guiGridListSetItemText(DutySkins.gridlist[1], row, 2, tostring(v[2]), false, false)
	end
end

function checkAmmo()
	local r, c = guiGridListGetSelectedItem( DutyCreate.gridlist[1] )
	if r >= 0 then
		if tonumber(guiGetText(DutyCreate.edit[2])) then
			if tonumber(guiGridListGetItemText(DutyCreate.gridlist[1], r, 2)) >= tonumber(guiGetText( DutyCreate.edit[2] )) then
				guiLabelSetColor(DutyCreate.label[2], 0, 255, 0)
				guiSetText(DutyCreate.label[2], "Valid")
				guiSetEnabled(DutyCreate.button[3], true)
				return
			end
		end
	end
	guiLabelSetColor(DutyCreate.label[2], 255, 0, 0)
	guiSetText(DutyCreate.label[2], "Invalid")
	guiSetEnabled(DutyCreate.button[3], false)
end

function addDutyItem()
   	local r, c = guiGridListGetSelectedItem ( DutyCreate.gridlist[2] )
	if r >= 0 then
		local info = guiGridListGetItemData( DutyCreate.gridlist[2], r, 1 )
		local row = guiGridListAddRow(DutyCreate.gridlist[4])

		guiGridListSetItemText(DutyCreate.gridlist[4], row, 1, exports["vrp_items"]:getItemName(info[2]), false, false) -- Item Name
		guiGridListSetItemText(DutyCreate.gridlist[4], row, 2, tostring(info[2]), false, false) -- Item ID
		guiGridListSetItemData( DutyCreate.gridlist[4], row, 1, info )

		dutyItems[tostring(info[1])] = { info[1], tonumber(info[2]), info[3] }
		guiGridListRemoveRow( DutyCreate.gridlist[2], r )
	end
end

function removeDutyWeapon()
   	local r, c = guiGridListGetSelectedItem ( DutyCreate.gridlist[3] )
	if r >= 0 then
		local info = guiGridListGetItemData(DutyCreate.gridlist[3], r, 2)
		local red, g, b = guiGridListGetItemColor(DutyCreate.gridlist[3], r, 1)
		dutyItems[tostring(info[1])] = nil
		guiGridListRemoveRow( DutyCreate.gridlist[3], r)
		if red == 255 and g ~= 0 and b ~= 0 then
			local row = guiGridListAddRow(DutyCreate.gridlist[1])
			if tonumber(info[1]) == -100 then
				guiGridListSetItemText(DutyCreate.gridlist[1], row, 1, "Armor", false, false)
				guiGridListSetItemText(DutyCreate.gridlist[1], row, 2, tostring(info[4]), false, false)
				guiGridListSetItemData(DutyCreate.gridlist[1], row, 1, info)
			else
				guiGridListSetItemText(DutyCreate.gridlist[1], row, 1, exports["vrp_items"]:getItemName(info[2]), false, false)
				guiGridListSetItemText(DutyCreate.gridlist[1], row, 2, tostring(info[4]), false, false)
				guiGridListSetItemData(DutyCreate.gridlist[1], row, 1, info)
			end
		end
	end
end

function removeDutyItem()
   	local r, c = guiGridListGetSelectedItem ( DutyCreate.gridlist[4] )
	if r >= 0 then
		local info = guiGridListGetItemData(DutyCreate.gridlist[4], r, 1)
		local red, g, b = guiGridListGetItemColor(DutyCreate.gridlist[4], r, 1)
		dutyItems[tostring(info[1])] = nil
		guiGridListRemoveRow(DutyCreate.gridlist[4], r)
		if red == 255 and g ~= 0 and b ~= 0 then
			local row = guiGridListAddRow(DutyCreate.gridlist[2])

			guiGridListSetItemText(DutyCreate.gridlist[2], row, 1, exports["vrp_items"]:getItemName(tonumber(info[2])), false, false)
			guiGridListSetItemText(DutyCreate.gridlist[2], row, 2, exports["vrp_items"]:getItemDescription(tonumber(info[2]), info[3]), false, false)
			guiGridListSetItemData(DutyCreate.gridlist[2], row, 1, info)
		end
	end
end

function createDuty()
	if isElement(DutyCreate.window[1]) then
		destroyElement(DutyCreate.window[1])
		dutyItems = nil
	end

    DutyCreate.window[1] = guiCreateWindow(450, 310, 768, 566, "Görev Düzenleme Penceresi - Ana", false)
    guiWindowSetSizable(DutyCreate.window[1], false)
    centerWindow(DutyCreate.window[1])

    DutyCreate.button[1] = guiCreateButton(600, 512, 158, 44, "Kapat", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[1], closeTheGUI, false)

    DutyCreate.button[2] = guiCreateButton(454, 512, 138, 44, "Kaydet", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[2], saveGUI, false)

    DutyCreate.gridlist[1] = guiCreateGridList(11, 34, 427, 192, false, DutyCreate.window[1])
    --guiGridListAddColumn(DutyCreate.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(DutyCreate.gridlist[1], "Silahı İsmi", 0.5)
    guiGridListAddColumn(DutyCreate.gridlist[1], "Maksimum Cephane Miktarı", 0.5)

    DutyCreate.gridlist[2] = guiCreateGridList(12, 247, 426, 208, false, DutyCreate.window[1])
   --guiGridListAddColumn(DutyCreate.gridlist[2], "ID", 0.1)
    guiGridListAddColumn(DutyCreate.gridlist[2], "İtem İsmi", 0.3)
    guiGridListAddColumn(DutyCreate.gridlist[2], "Açıklama", 0.7)

    DutyCreate.button[3] = guiCreateButton(444, 34, 128, 41, "-->", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[3], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.gridlist[1], checkAmmo)
    addEventHandler("onClientGUIClick", DutyCreate.button[3], function()
    	 -- Add Duty Weapon
    	local r, c = guiGridListGetSelectedItem ( DutyCreate.gridlist[1] )
		if r >= 0 then
			local maxammo = guiGridListGetItemText( DutyCreate.gridlist[1], r, 2 )
			local info = guiGridListGetItemData( DutyCreate.gridlist[1], r, 1 )
			local ammo = guiGetText( DutyCreate.edit[2] )

			local row = guiGridListAddRow(DutyCreate.gridlist[3])
			if tonumber(info[2]) == -100 then
				guiGridListSetItemText(DutyCreate.gridlist[3], row, 1, "Zırh", false, false) -- Weapon Name
				guiGridListSetItemData(DutyCreate.gridlist[3], row, 2, info)
				guiGridListSetItemText(DutyCreate.gridlist[3], row, 2, ammo, false, false) -- Ammo
			else
				guiGridListSetItemText(DutyCreate.gridlist[3], row, 1, exports["vrp_items"]:getItemName(tonumber(info[2])), false, false) -- Weapon Name
				guiGridListSetItemData(DutyCreate.gridlist[3], row, 2, info)
				guiGridListSetItemText(DutyCreate.gridlist[3], row, 2, ammo, false, false) -- Ammo
			end

			dutyItems[tostring(info[1])] = { info[1], tonumber(info[2]), tonumber(ammo), info[3] }

			guiGridListRemoveRow( DutyCreate.gridlist[1], r )
		end
    end, false)
    DutyCreate.button[4] = guiCreateButton(444, 249, 128, 41, "-->", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[4], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[4], addDutyItem, false) -- Add Duty Item
    addEventHandler("onClientGUIDoubleClick", DutyCreate.gridlist[2], addDutyItem, false)
    
    DutyCreate.gridlist[3] = guiCreateGridList(582, 34, 176, 192, false, DutyCreate.window[1])
    guiGridListAddColumn(DutyCreate.gridlist[3], "Weapon", 0.5)
    guiGridListAddColumn(DutyCreate.gridlist[3], "Ammo", 0.3)

    --[[DutyCreate.edit[1] = guiCreateEdit(445, 298, 127, 27, "Item Value", false, DutyCreate.window[1])
    DutyCreate.label[1] = guiCreateLabel(444, 325, 128, 89, "Invalid", false, DutyCreate.window[1])
    guiLabelSetColor(DutyCreate.label[1], 255, 0, 0)
    guiLabelSetHorizontalAlign(DutyCreate.label[1], "center", false)]]
    DutyCreate.edit[2] = guiCreateEdit(445, 81, 127, 27, "Cephane Miktarı", false, DutyCreate.window[1])
    DutyCreate.label[2] = guiCreateLabel(444, 108, 128, 77, "Invalid", false, DutyCreate.window[1])
    guiLabelSetColor(DutyCreate.label[2], 255, 0, 0)
    addEventHandler("onClientGUIChanged", DutyCreate.edit[2], checkAmmo)

    DutyCreate.gridlist[4] = guiCreateGridList(582, 248, 176, 207, false, DutyCreate.window[1])
    guiGridListAddColumn(DutyCreate.gridlist[4], "Item", 0.5)
    guiGridListAddColumn(DutyCreate.gridlist[4], "ID", 0.3)
    guiLabelSetHorizontalAlign(DutyCreate.label[2], "center", false)

    DutyCreate.button[5] = guiCreateButton(444, 185, 128, 41, "<---", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[5], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[5], removeDutyWeapon, false)
    addEventHandler("onClientGUIDoubleClick", DutyCreate.gridlist[3], removeDutyWeapon, false)
    DutyCreate.button[6] = guiCreateButton(444, 414, 128, 41, "<--", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[6], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[6], removeDutyItem, false)
    addEventHandler("onClientGUIDoubleClick", DutyCreate.gridlist[4], removeDutyItem, false)
    DutyCreate.button[7] = guiCreateButton(12, 511, 138, 45, "Skin", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[7], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[7], createSkins, false)

    DutyCreate.button[8] = guiCreateButton(160, 512, 138, 44, "Lokasyon", false, DutyCreate.window[1])
    guiSetProperty(DutyCreate.button[8], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyCreate.button[8], createLocations, false)

    DutyCreate.label[3] = guiCreateLabel(57, 19, 319, 15, "Mevcut Silahlar", false, DutyCreate.window[1])
    guiLabelSetHorizontalAlign(DutyCreate.label[3], "center", false)
    DutyCreate.label[4] = guiCreateLabel(582, 17, 176, 17, "Görev Silahları", false, DutyCreate.window[1])
    guiLabelSetHorizontalAlign(DutyCreate.label[4], "center", false)
    DutyCreate.label[5] = guiCreateLabel(57, 228, 319, 15, "Uygun Ürünler", false, DutyCreate.window[1])
    guiLabelSetHorizontalAlign(DutyCreate.label[5], "center", false)
    DutyCreate.label[6] = guiCreateLabel(583, 227, 175, 21, "Görev Eşyaları", false, DutyCreate.window[1])
    guiLabelSetHorizontalAlign(DutyCreate.label[6], "center", false)
    DutyCreate.label[7] = guiCreateLabel(14, 463, 88, 32, "Görev İsmi:", false, DutyCreate.window[1])
    guiLabelSetVerticalAlign(DutyCreate.label[7], "center")
    DutyCreate.edit[3] = guiCreateEdit(83, 462, 240, 33, "", false, DutyCreate.window[1])    

	guiSetEnabled(DutyCreate.button[3], false)
    grabDetails()
end


DutyLocations = {
    gridlist = {},
    window = {},
    button = {},
    label = {}
}

function addLocationToDuty()
   	local r, c = guiGridListGetSelectedItem ( DutyLocations.gridlist[1] )
	if r >= 0 then
		local id = guiGridListGetItemText(DutyLocations.gridlist[1], r, 1)
		local name = guiGridListGetItemText(DutyLocations.gridlist[1], r, 2)

		guiGridListRemoveRow(DutyLocations.gridlist[1], r)
		local row = guiGridListAddRow(DutyLocations.gridlist[2])

		guiGridListSetItemText(DutyLocations.gridlist[2], row, 1, tostring(id), false, true)
		guiGridListSetItemText(DutyLocations.gridlist[2], row, 2, tostring(name), false, false)
		tempLocations[id] = name
	end
end

function removeLocationFromDuty()
   	local r, c = guiGridListGetSelectedItem ( DutyLocations.gridlist[2] )
	if r >= 0 then
		local id = guiGridListGetItemText(DutyLocations.gridlist[2], r, 1)
		local name = guiGridListGetItemText(DutyLocations.gridlist[2], r, 2)

		guiGridListRemoveRow(DutyLocations.gridlist[2], r)
		local row = guiGridListAddRow(DutyLocations.gridlist[1])

		guiGridListSetItemText(DutyLocations.gridlist[1], row, 1, tostring(id), false, true)
		guiGridListSetItemText(DutyLocations.gridlist[1], row, 2, tostring(name), false, false)
		tempLocations[id] = nil
	end
end

function createLocations()
	if isElement(DutyLocations.window[1]) then
		destroyElement(DutyLocations.window[1])
		tempLocations = nil
	end
    DutyLocations.window[1] = guiCreateWindow(573, 285, 520, 423, "Görev Düzenleme Penceresi - Konumlar", false)
    guiWindowSetSizable(DutyLocations.window[1], false)
    centerWindow(DutyLocations.window[1])

    DutyLocations.gridlist[1] = guiCreateGridList(9, 36, 240, 297, false, DutyLocations.window[1])
    guiGridListAddColumn(DutyLocations.gridlist[1], "ID", 0.2)
    guiGridListAddColumn(DutyLocations.gridlist[1], "İsim", 0.9)

    DutyLocations.gridlist[2] = guiCreateGridList(270, 36, 240, 297, false, DutyLocations.window[1])
    guiGridListAddColumn(DutyLocations.gridlist[2], "ID", 0.2)
    guiGridListAddColumn(DutyLocations.gridlist[2], "İsim", 0.9)

    DutyLocations.button[1] = guiCreateButton(9, 332, 240, 27, "-->", false, DutyLocations.window[1])
    guiSetProperty(DutyLocations.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyLocations.button[1], addLocationToDuty, false)
    addEventHandler("onClientGUIDoubleClick", DutyLocations.gridlist[1], addLocationToDuty, false)
    DutyLocations.button[2] = guiCreateButton(270, 332, 240, 27, "<--", false, DutyLocations.window[1])
    guiSetProperty(DutyLocations.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyLocations.button[2], removeLocationFromDuty, false)
    addEventHandler("onClientGUIDoubleClick", DutyLocations.gridlist[2], removeLocationFromDuty, false)
    DutyLocations.label[1] = guiCreateLabel(10, 19, 233, 17, "Tüm mekanlar", false, DutyLocations.window[1])
    guiLabelSetHorizontalAlign(DutyLocations.label[1], "center", false)
    DutyLocations.label[2] = guiCreateLabel(270, 19, 233, 17, "Görev yerleri", false, DutyLocations.window[1])
    guiLabelSetHorizontalAlign(DutyLocations.label[2], "center", false)
    DutyLocations.button[3] = guiCreateButton(270, 367, 146, 36, "Kaydet", false, DutyLocations.window[1])
    guiSetProperty(DutyLocations.button[3], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyLocations.button[3], saveGUI, false)

    DutyLocations.button[4] = guiCreateButton(103, 367, 146, 36, "Arayüzü Kapat", false, DutyLocations.window[1])
    guiSetProperty(DutyLocations.button[4], "NormalTextColour", "FFAAAAAA")   
    addEventHandler("onClientGUIClick", DutyLocations.button[4], closeTheGUI, false) 

    populateLocations()
end

DutySkins = {
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

function skinAlreadyExists(skin, dupont)
	for k,v in pairs(dutyNewSkins) do
		if skin == v[1] and dupont == v[2] then
			return true
		end
	end
end

function addSkin()
	local raw = guiGetText(DutySkins.edit[1])
	if string.find(raw, ":") then
		local howAboutIt = split(raw, ":")
		if tonumber(howAboutIt[1]) and tonumber(howAboutIt[2]) then
			if not skinAlreadyExists(tonumber(howAboutIt[1]), tonumber(howAboutIt[2])) then
				table.insert(dutyNewSkins, { howAboutIt[1], howAboutIt[2] })
				local row = guiGridListAddRow(DutySkins.gridlist[1])

				guiGridListSetItemText(DutySkins.gridlist[1], row, 1, tostring(howAboutIt[1]), false, false)
				guiGridListSetItemText(DutySkins.gridlist[1], row, 2, tostring(howAboutIt[2]), false, false)
			else
				outputChatBox("You cannot add the same skin twice.", 255, 0, 0)
			end
		else
			outputChatBox("Please use only numbers.", 255, 0, 0)
		end
	else
		local raw = tonumber(raw)
		if raw then
			if not skinAlreadyExists(raw, "N/A") then
				table.insert(dutyNewSkins, { raw, "N/A" })
				local row = guiGridListAddRow(DutySkins.gridlist[1])

				guiGridListSetItemText(DutySkins.gridlist[1], row, 1, tostring(raw), false, false)
				guiGridListSetItemText(DutySkins.gridlist[1], row, 2, "N/A", false, false)
			else
				outputChatBox("You cannot add the same skin twice.", 255, 0, 0)
			end
		else
			outputChatBox("Please use only numbers.", 255, 0, 0)
		end
	end
	guiSetText(DutySkins.edit[1], "")
end

function removeSkin()
   	local r, c = guiGridListGetSelectedItem ( DutySkins.gridlist[1] )
	if r >= 0 then
		local skin = guiGridListGetItemText(DutySkins.gridlist[1], r, 1)
		local dupont = guiGridListGetItemText(DutySkins.gridlist[1], r, 2) -- ew dupont!

		for k,v in pairs(dutyNewSkins) do
			if tonumber(v[1]) == tonumber(skin) and tostring(v[2]) == dupont then
				table.remove(dutyNewSkins, k)
				break
			end
		end

		guiGridListRemoveRow(DutySkins.gridlist[1], r)
	end
end

function createSkins()
	if isElement(DutySkins.window[1]) then
		destroyElement(DutySkins.window[1])
		dutyNewSkins = nil
	end
    DutySkins.window[1] = guiCreateWindow(697, 240, 294, 425, "", false)
    guiWindowSetSizable(DutySkins.window[1], false)
    centerWindow(DutySkins.window[1])

    DutySkins.gridlist[1] = guiCreateGridList(9, 36, 275, 275, false, DutySkins.window[1])
    guiGridListAddColumn(DutySkins.gridlist[1], "SkinID", 0.5)
    guiGridListAddColumn(DutySkins.gridlist[1], "DupontID", 0.5)
    DutySkins.label[1] = guiCreateLabel(12, 18, 272, 18, "Duty Skins", false, DutySkins.window[1])
    guiLabelSetHorizontalAlign(DutySkins.label[1], "center", false)
    DutySkins.edit[1] = guiCreateEdit(11, 313, 139, 29, "", false, DutySkins.window[1])
    DutySkins.button[1] = guiCreateButton(152, 313, 53, 29, "Add", false, DutySkins.window[1])
    guiSetProperty(DutySkins.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutySkins.button[1], addSkin, false)
    DutySkins.button[2] = guiCreateButton(231, 313, 53, 29, "Remove", false, DutySkins.window[1])
    guiSetProperty(DutySkins.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutySkins.button[2], removeSkin, false)
    addEventHandler("onClientGUIDoubleClick", DutySkins.gridlist[1], removeSkin, false)
    DutySkins.label[2] = guiCreateLabel(11, 345, 273, 29, "Use format: SkinID:DupontID\nExample: 121:622 or 130 for just a SkinID.", false, DutySkins.window[1])
    guiLabelSetHorizontalAlign(DutySkins.label[2], "center", false)
    DutySkins.button[3] = guiCreateButton(9, 381, 99, 34, "Cancel", false, DutySkins.window[1])
    guiSetProperty(DutySkins.button[3], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutySkins.button[3], closeTheGUI, false)

    DutySkins.button[4] = guiCreateButton(185, 381, 99, 34, "Save", false, DutySkins.window[1])
    guiSetProperty(DutySkins.button[4], "NormalTextColour", "FFAAAAAA")    
    addEventHandler("onClientGUIClick", DutySkins.button[4], saveGUI, false)

    populateSkins()
end

DutyVehicleAdd = {
    button = {},
    window = {},
    edit = {}
}
function createVehicleAdd()
	if isElement(DutyVehicleAdd.window[1]) then
		destroyElement(DutyVehicleAdd.window[1])
	end
    DutyVehicleAdd.window[1] = guiCreateWindow(685, 338, 335, 85, "Add new duty vehicle", false)
    guiWindowSetSizable(DutyVehicleAdd.window[1], false)
    centerWindow(DutyVehicleAdd.window[1])

    DutyVehicleAdd.edit[1] = guiCreateEdit(9, 26, 181, 40, "Vehicle ID", false, DutyVehicleAdd.window[1])
    DutyVehicleAdd.button[1] = guiCreateButton(192, 26, 62, 40, "Add", false, DutyVehicleAdd.window[1])
    guiSetProperty(DutyVehicleAdd.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyVehicleAdd.button[1], saveGUI, false)

    DutyVehicleAdd.button[2] = guiCreateButton(263, 26, 62, 40, "Close", false, DutyVehicleAdd.window[1])
    guiSetProperty(DutyVehicleAdd.button[2], "NormalTextColour", "FFAAAAAA")   
    addEventHandler( "onClientGUIClick", DutyVehicleAdd.button[2], closeTheGUI, false ) 
end

DutyLocationMaker = {
    button = {},
    window = {},
    edit = {},
    label = {}
}
function createDutyLocationMaker(x, y, z, r, i, d, name)
	if isElement(DutyLocationMaker.window[1]) then
		destroyElement(DutyLocationMaker.window[1])
	end
    DutyLocationMaker.window[1] = guiCreateWindow(638, 285, 488, 198, "Add duty location", false)
    guiWindowSetSizable(DutyLocationMaker.window[1], false)
    centerWindow(DutyLocationMaker.window[1])

    DutyLocationMaker.label[1] = guiCreateLabel(8, 24, 44, 19, "X Value:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[1] = guiCreateEdit(56, 24, 135, 20, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[2] = guiCreateLabel(201, 24, 53, 19, "Y Value:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[2] = guiCreateEdit(253, 23, 88, 20, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[3] = guiCreateLabel(355, 25, 52, 18, "Z Value:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[3] = guiCreateEdit(406, 23, 71, 20, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[4] = guiCreateLabel(8, 60, 49, 18, "Radius:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[4] = guiCreateEdit(53, 58, 82, 20, "1-10", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[5] = guiCreateLabel(162, 61, 72, 17, "Interior:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[5] = guiCreateEdit(216, 58, 93, 20, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[6] = guiCreateLabel(336, 60, 60, 18, "Dimension:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.edit[6] = guiCreateEdit(402, 58, 75, 20, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[7] = guiCreateLabel(9, 92, 57, 21, "Name:", false, DutyLocationMaker.window[1])
    DutyLocationMaker.label[8] = guiCreateLabel(10, 119, 467, 28, "The name of the duty is used strictly for your identification.", false, DutyLocationMaker.window[1])
    guiLabelSetHorizontalAlign(DutyLocationMaker.label[8], "center", false)
    DutyLocationMaker.edit[7] = guiCreateEdit(51, 91, 426, 22, "", false, DutyLocationMaker.window[1])
    DutyLocationMaker.button[1] = guiCreateButton(10, 149, 115, 37, "Insert Current Position", false, DutyLocationMaker.window[1])
    guiSetProperty(DutyLocationMaker.button[1], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyLocationMaker.button[1], curPos, false)

    DutyLocationMaker.button[2] = guiCreateButton(184, 149, 115, 37, "Close", false, DutyLocationMaker.window[1])
    guiSetProperty(DutyLocationMaker.button[2], "NormalTextColour", "FFAAAAAA")
    addEventHandler("onClientGUIClick", DutyLocationMaker.button[2], closeTheGUI, false)

    DutyLocationMaker.button[3] = guiCreateButton(357, 149, 115, 37, "Save", false, DutyLocationMaker.window[1])
    guiSetProperty(DutyLocationMaker.button[3], "NormalTextColour", "FFAAAAAA") 
    addEventHandler("onClientGUIClick", DutyLocationMaker.button[3], saveGUI, false)

    -- Populate List
    if name then
    	guiSetText(DutyLocationMaker.edit[1], x)
		guiSetText(DutyLocationMaker.edit[2], y)
		guiSetText(DutyLocationMaker.edit[3], z)
		guiSetText(DutyLocationMaker.edit[4], r)
		guiSetText(DutyLocationMaker.edit[5], i)
		guiSetText(DutyLocationMaker.edit[6], d)
		guiSetText(DutyLocationMaker.edit[7], name)
	end
end

function duplicateVeh(type, id, faction)
	for k,v in ipairs(locationsg) do
		if v[10] == id then
			return true
		end
	end
end

-- Closing! 
function closeTheGUI()
	if source == DutyCreate.button[1] then -- Main
		destroyElement(DutyCreate.window[1])
		customEditID = 0
		tempLocations = nil
		dutyNewSkins = nil
		dutyItems = nil
		setElementData(getLocalPlayer(), "savedLocations", false)
		setElementData(getLocalPlayer(), "savedSkins", false)
	elseif source == DutyLocations.button[4] then -- Main > Locations
		tempLocations = nil
		destroyElement(DutyLocations.window[1])
	elseif source == DutySkins.button[3] then -- Main > Skins
		dutyNewSkins = nil
		destroyElement(DutySkins.window[1])
	elseif source == DutyVehicleAdd.button[2] then -- Vehicle Add
		destroyElement(DutyVehicleAdd.window[1])
	elseif source == DutyLocationMaker.button[2] then -- Location Maker
		locationEditID = 0
		destroyElement(DutyLocationMaker.window[1])
	end
end

-- Save!
function saveGUI()
	if source == DutyCreate.button[2] then -- Main
		local name = guiGetText(DutyCreate.edit[3])
		if name ~= "" then
			if customEditID ~= 0 then
				triggerServerEvent("Duty:AddDuty", resourceRoot, dutyItems, getElementData(getLocalPlayer(), "savedLocations") or customg[customEditID][4], getElementData(getLocalPlayer(), "savedSkins") or customg[customEditID][3], name, factionIDg, customEditID)
			else
				triggerServerEvent("Duty:AddDuty", resourceRoot, dutyItems, getElementData(getLocalPlayer(), "savedLocations") or {}, getElementData(getLocalPlayer(), "savedSkins") or {}, name, factionIDg, customEditID)
			end
			tempLocations = nil
			dutyNewSkins = nil
			dutyItems = nil 
			customEditID = 0
			setElementData(getLocalPlayer(), "savedLocations", false)
			setElementData(getLocalPlayer(), "savedSkins", false)
		else
			outputChatBox("Please enter in a name for this duty.", 255, 0, 0)
			return
		end
		destroyElement(DutyCreate.window[1])
	elseif source == DutyLocations.button[3] then -- Main > Locations
		setElementData(getLocalPlayer(), "savedLocations", tempLocations)
		tempLocations = nil
		destroyElement(DutyLocations.window[1])
	elseif source == DutySkins.button[4] then -- Main > Skins
		setElementData(getLocalPlayer(), "savedSkins", dutyNewSkins)
		dutyNewSkins = nil
		destroyElement(DutySkins.window[1])
	elseif source == DutyVehicleAdd.button[1] then -- Vehicle Add
		local id = guiGetText(DutyVehicleAdd.edit[1])
		if not duplicateVeh("location", id, factionIDg) then
			triggerServerEvent("Duty:AddVehicle", resourceRoot, tonumber(id), factionIDg)
			destroyElement(DutyVehicleAdd.window[1])
		else
			outputChatBox("This vehicle is already added.", 255, 0, 0)
		end
	elseif source == DutyLocationMaker.button[3] then -- Location Maker
		local x = tonumber(guiGetText(DutyLocationMaker.edit[1]))
		local y = tonumber(guiGetText(DutyLocationMaker.edit[2]))
		local z = tonumber(guiGetText(DutyLocationMaker.edit[3]))
		local r = tonumber(guiGetText(DutyLocationMaker.edit[4]))
		local i = tonumber(guiGetText(DutyLocationMaker.edit[5]))
		local d = tonumber(guiGetText(DutyLocationMaker.edit[6]))
		local name = guiGetText(DutyLocationMaker.edit[7])
		if (x and y and z and r and i and d and name) then
			if r >= 1 and r <=10 then
				if string.len(name) > 0 then
					triggerServerEvent("Duty:AddLocation", resourceRoot, x, y, z, r, i, d, name, factionIDg, (locationEditID ~= 0 and locationEditID or nil))
				else
					outputChatBox("You must enter a name.", 255, 0, 0)
					return
				end
			else
				outputChatBox("Radius must be between 1 and 10", 255, 0, 0)
				return
			end
		else
			outputChatBox("Please enter in all the information correctly.", 255, 0, 0)
			return
		end
		locationEditID = 0
		destroyElement(DutyLocationMaker.window[1])
	end
end

function curPos()
	local x, y, z = getElementPosition(getLocalPlayer())
	local dim = getElementDimension(getLocalPlayer())
	local int = getElementInterior(getLocalPlayer())
	return guiSetText(DutyLocationMaker.edit[1], x), guiSetText(DutyLocationMaker.edit[2], y), guiSetText(DutyLocationMaker.edit[3], z), guiSetText(DutyLocationMaker.edit[5], int), guiSetText(DutyLocationMaker.edit[6], dim)
end

function removeLocation()
	local r, c = guiGridListGetSelectedItem ( Duty.gridlist[1] )
	if r >= 0 then
		local removeid = guiGridListGetItemText ( Duty.gridlist[1], r, 1 )
		triggerServerEvent("Duty:RemoveLocation", resourceRoot, removeid, factionIDg)
		locationsg[tonumber(removeid)] = nil
		refreshUI()
	end
end

function removeDuty()
	local r, c = guiGridListGetSelectedItem ( Duty.gridlist[2] )
	if r >= 0 then
		local removeid = guiGridListGetItemText ( Duty.gridlist[2], r, 1 )
		triggerServerEvent("Duty:RemoveDuty", resourceRoot, removeid, factionIDg)
		customg[tonumber(removeid)] = nil
		refreshUI()
	end
end

function removeVehicle()
	local r, c = guiGridListGetSelectedItem ( Duty.gridlist[3] )
	if r >= 0 then
		local removeid = guiGridListGetItemText ( Duty.gridlist[3], r, 1 )
		triggerServerEvent("Duty:RemoveLocation", resourceRoot, removeid, factionIDg)
		locationsg[tonumber(removeid)] = nil
		refreshUI()
	end
end