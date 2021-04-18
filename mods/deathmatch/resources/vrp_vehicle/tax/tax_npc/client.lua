function VergiGUI(Data)
	if not source then
		source = getLocalPlayer()
	end
	local screenW, screenH = guiGetScreenSize()
	local scaleW, scaleH = (screenW/1366), (screenH/768)
    vergiPanelWindow = guiCreateWindow(scaleW * 426, scaleH * 205, scaleW * 513, scaleH * 359, "Valhalla - Araç Vergi Sistemi", false)
    guiWindowSetSizable(vergiPanelWindow, false)
    vergiPanelGrid = guiCreateGridList(scaleW * 10, scaleH * 28, scaleW * 493, scaleH * 220, false, vergiPanelWindow)
    guiGridListAddColumn(vergiPanelGrid, "ID", 0.1)
    guiGridListAddColumn(vergiPanelGrid, "", 0.5)
    guiGridListAddColumn(vergiPanelGrid, "Vergi Borcu", 0.36)
	for i, data in ipairs(Data) do
		local row = guiGridListAddRow(vergiPanelGrid)
		guiGridListSetItemText(vergiPanelGrid, row, 1, data[1], false, true)
		guiGridListSetItemText(vergiPanelGrid, row, 2, data[2],  false, false)
		guiGridListSetItemText(vergiPanelGrid, row, 3, "$" .. exports.vrp_global:formatMoney(data[3]), false, false)
	end
    miktarLbl = guiCreateLabel(scaleW * 10, scaleH * 258, scaleW * 107, scaleH * 26, "Ödenecek Miktar:", false, vergiPanelWindow)
    guiLabelSetVerticalAlign(miktarLbl, "center")
    miktarEdit = guiCreateEdit(scaleW * 117, scaleH * 258, scaleW * 386, scaleH * 26, "", false, vergiPanelWindow)
    kapatBtn = guiCreateButton(scaleW * 10, scaleH * 294, scaleW * 245, scaleH * 50, "Kapat", false, vergiPanelWindow)
    odeBtn = guiCreateButton(scaleW * 265, scaleH * 294, scaleW * 238, scaleH * 50, "Borcu Öde", false, vergiPanelWindow)    
	addEventHandler("onClientGUIClick", guiRoot, 
		function() 
			if source == odeBtn then
				local miktar = guiGetText(miktarEdit) 
				miktar = tonumber(miktar)
				if miktar == 0 or miktar < 0 then 
					outputChatBox("[!] #f0f0f0Ödeyeceğiniz miktar en az $0 olmalıdır.", 255, 0, 0, true) 
					return
				end 
				local row, col = guiGridListGetSelectedItem(vergiPanelGrid)
				if row == -1 then
					outputChatBox("[!] #f0f0f0Lütfen listeden bir araç seçin.", 255, 0, 0, true)
					return
				end
				local aracID = guiGridListGetItemText(vergiPanelGrid, row, 1)
				destroyElement(vergiPanelWindow)
				triggerServerEvent("vergi:VergiOde", getLocalPlayer(), aracID, miktar)
			elseif source == kapatBtn then
				destroyElement(vergiPanelWindow)
			end
		end
	)
end
addEvent("vergi:VergiGUI", true)
addEventHandler("vergi:VergiGUI", getRootElement(), VergiGUI)

