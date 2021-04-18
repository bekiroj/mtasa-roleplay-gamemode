addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1934)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1934)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1934)
engineSetModelLODDistance(1934, 301)

end)