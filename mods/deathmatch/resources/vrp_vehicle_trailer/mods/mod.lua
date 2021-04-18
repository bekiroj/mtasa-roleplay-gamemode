function _load()
    local txd = engineLoadTXD ('mods/443.txd')
    engineImportTXD(txd,443)
    local dff = engineLoadDFF('mods/443.dff',443)
    engineReplaceModel(dff,443)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),_load)