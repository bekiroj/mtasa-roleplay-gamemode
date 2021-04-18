BankClass = {
    peds = {
        {2243.775390625, -1828.3486328125, 1625.6234130859, 83, 101, 183.09269714355}
		
	};
	ScreenSize = Vector2(guiGetScreenSize());
	
    onReady = function(self)
        for index, value in ipairs(BankClass.peds) do
            banking_ped = createPed(290, value[1], value[2], value[3]);
            banking_ped:setDimension(value[4]);
            banking_ped:setInterior(value[5]);
			banking_ped:setRotation(0, 0, value[6]);
			banking_ped.frozen = true;
            banking_ped:setData('bank-operation', true);
        end
    end;
    onClick = function(self, element)
		if guiGetVisible(BankClass.BankBrowser) == false then
			local x, y, z = getElementPosition(localPlayer)
			local x2, y2, z2 = getElementPosition(self)
			if distance(x, y, x2, y2) <= 4 and self:getData('bank-operation') then
				BankClass.onGUICreate();
			end
		end
    end;
   
	onGUIReady = function(self)
		if guiGetVisible(BankClass.BankBrowser) == true then
			BankReceiver:executeJavascript("show('waiting');");
			if isTimer(BankClass.timer) then killTimer(BankClass.timer) end
			BankClass.timer = Timer(
				function()
					if isElement(BankClass.BankBrowser) and BankReceiver then
						BankReceiver:executeJavascript("change('curbalance', '"..exports.vrp_global:formatMoney(localPlayer:getData("bankmoney")).."')");
						BankReceiver:executeJavascript("change('username1', '"..(localPlayer.name).."')");
						guiSetInputEnabled(true)
						if getElementData(localPlayer, "loggedin") ~= 1 then
							BankClass.onGUIClose()
						end
					end
				end,
			100, 0)
		end
	end;
	onGUICreate = function(self)
		if guiGetVisible(BankClass.BankBrowser) == false then
			guiSetVisible(BankClass.BankBrowser, true)
			guiSetInputEnabled(true)
			BankReceiver:executeJavascript("show('waiting');");
			if isTimer(BankClass.timer) then killTimer(BankClass.timer) end
			BankClass.timer = Timer(
				function()
					if isElement(BankClass.BankBrowser) and BankReceiver then
						BankReceiver:executeJavascript("change('curbalance', '"..exports.vrp_global:formatMoney(localPlayer:getData("bankmoney")).."')");
						BankReceiver:executeJavascript("change('username1', '"..(localPlayer.name).."')");
						guiSetInputEnabled(true)
						if getElementData(localPlayer, "loggedin") ~= 1 then
							BankClass.onGUIClose()
						end
					end
				end,
			100, 0)
		end
    end;
    onGUIClose = function(self)
		if guiGetVisible(BankClass.BankBrowser) == true then
            guiSetVisible(BankClass.BankBrowser, false)
			killTimer(BankClass.timer)
			guiSetInputEnabled(false)
        end
    end;
}
BankClass.BankBrowser = GuiBrowser(0, 0, BankClass.ScreenSize.x, BankClass.ScreenSize.y, true, true, false, false);
guiSetVisible(BankClass.BankBrowser, false)
guiSetInputEnabled(false)
showCursor(false)
addEventHandler('onClientBrowserCreated', BankClass.BankBrowser,
	function() 
		source:loadURL("http://mta/local/html/index.html");
		BankReceiver = source;
	end
)
instance = BankClass--new(BankClass);

function distance( x1, y1, x2, y2 )
	return math.sqrt( (x2-x1)^2 + (y2-y1)^2 )
end
addEvent('BankBrowser-CloseBrowser', true)
addEvent('BankBrowser-ReadyBrowser', true)
addEvent('BankBrowser-DepositMoney', true)
addEvent('BankBrowser-WidthrawMoney', true)
addEventHandler('onClientResourceStart', resourceRoot, function() instance.onReady(); end)
addEventHandler('onClientClick', root, function(b,s,_,_,_,_,_,element) if b == 'right' and s == 'down' and element and (isElement(element) and element.type == 'ped') or (isElement(element) and element.type == 'object') and element:getData('bank-operation') then instance.onClick(element) end end)
addEventHandler('BankBrowser-CloseBrowser', root, function() instance.onGUIClose(); end)
addEventHandler('BankBrowser-ReadyBrowser', root, function() instance.onGUIReady(); end)
addEventHandler('BankBrowser-DepositMoney', root, function(amount) if exports.vrp_global:hasMoney(localPlayer, tonumber(amount)) then triggerServerEvent('BankBrowser-DepositMoney', localPlayer, tonumber(amount)) BankReceiver:executeJavascript("change('curbalance', '"..(localPlayer:getData("bankmoney")+tonumber(amount)).."')"); else outputChatBox("Bank of Santos:#ffffff Yeterli paranız olmadığı için parayı kabul edemiyoruz.", 100, 100, 100, true) end end)
addEventHandler('BankBrowser-WidthrawMoney', root, function(amount) local amount = tonumber(amount) if localPlayer:getData('bankmoney') >= amount then triggerServerEvent('BankBrowser-WidthrawMoney', localPlayer, tonumber(amount)) else outputChatBox("Bank of Santos:#ffffff Hesabınızda yeterli para yok.", 100, 100, 100, true) end end)











