
version = exports["vrp_global"]:getScriptVersion()

wGeneralshop, iClothesPreview, bShrink  = nil
bSend, tBizManagement, tGoodBye = nil
shop = nil
shop_type = nil

BizNoteFont = guiCreateFont( ":vrp_resources/BizNote.ttf", 30 )
BizNoteFont18 = guiCreateFont( ":vrp_resources/BizNote.ttf", 18 )
BizNoteFont2 = guiCreateFont( "files/fonts/seguisb.ttf", 11 )

warningDebtAmount = getElementData(getRootElement(), "shop:warningDebtAmount") or 500
limitDebtAmount = getElementData(getRootElement(), "shop:limitDebtAmount") or 1000
wageRate = getElementData(getRootElement(), "shop:wageRate") or 5

coolDownSend = 1 -- Minutes

local fdgw = {}

-- returns [item index in current shop], [actual item]
function getSelectedItem( grid )
	if grid then
		local row, col = guiGridListGetSelectedItem( grid )
		if row > -1 and col > -1 then
			local index = tonumber( guiGridListGetItemData( grid, row, 1 ) ) -- 1 = cName
			if index then
				local item = getItemFromIndex( shop_type, index )
				return index, item
			end
		end
	end
end

local products = {}

-- creates a shop window, hooray.
function showGeneralshopUI(shop_type, race, gender, discount, products1)
	products = products1
	local ped = source
	if not wCustomShop and not wAddingItemsToShop and not wGeneralshop and not getElementData(getLocalPlayer(), "shop:NoAccess" ) then
		setElementData(getLocalPlayer(), "shop:NoAccess", true, true )
		if shop_type==17 then
			--CUSTOM SHOP / MAXIME
		
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 432
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			local isClientBizOwner, bizName, bizNote = isBizOwner(getLocalPlayer())
			
			if not bizName then
				hideGeneralshopUI()
				return false
			end
			
			guiSetInputEnabled(true)
			showCursor(true)
			
			wCustomShop = guiCreateWindow(X,Y,Width,Height,bizName.." - Özel Market ",false)
			guiWindowSetSizable(wCustomShop,false)
			
			local shopTabPanel = guiCreateTabPanel(9,26,738,396,false,wCustomShop)
			local tProducts = guiCreateTab ( "Ürünler" , shopTabPanel )
			local gProducts = guiCreateGridList ( 0, 0, 1, 0.9, true, tProducts)
			
			local lWelcomeText = guiCreateLabel(0,0.89,0.848,0.1,'"'..bizName..'!": Hoşgeldiniz! Birşey satın almak için ürüne çift tıklayın',true,tProducts)
			bCloseStatic = guiCreateButton(0.85, 0.90 , 0.15, 0.089, "Kapat", true, tProducts)
			guiSetFont(bCloseStatic, BizNoteFont2)
			addEventHandler( "onClientGUIClick", bCloseStatic,hideGeneralshopUI , false )
			
			guiLabelSetVerticalAlign(lWelcomeText,"center")
			guiLabelSetHorizontalAlign(lWelcomeText,"center",false)
			guiSetFont(lWelcomeText, BizNoteFont18)
			local colName = guiGridListAddColumn(gProducts,"İsim",0.2)
			local colAmount = guiGridListAddColumn(gProducts,"Detaylar",0.2)
			local colPrice = guiGridListAddColumn(gProducts,"Fiyat",0.1)
			local colDesc = guiGridListAddColumn(gProducts,"Bilgi",0.36)
			--local colDate = guiGridListAddColumn(gProducts,"Published Date",0.15)
			local colProductID = guiGridListAddColumn(gProducts,"Ürün ID",0.1)
			local currentCap = 0
			for _, record in ipairs(products) do
				local row = guiGridListAddRow(gProducts)
				local itemName = exports["vrp_items"]:getItemName( tonumber(record[2]), tostring(record[3]) ) 
				local itemValue = ""
				if not exports["vrp_items"]:getItemHideItemValue(tonumber(record[2])) then
					itemValue = exports["vrp_items"]:getItemValue( tonumber(record[2]), tostring(record[3]) )
				end
				local itemPrice = exports.vrp_global:formatMoney(math.ceil(tonumber(record[5] or 0))).. " $" or false
				guiGridListSetItemText(gProducts, row, colName, itemName or "Unknown", false, false)
				guiGridListSetItemText(gProducts, row, colAmount, itemValue or "Unknown", false, false)
				guiGridListSetItemText(gProducts, row, colPrice, itemPrice, false, true)
				guiGridListSetItemText(gProducts, row, colDesc, record[4] or "Unknown", false, false)
				--guiGridListSetItemText(gProducts, row, colDate, record[6], false, false)
				guiGridListSetItemText(gProducts, row, colProductID, record[7] or "Unknown", false, true)
				currentCap = currentCap + 1
				setElementData(ped, "currentCap", currentCap, true)
			end

			if isClientBizOwner then
				----------------------START EDIT CONTACT-------------------------------------------------------
				tGoodBye = guiCreateTab ( "Edit Contact Info" , shopTabPanel )
				
				local lTitle1 = guiCreateLabel(11,19,716,56,("Edit Contact Info - "..bizName),false,tGoodBye)
					--guiLabelSetVerticalAlign(lTitle1[1],"center")
					guiLabelSetHorizontalAlign(lTitle1,"center",false)
					guiSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.vrp_global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = guiCreateLabel(11,75,100,20,"- Sahibi:",false,tGoodBye)
				local eOwner = guiCreateEdit(111,75,600,20,sOwner,false,tGoodBye)
				local lPhone = guiCreateLabel(11,95,100,20,"- Telefon Numarası:",false,tGoodBye)
				local ePhone = guiCreateEdit(111,95,600,20,sPhone,false,tGoodBye)
				local lEmail = guiCreateLabel(11,115,100,20,"- Email Adresi:",false,tGoodBye)
				local eEmail = guiCreateEdit(111,115,600,20,sEmail,false,tGoodBye)
				local lForums = guiCreateLabel(11,135,100,20,"((Forum İsmi)):",false,tGoodBye)
				local eForums = guiCreateEdit(111,135,600,20,sForum,false,tGoodBye)
				
				guiEditSetMaxLength ( eOwner, 100 )
				guiEditSetMaxLength ( ePhone, 100 )
				guiEditSetMaxLength ( eEmail, 100 )
				guiEditSetMaxLength ( eForums, 100 )
				
				local lBizNote = guiCreateLabel(0.01,0.5,1,0.1,"- Biz Note:",true,tGoodBye)
				
				local eBizNote = guiCreateEdit ( 0.01, 0.58, 0.98, 0.1,bizNote, true, tGoodBye)
				guiEditSetMaxLength ( eBizNote, 100 )
				
				bSend = guiCreateButton(0.01, 0.88, 0.49, 0.1, "Kaydet", true, tGoodBye)	
				local contactName, contactContent = nil
				
				addEventHandler( "onClientGUIClick", bSend, function()
					if guiGetText(eBizNote) ~= "" then
						triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(),getLocalPlayer(), "setbiznote", guiGetText(eBizNote))
					end
					
					if guiGetText(ePhone) ~= "" and not tonumber(guiGetText(ePhone)) then
						guiSetText(ePhone, "Invalid Number")
					else
						triggerServerEvent("shop:saveContactInfo", getLocalPlayer(), ped, {guiGetText(eOwner),guiGetText(ePhone),guiGetText(eEmail),guiGetText(eForums)})
						hideGeneralshopUI()
					end
					
					
				end, false ) 
			
				local bClose = guiCreateButton(0.5, 0.88, 0.49, 0.1, "Kaydet", true, tGoodBye)
				addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
			
				exports["vrp_dxlib"]:convertUI(tGoodBye)
				----------------------START BIZ MANAGEMENT-------------------------------------------------------
				local GUIEditor_Memo = {}
				local GUIEditor_Label = {}
				
				tBizManagement = guiCreateTab ( "İş yönetimi" , shopTabPanel )
				guiSetEnabled(tBizManagement,false)
				GUIEditor_Label[1] = guiCreateLabel(11,19,716,56,"İş yönetimi - "..bizName or "",false,tBizManagement)
					--guiLabelSetVerticalAlign(GUIEditor_Label[1],"center")
					guiLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)
					guiSetFont(GUIEditor_Label[1], BizNoteFont)
			
				local sCapacity = tonumber(getElementData(ped, "sCapacity")) or 0
				local sIncome = tonumber(getElementData(ped, "sIncome")) or 0
				local sPendingWage = tonumber(getElementData(ped, "sPendingWage")) or 0
				local sSales = getElementData(ped, "sSales") or ""
				local sProfit = sIncome-sPendingWage
				
				guiSetText(lWelcomeText,'"Hoşgeldin patron! Naber?" || '..currentCap..'/'..sCapacity..' Ürünler , Toplam Gelir: TL'..exports.vrp_global:formatMoney(sIncome)..'.')
				
				GUIEditor_Label[2] = guiCreateLabel(11,75,716,20,"- Kapasite: "..sCapacity.." (Dükkanın tutabileceği maksimum ürün sayısı, 5 ek ürün için 1 saat daha fazla ödeme yapmanız gerekiyor)",false,tBizManagement)
				GUIEditor_Label[3] = guiCreateLabel(11,95,716,20,"- Gelir: $"..exports.vrp_global:formatMoney(sIncome),false,tBizManagement)
				GUIEditor_Label[4] = guiCreateLabel(11,115,716,20,"- Personel Ödemesi: $"..exports.vrp_global:formatMoney(sPendingWage).." ($"..exports.vrp_global:formatMoney(sCapacity/wageRate).."/hour)",false,tBizManagement)
				GUIEditor_Label[5] = guiCreateLabel(11,135,716,20,"- kâr: $"..exports.vrp_global:formatMoney(sProfit),false,tBizManagement)
				GUIEditor_Label[6] = guiCreateLabel(11,155,57,19,"- Satışlar: ",false,tBizManagement)
				GUIEditor_Memo[1] = guiCreateMemo(11,179,498,184,sSales,false,tBizManagement)
				guiMemoSetReadOnly(GUIEditor_Memo[1], true)
				
				if sProfit < 0 then
					guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
					if sProfit < (0 - warningDebtAmount) then 
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Uyarı: Eğer borcunuz varsa $"..exports.vrp_global:formatMoney(limitDebtAmount)..", Çalışanlarınız işten ayrılacaktır)." )
						guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
						
					end
				elseif sProfit == 0 then
				else
					if sProfit < 500 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Ortalama).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 255, 0)
					elseif sProfit >= 500 and sProfit < 1000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (İyi!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 245, 0)
					elseif sProfit >= 1000 and sProfit < 2000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Çok iyi!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 235, 0)
					elseif sProfit >= 2000 and sProfit < 4000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Mükemmel!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 225, 0)
					elseif sProfit >= 4000 and sProfit < 8000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Beklenmedik!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 215, 0)
					elseif sProfit >= 8000 and sProfit < 20000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (İnanılmaz!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 205, 0)
					elseif sProfit >= 20000 then
						guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (İşin kralıyız!!!!).")
						guiLabelSetColor ( GUIEditor_Label[5], 0, 195, 0)
					end
				end
				---------------------
				local bExpand = guiCreateButton(0.695, 0.48, 0.15, 0.1, "İşi genişletin", true, tBizManagement)
				guiSetFont(bExpand, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bExpand, function ()
					setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) + 1, true)
					triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
					guiSetText(GUIEditor_Label[2], "- Kapasite: "..tostring(getElementData(ped, "sCapacity")).." (Dükkanın tutabileceği maksimum ürün sayısı, 5 ek ürün için 1 saat daha fazla ödeme yapmanız gerekiyor "..wageRate..")")
					guiSetText(GUIEditor_Label[4] , "- Personel Ödemesi: $"..exports.vrp_global:formatMoney(sPendingWage).." ($"..exports.vrp_global:formatMoney(getElementData(ped, "sCapacity")/wageRate).."/Saatlik)")
					if tonumber(getElementData(ped, "sCapacity")) <= tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) <= 10 then
						guiSetEnabled(bShrink, false)
					else
						guiSetEnabled(bShrink, true)
					end
				end, false )
				-------------------------
				bShrink = guiCreateButton(0.845, 0.48, 0.15, 0.1, "İşi küçült", true, tBizManagement)
				guiSetFont(bShrink, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bShrink, function ()
					if tonumber(getElementData(ped, "sCapacity")) > tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) > 10 then
						guiSetEnabled(bShrink, true)
						setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) - 1, true)
						triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
						guiSetText(GUIEditor_Label[2], "- Kapasite: "..tostring(getElementData(ped, "sCapacity")).." (Dükkanın tutabileceği maksimum ürün sayısı, 5 ek ürün için 1 saat daha fazla ödeme yapmanız gerekiyor  "..wageRate.." )")
						guiSetText(GUIEditor_Label[4] , "- Personel Ödemesi: $"..exports.vrp_global:formatMoney(sPendingWage).." ($"..exports.vrp_global:formatMoney(getElementData(ped, "sCapacity")/wageRate).."/Saatlik)")
					else
						guiSetEnabled(bShrink, false)
					end
				end, false )
				---------------------------
				local bClearSaleLogs = guiCreateButton(0.695, 0.58, 0.3, 0.1, "Satış defterini temizle", true, tBizManagement)
				guiSetFont(bClearSaleLogs, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bClearSaleLogs, function ()
					guiSetText(GUIEditor_Memo[1],"")
					setElementData(ped, "sSales", "", true)
					triggerServerEvent("shop:updateSaleLogs", getLocalPlayer(), getLocalPlayer(), getElementData(ped, "dbid") , "")
				end, false )
				
				--------------------------------
				
				local bPayWage = guiCreateButton(0.695, 0.68, 0.3, 0.1, "Ücretli çalışanlar", true, tBizManagement)
				guiSetFont(bPayWage, BizNoteFont2)
				if sPendingWage > 0 then
					addEventHandler( "onClientGUIClick", bPayWage, function ()
						guiSetVisible(wCustomShop, false)
						triggerServerEvent("shop:solvePendingWage", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					guiSetEnabled(bPayWage, false)
				end
				
				--------------------------------
				local bCollectProfit = guiCreateButton(0.695, 0.78, 0.3, 0.1, "kâr'ı topla", true, tBizManagement)
				guiSetFont(bCollectProfit, BizNoteFont2)
				if (sPendingWage > 0) or (sIncome > 0) then
					addEventHandler( "onClientGUIClick", bCollectProfit, function ()
						guiSetVisible(wCustomShop, false)
						triggerServerEvent("shop:collectMoney", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					guiSetEnabled(bCollectProfit, false)
				end
				
				local bClose = guiCreateButton(0.695, 0.88, 0.3, 0.1, "Kapat", true, tBizManagement)
				guiSetFont(bClose, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
			else
				-----------------------------------------CUSTOMER PANEL-----------------------------------------------------------------
				
				tGoodBye = guiCreateTab ( "İletişim bilgiler" , shopTabPanel )
				
				local lTitle1 = guiCreateLabel(11,19,716,56,(bizName.." - Tekrar görüşürüz!"),false,tGoodBye)
					--guiLabelSetVerticalAlign(lTitle1[1],"center")
					guiLabelSetHorizontalAlign(lTitle1,"center",false)
					guiSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.vrp_global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = guiCreateLabel(11,75,716,20,"- Sahibi: "..sOwner.."",false,tGoodBye)
				local lPhone = guiCreateLabel(11,95,716,20,"- Telefon numarası: "..sFormatedPhone.."",false,tGoodBye)
				local lEmail = guiCreateLabel(11,115,716,20,"- Email Adresi: "..sEmail.."",false,tGoodBye)
				local lForums = guiCreateLabel(11,135,716,20,"- ((Forum ismi: "..sForum.."))",false,tGoodBye)
				local lGuide = guiCreateLabel(0.01,0.5,1,0.1,"        'Hey, mesajını istersen patronlarıma iletebilirim': ",true,tGoodBye)
				
				local eBargainName = guiCreateEdit ( 0.01, 0.58, 0.19, 0.1,"Kimliğiniz", true, tGoodBye)
				addEventHandler( "onClientGUIClick", eBargainName, function()
					guiSetText(eBargainName, "")
				end, false )
				
				local eContent = guiCreateEdit ( 0.2, 0.58, 0.79, 0.1,"İçerik", true, tGoodBye)
				guiEditSetMaxLength ( eContent, 95 )
				addEventHandler( "onClientGUIClick", eContent, function()
					guiSetText(eContent, "")
				end, false )
				
				bSend = guiCreateButton(0.01, 0.88, 0.49, 0.1, "Gönder", true, tGoodBye)	
				local contactName, contactContent = nil
				if not getElementData(getLocalPlayer(), "shop:coolDown:contact") then
					guiSetText(bSend, "Gönder")
					guiSetEnabled(bSend, true)
				else
					guiSetText(bSend, "(Başka bir mesaj gönderebimek için "..coolDownSend.." Dakika beklemeniz gerekiyor)")
					guiSetEnabled(bSend, false)
				end	
				
				addEventHandler( "onClientGUIClick", bSend, function()
					contactContent = guiGetText(eContent)
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = guiGetText(eBargainName):gsub("_"," ") 
						if contactName == "" or contactName == "Kimliğiniz" then 
							contactName = "Bir müşteri" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Bay. "..contactName
							else
								contactName = "Bayan. "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Hey Patron! Oku bunu '"..contactContent.."', diyorki "..contactName..".")
						
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								guiSetText(bSend, "Gönder")
								guiSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) 
						
						guiSetText(bSend, "(Başka bir mesaj gönderebimek için "..coolDownSend.." dakika beklemeniz gerekiyor)")
						guiSetEnabled(bSend, false)
						
						guiSetText(eContent, "")
					end 
					
					
					
				end, false ) 
				
				addEventHandler( "onClientGUIAccepted", eContent,function()
					contactContent = guiGetText(eContent):gsub("_"," ") 
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = guiGetText(eBargainName) 
						if contactName == "" or contactName == "Kimliğiniz" then 
							contactName = "Bir müşteri" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Bay. "..contactName
							else
								contactName = "Bayan. "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Hey Patron! Oku bunu '"..contactContent.."', diyorki "..contactName..".")
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								guiSetText(bSend, "Gönder")
								guiSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) -- 5 minutes
						
						guiSetText(bSend, "(Başka bir mesaj gönderebimek için "..coolDownSend.." dakika beklemeniz gerekiyor)")
						guiSetEnabled(bSend, false)
						
						guiSetText(eContent, "")
						
					end 
					
					
				end, false )
			
				local bClose = guiCreateButton(0.5, 0.88, 0.49, 0.1, "Kapat", true, tGoodBye)
				addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
			end
			
			addEventHandler("onClientGUIDoubleClick", gProducts, function () 
				if products then 
					local row, col = guiGridListGetSelectedItem(gProducts)
					if (row==-1) or (col==-1) then
						--do nothing
					else  
						local proID = tostring(guiGridListGetItemText(gProducts, row, 5))
						if isClientBizOwner then
							triggerEvent("shop:ownerProductView", root,  products, proID, ped)
						else
							triggerEvent("shop:customShopBuy", root,  products, proID, ped)
						end
						
					end
				end
			end, false)
			setSoundVolume(playSound(":vrp_resources/sounds/inv_open.mp3"), 0.3)
		elseif shop_type==18 then --Faction Drop NPC - General Items
		elseif shop_type==19 then --Faction Drop NPC - Weapons
			if not canPlayerViewShop(localPlayer, ped) and not canPlayerAdminShop(localPlayer) then
				hideGeneralshopUI()
				sendRefusingLocalChat(ped)
				return false
			end
			
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 432
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			guiSetInputEnabled(true)
			showCursor(true)
			
			wCustomShop = guiCreateWindow(X,Y,Width,Height,"Birlik Marketi - ",false)
			guiWindowSetSizable(wCustomShop,false)
			
			local shopTabPanel = guiCreateTabPanel(9,26,738,396,false,wCustomShop)
			local tProducts = guiCreateTab ( "Ürünler" , shopTabPanel )
			fdgw.gProducts = guiCreateGridList ( 0, 0, 1, 0.9, true, tProducts)
			
			local lWelcomeText = guiCreateLabel(0,0.89,0.848,0.1,'Bir ürün almak için üzerine çift tıklayın!',true,tProducts)
			bCloseStatic = guiCreateButton(0.85, 0.90 , 0.15, 0.089, "Kapat", true, tProducts)
			guiSetFont(bCloseStatic, BizNoteFont2)
			addEventHandler( "onClientGUIClick", bCloseStatic,hideGeneralshopUI , false )
			
			guiLabelSetVerticalAlign(lWelcomeText,"center")
			guiLabelSetHorizontalAlign(lWelcomeText,"center",false)
			guiSetFont(lWelcomeText, BizNoteFont18)
			
			fdgw.colProductID = guiGridListAddColumn(fdgw.gProducts,"ID",0.08)
			fdgw.colName = guiGridListAddColumn(fdgw.gProducts,"İsim",0.18)
			fdgw.colPrice = guiGridListAddColumn(fdgw.gProducts,"Fiyat",0.08)
			fdgw.colDesc = guiGridListAddColumn(fdgw.gProducts,"Bilgi",0.4)
			fdgw.colQuantity = guiGridListAddColumn(fdgw.gProducts,"Stokta var",0.06)
			fdgw.colRestock = guiGridListAddColumn(fdgw.gProducts,"Yeniden stoklanması gerek",0.15)
			
			for _, record in ipairs(products) do
				local row = guiGridListAddRow(fdgw.gProducts)
				local itemName = exports["vrp_items"]:getItemName( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
				local itemValue = exports["vrp_items"]:getItemValue( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
				local description = exports["vrp_items"]:getItemDescription( tonumber(record["pItemID"]), itemValue ) 
				local itemPrice = exports.vrp_global:formatMoney(math.floor(tonumber(record["pPrice"] or 0))).. " $"
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colName, itemName or "Unknown", false, false)
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colPrice, itemPrice, false, true)
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colDesc, description, false, false)
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colQuantity, exports.vrp_global:formatMoney(record["pQuantity"]), false, false)
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colProductID, record["pID"], false, true)
				local pRestockInFinal = "Never"
				local pRestockInterval = tonumber(record["pRestockInterval"]) or 0
				local pRestockIn = record["pRestockIn"]
				if pRestockIn and tonumber(pRestockIn) and pRestockInterval > 0 then
					pRestockIn = tonumber(pRestockIn)
					if pRestockIn == 0 then
						pRestockInFinal = "Bugün"
					elseif pRestockIn == 1 then
						pRestockInFinal = "Yarın"
					elseif pRestockIn == 2 then
						pRestockInFinal = "Yarından sonrakigün"
					elseif pRestockIn > 2 then
						pRestockInFinal = pRestockIn.." Günler"
					end
				end
				outputDebugString(pRestockIn)
				guiGridListSetItemText(fdgw.gProducts, row, fdgw.colRestock,  pRestockInFinal, false, true)
			end
			
			addEventHandler("onClientGUIDoubleClick", fdgw.gProducts, function () 
				if products then 
					local row, col = guiGridListGetSelectedItem(fdgw.gProducts)
					if (row==-1) or (col==-1) then
						--do nothing
					else
						local quan = tostring(guiGridListGetItemText(fdgw.gProducts, row, 5))
						if tonumber(quan) <= 0 then
							exports.vrp_global:playSoundError()
							return false
						end
						local proID = tostring(guiGridListGetItemText(fdgw.gProducts, row, 1))
						togMainShop(false)
						triggerEvent("shop:factionDropWeaponBuy", localPlayer,  products, proID, ped)
					end
				end
			end, false)
			
			local updateConfigGUI = function()
				if ped and tProducts and lWelcomeText then
					if getElementData(ped, "faction_belong") <= 0 then
						guiSetEnabled(tProducts, false)
						if addItemBtn and isElement(addItemBtn) then
							guiSetEnabled(addItemBtn, false)
						end
						guiSetText(lWelcomeText, "Bu NPC Lider Admin tarafından düzenlenmeli.")
					else
						guiSetEnabled(tProducts, true)
						if addItemBtn and isElement(addItemBtn) then
							guiSetEnabled(addItemBtn, true)
						end
						guiSetText(lWelcomeText, "Birşey satın almak için üzerine çift tıklayın!")
					end
				end
			end
			updateConfigGUI()
			
			if canPlayerAdminShop(localPlayer) then
				addItemBtn = guiCreateButton(0.85-0.15, 0.90 , 0.15, 0.089, "İtem yarat", true, tProducts)
				guiSetFont(addItemBtn, BizNoteFont2)
				addEventHandler( "onClientGUIClick", addItemBtn,function()
					showCreateFactionDropItem(getElementData(ped, "dbid"))
				end, false )
			
			
			
				tBizManagement = guiCreateTab ( "Düzenlemeler" , shopTabPanel )
				local l1 = guiCreateLabel(11,19,716,56,"Birlik NPC düzenlemeleri",false,tBizManagement)
				guiLabelSetHorizontalAlign(l1,"center",false)
				guiSetFont(l1, BizNoteFont)
				
				local line = 40
				local col = 200
				local xOffset = 30
				local lTeam = guiCreateLabel(xOffset,line*3,716,56,"Birlik erişim izni:",false,tBizManagement)
				guiSetFont(lTeam, "default-bold-small")
				local cFaction =  guiCreateComboBox ( xOffset+col,line*3,col*2,56, "None", false, tBizManagement )
				local counter = 0
				local comboIndex1 = {}
				comboIndex1[0] = {"None", 0}
				guiComboBoxAddItem(cFaction, "None")
				local factions = getElementsByType("team")
				for i = 1, #factions do
					local factionName = getTeamName(factions[i])
					if factionName ~= "Citizen" then
						counter = counter + 1
						guiComboBoxAddItem(cFaction, factionName)
						comboIndex1[counter] = {getTeamName(factions[i]), getElementData(factions[i], "id")}
						outputDebugString(counter.." - "..tostring(getTeamName(factions[i])).." - ".. tostring(getElementData(factions[i], "id")))
					end
				end
				if counter > 2 then
					counter = counter - 1
				end
				exports.vrp_global:guiComboBoxAdjustHeight(cFaction, counter)
				guiComboBoxSetSelected ( cFaction, getComboIndexFromFactionID(comboIndex1,getElementData(ped, "faction_belong")) )
				
				local lMember = guiCreateLabel(xOffset,line*4,716,56,"Bu NPC'den kimler satın alabilir?:",false,tBizManagement)
				guiSetFont(lMember, "default-bold-small")
				local cMember =  guiCreateComboBox ( xOffset+col,line*4,col*2,56, "No-one", false, tBizManagement )
				guiComboBoxAddItem(cMember, "Kimse")
				guiComboBoxAddItem(cMember, "Liderler")
				guiComboBoxAddItem(cMember, "Liderler & Üyeler")
				exports.vrp_global:guiComboBoxAdjustHeight(cMember, 3)
				guiComboBoxSetSelected ( cMember, getElementData(ped, "faction_access") )
				
				local bSaveNpcConfigs = guiCreateButton(0.85-0.15, 0.90 , 0.15, 0.089, "Kaydet", true, tBizManagement)
				guiSetFont(bSaveNpcConfigs, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bSaveNpcConfigs,function()
					local selectedIndex1 = guiComboBoxGetSelected ( cFaction ) or 0
					outputDebugString("selectedIndex1 = "..tostring(selectedIndex1))
					local factionBelong = comboIndex1[selectedIndex1][2] or 0
					outputDebugString("comboIndex1[selectedIndex1][2] = "..tostring(comboIndex1[selectedIndex1][2]))
					local factionAccess = guiComboBoxGetSelected ( cMember ) or 0
					triggerServerEvent("saveFactionDropNPCConfigs", localPlayer, ped, factionBelong, factionAccess)
					timer_updateConfigGUI = setTimer(function()
						updateConfigGUI()
					end, 3000, 1)
				end, false )
				
				local bCloseStatic2 = guiCreateButton(0.85, 0.90 , 0.15, 0.089, "Kapat", true, tBizManagement)
				guiSetFont(bCloseStatic2, BizNoteFont2)
				addEventHandler( "onClientGUIClick", bCloseStatic2,hideGeneralshopUI , false )
			end
			setSoundVolume(playSound(":vrp_resources/sounds/inv_open.mp3"), 0.3)
		else
				--STATIC SHOP / MAXIME
			
			shop = g_shops[ shop_type ]

			if not shop or #shop == 0 then
				outputChatBox("Burası bir mağaza değil. Siktir git.")
				hideGeneralshopUI()
				return
			end

			if shop_type == 7 then
				if not exports.vrp_global:hasItem(localPlayer, 183) then -- Viozy Membership Card
					outputChatBox("Burada alışveriş yapmak için bir Viozy Üyelik Kartı edinmelisiniz!", 255, 0, 0)
					hideGeneralshopUI()
					return
				end
			end

			_G['shop_type'] = shop_type
			updateItems( shop_type, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
			
			--setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
			
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 556
			local Height = 542
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			local isClientBizOwner, bizName, bizNote, interiorSupplies, govOwned = isBizOwner(getLocalPlayer())
			
			if not bizName then
				bizName = ""
			end
			
			guiSetInputEnabled(true)
			showCursor(true)
			-- #forked:bekiroj
			wGeneralshop = guiCreateWindow(X,Y,Width,Height,"Market - "..shop.name.." ",false)
			guiWindowSetSizable(wGeneralshop,false)
			
			tabpanel = guiCreateTabPanel(9,26,638,516,false,wGeneralshop)
			-- create the tab panel with all shoppy items
			local counter = 1
			local bCloseStatic = {}
			for _, category in ipairs( shop ) do
				local tab = guiCreateTab( category.name, tabpanel )
				local grid =  guiCreateGridList ( 0, 0, 1, 0.9, true, tab)
				
				local cName = guiGridListAddColumn( grid, "İsim", 0.21 )
				local cPrice = guiGridListAddColumn( grid, "Fiyat", 0.1 )
				local cDescription = guiGridListAddColumn( grid, "Bilgi", 0.62 )
				
				local hasSkins = false
				for _, item in ipairs( category ) do
					local row = guiGridListAddRow( grid )
					guiGridListSetItemText( grid, row, cName, item.name, false, false )
					guiGridListSetItemData( grid, row, cName, tostring( counter ) )
					
					if item.minimum_age and getElementData(localPlayer, "age") < item.minimum_age then
						guiGridListSetItemText( grid, row, cPrice, "◊ " .. item.minimum_age .. " or older", false, false )
					else
						guiGridListSetItemText( grid, row, cPrice, tostring(exports.vrp_global:formatMoney(math.ceil(discount * item.price))).." $", false, false )
					end
					guiGridListSetItemText( grid, row, cDescription, item.description or "", false, false )
					
					if item.itemID == 16 then
						hasSkins = true
					end
					
					counter = counter + 1
				end
				
				if hasSkins then -- event handler for skin preview
					addEventHandler( "onClientGUIClick", grid, function( button, state )
						if button == "left" then
							local index, item = getSelectedItem( source )
							
							if iClothesPreview then
								destroyElement(iClothesPreview)
								iClothesPreview = nil
							end
							
							if item.itemID == 16 then
								iClothesPreview = guiCreateStaticImage( 620, 23, 100, 100, ":vrp_account/img/" .. ("%03d"):format( item.itemValue or 1 ) .. ".png", false, source)
							end
						end
					end, false )
				end
				
				addEventHandler( "onClientGUIDoubleClick", grid, function( button, state )
					if button == "left" then
						local index, item = getSelectedItem( source )
						if index then
							triggerServerEvent( "shop:buy", ped, index )
						end
					end
				end, false )
				
				bCloseStatic[_] = guiCreateButton(0, 0.90 , 1.0, 0.094, "Kapat", true, tab)
				guiSetFont(bCloseStatic[_], BizNoteFont2)
				addEventHandler( "onClientGUIClick", bCloseStatic[_], hideGeneralshopUI, false )
			end
			
			if isClientBizOwner then
				----------------------START EDIT CONTACT-------------------------------------------------------
				tGoodBye = guiCreateTab ( "İletişim bilgilerini güncelle" , tabpanel )
				guiSetInputEnabled(true)
				showCursor(true)
				local lTitle1 = guiCreateLabel(11,19,716,56,("İletişim bilgilerini güncelle - "..bizName),false,tGoodBye)
					--guiLabelSetVerticalAlign(lTitle1[1],"center")
					guiLabelSetHorizontalAlign(lTitle1,"center",false)
					guiSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.vrp_global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = guiCreateLabel(11,75,100,20,"- Sahibi:",false,tGoodBye)
				local eOwner = guiCreateEdit(111,75,600,20,sOwner,false,tGoodBye)
				local lPhone = guiCreateLabel(11,95,100,20,"- Telefon numarası:",false,tGoodBye)
				local ePhone = guiCreateEdit(111,95,600,20,sPhone,false,tGoodBye)
				local lEmail = guiCreateLabel(11,115,100,20,"- Email Adresi:",false,tGoodBye)
				local eEmail = guiCreateEdit(111,115,600,20,sEmail,false,tGoodBye)
				local lForums = guiCreateLabel(11,135,100,20,"((Forum ismi)):",false,tGoodBye)
				local eForums = guiCreateEdit(111,135,600,20,sForum,false,tGoodBye)
				
				guiEditSetMaxLength ( eOwner, 100 )
				guiEditSetMaxLength ( ePhone, 100 )
				guiEditSetMaxLength ( eEmail, 100 )
				guiEditSetMaxLength ( eForums, 100 )
				
				local lBizNote = guiCreateLabel(0.01,0.5,1,0.1,"- Biz Note:",true,tGoodBye)
				
				local eBizNote = guiCreateEdit ( 0.01, 0.58, 0.98, 0.1,bizNote, true, tGoodBye)
				guiEditSetMaxLength ( eBizNote, 100 )
				
				bSend = guiCreateButton(0.01, 0.88, 0.49, 0.1, "Kaydet", true, tGoodBye)	
				local contactName, contactContent = nil
				
				addEventHandler( "onClientGUIClick", bSend, function()
					if guiGetText(eBizNote) ~= "" then
						triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(),getLocalPlayer(), "setbiznote", guiGetText(eBizNote))
					end
					
					if guiGetText(ePhone) ~= "" and not tonumber(guiGetText(ePhone)) then
						guiSetText(ePhone, "Geçersiz Numara")
					else
						triggerServerEvent("shop:saveContactInfo", getLocalPlayer(), ped, {guiGetText(eOwner),guiGetText(ePhone),guiGetText(eEmail),guiGetText(eForums)})
						hideGeneralshopUI()
					end
					
					
				end, false ) 
			
				local bClose = guiCreateButton(0.5, 0.88, 0.49, 0.1, "Kapat", true, tGoodBye)
				addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
			
				if shop_type ~= 14 then -- Lazy fix for non-profitable carpart shop,  maxime
					----------------------START BIZ MANAGEMENT-------------------------------------------------------
					local GUIEditor_Memo = {}
					local GUIEditor_Label = {}
					
					tBizManagement = guiCreateTab ( "İş yönetimi" , tabpanel )
					
					GUIEditor_Label[1] = guiCreateLabel(11,19,716,56,"İş yönetimi - "..bizName or "",false,tBizManagement)
						--guiLabelSetVerticalAlign(GUIEditor_Label[1],"center")
						guiLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)
						guiSetFont(GUIEditor_Label[1], BizNoteFont)
				
					local sIncome = tonumber(getElementData(ped, "sIncome")) or 0
					local sPendingWage = tonumber(getElementData(ped, "sPendingWage")) or 0
					local sSales = getElementData(ped, "sSales") or ""
					local sProfit = sIncome-sPendingWage
					
					GUIEditor_Label[2] = guiCreateLabel(11,75,716,20,"- Kalan Malzemeler: "..interiorSupplies.." kg(s)",false,tBizManagement)
					GUIEditor_Label[3] = guiCreateLabel(11,95,716,20,"- Gelir: $"..exports.vrp_global:formatMoney(sIncome),false,tBizManagement)
					GUIEditor_Label[4] = guiCreateLabel(11,115,716,20,"- Personel ödemesi: $"..exports.vrp_global:formatMoney(sPendingWage).." (Already bound to interior taxes)",false,tBizManagement)
					GUIEditor_Label[5] = guiCreateLabel(11,135,716,20,"- kâr: $"..exports.vrp_global:formatMoney(sProfit),false,tBizManagement)
					GUIEditor_Label[6] = guiCreateLabel(11,155,57,19,"- Satışlar: ",false,tBizManagement)
					GUIEditor_Memo[1] = guiCreateMemo(11,179,498,184,sSales,false,tBizManagement)
					guiMemoSetReadOnly(GUIEditor_Memo[1], true)
					
					if sProfit < 0 then
						guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
						if sProfit < (0 - warningDebtAmount) then 
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Uyarı: Eğer borcunuz varsa $"..exports.vrp_global:formatMoney(limitDebtAmount)..", Çalışanlarınız işten ayrılacaktır)." )
							guiLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
							
						end
					elseif sProfit == 0 then
					else
						if sProfit < 500 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Ortalama).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 255, 0)
						elseif sProfit >= 500 and sProfit < 1000 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (İyi!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 245, 0)
						elseif sProfit >= 1000 and sProfit < 2000 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Çok iyi!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 235, 0)
						elseif sProfit >= 2000 and sProfit < 4000 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Mükemmel!!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 225, 0)
						elseif sProfit >= 4000 and sProfit < 8000 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (Beklenmedik!!!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 215, 0)
						elseif sProfit >= 8000 and sProfit < 20000 then
							guiSetText(GUIEditor_Label[5] , "- Profit: $"..exports.vrp_global:formatMoney(sProfit).." (İnanılmaz!!!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 205, 0)
						elseif sProfit >= 20000 then
							guiSetText(GUIEditor_Label[5] , "- kâr: $"..exports.vrp_global:formatMoney(sProfit).." (İşin kralıyız!!!!).")
							guiLabelSetColor ( GUIEditor_Label[5], 0, 195, 0)
						end
					end
					
					---------------------
					setElementData(ped, "orderingSupplies", 0)
					local bOrderSupplies = guiCreateButton(0.695, 0.48, 0.3, 0.1, "Malzeme siparişi gönder ("..getElementData(ped, "orderingSupplies").." kgs)", true, tBizManagement)
					guiSetFont(bOrderSupplies, BizNoteFont2)
					guiSetEnabled(bOrderSupplies, false)
					addEventHandler( "onClientGUIClick", bOrderSupplies, function ()
						guiSetEnabled(bOrderSupplies, false)
						triggerServerEvent("shop:shopRemoteOrderSupplies", getLocalPlayer(), getLocalPlayer(), getElementDimension(getLocalPlayer()), getElementData(ped, "orderingSupplies"))
						setElementData(ped, "orderingSupplies", 0 )
					end, false )
					-------------------------
					local bExpand = guiCreateButton(0.695, 0.58, 0.15, 0.1, "Malzemeler(+)", true, tBizManagement)
					guiSetFont(bExpand, BizNoteFont2)
					
					addEventHandler( "onClientGUIClick", bExpand, function ()
						local supplies = getElementData(ped, "orderingSupplies")
						setElementData(ped, "orderingSupplies", supplies + 10 )
					end, false )
					
					-------------------------
					
					bShrink = guiCreateButton(0.845, 0.58, 0.15, 0.1, "Malzemeler(-)", true, tBizManagement)
					guiSetFont(bShrink, BizNoteFont2)
					
					addEventHandler( "onClientGUIClick", bShrink, function ()
						local supplies = getElementData(ped, "orderingSupplies")
						if supplies >= 10 then
							setElementData(ped, "orderingSupplies", supplies - 10)
						end
					end, false )
					
					addEventHandler( "onClientElementDataChange", ped, function(n)
						if n == "orderingSupplies" then
							syncClientDisplaying()
						end
					end, false)
					
					function syncClientDisplaying()
						local supplies = getElementData(ped, "orderingSupplies") 
						if supplies > 0 then
							guiSetEnabled(bShrink, true)
							guiSetEnabled(bOrderSupplies, true)
						else
							guiSetEnabled(bShrink, false)
							guiSetEnabled(bOrderSupplies, false)
						end
						guiSetText(bOrderSupplies, "Malzeme siparişi gönder ("..supplies.." kgs)")
					end
					
					---------------------------
					local bClearSaleLogs = guiCreateButton(0.695, 0.68, 0.3, 0.1, "Satış defterini temizle", true, tBizManagement)
					guiSetFont(bClearSaleLogs, BizNoteFont2)
					addEventHandler( "onClientGUIClick", bClearSaleLogs, function ()
						guiSetText(GUIEditor_Memo[1],"")
						setElementData(ped, "sSales", "", true)
						triggerServerEvent("shop:updateSaleLogs", getLocalPlayer(), getLocalPlayer(), getElementData(ped, "dbid") , "")
					end, false )
					
					--------------------------------
					--[[
					local bPayWage = guiCreateButton(0.695, 0.68, 0.3, 0.1, "Pay Staff", true, tBizManagement)
					guiSetFont(bPayWage, BizNoteFont2)
					if sPendingWage > 0 then
						addEventHandler( "onClientGUIClick", bPayWage, function ()
							guiSetVisible(wCustomShop, false)
							triggerServerEvent("shop:solvePendingWage", getLocalPlayer(), getLocalPlayer(), ped)
							hideGeneralshopUI()
						end, false )
					else
						guiSetEnabled(bPayWage, false)
					end
					]]
					--------------------------------
					
					local bCollectProfit = guiCreateButton(0.695, 0.78, 0.3, 0.1, "kâr'ı topla", true, tBizManagement)
					guiSetFont(bCollectProfit, BizNoteFont2)
					if govOwned then
						guiSetEnabled(bCollectProfit, false)
					else
						if (sPendingWage > 0) or (sIncome > 0) then
							addEventHandler( "onClientGUIClick", bCollectProfit, function ()
								triggerServerEvent("shop:collectMoney", getLocalPlayer(), getLocalPlayer(), ped)
								hideGeneralshopUI()
							end, false )
						else
							guiSetEnabled(bCollectProfit, false)
						end
					end
					local bClose = guiCreateButton(0.695, 0.88, 0.3, 0.1, "Kapat", true, tBizManagement)
					guiSetFont(bClose, BizNoteFont2)
					addEventHandler( "onClientGUIClick", bClose, hideGeneralshopUI, false )
				end
			end
			setSoundVolume(playSound(":vrp_resources/sounds/inv_open.mp3"), 0.3)
		end
	end
end
addEvent("showGeneralshopUI", true )
addEventHandler("showGeneralshopUI", getResourceRootElement(), showGeneralshopUI)

function isBizOwner(player)
	local key = getElementDimension(player)
	local possibleInteriors = getElementsByType("interior")
	local isOwner = false
	local interiorName = false
	local interiorBizNote = nil
	local interiorSupplies = 0
	local govOwned = true
	for _, interior in ipairs(possibleInteriors) do
		if tonumber(key) == getElementData(interior, "dbid") then
			interiorName = getElementData(interior, "name") or ""
			interiorBizNote = getElementData(interior, "business:note") or ""
			local status = getElementData(interior, "status")
			interiorSupplies = status[6] or 0
			if tonumber(status[4]) == tonumber(getElementData(player, "dbid")) then
				if status[1] ~= 2 then
					isOwner = true
					govOwned = false
					break
				end
			end
		end
	end	
	
	if not interiorName then
		return false, false, false, false, false
	end

	return isOwner, interiorName, interiorBizNote, interiorSupplies, govOwned
end


function hideGeneralshopUI()
	if timer_updateConfigGUI and isTimer(timer_updateConfigGUI) then
		killTimer(timer_updateConfigGUI)
	end
	triggerServerEvent("shop:removeMeFromCurrentShopUser", localPlayer, localPlayer)
	--outputDebugString("Triggered")
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	setTimer(function ()
		setElementData(getLocalPlayer(), "shop:NoAccess", false, true )
	end, 50, 1)
	guiSetInputEnabled(false)
	showCursor(false)
	if wGeneralshop then
		destroyElement(wGeneralshop)
		wGeneralshop = nil
		setSoundVolume(playSound(":vrp_resources/sounds/inv_close.mp3"), 0.3)
	end
	if wCustomShop then
		destroyElement(wCustomShop)
		wCustomShop = nil
		setSoundVolume(playSound(":vrp_resources/sounds/inv_close.mp3"), 0.3)
	end
	closeOwnerProductView()
	closeAddingItemWindow()
	closeCustomShopBuy()
end
addEvent("hideGeneralshopUI", true )
addEventHandler("hideGeneralshopUI", getRootElement(), hideGeneralshopUI)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function() 
	if wGeneralshop ~= nil then 
		hideGeneralshopUI() 
	end 
	setElementData(getLocalPlayer(), "shop:NoAccess", false, true)
	setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
end)

function sendRefusingLocalChat(theShop)
	local says = {
		"Siktir git!",
		"Kaybol burdan!",
		"Sen kimsin?",
		"Evine git!",
		"Seni tanıyormuyum, Kardeşim?",
	}
	local ran = math.random(1, #says)
	local say = says[ran]
	local pedName = getElementData(theShop, "name")
	triggerServerEvent("shop:storeKeeperSay", localPlayer, localPlayer, say, pedName)
end


function factionDropUpdateWeaponList(newItems)
	products = newItems
	if fdgw.gProducts and isElement(fdgw.gProducts) then
		guiGridListClear(fdgw.gProducts)
		for _, record in ipairs(products) do
			local row = guiGridListAddRow(fdgw.gProducts)
			local itemName = exports["vrp_items"]:getItemName( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
			local itemValue = ""
			if not exports["vrp_items"]:getItemHideItemValue(tonumber(record["pItemID"])) then
				itemValue = exports["vrp_items"]:getItemValue( tonumber(record["pItemID"]), tostring(record["pItemValue"]) )
			end
			local description = exports["vrp_items"]:getItemDescription( tonumber(record["pItemID"]), itemValue ) 
			local itemPrice = exports.vrp_global:formatMoney(math.floor(tonumber(record["pPrice"] or 0))).. " $"
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colName, itemName or "Unknown", false, false)
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colPrice, itemPrice, false, true)
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colDesc, description, false, false)
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colQuantity, exports.vrp_global:formatMoney(record["pQuantity"]), false, false)
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colProductID, record["pID"], false, true)
			local pRestockInFinal = "Never"
			local pRestockInterval = tonumber(record["pRestockInterval"]) or 0
			local pRestockIn = record["pRestockIn"]
			if pRestockIn and tonumber(pRestockIn) and pRestockInterval > 0 then
				pRestockIn = tonumber(pRestockIn)
				if pRestockIn == 0 then
					pRestockInFinal = "Bugün"
				elseif pRestockIn == 1 then
					pRestockInFinal = "Yarın"
				elseif pRestockIn == 2 then
					pRestockInFinal = "Yarından sonraki ün"
				elseif pRestockIn > 2 then
					pRestockInFinal = pRestockIn.." Günler"
				end
			end
			outputDebugString(pRestockIn)
			guiGridListSetItemText(fdgw.gProducts, row, fdgw.colRestock,  pRestockInFinal, false, true)
		end
	end
end
addEvent("shop:factionDropUpdateWeaponList", true)
addEventHandler( "shop:factionDropUpdateWeaponList", root, factionDropUpdateWeaponList)

function togMainShop(state)
	if wCustomShop and isElement(wCustomShop) then
		guiSetEnabled(wCustomShop, state)
	end
end