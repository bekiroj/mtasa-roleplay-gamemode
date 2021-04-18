cPrison = {
	show = false,

	text = function()
		if (localPlayer:getData('hapis_sure') or 0) > 0 then
			sX,sY = guiGetScreenSize()
			u1,u2 = sx,25
			x,y,w,h = sX/2-u1/2,sY/2-u2/2,u1,u2
			w, h = w+2, h-4
			x, y = x-4, y
			dxDrawText("HAPİS : #FF0606"..(getElementData(localPlayer, "hapis_sure") or 0).."#ffffff Dakika",x,y+5,w+x,h+y+4,tocolor(235,235,235),1.8,"default-bold","right","top",true,true,true,true)
		end
	end,

	window = function()
	cPrison = instance;
		if not instance.show then
			if exports.vrp_integration:isPlayerTrialAdmin(localPlayer) then
				instance.show = true
				window = GuiWindow(0, 0, 329, 295, 'Hapisdeki Oyuncular', false)
				window:setSizable(false)
				exports.vrp_global:centerWindow(window)

				list = GuiGridList(9, 29, 310, 228, false, window)
				list:setSortingEnabled(false)
				list:addColumn('Oyuncu Adı', 0.5)
				list:addColumn('Süre', 0.5)

				close = GuiButton(93, 264, 138, 21, 'Arayüzü Kapat', false, window)

				for index, value in ipairs(getElementsByType("player")) do
					if value:getData('hapis_sure') > 0 then
						local row =  list:addRow()
						list:setItemText(row, 1, value:getData('playerid').." - "..getPlayerName(value), false, false)
						list:setItemText(row, 2, (value:getData('hapis_sure') or 0 )..'DK', false, false)
					end
				end
			end
		elseif instance.show then
			instance.show = false
			window:destroy()
		end
	end,

	_click = function()
	cPrison = instance;
		if source == close then
			instance.show = false
			window:destroy()
		end
	end,

	index = function(self)
		setTimer(self.text,7, 0)
		addCommandHandler('hapisdekiler',self.window)
		addEventHandler('onClientGUIClick',getRootElement(),self._click)
	end,
}

instance = new(cPrison)
instance:index()