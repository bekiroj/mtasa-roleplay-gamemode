-- // bekiroj

local kelepceyeri = createColSphere ( 1424.9951171875, -1292.7138671875, 13.556790351868, 3)

function kelepcekir(thePlayer, cmd)

	if not isElementWithinColShape(thePlayer, kelepceyeri) then return end

	if getElementData(thePlayer, "kelepce") or getElementData(thePlayer, "ipbagli") then

		local miktar = 500

		if getElementData(thePlayer, "vip") >= 1 then
			miktar = 0
		end

		if not exports.vrp_global:takeMoney(thePlayer, miktar) then -- kırdıma fiyatı
			outputChatBox("[!]#ffffff Kelepçe kırdırmak için $"..miktar.." ödemeniz gerekli.",thePlayer,104,113,232,true)
		return end

		exports.vrp_handcuff:kelepcele(thePlayer, "al")
		exports.vrp_handcuff:kelepcele(thePlayer, "ipal")
	else
		outputChatBox("[!]#FFFFFF Kelepçeli değilsiniz.",thePlayer,104,113,232,true)
	end
end
addCommandHandler("kelepcekir", kelepcekir)