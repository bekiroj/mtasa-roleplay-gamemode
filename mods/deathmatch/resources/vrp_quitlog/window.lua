cquitLog = {

	show = false,

	_window = function()
	cquitLog = instance;
		if localPlayer:getData('loggedin') == 1 then
			if not instance.show then
				showCursor(true)
				instance.show = true
				window = GuiWindow(0, 0, 730, 406, 'Yakın Çevrede Çıkan Oyuncular - Valhalla', false)
				window:setSizable(false)
				exports.vrp_global:centerWindow(window)

				list = GuiGridList(9, 25, 711, 315, false, window)
				list:addColumn('Karakter Adı', 0.2)
	        	list:addColumn('Kullanıcı Adı', 0.2)
	        	list:addColumn('Çıkış Sebebi', 0.2)
	        	list:addColumn('Uzaklık(mt)', 0.2)
	        	list:addColumn('Konum', 0.2)
	        	list:addColumn('Tarih', 0.2)

				close = GuiButton(9, 356, 712, 34, 'Arayüzü Kapat', false, window)
			elseif instance.show then
				window:destroy()
				showCursor(false)
				instance.show = false
			end
		end
	end,

	_click = function()
	cquitLog = instance;
		if source == close then
			window:destroy()
			showCursor(false)
			instance.show = false
		end
	end,

	_add = function(name,username,reason,mt,location,history)
		local row =  list:addRow()
	    list:setItemText(row,1,name,false,true)
	    list:setItemText(row,2,username,false,true)
	    list:setItemText(row,3,reason,false,true)
	    list:setItemText(row,4,mt,false,true)
	    list:setItemText(row,5,location,false,true)
	    list:setItemText(row,6,history,false,true)
	end,

	index = function(self)
		addCommandHandler('quitlog',self._window)
		addEventHandler('onClientGUIClick',getRootElement(),self._click)
		addEvent('quitlog:add',true)
		addEventHandler('quitlog:add',root,self._add)
	end,
}

instance = new(cquitLog)
instance:index()