localPlayer = getLocalPlayer()

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return false
	end

	if gui["_root"] then
		return
	end

	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)

	theVehicle = source

	guiSetInputEnabled(true)
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	

GUIEditor = {
    button = {},
    window = {},
    label = {}
}
	gui["_root"] = guiCreateWindow(0, 0, 349, 164, "Araç Satın Alma Ekranı - Valhalla", false)
	guiWindowSetSizable(gui["_root"], false)
	exports.vrp_global:centerWindow(gui["_root"])

	gui["btnCash"] = guiCreateButton(9, 122, 211, 32, "Aracı Satın Al", false, gui["_root"])
	gui["btnCancel"] = guiCreateButton(226, 122, 113, 32, "Arayüzü Kapat", false, gui["_root"])
	gui["lblText1"] = guiCreateLabel(7, 27, 332, 38, "Belirtilen aracı satın aldığınızda geri dönüşü olmayacaktır.\nToken sistemi sadece 25,000$ ve altı araçlarda çalışmaktadır.", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblText1"], "center", false)
	gui["lblVehicleCost"] = guiCreateLabel(8, 74, 212, 44, "Araç Markası: "..getElementData(source, "brand").." "..getElementData(source, "model").." "..getElementData(source, "year").."\nAraç Fiyatı: $"..exports.vrp_global:formatMoney(carPrice), false, gui["_root"])
	guiSetFont(gui["lblVehicleCost"], "default-bold-small")

	addEventHandler("onClientGUIClick", gui["btnCash"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnCash"], cashEnabled)
	if exports.vrp_global:hasItem(localPlayer, 263, 1) and carPrice < 25000 then
		guiSetText(gui["btnCash"], "Token ile Al")
		guiSetEnabled(gui["btnCash"], true)
	end

	addEventHandler("onClientGUIClick", gui["btnCancel"], carshop_buyCar_close, false)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyCar)

function carshop_buyCar_click()
	if exports.vrp_global:hasSpaceForItem(getLocalPlayer(), 3, 1) then
		local sourcestr = "cash"
		if (source == gui["btnBank"]) then
			sourcestr = "bank"
		elseif guiGetText(gui["btnCash"]) == "Token ile Al" then
			sourcestr = "token"
		end
		triggerServerEvent("carshop:buyCar", theVehicle, sourcestr)
	else
		outputChatBox("Envanterinizde bir anahtar için yer kalmadığı için satın alamıyorsunuz.", 255, 255, 255, true)
	end
	carshop_buyCar_close()
end


function carshop_buyCar_close()
	if gui["_root"] then
		destroyElement(gui["_root"])
		gui = { }
	end
	guiSetInputEnabled(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end
addEventHandler ( "account:changingchar", getRootElement(), carshop_buyCar_close )
addEventHandler("onClientChangeChar", getRootElement(), carshop_buyCar_close)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	end
)