local pickup = createPickup(1136.6435546875, -11.2705078125, 1000.6796875, 3, 1239)
setElementData(pickup, "informationicon:information", "#33FF00/kumar#ffffff\nKumarhane")
setElementInterior(pickup, 12)
setElementDimension(pickup, 36)


addEvent("kumar:istek", true)
addEvent("kumar:durum", true)
addEvent("kumar:oyna", true)
addEvent("kumar:ayril", true)

addEventHandler("kumar:ayril", root, function(plr, karsi)
outputChatBox("#fbc531[Valhalla] #ffffffDüellodan ayrıldınız.",plr,0,100,255,true)
outputChatBox("#fbc531[Valhalla] #ffffffPartneriniz "..getPlayerName(plr).." düellodan ayrıldı.",karsi,255,0,0,true)

setElementData(plr, "kumar:istek",nil)
setElementData(plr, "kumar:partner", nil)
setElementData(plr, "kumar:bahis", nil)
setElementData(plr, "kumar:cevir",nil)
setElementData(plr, "kumar:düello",nil)

setElementData(karsi, "kumar:istek",nil)
setElementData(karsi, "kumar:partner", nil)
setElementData(karsi, "kumar:bahis", nil)
setElementData(karsi, "kumar:cevir",nil)
setElementData(karsi, "kumar:düello",nil)

triggerClientEvent("kumar:kapat",plr,plr,karsi)



end)

addEventHandler("kumar:oyna", root, function(plr, karsi, miktar)
	if getElementData(plr, "money") < miktar then
		outputChatBox("#e84118[Valhalla] #ffffffKumar oynamak için biraz fakir değil misin? :) (yetersiz para)",plr,255,0,0,true)
	return end
	if getElementData(karsi, "money") < miktar then
		outputChatBox("#e84118[Valhalla] #ffffffKumar oynamak için biraz fakir değil misin? :) (yetersiz para)",karsi,255,0,0,true)
	return end
	if not getElementData(karsi, "kumar:cevir") then
		if getElementData(plr, "kumar:cevir") then
			--outputChatBox("[Valhalla]#ffffff Siz Zaaten  çevirdiniz bekleyiniz karşı tarafı",plr,255,0,0,true)
		return end
		outputChatBox("#00a8ff[Valhalla] #ffffffÇevirdiniz, partnerinizin karşılık vermesini bekleyin.",plr,0,255,0,true)
		outputChatBox("#fbc531[Valhalla] #ffffffPartneriniz çevirdi. Sıra sende. ",karsi,0,100,255,true)
		setElementData(plr, "kumar:cevir", true)
	return end
	if getElementData(karsi, "kumar:cevir")   then
		setElementData(plr, "kumar:düello", true)
		setElementData(karsi, "kumar:düello", true)
		sayi1,sayi2 = math.random(1,6),math.random(1,6) -- plr sayı
		sayi5 = sayi1+sayi2 -- plr toplam sayısı
		
		sayi3,sayi4 = math.random(1,6),math.random(1,6) -- karsi sayi	
		sayi6 =  sayi3+sayi4 -- karsi toplam sayı
		
			if sayi5  < sayi6 then
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,plr,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,plr,66, 135, 245,true)
				outputChatBox("#00a8ff[Valhalla]#ffffff | Bu raundu kazanan oyuncu: "..getPlayerName(plr),karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | Harika! bu raundun galibi sen oldun.",plr,66, 135, 245,true)
				exports["vrp_global"]:takeMoney(karsi, miktar)
				exports["vrp_global"]:giveMoney(plr, miktar)
				setElementData(plr, "kumar:cevir", nil)
				setElementData(karsi, "kumar:cevir", nil)
			return end
			if sayi5 == sayi6 then
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,plr,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,plr,66, 135, 245,true)
				outputChatBox("#00a8ff[Valhalla]#ffffff | Raund berabere kaldı, kazanan kimse olmadı.",plr,66,135,245,true)
				setElementData(plr, "kumar:cevir", nil)
				setElementData(karsi, "kumar:cevir", nil)
			return end
			if sayi5 > sayi6 then
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,plr,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(karsi)..", (1. Zar: "..sayi3.."), (2. Zar: "..sayi4..") Toplam: "..sayi6,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,karsi,66, 135, 245,true)
				outputChatBox("#fbc531[Valhalla]#ffffff | "..getPlayerName(plr)..", (1. Zar: "..sayi1.."), (2. Zar: "..sayi2..") Toplam: "..sayi5,plr,66, 135, 245,true)
				outputChatBox("#e84118[Valhalla]#ffffff | Bu raundu kazanan oyuncu: "..getPlayerName(karsi),plr,66, 135, 245,true)
				outputChatBox("#00a8ff[Valhalla]#ffffff | Harika! bu raundun galibi sen oldun.",karsi,66, 135, 245,true)
				exports["vrp_global"]:giveMoney(karsi, miktar)
				exports["vrp_global"]:takeMoney(plr, miktar)
				setElementData(plr, "kumar:cevir", nil)
				setElementData(karsi, "kumar:cevir", nil)
			return end

		
		
	end
end)

addEventHandler("kumar:istek", root, function(daveteden, davetedilen, miktar)
	     local x, y, z = getElementPosition(daveteden) 
	     local x1, y1, z1 = getElementPosition(davetedilen) 
        local distance = getDistanceBetweenPoints3D(x, y, z, x1, y1, z1)
	if distance > 3 then
		outputChatBox("[Valhalla]#ffffff İstek yollamaya çalıştığınız kişi yakınızda olmalı",daveteden,255,0,0,true)
	return end
	if daveteden == davetedilen then
		outputChatBox("#e84118[Valhalla]#ffffff Kendi kendine kumar oynayamazsın.",daveteden,255,0,0,true)
	return end
	if not getElementData(daveteden, "kumar:istek") then
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(daveteden).." isimli oyuncu size bir zar düellosu daveti yolladı.", davetedilen, 0, 0, 255, true)
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(davetedilen).." isimli oyuncuya zar düellosu teklifinde bulundunuz.", daveteden, 0, 0, 255, true)
		triggerClientEvent(davetedilen, "kumar:davet", davetedilen, daveteden, davetedilen, miktar)
		setElementData(daveteden, "kumar:istek",davetedilen)
	else
	local davet = getElementData(daveteden, "kumar:istek")
		outputChatBox("#e84118[Valhalla]#ffffff Veri deponuzda zaten istek yollanan bir oyuncu bulunuyor. İstek yollanan oyuncu: "..getPlayerName(davet),daveteden,255,0,0,true)
	end
end)

addEventHandler("kumar:durum", root, function(daveteden, davetedilen,miktar, durum)
	if durum == "+" then
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(davetedilen).." isimli oyuncu zar düellosunu kabul etti!", daveteden, 0, 0, 255, true)
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(daveteden).." isimli oyuncunun zar düellosu teklifini kabul ettin.", davetedilen, 0, 0, 255, true)
		
		
		setElementData(daveteden, "kumar:partner", davetedilen)
		setElementData(davetedilen, "kumar:partner", daveteden)
		setElementData(daveteden, "kumar:düello", true)
		setElementData(davetedilen, "kumar:düello", true)
		
		setElementData(daveteden, "kumar:bahis", miktar)
		setElementData(davetedilen, "kumar:bahis", miktar)
		
		setElementData(daveteden, "kumar:istek", nil)
		triggerClientEvent("kumar:oynama", davetedilen, daveteden, davetedilen)
		setElementData(daveteden, "kumar:istek", nil)
	else
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(davetedilen).." isimli oyuncu zar düellosu teklifinizi geri çevirdi.", daveteden, 255, 0, 0, true)
		outputChatBox("#e84118[Valhalla]#ffffff "..getPlayerName(daveteden).." isimli oyuncunun zar düellosu teklifini geri çevirdiniz.", davetedilen, 255, 0, 0, true)
		setElementData(daveteden, "kumar:istek", nil)
	end
end)