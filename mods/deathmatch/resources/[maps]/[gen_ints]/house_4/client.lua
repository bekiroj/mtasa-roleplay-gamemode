

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1931)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1931)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1931)
engineSetModelLODDistance(1931, 301)
end)


