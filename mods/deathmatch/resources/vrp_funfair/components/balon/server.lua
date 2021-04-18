local balon = createObject(1928, 393.14453125, -2055.08203125, 12.834819793701)
local startColShape = createColSphere(393.14453125, -2055.08203125, 12.834819793701, 3)
attachElements(startColShape, balon)
local biletColShape = createColSphere(395.861328125, -2079.87890625, 7.8300905227661, 5)
local biletx, bilty, biletz = 395.861328125, -2079.87890625, 7.8300905227661
--local object = 1212
--local balonObject = createPickup(biletx, bilty, biletz, 3, object)
local balonRota = {
{ 394.40625, -2056.94921875, 61.048377990723 },
{ 262.81640625, -2034.5, 74.716415405273 },
{ 7.822265625, -2006.5927734375, 72.476318359375 },
{ -146.0888671875, -1892.2763671875, 64.191200256348 },
{ -75.7900390625, -1728.9404296875, 79.235191345215 },
{ 3.1884765625, -1606.1650390625, 90.367240905762 },
{ 129.6845703125, -1510.154296875, 90.382225036621 },
{ 319.953125, -1398.255859375, 84.298866271973 },
{ 493.7080078125, -1402.5009765625, 74.936103820801 },
{ 669.0458984375, -1401.345703125, 70.803604125977 },
{ 823.310546875, -1399.822265625, 62.831356048584 },
{ 987.53515625, -1400.1923828125, 58.463596343994 },
{ 1082.013671875, -1400.2626953125, 66.23592376709 },
{ 1186.0048828125, -1400.74609375, 76.275688171387 },
{ 1274.5517578125, -1400.4091796875, 81.113227844238 },
{ 1381.755859375, -1405.78125, 91.334053039551 },
{ 1502.4296875, -1430.2509765625, 103.75495147705 },
{ 1615.83984375, -1495.1904296875, 107.26190948486 },
{ 1722.5498046875, -1576.0234375, 101.2013092041 },
{ 1797.37109375, -1678.822265625, 92.932838439941 },
{ 1807.8642578125, -1841.93359375, 92.497009277344 },
{ 1687.6044921875, -2053.412109375, 99.900924682617 },
{ 1477.9443359375, -2201.44921875, 97.933013916016 },
{ 1307.30859375, -2292.3154296875, 94.79141998291 },
{ 1075.736328125, -2337.876953125, 88.437980651855 },
{ 891.3779296875, -2260.017578125, 81.021934509277 },
{ 744.5029296875, -2200.76953125, 68.728530883789 },
{ 607.2861328125, -2148.115234375, 52.390445709229 },
{ 483.6806640625, -2090.28515625, 38.059783935547 },
{ 392.7763671875, -2055.1279296875, 29.750844955444 },
{ 393.4267578125, -2054.126953125, 13.836839675903 },
{ 393.14453125, -2055.08203125, 12.834819793701 },
}

addEventHandler("onColShapeHit", getRootElement(), 
	function(thePlayer, matchingDimension)
		if source == startColShape and matchingDimension then
			if not getElementData(balon, "mesgul") and not getElementData(balon, "isiniyor") then
				if (getElementData(thePlayer, "balonbilet") or 0) > 0 then
					setElementData(thePlayer, "balonbilet", (getElementData(thePlayer, "balonbilet") or 0) - 1)
					outputChatBox("[!] #f0f0f0Balona binmek için bir bilet harcadınız. /balonbasla komutu ile havalanmaya başlayabilirsiniz.", thePlayer, 255, 0, 0, true)
					if getElementData(balon, "isiniyor") then
						outputChatBox("[!] #f0f0f0Balon ısınana kadar bekleyin. Bu işlem 10 saniye sürebilir.", thePlayer, 0, 0, 255, true)
					end
				else
					local x,y,z = getElementPosition(thePlayer)
					exports["vrp_infobox"]:addBox(thePlayer, "error", "Balona binmek için biletiniz yok.")
					setElementPosition(thePlayer, 395.8837890625, -2061.9404296875, 14.747950553894)
					setElementRotation(thePlayer, 0, 0, 0)
					setElementFrozen(thePlayer, true)
					setTimer(setElementFrozen, 500, 1, thePlayer, false)
				end
			end
		end
	end
)


local fire = nil
addCommandHandler("balonbasla", 
	function(thePlayer)
		if isElementWithinColShape(thePlayer, startColShape) then
			if getElementData(balon, "mesgul") then
				outputChatBox("[!] #f0f0f0Balon şu anda meşguldür. Lütfen balonun gelmesini bekleyin.", thePlayer, 255, 0, 0, true)
				return
			end
			setElementData(balon, "mesgul", true)
			local i = 1
			setTimer(
				function()
					if not (i > #balonRota) then
						if i == 1 then
							destroyElement(fire)
							setElementData(balon, "isiniyor", false)
							
							local fire = createObject(3461, 393.1728515625, -2055.0791015625, 17.40701675415)
							attachElements(fire, balon, 0, 0, 8, 0, 180, 0)
							
							outputChatBox("[!] #f0f0f0Balon ısınmıştır, havalanıyorsunuz.", thePlayer, 0, 0, 255, true)
						elseif i == #balonRota then
							setElementData(balon, "mesgul", false)
							destroyElement(fire)
						end
						moveObject(balon, 10000, balonRota[i][1], balonRota[i][2], balonRota[i][3])
						i = i + 1
					end
				end, 10000, #balonRota
			)
			fire = createObject(3461, 393.1728515625, -2055.0791015625, 17.40701675415)
			attachElements(fire, balon, 0, 0, 5, 0, 180, 0)
			setElementData(balon, "isiniyor", true)
			outputChatBox("[!] #f0f0f0Balon ısınana kadar bekleyin. Bu işlem 10 saniye sürebilir.", thePlayer, 0, 0, 255, true)
		end
	end
)

addCommandHandler("biletal",
	function(thePlayer, cmd)
		if isElementWithinColShape(thePlayer, biletColShape) then
			if exports.vrp_global:takeMoney(thePlayer, 10) then
				outputChatBox("[!] #f0f0f0Bir adet bilet satın aldınız. Ücret: 10 TL.", thePlayer, 0, 255, 0, true)
				setElementData(thePlayer, "balonbilet", (getElementData(thePlayer, "balonbilet") or 0 ) + 1)
			else
				outputChatBox("[!] #f0f0f0Yeterli paranız bulunmamaktadır. Ücret: 10 TL.", thePlayer, 255, 0, 0, true)
			end
		end
	end
)