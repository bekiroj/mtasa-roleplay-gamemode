kornas = {
	{418, "Korna #1", 1500000},
	{419, "Korna #2", 1500000},
	{420, "Korna #3", 1500000},
	{421, "Korna #4", 1500000},
	{422, "Korna #5", 1500000},
	{423, "Korna #6", 1500000},
}

local mesaj = "Sipariş Ver"

addEvent("korna:gui", true)
addEventHandler("korna:gui", root,
	function()
		setElementData(localPlayer, "korna:mechanic", true)
		kornaGUI = guiCreateWindow(0, 0, 612, 348, "Valhalla - Havalı Korna Sistemi", false)
		guiWindowSetSizable(kornaGUI, false)
		exports.vrp_global:centerWindow(kornaGUI)
		gridlist = guiCreateGridList(9, 24, 349, 228, false, kornaGUI)
		guiGridListAddColumn(gridlist, "Kornalar", 0.6)
		guiGridListAddColumn(gridlist, "Fiyat", 0.23)
		for index, v in ipairs(kornas) do
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, "Havalı Korna (#"..index..")", false, false)
			guiGridListSetItemText(gridlist, row, 2, exports.vrp_global:formatMoney(v[3]).." ", false, false)
		end
		savesd = guiCreateButton(10, 267, 590, 33, mesaj, false, kornaGUI)
		korna = guiCreateStaticImage(375, 26, 223, 226, "korna/main/korna.png", false, kornaGUI)

		close = guiCreateButton(10, 306, 590, 33, "Arayüzü Kapat", false, kornaGUI)
	end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == close) then
				mesaj = "Sipariş Ver"
				guiSetText(savesd, mesaj)
				destroyElement(kornaGUI)
				localPlayer:setData("korna:mechanic", nil)	
				
			elseif (source == savesd) then
					if localPlayer:getData("tamirci") ~= 1 then 
						mesaj = "Bunu yapabilmen için bir mekanikçi olman gerekiyor."
						guiSetText(savesd, mesaj)
						guiSetEnabled(savesd, false) 
					return end
				local selectedIndex = guiGridListGetSelectedItem(gridlist)
				if selectedIndex ~= -1 then

					if getElementData(localPlayer, "money") < kornas[selectedIndex+1][3] then
						outputChatBox("[-]#f9f9f9 Bunu ödeyecek paraya sahip değilsin.",230,30,30,true)
					return end
					veh = getNearByVehicle(localPlayer,2)
					if not veh then
						outputChatBox("[-]#f9f9f9 Korna takmak istediğin aracın direksiyon camı kısmına yaklaş." ,98, 149, 245,true)
					return end

					triggerServerEvent("mechanic:givekorna", localPlayer, localPlayer,kornas[selectedIndex+1][1], veh, kornas[selectedIndex+1][3] )
					destroyElement(kornaGUI)
					localPlayer:setData("korna:mechanic", nil)
				else
					outputChatBox("[-]#f9f9f9 Bir seçim yapmalısın.", 230, 30, 30, true)
				end
			end
		end
	end
)

function getNearByVehicle(plr)
	for k,veh in ipairs(getElementsByType("vehicle")) do
		local x,y,z = getElementPosition(veh);
		local x1,y1,z1 = getElementPosition(plr);
		if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < 3 then
			return veh	
		end
	end
end