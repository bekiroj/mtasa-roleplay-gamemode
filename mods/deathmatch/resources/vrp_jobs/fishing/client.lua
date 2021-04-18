local chars = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,J,K,L,M,N,P,R,S,Q,U,V,X,W,Z"
local codes = split (chars, ",")

addEvent("fisher->active", true)
addEventHandler("fisher->active", root,
	function()

		if isElement(window) or isElement(yemWindow) then return end
		window = guiCreateWindow(0, 0, 420, 223, "Balıkçı: Hoşgeldin.", false)
		exports.vrp_global:centerWindow(window)
		guiWindowSetSizable(window, false)
		guiWindowSetMovable(window, false)

		gridlist = guiCreateGridList(10, 27, 400, 141, false, window)
		guiGridListAddColumn(gridlist, "", 0.9)
		for i = 1, 2 do
		    guiGridListAddRow(gridlist)
		end
		guiGridListSetItemText(gridlist, 0, 1, "Yem Almak İstiyorum", false, false)
		guiGridListSetItemText(gridlist, 1, 1, "Balık Satmak İstiyorum", false, false)
		okButton = guiCreateButton(69, 184, 131, 26, "Evet", false, window)
		closeButton = guiCreateButton(225, 184, 131, 26, "Kapat", false, window)

		addEventHandler("onClientGUIClick", root,
			function(b)
				if b == "left" then
					if source == closeButton then
						destroyElement(window)
					elseif source == okButton then
						local selectedIndex = guiGridListGetSelectedItem(gridlist)
						if selectedIndex == 0 then-- yem al
							destroyElement(window)
							randomCode = codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]
							yemWindow = guiCreateWindow(0, 0, 268, 58, "Bu Kodu Girin: "..randomCode, false)
							exports.vrp_global:centerWindow(yemWindow)
							guiWindowSetSizable(yemWindow, false)

							editbox = guiCreateEdit(9, 21, 249, 27, "", false, yemWindow)
							addEventHandler("onClientGUIChanged", editbox,
								function()
									if guiGetText(source) == randomCode then
										destroyElement(yemWindow)
										triggerServerEvent("@lucyrpg_3e0dcecefcffd651db114f47f04e9a33", localPlayer, localPlayer, "yemal")
									end
								end
							)
						elseif selectedIndex == 1 then-- balık sat
							destroyElement(window)
							triggerServerEvent("@lucyrpg_329c61fb962da98a18a538ef431f6eed", localPlayer, localPlayer, "baliksat")
						end
					end
				end
			end
		)
	end
)