local bolge = createMarker(  395.8076171875, -2079.8818359375, 6.8900905227661, "cylinder", 1, 255, 0, 0, 255)

local Font = dxCreateFont(":vrp_fonts/files/Roboto.ttf", 16)


setTimer( function()
       local x, y, z = getElementPosition( bolge )
       local Mx, My, Mz = getCameraMatrix(   )
        if ( getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz ) <= 10 ) then
           local WorldPositionX, WorldPositionY = getScreenFromWorldPosition( x, y, z +0.2, 0.07 )
           local WorldPositionX2, WorldPositionY2 = getScreenFromWorldPosition( x, y, z +0.08, 0.07 )
            if ( WorldPositionX and WorldPositionY ) then
			    dxDrawText("✪ /biletal ✪", WorldPositionX - 2, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(0,0,0, 255), 1.0, Font, "center", "center", false, false, false, true, false)
			    dxDrawText("✪ /biletal ✪", WorldPositionX - 1, WorldPositionY + 1, WorldPositionX - 1, WorldPositionY + 1, tocolor(255,255,255, 255), 1.0, Font, "center", "center", false, false, false, true, false)
            end
      end
end,
0,0)

function BalonLoad()
	local balonTXD = engineLoadTXD("dosyalar/balon.txd")
	engineImportTXD(balonTXD, 1928)
	local balonDFF = engineLoadDFF("dosyalar/balon.dff", 1928)
	engineReplaceModel(balonDFF, 1928)
	local balonCOL = engineLoadCOL("dosyalar/balon.col")
	engineReplaceCOL(balonCOL, 1928)
end
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), BalonLoad)