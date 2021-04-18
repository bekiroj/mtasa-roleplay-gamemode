wRightClick = nil
bAddAsFriend, bFrisk, bRestrain, bCloseMenu, bInformation, bBlindfold, bStabilize = nil
sent = false
ax, ay = nil
player = nil
gotClick = false
closing = false

function clickPlayer(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if (element) and (getElementType(element)=="player") and (button=="right") and (state=="down") and (sent==false) then
		local x, y, z = getElementPosition(getLocalPlayer())
		
		if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=5) then
			if (wRightClick) then
				hidePlayerMenu()
			end
			--showCursor(true)
			ax = absX
			ay = absY
			player = element
			sent = true
			closing = false
			
			if(element == getLocalPlayer()) then
				showPlayerSelfMenu()
			else
				showPlayerMenu(player, isFriendOf(getElementData(player, "account:id")))
			end
		end
	end
end
addEventHandler("onClientClick", getRootElement(), clickPlayer, true)

function showPlayerSelfMenu()
	local row = {}
	local rcMenu
	local playerid = tonumber(getElementData(getLocalPlayer(), "playerid")) or 0

	if getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher") then
		if not rcMenu then
			rcMenu = exports['vrp_rightclick']:create("Me ("..tostring(playerid)..")")
		end
		row.stretcher = exports['vrp_rightclick']:addRow("Sedyeyi bırak")
		addEventHandler("onClientGUIClick", row.stretcher, leaveStretcher, false)
	end
	sent = false
end

function showPlayerMenu(targetPlayer, friend)
	local row = {}
	local rcMenu
	local playerid = tonumber(getElementData(targetPlayer, "playerid")) or 0
	rcMenu = exports.vrp_rightclick:create(string.gsub(exports.vrp_global:getPlayerName(targetPlayer), "_", " ").." ("..tostring(playerid)..")")
	
	if not friend then
		bAddAsFriend = exports['vrp_rightclick']:addRow("Arkadaş Ekle")
		addEventHandler("onClientGUIClick", bAddAsFriend, caddFriend, false)
	else
		bAddAsFriend = exports['vrp_rightclick']:addRow("Arkadaşlıktan çıkar")
		addEventHandler("onClientGUIClick", bAddAsFriend, cremoveFriend, false)
	end

	-- FRISK
	bFrisk = exports['vrp_rightclick']:addRow("Üstünü Ara")
	addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	
	-- RESTRAIN
	local cuffed = getElementData(player, "Kelepçele")
	if cuffed == 0 then
		bRestrain = exports['vrp_rightclick']:addRow("Restrain")
		addEventHandler("onClientGUIClick", bRestrain, crestrainPlayer, false)
	else
		bRestrain = exports['vrp_rightclick']:addRow("Kelepçeyi çıkar")
		addEventHandler("onClientGUIClick", bRestrain, cunrestrainPlayer, false)
		-- FRISK
		bFrisk = exports['vrp_rightclick']:addRow("Üstünü Ara")
		addEventHandler("onClientGUIClick", bFrisk, cfriskPlayer, false)
	end
	
	-- BLINDFOLD
	local blindfold = getElementData(player, "Göz Bandı")
	if (blindfold) and (blindfold == 1) then
		bBlindfold = exports['vrp_rightclick']:addRow("Göz Bandını Çıkar")
		addEventHandler("onClientGUIClick", bBlindfold, cremoveBlindfold, false)
	else
		bBlindfold = exports['vrp_rightclick']:addRow("Göz Bandı")
		addEventHandler("onClientGUIClick", bBlindfold, cBlindfold, false)
	end
	
	-- STABILIZE
	if exports.vrp_global:hasItem(getLocalPlayer(), 70) and getElementData(player, "injuriedanimation") then
		bStabilize = exports['vrp_rightclick']:addRow("Stabilize")
		addEventHandler("onClientGUIClick", bStabilize, cStabilize, false)
	end

	-- Stretcher system
	local stretcherElement = getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher") 
	if stretcherElement then
		local stretcherPlayer = getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
		if stretcherPlayer and stretcherPlayer == player then
			bStabilize = exports['vrp_rightclick']:addRow("Sedye al")
			addEventHandler("onClientGUIClick", bStabilize, fTakeFromStretcher, false)
		end
		if not stretcherPlayer then
			bStabilize = exports['vrp_rightclick']:addRow("Sedyeye Yatır")
			addEventHandler("onClientGUIClick", bStabilize, fLayOnStretcher, false)
		end
	end
	
	bInformation = exports['vrp_rightclick']:addRow("Bilgi")
	addEventHandler("onClientGUIClick", bInformation, showPlayerInfo, false)

	sent = false
end
addEvent("displayPlayerMenu", true)
addEventHandler("displayPlayerMenu", getRootElement(), showPlayerMenu)

function fTakeFromStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:takePedFromStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function fLayOnStretcher(button, state)
	if button == "left" and state == "up" then
		triggerServerEvent("stretcher:movePedOntoStretcher", getLocalPlayer(), player)
		hidePlayerMenu()
	end
end

function leaveStretcher()
	triggerServerEvent("stretcher:leaveStretcher", getLocalPlayer())
end

function showPlayerInfo(button, state)
	if (button=="left") then
		triggerServerEvent("social:look", player)
		hidePlayerMenu()
	end
end


--------------------
--   STABILIZING  --
--------------------

function cStabilize(button, state)
	if button == "left" and state == "up" then
		if (exports.vrp_global:hasItem(getLocalPlayer(), 70)) then -- Has First Aid Kit?
			local knockedout = getElementData(player, "injuriedanimation")
			
			if not knockedout then
				outputChatBox("Bu oyuncu bayılmamış.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("stabilizePlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("İlk yardım çantan yok.", 255, 0, 0)
		end
	end
end

--------------------
--  BLINDFOLDING  --
-------------------
function cBlindfold(button, state, x, y)
	if (button=="left") then
		if (exports.vrp_global:hasItem(getLocalPlayer(), 66)) then -- Has blindfold?
			local blindfolded = getElementData(player, "blindfold")
			local restrained = getElementData(player, "restrain")
			
			if (blindfolded==1) then
				outputChatBox("Bu oyuncunun gözleri zaten bağlanmış.", 255, 0, 0)
				hidePlayerMenu()
			elseif (restrained==0) then
				outputChatBox("Oyuncuya göz bandı takabilmeniz için ilk önce oyuncuyu kelepçelemeniz gerekiyor.", 255, 0, 0)
				hidePlayerMenu()
			else
				triggerServerEvent("blindfoldPlayer", getLocalPlayer(), player)
				hidePlayerMenu()
			end
		else
			outputChatBox("Göz bandınız bulunmuyor.", 255, 0, 0)
		end
	end
end

function cremoveBlindfold(button, state, x, y)
	if (button=="left") then
		local blindfolded = getElementData(player, "blindfold")
		if (blindfolded==1) then
			triggerServerEvent("removeBlindfold", getLocalPlayer(), player)
			hidePlayerMenu()
		else
			outputChatBox("Bu oyuncunun gözü kapalı değil.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

--------------------
--  RESTRAINING   --
--------------------
function crestrainPlayer(button, state, x, y)
	if (button=="left") then
		if (exports.vrp_global:hasItem(getLocalPlayer(), 45) or exports.vrp_global:hasItem(getLocalPlayer(), 46)) then
			local restrained = getElementData(player, "restrain")
			
			if (restrained==1) then
				outputChatBox("Bu oyuncu zaten kelepçeli.", 255, 0, 0)
				hidePlayerMenu()
			else
				local restrainedObj
				
				if (exports.vrp_global:hasItem(getLocalPlayer(), 45)) then
					restrainedObj = 45
				elseif (exports.vrp_global:hasItem(getLocalPlayer(), 46)) then
					restrainedObj = 46
				end
					
				triggerServerEvent("restrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			end
		else
			outputChatBox("Kelepçeniz bulunmuyor.", 255, 0, 0)
			hidePlayerMenu()
		end
	end
end

function cunrestrainPlayer(button, state, x, y)
	if (button=="left") then
		local restrained = getElementData(player, "restrain")
		
		if (restrained==0) then
			outputChatBox("Bu karakter kelepçeli değil.", 255, 0, 0)
			hidePlayerMenu()
		else
			local restrainedObj = getElementData(player, "restrainedObj")
			local dbid = getElementData(player, "dbid")
			
			if (exports.vrp_global:hasItem(getLocalPlayer(), 47, dbid)) or (restrainedObj==46) then -- has the keys, or its a rope
				triggerServerEvent("unrestrainPlayer", getLocalPlayer(), player, restrainedObj)
				hidePlayerMenu()
			else
				outputChatBox("Bu kelepçenin anahtarına sahip değilsin.", 255, 0, 0)
			end
		end
	end
end
--------------------
-- END RESTRAINING--
--------------------

--------------------
--    FRISKING    --
--------------------

gx, gy, wFriskItems, bFriskTakeItem, bFriskClose, gFriskItems, FriskColName = nil
function cfriskPlayer(button, state, x, y)
	if (button=="left") then
		destroyElement(wRightClick)
		wRightClick = nil
		
		local restrained = getElementData(player, "restrain")
		local injured = getElementData(player, "injuriedanimation")
		
		if restrained ~= 1 and not injured then
			outputChatBox("Bu karakter baygın yada kelepçeli değil.", 255, 0, 0)
			hidePlayerMenu()
		--[[elseif getElementHealth(getLocalPlayer()) < 50 then
			outputChatBox("You need at least half health to frisk someone.", 255, 0, 0)
			hidePlayerMenu()]]--
		else
			gx = x
			gy = y
			triggerServerEvent("friskShowItems", getLocalPlayer(), player)
		end
	end
end

function friskShowItems(items)
	if wFriskItems then
		destroyElement( wFriskItems )
	end
	
	addEventHandler("onClientPlayerQuit", source, hidePlayerMenu)
	local playerName = string.gsub(getPlayerName(source), "_", " ")
	triggerServerEvent("sendLocalMeAction", getLocalPlayer(), getLocalPlayer(), "elleri ile " .. playerName .. " isimli şahısın üstünü aramaya başlar.")
	local width, height = 300, 200
	
	wFriskItems = guiCreateWindow(gx, gy, width, height, "Üst Arama: " .. playerName, false)
	guiSetText(wFriskItems, "Aranan: " .. playerName)
	guiWindowSetSizable(wFriskItems, false)
	
	gFriskItems = guiCreateGridList(0.05, 0.1, 0.9, 0.7, true, wFriskItems)
	FriskColName = guiGridListAddColumn(gFriskItems, "İsim", 0.9)
	
	for k, v in ipairs(items) do
		local itemName = v[1] ~= 80 and exports.vrp_global:getItemName(v[1]) or v[2]
		local row = guiGridListAddRow(gFriskItems)
		guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
		guiGridListSetSortingEnabled(gFriskItems, false)
	end
	
	-- WEAPONS
	for i = 0, 12 do
		if (getPedWeapon(source, i)>0) then
			local ammo = getPedTotalAmmo(source, i)
			
			if (ammo>0) then
				local itemName = getWeaponNameFromID(getPedWeapon(source, i))
				local row = guiGridListAddRow(gFriskItems)
				guiGridListSetItemText(gFriskItems, row, FriskColName, tostring(itemName), false, false)
				guiGridListSetSortingEnabled(gFriskItems, false)
			end
		end
	end
	
	bFriskClose = guiCreateButton(0.05, 0.85, 0.9, 0.1, "Kapat", true, wFriskItems)
	addEventHandler("onClientGUIClick", bFriskClose, hidePlayerMenu, false)
end
addEvent("friskShowItems", true)
addEventHandler("friskShowItems", getRootElement(), friskShowItems)
--------------------
--  END FRISKING  --
--------------------

function caddFriend()
	triggerServerEvent("addFriend", getLocalPlayer(), player)
	hidePlayerMenu()
end

function cremoveFriend()
	triggerServerEvent("social:remove", getLocalPlayer(), getElementData(player, "account:id"))
	hidePlayerMenu()
end

function hidePlayerMenu()
	if (isElement(bAddAsFriend)) then
		destroyElement(bAddAsFriend)
	end
	bAddAsFriend = nil
	
	if (isElement(bCloseMenu)) then
		destroyElement(bCloseMenu)
	end
	bCloseMenu = nil

	if (isElement(wRightClick)) then
		destroyElement(wRightClick)
	end
	wRightClick = nil

	if (isElement(wFriskItems)) then
		destroyElement(wFriskItems)
	end
	wFriskItems = nil
	
	ax = nil
	ay = nil
	
	description = nil
	age = nil
	weight = nil
	height = nil
	
	if player then
		removeEventHandler("onClientPlayerQuit", player, hidePlayerMenu)
	end
	
	sent = false
	player = nil
	
	showCursor(false)
end

function checkMenuWasted()
	if source == getLocalPlayer() or source == player then
		hidePlayerMenu()
	end
end

addEventHandler("onClientPlayerWasted", getRootElement(), checkMenuWasted)