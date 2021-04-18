-- ROTA --
local betonMarker = 0
local betonCreatedMarkers = {}
local betonRota = {
	--{ 2227.8173828125, -2626.603515625, 13.87215423584, false },
{ 2342.490234375, -2051.876953125, 14.341323852539, false }, -- start
{ 2472.2529296875, -2051.7568359375, 25.405910491943, false },
{ 2676.568359375, -2051.5595703125, 16.57963180542, false },
{ 2728.630859375, -2051.4970703125, 14.196690559387, false },
{ 2807.52734375, -2051.6171875, 12.059923171997, false },
{ 2840.2685546875, -2032.9814453125, 11.900426864624, false },
{ 2840.5263671875, -1905.095703125, 11.901624679565, false },
{ 2855.6708984375, -1764.2392578125, 11.836605072021, false },
{ 2896.212890625, -1607.66015625, 11.846076011658, false },
{ 2929.7109375, -1434.3037109375, 11.846299171448, false },
{ 2896.388671875, -1202.1328125, 11.843564987183, false },
{ 2894.525390625, -937.408203125, 11.851331710815, false },
{ 2897.92578125, -593.4501953125, 12.127119064331, false },
{ 2882.2021484375, -531.955078125, 14.62961101532, false },
{ 2752.19921875, -370.123046875, 25.886693954468, false },
{ 2729.328125, -248.66796875, 29.207647323608, false },
{ 2774.6298828125, -84.080078125, 36.718746185303, false },
{ 2775.119140625, 15.5634765625, 34.98405456543, false },
{ 2776.162109375, 195.7109375, 21.22891998291, false },
{ 2578.880859375, 320.298828125, 29.152549743652, false },
{ 2412.4140625, 331.7529296875, 33.63257598877, false },
{ 2281.8056640625, 343.177734375, 33.658977508545, false },
{ 2329.4951171875, 391.8837890625, 28.127105712891, false },
{ 2341.423828125, 344.0654296875, 27.308841705322, false },
{ 2341.1884765625, 291.8759765625, 27.304466247559, false },
{ 2341.1484375, 226.267578125, 27.301816940308, false },
{ 2314.3076171875, 216.4482421875, 26.480110168457, false },
{ 2210.216796875, 229.259765625, 15.543110847473, false },
{ 2097.572265625, 251.6416015625, 21.234920501709, false },
{ 1964.00390625, 355.4931640625, 24.028856277466, false },
{ 1815.435546875, 382.056640625, 19.748586654663, false },
{ 1660.9951171875, 384.775390625, 20.756629943848, false },
{ 1482.388671875, 400.8486328125, 20.852983474731, false },
{ 1288.908203125, 492.91796875, 20.859077453613, false },
{ 1108.3427734375, 578.6474609375, 20.848100662231, false },
{ 1023.5830078125, 491.427734375, 20.854917526245, false },
{ 933.10546875, 376.994140625, 20.851699829102, false },
{ 785.1025390625, 333.0517578125, 20.860103607178, false },
{ 660.5986328125, 314.95703125, 20.849733352661, false },
{ 617.2275390625, 339.5986328125, 20.089292526245, false },
{ 525.498046875, 473.5048828125, 19.905014038086, false },
{ 476.69921875, 539.7255859375, 19.884603500366, false },
{ 415.646484375, 626.2294921875, 19.289714813232, false },
{ 333.63671875, 740.4208984375, 11.225601196289, false },
{ 234.6298828125, 959.419921875, 28.96231842041, false },
{ 267.5380859375, 984.6611328125, 29.164455413818, false },
{ 389.5634765625, 1014.9794921875, 29.430627822876, false },
{ 542.7080078125, 1054.3779296875, 29.398397445679, false },
{ 727.96875, 1105.00390625, 29.411989212036, false },
{ 809.23046875, 1135.8935546875, 29.413652420044, false },
{ 829.6923828125, 1116.7802734375, 30.691274642944, false },
{ 895.666015625, 1002.71484375, 12.795100212097, false },
{ 894.912109375, 905.3271484375, 14.317706108093, false },
{ 809.181640625, 845.6845703125, 10.861570358276, false },
{ 769.6748046875, 887.9453125, -0.30022129416466, false },
{ 744.3583984375, 927.0703125, -6.4498476982117, false },
{ 701.5849609375, 976.5576171875, -10.656717300415, false },
{ 683.037109375, 963.5341796875, -11.705173492432, false },
{ 706.3134765625, 940.31640625, -17.691158294678, false },
{ 725.7978515625, 900.677734375, -22.54628944397, false },
{ 709.1884765625, 901.970703125, -28.518692016602, false },
{ 692.380859375, 933.603515625, -29.257026672363, false },
{ 644.03515625, 949.5146484375, -33.894538879395, false },
{ 621.4228515625, 918.51953125, -41.120304107666, false },
{ 586.267578125, 902.01171875, -43.198040008545, false },
{ 530.9423828125, 905.0986328125, -41.991081237793, false },
{ 498.0478515625, 898.1005859375, -31.001882553101, false },
{ 502.3232421875, 871.064453125, -32.575977325439, false },
{ 550.84765625, 859.14453125, -41.952102661133, false },
{ 597.6044921875, 853.671875, -42.07600402832, false },
{ 636.5380859375, 836.44140625, -41.989551544189, true },   -- yük indir
{ 658.4609375, 854.177734375, -41.988761901855, false },
{ 666.650390625, 894.83984375, -39.4313621521, false },
{ 641.4794921875, 905.0966796875, -41.679798126221, false },
{ 633.1875, 933.8662109375, -37.328067779541, false },
{ 671.6123046875, 942.8505859375, -30.681373596191, false },
{ 704.177734375, 899.84765625, -28.496286392212, false },
{ 730.92578125, 901.255859375, -23.005563735962, false },
{ 697.7998046875, 957.28125, -15.484166145325, false },
{ 706.89453125, 967.494140625, -8.2000427246094, false },
{ 740.7724609375, 921.2900390625, -6.4241671562195, false },
{ 756.3779296875, 890.86328125, -0.25060224533081, false },
{ 776.11328125, 866.5263671875, 2.1175744533539, false },
{ 807.576171875, 840.9150390625, 10.454833984375, false },
{ 901.533203125, 894.5546875, 14.321466445923, false },
{ 902.490234375, 1008.0634765625, 12.8453540802, false },
{ 825.1728515625, 1137.5126953125, 29.97075843811, false },
{ 776.0302734375, 1126.3291015625, 29.294254302979, false },
{ 625.7177734375, 1083.4013671875, 29.316089630127, false },
{ 474.984375, 1043.599609375, 29.306058883667, false },
{ 234.9501953125, 978.583984375, 29.150861740112, false },
{ 230.6982421875, 952.5126953125, 28.803239822388, false },
{ 277.8623046875, 845.8193359375, 19.94540977478, false },
{ 330.9384765625, 730.3583984375, 10.804580688477, false },
{ 389.2626953125, 649.3515625, 15.95866394043, false },
{ 434.9345703125, 589.974609375, 19.893836975098, false },
{ 473.419921875, 535.060546875, 19.881258010864, false },
{ 516.3037109375, 471.68359375, 19.893329620361, false },
{ 564.5791015625, 405.09375, 19.893590927124, false },
{ 616.10546875, 322.0283203125, 20.610523223877, false },
{ 664.6748046875, 308.5234375, 20.853105545044, false },
{ 783.7138671875, 325.9599609375, 20.854465484619, false },
{ 977.9794921875, 395.6591796875, 20.848476409912, false },
{ 1019.1669921875, 464.4013671875, 20.850938796997, false },
{ 1036.4814453125, 500.1845703125, 20.846078872681, false },
{ 1110.771484375, 570.86328125, 20.85245513916, false },
{ 1225.3232421875, 519.646484375, 20.854923248291, false },
{ 1390.5458984375, 435.822265625, 20.847869873047, false },
{ 1509.603515625, 387.29296875, 20.849033355713, false },
{ 1662.123046875, 379.962890625, 20.748167037964, false },
{ 1750.759765625, 383.7958984375, 20.551818847656, false },
{ 1852.044921875, 363.9931640625, 20.413740158081, false },
{ 1982.3955078125, 348.974609375, 26.617116928101, false },
{ 2050.091796875, 262.943359375, 26.104026794434, false },
{ 2163.845703125, 233.87109375, 15.535889625549, false },
{ 2280.314453125, 211.6005859375, 22.019861221313, false },
{ 2329.505859375, 211.2724609375, 27.250537872314, false },
{ 2346.44921875, 260.4306640625, 27.304990768433, false },
{ 2368.689453125, 280.7509765625, 27.721000671387, false },
{ 2446.046875, 298.1015625, 33.280876159668, false },
{ 2563.4619140625, 290.298828125, 31.166963577271, false },
{ 2641.1474609375, 305.4482421875, 39.625885009766, false },
{ 2741.0654296875, 224.5244140625, 29.703657150269, false },
{ 2756.4443359375, 108.71484375, 24.512407302856, false },
{ 2741.1044921875, -133.6787109375, 34.576072692871, false },
{ 2698.4931640625, -262.6279296875, 30.700031280518, false },
{ 2714.8623046875, -365.8935546875, 28.058710098267, false },
{ 2826.322265625, -487.0185546875, 19.221296310425, false },
{ 2869.2197265625, -575.1748046875, 12.922604560852, false },
{ 2873.123046875, -678.3359375, 11.807153701782, false },
{ 2871.7294921875, -815.6572265625, 11.847786903381, false },
{ 2866.263671875, -1026.73046875, 11.847318649292, false },
{ 2874.90625, -1231.38671875, 11.851299285889, false },
{ 2896.1201171875, -1349.521484375, 11.849575996399, false },
{ 2895.6591796875, -1515.0712890625, 11.847499847412, false },
{ 2858.958984375, -1642.7392578125, 11.847455024719, false },
{ 2823.669921875, -1814.5751953125, 11.847554206848, false },
{ 2820.31640625, -1921.046875, 11.910109519958, false },
{ 2820.529296875, -2033.640625, 11.907586097717, false }, --halka1
{ 2799.6669921875, -2115.4658203125, 11.8981590271, false },
{ 2730.775390625, -2152.4111328125, 11.896626472473, false },
{ 2716.6376953125, -2127.548828125, 11.824767112732, false },
{ 2716.6669921875, -2066.548828125, 13.779537200928, false },
{ 2666.9609375, -2046.8876953125, 18.653774261475, false },
{ 2551.1865234375, -2047.1630859375, 26.010684967041, false },
{ 2363.63671875, -2046.548828125, 14.597168922424, false },
{ 2292.9013671875, -2067.2373046875, 14.347728729248, false },
{ 2289.2783203125, -2096.8349609375, 14.496188163757, true, true }, -- bitiş
	
}
-- tek true yük indir, iki true bitiş.

function betonBasla(cmd)
	if not getElementData(getLocalPlayer(), "betonSoforlugu") then
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)
		local kacakciAracModel = 524
		
		if oyuncuAracModel == kacakciAracModel then
			setElementData(getLocalPlayer(), "betonSoforlugu", true)
			updateBetonRota()
			addEventHandler("onClientMarkerHit", resourceRoot, betonRotaMarkerHit)
		end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("betonbasla", betonBasla)

function updateBetonRota()
	betonMarker = betonMarker + 1
	for i,v in ipairs(betonRota) do
		if i == betonMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function betonRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 524 then
				for _, marker in ipairs(betonCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateBetonRota()
						elseif marker[2] == true and marker[3] == true then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitVehicle, true)
							setElementFrozen(hitPlayer, true)
							toggleAllControls(false, true, false)
							betonMarker = 0
							triggerServerEvent("betonparaVer", hitPlayer, hitPlayer)
							outputChatBox("[!] #FFFFFFAracınıza yeni mallar yükleniyor, lütfen bekleyiniz. Eğer devam etmek istemiyorsanız, /betonbitir yazınız.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınıza yeni mallar yüklenmiştir. Gidebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateBetonRota()
								end, 5000, 1, hitPlayer, hitVehicle, source
							)	
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true)
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									outputChatBox("[!] #FFFFFFAracınızdaki mallar indirilmiştir, geri dönebilirsiniz.", 0, 255, 0, true)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)
									toggleAllControls(true)
									updateBetonRota()
								end, 12000, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function betonBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local betonSoforlugu = getElementData(getLocalPlayer(), "betonSoforlugu")
	if pedVeh then
		if pedVehModel == 524 then
			if betonSoforlugu then
				exports.vrp_global:fadeToBlack()
				setElementData(getLocalPlayer(), "betonSoforlugu", false)
				for i,v in ipairs(betonCreatedMarkers) do
					destroyElement(v[1])
				end
				betonCreatedMarkers = {}
				betonMarker = 0
				triggerServerEvent("betonBitir", getLocalPlayer(), getLocalPlayer())
				removeEventHandler("onClientMarkerHit", resourceRoot, betonRotaMarkerHit)
				removeEventHandler("onClientVehicleStartEnter", getRootElement(), betonAntiYabanci)
				setTimer(function() exports.vrp_global:fadeFromBlack() end, 2000, 1)
			end
		end
	end
end
addCommandHandler("betonbitir", betonBitir)

function betonAntiAracTerketme(thePlayer, seat)
	if thePlayer == getLocalPlayer() then
		local theVehicle = source
		if seat == 0 then
			betonBitir()
		end
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), betonAntiAracTerketme)

function betonBlip()
	blip = createBlip(2321.599609375, -2068, 13.546875, 0, 4, 255, 255, 0)  --0 0 1787.1259765625 -1903.591796875 13.394536972046
	exports.vrp_hud:sendBottomNotification(localPlayer, "Beton Taşımacılığı Şoförü", "Haritadaki sarı işarete giderek Beton Taşımacılığı şoförlüğü mesleğinize başlayabilirsiniz.")
end