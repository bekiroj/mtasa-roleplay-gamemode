-- Bu senaryo bekiroj tarafından yazılmıştır
local pickup = createPickup(1911.296875, -1775.27734375, 13.411722183228, 3, 1318)
setElementData(pickup, "informationicon:information", "#ffffff[tamiret]#90C92F\n200$")

local tamiryeri = createColSphere ( 1911.296875, -1775.27734375, 13.411722183228, 3)

function vehicle_fix(thePlayer)
	if isPedInVehicle(thePlayer) then
		if not isElementWithinColShape(thePlayer, tamiryeri) then return end
		local car = getPedOccupiedVehicle(thePlayer)

		if not exports.vrp_global:takeMoney(thePlayer, 200) then -- tamir fiyatı
			outputChatBox("Sunucu: #ffffffAracınızı tamir etmek için 200$ ödemeniz gerekli.", thePlayer, 255,0,0,true)
		return end

		outputChatBox("Sunucu: #ffffffAracınız tamir ediliyor, bekleyin.", thePlayer, 255,0,0,true)
		toggleAllControls ( thePlayer, false )
		setElementData(car, "enginebroke", 0, false)
		setElementFrozen(car, true)
		setTimer(function()
			triggerEvent("fixVehicle", thePlayer)
			outputChatBox("Sunucu: #ffffffAracınız tamir edildi.", thePlayer, 255,0,0,true)
			 toggleAllControls ( thePlayer, true )
			 setElementFrozen(car, false)
		end, 5000, 1)
	end
end
addCommandHandler("tamiret", vehicle_fix)

addEvent("fixVehicle", true)
addEventHandler("fixVehicle", getRootElement(),
	function()
		fixVehicle(getPedOccupiedVehicle(source))
		setElementData(source, "enginebroke", 0, false)
	end
)