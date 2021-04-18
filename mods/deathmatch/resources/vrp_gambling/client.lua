function showGUI(partnerName, price)
	if isElement(window) then return end
	window = guiCreateWindow(0, 0, 454, 330, "Zar Düellosu", false)
	guiWindowSetSizable(window, false)
	exports.vrp_global:centerWindow(window)

	grid = guiCreateGridList(9, 27, 435, 258, false, window)
	guiGridListAddColumn(grid, "", 0.9)
	for i = 1, 3 do
	    guiGridListAddRow(grid)
	end
	guiGridListSetItemText(grid, 0, 1, ">> Partner: "..partnerName:gsub("_", " "), false, false)
	guiGridListSetItemText(grid, 1, 1, ">> Bahis: "..(price).."$", false, false)
	guiGridListSetItemText(grid, 2, 1, ">> Döndür", false, false)
	guiGridListSetItemColor(grid, 2, 1, 254, 0, 0, 255)
	ok_ = guiCreateButton(51, 295, 168, 25, "Seç", false, window)
	close_ = guiCreateButton(243, 295, 168, 25, "Kapat", false, window)
	bindKey("enter", "down",
		function()
			triggerServerEvent("diceBet:spin", localPlayer, localPlayer)
			destroyElement(window)
		end
	)
	addEventHandler('onClientGUIClick', root,
		function(b)
			if (b == 'left') then
				if (source == ok_) then
					triggerServerEvent("diceBet:spin", localPlayer, localPlayer)
					destroyElement(window)
				elseif (source == close_) then
					destroyElement(window)
					triggerServerEvent("diceBet:remove", localPlayer, localPlayer)
				end
			end
		end
	)
end
addEvent('bekiroj:pairs:showGUI', true)
addEventHandler('bekiroj:pairs:showGUI', root, showGUI)

function inviteGUI(partnerName, price)
	window = guiCreateWindow(722, 463, 483, 167, "Bahis İsteği Penceresi", false)
	guiWindowSetSizable(window, false)
	exports.vrp_global:centerWindow(window)

	ok = guiCreateButton(9, 125, 220, 31, "Kabul Et", false, window)
	deny = guiCreateButton(235, 125, 238, 31, "Reddet", false, window)
	label = guiCreateLabel(8, 33, 465, 57, partnerName.." tarafından bahis isteği aldın.\nPartner: "..partnerName.."\nBahis Ücreti: "..price.."$", false, window)
	guiLabelSetHorizontalAlign(label, "center", false)
	guiLabelSetVerticalAlign(label, "center")
	addEventHandler('onClientGUIClick', root,
		function(b)
			if (b == 'left') then
				if (source == ok) then
					triggerServerEvent("diceBet:invite", localPlayer, localPlayer, "davet", "kabul")
					destroyElement(window)
				elseif (source == deny) then
					destroyElement(window)
					triggerServerEvent("diceBet:invite", localPlayer, localPlayer, "davet", "ret")
				end
			end
		end
	)
end
addEvent('bekiroj:pairs:inviteGUI', true)
addEventHandler('bekiroj:pairs:inviteGUI', root, inviteGUI)

addEvent("diceBet:closeGUI", true)
addEventHandler("diceBet:closeGUI", root,
	function()
		if isElement(window) then destroyElement(window) end
	end
)