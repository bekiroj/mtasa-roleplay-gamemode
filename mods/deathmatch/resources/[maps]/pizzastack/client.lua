addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
fileDelete("object.txd")
engineImportTXD(txd, 5418)
end)