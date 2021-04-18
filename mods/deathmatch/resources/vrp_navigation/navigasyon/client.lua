Locations = {
    [1] = {"Polis Departmanı", {1536.5, -1675.7451171875, 13.3828125}, false},
	[2] = {"Banka", {1456.7333984375, -1030.9462890625, 23.65625}, false},
	[3] = {"Los Santos Mall", {1129.0499267578, -1454.4543457031, 15.790126800537}, false},
	[4] = {"Los Santos Vergi Dairesi", {1481.0537109375, -1732.6884765625, 13.3828125}, false},
	[5] = {"Belediye Binası", {1481.0537109375, -1732.6884765625, 13.3828125}, false},
	[6] = {"Sürücü Kursu", {1082.5576171875, -1763.5, 13.371026992798}, false},
	[7] = {"Los Santos Television", {638.619140625, -1359.8896484375, 13.419981956482}, false},
	[8] = {"Los Santos Dorm [Yurt]", {1296.5986328125, -1410.5029296875, 13.2190284729}, false},
	[9] = {"Odun Taşıma Mesleği", {-351.5537109375, -1058.95703125, 59.269191741943}, false},
	[10] = {"Tütün Nakliye Mesleği", {-85.15625, -1188.6416015625, 1.75}, false},
	[11] = {"Dondurmacılık Mesleği", {1005.458984375, -1348.1689453125, 13.346240997314}, false},
	[12] = {"Çöpçülük Mesleği", {1640.3935546875, -1891.4951171875, 13.556436538696}, false},
	[13] = {"Taksi Durağı", {1794.6630859375, -1857.8291015625, 13.4140625}, false},
	[14] = {"Demir Madeni", {-159.8232421875, 2012.2568359375, 15.381496429443}, false},
	[15] = {"Altın Madeni", {-1995.6357421875, -1567.3212890625, 85.835067749023}, false},
	[16] = {"Bakır Madeni", {-775.685546875, -1858.130859375, 11.960872650146}, false},
	[17] = {"Kömür Madeni", {-729.13671875, 1533.650390625, 40.142238616943}, false},
	[18] = {"Taş Madeni", {541.9375, 840.314453125, -41.50301361084}, false},
	[19] = {"Maden İşleme Fabrikası", {642.2353515625, 1238.1552734375, 11.672054290771}, false},
	[20] = {"Kuyumcu", {1576.5732421875, -1810.5732421875, 13.452065467834}, false},	
	
}
Instance = {
	window = nil,
        blip = nil,

	find = function(self)
		if isElement(self.window) then
			return
		end
		self.window = guiCreateWindow(0, 0, 510, 333, "ValhallaMTA | Navigasyon Sistemi", false)
		exports.vrp_global:centerWindow(self.window)
                guiWindowSetSizable(self.window, false)

                grid = guiCreateGridList(9, 26, 485, 237, false, self.window)
                column = guiGridListAddColumn(grid, "Bölge Adı", 0.9)
                for index, value in pairs(Locations) do
                        local id = guiGridListAddRow(grid)
                        guiGridListSetItemText(grid, id, column, value[1], false, false)
                        guiGridListSetItemData(grid, id, column, index)
                end
                
                ok = guiCreateButton(9, 267, 485, 27, "İşaretle", false, self.window)
                addEventHandler('onClientGUIClick', ok,
                	function(b, s)
                                local selectedRow, selectedColumn = guiGridListGetSelectedItem(grid)
                                if selectedRow ~= -1 then
                                        local selectedJob = guiGridListGetItemData(grid, selectedRow, selectedColumn)
                                         outputChatBox("(( Bulmak istediğiniz yer radarda kırmızı olarak işaretlendi. ))", 225, 225, 225)
                                        if isElement(self.blip) then
                                                self.blip.position = unpack(Locations[selectedJob][2])
                                                return
                                        end
                                       -- self.blip = Blip(Locations[selectedJob][2][1], Locations[selectedJob][2][2], Locations[selectedJob][2][3], 0, 5)
                                       exports.vrp_navigation:findBestWay(Locations[selectedJob][2][1], Locations[selectedJob][2][2], Locations[selectedJob][2][3])
                                end
                	end
                )
                close = guiCreateButton(9, 298, 485, 25, "Arayüzü Kapat", false, self.window)
                addEventHandler('onClientGUIClick', close,
                	function(b, s)
                	       self.window:destroy()
                	end
                )   
	end,
}

Array = Instance
addCommandHandler('navigasyon', function() Array:find() end)