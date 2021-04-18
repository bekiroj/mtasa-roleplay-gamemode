local region = createColSphere(1559.6904296875, -1687.18359375, 16.1953125, 4)
setElementInterior(region, 0)
setElementDimension(region, 0)

addCommandHandler("cctv",
	function(source, cmd)
		if getElementData(source, "loggedin") == 1 then
			if getElementData(source, "faction") == 1 then
				if isElementWithinColShape(source, region) then
					if not getElementData(source, "cctv") then
						lastint = getElementInterior(source)
						lastdim = getElementDimension(source)
						setElementInterior(source, 0)
						setElementDimension(source, 0)

						setElementFrozen(source, true)
						setElementData(source, "cctv", true)
						triggerClientEvent(source,"ShowBtns",source)
						outputChatBox("[CCTV] #f9f9f9Arayüzü açtınız, kapatmak için /cctv.", source, 30, 30, 30, true)
					else
						setElementInterior(source, lastint)
						setElementDimension(source, lastdim)

						triggerClientEvent(source,"HideBtns",source)
						setElementFrozen(source, false)
						setElementData(source, "cctv", nil)
						setCameraTarget(source)
					end
				else
					outputChatBox("[CCTV] #f9f9f9Bu işlemi kullanabilmek için geçerli alanda olmanız gerekir.", source, 30, 30, 30, true)
				end
			end
		end
	end
)
