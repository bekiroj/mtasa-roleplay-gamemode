local localPlayer = getLocalPlayer()
local show = false
local width, height = 570,100
local woffset, hoffset = 0, 0
local sx, sy = guiGetScreenSize()
local content = {}
local timerClose = getTickCount()
local cooldownTime = 5 --seconds
local toBeDrawnWidth = 0

local function removeRender()
	if show then
		removeEventHandler( "onClientRender", root, clientRender )
		show = false
	end
end

local function makeFonts()
	exports.vrp_fonts:getFont('Roboto',18)
end

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
	if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
		local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
		if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
			for _, v in ipairs( aAttachedFunctions ) do
				if v == func then
					return true
				end
			end
		end
	end

	return false
end

function drawOverlayBottomCenter(info, widthNew, woffsetNew, hoffsetNew, cooldown)
	if getElementData(localPlayer, "loggedin") == 1 then
		makeFonts()
		content = info
		if woffsetNew then
			woffset = woffsetNew
		end
		if hoffsetNew then
			hoffset = hoffsetNew
		end
		
		playSoundFrontEnd ( 101 )	
		toBeDrawnWidth = dxGetTextWidth ( content[1][1] or "" , 1 , BizNoteFont18)
		
		for i=1, #info do
			outputConsole(info[i][1] or "")
		end
		if not show and not isEventHandlerAdded("onClientRender", root, clientRender) then
			addEventHandler( "onClientRender", root, clientRender )
		end
		timerClose = getTickCount()
	else
		removeRender()
	end
end
addEvent("hudOverlay:drawOverlayBottomCenter", true)
addEventHandler("hudOverlay:drawOverlayBottomCenter", localPlayer, drawOverlayBottomCenter)

local font = exports.vrp_fonts:getFont('Roboto',10)
function clientRender() 
	show = true
	if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
		local h = 16*(#content)+30
		local posX = (sx/2)-(toBeDrawnWidth/2)+woffset
		local posY = 20
		x, y, w, h = posX, posY , toBeDrawnWidth, h
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
		w, h = w-4, h-4
		x, y = x+2, y+2
		dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0, 80))
		dxDrawRectangle(x, y, w, 25, tocolor(0, 0, 0, 80))

		content[1][2], content[1][3], content[1][4], content[1][5] = 85, 155, 255, 255
		dxDrawText(content[1][1], x, y, w+x, 25+y, tocolor(225,225,225), 1, font, "center", "center")
		posY = posY-7
		for i=2, #content do
			if content[i] then
			
				local currentWidth = dxGetTextWidth ( content[i][1] or "" , 1 , font) + 30
				if currentWidth > toBeDrawnWidth then
					toBeDrawnWidth = currentWidth
				end
				dxDrawText( content[i][1] or "" , posX+16, posY+(16*i), toBeDrawnWidth-5, 15, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1,font  )
			end
		end
	end

	if getTickCount() - timerClose > cooldownTime*1000 then
		removeRender()
	end
end
