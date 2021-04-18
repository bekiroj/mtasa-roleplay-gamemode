local advertPed = createPed(53, 359.7138671875, 173.8740234375, 1008.3893432617, 271.62738037109)
setElementDimension(advertPed, 13)
setElementInterior(advertPed, 3)
setElementFrozen(advertPed, true)
addEventHandler("onClientClick", root, function(b, s, _, _, _, _, _, elem) if (b == "right" and s == "down" and elem and getElementType(elem) == "ped" and elem == advertPed) then triggerEvent("reklam:HTML", localPlayer, localPlayer)  end end)

addCommandHandler("reklam",
	function(cmd)
		if (getElementData(localPlayer, "vip") >= 1) then
			triggerEvent("reklam:HTML", localPlayer, localPlayer)		
		end
	end
)