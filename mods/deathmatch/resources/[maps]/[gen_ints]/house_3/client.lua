

addEventHandler('onClientResourceStart', resourceRoot,
function()
local txd = engineLoadTXD('object.txd',true)
engineImportTXD(txd, 1839)
local dff = engineLoadDFF('object.dff', 0)
engineReplaceModel(dff, 1839)
local col = engineLoadCOL('object.col')
engineReplaceCOL(col, 1839)
engineSetModelLODDistance(1839, 301)
end)



function object2()
txd = engineLoadTXD ( "object2.txd"  )
engineImportTXD ( txd, 1954 )
col = engineLoadCOL ( "object2.col" )
engineReplaceCOL ( col, 1954 )
dff = engineLoadDFF ( "object2.dff" )
engineReplaceModel ( dff, 1954 )
engineSetModelLODDistance(1954, 100000)
end
addEventHandler ( "onClientResourceStart", getResourceRootElement(getThisResource()), object2)