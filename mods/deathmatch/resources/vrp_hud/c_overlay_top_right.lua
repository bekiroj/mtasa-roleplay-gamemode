local localPlayer = getLocalPlayer()
local show = false
local width, height = 400,67
local sx, sy = guiGetScreenSize()



local groupIcon = exports.vrp_fonts:getIcon("info-circle")
local roboto = exports.vrp_fonts:getFont('Roboto',10)
local robotoB = exports.vrp_fonts:getFont('RobotoB',13)
local awesomeFont = exports.vrp_fonts:getFont("AwesomeFont", 30)


local content = {}
local timerClose = nil
local cooldownTime = 20 --seconds
local toBeDrawnWidth = width
local justClicked = false
function drawOverlayTopRight(info, widthNew, posXOffsetNew, posYOffsetNew, cooldown)
	local pinned = getElementData(localPlayer, "hud:pin")
	if not pinned and timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
	if info then
		content = info
		content[1][1] = string.sub(content[1][1], 1, 1)..string.sub(content[1][1], 2)
	else
		return false
	end
	
	if posXOffsetNew then
		posXOffset = posXOffsetNew
	end
	if posYOffsetNew then
		posYOffset = posYOffsetNew
	end
	if cooldown then
		cooldownTime = cooldown
	end
	if content then
		show = true
	end
	
	toBeDrawnWidth = width
	
	playSoundFrontEnd ( 101 )
	if cooldownTime ~= 0 and not pinned then
		timerClose = setTimer(function()
			show = false
			setElementData(localPlayer, "hud:overlayTopRight", 0, false)
		end, cooldownTime*1000, 1)
	end
	
	for i=1, #info do
		outputConsole(info[i][1] or "")
	end
end
addEvent("hudOverlay:drawOverlayTopRight", true)
addEventHandler("hudOverlay:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

addEventHandler("onClientRender",getRootElement(), function ()
	if show and not getElementData(localPlayer, "integration:previewPMShowing") and getElementData(localPlayer, 'loggedin') == 1 then 
		if ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( localPlayer, "aim_weapon" ) ) then
			local posXOffset, posYOffset = 0, 165
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				posYOffset = posYOffset + hudDxHeight + 20
			end

			roundedRectangle(sx-toBeDrawnWidth-15+posXOffset-2, 5+posYOffset-2, toBeDrawnWidth, 309, tocolor(15,15,15,50), tocolor(15,15,15,100)) -- shadoe
			roundedRectangle(sx-toBeDrawnWidth-15+posXOffset, 5+posYOffset, toBeDrawnWidth, 309, tocolor(15,15,15,160), tocolor(15,15,15,170)) -- main
			roundedRectangle(sx-toBeDrawnWidth-15+posXOffset, 5+posYOffset, toBeDrawnWidth, 65, tocolor(15,15,15,210), tocolor(15,15,15,210)) -- üst taraf
			roundedRectangle(sx-toBeDrawnWidth-15+posXOffset, posYOffset*2.57, toBeDrawnWidth, 25, tocolor(15,15,15,210), tocolor(15,15,15,210)) -- alt taraf
			

			dxDrawText ( " "..groupIcon.."", 155+sx-toBeDrawnWidth-15+posXOffset, 10+posYOffset, toBeDrawnWidth, 309, tocolor ( 200,200,200, 255 ), 1, awesomeFont )
			--dxDrawText ( "Kullanıcı Bilgileri", 141+sx-toBeDrawnWidth-15+posXOffset, 3+posYOffset*2.57, toBeDrawnWidth, 309, tocolor ( 200,200,200, 255 ), 1, roboto )
		
			for i=1, #content do
				if content[i] then
					
					if i == 1 or content[i][7] == "title" then --Title
						
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+1+posXOffset, (16*i)+posYOffset+64, toBeDrawnWidth-5, 15, tocolor ( 225, 225, 225, 200), 1, robotoB )
					else
						dxDrawText( content[i][1] or "" , sx-toBeDrawnWidth+1+posXOffset, (16*i)+posYOffset+55, toBeDrawnWidth-5, 15, tocolor ( content[i][2] or 225, content[i][3] or 225, content[i][4] or 225, content[i][5] or 225 ), content[i][6] or 1, roboto )
					end
				end
			end
		end
	end
end, false)

function pinIt()
	setElementData(localPlayer, "hud:pin", true, false)
	if timerClose and isTimer(timerClose) then
		killTimer(timerClose)
		timerClose = nil
	end
end

function unpinIt()
	pinIt()
	setElementData(localPlayer, "hud:pin", false, false)
	timerClose = setTimer(function()
		show = false
		setElementData(localPlayer, "hud:overlayTopRight", 0, false)
	end, 3000, 1)
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);

	end
end