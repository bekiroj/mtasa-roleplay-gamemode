function birlikKurGUI()
	guiSetInputMode("no_binds_when_editing")
	local screenW, screenH = guiGetScreenSize()
	birlikWindow = guiCreateWindow((screenW - 288) / 2, (screenH - 321) / 2, 288, 321, "Valhalla - Birlik Sistemi", false)
	guiWindowSetSizable(birlikWindow, false)

	isimLbl = guiCreateLabel(10, 26, 63, 26, "Birlik İsmi: ", false, birlikWindow)
	guiLabelSetHorizontalAlign(isimLbl, "center", false)
	guiLabelSetVerticalAlign(isimLbl, "center")
	isimEdit = guiCreateEdit(73, 26, 204, 26, "", false, birlikWindow)
	maxKarakterLbl = guiCreateLabel(73, 52, 204, 15, "Max. 36 Karakter.", false, birlikWindow)
	turLbl = guiCreateLabel(10, 77, 63, 26, "Birlik Türü: ", false, birlikWindow)
	guiLabelSetHorizontalAlign(turLbl, "center", false)
	guiLabelSetVerticalAlign(turLbl, "center")
	ceteRadio = guiCreateRadioButton(73, 77, 204, 26, "Çete", false, birlikWindow)
	mafyaRadio = guiCreateRadioButton(73, 103, 204, 26, "Mafya", false, birlikWindow)
	haberRadio = guiCreateRadioButton(73, 129, 204, 26, "Haber", false, birlikWindow)
	sanayiRadio = guiCreateRadioButton(73, 155, 204, 26, "Sanayi", false, birlikWindow)
	digerRadio = guiCreateRadioButton(73, 181, 204, 26, "Diğer (Legal)", false, birlikWindow)
	guiRadioButtonSetSelected(digerRadio, true)
	kurBtn = guiCreateButton(10, 217, 267, 39, "Birlik Kur ($10.000)", false, birlikWindow)
	addEventHandler("onClientGUIClick", kurBtn, 
		function() 
			if guiRadioButtonGetSelected(ceteRadio) then
				birlikType = 0
			elseif guiRadioButtonGetSelected(mafyaRadio) then
				birlikType = 1
			elseif guiRadioButtonGetSelected(haberRadio) then
				birlikType = 6
			elseif guiRadioButtonGetSelected(sanayiRadio) then
				birlikType = 7
			elseif guiRadioButtonGetSelected(digerRadio) then
				birlikType = 5
			end
			triggerServerEvent("birlikKur", getLocalPlayer(), getLocalPlayer(), guiGetText(isimEdit), birlikType) 
			destroyElement(birlikWindow) 
		end
	)
	guiSetProperty(kurBtn, "NormalTextColour", "FFAAAAAA")
	kapatBtn = guiCreateButton(10, 266, 267, 39, "Kapat", false, birlikWindow)
	addEventHandler("onClientGUIClick", kapatBtn, function() destroyElement(birlikWindow) end)
	guiSetProperty(kapatBtn, "NormalTextColour", "FFAAAAAA")
end
addEvent("birlikKurGUI", true)
addEventHandler("birlikKurGUI", getRootElement(), birlikKurGUI)

function birlikSeviyeGUI(birlikIsmi, birlikLevel)
	local screenW, screenH = guiGetScreenSize()
	local birlikFiyat = 150000 * birlikLevel
	seviyeWindow = guiCreateWindow((screenW - 289) / 2, (screenH - 181) / 2, 289, 230, "Valhalla- - Birlik Seviyesi ", false)
	guiWindowSetSizable(seviyeWindow, false)

	isimLbl = guiCreateLabel(13, 30, 267, 24, "Birlik İsmi: " .. birlikIsmi, false, seviyeWindow)
	guiLabelSetVerticalAlign(isimLbl, "center")
	seviyeLbl = guiCreateLabel(13, 64, 267, 24, "Birlik Seviyesi: " .. birlikLevel, false, seviyeWindow)
	guiLabelSetVerticalAlign(seviyeLbl, "center")

	local yeniBirlikSeviyesi = birlikLevel + 1
	yeniSeviyeLbl = guiCreateLabel(13, 98, 267, 24, "Yeni Birlik Seviyesi: " .. yeniBirlikSeviyesi, false, seviyeWindow)
	
	guiLabelSetVerticalAlign(yeniSeviyeLbl, "center")
	seviyeYukseltBtn = guiCreateButton(13, 132, 267, 37, "Seviye Yükselt (" .. string.gsub(birlikFiyat, "^(-?%d+)(%d%d%d)", '%1.%2') .. " TL)", false, seviyeWindow)
	addEventHandler("onClientGUIClick", seviyeYukseltBtn, function() triggerServerEvent("birlikSeviye", getLocalPlayer(), getLocalPlayer(), birlikIsmi, yeniBirlikSeviyesi, birlikFiyat) destroyElement(seviyeWindow) end)
	seviyeKapatBtn = guiCreateButton(13, 179, 267, 37, "Kapat", false, seviyeWindow)
	addEventHandler("onClientGUIClick", seviyeKapatBtn, function() destroyElement(seviyeWindow) end)

end
addEvent("birlikSeviyeGUI", true)
addEventHandler("birlikSeviyeGUI", getRootElement(), birlikSeviyeGUI)

function adminBirlikKur()
	guiSetInputMode("no_binds_when_editing")
	local screenW, screenH = guiGetScreenSize()
	adminBirlikWindow = guiCreateWindow((screenW - 288) / 2, (screenH - 321) / 2, 288, 321, "Valhalla - Birlik Oluştur", false)
	guiWindowSetSizable(adminBirlikWindow, false)

	nameLbl = guiCreateLabel(10, 26, 63, 26, "Birlik İsmi: ", false, adminBirlikWindow)
	guiLabelSetHorizontalAlign(nameLbl, "center", false)
	guiLabelSetVerticalAlign(nameLbl, "center")
	nameEdit = guiCreateEdit(73, 26, 204, 26, "", false, adminBirlikWindow)
	maxKarakterLbl = guiCreateLabel(73, 52, 204, 15, "Max. 36 Karakter.", false, adminBirlikWindow)
	turLbl = guiCreateLabel(10, 77, 63, 26, "Birlik Türü: ", false, adminBirlikWindow)
	guiLabelSetHorizontalAlign(turLbl, "center", false)
	guiLabelSetVerticalAlign(turLbl, "center")
	ceteRadio = guiCreateRadioButton(73, 77, 204, 26, "Çete", false, adminBirlikWindow)
	mafyaRadio = guiCreateRadioButton(73, 103, 204, 26, "Mafya", false, adminBirlikWindow)
	haberRadio = guiCreateRadioButton(73, 129, 204, 26, "Haber", false, adminBirlikWindow)
	sanayiRadio = guiCreateRadioButton(73, 155, 204, 26, "Sanayi", false, adminBirlikWindow)
	digerRadio = guiCreateRadioButton(73, 181, 204, 26, "Diğer (Legal)", false, adminBirlikWindow)
	guiRadioButtonSetSelected(digerRadio, true)
	kurBtn = guiCreateButton(10, 217, 267, 39, "Birliği Oluştur", false, adminBirlikWindow)
	addEventHandler("onClientGUIClick", kurBtn, 
		function() 
			if guiRadioButtonGetSelected(ceteRadio) then
				birlikType = 0
			elseif guiRadioButtonGetSelected(mafyaRadio) then
				birlikType = 1
			elseif guiRadioButtonGetSelected(haberRadio) then
				birlikType = 6
			elseif guiRadioButtonGetSelected(sanayiRadio) then
				birlikType = 7
			elseif guiRadioButtonGetSelected(digerRadio) then
				birlikType = 5
			end
			triggerServerEvent("adminBirlikKur", getLocalPlayer(), getLocalPlayer(), guiGetText(nameEdit), birlikType) 
			destroyElement(adminBirlikWindow) 
		end
	)
	guiSetProperty(kurBtn, "NormalTextColour", "FFAAAAAA")
	kapatBtn = guiCreateButton(10, 266, 267, 39, "Kapat", false, adminBirlikWindow)
	addEventHandler("onClientGUIClick", kapatBtn, function() destroyElement(adminBirlikWindow) end)
	guiSetProperty(kapatBtn, "NormalTextColour", "FFAAAAAA")
end

function makeFaction()
	if not exports.vrp_integration:isPlayerDeveloper(localPlayer) then return end
	adminBirlikKur()
end
addCommandHandler("makefaction", makeFaction)
