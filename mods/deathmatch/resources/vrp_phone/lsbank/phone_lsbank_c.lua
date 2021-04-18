local BankGUIs = {}
function toggleLSBank(state)
	if state then
		isBankShowing = true
		isBankShowingLogged = false
		createBankMenu()
		guiSetInputEnabled(true)
		addEventHandler("onClientGUIClick", root, clickBankFunctions)
	else
		isBankShowing = false
		guiSetInputEnabled(false)
		isBankShowingLogged = false
		for k,v in ipairs(BankGUIs) do
			if isElement(v) then
				destroyElement(v)
			end
		end
		removeEventHandler("onClientGUIClick", root, clickBankFunctions)
	end
end

addEvent("logging:lsBank", true)
addEventHandler("logging:lsBank", root,
	function()
		isBankShowingLogged = true
		guiSetVisible(BankGUIs[2], false)
		guiSetVisible(BankGUIs[3], false)
		guiSetVisible(BankGUIs[4], false)
		
		guiSetVisible(BankGUIs[5], true)
		guiSetVisible(BankGUIs[6], true)
		guiSetVisible(BankGUIs[7], true)
		guiSetVisible(BankGUIs[8], true)
	end
)

function createBankMenu()
	BankGUIs[1] = guiCreateButton(20,70,24,24,"",false,wPhoneMenu)
	guiSetAlpha(BankGUIs[1],0)
	addEventHandler("onClientGUIClick", BankGUIs[1], function(state) if state == "left" and source == BankGUIs[1] then toggleOffEverything() togglePhoneHome(true) end end)

	--cart number
	BankGUIs[2] = guiCreateEdit(50,292,200,33,"",false,wPhoneMenu)
	guiEditSetMaxLength(BankGUIs[2], 19)
	--[[
	curCardText = ""
	addEventHandler("onClientGUIChanged", BankGUIs[2], function(element) 
		if guiGetText(element) == "" or tonumber(guiGetText(element)) then
		   	curCardText = guiGetText(element)
		else
		    guiSetText(element, curCardText)
		end
	end)
	]]--
	--password
	BankGUIs[3] = guiCreateEdit(50,329,200,33,"",false,wPhoneMenu)
	guiEditSetMaxLength(BankGUIs[3], 4)
	guiEditSetMasked(BankGUIs[3], true )
	guiSetProperty(BankGUIs[3], 'MaskCodepoint', '8226' )
	curPasswordText = ""
	addEventHandler("onClientGUIChanged", BankGUIs[3], function(element) 
		if guiGetText(element) == "" or tonumber(guiGetText(element)) then
		   	curPasswordText = guiGetText(element)
		else
		    guiSetText(element, curPasswordText)
		end
	end)
	--log-in
	BankGUIs[4] = guiCreateButton(40,378,185,30,"",false,wPhoneMenu)
	guiSetAlpha(BankGUIs[4],0)


	---############ LOGGED MENU ################--
	y = 45
	--from
	BankGUIs[5] = guiCreateEdit(50,292+y,200,33,"",false,wPhoneMenu)
	guiSetVisible(BankGUIs[5], false)
	guiEditSetMaxLength(BankGUIs[5], 16)

	--value of money
	BankGUIs[6] = guiCreateEdit(50,329+y,200,33,"",false,wPhoneMenu)
	guiSetVisible(BankGUIs[6], false)
	guiEditSetMaxLength(BankGUIs[6], 7)

	--log-in
	BankGUIs[7] = guiCreateButton(40,378+y,185,30,"",false,wPhoneMenu)
	guiSetAlpha(BankGUIs[7],0)
	guiSetVisible(BankGUIs[7], false)

	BankGUIs[8] = guiCreateLabel(45,270,185,30,"Bakiye: $"..getElementData(localPlayer,"bankmoney"),false,wPhoneMenu)
	guiSetVisible(BankGUIs[8], false)

end

function clickBankFunctions(state)
	if state == "left" then
		if source == BankGUIs[4] then
			if isTimer(spamTimer) then return end
			spamTimer = setTimer(function() killTimer(spamTimer) end, 1250, 1)
			triggerServerEvent("logIn:lsbank", localPlayer, localPlayer, guiGetText(BankGUIs[2]), guiGetText(BankGUIs[3]))
		elseif source == BankGUIs[7] then
			local amount = tonumber(guiGetText(BankGUIs[6]))
			local money = getElementData(localPlayer, "bankmoney")
			local playername = guiGetText(BankGUIs[5])

			if not amount or amount <= 0 or math.ceil( amount ) ~= amount then
				outputChatBox("[!] #ffffffLütfen pozitif değer giriniz.", 255, 0, 0, true)
			elseif (amount>money) then
				outputChatBox("[!] #ffffffBanka hesabınızda yeterli para yok.", 255, 0, 0, true)
			elseif playername == "" then
				outputChatBox("[!] #ffffffLütfen parayı göndermek istediğiniz kişinin adını tam girin.", 255, 0, 0, true)
			else
				triggerServerEvent("transferMoneyToPersonal", localPlayer, false, playername, amount, "LSBANK > Mobile Transfer")
				guiSetText(BankGUIs[6], "0")
				guiSetText(BankGUIs[8], "Bakiye: $"..getElementData(localPlayer, "bankmoney")-amount)
				guiSetText(BankGUIs[5], "Örnk: David Beckham")
			end
		end
	end
end





