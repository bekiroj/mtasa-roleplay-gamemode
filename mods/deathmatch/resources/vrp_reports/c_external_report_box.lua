-- bekiroj
local localPlayer = getLocalPlayer()
local show = false
local width, height = 650,300
local woffset, hoffset = 0, 0
local sx, sy = guiGetScreenSize()
local content = {}
local line = 10
local thisResourceElement = getResourceRootElement(getThisResource())
local BizNoteFont18 = dxCreateFont ( ":vrp_resources/BizNote.ttf" , 18 )

function updateOverlay(info, widthNew, woffsetNew, hoffsetNew)
	if showExternalReportBox(localPlayer) then
		if info then
			table.insert(content, info)
			playSoundFrontEnd ( 101 )
		end
		if widthNew then
			width = widthNew
		end
		if woffsetNew then
			woffset = woffsetNew
		end
		if hoffsetNew then
			hoffset = hoffsetNew
		end
	end
end
addEvent("report-system:updateOverlay", true)
addEventHandler("report-system:updateOverlay", localPlayer, updateOverlay)

addEventHandler( "onClientElementDataChange", thisResourceElement , 
	function(n)
		if n == "reportPanel" then
			updateOverlay(getElementData(thisResourceElement, "reportPanel") or false)
		end
	end, false
)


addEventHandler("onClientRender",getRootElement(), function ()
	if showExternalReportBox(localPlayer) and exports.vrp_hud:isActive() then 
		if (getElementData(localPlayer, "loggedin") == 1) and( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( "aim_weapon" ) )  and not isPlayerMapVisible() then
			local w = width
			local h = 16*(line)+30
			local posX = (sx/2)-(w/2)+woffset
			local sy1 = getElementData(localPlayer, "recon:whereToDisplayY") or sy
			if sy1 ~= sy then
				sy1 = sy1 + 25
			end
			local posY = sy1-(h+30)+hoffset 
			
			dxDrawRectangle(posX, posY , w, h , tocolor(0, 0, 0, 100), false)
			
			dxDrawText( "Rapor Paneli " , posX+16, posY+16, w-5, 5, tocolor ( 70, 200, 30, 255 ), 1, BizNoteFont18 )
			--dxDrawText( "(Press F5 to toggle this window)" , posX+110, posY+20, w-5, 5, tocolor ( 250, 250, 250, 255 ), 1 )
			dxDrawText( "Geliştirici: bekiroj" , posX+530, posY, w-5, 5, tocolor ( 255, 255, 255, 70 ), 1)
			
			local lastIndex = #content
			local count = 1
			for i = (lastIndex-line+2), (lastIndex) do
				if content[i] then
					dxDrawText( content[i][1] or "" , posX+16, posY+(15*count)+30, w-5, 15, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1, content[i][7] or "default" )
					count = count + 1
				end
			-- setElementData(localPlayer,"hudVisible",false)
			-- triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )				
			end
		end
	end
end, false)