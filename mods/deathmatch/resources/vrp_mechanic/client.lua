self = {
    tab = {},
    staticimage = {},
    tabpanel = {},
    label = {},
    button = {},
    window = {},
    gridlist = {}
}
addEvent("mechanic:gui", true)
addEventHandler("mechanic:gui", root,
    function()
        self.window[1] = guiCreateWindow(578, 351, 767, 409, "Valhalla - Mekanik Arayüzü", false)
        guiWindowSetSizable(self.window[1], false)

        self.tabpanel[1] = guiCreateTabPanel(9, 25, 748, 374, false, self.window[1])

        self.tab[1] = guiCreateTab("Arayüzler", self.tabpanel[1])

        close = guiCreateButton(10, 316, 728, 24, "Arayüzü Kapat", false, self.tab[1])
        self.tabpanel[2] = guiCreateTabPanel(20, 15, 695, 287, false, self.tab[1])

        self.tab[2] = guiCreateTab("Jant", self.tabpanel[2])

        jantpanel = guiCreateButton(23, 213, 650, 40, "Jant Arayüzünü Aç", false, self.tab[2])
        self.label[1] = guiCreateLabel(216, 179, 255, 19, "Artık araç jantlarını daha kolay takabileceksiniz. ", false, self.tab[2])
        self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "wheel/main/main.png", false, self.tab[2])

        self.tab[3] = guiCreateTab("Spoiler", self.tabpanel[2])

        spoilerpanel = guiCreateButton(23, 213, 650, 40, "Spoiler Arayüzünü Aç", false, self.tab[3])
        self.label[1] = guiCreateLabel(216, 179, 255, 19, "Artık araç spoilerlarını daha kolay takabileceksiniz. ", false, self.tab[3])
        self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "spoiler/main/main.png", false, self.tab[3])
		
        self.tab[4] = guiCreateTab("Korna", self.tabpanel[2])
		
        kornapanel = guiCreateButton(23, 213, 650, 40, "Korna Arayüzünü Aç", false, self.tab[4])
        self.label[4] = guiCreateLabel(216, 179, 255, 19, "Artık araç kornalarını daha kolay takabileceksiniz. ", false, self.tab[4])
        self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "korna/main/main.png", false, self.tab[4])
		
        self.tab[5] = guiCreateTab("Ek Özellikler", self.tabpanel[2])

        self.label[2] = guiCreateLabel(271, 114, 155, 15, "Bu arayüz yapım aşamasında.", false, self.tab[5])
        self.label[3] = guiCreateLabel(316, 129, 58, 16, "© bekiroj", false, self.tab[5])



        self.tab[6] = guiCreateTab("Yardım", self.tabpanel[1])

        close2 = guiCreateButton(10, 317, 728, 23, "Arayüzü Kapat", false, self.tab[6])
        self.gridlist[1] = guiCreateGridList(18, 20, 710, 287, false, self.tab[6])
        guiGridListAddColumn(self.gridlist[1], "Yardım", 0.9)
        for i = 1, 14 do
            guiGridListAddRow(self.gridlist[1])
        end
        guiGridListSetItemText(self.gridlist[1], 0, 1, "Mekanik yardım arayüzüne hoş geldiniz, hemen size bir kaç bilgi verelim.", false, false)
        guiGridListSetItemText(self.gridlist[1], 1, 1, "Eğer bir mekanikçiyseniz, ve bir dükkanınız varsa bu arayüze erişebiliyorsunuz.", false, false)
        guiGridListSetItemText(self.gridlist[1], 2, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 3, 1, "Bu arayüz ne işe yarıyor?", false, false)
        guiGridListSetItemColor(self.gridlist[1], 3, 1, 254, 18, 0, 255)
        guiGridListSetItemText(self.gridlist[1], 4, 1, "Bu arayüz sayesinde mekanik & tamircilik işlemlerinizi çok daha hızlı ve rol kurallarına uygun gerçekleştiriyorsunuz.", false, false)
        guiGridListSetItemColor(self.gridlist[1], 4, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 5, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 6, 1, "Mekanik işini bırakıp, arkadaşıma devretmek istiyorum. Nasıl yapabilirim?", false, false)
        guiGridListSetItemColor(self.gridlist[1], 6, 1, 249, 3, 3, 255)
        guiGridListSetItemText(self.gridlist[1], 7, 1, "Mekaniğinizi bir arkadaşınıza devretmek, ya da satmak istiyorsanız, /mekanikdevret <Karakter Adı ya da ID> şeklinde devredebilirsiniz.", false, false)
        guiGridListSetItemColor(self.gridlist[1], 7, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 8, 1, "çok basit bir şekilde devredebilirsiniz.", false, false)
        guiGridListSetItemColor(self.gridlist[1], 8, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 9, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 10, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 11, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 12, 1, "Gereken yardımı aldın. Her hangi bir sıkıntın, isteğin ya da sorunun olursa F2 rapor atabilirsin.", false, false)
        guiGridListSetItemText(self.gridlist[1], 13, 1, "Valhalla - Scripting Team", false, false)    
    end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == close) or (source == close2)  then
				destroyElement(self.window[1])
				
			elseif (source == jantpanel) then
				if localPlayer:getData("tamirci") == 1 then 
					destroyElement(self.window[1])
					triggerEvent("jant:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Bu arayüze erişmene iznin yok.", 255, 0, 0, true)
				end
			elseif (source == spoilerpanel) then
				if localPlayer:getData("tamirci") == 1 then 
					destroyElement(self.window[1])
					triggerEvent("spoiler:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Bu arayüze erişmene iznin yok.", 255, 0, 0, true)
				end
			elseif (source == kornapanel) then
				if localPlayer:getData("tamirci") == 1 then 
					destroyElement(self.window[1])
					triggerEvent("korna:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Bu arayüze erişmene iznin yok.", 255, 0, 0, true)
				end				
			end
		end
	end
)
