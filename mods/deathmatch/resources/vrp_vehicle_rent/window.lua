cRent = {

	cars = {
		-- id, isim, fiyat, hız, gta model
		{1, 'Peugeot Partner', 225, 140, 540},
		{2, 'Fiat Coupe', 265, 160, 566},
		{3, 'Opel Corsa', 310, 168, 439},
		{4, 'Honda Crv', 240, 150, 543},
		{5, 'Peugeot 206', 245, 150, 526},
		{6, 'Toyota Corolla', 280, 140, 492},
	},

	_window = function()
	cRent = instance;
		if localPlayer:getData('loggedin') == 1 then
			showCursor(true)
			local font = GuiFont(':vrp_fonts/files/Roboto-Bold.ttf', 9)

			window = GuiWindow(0, 0, 850, 524, 'Araç Kiralama Noktası - Valhalla', false)
			window:setSizable(false)
			window:setAlpha(0.75)
			exports.vrp_global:centerWindow(window)

			list = GuiGridList(20, 32, 287, 382, false, window)
			list:setSortingEnabled(false)
			list:setAlpha(0.93)
			list:addColumn('ID', 0.1)
			list:addColumn('Marka', 0.5)
			list:addColumn('Fiyat', 0.3)

			for index, value in ipairs(instance.cars) do
				local row =  list:addRow()
				list:setItemText(row, 1, value[1], false, false)
				list:setItemText(row, 2, value[2], false, false)
				list:setItemText(row, 3, value[3]..' $', false, false)
			end

			speed = GuiLabel(547, 481, 145, 21, 'Azami Hız: N/A', false, window)
			speed:setFont(font)

			buy = GuiButton(99, 446, 129, 28, 'Seçim Yap', false, window)
			buy:setAlpha(0.75)

			close = GuiButton(720, 33, 113, 30, 'Arayüzü Kapat', false, window)
			close:setAlpha(0.75)

			scroll = guiCreateScrollBar(466, 446, 268, 18, true, false, window)
			scroll:setProperty('StepSize', '0.0028')

			GuiStaticImage(317, 32, 63, 60, 'images/logo.png', false, window)

			previewObject = createVehicle(540, 0, 0, 0)
			previewObject:setData('alpha', 255)
			previewObject:setDimension(999)

			preview = exports['vrp_object_preview']:createObjectPreview(previewObject, 0, 0, 180, 0.50, 0.40, 0.26, 0.20, true, true)

			addEventHandler('onClientGUIScroll', scroll,
				function()
					if localPlayer:getData('rent:window') then
						local rotation = tonumber(guiGetProperty(source, 'ScrollPosition'))
						setElementRotation(previewObject, 0, 0, 155 + rotation * 360)
						exports['vrp_object_preview']:setRotation(preview,0, 0, 155 + rotation * 360)
					end
			end, false)

		end
	end,

	_render = function()
	cRent = instance;
		if localPlayer:getData('rent:window') then
			if isElement(list) then
				local selected = guiGridListGetSelectedItem(list)
				selected = selected + 1
				selectedTable = instance.cars[selected] or false
				if selectedTable then
					guiSetText(speed, 'Azami Hız: '..selectedTable[4]..'km/h')
					setElementModel(previewObject, selectedTable[5])
				end
			end
		end
	end,

	_click = function()
	cRent = instance;
		if localPlayer:getData('rent:window') then
			if source == close then
				previewObject:destroy()
				exports['vrp_object_preview']:destroyObjectPreview(preview)
				window:destroy()
				localPlayer:setData('rent:window', false)
				outputChatBox('[Valhalla]#D0D0D0 Hmm, demek bir araba beğenemdin başka zaman tekrar gel!',195,184,116,true)
				showCursor(false)
			elseif source == buy then
				local selected = guiGridListGetSelectedItem(list)
				if selected == -1 then
					outputChatBox('[Valhalla]#D0D0D0 Lütfen kiralamak istediğin aracı listeden seç!',195,184,116,true)
				else
					selected = selected + 1
					selectedTable = instance.cars[selected] or false
					if selectedTable then
						previewObject:destroy()
						exports['vrp_object_preview']:destroyObjectPreview(preview)
						window:destroy()
						localPlayer:setData('rent:window', false)
						showCursor(false)
						triggerServerEvent('rent:create', localPlayer, selectedTable[2], selectedTable[3], selectedTable[5])
					end
				end
			end
		end
	end,

	index = function(self)
		setTimer(self._render, 50, 0)
		addEvent('rent:window', true)
		addEventHandler('rent:window', getRootElement(), self._window)
		addEventHandler('onClientGUIClick',getRootElement(),self._click)
	end,
}

localPlayer:setData('rent:window', false)
instance = new(cRent)
instance:index()