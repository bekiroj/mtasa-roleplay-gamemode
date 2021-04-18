spoilers = {
[1] = { -- // Settings
		distance = 5,
		veh = nil,
	},
[2] = { -- // Spoiler List
	{1000, "1", 7500},
	{1001, "2",7500},
	{1002, "3",7500},
	{1003, "4",7500},
	{1014, "5",7500},
	{1015, "6",7500},
	{1016, "7",7500},
	{1023, "8",7500},
	{1049, "9",7500},
	{1050, "10",7500},
	{1058, "11",7500},
	{1060, "12",7500},
	{1138, "13",7500},
	{1139, "14",7500},
	{1146, "15",7500},
	{1147, "16",7500},
	{1158, "17",7500},
	{1162, "18",7500},
	{1163, "19",7500},
},
}

local mesaj = "Sipariş Ver"

addEvent("spoiler:gui", true)
addEventHandler("spoiler:gui", root,
	function()
		setElementData(localPlayer, "spoiler:mechanic", true)
		spoilerGUI = guiCreateWindow(0, 0, 612, 348, "Valhalla - Spoiler Sistemi", false)
		guiWindowSetSizable(spoilerGUI, false)
		exports.vrp_global:centerWindow(spoilerGUI)
		gridlist = guiCreateGridList(9, 24, 349, 228, false, spoilerGUI)
		guiGridListAddColumn(gridlist, "Spoilerler", 0.6)
		guiGridListAddColumn(gridlist, "Fiyat", 0.2)
		for index, v in ipairs(spoilers[2]) do
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, "Spoiler (#"..index..")", false, false)
			guiGridListSetItemText(gridlist, row, 2, exports.vrp_global:formatMoney(v[3]).." ", false, false)
			guiGridListSetItemData(gridlist, row, 1, v[2], false, false)
		end
		saves = guiCreateButton(10, 267, 590, 33, mesaj, false, spoilerGUI)
		spoiresim = guiCreateStaticImage(375, 26, 223, 226, "files/spoilers/1.png", false, spoilerGUI)

		close = guiCreateButton(10, 306, 590, 33, "Arayüzü Kapat", false, spoilerGUI)
	end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == close) then
				mesaj = "Sipariş Ver"
				guiSetText(saves, mesaj)
				destroyElement(spoilerGUI)
				localPlayer:setData("spoiler:mechanic", nil)	
				
			elseif (source == saves) then
					if localPlayer:getData("tamirci") ~= 1 then 
						mesaj = "Bunu yapabilmen için bir mekanikçi olman gerekiyor."
						guiSetText(saves, mesaj)
						guiSetEnabled(saves, false) 
					return end
				local selectedIndex = guiGridListGetSelectedItem(gridlist)
				if selectedIndex ~= -1 then

					if getElementData(localPlayer, "money") < spoilers[2][selectedIndex+1][3] then
						outputChatBox("[-]#f9f9f9 Bunu ödeyecek paraya sahip değilsin.",230,30,30,true)
					return end
					veh = getNearByVehicle(localPlayer,2)
					if not veh then
						outputChatBox("[-]#f9f9f9 Spoiler takmak istediğin aracın bagaj kısmına yaklaş." ,98, 149, 245,true)
					return end

					triggerServerEvent("mechanic:givespoiler", localPlayer, localPlayer,spoilers[2][selectedIndex+1][1], veh, spoilers[2][selectedIndex+1][3] )
					destroyElement(spoilerGUI)
					localPlayer:setData("spoiler:mechanic", nil)
				else
					outputChatBox("[-]#f9f9f9 Bir seçim yapmalısın.", 230, 30, 30, true)
				end
			elseif (source == gridlist) then
				local selectedIndex = guiGridListGetSelectedItem(gridlist)
				if selectedIndex ~= -1 then
					index = tostring(guiGridListGetItemData(gridlist, selectedIndex, 1))
					guiStaticImageLoadImage(spoiresim, "files/spoilers/"..index..".png")
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