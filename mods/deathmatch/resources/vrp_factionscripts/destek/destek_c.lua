local sw,sh = guiGetScreenSize()
local GothaProMed = dxCreateFont("destek/Roboto.ttf",15)

addEventHandler( "onClientRender", root, function (  )
    for k,player in ipairs(getElementsByType("player")) do
        if player ~= getLocalPlayer() and getElementDimension(getLocalPlayer()) == getElementDimension(player) and  getElementData(getLocalPlayer(), "faction") == 1 or  getElementData(getLocalPlayer(), "faction") == 78 then
            local dutyLevel = getElementData(getLocalPlayer(), "duty")
			--if not dutyLevel or dutyLevel == 0 then return end
            local x, y, z = getElementPosition(player)
            z = z + 0.95
            local Mx, My, Mz = getCameraMatrix()
            local distance = getDistanceBetweenPoints3D( x, y, z, Mx, My, Mz )
            local size = 1
            x, y, z = getElementPosition(player)
			fx, fy, fz = getElementPosition(getLocalPlayer())
            if getElementData(player, "destekacik") then
            local sx,sy = getScreenFromWorldPosition( x, y, z, 0 )
                if ( sx and sy ) then
			        dxDrawImage(sx-30, sy-80, 40,40, "destek/destek.png",0,0,0,tocolor(255,255,255,255))
			        local metre = tostring(getDistanceBetweenPoints3D(x, y, z, fx, fy, fz))
                    local name = getPlayerName(player):gsub("_", " ")
                    local tur = getElementData(player, "destek_tur")
					dxDrawText(""..name.." ("..tur..")", sx, sy, sx+size, sy+size-10, tocolor(0,0,0,200), size, GothaProMed, "center", "bottom", false, false, false)
					dxDrawText(""..name.." ("..tur..")", sx, sy, sx, sy-10, tocolor(255,255,255,200), size, GothaProMed, "center", "bottom", false, false, false)
                end
            end
            if getElementData(player, "takipacik") then
            	local sx,sy = getScreenFromWorldPosition( x, y, z, 0 )
                if ( sx and sy ) then
                	dxDrawImage(sx-30, sy-80, 40,40, "destek/takip.png",0,0,0,tocolor(255,255,255,255))

                    local name = getPlayerName(player):gsub("_", " ")
					dxDrawText(""..name.."", sx, sy, sx+size, sy+size-10, tocolor(0,0,0,200), size, GothaProMed, "center", "bottom", false, false, false)
					dxDrawText(""..name.."", sx, sy, sx, sy-10, tocolor(255,255,255,200), size, GothaProMed, "center", "bottom", false, false, false)
                end
            end
        end
    end 
end)