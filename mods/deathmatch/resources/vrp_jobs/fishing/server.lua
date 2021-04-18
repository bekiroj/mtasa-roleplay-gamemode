local fishingList = {
	--example:
	--{name = "name", price = 50},
	{name = "Alabalık", price = 35},
	{name = "Sudak Balığı", price = 20},
	{name = "Dağ Alabalığı", price = 20},
	{name = "Deniz Alabalığı", price = 20},
	{name = "Snapper Balığı", price = 20},
	{name = "Cabak Balığı", price = 20},
	{name = "Butter Balığı", price = 20},
	{name = "Ton Balığı", price = 20},
	{name = "Kılıç Balığı", price = 20},
	{name = "Kalamar Balığı", price = 20},
	{name = "Ringa Balığı", price = 35},
	{name = "Cipura Balığı", price = 20},
	{name = "Gökkuşağı Balığı", price = 20},
	{name = "Siyah Cod Balığı", price = 20},
	{name = "Beyaz Seabass Balığı", price = 20},
	{name = "Göl Alabalığı", price = 20},
	{name = "Sazan Balığı", price = 20},
	{name = "Monk Balığı", price = 20},
	{name = "Beyaz Bass Balığı", price = 20},
	{name = "Benekli Bass Balığı", price = 20},
	{name = "Altın Balığı", price = 20},
	{name = "Dere Alabalığı", price = 20},
}

local yemx, yemy, yemz = 356.5810546875, -2026.201171875, 7.8359375
local pickup = createPickup(yemx,yemy,yemz, 3,1239)
setElementData(pickup,"informationicon:information","Balık sistemi arayüzünü açmak için /balik komutunu kullanın.")
local yemCol = createColSphere(yemx, yemy, yemz, 2)
local balikCol = createColPolygon(360.2646484375, -2047.708984375, 349.84375, -2047.708984375, 349.8466796875, -2088.7978515625, 409.24609375, -2088.7978515625, 409.25390625, -2047.7099609375, 399.392578125, -2047.7099609375, 399.513671875, -2048.248046875, 408.4306640625, -2048.2607421875, 408.322265625, -2087.6474609375, 350.8984375, -2087.5585937, 350.7744140625, -2048.453125, 360.427734375, -2048.681640625, 360.2431640625, -2047.709960937)

addEventHandler("onPickupHit", root,
	function()
		cancelEvent()
	end
)

addCommandHandler("balik",
	function(player, cmd)
		if isElementWithinColShape(player, yemCol) then
			triggerClientEvent(player, "fisher->active", player, player)
		end
	end
)

addCommandHandler("baliktut", 
	function(thePlayer, cmd)
		if isElementWithinColShape(thePlayer, balikCol) then
			if (not getElementData(thePlayer, "balikTutuyor")) then
				local toplamyem = getElementData(thePlayer, "toplamyem") or 0
				if toplamyem > 0 then
					--triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
					exports.vrp_global:applyAnimation(thePlayer, "SWORD", "sword_IDLE", -1, false, true, true, false)
					setElementData(thePlayer, "balikTutuyor", true)
					exports.vrp_global:sendLocalMeAction(thePlayer, "oltasını denize doğru sallar.", false, true)
					outputChatBox("[!] #ffffffBalık tutuyorsunuz, lütfen bekleyin!", thePlayer, 10, 10, 255, true)
					setElementData(thePlayer, "toplamyem", toplamyem - 1)
					setTimer(function(thePlayer) 
						local rastgeleSayi = math.random(1, 3)
						if rastgeleSayi == 2 then
							local givenFishIndex = math.random(1, #fishingList)
							local givenFishTable = fishingList[givenFishIndex]
							
							exports["vrp_items"]:giveItem(thePlayer, 273, givenFishTable.name)
							outputChatBox("[!] #ffffffTebrikler, bir adet "..(givenFishTable.name).." balığı tuttunuz!", thePlayer, 0, 255, 0, true)
						else
							outputChatBox("[!] #ffffffMalesef, balık tutamadınız.", thePlayer,255,255,0, true)
						end
						exports.vrp_global:removeAnimation(thePlayer)
						--triggerEvent("artifacts:toggle", thePlayer, thePlayer, "rod")
						setElementData(thePlayer, "balikTutuyor", false)
					end, 20000, 1, thePlayer)
				else
					outputChatBox("[!] #ffffffMalesef, üzerinizde yem kalmadı.", thePlayer,255,255,0, true)
				end
			end
		end
		end
)


addCommandHandler("balikdurum", 
	function(thePlayer, cmd)
		local yem = getElementData(thePlayer, "toplamyem") or 0
		--local balik = getElementData(thePlayer, "toplambalik") or 0
		local toplamBalik = exports["vrp_items"]:countItems(thePlayer, 273)
		outputChatBox("-----------------------------------------", thePlayer,255,255,0)
		outputChatBox("==> Toplam Balık: " .. tostring(toplamBalik), thePlayer, 255, 240, 240)
		outputChatBox("==> Toplam Yem: " .. tostring(yem), thePlayer, 255, 240, 240)
		outputChatBox("-----------------------------------------", thePlayer,255,255,0)
	end
)

function yemAl(thePlayer, cmd)
	local para = exports.vrp_global:getMoney(thePlayer)
	if para >= 1 then
		if isElementWithinColShape(thePlayer, yemCol) then
			local toplamyem = getElementData(thePlayer, "toplamyem") or 0
			if toplamyem >= 20 then
				outputChatBox("[!] #ffffffMalesef, daha fazla yem alamazsınız.", thePlayer,255,255,0, true)
				return
			elseif toplamyem <= 20 then
				exports.vrp_global:takeMoney(thePlayer, 1)
				if (toplamyem + 10) <= 20 then
					setElementData(thePlayer, "toplamyem", toplamyem + 10)
					outputChatBox("[!] #ffffff10 Adet yem aldınız.", thePlayer, 10, 10, 255, true)
				elseif (toplamyem + 10) >= 20 then
					alinamayanYem = toplamyem + 10 - 20
					alinanYem = 10 - alinamayanYem
					setElementData(thePlayer, "toplamyem", 20)
					outputChatBox("[!] #ffffff" .. tostring(alinanYem) .. " Adet yem aldınız.", thePlayer, 10, 10, 255, true)
				end
			end
		end
	else
		outputChatBox("[!] #ffffffYem almak için paranız yok.", thePlayer,255,255,0, true)
	end
end
addEvent("@lucyrpg_3e0dcecefcffd651db114f47f04e9a33", true)
addEventHandler("@lucyrpg_3e0dcecefcffd651db114f47f04e9a33", root, yemAl)

function balikSat(thePlayer, cmd)
	local countOfPlayerFish = exports["vrp_items"]:countItems(thePlayer, 273)
	local countPrice = 0
	local playerFishs = exports["vrp_items"]:getItems(thePlayer)
		
	for index, row in ipairs(playerFishs) do
		for _, value in ipairs(fishingList) do
			if row[2] == value.name then
				countPrice = countPrice + (value.price*3)
			end
		end
	end

	if isElementWithinColShape(thePlayer, yemCol) then
		local toplambalik = countOfPlayerFish
		if toplambalik <= 0 then
			outputChatBox("[!] #ffffffSatacak balığınız yok!", thePlayer,255,255,0, true)
			return
		else
			exports.vrp_global:giveMoney(thePlayer, countPrice)
			for i = 0, countOfPlayerFish do
				exports["vrp_items"]:takeItem(thePlayer, 273)
			end
			outputChatBox("[!] #ffffff" .. tostring(toplambalik) .. " tane balıktan toplam $" .. tostring(countPrice) .. " kazandınız!", thePlayer, 0, 255, 0, true)
		end
	end
end
addEvent("@lucyrpg_329c61fb962da98a18a538ef431f6eed", true)
addEventHandler("@lucyrpg_329c61fb962da98a18a538ef431f6eed", root, balikSat)


function yuzdelikOran (percent)
	assert(percent >= 0 and percent <= 100) 
	return percent >= math.random(1, 100)
end