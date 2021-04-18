addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1933)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1933)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1933)
engineSetModelLODDistance(1933, 301)

end)