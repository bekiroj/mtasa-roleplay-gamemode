tablo = {
	{dff = "exterior_pd", txd = "exterior_pd", col = "exterior_pd", model = 3976 },
	{dff = "pd_props", txd = "pd_props", col = "pd_props", model = 14682 },
}

function modelleriYukle()
	for k,v in ipairs(tablo) do
		if v.txd then
			local txd = engineLoadTXD ("Dosyalar/"..v.txd..".txd")
			engineImportTXD(txd,v.model)
		end
		if v.dff then
			local dff = engineLoadDFF("Dosyalar/"..v.dff..".dff",v.model)
			engineReplaceModel(dff,v.model)
		end
		if v.col then
			col = engineLoadCOL( "Dosyalar/"..v.col..".col" )
			engineReplaceCOL( col, v.model )
		end
	end
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),modelleriYukle)