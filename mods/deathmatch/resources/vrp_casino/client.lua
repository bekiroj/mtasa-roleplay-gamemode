
guiler = {
    gridlist = {},
    window = {},
    scrollbar = {},
    button = {},
	label = {}
}
setElementData(localPlayer, "kumar:istek",nil)
setElementData(localPlayer, "kumar:partner", nil)
setElementData(localPlayer, "kumar:bahis", nil)
setElementData(localPlayer, "kumar:cevir",nil)
setElementData(localPlayer, "kumar:panel", nil)
local  sx,sy = guiGetScreenSize()
function davetpanel ()
	if getElementDimension(localPlayer) == 36 then
	if not getElementData(localPlayer, "kumar:panel") then
	setElementData(localPlayer, "kumar:panel", true)
	arkaplan= guiCreateWindow(sx/2-450/2, sy/2-75, 450, 150, "Valhalla - Kumar Daveti", false)
	yazi  = guiCreateLabel(15,35,450,50,"İlk kutucuğa oyuncu ismini, ikinci kutucuğa düello fiyatını girin.",false,arkaplan)
	guiSetFont(yazi ,"default-bold-small")
	oyuncubox = guiCreateEdit(0,65,450,30,"Oyuncu İsmi: Ad_Soyad",false,arkaplan)
	
	miktarbox = guiCreateEdit(0,100,70,30,"Fiyat Girin",false,arkaplan)
	gonderbuton = guiCreateButton(85,100,175,30,"Gönder",false,arkaplan)
	kapatbuton = guiCreateButton(265,100,190,30,"Kapat",false,arkaplan)
	else
	destroyElement(arkaplan)
	setElementData(localPlayer, "kumar:panel", nil)
		end
	end
end

addCommandHandler("kumar", davetpanel)

addEventHandler("onClientRender", root, function()
		if getElementData(localPlayer, "kumar:partner") then
		print("tetik1")
			if getElementDimension(localPlayer) < 36 then
			destroyElement(arkaplan2)
			triggerServerEvent("kumar:ayril", localPlayer, localPlayer,getElementData(localPlayer, "kumar:partner"))
	setElementData(localPlayer, "kumar:istek",nil)
setElementData(localPlayer, "kumar:partner", nil)
setElementData(localPlayer, "kumar:bahis", nil)
setElementData(localPlayer, "kumar:cevir",nil)
setElementData(localPlayer, "kumar:panel", nil)
			end
		end
end)

function showInviteMenu(daveteden, davetedilen, miktar)
	showCursor(true)

	guiler.window[1] = guiCreateWindow(0.37, 0.42, 0.26, 0.20, "Valhalla - Zar Düellosu", true)
	guiWindowSetSizable(guiler.window[1], false)


	guiler.label[1] = guiCreateLabel(0.03, 0.21, 0.31, 0.13, "Davet eden oyuncu:", true, guiler.window[1])
	guiSetFont(guiler.label[1], "default-bold-small")
	guiler.label[2] = guiCreateLabel(0.03, 0.34, 0.50, 0.13, "Bahis Miktarı: $", true, guiler.window[1])
	guiSetFont(guiler.label[2], "default-bold-small")
	guiler.label[3] = guiCreateLabel(0.26, 0.21, 0.62, 0.13, getPlayerName(daveteden), true, guiler.window[1])
	guiler.label[4] = guiCreateLabel(0.19, 0.34, 0.62, 0.13, miktar, true, guiler.window[1])
	onaylaButonu = guiCreateButton(0.02, 0.53, 0.47, 0.35, "ONAYLA", true, guiler.window[1])
	addEventHandler("onClientGUIClick", guiRoot, 
	function () 
		if source == onaylaButonu then
			triggerServerEvent("kumar:durum", davetedilen, daveteden, davetedilen, miktar, "+")
			destroyElement(guiler.window[1])
			showCursor(false)
		end
	end)
	
	kapatmaButonu = guiCreateButton(0.51, 0.53, 0.47, 0.35, "REDDET", true, guiler.window[1])    
	addEventHandler("onClientGUIClick", guiRoot, 
	function () 
		if source == kapatmaButonu then
			destroyElement(guiler.window[1])
		triggerServerEvent("kumar:durum", davetedilen, daveteden, davetedilen, miktar, "-")
			showCursor(false)
		end
	end)
end
addEvent("kumar:davet", true)
addEventHandler("kumar:davet", root, showInviteMenu)

function kumaroynama (daveteden, davetedilen)
	tablolar = {
		{">> Oynanan Partner: "..getPlayerName(getElementData(localPlayer, "kumar:partner"))},
		{">> Bahis Miktarı: $"..getElementData(localPlayer, "kumar:bahis") },
		{">> Döndür" },
	}
	arkaplan2  = guiCreateWindow(sx/2-450/2, sy/2-75, 450, 250, "Valhalla - Zar Düellosu", false)
	ayril = guiCreateButton(0,195,440,30,"Bahisten Ayrıl", false,arkaplan2)
	liste = guiCreateGridList(0,20,440,140,false,arkaplan2)
	guiGridListAddColumn(liste, "", 0.90)
	for k, v in ipairs(tablolar) do
	local row = guiGridListAddRow(liste)
	guiGridListSetItemText(liste, row, 1, v[1] or "Yok",false, false)
	end

end
addEvent("kumar:oynama",true)
addEventHandler("kumar:oynama", root, kumaroynama)

addEvent("kumar:kapat", true)
addEventHandler("kumar:kapat", root, function(daveteden, davetedilen)

destroyElement(arkaplan2)
destroyElement(arkaplan)
destroyElement(arkaplan)
	setElementData(localPlayer, "kumar:panel", nil)


end)

function listetiklama( )
 if button == "left" then
	if  source == liste then
		local siraCek = guiGridListGetSelectedItem(liste)
		local isimCek = guiGridListGetItemText(liste, siraCek, 1)
		if siraCek ~= -1 and siraCek ~= 0 and siraCek ~= 1 then
			triggerServerEvent("kumar:oyna", localPlayer, localPlayer ,getElementData(localPlayer, "kumar:partner"),tonumber( getElementData(localPlayer, "kumar:bahis")))
			print(siraCek)
			end
		end
	end
end
 addEventHandler( "onClientGUIDoubleClick", root, listetiklama )

function tiklama ( button )
    if button == "left" then
	if source == ayril then
	
		triggerServerEvent("kumar:ayril", localPlayer, localPlayer,getElementData(localPlayer, "kumar:partner"))
		--destroyElement(arkaplan2)
	end
	if  source == liste then
		local siraCek = guiGridListGetSelectedItem(liste)
		local isimCek = guiGridListGetItemText(liste, siraCek, 1)
		if siraCek ~= -1 and siraCek ~= 0 and siraCek ~= 1 then
		
			triggerServerEvent("kumar:oyna", localPlayer, localPlayer ,getElementData(localPlayer, "kumar:partner"),tonumber( getElementData(localPlayer, "kumar:bahis")))
			
		end
	end
		if source == gonderbuton then
		if not tonumber(guiGetText(miktarbox)) then
		outputChatBox("#e84118[Valhalla] #ffffffHerhangi bir sayı değeri girmediniz.",255,0,0,true)
		return end
		if tonumber(guiGetText(miktarbox)) < 500  then
		outputChatBox("#e84118[Valhalla] #ffffffMinimum $500 yazabilirsiniz.",255,0,0,true)
		return end
		if tonumber(guiGetText(miktarbox)) >  10000 then
		outputChatBox("#e84118[Valhalla] #ffffff$10.000'dan daha büyük bir para yazamazsınız.",255,0,0,true)
		return end
		if tonumber(guiGetText(miktarbox))  then
			if guiGetText(oyuncubox) == "" and guiGetText(oyuncubox) == " " then
				outputChatBox("#e84118[Valhalla]#ffffffGirdiğiniz isim geçersiz",255,0,0,true)
			return end
			local hedef = getPlayerFromPartialName(guiGetText(oyuncubox))
			
				if hedef then
				triggerServerEvent("kumar:istek",localPlayer,localPlayer,hedef, guiGetText(miktarbox))
				destroyElement(arkaplan)
				destroyElement(arkaplan)
	setElementData(localPlayer, "kumar:panel", nil)
				 else
				outputChatBox("#e84118[Valhalla]#ffffffGirdiğiniz isim geçersiz.",255,0,0,true)
				end
			end
		end
		if source == kapatbuton then
	destroyElement(arkaplan)
	setElementData(localPlayer, "kumar:panel", nil)
		end
    end
end
addEventHandler ( "onClientGUIClick", root, tiklama )


function getPlayerFromPartialName(name)
    local name = name and name:gsub("#%x%x%x%x%x%x", ""):lower() or nil
    if name then
        for _, player in ipairs(getElementsByType("player")) do
            local name_ = getPlayerName(player):gsub("#%x%x%x%x%x%x", ""):lower()
            if name_:find(name, 1, true) then
                return player
            end
        end
    end
end

