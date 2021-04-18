--// github.com/yourpalenes * github.com/foreigner26
--// ProjectE - 2019 * Open Source Project
Instance = {
	window = nil,
        blip = nil,

	find = function(self)
		if isElement(self.window) then
			return
		end
		self.window = guiCreateWindow(0, 0, 271, 333, "Meslek Bulma Arayüzü", false)
		exports.vrp_global:centerWindow(self.window)
                guiWindowSetSizable(self.window, false)

                grid = guiCreateGridList(9, 26, 252, 237, false, self.window)
                column = guiGridListAddColumn(grid, "Meslek Adı", 0.9)
                for index, value in pairs(Jobs) do
                        local id = guiGridListAddRow(grid)
                        guiGridListSetItemText(grid, id, column, value[1], false, false)
                        guiGridListSetItemData(grid, id, column, index)
                end
                
                ok = guiCreateButton(9, 267, 252, 27, "Haritada İşaretle", false, self.window)
                addEventHandler('onClientGUIClick', ok,
                	function(b, s)
                                local selectedRow, selectedColumn = guiGridListGetSelectedItem(grid)
                                if selectedRow ~= -1 then
                                        local selectedJob = guiGridListGetItemData(grid, selectedRow, selectedColumn)
                                         outputChatBox("(( Bulmak istediğiniz meslek radarda kırmızı olarak işaretlendi. ))", 225, 225, 225)
                                        if isElement(self.blip) then
                                                self.blip.position = unpack(Jobs[selectedJob][2])
                                                return
                                        end
                                        self.blip = Blip(Jobs[selectedJob][2][1], Jobs[selectedJob][2][2], Jobs[selectedJob][2][3], 0, 5)
                                       
                                end
                	end
                )
                close = guiCreateButton(9, 298, 252, 25, "Arayüzü Kapat", false, self.window)
                addEventHandler('onClientGUIClick', close,
                	function(b, s)
                	       self.window:destroy()
                	end
                )   
	end,
}

Array = Instance

addEvent('push.showJob', true)
addEventHandler('push.showJob', root, function() Array:find() end)