benzinmarker = createMarker ( 1939.1982421875, -1775.466796875, 13.39999961853, "cylinder", 1.5, 255, 255, 0, 0 )
-- benzinmarker2 = createMarker ( 1936.3503417969, -1775.6013183594, 13, "cylinder", 1.5, 255, 255, 0, 0 )

function rolePlayMarkerTextRender()
rolePlayMarkerText(benzinmarker,"/yakital <Miktar>\n[Litre 2$]",1,20,255,255,255,255,2,"arial")
end
addEventHandler("onClientRender", getRootElement(), rolePlayMarkerTextRender)

function rolePlayMarkerText(TheElement,text,height,distance,R,G,B,alpha,size,font,checkBuildings,checkVehicles,checkPeds,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)
    local x, y, z = getElementPosition(TheElement)
    local x2, y2, z2 = getElementPosition(localPlayer)
    local distance = distance or 20
    local height = height or 1
                                local checkBuildings = checkBuildings or true
                                local checkVehicles = checkVehicles or false
                                local checkPeds = checkPeds or false
                                local checkObjects = checkObjects or true
                                local checkDummies = checkDummies or true
                                local seeThroughStuff = seeThroughStuff or false
                                local ignoreSomeObjectsForCamera = ignoreSomeObjectsForCamera or false
                                local ignoredElement = ignoredElement or nil
    if (isLineOfSightClear(x, y, z, x2, y2, z2, checkBuildings, checkVehicles, checkPeds , checkObjects,checkDummies,seeThroughStuff,ignoreSomeObjectsForCamera,ignoredElement)) then
     local sx, sy = getScreenFromWorldPosition(x, y, z+height)
     if(sx) and (sy) then
      local distanceBetweenPoints = getDistanceBetweenPoints3D(x, y, z, x2, y2, z2)
      if(distanceBetweenPoints < distance) then
       dxDrawText(text, sx+2, sy+2, sx, sy, tocolor(R or 255, G or 255, B or 255, alpha or 255), (size or 1)-(distanceBetweenPoints / distance), font or "arial", "center", "center")
   end
  end
 end
end