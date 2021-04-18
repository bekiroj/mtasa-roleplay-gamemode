wheels = {
[1] = { -- // Settings
		distance = 1.2,
		veh = nil,
	},
[2] = { -- // Wheel List
	{1025, "1", 3000},
	{1073, "2",3000},
	{1074, "3",3000},
	{1075, "4",2800},
	{1076, "5",3000},
	{1077, "6",2600},
	{1078, "7",2400},
	{1079, "8",2500},
	{1080, "9",3400},
	{1081, "10",5000},
},
}

local mesaj = "Sipariş Ver"

addEvent("jant:gui", true)
addEventHandler("jant:gui", root,
	function()
		setElementData(localPlayer, "wheel:mechanic", true)
		mechanicGUI = guiCreateWindow(0, 0, 612, 348, "Valhalla - Jant Sistemi ", false)
		guiWindowSetSizable(mechanicGUI, false)
		exports.vrp_global:centerWindow(mechanicGUI)
		gridlist = guiCreateGridList(9, 24, 349, 228, false, mechanicGUI)
		guiGridListAddColumn(gridlist, "Jantlar", 0.6)
		guiGridListAddColumn(gridlist, "Fiyat", 0.2)
		for index, v in ipairs(wheels[2]) do
			local row = guiGridListAddRow(gridlist)
			guiGridListSetItemText(gridlist, row, 1, "Jant (#"..index..")", false, false)
			guiGridListSetItemText(gridlist, row, 2, exports.vrp_global:formatMoney(v[3]).." ", false, false)
			guiGridListSetItemData(gridlist, row, 1, v[2], false, false)
		end
		save = guiCreateButton(10, 267, 590, 33, mesaj, false, mechanicGUI)
		image = guiCreateStaticImage(375, 26, 223, 226, "files/wheels/1.png", false, mechanicGUI)

		close = guiCreateButton(10, 306, 590, 33, "Arayüzü Kapat", false, mechanicGUI)
	end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == close) then
				mesaj = "Sipariş Ver"
				guiSetText(save, mesaj)
				destroyElement(mechanicGUI)
				localPlayer:setData("wheel:mechanic", nil)	
				
			elseif (source == save) then
					if localPlayer:getData("tamirci") ~= 1 then 
						mesaj = "Bunu yapabilmen için bir mekanikçi olman gerekiyor."
						guiSetText(save, mesaj)
						guiSetEnabled(save, false) 
					return end
				local selectedIndex = guiGridListGetSelectedItem(gridlist)
				if selectedIndex ~= -1 then

					if getElementData(localPlayer, "money") < wheels[2][selectedIndex+1][3] then
						outputChatBox("[-]#f9f9f9 Bunu ödeyecek paraya sahip değilsin.",230,30,30,true)
					return end
					veh = getNearByVehicle(localPlayer,2)
					if not veh then
						outputChatBox("[-]#f9f9f9 Jant takmak istediğin aracın lastiğinin yanına yaklaş." ,98, 149, 245,true)
					return end

					triggerServerEvent("mechanic:givewheel", localPlayer, localPlayer,wheels[2][selectedIndex+1][1], veh, wheels[2][selectedIndex+1][3] )
					destroyElement(mechanicGUI)
					localPlayer:setData("wheel:mechanic", nil)
				else
					outputChatBox("[-]#f9f9f9 Bir seçim yapmalısın.", 230, 30, 30, true)
				end
			elseif (source == gridlist) then
				local selectedIndex = guiGridListGetSelectedItem(gridlist)
				if selectedIndex ~= -1 then
					index = tostring(guiGridListGetItemData(gridlist, selectedIndex, 1))
					guiStaticImageLoadImage(image, "files/wheels/"..index..".png")
				end
			end
		end
	end
)

-- getDistanceBetweenPoints3D ( vehicle1x, vehicle1y, vehicle1z, vehicle2x,vehicle2y, vehicle2z )

function drillSound()
   local sound = playSound("files/sounds/drill.mp3")   
   setSoundVolume(sound, 0.5)
end
addEvent("play:drill", true)
addEventHandler("play:drill", getLocalPlayer(), drillSound)


function getNearByVehicle(plr, distance)
	for k,veh in ipairs(getElementsByType("vehicle")) do
		local x,y,z = getElementPosition(veh);
		local x1,y1,z1 = getElementPosition(plr);
		if getDistanceBetweenPoints3D(x,y,z,x1,y1,z1) < distance then
			return veh	
		end
	end
end