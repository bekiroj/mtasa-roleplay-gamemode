function karakterDegistirmeEvent(source)

		local isim = getPlayerName(source)
		exports.vrp_global:sendLocalText(source, isim.." adlı oyuncu karakter değiştirme ekranına gitti. (kendi isteğiyle.)", 255, 255, 255, 10)

end
addEvent("karakterDegistirmeEvent", true)
addEventHandler("karakterDegistirmeEvent", getRootElement(), karakterDegistirmeEvent)
