addEvent("vehicleEngineSound", true)
addEventHandler("vehicleEngineSound", root,
	function(src)
		playSound("components/sound/"..src)
	end
)

local vt = getVehicleType
function getVehicleType( ... )
    local ret = vt( ... )
    if ret == "" then
        return "Trailer"
    end
    return ret
end

local disabledType = {
    ["BMX"] = true,
    ["Mountain Bike"] = true,
}
local oldx, oldy, oldz = 0,0,0
local oldOdometerFloor = 0
setTimer(
    function()
        local veh = getPedOccupiedVehicle(localPlayer)
        if veh then
            local seat = getPedOccupiedVehicleSeat(localPlayer)
            if getElementHealth(veh) > 300 and seat == 0 and not disabledType[getVehicleType(veh)] then
                if getElementData(veh, "engine") then
                    local newx, newy, newz = getElementPosition(veh)
                    local addKM = getDistanceBetweenPoints3D(oldx, oldy, oldz, newx, newy, newz) / 500
                    local oldOdometer = getElementData(veh, "odometer") or 0
                    oldx, oldy, oldz = newx, newy, newz
                    if addKM * 500 > 1 then
                        if getVehicleType(veh) ~= "BMX" or getVehicleType(veh) ~= "Mountain Bike" then
                            local newOdometer = getElementData(veh, "odometer") or 0
                            if math.floor(newOdometer) > oldOdometerFloor then
                                local oldFuel = getElementData(veh, "fuel")
                                oldFuel = oldFuel - 1
                                if oldFuel <= 0 then
                                    if getElementData(veh, "engine") then
                                        setElementData(veh, "engine", false)
                                    end
                                    if getVehicleEngineState(veh) then
                                        setVehicleEngineState(veh, false)
                                    end
                                end
                                setElementData(veh, "fuel", oldFuel)
                                oldOdometerFloor = math.floor(newOdometer)
                            end
                        end
                    end
                end
            end
        end
    end, 500, 0
)

local vControlGUI = { }
local controllingVehicle = nil

local vTimers = { }

function openVehicleDoorGUI( vehicleElement )
	if vControlGUI["main"] then
		closeVehicleGUI()
		return
	end
	
	if not vehicleElement then
		controllingVehicle = getPedOccupiedVehicle ( getLocalPlayer() )
	else
		controllingVehicle = vehicleElement
		if controllingVehicle ~= getPedOccupiedVehicle( getLocalPlayer() ) then
			local vehicle1x, vehicle1y, vehicle1z = getElementPosition ( controllingVehicle )
			local player1x, player1y, player1z = getElementPosition ( getLocalPlayer() )
			
			if getDistanceBetweenPoints3D ( vehicle1x, vehicle1y, vehicle1z, player1x, player1y, player1z ) > 5 then
				return
			end
		end
	end
		
	local playerSeat = -1
	for checkingSeat = 0, ( getVehicleMaxPassengers ( controllingVehicle ) or 0 ) do
		if getVehicleOccupant( controllingVehicle, checkingSeat ) == localPlayer then
			playerSeat = checkingSeat
			break
		end
	end
	
	local doors = getDoorsFor(getElementModel(controllingVehicle), playerSeat)
	if #doors == 0 then
		return
	end

	local options = 0
	local guiPos = 30
	vControlGUI["main"] = guiCreateWindow(700,236,272,288,"Vehicle Control",false)	
	for index, doorEntry in ipairs(doors) do
		vControlGUI["scroll"..index] = guiCreateScrollBar(24,guiPos + 17,225,17,true,false,vControlGUI["main"])
		vControlGUI["label"..index] = guiCreateLabel(30,guiPos,135,15,doorEntry[1],false,vControlGUI["main"])
		guiSetFont(vControlGUI["label"..index] ,"default-bold-small")
		setElementData(vControlGUI["scroll"..index], "vehicle:doorcontrol:panel", doorEntry[2], false)
		addEventHandler ( "onClientGUIScroll",vControlGUI["scroll"..index], startTimerUpdateServerSide, false )
		guiPos = guiPos + 40
		
		local currentDoorPos = getVehicleDoorOpenRatio ( controllingVehicle, doorEntry[2] )
		if currentDoorPos then
			currentDoorPos = currentDoorPos * 100
			guiScrollBarSetScrollPosition (vControlGUI["scroll"..index], currentDoorPos )
		end	
	end
		
	guiSetSize(vControlGUI["main"],272,guiPos+40, false)
	vControlGUI["close"] = guiCreateButton(23,guiPos,230,14,"Close",false, vControlGUI["main"])
	addEventHandler ( "onClientGUIClick", vControlGUI["close"], closeVehicleGUI, false )
end
addCommandHandler("doors", openVehicleDoorGUI)

function closeVehicleGUI()
	if vControlGUI["main"] then
		destroyElement(vControlGUI["main"] )
		vControlGUI = { }
		controllingVehicle = nil
	end
end
addEventHandler("onClientPlayerVehicleExit", getLocalPlayer(), closeVehicleGUI)

function startTimerUpdateServerSide(theScrollBar)
	if vControlGUI["main"] then
		local door = getElementData(theScrollBar, "vehicle:doorcontrol:panel")
		if not door then
			return -- Not our element
		end
		
		if vTimers[theScrollBar] then
			return -- Already running a timer
		end
		
		vTimers[theScrollBar] = setTimer(updateServerSide, 400, 1, theScrollBar)
	end
end

function updateServerSide(theScrollBar, state)
	if vControlGUI["main"] then -- and state == "up" then
		
		local door = getElementData(theScrollBar, "vehicle:doorcontrol:panel")
		if not door then
			return
		end
		
		vehicle1x, vehicle1y, vehicle1z = getElementPosition ( controllingVehicle )
		player1x, player1y, player1z = getElementPosition ( getLocalPlayer() )
		if not (getPedOccupiedVehicle ( getLocalPlayer() ) == controllingVehicle) and not (getDistanceBetweenPoints3D ( vehicle1x, vehicle1y, vehicle1z, player1x, player1y, player1z ) < 5) then
			closeVehicleGUI()
			return
		end
		
		if (isVehicleLocked(controllingVehicle)) then
			return
		end
		
		
		local position = guiScrollBarGetScrollPosition(theScrollBar)
		triggerServerEvent("vehicle:control:doors", controllingVehicle, door, position)
		
		vTimers[theScrollBar] = nil
	end
end

local doorTypeRotation = {
    [1] = {-72, 0, 0}, -- scissor
    [2] = {-35, 0, -60} -- butterfly
}


local doorIDComponentTable = {
    [2] = "door_lf_dummy",
    [3] = "door_rf_dummy",
    [4] = "door_lr_dummy",
    [5] = "door_rr_dummy"
                        }
local vDoorType = {}
addEventHandler('onClientResourceStart', resourceRoot,
    function()
        for i, v in pairs ( getElementsByType("vehicle")) do
            local doorType = getElementData ( v, "vDoorType" )
            if doorType then
                vDoorType[v] = doorType
            end
        end
    end)

local function elementDataChange ( key, oldValue )
    if key == "vDoorType" and getElementType(source) == 'vehicle' then
        local t = getElementData ( source, "vDoorType" )
        if t and doorTypeRotation[t] then
            vDoorType[source] = t
        else
            vDoorType[source] = nil
            for door, dummyName in pairs(doorIDComponentTable) do
                local ratio = getVehicleDoorOpenRatio(source, door)
                setVehicleComponentRotation( source, dummyName, 0, 0, 0 )
                setVehicleDoorOpenRatio(source, door, ratio)
            end
        end
    end
end
addEventHandler ( "onClientElementDataChange", root, elementDataChange )
 
local function preRender ()
    for v, doorType in pairs ( vDoorType ) do
        if isElement(v) then
            if isElementStreamedIn(v) then
                for door, dummyName in pairs ( doorIDComponentTable ) do
                    local ratio = getVehicleDoorOpenRatio(v, door)
                    local rx, ry, rz = unpack(doorTypeRotation[doorType])
                    local rx, ry, rz = rx*ratio, ry*ratio, rz*ratio
                    if string.find(dummyName,"rf") or string.find(dummyName,"rr") then
                        ry, rz = ry*-1, rz*-1
                    end
                    setVehicleComponentRotation ( v, dummyName, rx, ry, rz )
                end
            end
        else
            vDoorType[v] = nil
        end
    end
end
addEventHandler ( "onClientPreRender", root, preRender )

addEventHandler('onClientPlayerVehicleEnter', localPlayer,
    function(vehicle, seat)
        if seat == 0 then
            setVehicleEngineState(vehicle, false)
        end
    end
)

local vehicle = nil
local ax, ay = 0, 0

function requestInventory(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		if isVehicleLocked(vehicle) and vehicle ~= getPedOccupiedVehicle(localPlayer) then
			triggerServerEvent("onVehicleRemoteAlarm", vehicle)
			outputChatBox("Bu araç kilitli.", 255, 0, 0)
		elseif type(getElementData(vehicle, "Impounded")) == "number" and isVehicleImpounded(vehicle) and not exports.vrp_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then
			outputChatBox("Aracı aramak için anahtara ihtiyacın var.", 255, 0, 0)
		elseif (getElementData(vehicle, "owner") ~= getElementData(localPlayer, "dbid")) and not exports.vrp_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) then 
			outputChatBox("#575757Valhalla: #ffffffBu işlemi yapabilmek için aracın anahtarına sahip olmalısınız.", 255, 0, 0, true)
		else
			triggerServerEvent( "openFreakinInventory", localPlayer, vehicle, ax, ay )
		end
	end
end

function clickVehicle(button, state, absX, absY, wx, wy, wz, element)
    if getElementData(getLocalPlayer(), "exclusiveGUI") then
        return
    end
    if (element) and (getElementType(element)=="vehicle") and (button=="right") and (state=="down") then
        local x, y, z = getElementPosition(localPlayer)
        if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
            ax = absX
            ay = absY
            vehicle = element
        end
    end
end
addEventHandler("onClientClick", root, clickVehicle, true)

function isNotAllowedV(theVehicle)
    return false
end

function lockUnlock(button, state)
    if (button=="left") then
        if getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == vehicle then
            triggerServerEvent("lockUnlockInsideVehicle", localPlayer, vehicle)
        elseif exports.vrp_global:hasItem(localPlayer, 3, getElementData(vehicle, "dbid")) or (exports["vrp_factions"]:isPlayerInFaction(localPlayer, getElementData(vehicle, "faction"))) then
            triggerServerEvent("lockUnlockOutsideVehicle", localPlayer, vehicle)
        end
    end
end

function fStretcher(button, state)
    if (button=="left") then
        if not (isVehicleLocked(vehicle)) then
            triggerServerEvent("stretcher:createStretcher", getLocalPlayer(), false, vehicle)
        end
    end
end

function fLook(button, state)
    if (button=="left") then
        triggerEvent("editdescription", getLocalPlayer())
    end
end

function fDoorControl(button, state)
	if (button=="left") then
		openVehicleDoorGUI( vehicle )
	end
end

function parkTrailer(button, state)
    if (button=="left") then
        triggerServerEvent("parkVehicle", localPlayer, vehicle)
    end
end
function factionParkTrailer(button, state)
    if (button=="left") then
        triggerServerEvent("fparkVehicle", localPlayer, localPlayer, false, vehicle)
    end
end

function fillFuelTank(button, state)
    if (button=="left") then
        local _,_, value = exports.vrp_global:hasItem(localPlayer, 57)
        if value > 0 then
            triggerServerEvent("fillFuelTankVehicle", localPlayer, vehicle)
        else
            outputChatBox("Bu yakıt boş olabilir...", 255, 0, 0)
        end
    end
end

function openMechanicWindow(button, state)
    if (button=="left") then
        triggerEvent("openMechanicFixWindow", localPlayer, vehicle)
    end
end

function toggleRamp(button)
    if (button=="left") then
        triggerServerEvent("vehicle:control:ramp", localPlayer, vehicle)
    end
end

function sitInHelicopter(button, state)
    if (button=="left") then
        triggerServerEvent("sitInHelicopter", localPlayer, vehicle)
    end
end

function unsitInHelicopter(button, state)
    if (button=="left") then
        triggerServerEvent("unsitInHelicopter", localPlayer, vehicle)
    end
end

function enterInterior()
    triggerServerEvent( "enterVehicleInterior", getLocalPlayer(), vehicle )
end

function knockVehicle()
    triggerServerEvent("onVehicleKnocking", getLocalPlayer(), vehicle)
end

function handbrakeVehicle()
    triggerServerEvent("vehicle:handbrake", vehicle)
end

function cabrioletToggleRoof()
    triggerServerEvent("vehicle:toggleRoof", getLocalPlayer(), vehicle)
end

function fTextures()
    triggerEvent("item-texture:vehtex", localPlayer, vehicle)
end

function pTextures()
    triggerEvent("item-texture:previewVehTex", localPlayer, vehicle) 
end

function fLadder(button, state)
    if (button=="left") then
        local vx, vy, vz = getElementPosition(vehicle)
        setElementPosition(localPlayer, vx, vy-4, vz+1.55)
    end
end

function clientUpdateSirens()
    if(source == localPlayer) then
        local vehicles = getElementsByType("vehicle")
        for k,v in ipairs(vehicles) do
            local model = getElementModel(v)
            --stage 1: Check models
            if(model == 525) then --towtruck
                addVehicleSirens(veh, 3, 4, true, true, true, true)
                triggerEvent("sirens:setroofsiren", localPlayer, veh, 1, -0.7, -0.35, -0.7, 255, 0, 0)
                triggerEvent("sirens:setroofsiren", localPlayer, veh, 2, 0, -0.35, -0.7)
                triggerEvent("sirens:setroofsiren", localPlayer, veh, 3, 0.7, -0.35, -0.7, 255, 0, 0)
                return true
            --stage 2: Check items
            elseif(exports.vrp_global:hasItem(v, 144)) then --single yellow strobe (airport, etc.)
                addVehicleSirens(veh, 1, 2, true, true, false, true)
                triggerClientEvent("sirens:setroofsiren", localPlayer, veh, 1, 0, 0, -0.2)
            end
        end
    end
end
addEventHandler("onClientPlayerJoin", getRootElement(), clientUpdateSirens)

local inactive_vehicles = {}
addEvent("showVehiclesPanel", true)
addEventHandler("showVehiclesPanel", root,
	function(table)
		if isElement(window) then
			return false
		end
		inactive_vehicles = table
		window = guiCreateWindow(0, 0, 389, 366, "İnaktif Araçlarım - Valhalla", false)
        guiWindowSetSizable(window, false)
        exports.vrp_global:centerWindow(window)

        grid = guiCreateGridList(10, 24, 368, 250, false, window)
        local colID = guiGridListAddColumn(grid, "ID", 0.5)
        local colName = guiGridListAddColumn(grid, "Araç Adı", 0.5)
        if #inactive_vehicles > 0 then
	        for index, value in ipairs(inactive_vehicles) do
	            local row = guiGridListAddRow(grid)
		    	guiGridListSetItemText(grid, row, colID, value:getData('dbid'), false, true)
	            guiGridListSetItemData(grid, row, colID, value:getData('dbid'))

	            if isElement(value) then
	            	if value:getData('brand') then
	            		guiGridListSetItemText(grid, row, colName, (value:getData('year') or "N/A").." "..(value:getData('brand') or "N/A").." "..(value:getData('model') or "N/A"), false, true)
	            	else
	            		guiGridListSetItemText(grid, row, colName, getVehicleName(value), false, true)
	            	end
	            end
	        end
	     end
        ok = guiCreateButton(10, 284, 368, 31, "Aracı Aktif Et", false, window)
        deny = guiCreateButton(11, 325, 367, 31, "Arayüzü Kapat", false, window)

        addEventHandler('onClientGUIClick', ok,
        	function(b)
        		if (source == ok) then
        			local row, col = guiGridListGetSelectedItem(grid)
        			if row ~= -1 and col ~= -1 then
        				local vehid = guiGridListGetItemData(grid, row, colID)

        				triggerServerEvent("inactive:active_vehicle",localPlayer,localPlayer,vehid)
        				outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Araç başarıyla aktif edildi.", 255, 255, 255, true)
        			else
        				outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Aktif etmek istediğiniz araç ID'yi girin.", 255, 255, 255, true)
        			end
        		end
        	end
        )

        addEventHandler('onClientGUIClick', deny,
        	function(b)
        		if (source == deny) then
        			destroyElement(window)
        		end
        	end
        )
	end
)

function openMechanicWindow(element, state)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		triggerEvent("openMechanicFixWindow", localPlayer, vehicle)
	end
end

function toggleRamp(button)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
		triggerServerEvent("vehicle:control:ramp", localPlayer, vehicle)
	end
end

function sitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("sitInHelicopter", localPlayer, vehicle)
	end
end

function unsitInHelicopter(button, state)
	if (button=="left") then
		triggerServerEvent("unsitInHelicopter", localPlayer, vehicle)
	end
end

function enterInterior()
	triggerServerEvent( "enterVehicleInterior", getLocalPlayer(), vehicle )
end

function knockVehicle()
	triggerServerEvent("onVehicleKnocking", getLocalPlayer(), vehicle)
end

function handbrakeVehicle()
	triggerServerEvent("vehicle:handbrake", vehicle)
end

function cabrioletToggleRoof()
	triggerServerEvent("vehicle:toggleRoof", getLocalPlayer(), vehicle)
end

function fRespawn(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
	triggerServerEvent("vehicle-manager:respawn", getLocalPlayer(), vehicle)
end
end

function fTextures(element)
	if (element) and (getElementType(element)=="vehicle") then
		vehicle = element
	triggerEvent("item-texture:vehtex", localPlayer, vehicle)
end
end