
marketListesi = {
	{0, "İsim Değişikliği (Cinsiyet ve İsim)", 10},
	{1, "VIP 1 (1/ay)", 40 	},
	{2, "VIP 2 (1/ay)", 40},
	{3, "VIP 3 (1/ay)", 60},
	{4, "VIP 4 (1/ay)", 80},
	{5, "Karakter Sayısı Arttırma (1 Adet)", 5},
	{6, "Kullanıcı İsmi Değişikliği", 10},
	{7, "Özel Plaka", 5},
	{8, "Cam Filmi", 10},
	{9, "Araç Neon", 15},
	{10, "Araç Texture (Kaplama)", 20},
	{11, "Kelebek Kapı", 10},
	{12, "Araç Slotu Arttırma", "5"},
	{13, "History Sildirme", 1},

}


aracListesi = {
	-- vehname, price, model, owlmodel, maxspeed, tax
	{"Audi A7", 200, 529, 1076, 260, 35},
	{"Range Rover", 100, 490, 1078, 250, 25},
	{"Mercedes Amg", 70, 602, 1079, 230, 25},
	{"BMW M4", 120, 412, 1080, 225, 20},
	{"Masserati", 100, 402, 1081, 215, 15},
}

function getPrivateSettings(booling)
	if (booling == "vehicle") then
		return aracListesi
	end
end

restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end

aracListesiRenk = {
	{"Siyah", {0,0,0}},
	{"Beyaz", {255,255,255}},
	{"Kırmızı", {255,0,0}},
	{"Yeşil", {0,255,0}},
	{"Mavi", {0,0,255}},
	{"Sarı", {255,135,0}},
	{"Gri", {90,90,90}}
}

silahListesi = {
	{31, "M4", 250},
	{30, "AK-47", 90},
	{29, "MP5", 65},
	{25, "Shotgun", 65},
	{32, "Tec-9", 65},
	{28, "Uzi", 55},
	{24, "Deagle", 50},
	{22, "Colt45", 30},
}

hakListesi = {
	[356] = math.ceil(250/3),
	[355] = math.ceil(90/3),
	[353] = math.ceil(65/3),
	[349] = math.ceil(65/3),
	[372] = math.ceil(65/3),
	[352] = math.ceil(55/3),
	[348] = math.ceil(50/3),
	[346] = math.ceil(30/3),
}


local sx, sy = guiGetScreenSize()
local maintance = false
function marketSistemiAC()
	if not exports.vrp_integration:isPlayerDeveloper(localPlayer) and maintance then outputChatBox("[!] #ffffffBurayı güncelliyoruz, sürprizleri bekle ;)", 255, 0, 0, true) return end
	if getElementData(localPlayer, "loggedin") == 0 then outputChatBox("[!] #ffffffBu komutu karakterinizdeyken kullanabilirsiniz.", 255, 0, 0, true) return end
	setElementData(localPlayer, "marketSistemiAcik", 1)
	--showCursor(true)
	--guiSetInputEnabled(true)
	
	imageWindow = false
	normalWindow = guiCreateWindow(sx/2-600/2,sy/2-400/2,540,400, "Valhalla - Market Sistemi", false)
	guiWindowSetSizable(normalWindow, false)
	guiWindowSetMovable(normalWindow, false)

	tab = guiCreateTabPanel(10,24,690,380,false, normalWindow)
	window = guiCreateTab("Kişisel Özellikler", tab)
	window2 = guiCreateTab("Özel Araçlar", tab)
	--window3 = guiCreateTab("Evcil Hayvanlar", tab)
	window4 = guiCreateTab("Silahlar", tab)
	
	--window5 = guiCreateTab("#", tab)
	window6 = guiCreateTab("Animasyonlar", tab)

	-------------- CUSTOM ANIMATION SYSTEM ------------------
	tab6 = guiCreateTabPanel(10,5,670,290,false,window6)
	tab6_1 = guiCreateTab("Animasyon Fizikleri", tab6)
	tab6_2 = guiCreateTab("Kodlu Animasyonlar", tab6)
	onaylaButonu6 = guiCreateButton(0.03, 0.89, 0.45, 0.09, "Ürünü Satın Al", true, window6)
	guiSetFont(onaylaButonu6, "default-bold")
	guiSetFont(tab, "default-bold")
	
	kapatButonu6 = guiCreateButton(0.52, 0.89, 0.45, 0.09, "Arayüzden Çık", true, window6)
	guiSetFont(kapatButonu6, "default-bold")
	
	gridlist6 = guiCreateGridList(0.03, 0.06, 0.70, 0.80, true, tab6_1)
	guiGridListSetSortingEnabled(gridlist6, false)
	guiGridListAddColumn(gridlist6, "İsim", 0.65)
	guiGridListAddColumn(gridlist6, "Fiyat", 0.20)

	local customtable = getElementData(localPlayer, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
	for index, value in pairs(exports['vrp_animations']:getCustomAnimations()) do
		if value.price > 0 and value.engine == 1 then
			local row = guiGridListAddRow(gridlist6)
			guiGridListSetItemText(gridlist6, row, 1, value.name, false, false)
			guiGridListSetItemData(gridlist6, row, 1, index, false, false)
			guiGridListSetItemData(gridlist6, row, 2, value.price, false, false)
			guiGridListSetItemText(gridlist6, row, 2, ((value.price) or 0).." $", false, false)
			if customtable[index] then
				for i = 1, 2 do
					guiGridListSetItemColor(gridlist6, row, i, 0, 255, 0)
				end
			else
				for i = 1, 2 do
					guiGridListSetItemColor(gridlist6, row, i, 225, 225, 225)
				end
			end
		end
	end
	
	gridlist61 = guiCreateGridList(0.03, 0.06, 0.70, 0.80, true, tab6_2)
	guiGridListSetSortingEnabled(gridlist61, false)
	guiGridListAddColumn(gridlist61, "İsim", 0.65)
	guiGridListAddColumn(gridlist61, "Fiyat", 0.20)

	local customtable = getElementData(localPlayer, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
	for index, value in pairs(exports['vrp_animations']:getCustomAnimations()) do
		if value.price > 0 and value.engine == 0 then
			local row = guiGridListAddRow(gridlist61)
			guiGridListSetItemText(gridlist61, row, 1, value.name, false, false)
			guiGridListSetItemData(gridlist61, row, 1, index, false, false)
			guiGridListSetItemData(gridlist61, row, 2, value.price, false, false)
			guiGridListSetItemText(gridlist61, row, 2, ((value.price) or 0).." $", false, false)
			if customtable[index] then
				for i = 1, 2 do
					guiGridListSetItemColor(gridlist61, row, i, 0, 255, 0)
				end
			else
				for i = 1, 2 do
					guiGridListSetItemColor(gridlist61, row, i, 225, 225, 225)
				end
			end
		end
	end

	--------------------- BAKIYE YAZISI ---------------------

	bakiyeMiktari = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window)

	guiLabelSetHorizontalAlign(bakiyeMiktari, "right", false)

	bakiyeMiktari2 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window2)

	guiLabelSetHorizontalAlign(bakiyeMiktari2, "right", false)

	--bakiyeMiktari3 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window3)
	
	--guiLabelSetHorizontalAlign(bakiyeMiktari3, "right", false)
	
	bakiyeMiktari4 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window4)
	
	guiLabelSetHorizontalAlign(bakiyeMiktari4, "right", false)
	
	--bakiyeMiktari5 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window5)
	
	--guiLabelSetHorizontalAlign(bakiyeMiktari5, "right", false)
	
	bakiyeMiktari6 = guiCreateLabel(0.79, 0.01, 0.18, 0.04, ""..getElementData(localPlayer, "bakiye").." $", true, window6)
	
	guiLabelSetHorizontalAlign(bakiyeMiktari6, "right", false)
	---------------------------------------------------------

	--[[------------------- BAKIYE DÖNÜŞTÜR -------------------	
	
	bakiyeUyari = guiCreateLabel(0.28, 0.1, 0.97, 0.17, "Ne kadar bakiye dönüştürülecek?", true, window5)
	bakiyeEdit = guiCreateEdit(0.28,0.2, 0.46, 0.07, "", true, window5)
	bakiyeDonusecek = guiCreateLabel(0.28, 0.3, 0.97, 0.17, "Dönüştürülecek para: $0", true, window5)
	bakiyeCheck = guiCreateCheckBox(0.28, 0.35,0.40, 0.10, "Onaylıyor musunuz? (tik koyunuz)", false, true, window5)
	bakiyeDonusturButton = guiCreateButton(0.28,0.45,0.46,0.07, "Bakiyeyi Paraya Dönüştür", true, window5)
	
	guiEditSetMaxLength(bakiyeEdit, 3)
	guiSetProperty(bakiyeEdit, "ValidationString", "^[0-9]*$")
	
	kapatButonu5 = guiCreateButton(0.05, 0.87, 0.9, 0.10, "Arayüzden Çık", true, window5)
	guiSetFont(kapatButonu5, "default-bold")
	]]
	--------------------- SATIS LISTESI ---------------------
	gridlist = guiCreateGridList(0.03, 0.1, 0.94, 0.74, true, window)
	guiGridListSetSortingEnabled(gridlist, false)
	guiGridListAddColumn(gridlist, "İsim", 0.75)
	guiGridListAddColumn(gridlist, "Fiyat", 0.20)
	--guiGridListAddRow(gridlist)
	local urunIndirimler = {}
	for index, value in ipairs(marketListesi) do
		local row = guiGridListAddRow(gridlist)
		guiGridListSetItemText(gridlist, row, 1, value[2], false, false)
		guiGridListSetItemText(gridlist, row, 2, value[3].." $", false, false)
		if string.find(value[2]:lower(), "yerine") then
			urunIndirimler[#urunIndirimler + 1] = row
		end
	end
	
	stateColor = false
	
			
	--guiGridListSetItemText(gridlist, 0, 1, "-", false, false)
	--guiGridListSetItemText(gridlist, 0, 2, "10 $", false, false)
	---------------------------------------------------------
	
	
	onaylaButonu = guiCreateButton(0.03, 0.89, 0.45, 0.09, "Ürünü Satın Al", true, window)
	guiSetFont(onaylaButonu, "default-bold")
	indirimTimer = setTimer(
		function()
			if isElement(normalWindow) then
				stateColor = not stateColor
				for i, v in ipairs(urunIndirimler) do
					if stateColor then
						for i=1, 2 do
							guiGridListSetItemColor(gridlist, v, i, 237, 184, 43)
						end
						guiSetProperty (onaylaButonu3, "NormalTextColour", "FFEDB82B")
						guiSetProperty (onaylaButonu4, "NormalTextColour", "FFEDB82B")
					else
						for i=1, 2 do
							guiGridListSetItemColor(gridlist, v, i, 255, 255, 255)
						end
						guiSetProperty (onaylaButonu3, "NormalTextColour", "FFFFFFFF")
						guiSetProperty (onaylaButonu4, "NormalTextColour", "FFFFFFFF")
					end
				end
			else
				killTimer(indirimTimer)
			end
		end,
	700, 0)

	
	kapatButonu = guiCreateButton(0.52, 0.89, 0.45, 0.09, "Arayüzden Çık", true, window)
	guiSetFont(kapatButonu, "default-bold")


	--------------------- SATIS LISTESI VE TAB 2 ---------------------
	gridlist2 = guiCreateGridList(0.03, 0.18, 0.46, 0.48, true, window2)
	guiGridListSetSortingEnabled(gridlist2, false)
	guiGridListAddColumn(gridlist2, "İsim", 0.65)
	guiGridListAddColumn(gridlist2, "Fiyat", 0.20)

	for index, value in ipairs(aracListesi) do
		local row = guiGridListAddRow(gridlist2)
		guiGridListSetItemText(gridlist2, row, 1, value[1], false, false)
		guiGridListSetItemText(gridlist2, row, 2, value[2].." $", false, false)
	end

	kapatButonu2 = guiCreateButton(0.52, 0.89, 0.45, 0.09, "Arayüzden Çık", true, window2)
	guiSetFont(kapatButonu2, "default-bold")

	araciSatinAlmaButonu = guiCreateButton(0.03, 0.89, 0.45, 0.09, "Ürünü Satın Al", true, window2)


	x,y,z = getCameraMatrix()
	previewObject = createVehicle(410, 0, 0, 0)

	setElementData(previewObject, "alpha", 255)
	setElementDimension(previewObject, 31)

	oPrevElement = exports["vrp_object_preview"]:createObjectPreview(previewObject, 0, 0, 180, 0.46, 0.40, 0.26, 0.20, true, true)
	--rotation config
	local scrollbar = guiCreateScrollBar(0.51, 0.75, 0.47, 0.07, true, true, window2)
	guiSetProperty(scrollbar, "StepSize", "0.0028")
	addEventHandler('onClientGUIScroll', scrollbar,
		function()
			local rotation = tonumber(guiGetProperty(source, "ScrollPosition"))
			setElementRotation(previewObject, 0, 0, 155 + rotation * 360)
			exports["vrp_object_preview"]:setRotation(oPrevElement,0, 0, 155 + rotation * 360)
		end, false)
	--color config
	--[[
	vehColorCBox = guiCreateComboBox(0.03, 0.07, 0.46, 0.50, "Araç Rengi", true, window2)
	for k,v in ipairs(aracListesiRenk) do
		guiComboBoxAddItem(vehColorCBox, v[1])

	end
	]]--
	vehColorCBox = guiCreateButton(0.03,0.09,0.46,0.08, "Araç Rengini Ayarla", true, window2)

	--plate = guiCreateLabel(0.03, 0.68,0.40, 0.10, "Özel Plaka (Ek 10TL):", true, window2)
	plate = guiCreateCheckBox(0.03, 0.65,0.40, 0.10, "5 $ Karşlığında özel plaka istiyorum.", false, true, window2)
	plateEdit = guiCreateEdit(0.03,0.75, 0.46, 0.07, "örn: SLR26", true, window2)
	guiEditSetMaxLength(plateEdit, 12)
	guiSetEnabled(plateEdit, false)

	infoLabel = guiCreateLabel(0.03, 0.02,0.90, 0.10, "Araç Hız Limiti: ...", true, window2)
	
	-- ################################################################################################################
	
	--- ###### TAB 3 * PETLER ######---
	--[[gridlist3 = guiCreateGridList(0.03, 0.07, 0.54, 0.60, true, window3window3)
	guiGridListSetSortingEnabled(gridlist3, false)
	guiGridListAddColumn(gridlist3, "Köpek Adı", 0.75)

	--guiGridListAddRow(gridlist3)
	
	for index, value in ipairs(exports.vrp_pet:getDogs()) do
		local row = guiGridListAddRow(gridlist3)
		guiGridListSetItemText(gridlist3, row, 1, "Köpek "..index, false, false)
		guiGridListSetItemData(gridlist3, row, 1, value[8], false, false)
	end
	--guiGridListSetSelectedItem(gridlist3, 1)
	image = guiCreateStaticImage(420, 36, 223, 226, ":pet/files/pet.png", false, window3)
	label = guiCreateLabel(20, 250, 165, 15, "Köpek Adı:", false, window3)
	pet_name = guiCreateEdit(19, 272, 349, 27, petName or "", false, window3)

	onaylaButonu3 = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Ürünü Satın Al (30 $)", true, window3)
	guiSetFont(onaylaButonu3, "default-bold")

	
	kapatButonu3 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Arayüzden Çık", true, window3)
	guiSetFont(kapatButonu3, "default-bold")
	]]
	-- ################################################################################################################
	
	--- ###### TAB 4 * SILAHLAR ######---
	tabpanel4 = guiCreateTabPanel(0.03, 0.07, 0.94, 0.80, true, window4)
	tab41 = guiCreateTab("Silah Alımı", tabpanel4)
	tab42 = guiCreateTab("Hak Ekletme", tabpanel4)
	gridlist41 = guiCreateGridList(0.03, 0.17, 0.94, 0.70, true, tab41)
	guiGridListSetSortingEnabled(gridlist41, false)
	guiGridListAddColumn(gridlist41, "İsim", 0.45)
	guiGridListAddColumn(gridlist41, "Fiyat", 0.20)
	--guiGridListAddColumn(gridlist41, "Hak Fiyatı", 0.20)
	for index, value in ipairs(silahListesi) do
		local row = guiGridListAddRow(gridlist41)
		guiGridListSetItemText(gridlist41, row, 1, "("..index..") - "..value[2], false, false)
		guiGridListSetItemText(gridlist41, row, 2, value[3].." $", false, false)
	--	guiGridListSetItemText(gridlist41, row, 3, math.floor(value[3]/3).." $", false, false)
	end
	gridlist42 = guiCreateGridList(0.03, 0.17, 0.94, 0.70, true, tab42)
	guiGridListSetSortingEnabled(gridlist42, false)
	guiGridListAddColumn(gridlist42, "İsim", 0.45)
	guiGridListAddColumn(gridlist42, "Hak Fiyatı", 0.20)
	guiGridListAddColumn(gridlist42, "Şu Anki Silah Hakkı", 0.20)
	--guiGridListAddColumn(gridlist42, "Hak Fiyatı", 0.20)
	for index, value in ipairs(exports['vrp_items']:getItems(localPlayer)) do
		 if value[1] == 115 and hakListesi[exports['vrp_items']:getItemModel(value[1], value[2])] then
			local row = guiGridListAddRow(gridlist42)
			guiGridListSetItemText(gridlist42, row, 1, exports['vrp_items']:getItemName(value[1], value[2]), false, false)
		--	guiGridListSetItemText(gridlist42, row, 2, value[3].." $", false, false)
			guiGridListSetItemData(gridlist42, row, 1, value[3], false, false)
			guiGridListSetItemText(gridlist42, row, 2, (hakListesi[exports['vrp_items']:getItemModel(value[1], value[2])] or 9999).." $", false, false)
			guiGridListSetItemData(gridlist42, row, 2, (hakListesi[exports['vrp_items']:getItemModel(value[1], value[2])] or 0), false, false)
			local silahHak = (#tostring(exports.vrp_global:explode(":", value[2])[5])>0 and exports.vrp_global:explode(":", value[2])[5]) or 3
			silahHak = not restrictedWeapons[tonumber(exports.vrp_global:explode(":", value[2])[1])] and silahHak or "-"
			guiGridListSetItemText(gridlist42, row, 3, silahHak, false, false)
		end
	end



	onaylaButonu4 = guiCreateButton(0.03, 0.90, 0.45, 0.07, "Ürünü Satın Al", true, window4)
	guiSetFont(onaylaButonu4, "default-bold")

	
	kapatButonu4 = guiCreateButton(0.52, 0.90, 0.45, 0.07, "Arayüzden Çık", true, window4)
	guiSetFont(kapatButonu4, "default-bold")
end
addCommandHandler("market", marketSistemiAC)
addCommandHandler("oocmarket", marketSistemiAC)
local inHeritsResource = {}
addEventHandler("onClientRender", root, 
	function()
		if not isElement(normalWindow) and isElement(imageWindow) then
			destroyElement(imageWindow)
		end
		if getElementData(localPlayer, "marketSistemiAcik") == 1 then

			if isElement(bakiyeMiktari) then guiSetText(bakiyeMiktari,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(bakiyeMiktari2) then guiSetText(bakiyeMiktari2,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(bakiyeMiktari3) then guiSetText(bakiyeMiktari3,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(bakiyeMiktari4) then guiSetText(bakiyeMiktari4,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(bakiyeMiktari5) then guiSetText(bakiyeMiktari5,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(bakiyeMiktari6) then guiSetText(bakiyeMiktari6,  "Bakiye: "..getElementData(localPlayer, "bakiye").." $") end
			if isElement(tab) then
				if guiGetSelectedTab(tab) == window2 then
					if getElementData(previewObject, "alpha") ~= 255 then
						setElementData(previewObject, "alpha", 255)
						setElementAlpha(previewObject, 255)
					end
				else
					setElementData(previewObject, "alpha", 0)
					setElementAlpha(previewObject,0)
				end
			end
			if isElement(plate) then
				if guiCheckBoxGetSelected(plate) then
					guiSetEnabled(plateEdit, true)
				else
					guiSetEnabled(plateEdit, false)
				end
			end
			if isElement(bakiyeEdit) then
				local t = guiGetText(bakiyeEdit)
				
				if tonumber(t) then
					guiSetText(bakiyeDonusecek,"Dönüştürülecek para: $"..exports.vrp_global:formatMoney(tonumber(t)*1000))
				else
					guiSetText(bakiyeDonusecek,"Dönüştürülecek para: $0")
				end
			end
			
			for _, v in ipairs({"gui-scrollpane", "gui-checkbox", "gui-combobox", "gui-label", "gui-gridlist", "gui-radiobutton", "gui-edit", "gui-combobox", "gui-memo", "gui-staticimage"}) do
				for _, element in ipairs(getElementsByType(v,normalWindow)) do
					if not inHeritsResource[element] then
						guiSetProperty(element, "InheritsAlpha", "FF000000")
						if getElementType(element) == "gui-edit" or getElementType(element) == "gui-memo" then
							guiSetProperty(element, "NormalTextColour", "FF000000")
						else
							guiSetProperty(element, "NormalTextColour", "FFFFFFFF")
						end
						guiSetProperty(element, "ActiveSelectionColour", "FF545454")
						guiSetAlpha(element, guiGetAlpha(element))
						guiSetFont(element, "default-bold")

						inHeritsResource[element] = true
					end
				end
			end
			
			
			if isElement(bakiyeCheck) then
				if guiCheckBoxGetSelected(bakiyeCheck) then
					guiSetEnabled(bakiyeDonusturButton, true)
				else
					guiSetEnabled(bakiyeDonusturButton, false)
				end
			end

			if isElement(gridlist2) then
				local selectedVehID = guiGridListGetSelectedItem(gridlist2)
				
				selectedVehID = selectedVehID + 1
				exportedTable = aracListesi[selectedVehID] or false
				if exportedTable then
					guiSetText(infoLabel, "Araç Hızı: "..exportedTable[5].. " km/h * Araç Vergisi: $"..exportedTable[6])
					setElementModel(previewObject, exportedTable[3])

					odencekPara = exportedTable[2]
					if guiCheckBoxGetSelected(plate) then
						odencekPara = odencekPara + 5
					end
					guiSetText(araciSatinAlmaButonu, "Ürünü Satın Al ("..odencekPara.." $)")
				end
			end
		end
	end
)
	
function historySilmeAc()
	historyGUI = guiCreateWindow(0, 0, 299, 116, "History Sildirme (1 Adet : 1 $)", false)
	guiWindowSetSizable(historyGUI, false)
	exports.vrp_global:centerWindow(historyGUI)

	historyAdetEdit = guiCreateEdit(9, 35, 280, 24, "", false, historyGUI)
	addEventHandler("onClientGUIChanged", historyAdetEdit,
		function(edit)
			local text = tonumber(edit.text) or 1
			guiSetText(historyOnayla, "Satın Al ("..text.." $)")
		end
	)
	guiSetProperty(historyAdetEdit, "ValidationString", "^[0-9]*$")
	guiEditSetMaxLength(historyAdetEdit, 6)
	historyIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, historyGUI)
	historyOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al ( 1TL )", false, historyGUI)
end

function camFilmiAC()
	camFilmiGUI = guiCreateWindow(0, 0, 299, 116, "Valhalla * Cam Filmi ( Araç ID Girin )", false)
	guiWindowSetSizable(camFilmiGUI, false)
	exports.vrp_global:centerWindow(camFilmiGUI)

	aracIDCamFilm = guiCreateEdit(9, 35, 280, 24, "", false, camFilmiGUI)
	guiSetProperty(aracIDCamFilm, "ValidationString", "^[0-9]*$")
	guiEditSetMaxLength(aracIDCamFilm, 6)
	camFilmIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, camFilmiGUI)
	camFilmOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al ( 10TL )", false, camFilmiGUI)
end

function kelebekKapiAc()
	kelebekFilmiGUI = guiCreateWindow(0, 0, 299, 116, "Valhalla * Kelebek Kapı ( Araç ID Girin )", false)
	guiWindowSetSizable(kelebekFilmiGUI, false)
	exports.vrp_global:centerWindow(kelebekFilmiGUI)

	aracIDKelebekFilm = guiCreateEdit(9, 35, 280, 24, "", false, kelebekFilmiGUI)
	guiSetProperty(aracIDKelebekFilm, "ValidationString", "^[0-9]*$")
	guiEditSetMaxLength(aracIDKelebekFilm, 6)
	kelebekFilmIptal = guiCreateButton(9, 72, 130, 29, "İptal Et", false, kelebekFilmiGUI)
	kelebekFilmOnayla = guiCreateButton(145, 72, 144, 29, "Satın Al ( 10TL )", false, kelebekFilmiGUI)
end

function plakaDegisikligiAC()
    plakaWINDOW = guiCreateWindow(0.38, 0.37, 0.24, 0.28, "Valhalla * Araç Plaka Değişikliği", true)
    guiWindowSetSizable(plakaWINDOW, false)
	guiSetInputEnabled(true)

    
    plakaAracID = guiCreateLabel(0.04, 0.09, 0.37, 0.07, "Araç ID:", true, plakaWINDOW)
    guiSetFont(plakaAracID, "default-bold")
    plakaAracIDedit = guiCreateEdit(0.04, 0.16, 0.93, 0.13, "", true, plakaWINDOW)
	guiEditSetMaxLength(plakaAracIDedit, 6)
	guiSetProperty(plakaAracIDedit, "ValidationString", "^[0-9]*$")
	
	
    plakaAracWHO = guiCreateLabel(0.04, 0.33, 0.37, 0.07, "Plaka ne olacak?:", true, plakaWINDOW)
    guiSetFont(plakaAracWHO, "default-bold")
    plakaAracYaziEdit = guiCreateEdit(0.04, 0.40, 0.93, 0.12, "", true, plakaWINDOW)
	
	
	
    plakaOnayBOX = guiCreateCheckBox(0.03, 0.69, 0.61, 0.07, "Üstte yazdıklarımı onaylıyorum.", false, true, plakaWINDOW)
	plakaOnayButon = guiCreateButton(0.03, 0.78, 0.46, 0.18, "ONAYLA", true, plakaWINDOW)
	guiSetFont(plakaOnayButon, "default-bold")
	
	plakaKapatButon = guiCreateButton(0.51, 0.78, 0.46, 0.18, "Arayüzden Çık", true, plakaWINDOW)
    guiSetFont(plakaKapatButon, "default-bold")    
end

addEventHandler("onColorPickerOK", root, function(id,hex,r,g,b)
	if isElement(previewObject) then
		setVehicleColor(previewObject, r,g,b)
		rgbTbl = {r,g,b}
		setElementData(localPlayer, "vehDonateColorTable", rgbTbl)
	end
end)

----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function isimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "Valhalla * İsim Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen karakter Ad ve Soyadınızı aşağıdaki kutuya\nşu şekilde yazınız. \"Ad Soyad\"", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
	isimDegistirmeComboBOX1 = guiCreateComboBox(0.17, 0.43, 0.31, 0.25, "Cinsiyet Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Erkek")
    guiComboBoxAddItem(isimDegistirmeComboBOX1, "Bayan")
    isimDegistirmeComboBOX2 = guiCreateComboBox(0.50, 0.43, 0.31, 0.30, "Irk Seçin", true, isimDegistirmeWINDOW)
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Siyahi")
    guiComboBoxAddItem(isimDegistirmeComboBOX2, "Beyaz")
	guiComboBoxAddItem(isimDegistirmeComboBOX2, "Asyalı")
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    isimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeOnaylaBUTON, "default-bold")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "Arayüzden Çık", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold")
end
addEvent("market->isimDegistirmePaneli", true)
addEventHandler("market->isimDegistirmePaneli", root, isimDegistirmePaneli)

function isimDegistirmePanelAC()
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
	triggerEvent("market->isimDegistirmePaneli", localPlayer)
	end
end
addCommandHandler("isimac", isimDegistirmePanelAC)
----------------------------------------------------------------------------------

----------------------------- ISIM DEGISTIRME PANELI -----------------------------
function kisimDegistirmePaneli()
	showCursor(true)
	guiSetInputEnabled(true)
    isimDegistirmeWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "Valhalla * Kullanıcı Adı Değiştirme Paneli", true)
    guiWindowSetSizable(isimDegistirmeWINDOW, false)

    isimDegistirmeUyariYAZI = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Lütfen yeni bir kullanıcı adı belirleyin.", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeUyariYAZI, "default-bold")
    guiLabelSetHorizontalAlign(isimDegistirmeUyariYAZI, "center", false)
    guiLabelSetVerticalAlign(isimDegistirmeUyariYAZI, "center")
    isimDegistirmeEditBOX = guiCreateEdit(0.02, 0.26, 0.96, 0.16, "", true, isimDegistirmeWINDOW)
	
    isimDegistirmeCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Üstteki isimin doğru olduğunu onaylıyorum ve değiştirmek istiyorum.", false, true, isimDegistirmeWINDOW)
    kisimDegistirmeOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, isimDegistirmeWINDOW)
    guiSetFont(kisimDegistirmeOnaylaBUTON, "default-bold")
    isimDegistirmeKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "Arayüzden Çık", true, isimDegistirmeWINDOW)
    guiSetFont(isimDegistirmeKapatBUTON, "default-bold")
end
addEvent("market->kisimDegistirmePaneli", true)
addEventHandler("market->kisimDegistirmePaneli", root, kisimDegistirmePaneli)

function kisimDegistirmePanelAC()
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		triggerEvent("market->kisimDegistirmePaneli", localPlayer)
	end
end
addCommandHandler("kisimac", kisimDegistirmePanelAC)
----------------------------------------------------------------------------------


VIPNUMARA = nil
----------------------------- VIP SATIN ALMA PANEL -----------------------------
function vipSatinAlmaPANEL(vipNumara)
VIPNUMARA = vipNumara
	if getElementData(localPlayer, "vip") == vipNumara or getElementData(localPlayer, "vip") == 0 or not getElementData(localPlayer, "vip") then
	
		setElementData(localPlayer, "vipSatinAlmaPanel", 1)
		showCursor(true)
		guiSetInputEnabled(true)
		
		vipSatinAlmaWINDOW = guiCreateWindow(0.36, 0.37, 0.29, 0.19, "Valhalla * VIP ["..vipNumara.."] Satın Alma Paneli", true)
        guiWindowSetSizable(vipSatinAlmaWINDOW, false)
		
		vipSatinAlmaYazi1 = guiCreateLabel(0.03, 0.15, 0.38, 0.19, "Kaç günlük VIP istiyorsun?", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaYazi1, "default-bold")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi1, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi1, "center")   
        vipSatinAlmaEditBOX = guiCreateEdit(0.43, 0.14, 0.12, 0.20, "", true, vipSatinAlmaWINDOW)
		
        vipSatinAlmaYazi2 = guiCreateLabel(0.02, 0.34, 0.95, 0.18, "* $ karşılığında, * günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?", true, vipSatinAlmaWINDOW)
		
		addEventHandler("onClientRender", root, 
		function()
			if getElementData(localPlayer, "vipSatinAlmaPanel") == 1 then
				local gunSayisi = tonumber(guiGetText(vipSatinAlmaEditBOX))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
				end
				if vipNumara == 1 then
					if gunSayisi ~= nil then
						vipFiyat = 20 / 30 * gunSayisi
					end
				elseif vipNumara == 2 then
					if gunSayisi ~= nil then
						vipFiyat = 40 / 30 * gunSayisi
					end
				elseif vipNumara == 3 then
					if gunSayisi ~= nil then
						vipFiyat = 60 / 30 * gunSayisi
					end
				elseif vipNumara == 4 then
					if gunSayisi ~= nil then
						vipFiyat = 80 / 30 * gunSayisi
					end
				end
				if gunSayisi == nil then
					guiSetText(vipSatinAlmaYazi2, " $ karşılığında, * günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?")
				else
					guiSetText(vipSatinAlmaYazi2, math.ceil(vipFiyat).." $ karşılığında, "..gunSayisi.." günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?")
					--guiSetText(vipSatinAlmaYazi2, math.ceil(vipFiyat).." $ karşılığında, "..math.floor(gunSayisi*1.5).." günlük VIP ["..vipNumara.."] alacaksınız. \nOnaylıyor musunuz?")

				end
			end
		end
		)
		
        guiSetFont(vipSatinAlmaYazi2, "default-bold")
        guiLabelSetHorizontalAlign(vipSatinAlmaYazi2, "center", false)
        guiLabelSetVerticalAlign(vipSatinAlmaYazi2, "center")
        vipSatinAlmaOnaylaBUTON = guiCreateButton(0.02, 0.55, 0.47, 0.38, "ONAYLA", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaOnaylaBUTON, "default-bold")
        vipSatinAlmaKapatBUTON = guiCreateButton(0.51, 0.55, 0.47, 0.38, "Arayüzden Çık", true, vipSatinAlmaWINDOW)
        guiSetFont(vipSatinAlmaKapatBUTON, "default-bold")
	else
		outputChatBox("[!] #ffffffAncak sadece sahip olduğunuz VIP seviyesinin aynısını satın alabilir ve süre uzatabilirsiniz.", 255, 0, 0, true)
	end
end
addEvent("market->vipSatinAlma", true)
addEventHandler("market->vipSatinAlma", root, vipSatinAlmaPANEL)

addEventHandler("onClientGUIChanged", guiRoot, function() 
	if not(source == vipSatinAlmaEditBOX) then return false end
	local text = guiGetText(source) or "" 
	if not tonumber(text) then --if the text isn't a number (statement needed to prevent infinite loop) 
		guiSetText(source, string.gsub(text, "%a", "")) --Remove all letters 
	end
end)


function vipAlmaPanelAC()
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		triggerEvent("market->vipSatinAlma", localPlayer, 3)
	end
end
addCommandHandler("vipac", vipAlmaPanelAC)

function vergiOnayiAc()

	vergiWINDOW = guiCreateWindow(0.35, 0.39, 0.30, 0.24, "Valhalla * Vergi Azaltıcı Onay Paneli", true)
	guiWindowSetSizable(vergiWINDOW, false)

	vergiUyari = guiCreateLabel(0.02, 0.08, 0.97, 0.17, "Aşağıdaki yazıyı işaretledikten sonra satın alma işleminin geri dönüşü olamaz.", true, vergiWINDOW)
	guiSetFont(vergiUyari, "default-bold")
	guiLabelSetHorizontalAlign(vergiUyari, "center", false)
	guiLabelSetVerticalAlign(vergiUyari, "center")

	vergiCheckBOX = guiCreateCheckBox(0.05, 0.67, 0.91, 0.10, "Vergi azaltıcı sistemini gerçekten satın almak istiyorum.", false, true, vergiWINDOW)
	vergiOnaylaBUTON = guiCreateButton(0.02, 0.80, 0.46, 0.12, "ONAYLA", true, vergiWINDOW)
	guiSetFont(vergiOnaylaBUTON, "default-bold")
	vergiKapatBUTON = guiCreateButton(0.51, 0.80, 0.47, 0.12, "Arayüzden Çık", true, vergiWINDOW)
	guiSetFont(vergiKapatBUTON, "default-bold")
end
----------------------------------------------------------------------------------


addEventHandler("onClientGUIClick", guiRoot, function()
	------------------ MARKET ------------------
	if source == onaylaButonu6 then
		local selectedRow = guiGridListGetSelectedItem(gridlist6)
		local selectedRow2 = guiGridListGetSelectedItem(gridlist61)
		local selectedID = tostring(guiGridListGetItemData(gridlist6, selectedRow, 1))
		local selectedID2 = tostring(guiGridListGetItemData(gridlist61, selectedRow2, 1))
		local anims = exports['vrp_animations']:getCustomAnimations()
		if anims[selectedID] then
			local price = anims[selectedID].price
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiye"))
			if bakiyeCek < math.ceil(price) then
				outputChatBox("[!] #ffffff '"..anims[selectedID].name.."' adlı animasyon için bakiyeniz yetersiz.", 255, 0, 0, true)
			return
			end
			triggerServerEvent("market->addCustomAnimation", localPlayer, localPlayer, selectedID, price)
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
		elseif anims[selectedID2] then
			local price = anims[selectedID2].price
			if tonumber(getElementData(localPlayer, "bakiye")) < math.ceil(price) then
				outputChatBox("[!] #ffffffBakiyeniz yetersiz.", 255, 0, 0, true)
			return
			end
			triggerServerEvent("market->addCustomAnimation", localPlayer, localPlayer, selectedID2, price)
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
		else

			outputChatBox("[!] #ffffffHenüz bir animasyon seçmediniz.", 255, 0, 0, true)
		end
	elseif source == gridlist then
		local selectedID = guiGridListGetSelectedItem(gridlist)
		if selectedID == -1 then
			return
		end
		if selectedID == 9 or selectedID == 10 then
			guiSetText(onaylaButonu, "Detayları Görüntüle")
		else
			guiSetText(onaylaButonu, "Ürünü Satın Al")
		end
	elseif source == gridlist or gridlist3 then
		if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end

	elseif source == araciSatinAlmaButonu then

		-- araç satın alma
		local selectedVehID = guiGridListGetSelectedItem(gridlist2)
		
		if selectedVehID == -1 then
			outputChatBox("[!] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
			return false
		end
		selectedVehID = selectedVehID + 1
		exportedTable = aracListesi[selectedVehID] or false	-- vehname, price, model, owlmodel, maxspeed, tax

		if exportedTable then
			bakiye = getElementData(localPlayer, "bakiye")
			alincakMiktar = exportedTable[2]
			if guiCheckBoxGetSelected(plate) then
				plateState = true
				alincakMiktar = alincakMiktar + 5
				if isElement(plateEdit) then
					plateText = guiGetText(plateEdit)
				else
					plateText = ""
				end
			else
				playerteState = false
				alincakMiktar = exportedTable[2]
				plateText = ""
			end

			if bakiye < alincakMiktar then
				outputChatBox("[!] #ffffffYeterli bakiyeniz bulunmadığı için aracı alamazsınız. [ Senin "..alincakMiktar-bakiye.." $'ye daha ihtiyacın var. ]", 255, 0, 0, true)
				return
			end

			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
			
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)

			--fonksiyon çıktısı: player, araçid, owlid, renk, kesilcek bakiye
			rgbTble = getElementData(localPlayer,"vehDonateColorTable")
			triggerServerEvent("market->donateSatinAl", localPlayer, exportedTable[3], exportedTable[4], rgbTble or {255, 255, 255}, alincakMiktar, exportedTable[1], plateState, plateText)
		else
			outputChatBox("[!] #ffffffAlacak bir araba seçmediniz, ayrıca unutmayın alacağınız arabanın rengini ayarlayabilirsiniz.", 255, 0, 0, true)
		end
	elseif source == kapatButonu or source == kapatButonu2 or source == kapatButonu3 or source == kapatButonu4 or source == kapatButonu5 or source == kapatButonu6 then
		destroyElement(normalWindow)
		if isElement(previewObject) then
			destroyElement(previewObject)
			
			if oPrevElement then
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			
		end
		showCursor(false)
		guiSetInputEnabled(false)
		setElementData(localPlayer, "marketSistemiAcik", 0)
	elseif source == vehColorCBox then
		openPicker(1,"FFFFFF","Araç Rengini Ayarlayın")
	elseif source == onaylaButonu6 then
		local siraCek = guiGridListGetSelectedItem(gridlist6)
		local isimCek = guiGridListGetItemText(gridlist6, siraCek, 1)
		local fiyatCek = guiGridListGetItemText(gridlist6, siraCek, 2)
	elseif source == onaylaButonu then
		local siraCek = guiGridListGetSelectedItem(gridlist)
		local isimCek = guiGridListGetItemText(gridlist, siraCek, 1)
		local fiyatCek = guiGridListGetItemText(gridlist, siraCek, 2)
			param = fiyatCek:gsub(" $","")
			if siraCek >= 0 then
				if tonumber(getElementData(localPlayer, "bakiye") or 0) < tonumber(param) then
					outputChatBox("[!]#ffffff '"..isimCek.." için "..param.." $ olması gerekli.",255,0,0,true)
					showCursor(false)
					guiSetInputEnabled(false)
					destroyElement(previewObject)
					destroyElement(normalWindow)
				return false end
			end
		if isimCek == marketListesi[1][2] then --isimDegisikligi
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent("market->isimDegistirmePaneli", localPlayer)
		return false
		elseif isimCek == marketListesi[2][2] then --VIP 1
			triggerEvent("market->vipSatinAlma", localPlayer, 1)
		return false
		elseif isimCek == marketListesi[3][2] then --VIP 2
			triggerEvent("market->vipSatinAlma", localPlayer, 2)
		return false
		elseif isimCek == marketListesi[4][2] then --VIP 3
			triggerEvent("market->vipSatinAlma", localPlayer, 3)
		return false
		elseif isimCek == marketListesi[5][2] then --VIP 4
			triggerEvent("market->vipSatinAlma", localPlayer, 4)
		return false
		elseif isimCek == marketListesi[6][2] then -- Karakter Limit Arttırma
		
			outputChatBox("[!] #ffffffTebrikler, başarıyla "..marketListesi[6][3].." $ karşılığı Karakter Limiti arttırma satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->karakterSlotLOG", localPlayer, marketListesi[6][3])
			return false
		elseif isimCek == marketListesi[7][2] then --Kullanıcı Adı Değişikliği
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent("market->kisimDegistirmePaneli", localPlayer)
			return
		elseif isimCek == marketListesi[8][2] then
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(localPlayer, "marketSistemiAcik", 0)
			plakaDegisikligiAC()
		elseif isimCek == marketListesi[9][2] then--Araç Cam Filmi
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			setElementData(localPlayer, "marketSistemiAcik", 0)
			camFilmiAC()
		elseif isimCek == marketListesi[10][2] then--Neon Sistemi
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent('neon->showList', localPlayer)
		elseif isimCek == marketListesi[11][2] then
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			triggerEvent('vehicletexture->showList', localPlayer)
			return false
		elseif isimCek == marketListesi[12][2] then
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			setElementData(localPlayer, "marketSistemiAcik", 0)
			kelebekKapiAc()
			return false
		elseif isimCek == marketListesi[13][2] then -- Araç Limit Arttırma
			
			outputChatBox("[!] #ffffffTebrikler, başarıyla 5 $ karşılığı Araç Limiti arttırma satın aldınız.", 0, 255, 0, true)
			triggerServerEvent("market->aracSlot", localPlayer, localPlayer, marketListesi[13][3])
			return false
		elseif isimCek == marketListesi[14][2] then
			
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
			end
			
			setElementData(getLocalPlayer(), "marketSistemiAcik", 0)
			historySilmeAc()
		return false

		end
	elseif source == onaylaButonu4 then
		--silah satın alma
		--silahın sıra ID'sini çekme
		if guiGetSelectedTab(tabpanel4) == tab41 then
			local selectedGunID, row = guiGridListGetSelectedItem(gridlist41)
			--eğer row 2 ise silah alma, 3 ise hak ekletme
			if selectedGunID == -1 then
				outputChatBox("[!] #ffffffAlmak ekletmek istediğiniz silahı seçmediniz.", 255, 0, 0, true)
				return
			end

			selectedGunID = selectedGunID + 1 

			gunTable = silahListesi[selectedGunID]

			bakiyeCek = tonumber(getElementData(localPlayer, "bakiye"))
			if bakiyeCek < gunTable[3] then
				outputChatBox("[!] #ffffffBu işlem için "..gunTable[3].." $ bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				return false
			end
			----------------------------
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			----------------------------
			--triggerServerEvent("market->silahSatinAl", localPlayer, localPlayer, gunTable[2], gunTable[3], selectedGunID, row)
			triggerServerEvent("market->silahSatinAl", localPlayer, gunTable[1], gunTable[3])
		else
			local selectedGunID, row = guiGridListGetSelectedItem(gridlist42)
			if selectedGunID == -1 then
				outputChatBox("[!] #ffffffHak ekletmek istediğiniz silahı seçmediniz.", 255, 0, 0, true)
				return
			end
			bakiyeCek = tonumber(getElementData(localPlayer, "bakiye"))
			MONEY = guiGridListGetItemData(gridlist42, selectedGunID, 2) or false
			itemIndex = guiGridListGetItemData(gridlist42, selectedGunID, 1)
			if bakiyeCek < MONEY then
				outputChatBox("[!] #ffffffBu işlem için "..MONEY.." $ bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				return false
			end
			----------------------------
			----------------------------
			destroyElement(normalWindow)
			if isElement(previewObject) then
				destroyElement(previewObject)
				if oPrevElement then
					exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
				end
				
			end
			showCursor(false)
			guiSetInputEnabled(false)
			setElementData(localPlayer, "marketSistemiAcik", 0)
			----------------------------
			triggerServerEvent("market->silahHakEkle", localPlayer, localPlayer, itemIndex, MONEY)
		end

	------------------ ISIM DEGISTIRME PANEL ------------------
	elseif source == isimDegistirmeKapatBUTON then
		destroyElement(isimDegistirmeWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == kisimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[!] #ffffffLütfen bir kullanıcı adı girin.", 255, 0, 0, true)
		return
		end
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			triggerServerEvent( "market->kisimDegistirOnayla", localPlayer, editBOX, marketListesi[7][3])
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
			showCursor(false)
		else
			outputChatBox("[!] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	elseif source == isimDegistirmeOnaylaBUTON then
		local editBOX = tostring(guiGetText(isimDegistirmeEditBOX))
		if editBOX == "" then
			outputChatBox("[!] #ffffffKarakter Ad ve Soyad giriniz.", 255, 0, 0, true)
		return
		end
		local secim1 = guiComboBoxGetSelected(isimDegistirmeComboBOX1)
		local text1 = guiComboBoxGetItemText(isimDegistirmeComboBOX1, secim1)
		
		if text1 == "Cinsiyet Seçin" then
			outputChatBox("[!] #ffffffLütfen Cinsiyet seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		local secim2 = guiComboBoxGetSelected(isimDegistirmeComboBOX2)
		local text2 = guiComboBoxGetItemText(isimDegistirmeComboBOX2, secim2)
		
		if text2 == "Irk Seçin" then
			outputChatBox("[!] #ffffffLütfen Irk seçimi yapınız.", 255, 0, 0, true)
		return
		end
		
		if guiCheckBoxGetSelected(isimDegistirmeCheckBOX) then
			if text1 == "Erkek" then
				setElementData(localPlayer, "gender", 0)
			elseif text1 == "Bayan" then
				setElementData(localPlayer, "gender", 1)
			end
			
			if text2 == "Siyahi" then
				setElementData(localPlayer, "race", 0)
			elseif text2 == "Beyaz" then
				setElementData(localPlayer, "race", 1)
			elseif text2 == "Asyalı" then
				setElementData(localPlayer, "race", 2)
			end
			
			triggerServerEvent( "market->isimDegistirOnayla", localPlayer, editBOX, marketListesi[1][3] )
			destroyElement(isimDegistirmeWINDOW)
			guiSetInputEnabled(false)
			showCursor(false)
		else
			outputChatBox("[!] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	------------------ VIP ALMA PANEL ------------------
	elseif source == vipSatinAlmaKapatBUTON then
		setElementData(localPlayer, "vipSatinAlmaPanel", 0)
		destroyElement(vipSatinAlmaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == vipSatinAlmaOnaylaBUTON then
		--triggerServerEvent("market->vipVer", localPlayer, vipSeviye, vipGun)
		local gunSayisi = math.floor(tonumber(guiGetText(vipSatinAlmaEditBOX)))
				if not gunSayisi or gunSayisi < 0 then
					guiSetText(vipSatinAlmaEditBOX,"")
					gunSayisi = 0
				end
		if VIPNUMARA == 1 then
			if gunSayisi ~= nil then
				vipFiyat = 20 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 2 then
			if gunSayisi ~= nil then
				vipFiyat = 40 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 3 then
			if gunSayisi ~= nil then
				vipFiyat = 60 / 30 * gunSayisi
			end
		elseif VIPNUMARA == 4 then
			if gunSayisi ~= nil then
				vipFiyat = 80 / 30 * gunSayisi
			end
		end
		if VIPNUMARA >= 1 and VIPNUMARA <= 4 then
			local bakiyeCek = tonumber(getElementData(localPlayer, "bakiye"))
			if bakiyeCek < math.ceil(vipFiyat) then
				outputChatBox("[!] #ffffffBu işlem için "..math.ceil(vipFiyat).." $ bakiyeniz olması gerekmektedir.", 255, 0, 0, true)
				showCursor(false)
				guiSetInputEnabled(false)
				destroyElement(vipSatinAlmaWINDOW)
				setElementData(localPlayer, "vipSatinAlmaPanel", 0)
			return false
			end
			if gunSayisi == 0 then
				outputChatBox("[!] #ffffffGün sayısı 0 olamaz.", 255, 0, 0, true)
			return
			end
			
			if gunSayisi < 10 then
				outputChatBox("[!] #ffffffGün sayısı 10'dan küçük olamaz.", 255, 0, 0, true)
			return
			end
			
			setElementData(localPlayer, "vipSatinAlmaPanel", 0)
			triggerServerEvent("market->vipVer", localPlayer, VIPNUMARA, gunSayisi, math.ceil(vipFiyat))
			outputChatBox("[!] #ffffffTebrikler, "..math.ceil(vipFiyat).." $ karşılığında "..gunSayisi.." günlük VIP ["..VIPNUMARA.."] satın aldınız.", 0, 255, 0, true)
			
			--triggerServerEvent("market->vipVer", localPlayer, VIPNUMARA, math.floor(gunSayisi*1.5), math.ceil(vipFiyat))
			--outputChatBox("[!] #ffffffTebrikler, "..math.ceil(vipFiyat).." $ karşılığında "..math.floor(gunSayisi*1.5).." günlük VIP ["..VIPNUMARA.."] satın aldınız.", 0, 255, 0, true)
			showCursor(false)
			guiSetInputEnabled(false)
			destroyElement(vipSatinAlmaWINDOW)
		end
	elseif source == bakiyeDonusturButton then
		bakiyeYaziCek = tonumber(guiGetText(bakiyeEdit))
		if not (bakiyeYaziCek > 0 and bakiyeYaziCek <= 125) then
			outputChatBox("[!] #ffffff1-125 arası sayı girişi yapabilirsiniz.", 255, 0, 0, true)
		return
		end
		if guiCheckBoxGetSelected(bakiyeCheck) == true then
			triggerServerEvent("market->paraDonustur", localPlayer, localPlayer, tonumber(bakiyeYaziCek))
		end
	elseif source == camFilmIptal then
		destroyElement(camFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	
	elseif source == historyIptal then
		destroyElement(historyGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == historyOnayla then
		triggerServerEvent("market->clearHistory", localPlayer, localPlayer, guiGetText(historyAdetEdit))
		destroyElement(historyGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == kelebekFilmIptal then
		destroyElement(kelebekFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif kelebekFilmOnayla then
		local plakaEditBOX = tostring(guiGetText(aracIDKelebekFilm))
		if plakaEditBOX == "" then
			outputChatBox("[!] #ffffffAraç ID kısmını doldurunuz.", 255, 0, 0, true)
			return
		end
		triggerServerEvent("market->kelebekKapi", localPlayer, plakaEditBOX, marketListesi[12][3])
		destroyElement(kelebekFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == camFilmOnayla then
		local plakaEditBOX = tostring(guiGetText(aracIDCamFilm))
		if plakaEditBOX == "" then
			outputChatBox("[!] #ffffffAraç ID kısmını doldurunuz.", 255, 0, 0, true)
			return
		end
		triggerServerEvent("market->camFilm", localPlayer, plakaEditBOX, marketListesi[9][3])
		destroyElement(camFilmiGUI)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == vergiKapatBUTON then
		destroyElement(vergiWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == plakaKapatButon then 
		destroyElement(plakaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif source == plakaOnayButon then
		local plakaEditBOX = tostring(guiGetText(plakaAracIDedit))
		if plakaEditBOX == "" then
			outputChatBox("[!] #ffffffAraç ID kısmını doldurunuz.", 255, 0, 0, true)
		return
		end
		
		local plakaEditBOX2 = tostring(guiGetText(plakaAracYaziEdit))
		if plakaEditBOX2 == "" then
			outputChatBox("[!] #ffffffPlakaya yazılacak yazı kısmını doldurunuz.", 255, 0, 0, true)
		return
		end
		
		if guiCheckBoxGetSelected(plakaOnayBOX) == true then
			local bakiyeCekPlaka = tonumber(getElementData(localPlayer, "bakiye"))
			if bakiyeCekPlaka < 5 then
				outputChatBox("[!] #ffffffBakiye yetersiz.", 255, 0, 0, true)
			return
			end
			destroyElement(plakaWINDOW)
		showCursor(false)
		guiSetInputEnabled(false)
			triggerServerEvent("market->setVehiclePlate", localPlayer, localPlayer, plakaEditBOX2, plakaEditBOX, 5)--buraya
			
		else
			outputChatBox("[!] #ffffffKutucuğu işaretlemeniz gerekmektedir.", 255, 0, 0, true)
		end
	end
	-----------------------------------------------------
end)

function isimnextStage(stage)
	if stage == 1 then
		if isElement(isimDegistirmeWINDOW) then
			destroyElement(isimDegistirmeWINDOW)
		end
		triggerEvent("ulkePaneliniAc", localPlayer)
		showCursor(false)
	end
end
addEvent("market->isimDegistirmeAsama",true)
addEventHandler("market->isimDegistirmeAsama",root,isimnextStage)

addEventHandler("onClientResourceStop", resourceRoot, function()
if isElement(previewObject) then
	destroyElement(previewObject)
	
	if oPrevElement then
		exports["vrp_object_preview"]:destroyObjectPreview(oPrevElement)
	end
	
end
end)




local find = {}
local supportedVehicles = {
 --   ["Blade"] = "http://www.Anadoluroleplay.com/cdn/vehicles/blade.png",
  --  ["Broadway"] = "http://www.Anadoluroleplay.com/cdn/vehicles/broadway.png",
    --["Camper"] = "http://www.Anadoluroleplay.com/cdn/vehicles/camper.png",
  --  ["Elegy"] = "http://www.Anadoluroleplay.com/cdn/vehicles/elegy.png",
  --  ["Flash"] = "http://www.Anadoluroleplay.com/cdn/vehicles/flash.png",
  ---  ["Jester"] = "http://www.Anadoluroleplay.com/cdn/vehicles/jester.png",
  --  ["Remington"] = "http://www.Anadoluroleplay.com/cdn/vehicles/remington.png",
   -- ["Savanna"] = "http://www.Anadoluroleplay.com/cdn/vehicles/savanna.png",
  --  ["Slamvan"] = "http://www.Anadoluroleplay.com/cdn/vehicles/slamvan.png",
   -- ["Sultan"] = "http://www.Anadoluroleplay.com/cdn/vehicles/sultan.png",
   -- ["Tornado"] = "http://www.Anadoluroleplay.com/cdn/vehicles/tornado.png",
   -- ["Uranus"] = "http://www.Anadoluroleplay.com/cdn/vehicles/uranus.png",
}
function find:vehicle(vehicleID)
	for i,v in ipairs(getElementsByType('vehicle')) do
		if (tonumber(v:getData('dbid')) == tonumber(vehicleID)) then
			return v
		end
	end
	return false
end
local function checkLength( value )
	return value and #value >= 0 and #value <= 165
end

local allowedImageHosts = {
	["imgim.com"] = true,
}
local imageExtensions = {
	[".jpg"] = true,
	[".jpeg"] = true,
	[".png"] = true,
}
function verifyImageURL(url)
	if string.find(url, "http://", 1, true) or string.find(url, "https://", 1, true) then
		local domain = url:match("[%w%.]*%.(%w+%.%w+)") or url:match("^%w+://([^/]+)")
		if allowedImageHosts[domain] then
			local _extensions = ""
			for extension, _ in pairs(imageExtensions) do
				if _extensions ~= "" then
					_extensions = _extensions..", "..extension
				else
					_extensions = extension
				end
				if string.find(url, extension, 1, true) then
					return true
				end
			end			
		end
	end
	return false
end
addCommandHandler("arackaplama",
	function(cmd)
		if getElementData(localPlayer, "loggedin") == 1 and localPlayer.vehicle then
			if tonumber(localPlayer.vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid")) then
			
				if #localPlayer.vehicle:getData("textures") > 0 then
					triggerEvent("vehicletexture->showList", localPlayer, localPlayer.vehicle:getData("dbid"))
				end
			end
		end
	end
)
addEvent("vehicletexture->showList", true)
addEventHandler("vehicletexture->showList", root,
    function(vehID)
        if isElement(vehicleTextureGUI) then return end
        vehicleTextureGUI = guiCreateWindow(0, 0, 571, 246, "Araç Kaplama Sistemi * Valhalla", false)
        guiWindowSetSizable(vehicleTextureGUI, false)
		exports.vrp_global:centerWindow(vehicleTextureGUI)
		guiSetInputEnabled(true)
        linkLabel = guiCreateLabel(10, 27, 83, 25, "Kaplama Linki:", false, vehicleTextureGUI)
        guiLabelSetVerticalAlign(linkLabel, "center")
        linkEdit = guiCreateEdit(95, 24, 275, 28, "", false, vehicleTextureGUI)
        linkLabel2 = guiCreateLabel(380, 27, 47, 25, "Araç ID:", false, vehicleTextureGUI)
        guiLabelSetVerticalAlign(linkLabel2, "center")
        vehEdit = guiCreateEdit(432, 24, 129, 28, "", false, vehicleTextureGUI)
        letsTry = guiCreateButton(375, 60, 186, 31, "Hemen Dene", false, vehicleTextureGUI)
        linkLabel3 = guiCreateLabel(98, 65, 267, 20, "Aracında nasıl gözüktüğünü merak mı ediyorsun?", false, vehicleTextureGUI)
        order = guiCreateButton(278, 203, 283, 33, "Satın Al ("..marketListesi[13][3].."TL)", false, vehicleTextureGUI)
        close = guiCreateButton(9, 204, 263, 32, "Arayüzü Arayüzden Çık", false, vehicleTextureGUI)
        linkLabel4 = guiCreateLabel(5, 91, 566, 19, "------------------------------------------------------------------------------------------------------------------------------------------", false, vehicleTextureGUI)
        guiSetFont(linkLabel4, "default-bold")
        linkLabel5 = guiCreateLabel(8, 110, 396, 16, "Kendin mi düzenlemek istiyorsun? Desteklenen araçların linki işte burada:", false, vehicleTextureGUI)
        supportedCombobox = guiCreateComboBox(9, 130, 198, 74, "", false, vehicleTextureGUI)
        for i, v in pairs(supportedVehicles) do
            guiComboBoxAddItem(supportedCombobox, i)
        end
        copyLink = guiCreateButton(217, 126, 205, 27, "Linki Kopyala", false, vehicleTextureGUI)    
		if vehID then
			guiSetEnabled(copyLink, false)
			guiSetEnabled(supportedCombobox, false)
			guiSetEnabled(vehEdit, false)
			vehEdit.text = vehID;
			guiSetEnabled(letsTry, false)
			guiSetText(order, "Değiştir (5TL)")
		end
        addEventHandler("onClientGUIClick", root,
            function(b)
                if (b == "left") then
                    if (source == close) then
                        destroyElement(vehicleTextureGUI)
						guiSetInputEnabled(false)
						if isElement(tempVehicle) then
							destroyElement(tempVehicle)
							if isTimer(tempVehicleTimer) then
								killTimer(tempVehicleTimer)
							end
						end
                    elseif (source == order) then
                        local link, vehID = guiGetText(linkEdit), tonumber(guiGetText(vehEdit))
                        if verifyImageURL(link) then
                            if find:vehicle(vehID) then
                                local vehicle = find:vehicle(vehID);
                                if (tonumber(vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid"))) then
									if isElement(tempVehicle) then
										destroyElement(tempVehicle)
										if isTimer(tempVehicleTimer) then
											killTimer(tempVehicleTimer)
										end
									end
									guiSetInputEnabled(false)
									destroyElement(vehicleTextureGUI)
									local texnames = engineGetModelTextureNames(tostring(vehicle.model))
									for k,v in ipairs(texnames) do
										if string.find(v:lower(), "#") then
											foundedTexture = v
										end
									end
									triggerServerEvent("market->setVehicleTexture", localPlayer, localPlayer, vehID, link, foundedTexture, marketListesi[13][3])
                                else
                                    outputChatBox("[!]#ffffff Araç size ait değil.", 255, 0, 0, true)
                                end
                            else
                                --outputChatBox("[!]#ffffff Araç bulunamadı.", 255, 0, 0, true)
                            end
                        else
                            outputChatBox("[!]#ffffff Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.", 255, 0, 0, true)
                            outputChatBox("[!]#ffffff Desteklenen resim yükleme sunucuları: ", 255, 0, 0, true)
                            for i, v in pairs(allowedImageHosts) do
                                outputChatBox("[!]#ffffff "..i, 255, 0, 0, true)
                            end
                        end
                    elseif (source == letsTry) then
                        local link, vehID = guiGetText(linkEdit), tonumber(guiGetText(vehEdit))
                        if verifyImageURL(link) then
                            if find:vehicle(vehID) then
                                local vehicle = find:vehicle(vehID);
                                if (tonumber(vehicle:getData("owner")) == tonumber(localPlayer:getData("dbid"))) then
									if isTimer(tempVehicleTimer) or isElement(tempVehicle) then outputChatBox("[!]#ffffff Zaten önizlemede bir aracın var, 30 saniye sonra silinecek.", 255, 0, 0, true) return end --killTimer(tempVehicle) end
									local x, y, z = getElementPosition(localPlayer)
									local rx, ry, rz = getElementRotation(localPlayer)
									x = x + ( ( math.cos ( math.rad (  rz ) ) ) * 1.5 )
									y = y + ( ( math.sin ( math.rad (  rz ) ) ) * 1.5 )
									tempVehicle = createVehicle(vehicle.model, x, y, z)
									tempVehicle.frozen = true
									tempVehicle.dimension = localPlayer.dimension
									setElementCollisionsEnabled(tempVehicle, false)
									setVehicleColor(tempVehicle, 255, 255, 255)
									local texnames = engineGetModelTextureNames(tostring(tempVehicle.model))
									for k,v in ipairs(texnames) do
										if string.find(v:lower(), "#") then
											foundedTexture = v
										end
									end
									exports['vrp_item_texture']:addTexture(tempVehicle, foundedTexture, link)
									tempVehicleTimer = Timer(destroyElement, 1000*30, 1, tempVehicle)
                                else
                                    outputChatBox("[!]#ffffff Araç size ait değil.", 255, 0, 0, true)
                                end
                            else
                                outputChatBox("[!]#ffffff Araç bulunamadı.", 255, 0, 0, true)
                            end
                        else
                            outputChatBox("[!]#ffffff Geçersiz bir URL girdiniz veya girdiğiniz site sunucuyu desteklemiyor.", 255, 0, 0, true)
                            outputChatBox("[!]#ffffff Desteklenen resim yükleme sunucuları: ", 255, 0, 0, true)
                            for i, v in pairs(allowedImageHosts) do
                                outputChatBox("[!]#ffffff "..i, 255, 0, 0, true)
                            end
                        end
                    elseif (source == copyLink) then
                        local item = guiComboBoxGetSelected(supportedCombobox)
                        local selectedVehicle = tostring(guiComboBoxGetItemText(supportedCombobox, item))
                        setClipboard(supportedVehicles[selectedVehicle])
                        outputChatBox("[!]#ffffff Resim linki başarıyla panoya kopyalandı.", 0, 255, 0, true)
                    end
                end
            end
        )
	end
)
local birlikDuzenleme = {
    edit = {},
    button = {},
    window = {},
    label = {},
    radiobutton = {}
}

function uncbanPlayer()
	
end

function birlikAdiDuzenle()
	birlikDuzenleme.window[1] = guiCreateWindow(0, 0, 359, 292, "Birliğini Yeniden Adlandır", false)
	guiWindowSetSizable(birlikDuzenleme.window[1], false)
	exports.vrp_global:centerWindow(birlikDuzenleme.window[1])
	local team = getPlayerTeam(localPlayer)
	local teamName = getElementData(team, "name")
	local teamType = getElementData(team, "type")
	if teamType == 0 then
		turAdi = "Çete"
	elseif teamType == 1 then
		turAdi = "Mafya"
	elseif teamType == 6 then
		turAdi = "Haber"
	elseif teamType == 7 then
		turAdi = "Sanayi"
	elseif teamType == 5 then
		turAdi = "Diğer"
	end

	birlikDuzenleme.button[1] = guiCreateButton(184, 251, 165, 31, "Satın Al (10TL)", false, birlikDuzenleme.window[1])
	birlikDuzenleme.button[2] = guiCreateButton(9, 251, 165, 31, "İptal Et", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[1] = guiCreateLabel(170, 46, 14, 177, "|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n|\n", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[1], "center", false)
	birlikDuzenleme.label[2] = guiCreateLabel(26, 29, 111, 17, "Eski Özellikler:", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[2], "center", false)
	birlikDuzenleme.label[3] = guiCreateLabel(213, 29, 111, 17, "Yeni Özellikler:", false, birlikDuzenleme.window[1])
	guiLabelSetHorizontalAlign(birlikDuzenleme.label[3], "center", false)
	birlikDuzenleme.label[4] = guiCreateLabel(10, 59, 150, 36, "Birlik Adı: "..teamName, false, birlikDuzenleme.window[1])
	birlikDuzenleme.edit[1] = guiCreateEdit(190, 75, 159, 21, "", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[5] = guiCreateLabel(189, 53, 160, 17, "Birlik Adı:", false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[6] = guiCreateLabel(10, 105, 150, 36, "Birlik Türü: "..turAdi, false, birlikDuzenleme.window[1])
	birlikDuzenleme.label[7] = guiCreateLabel(189, 106, 160, 17, "Birlik Türü:", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[1] = guiCreateRadioButton(187, 131, 162, 15, "Çete", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[2] = guiCreateRadioButton(187, 152, 162, 17, "Mafya", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[3] = guiCreateRadioButton(187, 175, 162, 17, "Haber", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[4] = guiCreateRadioButton(187, 196, 162, 17, "Sanayi", false, birlikDuzenleme.window[1])
	birlikDuzenleme.radiobutton[5] = guiCreateRadioButton(187, 216, 162, 17, "Diğer", false, birlikDuzenleme.window[1])
	guiRadioButtonSetSelected(birlikDuzenleme.radiobutton[5], true)
	addEventHandler("onClientGUIClick", root, 
		function(b)
			if b == "left" then
				if source == birlikDuzenleme.button[1] then
					if birlikDuzenleme.edit[1].text == "" then
						outputChatBox("[!]#ffffff Birlik adını giriniz.", 255, 0, 0, true)
					return end
					if guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[1]) then
						birlikType = 0
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[2]) then
						birlikType = 1
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[3]) then
						birlikType = 6
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[4]) then
						birlikType = 7
					elseif guiRadioButtonGetSelected(birlikDuzenleme.radiobutton[5]) then
						birlikType = 5
					end
					triggerServerEvent("market->changeFactionSettings", localPlayer, localPlayer, birlikDuzenleme.edit[1].text, birlikType) 
					destroyElement(birlikDuzenleme.window[1])
					showCursor(false)
					guiSetInputEnabled(false)
				elseif source == birlikDuzenleme.button[2] then
					destroyElement(birlikDuzenleme.window[1])
					showCursor(false)
					guiSetInputEnabled(false)
				end
			end
		end
	)
end

settings = {
	[1] = { 
		{"Her maaşta +200$ alır"},
		{"PM Açma/Kapatma özelliği"},
		{"VIP Logosu"},
		{"Mesleklerde her turda +25$"},
		{"Maske Takma Özelliği (Örnek: Gizli #34545)"},
	},
	[2] = {
		{"Her maaşta +300$ alır"},
		{"PM Açma/Kapatma özelliği"},
		{"Hızlı Reklam Vermek AA'ya gitmeden"},
		{"VIP Logosu"},
		{"Mesleklerde her turda +50$"},
		{"Maske Takma Özelliği (Örnek: Gizli #34545)"},
		{"AK-47 marka silahı kullanabilme özelliği"},
	},
	[3] = {
		{"Her maaşta +400$ alır"},
		{"PM Açma/Kapatma özelliği"},
		{"Hızlı Reklam Vermek AA'ya gitmeden."},
		{"VIP Logosu"},
		{"Uygun fiyata mermi satın almak (Yarı Fiyatına %50)"},
		{"Mesleklerde her turda +75"},
		{"Maske Takma Özelliği (Örnek: Gizli #34545)"},
		{"Ücretsiz Tamir Özelliği"},
		{"Ücretsiz /tedaviol Özelliği"},
		{"AK-47 marka silahı kullanabilme özelliği"},
	},
	[4] = {
		{"Her maaşta +500$ alır"},
		{"PM Açma/Kapatma özelliği"},
		{"Hızlı Reklam Vermek AA'ya gitmeden"},
		{"VIP Logosu"},
		{"Uygun fiyata mermi satın almak (%60 Uyguna)"},
		{"Mesleklerde her turda +100$"},
		{"Maske Takma Özelliği (Örnek: Gizli #34545)"},
		{"Sahip olduğunuz araçların vergisi %35 daha az gelmektedir."},
		{"Ücretsiz Tamir Özelliği"},
		{"Ücretsiz /tedaviol Özelliği"},
		{"/onayla yazmadan otomatik saatlik bonus almak."},
		{"AK-47 ve M4 marka silahı kullanabilme özelliği"},
		
	}

}

function vipBilgiPanel()
	if isElement(vipWindow) then destroyElement(vipWindow) return end
	vipWindow = guiCreateWindow(0, 0, 450, 400, "Valhalla * VIP Ozellikleri", false)
	guiWindowSetSizable(vipWindow, false)
	exports.vrp_global:centerWindow(vipWindow)
	tab = guiCreateTabPanel(10,24,690,320,false, vipWindow)
	window = guiCreateTab("VİP-1", tab)
	window2 = guiCreateTab("VİP-2", tab)
	window3 = guiCreateTab("VİP-3", tab)
	window4 = guiCreateTab("VİP-4", tab)
	
	-------------- 1 ------------------
	tab6 = guiCreateTabPanel(10,5,450,290,false,window)
	tab6_1 = guiCreateTab("Özellikler", tab6)
	
	list = guiCreateGridList(10, 10, 450-40-10, 240, false, tab6_1)
	guiGridListSetSortingEnabled(list, false)
	guiGridListAddColumn(list, "İsim", 0.65)
	
	for index, value in pairs(settings[1]) do
		local row = guiGridListAddRow(list)
		guiGridListSetItemText(list, row, 1, value[1], false, false)
	end
	-------------- 2 ------------------
	tab6 = guiCreateTabPanel(10,5,450,290,false,window2)
	tab6_1 = guiCreateTab("Özellikler", tab6)
	
	list = guiCreateGridList(10, 10, 450-40-10, 240, false, tab6_1)
	guiGridListSetSortingEnabled(list, false)
	guiGridListAddColumn(list, "İsim", 0.65)
	
	for index, value in pairs(settings[2]) do
		local row = guiGridListAddRow(list)
		guiGridListSetItemText(list, row, 1, value[1], false, false)
	end
	-------------- 3 ------------------
	tab6 = guiCreateTabPanel(10,5,450,290,false,window3)
	tab6_1 = guiCreateTab("Özellikler", tab6)
	
	list = guiCreateGridList(10, 10, 450-40-10, 240, false, tab6_1)
	guiGridListSetSortingEnabled(list, false)
	guiGridListAddColumn(list, "İsim", 0.65)
	
	for index, value in pairs(settings[3]) do
		local row = guiGridListAddRow(list)
		guiGridListSetItemText(list, row, 1, value[1], false, false)
	end
	-------------- 4 ------------------
	tab6 = guiCreateTabPanel(10,5,450,290,false,window4)
	tab6_1 = guiCreateTab("Özellikler", tab6)
	
	list = guiCreateGridList(10, 10, 450-40-10, 240, false, tab6_1)
	guiGridListSetSortingEnabled(list, false)
	guiGridListAddColumn(list, "İsim", 0.65)
	
	for index, value in pairs(settings[4]) do
		local row = guiGridListAddRow(list)
		guiGridListSetItemText(list, row, 1, value[1], false, false)
	end
	--label6 = guiCreateLabel(0.25, 0.11, 0.24, 0.86, "* Her maaşta +300$ alır.\n* PM Açma/Kapatma özelliği\n* Hızlı Reklam Vermek AA'ya gitmeden.\n* VIP Logosu\n* Mesleklerde her turda +50$\n* Maske Takma Özelliği (Örnek: Gizli #34545)\n* AK-47 marka silahı kullanabilme özelliği", true, vipWindow)
	--label7 = guiCreateLabel(0.50, 0.11, 0.24, 0.86, "* Her maaşta +400$ alır.\n* PM Açma/Kapatma özelliği\n* Hızlı Reklam Vermek AA'ya gitmeden.\n* VIP Logosu\n* Uygun fiyata mermi satın almak (Yarı Fiyatına %50)\n* Mesleklerde her turda +75$\n* Maske Takma Özelliği (Örnek: Gizli #34545)\n* Ücretsiz Tamir Özelliği\n* Ücretsiz /tedaviol Özelliği\n* AK-47 marka silahı kullanabilme özelliği", true, vipWindow)
	--label8 = guiCreateLabel(0.74, 0.11, 0.24, 0.86, "* Her maaşta +500$ alır.\n* PM Açma/Kapatma özelliği\n* Hızlı Reklam Vermek AA'ya gitmeden.\n* VIP Logosu\n* Uygun fiyata mermi satın almak (%60 Uyguna)\n* Mesleklerde her turda +100$\n* Maske Takma Özelliği (Örnek: Gizli #34545)\n* Sahip olduğunuz araçların vergisi %35 daha az gelmektedir.\n* Ücretsiz Tamir Özelliği\n* Ücretsiz /tedaviol Özelliği\n* /onayla yazmadan otomatik saatlik bonus almak.\n* AK-47 ve M4 marka silahı kullanabilme özelliği", true, vipWindow)
	close = guiCreateButton(0, 350, 450, 35, "Arayüzden Çık", false, vipWindow)
	addEventHandler("onClientGUIClick", close, function(b) if (b == "left") then destroyElement(vipWindow) end end)
end
addCommandHandler("vip", vipBilgiPanel)
addCommandHandler("vipbilgi", vipBilgiPanel)

local CKClass = {
	edit = {},
	button = {},
	window = {},
	label = {},
	gridlist = {}
}

function ckActirma()
	if not isElement(CKClass.window[1]) then
		CKClass.window[1] = guiCreateWindow(676, 413, 579, 225, "Karakter Yasaklaması Açtırma", false)
		guiWindowSetSizable(CKClass.window[1], false)
		exports.vrp_global:centerWindow(CKClass.window[1])
		guiSetInputEnabled(true)
		triggerServerEvent("market->receiveInactiveCharacters", localPlayer)
		CKClass.button[1] = guiCreateButton(10, 183, 261, 32, "Arayüzü Arayüzden Çık", false, CKClass.window[1])
		CKClass.button[2] = guiCreateButton(281, 183, 288, 32, "Karakter Yasaklamasını Aç", false, CKClass.window[1])
		CKClass.label[1] = guiCreateLabel(9, 29, 262, 18, "Yasaklı Karakterlerinin Listesi:", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[1], "center", false)
		CKClass.gridlist[1] = guiCreateGridList(9, 53, 262, 120, false, CKClass.window[1])
		guiGridListAddColumn(CKClass.gridlist[1], "Karakter Adı", 0.5)
		guiGridListAddColumn(CKClass.gridlist[1], "Yasaklama Sebebi", 0.5)
		CKClass.label[2] = guiCreateLabel(294, 29, 262, 18, "Seçili Karaktere Göz Atalım:", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[2], "center", false)
		CKClass.label[3] = guiCreateLabel(288, 153, 271, 20, "Ödenecek Tutar: N/A $", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[3], "center", false)
		CKClass.edit[1] = guiCreateEdit(292, 116, 267, 27, "Yeni Karakter Adı", false, CKClass.window[1])
		guiSetEnabled(CKClass.edit[1], false)
		CKClass.label[4] = guiCreateLabel(292, 55, 264, 47, "Karakter yasaklanma admin banı\nise 20TL, rolsel ölüm ise isim\ndeğişikliği ile beraber 30TL alınır.", false, CKClass.window[1])
		guiLabelSetHorizontalAlign(CKClass.label[4], "center", false)
	end
end

addEvent("market->sendInactiveCharacters", true)
addEventHandler("market->sendInactiveCharacters", root,
	function(tbl)
		for i, v in ipairs(tbl) do
			local row = guiGridListAddRow(CKClass.gridlist[1])
			guiGridListSetItemText(CKClass.gridlist[1], row, 1, v.charactername, false, false)
			guiGridListSetItemData(CKClass.gridlist[1], row, 1, v.id, false, false)
			guiGridListSetItemText(CKClass.gridlist[1], row, 2, v.activeDescription, false, false)
			
		end
	end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == closeBrowser) then
				destroyElement(browserWindow)
				guiSetInputEnabled(false)
				showCursor(false)
			elseif (source == CKClass.button[1]) then
				destroyElement(CKClass.window[1])
				guiSetInputEnabled(false)
				showCursor(false)
			elseif (source == CKClass.edit[1]) then
				guiSetText(CKClass.edit[1], "")
			elseif (source == CKClass.button[2]) then
				local row = guiGridListGetSelectedItem( CKClass.gridlist[1])
				if row ~= -1 then
					local name = guiGridListGetItemText( CKClass.gridlist[1], row, 1)
					local charid = guiGridListGetItemData( CKClass.gridlist[1], row, 1)
					local reason = guiGridListGetItemText( CKClass.gridlist[1], row, 2)
					if guiGetEnabled(CKClass.edit[1]) == true then
						editBOX = tostring(guiGetText(CKClass.edit[1]))
						if editBOX == "" then
							outputChatBox("[!] #ffffffLütfen bir karakter adı girin.", 255, 0, 0, true)
						return
						end
					else
						editBOX = false
					end
					destroyElement(CKClass.window[1])
					guiSetInputEnabled(false)
					showCursor(false)


					triggerServerEvent("market->unBanCK", localPlayer, localPlayer, editBOX, charid, reason, name)
				end
			elseif (source == CKClass.gridlist[1]) then
				local row = guiGridListGetSelectedItem( CKClass.gridlist[1])
				if row ~= -1 then
					local name = guiGridListGetItemText( CKClass.gridlist[1], row, 1)
					local reason = guiGridListGetItemText( CKClass.gridlist[1], row, 2)
					if reason == "CK" or reason == "Karakter Ölümü" then
						guiSetEnabled(CKClass.edit[1], true)
						guiSetText(CKClass.label[3], "Ödenecek Tutar: 30 $")
					else
						guiSetEnabled(CKClass.edit[1], false)
						guiSetText(CKClass.label[3], "Ödenecek Tutar: 20 $")
					end
					guiSetText(CKClass.label[2], "Seçili Karaktere Göz Atalım: "..name)
				else
					guiSetEnabled(CKClass.edit[1], false)
					guiSetText(CKClass.label[3], "Ödenecek Tutar: N/A $")
					guiSetText(CKClass.label[2], "Seçili Karaktere Göz Atalım: ")
				end
				guiSetText(CKClass.edit[1], "Karakter Adınızı Girin")
			else
				if isElement(CKClass.edit[1]) then
					guiSetText(CKClass.edit[1], "Karakter Adınızı Girin")
				end
			end
		end
	end
)


function createLogGUI()
	if isElement(window) then destroyElement(window) guiSetInputEnabled(false) removeEventHandler("onClientGUIClick", root, clickElements) end
	window = guiCreateWindow(0, 0, 860, 481, "Valhalla - Marketlog Sistemi", false)
	guiWindowSetSizable(window, false)
	exports.vrp_global:centerWindow(window)
--	guiSetInputEnabled(true)
	triggerServerEvent("receiveMarketLogs", localPlayer, localPlayer, {type=3})
	triggerServerEvent("receiveMarketLogs", localPlayer, localPlayer, {type=2})
	
	tabs = guiCreateTabPanel(9, 24, 841, 402, false, window)

	tab1 = guiCreateTab("Karakter Adından LOG Bulma", tabs)

	grid1 = guiCreateGridList(5, 62, 826, 306, false, tab1)
	label1 = guiCreateLabel(5, 10, 259, 38, "Bu arayüzde istenilen bilgiyi arayın ve listeleyin:", false, tab1)
	guiLabelSetVerticalAlign(label1, "center")
	edit1 = guiCreateEdit(270, 13, 376, 35, "", false, tab1)
	scan1 = guiCreateButton(656, 14, 175, 34, "Tarat", false, tab1)

	-- // Tüm işlemlerin geçmişi //
	tab3 = guiCreateTab("Tüm İşlemlerin Geçmişi", tabs)

	grid3 = guiCreateGridList(5, 12, 826, 356, false, tab3)
	guiGridListAddColumn(grid3, "Accountusername", 0.2)
	guiGridListAddColumn(grid3, "Alınan Ürün", 0.4)
	guiGridListAddColumn(grid3, "Ücret", 0.2)
	guiGridListAddColumn(grid3, "Tarih", 0.9)


	--
	tab2 = guiCreateTab("Tüm Komut Geçmişleri", tabs)


	grid2 = guiCreateGridList(5, 12, 826, 356, false, tab2)


	
	guiGridListAddColumn(grid1, "Tarih", 0.2)
	guiGridListAddColumn(grid1, "Alınan Ürün", 0.2)
	guiGridListAddColumn(grid1, "Ücret", 0.9)
	
	
	guiGridListAddColumn(grid2, "Tarih", 0.2)
	guiGridListAddColumn(grid2, "Olay", 0.6)

	
	

	close = guiCreateButton(9, 437, 841, 34, "Arayüzü Kapat", false, window)

	addEventHandler("onClientGUIClick", root, clickElements)
end

addCommandHandler("bakiyelog",
	function(cmd)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
			createLogGUI()
		end
	end
)

function clickElements(b)
	if (b == "left") then
		if (source == grid1) then
			local row, col = guiGridListGetSelectedItem(grid1)
			if row ~= -1 and col ~= -1 then
				index = guiGridListGetItemText(grid1, row, 1).." "..guiGridListGetItemText(grid1, row, 2)
				setClipboard(index)
				outputConsole("ÜYK: Panoya kopyalandı ("..index..")")
			end
			return
		elseif (source == grid2) then
			local row, col = guiGridListGetSelectedItem(grid2)
			if row ~= -1 and col ~= -1 then
				index = guiGridListGetItemText(grid2, row, 1).." "..guiGridListGetItemText(grid2, row, 2)
				setClipboard(index)
				outputConsole("ÜYK: Panoya kopyalandı ("..index..")")
			end
			return
		elseif (source == close) then
			destroyElement(window)
			guiSetInputEnabled(false)
			removeEventHandler("onClientGUIClick", root, clickElements)
			return
		elseif (source == scan1) then
			--@trigger
			guiSetEnabled(scan1, false)
			triggerServerEvent("receiveMarketLogs", localPlayer, localPlayer, {type=1,edittext=edit1.text})
			return
		
		end
	end
end

addEvent("updateMarketLogGrid", true)
addEventHandler("updateMarketLogGrid", root,
	function(type, zaman)
		if (type == 1) then
			guiSetEnabled(scan1, true)
			grid1:clear()
			for index, value in ipairs(zaman) do
				local row = guiGridListAddRow(grid1)
				guiGridListSetItemText(grid1, row, 2, value.alinanUrun, false, false)
				guiGridListSetItemText(grid1, row, 3, value.ucret, false, false)
				guiGridListSetItemText(grid1, row, 1, value.tarih, false, false)
			end

			setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid1, 100) 
		elseif (type == 2) then
			grid2:clear()
			for i, v in ipairs(zaman) do
				local row = guiGridListAddRow(grid2)
				local text = ""
				if (v.komut == "/bakiyever") then
					text = v.fromusername.." adlı kişi "..v.tousername.." adlı kişiye "..v.miktar.." TL bakiye ekledi."
				elseif (v.komut == "//bakiyeal") then
					text = v.fromusername.." adlı kişi "..v.tousername.." adlı kişinin bakiyesinden "..v.miktar.." TL çıkardı."
				end
				guiGridListSetItemText(grid2, row, 2, text, false, false)
				guiGridListSetItemText(grid2, row, 1, v.zaman, false, false)	
			end
			--setTimer(guiGridListSetVerticalScrollPosition, 50, 1, grid2, 100)
		elseif (type == 3) then
			grid3:clear()
			for i, v in ipairs(zaman) do
				local row = guiGridListAddRow(grid3)
				local text = ""
			
				guiGridListSetItemText(grid3, row, 1, v.accountUsername, false, false)
				guiGridListSetItemText(grid3, row, 2, v.alinanUrun, false, false)
				guiGridListSetItemText(grid3, row, 3, v.ucret, false, false)
				guiGridListSetItemText(grid3, row, 4, v.tarih, false, false)
				

				--guiGridListSetItemText(grid3, row, 1, v.ucret, false, false)	
			end
		end
	end
)