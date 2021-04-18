local fav_list = {
    edit = {},
    button = {},
    window = {},
    label = {},
    gridlist = {}
}

addCommandHandler("aksesuarfavori",
    function()
        if getElementData(localPlayer, "loggedin") == 1 then
            ExclusiveGUI()
        end
    end
)

function ExclusiveGUI()
    if isElement(window) then
        destroyElement(window)
        return
    end
    window = guiCreateWindow(0, 0, 510, 283, "Kaydedilen Aksesuar Listesi - Can RPG v3.1", false)
    guiWindowSetSizable(window, false)
    exports.vrp_global:centerWindow()

    fav_list.gridlist[1] = guiCreateGridList(12, 30, 275, 206, false, window)
    guiGridListAddColumn(fav_list.gridlist[1], "Aksesuar Adı", 0.5)
    guiGridListAddColumn(fav_list.gridlist[1], "Modeller", 0.5)
    fav_list.button[1] = guiCreateButton(10, 246, 277, 26, "Seçili Aksesuarları Kullan", false, window)
    fav_list.button[2] = guiCreateButton(300, 246, 200, 26, "Arayüzü Kapat", false, window)
    fav_list.label[1] = guiCreateLabel(298, 38, 202, 24, "Üzerimdeki aksesuarları kaydet.", false, window)
    guiLabelSetHorizontalAlign(fav_list.label[1], "center", false)
    fav_list.button[3] = guiCreateButton(300, 210, 200, 26, "Kaydet", false, window)
    fav_list.label[2] = guiCreateLabel(297, 95, 203, 17, "Aksesuar listesini isimlendir:", false, window)
    guiLabelSetHorizontalAlign(fav_list.label[2], "center", false)
    fav_list.edit[1] = guiCreateEdit(298, 117, 202, 24, "", false, window)
end