

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1930)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1930)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1930)
engineSetModelLODDistance(1930, 301)
end)


