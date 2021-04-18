function AracYukle606()
    local txd = engineLoadTXD ('Dosyalar/1.txd')
    engineImportTXD(txd,Karavan.carid)
    local dff = engineLoadDFF('Dosyalar/2.dff',Karavan.carid)
    engineReplaceModel(dff,Karavan.carid)
end
addEventHandler('onClientResourceStart',getResourceRootElement(getThisResource()),AracYukle606)

addEvent("karavan:ComponentPosition" , true)
addEventHandler("karavan:ComponentPosition" , root , function(veh , caravan)
    local x , y , z = getVehicleComponentPosition(caravan , "misc_a" ,  "world")
    local vx , vy , vz = getVehicleComponentPosition(veh , "boot_dummy" ,  "world")
    if getDistanceBetweenPoints3D(x , y , z , x , vy , vz) > 3 then
        outputChatBox("[!]#ffffff Aracınızın arka kısmını karavanın ön tarafına getirip komutu tekrar yazınız!" , 255,0,0,true)
    return end
    triggerServerEvent("karavan:ComponentPosition" , source , veh , caravan)
end)