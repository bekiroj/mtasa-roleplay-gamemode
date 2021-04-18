local Interior = 0
local Dimension = 0
local PosX, PosY, PosZ = 1139.6806640625, -5.58984375, 1000.671875
local minBahis, maxBahis = 5, 200
local Maximum = {}
local MaximumTimers = {}
local Bahisler = {}

addCommandHandler("bahisoyna",
	function(thePlayer, cmd, sayi, bahis)
		local x, y, z = getElementPosition(thePlayer)
		local oyuncudim = getElementDimension(thePlayer)
		if oyuncudim == 36 then
			if not sayi or not bahis then outputChatBox("[!] #f0f0f0SÖZDİZİMİ: /" .. cmd .. " <1-4> [Bahis Miktarı]", thePlayer, 255, 0, 0, true) return end
			if (tonumber(sayi) > 4) or (tonumber(sayi) < 1) then outputChatBox("[!] #f0f0f0Sayı 1 ve 4 arasında olmalıdır.", thePlayer, 255, 0, 0, true) return end
			if (tonumber(bahis) > 200) or (tonumber(bahis) < 5) then outputChatBox("[!] #f0f0f0Bahis miktarı en az $5, en fazla $200 olabilir.", thePlayer, 255, 0, 0, true) return end
			
			local playerID = getElementData(thePlayer, "dbid")
			if not (Maximum[playerID]) then Maximum[playerID] = 0 end
			if (Bahisler[playerID]) then outputChatBox("[!] #f0f0f0Zaten bir bahis oynadınız. Tekrar oynayabilmek için mevcut yarışın bitmesini beklemeniz gerekmektedir.", thePlayer, 255, 0, 0, true) return end
			if (Maximum[playerID] >= 3) then outputChatBox("[!] #f0f0f024 Saat içerisinde en fazla 3 kez bahis oynayabilirsiniz.", thePlayer, 255, 0, 0, true) return end
			
			if not exports.vrp_global:hasMoney(thePlayer, tonumber(bahis)) then outputChatBox("[!] #f0f0f0Malesef üzerinizde yeterince para yok.", thePlayer, 255, 0, 0, true) return end
			exports.vrp_global:takeMoney(thePlayer, tonumber(bahis))
			outputChatBox("[!] #f0f0f0" .. sayi .. " numaralı ata $" .. bahis .. " bahis oynadınız!", thePlayer, 0, 255, 0, true)
			
			Bahisler[playerID] = { tonumber(sayi), tonumber(bahis) }
			Maximum[playerID] = Maximum[playerID] + 1
			if not (MaximumTimers[playerID]) then
				MaximumTimers[playerID] = setTimer(
					function()
						Maximum[playerID] = 0
					end, (60*1000*60*24), 1
				)
			end
		end
	end
)

function BahisZamani()
	local tutanSayi = math.random(1, 4)
	for index, value in ipairs(Bahisler) do
		if value[1] == tutanSayi then
			for _, player in ipairs(getElementsByType("player")) do
				if getElementData(player, "dbid") == index then
					kazananPlayer = player
				end
			end
			if kazananPlayer then
				outputChatBox("[!] Bahsiniz tuttuğu için, at yarışından toplam $" .. exports.vrp_global:formatMoney(value[2]) .. " kazandınız! Para banka hesabınıza yatırılmıştır.", kazananPlayer, 0, 255, 0, true)
			end
			local kazanilanPara = value[2] * 2
			setElementData(kazananPlayer, "bankmoney", getElementData(kazananPlayer, "bankmoney") + kazanilanPara)
			if not kazananPlayer then
				if dbExec(exports.vrp_mysql:getConnection(), "UPDATE characters SET bankmoney = bankmoney + " .. kazanilanPara .. " WHERE id=" .. index) then
				else
					outputDebugString("[BAHIS] MySQL hatası.")
				end
			end
		end
	end
	outputChatBox("<BBC News> Spor Haberleri: At yarışını " .. tutanSayi .. " numaralı at kazandı.", root, 0, 255, 64, true)
	Bahisler = {}
end
setTimer(
BahisZamani, ((60*1000) * 30), 0)