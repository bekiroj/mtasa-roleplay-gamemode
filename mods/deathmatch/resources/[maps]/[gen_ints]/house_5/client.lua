txd = engineLoadTXD ( "1919.txd" )
engineImportTXD ( txd, 1919 )
col = engineLoadCOL ( "1919.col" )
engineReplaceCOL ( col, 1919 )
dff = engineLoadDFF ( "1919.dff" )
engineReplaceModel ( dff, 1919 )
engineSetModelLODDistance(1919, 9999999999999)

