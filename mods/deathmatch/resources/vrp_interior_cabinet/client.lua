local sx , sy = guiGetScreenSize()

GUI = {
    gridlist = {},
    window = {},
    button = {}
}

GUI.window[1] = guiCreateWindow((sx-630)/2, (sy-535)/2, 630, 535, "Valhalla - Dolap Sistemi", false)
guiWindowSetSizable(GUI.window[1], false)

GUI.gridlist[1] = guiCreateGridList(0, 44, 290, 419, false, GUI.window[1])
GUI.gridlist[2] = guiCreateGridList(330, 44, 290, 419, false, GUI.window[1])
GUI.button[1] = guiCreateButton(20, 482, 180, 43, "<< Dolaptan Çıkar", false, GUI.window[1])
guiSetFont(GUI.button[1], "default-bold-small")
GUI.button[2] = guiCreateButton(430, 482, 180, 43, "Dolaba Ekle >>", false, GUI.window[1])
guiSetFont(GUI.button[2], "default-bold-small")
GUI.button[3] = guiCreateButton(228, 482, 180, 43, "Kapat", false, GUI.window[1])
guiSetFont(GUI.button[3], "default-bold-small")

guiGridListAddColumn(GUI.gridlist[1] , "" , 0.9)
guiGridListAddColumn(GUI.gridlist[2] , "" , 0.9)

guiSetVisible(GUI.window[1] , false)

local itemIDs = { 
-- İzin verilen ITEM ID'leri
    [2] = true,
    [115] = true,
    [116] = true,
	[3]   = true,
}

local playerItemGUI = {}
local dolapItemGUI  = {}
local elkoyState    = false

addEvent("dolapGUI" , true)
addEventHandler("dolapGUI" , root , function(state , dolapItems , playerItems , state2)

    elkoyState = state2

    guiSetVisible(GUI.window[1] , true)
    guiGridListClear(GUI.gridlist[1])
    guiGridListClear(GUI.gridlist[2])

    playerItemGUI = {}
    dolapItemGUI  = {}

    for k , v in ipairs(dolapItems) do 

        local row = guiGridListAddRow(GUI.gridlist[2])
        guiGridListSetItemText(GUI.gridlist[2] , row , 1 , v.text , false , false)

        table.insert(dolapItemGUI , {v.item , v.text})

    end

    for k , v in ipairs(playerItems) do 

        if itemIDs[v[1]] then 

            local row = guiGridListAddRow(GUI.gridlist[1])
            local itemname = exports["vrp_items"]:getItemName(v[1] , 1)
            local itemwp   = 0

            if v[1] == 115 then
                local gunDetails = explode(':', v[2])
                itemname = gunDetails[3]
                itemwp = gunDetails[3]
            end

            if v[1] == 116 then
                local gunDetails = explode(':', v[2])
                itemname = gunDetails[2].." mermili "..getWeaponNameFromID(gunDetails[1]).." şarjörü"
                itemwp = getWeaponNameFromID(gunDetails[1])
            end

            table.insert(playerItemGUI , {v[1] , v[3] , itemname , v[2] , itemwp , v[2]})

            guiGridListSetItemText(GUI.gridlist[1] , row , 1 , itemname , false , false)
        end

    end

    if not state then

        guiSetVisible(GUI.button[1] , false)
        guiSetVisible(GUI.button[2] , false)

    else

        guiSetVisible(GUI.button[1] , true)
        guiSetVisible(GUI.button[2] , true)

    end

end)

addEventHandler("onClientGUIClick" , root , function()

    if GUI.button[1] == source then -- Dolaptan çıkarma

        local row , col = guiGridListGetSelectedItem(GUI.gridlist[2])

        if row == -1 or col == -1 then
            outputChatBox("[!]#ffffff Herhangi bir ürün seçmedin!",255,0,0,true)
        return end

        local rowtext = guiGridListGetItemText(GUI.gridlist[2] , row , 1)

        guiGridListRemoveRow(GUI.gridlist[2] , row)

        local row = guiGridListAddRow(GUI.gridlist[1])
        guiGridListSetItemText(GUI.gridlist[1] , row , 1 , rowtext , false , false)

        for k , v in ipairs(dolapItemGUI) do 

            if rowtext == v[2] then

                triggerServerEvent("dolapGetir" , localPlayer , tonumber(v[1]) , v[2] , localPlayer.dimension , localPlayer , elkoyState)

                dolapHide()

                break

            end

        end

    elseif GUI.button[2] == source then -- Dolaba Ekleme

        if elkoyState then return end

        local row , col = guiGridListGetSelectedItem(GUI.gridlist[1])

        if row == -1 or col == -1 then
            outputChatBox("[!]#ffffff Herhangi bir ürün seçmedin!",255,0,0,true)
        return end

        local rowtext = guiGridListGetItemText(GUI.gridlist[1] , row , 1)

        guiGridListRemoveRow(GUI.gridlist[1] , row)

        local row = guiGridListAddRow(GUI.gridlist[2])
        guiGridListSetItemText(GUI.gridlist[2] , row , 1 , rowtext , false , false)

        local items = exports["vrp_items"]:getItems(localPlayer)

        for k , v in ipairs(playerItemGUI) do 

            if rowtext == v[3] then

                if v[1] == 115 or v[1] == 116 then 

                    triggerServerEvent("dolapAktar" , localPlayer , tonumber(v[1]) , v[4] , localPlayer.dimension , rowtext , v[5] , v[6])

                else

                    triggerServerEvent("dolapAktar" , localPlayer , tonumber(v[1]) , nil , localPlayer.dimension , rowtext , false , v[6])

                end

                dolapHide()

                break

            end

        end

    elseif GUI.button[3] == source then

        guiSetVisible(GUI.window[1] , false)

    end

end)


function dolapHide()

    guiSetVisible(GUI.window[1] , false)
    guiGridListClear(GUI.gridlist[1])
    guiGridListClear(GUI.gridlist[2])

    playerItemGUI = {}
    dolapItemGUI  = {}

end
addEvent("dolapHide" , true)
addEventHandler("dolapHide" , root , dolapHide)

function explode(div,str)
    if (div=='') then return false end
    local pos,arr = 0,{}
    for st,sp in function() return string.find(str,div,pos,true) end do
      table.insert(arr,string.sub(str,pos,st-1))
      pos = sp + 1
    end
    table.insert(arr,string.sub(str,pos))
    return arr
end