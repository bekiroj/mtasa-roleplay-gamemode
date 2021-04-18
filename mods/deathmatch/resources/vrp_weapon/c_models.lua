local modsTable = {}

modsTable[339] = {
	txd = "models/Katana.txd",
	dff = "models/Katana.dff",
}

function loadMods()
	for index, value in pairs(modsTable) do
		if value.txd then
			txd = engineLoadTXD(value.txd)
			engineImportTXD(txd, index)
		end
		if value.dff then
			dff = engineLoadDFF(value.dff)
			engineReplaceModel(dff, index)
		end
		if value.col then
			col = engineLoadCOL(value.col)
			engineReplaceCOL(col, index)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadMods()
		setTimer(loadMods, 1000, 1)
	end
)