wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil

function resourceStop()
	guiSetInputEnabled(false)
	showCursor(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

local sx,sy = guiGetScreenSize()
local browser = guiCreateBrowser(0,0,sx,sy, true, true, false)
guiSetVisible(browser, false)
local browserGUI = guiGetBrowser(browser)

addEventHandler("onClientBrowserCreated",browserGUI, function()
	loadBrowserURL(source, "http://mta/local/index.html")
	end)
	
addEvent("reports.close",true)
addEventHandler("reports.close",root,function()
    guiSetInputEnabled(not guiGetVisible(browser))
	guiSetVisible(browser, false)

	playSound("sound.mp3")
end)


aracTamiri = {"fix","ters","tamir","döndü","taamir","fiiix","fiiix","fiiix","fiiix","fiiiix","tamiret","patladı","tekerlek","teker","motor","bozuldu"}

kufurler = {"sikeyim","sikim","orospu","anne","ana","sik","s1keyim","amı","göt","gavat","piç","karını","kaltak","avradını","avrat","bacını","şerefsiz","mal","aptal","salak","taşak","taşşak","çocuğu",}

addEvent("reports.send",true)
addEventHandler("reports.send",root,function(msg)
	for index, value in ipairs(aracTamiri) do
		if string.find(msg, value) then 
			if value then 
					outputChatBox("[!]#f9f9f9 Aracına tamir veya unflip atmıyoruz, tamir kiti ya da kriko satın almalısınız.", 255, 0, 0, true) 
					outputChatBox("[!]#f9f9f9 Ayrıca araçlarınızı yanınıza ışınlayamayız, NPC'lerden almanız gerekiyor.", 255, 0, 0, true) 
				return false 
			end
		return end
	end
	for index, value in ipairs(kufurler) do
		if string.find(msg, value) then 
			if value then 
					outputChatBox("[!]#f9f9f9 Küfür etmene hiç gerek yok, kalbimi kırıyorsun :(", 255, 0, 0, true) 
				return false 
			end
		return end
	end	
	if msg == "" then outputChatBox("[!] #ffffffLütfen rapor içeriğini boş bırakma.", 245, 66, 66, true) return end
	if getElementData(localPlayer, "reportNum") then
		outputChatBox("[!] #ffffffZaten sırada beklemede olan bir rapor kaydın var. Raporunu sonlandırmak için ( /er )", 245, 66, 66, true)
	else
	
		outputChatBox("[!] #ffffffBaşarıyla rapor kaydın oluşturuldu, lütfen sabırla bekle.", 255, 194, 14, true)
		outputChatBox("Gönderilen: #ffffff"..msg, 255, 194, 14, true)
		triggerServerEvent("clientSendReport", localPlayer, localPlayer, msg, 4)
		guiSetVisible(browser, false)
		guiSetInputEnabled(not guiGetInputEnabled(browser))		
	end
end)


bindKey("F2","down",function()
    guiSetVisible(browser, not guiGetVisible(browser))
	guiSetInputEnabled(guiGetVisible(browser))
	playSound("sound.mp3")
end)

function toggleReport()
	executeCommandHandler("report")
	if wHelp then
		guiSetInputEnabled(false)
		showCursor(false)
		destroyElement(wHelp)
		wHelp = nil
	end
end

function checkBinds()
	if ( exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) or getElementData( getLocalPlayer(), "account:gmlevel" )  ) then
		if getBoundKeys("ar") or getBoundKeys("acceptreport") then
			--outputChatBox("You had keys bound to accept reports. Please delete these binds.", 255, 0, 0)
			triggerServerEvent("arBind", getLocalPlayer())
		end
	end
end
setTimer(checkBinds, 60000, 0)

local function scale(w)
	local width, height = guiGetSize(w, false)
	local screenx, screeny = guiGetScreenSize()
	local minwidth = math.min(700, screenx)
	if width < minwidth then
		guiSetSize(w, minwidth, height / width * minwidth, false)
		local width, height = guiGetSize(w, false)
		guiSetPosition(w, (screenx - width) / 2, (screeny - height) / 2, false)
	end
end

function toggleVehTheft()
	if exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "vehtheft")
		local numPdMembers = #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lVehTheftStatus, "Kapalı")
			guiLabelSetColor(lVehTheftStatus, 255, 0, 0)
			setElementData(resourceRoot, "vehtheft", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Vehicle Theft", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lVehTheftStatus, "Açık")
			guiLabelSetColor(lVehTheftStatus, 0, 255, 0)
			setElementData(resourceRoot, "vehtheft", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Vehicle Theft", tostring(status))
		end
	end
end

function togglePropBreak()
	if exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "propbreak")
		local numPdMembers = #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lPropBreakStatus, "Kapalı")
			guiLabelSetColor(lPropBreakStatus, 255, 0, 0)
			setElementData(resourceRoot, "propbreak", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Property Break-in", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lPropBreakStatus, "Açık")
			guiLabelSetColor(lPropBreakStatus, 0, 255, 0)
			setElementData(resourceRoot, "propbreak", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Property Break-in", tostring(status))
		end
	end
end

function togglePaperForg()
	if exports.vrp_integration:isPlayerTrialAdmin(getLocalPlayer()) then
		local status = getElementData(resourceRoot, "papforg")
		local numPdMembers = #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(1)) + #getPlayersInTeam(exports.vrp_factions:getTeamFromFactionID(59)) --PD and HP
		if numPdMembers < 3 then return outputChatBox("Oyunda 3 tane aktif güvenlik olmadığından dolayı, bu özelliği değiştiremezsin.") end -- Automaticly to 'on hold' is less than 3 pd members
		if status == "Açık" then
			guiSetText(lPapForgeryStatus, "Kapalı")
			guiLabelSetColor(lPapForgeryStatus, 255, 0, 0)
			setElementData(resourceRoot, "papforg", "Kapalı")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Paper Forgery", tostring(status))
		elseif status == "Kapalı" then
			guiSetText(lPapForgeryStatus, "Açık")
			guiLabelSetColor(lPapForgeryStatus, 0, 255, 0)
			setElementData(resourceRoot, "papforg", "Açık")
			triggerServerEvent("toggleStatus", localPlayer, localPlayer, "Paper Forgery", tostring(status))
		end
	end
end

-- // bekiroj
function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	--outputDebugString(logged)
	if (logged==1) then
		if (wReportMain==nil)  then
			reportedPlayer = nil
			wReportMain = guiCreateWindow(0.2, 0.2, 0.2, 0.25, "Lucy Roleplay - Yardım Arayüzü", true)
			playSound("sound.mp3")
			scale(wReportMain)
			guiSetInputEnabled(true)

			lPlayerName = guiCreateLabel(0, 0.1, 1.0, 0.3, "Kimi şikayet ediyorsun?", true, wReportMain)
			guiLabelSetHorizontalAlign( lPlayerName, "center", true)			
			guiSetFont(lPlayerName, "default-bold-small")

			tPlayerName = guiCreateEdit(0.3799, 0.13 , 0.25, 0.08, "Aradığınız Isim / ID", true, wReportMain)
			guiLabelSetHorizontalAlign( lPlayerName, "center", true)						
			addEventHandler("onClientGUIClick", tPlayerName, function()
				guiSetText(tPlayerName,"")
			end, false)

			lNameCheck = guiCreateLabel(0, 0.220, 1.0, 0.3, "Üst tarafı doldurmak zorunda değilsin.", true, wReportMain)
			guiLabelSetHorizontalAlign( lNameCheck, "center", true)						
			guiSetFont(lNameCheck, "default-bold-small")
			guiLabelSetColor(lNameCheck, 0, 255, 0)
			addEventHandler("onClientGUIChanged", tPlayerName, checkNameExists)

			lReportType = guiCreateLabel(0, 0.26, 1.0, 0.3, "Rapor içeriğinizi seçiniz.", true, wReportMain)
			guiLabelSetHorizontalAlign( lReportType, "center", true)			
			guiSetFont(lReportType, "default-bold-small")

			cReportType = guiCreateComboBox(0.358, 0.32, 0.3, 0.34, "Raporuma içerik belirle.", true, wReportMain)
			
			for key, value in ipairs(reportTypes) do
				guiComboBoxAddItem(cReportType, value[1])
			end
			addEventHandler("onClientGUIComboBoxAccepted", cReportType, canISubmit)
			addEventHandler("onClientGUIComboBoxAccepted", cReportType, function()
				local selected = guiComboBoxGetSelected(cReportType)+1
				guiLabelSetHorizontalAlign( lReportType, "center", true)
				guiSetText(lReportType, reportTypes[selected][7])
				end)

			lReport = guiCreateLabel(0, 0.45, 1.0, 0.3, "Merhaba sayın oyuncu, senden bir ricam var. Lütfen rapor açarken yazım kurallarına uy, sabırla bekle. ", true, wReportMain)
			guiLabelSetHorizontalAlign(lReport, "center")
			guiSetFont(lReport, "default-bold-small")
			guiSetFont(lPlayerName, "default-bold-small")

			tReport = guiCreateMemo(0.025, 0.49, 6, 0.3, "", true, wReportMain)
			addEventHandler("onClientGUIChanged", tReport, canISubmit)

			lLengthCheck = guiCreateLabel(0.29, 0.81, 0.4, 0.3, "Uzunluk: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150", true, wReportMain)
			guiLabelSetHorizontalAlign(lLengthCheck, "center")
			guiLabelSetColor(lLengthCheck, 0, 255, 0)
			guiSetFont(lLengthCheck, "default-bold-small")

			bSubmitReport = guiCreateButton(0, 0.875, 0.2, 0.1, "Gönder", true, wReportMain)
			addEventHandler("onClientGUIClick", bSubmitReport, submitReport)

			guiWindowSetSizable(wReportMain, false)
			showCursor(true)
			triggerEvent("hud:convertUI", localPlayer, wReportMain)			

		elseif (wReportMain~=nil) then
			guiSetVisible(wReportMain, false)
			destroyElement(wReportMain)

			wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
			guiSetInputEnabled(false)
			showCursor(false)
		end
	end
end
addCommandHandler("report", showReportMainUI)

function submitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer or getLocalPlayer(), tostring(guiGetText(tReport)), (guiComboBoxGetSelected(cReportType)+1))

		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	guiSetText(lLengthCheck, "Uzunluk: " .. string.len(tostring(guiGetText(tReport)))-1 .. "/150")

	if (tonumber(string.len(tostring(guiGetText(tReport))))-1>150) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1<3) then
		guiLabelSetColor(lLengthCheck, 255, 0, 0)
		return false
	elseif (tonumber(string.len(tostring(guiGetText(tReport))))-1>130) then
		guiLabelSetColor(lLengthCheck, 255, 255, 0)
		return true
	else
		guiLabelSetColor(lLengthCheck,0, 255, 0)
		return true
	end
end

function checkType(theGUI)
	local selected = guiComboBoxGetSelected(cReportType)+1 -- +1 to relate to the table for later

	if not selected or selected == 0 then
		return false
	else
		return true
	end
end

function canISubmit()
	local rType = checkType()
	local rReportLength = checkReportLength()
	--[[local adminreport = getElementData(getLocalPlayer(), "adminreport")
	local gmreport = getElementData(getLocalPlayer(), "gmreport")]]
	local reportnum = getElementData(getLocalPlayer(), "reportNum")
	if rType and rReportLength then
		if reportnum then
			guiSetText(wReportMain, "Rapor kimliğiniz #" .. (reportnum).. " Hala beklemede. Lütfen başka bir şey göndermeden önce bekleyin veya bekleyin..")
		else
			guiSetEnabled(bSubmitReport, true)
		end
	else
		guiSetEnabled(bSubmitReport, false)
	end
end

function checkNameExists(theEditBox)
	local found = nil
	local count = 0


	local text = guiGetText(theEditBox)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			for key, value in ipairs(players) do
				local username = string.lower(tostring(getPlayerName(value)))
				if string.find(username, string.lower(text)) then
					count = count + 1
					found = value
					break
				end
			end
		end
	end

	if (count>1) then
		guiSetText(lNameCheck, "Multiple Found - Will take yourself to submit.")
		guiLabelSetColor(lNameCheck, 255, 255, 0)
	elseif (count==1) then
		guiSetText(lNameCheck, "Seçilen: " .. getPlayerName(found) .. " [ID #" .. getElementData(found, "playerid") .. "]")
		guiLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
	elseif (count==0) then
		guiSetText(lNameCheck, "Böyle bir oyuncu yok. Kafandan bir şeyler üretiyorsun sanırım.")
		guiLabelSetColor(lNameCheck, 255, 0, 0)
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)
	elseif (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lLengthCheck, bSubmitReport = nil
		guiSetInputEnabled(false)
		showCursor(false)

		triggerEvent("viewF1Help", getLocalPlayer())
	end
end

function onOpenCheck(playerID)
	executeCommandHandler ( "check", tostring(playerID) )
end
addEvent("report:onOpenCheck", true)
addEventHandler("report:onOpenCheck", getRootElement(), onOpenCheck)
