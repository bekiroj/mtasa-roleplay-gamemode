local badguy = createPed(16, 2571.61328125, -2429, 13.632630348206, 312.83770751953, true)
setElementData(badguy, "talk", 1)
setElementData(badguy, "name", "Ramazan Acar")
setElementFrozen(badguy, true)

local Accept = {
	"Bana uyar, ahbap.",
	"Huh, güzel teklif.",
	"Ne zaman başlıyorum?",
}

local Reject = {
	"İşim olmaz, adamım.",
	"Daha önemli işlerim var.",
	"Meşgulüm, ahbap.",
}

function jobDisplayGUI(thePlayer)
	local faction = getPlayerTeam(thePlayer)
	local ftype = getElementData(faction, "type")

	if (ftype) and (ftype < 2) then
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ramazan Acar fısıldar: Hey, elimde bir iş var. Ne dersin, ha?", 255, 255, 255, 3, {}, true)
		acceptGUI(thePlayer)
		return
	else
		triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ramazan Acar diyor ki: Seninle bir işim yok. Derhal toz ol buradan.", 255, 255, 255, 10, {}, true)
		return
	end
end
addEvent("alkol:displayJob", true)
addEventHandler("alkol:displayJob", getRootElement(), jobDisplayGUI)

function acceptGUI(thePlayer)
	local screenW, screenH = guiGetScreenSize()
	local jobWindow = guiCreateWindow((screenW - 308) / 2, (screenH - 102) / 2, 308, 102, "Meslek Görüntüle: Alkol Kaçakçılığı", false)
	guiWindowSetSizable(jobWindow, false)

	local label = guiCreateLabel(9, 26, 289, 19, "İşi kabul ediyor musun?", false, jobWindow)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	
	local acceptBtn = guiCreateButton(9, 55, 142, 33, "Kabul Et", false, jobWindow)
	addEventHandler("onClientGUIClick", acceptBtn, 
		function()
			destroyElement(jobWindow)
			triggerServerEvent("acceptJob", getLocalPlayer(), 9)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "" .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. Accept[math.random(#Accept)], 255, 255, 255, 3, {}, true)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "Ramazan Acar diyor ki: Yandaki kamyonlardan birini alarak işe başla, kamyonlar yüklü ve yola çıkmaya hazır. Bol şanslar, ahbap.", 255, 255, 255, 3, {}, true)
			setTimer(function() outputChatBox("[!] #FFFFFFYandaki beyaz kamyonlardan birini alıp, /alkol basla yazarak işe başlayabilirsiniz!", 0, 0, 255, true) end, 500, 1)
			return	
		end
	)
	
	local line = guiCreateLabel(9, 32, 289, 19, "____________________________________________________", false, jobWindow)
	guiLabelSetHorizontalAlign(line, "center", false)
	guiLabelSetVerticalAlign(line, "center")
	local cancelBtn = guiCreateButton(159, 55, 139, 33, "İptal Et", false, jobWindow)
	addEventHandler("onClientGUIClick", cancelBtn, 
		function()
			destroyElement(jobWindow)
			triggerServerEvent("sendLocalText", getLocalPlayer(), getLocalPlayer(), "" .. getPlayerName(thePlayer):gsub("_", " ") .. " diyor ki: " .. kabulEtmeMsg[math.random(#kabulEtmeMsg)], 255, 255, 255, 3, {}, true)
			return	
		end
	)
end

-- ROTA --
local Marker = 0
local OldMarker = {}
local Routes = {
	{ 2553.3505859375, -2379.1875, 13.685671806335, false },
	{ 2503.0654296875, -2394.2275390625, 13.669926643372, false },
	{ 2463.791015625, -2434.2236328125, 13.669190406799, false },
	{ 2441.119140625, -2447.126953125, 13.668281555176, false },
	{ 2374.025390625, -2386.8076171875, 13.5966796875, false },
	{ 2333.833984375, -2346.033203125, 13.599342346191, false },
	{ 2293.2578125, -2305.640625, 13.593349456787, false },
	{ 2291.2109375, -2287.3203125, 13.597386360168, false },
	{ 2303.615234375, -2262.572265625, 13.591070175171, false },
	{ 2283.046875, -2267.400390625, 13.590983390808, false },
	{ 2194.919921875, -2355.7216796875, 13.591021537781, false },
	{ 2157.447265625, -2479.552734375, 13.591886520386, false },
	{ 2157.876953125, -2563.2763671875, 13.591895103455, false },
	{ 2068.5078125, -2667.8935546875, 13.591411590576, false },
	{ 1992.7646484375, -2668.21484375, 9.665696144104, false },
	{ 1938.5048828125, -2668.171875, 6.5566024780273, false },
	{ 1843.1162109375, -2667.5458984375, 6.0838894844055, false },
	{ 1747.662109375, -2667.5126953125, 6.1109046936035, false },
	{ 1656.521484375, -2667.1875, 6.0841431617737, false },
	{ 1400.4736328125, -2655.5390625, 13.591164588928, false },
	{ 1350.005859375, -2580.8173828125, 13.590746879578, false },
	{ 1348.28515625, -2495.5673828125, 13.590776443481, false },
	{ 1348.3349609375, -2411.376953125, 13.591401100159, false },
	{ 1348.4912109375, -2352.3818359375, 13.591487884521, false },
	{ 1349.41015625, -2282.1474609375, 13.606894493103, false },
	{ 1350.2197265625, -2222.1259765625, 13.599197387695, false },
	{ 1398.6044921875, -2146.998046875, 13.599312782288, false },
	{ 1510.2822265625, -2134.060546875, 14.13081073761, false },
	{ 1624.1953125, -2088.404296875, 20.053632736206, false },
	{ 1670.421875, -2002.1318359375, 23.641843795776, false },
	{ 1656.1240234375, -1912.8984375, 24.840379714966, false },
	{ 1614.1689453125, -1702.9228515625, 28.472721099854, false },
	{ 1612.8984375, -1562.8779296875, 28.802350997925, false },
	{ 1613.400390625, -1425.8505859375, 28.801507949829, false },
	{ 1620.287109375, -1333.099609375, 31.950277328491, false },
	{ 1635.900390625, -1219.5029296875, 51.776596069336, false },
	{ 1647.9619140625, -1133.7080078125, 58.523208618164, false },
	{ 1673.3203125, -971.349609375, 62.984867095947, false },
	{ 1696.62890625, -818.416015625, 57.074768066406, false },
	{ 1716.7080078125, -672.40625, 44.176921844482, false },
	{ 1717.6689453125, -522.84765625, 34.760738372803, false },
	{ 1696.5302734375, -411.306640625, 35.554481506348, false },
	{ 1681.9892578125, -323.849609375, 45.253086090088, false },
	{ 1677.294921875, -131.033203125, 36.49536895752, false },
	{ 1654.0751953125, -23.8515625, 36.725471496582, false },
	{ 1623.357421875, 112.0087890625, 37.236186981201, false },
	{ 1639.494140625, 181.8115234375, 33.438697814941, false },
	{ 1660.2353515625, 263.8701171875, 30.208274841309, false },
	{ 1688.634765625, 345.62890625, 30.284063339233, false },
	{ 1727.482421875, 456.4345703125, 30.890739440918, false },
	{ 1754.34765625, 526.1376953125, 27.689575195313, false },
	{ 1771.115234375, 579.232421875, 24.03247833252, false },
	{ 1802.5234375, 713.6787109375, 14.66579246521, false },
	{ 1809.623046875, 816.3037109375, 11.024002075195, false },
	{ 1803.482421875, 843.1083984375, 10.865094184875, false },
	{ 1758.4853515625, 855.3173828125, 10.26886844635, false },
	{ 1590.3388671875, 855.669921875, 6.9500527381897, false },
	{ 1481.8349609375, 855.0439453125, 7.0284280776978, false },
	{ 1376.9697265625, 860.1328125, 7.0282311439514, false },
	{ 1325.5908203125, 880.0146484375, 7.0282731056213, false },
	{ 1282.513671875, 913.4052734375, 7.0276160240173, false },
	{ 1241.849609375, 978.046875, 7.0285582542419, false },
	{ 1229.6083984375, 1113.7744140625, 7.0280385017395, false },
	{ 1229.62109375, 1171.47265625, 7.0356984138489, false },
	{ 1230.1630859375, 1306.7158203125, 6.9583463668823, false },
	{ 1229.6591796875, 1487.970703125, 6.9503569602966, false },
	{ 1229.5546875, 1637.0009765625, 6.9505848884583, false },
	{ 1249.31640625, 1708.3935546875, 7.0172305107117, false },
	{ 1293.7158203125, 1773.95703125, 10.591606140137, false },
	{ 1299.447265625, 1799.5751953125, 10.866620063782, false },
	{ 1284.828125, 1815.8203125, 10.877407073975, false },
	{ 1196.9345703125, 1815.6298828125, 13.575112342834, false },
	{ 1152.400390625, 1815.806640625, 10.888875007629, false },
	{ 1088.5263671875, 1815.5908203125, 10.888389587402, false },
	{ 1021.9794921875, 1815.35546875, 10.887842178345, false },
	{ 1009.740234375, 1834.1181640625, 10.887022018433, false },
	{ 1009.6298828125, 1937.6689453125, 10.887872695923, false },
	{ 1009.654296875, 2005.2470703125, 10.888219833374, false },
	{ 1009.7509765625, 2038.3076171875, 10.888193130493, false },
	{ 1009.6923828125, 2114.3154296875, 10.888027191162, false },
	{ 997.7265625, 2133.3203125, 11.037672042847, false },
	{ 981.6357421875, 2133.275390625, 11.037453651428, false },
	{ 978.8994140625, 2116.95703125, 11.035297393799, false },
	
	{ 978.677734375, 2096.033203125, 11.036551475525, true, false },
	
	{ 986.73046875, 2081.8505859375, 11.036367416382, false },
	{ 992.0771484375, 2100.1640625, 11.037192344666, false },
	{ 991.775390625, 2117.5703125, 11.036954879761, false },
	{ 1005.3876953125, 2115.466796875, 10.888833045959, false },
	{ 1005.361328125, 2068.1669921875, 10.89425945282, false },
	{ 1005.03125, 2009.779296875, 10.888617515564, false },
	{ 1005.00390625, 1969.263671875, 10.887773513794, false },
	{ 1005.123046875, 1867.529296875, 10.887434005737, false },
	{ 1005.1787109375, 1828.5322265625, 10.888028144836, false },
	{ 1017.9609375, 1810.6875, 10.929194450378, false },
	{ 1120.6533203125, 1811.05859375, 10.888703346252, false },
	{ 1147.56640625, 1761.7041015625, 10.223931312561, false },
	{ 1200.8896484375, 1674.9208984375, 6.9655790328979, false },
	{ 1205.9267578125, 1509.681640625, 6.9583010673523, false },
	{ 1205.06640625, 1323.2138671875, 6.9507851600647, false },
	{ 1205.533203125, 1113.55859375, 7.0332703590393, false },
	{ 1221.32421875, 962.09765625, 7.0296401977539, false },
	{ 1319.2216796875, 855.5361328125, 7.0424437522888, false },
	{ 1448.8408203125, 830.701171875, 7.0361800193787, false },
	{ 1538.1904296875, 830.310546875, 7.0321536064148, false },
	{ 1703.8212890625, 831.751953125, 8.4788770675659, false },
	{ 1767.5517578125, 831.8544921875, 10.571459770203, false },
	{ 1784.6689453125, 799.7841796875, 11.36337852478, false },
	{ 1774.0234375, 694.76171875, 16.024150848389, false },
	{ 1747.228515625, 587.9912109375, 23.941627502441, false },
	{ 1729.2646484375, 534.32421875, 27.701953887939, false },
	{ 1717.994140625, 502.107421875, 29.516632080078, false },
	{ 1668.658203125, 356.2119140625, 30.45799446106, false },
	{ 1640.1943359375, 263.7314453125, 30.334131240845, false },
	{ 1621.3115234375, 191.8642578125, 33.231594085693, false },
	{ 1601.4267578125, 108.3330078125, 37.689434051514, false },
	{ 1616.1181640625, 10.4677734375, 37.013683319092, false },
	{ 1654.091796875, -117.8232421875, 35.245311737061, false },
	{ 1659.939453125, -322.568359375, 40.513187408447, false },
	{ 1688.763671875, -467.255859375, 33.38289642334, false },
	{ 1701.8837890625, -594.763671875, 38.264812469482, false },
	{ 1695.7646484375, -680.9599609375, 45.182399749756, false },
	{ 1686.0634765625, -747.6748046875, 51.82837677002, false },
	{ 1669.7998046875, -839.92578125, 58.881423950195, false },
	{ 1650.3720703125, -968.1259765625, 62.921455383301, false },
	{ 1622.9423828125, -1151.1220703125, 57.151977539063, false },
	{ 1608.4853515625, -1267.7001953125, 45.108173370361, false },
	{ 1590.611328125, -1380.65625, 28.797309875488, false },
	{ 1589.5390625, -1471.3671875, 28.801954269409, false },
	{ 1589.609375, -1589.9677734375, 28.80230140686, false },
	{ 1593.6435546875, -1734.6337890625, 28.156415939331, false },
	{ 1621.72265625, -1873.013671875, 25.506885528564, false },
	{ 1651.4716796875, -1992.96875, 23.834579467773, false },
	{ 1603.71484375, -2079.1181640625, 19.453441619873, false },
	{ 1466.12109375, -2113.908203125, 13.614544868469, false },
	{ 1371.0908203125, -2141.5029296875, 13.598910331726, false },
	{ 1329.8408203125, -2224.7666015625, 13.599459648132, false },
	{ 1329.09765625, -2279.666015625, 13.604933738708, false },
	{ 1328.8623046875, -2348.2314453125, 13.59083366394, false },
	{ 1329.341796875, -2424.9296875, 13.594923973083, false },
	{ 1328.96875, -2551.779296875, 13.591382026672, false },
	{ 1357.677734375, -2647.3984375, 13.591364860535, false },
	{ 1487.8251953125, -2687.4033203125, 11.169103622437, false },
	{ 1656.1708984375, -2687.73828125, 6.0836005210876, false },
	{ 1846.4599609375, -2688.3349609375, 6.0835790634155, false },
	{ 1927.171875, -2687.8798828125, 6.166540145874, false },
	{ 2051.6572265625, -2687.14453125, 13.047265052795, false },
	{ 2136.34375, -2660.275390625, 13.592041015625, false },
	{ 2177.2919921875, -2581.8740234375, 13.596471786499, false },
	{ 2178.33203125, -2509.955078125, 13.593168258667, false },
	{ 2184.013671875, -2417.3310546875, 13.590664863586, false },
	{ 2237.419921875, -2341.9375, 13.591251373291, false },
	{ 2271.5869140625, -2307.4150390625, 13.590708732605, false },
	{ 2309.6748046875, -2330.552734375, 13.599245071411, false },
	{ 2377.494140625, -2397.796875, 13.596754074097, false },
	{ 2424.255859375, -2444.8623046875, 13.6686668396, false },
	{ 2446.203125, -2452.2802734375, 13.676085472107, false },
	{ 2477.439453125, -2427.283203125, 13.664783477783, false },
	{ 2520.7421875, -2383.701171875, 13.669543266296, false },
	{ 2541.1328125, -2377.61328125, 13.668137550354, false },
	{ 2575.65234375, -2408.921875, 13.685085296631, false },
	{ 2594.01171875, -2426.669921875, 13.68165397644, true, true }
}

function startJob(cmd, arg)
	if arg == "basla" then
		if not alcoholBlip then--not routeMarker then
			local faction = getPlayerTeam(getLocalPlayer())
			local factionType = getElementData(faction, "type")
			local veh = getPedOccupiedVehicle(getLocalPlayer())
			local vehModel = getElementModel(veh)
			local jobVehicle = 456
			
			if (factionType == 0) or (factionType == 1) then
				if vehModel == jobVehicle then
					updateRoutes()
					alcoholBlip = createBlip(2553.3505, -2379.1875, 13.6856, 0, 3, 255, 0, 0, 255)
					addEventHandler("onClientMarkerHit", resourceRoot, RoutesMarkerHit)
				end
			end
		else
			exports.vrp_hud:sendBottomNotification(localPlayer, "Alkol Kaçakçılığı", "Zaten bir sefere başladın.")
		end
	end
end
addCommandHandler("alkol", startJob)

function updateRoutes()
	Marker = Marker + 1

	for i,v in ipairs(Routes) do
		if i == Marker then
			if not v[4] == true then
				routeMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				if alcoholBlip then
					setElementPosition(alcoholBlip, v[1], v[2], v[3])
					setBlipColor(alcoholBlip, 255, 0, 0, 255)
				end
				table.insert(OldMarker, { routeMarker, false })
			elseif v[4] == true and v[5] == true then 
				fMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				destroyElement(alcoholBlip)
				table.insert(OldMarker, { fMarker, true, true })	
			elseif v[4] == true then
				pMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				setElementPosition(alcoholBlip, v[1], v[2], v[3])
				setBlipColor(alcoholBlip, 255, 255, 0, 255)
				table.insert(OldMarker, { pMarker, true, false })			
			end
		end
	end
end

function RoutesMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 456 then
				for _, marker in ipairs(OldMarker) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateRoutes()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							Marker = 0
							triggerServerEvent("alcohol:pay", hitPlayer, hitPlayer)
							outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateRoutes()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									updateRoutes()
								end, 1000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function cancelJob()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	if pedVeh then
		if pedVehModel == 456 then
			exports.vrp_global:fadeToBlack()
			for i,v in ipairs(OldMarker) do
				destroyElement(v[1])
			end
			OldMarker = {}
			Marker = 0
			if alcoholBlip then
				destroyElement(alcoholBlip)
				alcoholBlip = nil
			end
			-- triggerServerEvent("alcohol:exitVeh", getLocalPlayer(), getLocalPlayer())
			removeEventHandler("onClientMarkerHit", resourceRoot, RoutesMarkerHit)
			removeEventHandler("onClientVehicleStartEnter", getRootElement(), ickiAntiYabanci)
			setTimer(function() exports.vrp_global:fadeFromBlack() end, 2000, 1)
		end
	end
end

function cantExit(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			cancelJob()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), cantExit)