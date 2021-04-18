--MAXIME
local hotlinesGUI = {}
function drawPhoneHotlines(xoffset, yoffset)
	if not isPhoneGUICreated() then
		return false
	end

	if not xoffset then xoffset = 0 end
	if not yoffset then yoffset = 0 end

	if wHotlines and isElement(wHotlines) then
		return false
		--destroyElement(wHotlines)
	end

	wHotlines = guiCreateScrollPane(30+xoffset, 100+yoffset, 230, 370, false, wPhoneMenu)
	local count = 0
	for lineNumber, lineName in pairs(hotlines) do 
		hotlinesGUI[lineNumber] = {}
	    hotlinesGUI[lineNumber].number = guiCreateLabel(10+xoffset, 10+yoffset, 153, 19, lineNumber, false, wHotlines)
	    guiSetFont(hotlinesGUI[lineNumber].number, "default-bold-small")
	    guiLabelSetVerticalAlign(hotlinesGUI[lineNumber].number, "center")
	
	    hotlinesGUI[lineNumber].name = guiCreateLabel(10+xoffset, 29+yoffset, 150, 16, lineName, false, wHotlines)
	    guiSetFont(hotlinesGUI[lineNumber].name, "default-small")

	    guiCreateStaticImage(163+xoffset, 15+yoffset, 48, 14, "images/call.png", false, wHotlines)
	    hotlinesGUI[lineNumber].call = guiCreateButton(163+xoffset, 14+yoffset, 48, 16, "", false, wHotlines)
	    guiSetAlpha(hotlinesGUI[lineNumber].call, 0.3)

	    yoffset = yoffset + 31 - 14
	    guiCreateStaticImage(179+xoffset, 16+yoffset, 17, 12, "images/sms.png", false, wHotlines)
	    hotlinesGUI[lineNumber].sms = guiCreateButton(163+xoffset, 14+yoffset, 48, 16, "", false, wHotlines)
	    guiSetAlpha(hotlinesGUI[lineNumber].sms, 0.3)
	    yoffset = yoffset - (31 - 14)
		
		guiSetAlpha(guiCreateStaticImage(10+xoffset, 50+yoffset, 200, 1, ":admin-system/images/whitedot.jpg", false, wHotlines), 0.1)
	    yoffset = yoffset + 40 
	    count = count + 1
	end
	if count > 0 then
		addEventHandler("onClientGUIClick", wHotlines, function()
			for lineNumber, lineName in pairs(hotlines) do
				if source == hotlinesGUI[lineNumber].call then
					startDialing(phone, lineNumber)
					break
				elseif source == hotlinesGUI[lineNumber].sms then
					toggleOffEverything()
					drawOneSMSThread(lineNumber, nil)
					break
				end
			end
		end)
	else
		guiCreateLabel(0.5, 0.5, 1, 0.5, "It's lonely here..", true, wHotlines)
	end
	return wHotlines
end

function toggleHotlines(state)
	if wHotlines and isElement(wHotlines) then
		guiSetVisible(wHotlines, state)
	else
		if state then
			drawPhoneHotlines()
		end
	end
end
