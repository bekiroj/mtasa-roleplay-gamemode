-- @bekiroj


function onStealthKill(targetPlayer)
    cancelEvent(true)
end
addEventHandler("onPlayerStealthKill", getRootElement(), onStealthKill)


function changeBlurLevel()
    setPlayerBlurLevel ( source, 0 )
end

addEventHandler ( "onPlayerJoin", getRootElement(), changeBlurLevel )

 
function scriptStart()
    setPlayerBlurLevel ( getRootElement(), 0)
end

addEventHandler ("onResourceStart",getResourceRootElement(getThisResource()),scriptStart)

function scriptRestart()
	setTimer ( scriptStart, 1000, 1 )
end

addEventHandler("onResourceStart",getRootElement(),scriptRestart)


function respawnTheVehicle(vehicle)
	setElementCollisionsEnabled(vehicle, true)
	respawnVehicle(vehicle)
end

function unhookTrailer(thePlayer)
   if (isPedInVehicle(thePlayer)) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        if theVehicle then
            detachTrailerFromVehicle(theVehicle) 
        end
   end
end
addCommandHandler("detach", unhookTrailer)
addCommandHandler("unhook", unhookTrailer)

local noBelt = { [431] = true, [437] = true }
function seatbelt(thePlayer)
	if getPedOccupiedVehicle(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (getVehicleType(theVehicle) == "BMX" or getVehicleType(theVehicle) == "Bike") or (noBelt[getElementModel(theVehicle)] and getVehicleOccupant(theVehicle, 0) ~= thePlayer) then
			outputChatBox("#575757Valhalla: #F0F0F0Bu araçta emniyet kemeri bulunmamaktadır.", thePlayer, 255, 0, 0, true)
		else
			if 	(getElementData(thePlayer, "seatbelt") == true) then
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
				outputChatBox("#FF0000#575757Valhalla: #FFFFFFEmniyet kemerini başarıyla çıkardınız.", thePlayer, 0, 0, 0, true)
				exports.vrp_global:sendLocalMeAction(thePlayer, "sağ eli ile kıskaçtan kemeri çıkartır ve asar.")
			else
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", true, true)
				outputChatBox("#FF0000#575757Valhalla: #FFFFFFEmniyet kemerini başarıyla taktınız.", thePlayer, 0, 0, 0, true)
				exports.vrp_global:sendLocalMeAction(thePlayer, "sağ ve sol ellerini emniyet kemerine götürüp takar.")
			end
		end
	end
end
addCommandHandler("seatbelt", seatbelt)
addCommandHandler("belt", seatbelt)
addEvent('realism:seatbelt:toggle', true)
addEventHandler('realism:seatbelt:toggle', root, seatbelt)

function removeSeatbelt(thePlayer)
	if getElementData(thePlayer, "seatbelt") and not isPedInVehicle(thePlayer) then
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
		exports.vrp_global:sendLocalMeAction(thePlayer, "sağ eli ile kıskaçtan kemeri çıkartır ve asar.")
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeSeatbelt)

function seatbeltFix()
	local counter = 0
	for _, thePlayer in ipairs(getElementsByType("player")) do
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
		counter = counter + 1
	end
	--outputDebugString("Fixed for " .. counter .. " players")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), seatbeltFix)
--addCommandHandler("fixbelts", seatbeltFix, false, false)

local disabled = {[425] = true, [520] = true, [476] = true, [464] = true, [430] = true, [432] = true, [447] = true}

addEventHandler("onPlayerVehicleEnter", root,
    function(vehicle)
        local enabled = not disabled[getElementModel(vehicle)]
        if getElementType( source ) == "player" then
            toggleControl(source, 'vehicle_fire', enabled)
            toggleControl(source, 'vehicle_secondary_fire', enabled)
        end
    end)

addEventHandler("onResourceStart", resourceRoot,
    function()
        for _, player in ipairs(getElementsByType("player")) do
            local vehicle = getPedOccupiedVehicle(player)
            if vehicle then
                local enabled = not disabled[getElementModel(vehicle)]
                toggleControl(player, 'vehicle_fire', enabled)
                toggleControl(player, 'vehicle_secondary_fire', enabled)
            end
        end
    end)

addEvent("realism:startdrinking", true)
addEventHandler("realism:startdrinking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:drinkingsync", source, true, hand)
		exports.vrp_anticheat:changeProtectedElementDataEx(source, "realism:drinking", true, false )
		exports.vrp_anticheat:changeProtectedElementDataEx(source, "realism:drinking:hand", hand, false )
		setTimer ( stopdrinking, 300000, 1, thePlayer )
	end
);


function stopdrinking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isdrinking = getElementData(thePlayer, "realism:drinking")
		if (isdrinking) then
			triggerClientEvent("realism:drinkingsync", thePlayer, false, 0)
			exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:drinking", false, false )
		end
	end
end
addEvent("realism:stopdrinking", true)
addEventHandler("realism:stopdrinking", getRootElement(), stopdrinking)

function stopdrinkingCMD(thePlayer)
	local isdrinking = getElementData(thePlayer, "realism:drinking")
	if (isdrinking) then
		stopdrinking(thePlayer)
		exports.vrp_global:sendLocalMeAction(thePlayer, "throws their beerette on the ground.")
	end
end
addCommandHandler("throwbeer", stopdrinkingCMD)

-- Sync to new players
addEvent("realism:drinking.request", true)
addEventHandler("realism:drinking.request", getRootElement(), 
	function ()
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isdrinking = getElementData(thePlayer, "realism:drinking")
			if (isdrinking) then
				local drinkingHand = getElementData(thePlayer, "realism:drinking:hand")
				triggerClientEvent(source, "realism:drinkingsync", thePlayer, isdrinking, drinkingHand)
			end
		end
	end
);

alarmless = { [592]=true, [553]=true, [577]=true, [488]=true, [511]=true, [497]=true, [548]=true, [563]=true, [512]=true, [476]=true, [593]=true, [447]=true, [425]=true, [519]=true, [20]=true, [460]=true, [417]=true, [469]=true, [487]=true, [513]=true, [581]=true, [510]=true, [509]=true, [522]=true, [481]=true, [461]=true, [462]=true, [448]=true, [521]=true, [468]=true, [463]=true, [586]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [537]=true, [538]=true, [569]=true, [590]=true, [441]=true, [464]=true, [501]=true, [465]=true, [564]=true, [571]=true, [471]=true, [539]=true, [594]=true }

function onVehicleDamage(ignoredElement)
	local driver = getVehicleOccupant(source, 0)
	local passenger1 = getVehicleOccupant(source, 1)
	local passenger2 = getVehicleOccupant(source, 2)
	local passenger3 = getVehicleOccupant(source, 3)

	if isVehicleLocked(source) and not alarmless[getElementModel(source)]  and (not driver or driver == ignoredElement) and (not passenger1 or passenger1 == ignoredElement) and (not passenger2 or passenger2 == ignoredElement) and (not passenger3 or passenger3 == ignoredElement) then
	
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for _, arrayPlayer in ipairs(players) do
			local x, y, z = getElementPosition(source)
			local vDim = getElementDimension(source)
			local vInt = getElementInterior(source)
			local px, py, pz = getElementPosition(arrayPlayer)
			local pDim = getElementDimension(arrayPlayer)
			local pInt = getElementDimension(arrayPlayer)
			if (pDim == vDim and pInt == vInt and getDistanceBetweenPoints2D(x, y, px, py) <= 30) then
				triggerClientEvent(arrayPlayer, "startCarAlarm", source)
			end
		end	
	end
end
addEventHandler("onVehicleDamage", getRootElement(), onVehicleDamage)
addEvent("onVehicleRemoteAlarm", true)
addEventHandler("onVehicleRemoteAlarm", getRootElement(), onVehicleDamage)


-- Make a district when alarm is triggered
function district()
end
addEvent("alarmDistrict", true)
addEventHandler("alarmDistrict", getRootElement(), district)

function quitPlayer(quitReason, reason)
	if not (getElementData(source, "reconx")) then
		if (quitReason == "Timed out") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (zaman aşımı)", nil, nil, nil, 10)
		elseif (quitReason == "Bad Connection") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (bağlantı problemi)", nil, nil, nil, 10)
		elseif (quitReason == "Kicked") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (atıldı)", nil, nil, nil, 10)
		elseif (quitReason == "Banned") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (yasaklandı)", nil, nil, nil, 10)
		elseif (quitReason == "Quit") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (kendi isteğiyle)", nil, nil, nil, 10)
		elseif (quitReason == "Unknown") then
			exports.vrp_global:sendLocalText(source, ""..getPlayerName(source):gsub("_", " ").." sunucudan ayrıldı. (bilinmeyen)", nil, nil, nil, 10)			
		end
	end
end
addEventHandler("onPlayerQuit",getRootElement(), quitPlayer)

addEvent("setDrunkness", true)
addEventHandler("setDrunkness", getRootElement(),
	function( level )
		exports.vrp_anticheat:changeProtectedElementDataEx( source, "alcohollevel", level or 0, false )
	end
)

addEvent("realism:startsmoking", true)
addEventHandler("realism:startsmoking", getRootElement(),
	function(hand)
		if not (hand) then
			hand = 0
		else
			hand = tonumber(hand)
		end	
		
		triggerClientEvent("realism:smokingsync", source, true, hand)
		exports.vrp_anticheat:changeProtectedElementDataEx(source, "realism:smoking", true, false )
		exports.vrp_anticheat:changeProtectedElementDataEx(source, "realism:smoking:hand", hand, false )
	end
);


function Bind1(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    duman = createObject(2012,0,0,0) 
    if (sigara) then
       exports.vrp_global:applyAnimation(thePlayer, "SMOKING", "M_smkstnd_loop", 6000, false, true, true)
       triggerEvent("realism:startsmoking", thePlayer, 0)
       setTimer ( function()
        exports.vrp_bone_attach:attachElementToBone(duman,thePlayer,1,0,0,0,0,266,0)
        end, 5000, 1 )
       setTimer ( function()
        exports.vrp_bone_attach:detachElementFromBone(duman) 
        moveObject(duman, 1 ,0 ,0 ,0) 
        end, 8000, 1 )
   end
end

function Bind2(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    duman = createObject(2012,0,0,0) 
    if (sigara) then
       exports.vrp_global:applyAnimation(thePlayer, "GANGS", "smkcig_prtl", 8000, false, true, true)
       triggerEvent("realism:startsmoking", thePlayer, 1)
       setTimer ( function()
        exports.vrp_bone_attach:attachElementToBone(duman,thePlayer,1,0,0,0,0,266,0)
        end, 5000, 1 )
       setTimer ( function()
        exports.vrp_bone_attach:detachElementFromBone(duman) 
        moveObject(duman, 1 ,0 ,0 ,0) 
        end, 8000, 1 ) 
   end
end

function saniye(thePlayer)
    local sigara = getElementData(thePlayer, "realism:smoking")
    if (sigara) then
        setTimer( function()
            stopSmoking(thePlayer)
            end, 180000, 1)
    end
end
addEvent("realism:sigarasaniye", true)
addEventHandler("realism:sigarasaniye", getRootElement(), saniye)


function theBinds(thePlayer, commandName)
    bindKey ( thePlayer, "1", "down", Bind1 )
    bindKey ( thePlayer, "2", "down", Bind2 )
end
addEvent("realism:smokingbinds", true)
addEventHandler("realism:smokingbinds", getRootElement(), theBinds)

function stopSmoking(thePlayer)
	if not thePlayer then
		thePlayer = source
	end
	
	if (isElement(thePlayer)) then	
		local isSmoking = getElementData(thePlayer, "realism:smoking")
		local smokingJoint = getElementData(thePlayer, "realism:joint") -- If the player is smoking a Joint, not a ciggy
        if (smokingJoint) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
                exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
                return
        end
        if (isSmoking) then
                triggerClientEvent("realism:smokingsync", thePlayer, false, 0)
                exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
        end
	end
end
addEvent("realism:stopsmoking", true)
addEventHandler("realism:stopsmoking", getRootElement(), stopSmoking)

function stopSmokingCMD(thePlayer)
    local isSmoking = getElementData(thePlayer, "realism:smoking")
    local smokingJoint = getElementData(thePlayer, "realism:joint")
    if (smokingJoint) then
        stopSmoking(thePlayer)
        exports.vrp_global:sendLocalMeAction(thePlayer, "throws their joint on the ground.")
        return
    end
    if (isSmoking) then
        stopSmoking(thePlayer)
        unbindKey ( thePlayer, "1", "down", Bind1 )
        unbindKey ( thePlayer, "2", "down", Bind2 )
        exports.vrp_global:sendLocalMeAction(thePlayer, "sağ elindeki sigarayı yere atar.")
    end
end
addCommandHandler("sigaraat", stopSmokingCMD)

function changeSmokehand(thePlayer)
	local isSmoking = getElementData(thePlayer, "realism:smoking")
	if (isSmoking) then
		local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
		triggerClientEvent("realism:smokingsync", thePlayer, true, 1-smokingHand)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking:hand",1-smokingHand, false )
	end
end
addCommandHandler("switchhand", changeSmokehand)

function passJointCMD(thePlayer, commandName, target)
    if (not target) then
        outputChatBox("KULLANIM: /" .. commandName .. " [Player Partial Nick/ID]", thePlayer, 255, 194, 14)
        return
    end
   
    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
    if (not targetPlayer) then
        outputChatBox("No such player found.", thePlayer, 255, 0, 0)
        return
    end
    if (thePlayer == targetPlayer) then
        outputChatBox("Ahm, you're already smoking this one..", thePlayer, 255, 0, 0)
        return
    end
   
    local x, y, z = getElementPosition(thePlayer)
    local tx, ty, tz = getElementPosition(targetPlayer)
    if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz) <= 3) then
        local smokingJoint = getElementData(thePlayer, "realism:joint")
        if (smokingJoint) then
            stopSmoking(thePlayer)
            exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:joint", false, false )
            exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "realism:smoking", false, false )
            exports.vrp_global:sendLocalMeAction(thePlayer, "passes a joint to " .. targetPlayerName .. ".")
            outputChatBox( "(( /throwaway to throw it away, /switchhand to change hand, /passjoint to pass your joint ))", targetPlayer )
            setElementData(targetPlayer, "realism:joint", true)
            triggerEvent("realism:startsmoking", targetPlayer, 0)
        end
    else
        outputChatBox("You are not close enough to " .. targetPlayerName .. "!", thePlayer, 255, 0, 0)
    end
end
addCommandHandler("passjoint", passJointCMD, false, false)

-- Sync to new players
addEvent("realism:smoking.request", true)
addEventHandler("realism:smoking.request", getRootElement(), 
	function ()
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for key, thePlayer in ipairs(players) do
			local isSmoking = getElementData(thePlayer, "realism:smoking")
			if (isSmoking) then
				local smokingHand = getElementData(thePlayer, "realism:smoking:hand")
				triggerClientEvent(source, "realism:smokingsync", thePlayer, isSmoking, smokingHand)
			end
		end
	end
);

local syncedElements = { }
local weaponmodels = { [1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341, [15]=326, [22]=346, [23]=347, [24]=348, [25]=349, [26]=350, [27]=351, [28]=352, [29]=353, [32]=372, [30]=355, [31]=356, [33]=357, [34]=358, [35]=359, [36]=360, [37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366, [43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371, [40]=364, [100]=373 }



local handbrakeTimer = {}
local someExceptions = {
	[573] = true,
	[556] = true,
	[444] = true, --Monster Truck
}
function toggleHandbrake( player, vehicle, forceOnGround, commandName )
	local handbrake = getElementData(vehicle, "handbrake")
	local kickstand = false
	if commandName == nil then
		kickstand = getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike'
	else
		kickstand = commandName == 'kickstand'
	end
	--outputDebugString(tostring(kickstand) .. " " .. tostring(commandName) .. " " .. tostring(forceOnGround))
	if (handbrake == 0) then
		if getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike' then
			if not kickstand then
				outputChatBox('Bu araçta bir el freni yok.', player, 255, 0, 0)
			elseif not isVehicleOnGround(vehicle) and not forceOnGround then
				outputChatBox('Bu özelliğin çalışması için zeminde olmanız gerekmektedir.', player, 255, 0, 0)
			elseif math.floor(exports.vrp_global:getVehicleVelocity(vehicle)) > 2 then
				outputChatBox("Hareket halinde el frenini çekemezsiniz.", player, 255, 0, 0)
			else
				exports.vrp_anticheat:changeProtectedElementDataEx(vehicle, "handbrake", 1, true)
				setElementFrozen(vehicle, true)
			end
		elseif (isVehicleOnGround(vehicle) or forceOnGround) or getVehicleType(vehicle) == "Boat" or getVehicleType(vehicle) == "Helicopter" or someExceptions[getVehicleType(vehicle)] then
			if kickstand then
				outputChatBox('Bu araçta kickstand yoktur.', player, 255, 0, 0)
				return false
			end
			setControlState ( player, "handbrake", true )
			playSoundHandbrake(vehicle, "on")
			exports.vrp_anticheat:changeProtectedElementDataEx(vehicle, "handbrake", 1, true)
			handbrakeTimer[vehicle] = setTimer(function ()
				setElementFrozen(vehicle, true)
				--outputChatBox("Handbrake has been applied.", player, 0, 255, 0)
				setControlState ( player, "handbrake", false )
			end, 3000, 1)
		end
	else
		if getVehicleType(vehicle) == 'BMX' or getVehicleType(vehicle) == 'Bike' then
			if not kickstand then
				outputChatBox('Bu araçta El Freni mevcut değildir.', player, 255, 0, 0)
				return
			end
		else
			if kickstand then
				outputChatBox('Bu araçta kickstand mevcut değildir.', player, 255, 0, 0)
				return
			end
		end

		if isTimer(handbrakeTimer[vehicle]) then
			killTimer(handbrakeTimer[vehicle])
			setControlState ( player, "handbrake", false )
		end
		exports.vrp_anticheat:changeProtectedElementDataEx(vehicle, "handbrake", 0, true)
		setElementFrozen(vehicle, false) 
		--outputChatBox("Handbrake has been released.", player, 0, 255, 0)
		triggerEvent("vehicle:handbrake:lifted", vehicle, player)
		playSoundHandbrake(vehicle, "off")
	end	
end

addEvent("vehicle:handbrake:lifted", true)

addEvent("vehicle:handbrake", true)
addEventHandler( "vehicle:handbrake", root, function(forceOnGround, commandName) toggleHandbrake( client, source, forceOnGround, commandName ) end )


function playSoundHandbrake(veh, state)
	for i = 0, getVehicleMaxPassengers( veh ) do
		local player = getVehicleOccupant( veh, i )
		if player then
			triggerClientEvent(player, "playSoundHandbrake", player, state)
		end
	end
end


addEventHandler( "onVehicleEnter", getRootElement( ),
	function( player )
		if exports.vrp_global:hasItem( source, 84 ) then
			setTimer( triggerClientEvent, 1000, 1, player, "enablePoliceRadar", player )
		end
	end
)

function engineBreak()
	local health = getElementHealth(source)
	local driver = getVehicleController(source)
	local vehID = getElementData(source, "dbid")
	
	if (driver) then
		if (health<=300) then
			local rand = math.random(1, 2)

			if (rand==1) then -- 50% chance
				setVehicleEngineState(source, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(source, "engine", 0, false)
				exports.vrp_global:sendLocalDoAction(driver, "Aracın motoru bozulmuştur.")
				-- Take key / Give key to player when engine off by Anthony
				if exports['vrp_global']:hasItem(source, 3, vehID) then
					exports['vrp_global']:takeItem(source, 3, vehID)
					exports['vrp_global']:giveItem(driver, 3, vehID)
				else
				end
			end
		elseif (health<=400) then
			local rand = math.random(1, 5)

			if (rand==1) then -- 20% chance
				setVehicleEngineState(source, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(source, "engine", 0, false)
				exports.vrp_global:sendLocalDoAction(driver, "Aracın motoru bozulmuştur.")
				-- Take key / Give key to player when engine off by Anthony
				if exports['vrp_global']:hasItem(source, 3, vehID) then
					exports['vrp_global']:takeItem(source, 3, vehID)
					exports['vrp_global']:giveItem(driver, 3, vehID)
				else
				end
			end
		end
	end
end
addEventHandler("onVehicleDamage", getRootElement(), engineBreak)

lawVehicles = { [416]=true, [433]=true, [427]=true, [490]=true, [528]=true, [407]=true, [544]=true, [523]=true, [470]=true, [598]=true, [596]=true, [597]=true, [599]=true, [432]=true, [601]=true }

function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	local seat = getPedOccupiedVehicleSeat(source)

	if (vehicle) then
		exports.vrp_anticheat:changeProtectedElementDataEx(vehicle, "radiostation", station, false)
		for i = 0, getVehicleMaxPassengers(vehicle) do
			if (i~=seat) then
				local occupant = getVehicleOccupant(vehicle, i)
				if (occupant) then
					triggerClientEvent(occupant, "syncRadio", occupant, station)
				end
			end
		end
	end
end
addEvent("sendRadioSync", true)
addEventHandler("sendRadioSync", getRootElement(), syncRadio)

function setRadioOnEnter(player)
	if not (lawVehicles[getElementModel(source)]) then
		local station = getElementData(source, "radiostation")
		if not station then
			station = math.random(1, 12)
			exports.vrp_anticheat:changeProtectedElementDataEx(source, "radiostation", station, false)
		end
		triggerClientEvent(player, "syncRadio", player, station)
	else
		triggerClientEvent(player, "syncRadio", player, 0)
	end
end
addEventHandler("onVehicleEnter", getRootElement(), setRadioOnEnter)

validWalkingStyles = { [0]=true, [57]=true, [58]=true, [59]=true, [60]=true, [61]=true, [62]=true, [63]=true, [64]=true, [65]=true, [66]=true, [67]=true, [68]=true, [118]=true, [119]=true, [120]=true, [121]=true, [122]=true, [123]=true, [124]=true, [125]=true, [126]=true, [128]=true, [129]=true, [130]=true, [131]=true, [132]=true, [133]=true, [134]=true, [135]=true, [136]=true, [137]=true, [138]=true }
local mysql = exports.vrp_mysql
local connection = mysql:getConnection()
addEventHandler("onResourceStart", root,
    function(startedRes)
        if getResourceName(startedRes) == "vrp_mysql" then
            connection = exports.vrp_mysql:getConnection()
            restartResource(getThisResource())
        end
    end
)

function setWalkingStyle(thePlayer, commandName, walkingStyle)
	if not walkingStyle or not validWalkingStyles[tonumber(walkingStyle)] or not tonumber(walkingStyle) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Yürüyüş Stili ID]", thePlayer, 255, 194, 14)
		outputChatBox("'/walklist' komutunu kullanarak yürüyüş listesini gözlemleyebilirsiniz.", thePlayer, 255, 194, 14)
	else
		local dbid = getElementData(thePlayer, "dbid")
		local updateWalkingStyleSQL = dbExec(connection, "UPDATE `characters` SET `walkingstyle`='" .. (tonumber(walkingStyle)) .. "' WHERE `id`='".. (tostring(dbid)) .."'")
		if updateWalkingStyleSQL then
			--setElementData(thePlayer, "walkingstyle", walkingStyle)
			setElementData(thePlayer, "walkingstyle", walkingStyle, true)
			setPedWalkingStyle(thePlayer, tonumber(walkingStyle))
			outputChatBox("#575757Valhalla:#f9f9f9 Walking style successfully set to: " .. walkingStyle, thePlayer, 0, 255, 0, true)
		else
			outputChatBox("#575757Valhalla:#f9f9f9 Bir hata oluştu.", thePlayer, 255, 0, 0, true)
		end
	end
end
addCommandHandler("setwalkingstyle", setWalkingStyle)
addCommandHandler("setwalk", setWalkingStyle)

function applyWalkingStyle(style, ignoreSQL)
	local gender = getElementData(source, "gender")
	local charid = getElementData(source, "dbid")
	if not style or not validWalkingStyles[tonumber(style)] then
		outputDebugString("Invalid Walking style detected on "..getPlayerName(source))
		if gender == 1 then
			style = 129
		else
			style = 128
		end
		ignoreSQL = true
	else
		ignoreSQL = false
	end

	if not ignoreSQL then
		--outputDebugString("Updated walking style to SQL.")
		dbExec(connection, "UPDATE `characters` SET `walkingstyle`='" .. (style) .. "' WHERE `id`='".. (charid) .."'")
	end
	setElementData(source, "walkingstyle", tonumber(style), true)
	setPedWalkingStyle(source, tonumber(style))
end
addEvent("realism:applyWalkingStyle", true)
addEventHandler("realism:applyWalkingStyle", root, applyWalkingStyle)

function switchWalkingStyle()
	--local gender = getElementData(source, "gender")
	--local charid = getElementData(source, "dbid")
	local walkingStyle = getElementData(client, "walkingstyle")
	walkingStyle = tonumber(walkingStyle) or 57
	local nextStyle = getNextValidWalkingStype(walkingStyle)
	if not nextStyle then
		nextStyle = getNextValidWalkingStype(56)
	end
	triggerEvent("realism:applyWalkingStyle", client, nextStyle)
end
addEvent("realism:switchWalkingStyle", true)
addEventHandler("realism:switchWalkingStyle", root, switchWalkingStyle)

function getNextValidWalkingStype(cur)
	cur = tonumber(cur)
	local found = false
	for i = cur, 138 do
		if validWalkingStyles[i+1] then
			found = i+1
			break
		end
	end
	
	return found
end


function walkStyleList(thePlayer, commandName)
	outputChatBox("Walking style IDs list:", thePlayer, 255, 194, 14)
	outputChatBox("0, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 118", thePlayer, 100, 194, 14)
	outputChatBox("119, 120, 121, 122, 123, 124, 125, 126, 128", thePlayer, 100, 194, 14)
	outputChatBox("129, 130, 131, 132, 133, 134, 135, 136, 137, 138", thePlayer, 100, 194, 14)
end
addCommandHandler("walklist", walkStyleList)

function loadAllCorpses(res)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, result in ipairs(res) do
					local res = result["value"]
					local garages = fromJSON( res )
					
					if garages then
						for i = 0, 49 do
							setGarageOpen( i, garages[tostring(i)] )
						end
					else
						outputDebugString( "Failed to load Garage States" )
					end
				end
			end
		end,	
	mysql:getConnection(), "SELECT value FROM settings WHERE name = 'garagestates'")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllCorpses)

leftkey = "["
rightkey = "]"
bothkey = "="

LightState1 = {0}
LightState2 = {0}

BlinkT = {}
BlinkS = {}

function Blink(vehicle,how,l1,l2)
		if vehicle then
			if getElementData(vehicle,"asd") then
				if not BlinkS[vehicle] and how == 1 then
					setVehicleLightState ( vehicle, l1, 1 )
					setVehicleLightState ( vehicle, l2, 1 )
					BlinkS[vehicle] = true
				elseif BlinkS[vehicle] and how == 1 then
					setVehicleLightState ( vehicle, l1, 0 )
					setVehicleLightState ( vehicle, l2, 0 )
					BlinkS[vehicle] = false
				elseif not BlinkS[vehicle] and how == 2 then
					setVehicleLightState ( vehicle, l2, 1 )
					BlinkS[vehicle] = true
				elseif BlinkS[vehicle] and how == 2 then
					setVehicleLightState ( vehicle, l2, 0 )
					BlinkS[vehicle] = false
				elseif not BlinkS[vehicle] and how == 3 then
					setVehicleLightState ( vehicle, 0, 1 )
					setVehicleLightState ( vehicle, 1, 1 )
					setVehicleLightState ( vehicle, 2, 1 )
					setVehicleLightState ( vehicle, 3, 1 )
					BlinkS[vehicle] = true
				elseif BlinkS[vehicle] and how == 3 then
					setVehicleLightState ( vehicle, 0, 0 )
					setVehicleLightState ( vehicle, 1, 0 )
					setVehicleLightState ( vehicle, 2, 0 )
					setVehicleLightState ( vehicle, 3, 0 )
					BlinkS[vehicle] = false
				end
			else
				killTimer(BlinkT[vehicle])
				BlinkT[vehicle] = nil
		end
	end
end


function Blinker(thePlayer,mode)
	local vehicle = getPedOccupiedVehicle(thePlayer)
		if vehicle then
			if BlinkT[vehicle] then
				killTimer(BlinkT[vehicle])
				BlinkT[vehicle] = nil
				setVehicleLightState(vehicle,0,LightState1[vehicle])
				setVehicleLightState(vehicle,1,LightState2[vehicle])
				setVehicleLightState(vehicle,3,0)
				setVehicleLightState(vehicle,2,0)
				setVehicleOverrideLights(vehicle,0)
			else
				setVehicleOverrideLights(vehicle,2)
				setElementData(vehicle,"asd","asd")
				
				local a,b = getVehicleLightState(vehicle,0),getVehicleLightState(vehicle,1)
				LightState1[vehicle] = a
				LightState2[vehicle] = b
				
				if mode == leftkey then
					setVehicleLightState ( vehicle, 1, 1 )
					setVehicleLightState ( vehicle, 2, 1 )
					if a == 0 then
						BlinkT[vehicle] = setTimer(Blink,400,0,vehicle,1,0,3)
					elseif a == 1 then
						BlinkT[vehicle] = setTimer(Blink,400,0,vehicle,2,0,3)
					end
				elseif mode == rightkey then
					setVehicleLightState ( vehicle, 0, 1 )
					setVehicleLightState ( vehicle, 3, 1 )
					if b == 0 then
						BlinkT[vehicle] = setTimer(Blink,400,0,vehicle,1,1,2)
					elseif b == 1 then
						BlinkT[vehicle] = setTimer(Blink,400,0,vehicle,2,1,2)
					end
				elseif mode == bothkey then
						BlinkT[vehicle] = setTimer(Blink,400,0,vehicle,3,0,1)
				end
			end
		end
	end


addEventHandler ( "onVehicleEnter", getRootElement(),
function(thePlayer)
	if getElementType( thePlayer ) == "player" then
		bindKey ( thePlayer, leftkey, "down", Blinker, thePlayer, leftkey)
		bindKey ( thePlayer, rightkey, "down", Blinker, thePlayer, rightkey)
		bindKey ( thePlayer, bothkey, "down", Blinker, thePlayer, bothkey)
	end
end)

addEventHandler ( "onVehicleExit", getRootElement(),
function(thePlayer)
	if getElementType( thePlayer ) == "player" then
		unbindKey ( thePlayer, leftkey, "down", Blinker)
		unbindKey ( thePlayer, rightkey, "down", Blinker)
		unbindKey ( thePlayer, bothkey, "down", Blinker)
	end
end)

local notallowed = { [509]=true, [481]=true, [510]=true, [462]=true, [448]=true, [581]=true, [522]=true, [461]=true, [521]=true, [523]=true, [463]=true, [586]=true, [468]=true, [471]=true, [431] = true, [437] = true }

function onVehicleEnter()
	local driver = getVehicleOccupant(source, 0)
	local passenger = getVehicleOccupant(source, 1)
	local alarmfound = true
	
	if notallowed[getElementModel(source)] then
		return
	end

	if getVehicleType( source ) ~= "Automobile" then
		return
	end

	if not getVehicleEngineState ( source ) then
		return
	end
	
	if not (driver or passenger) then
		return
	end
	
	if (driver) then
		if (getElementData(driver, "seatbelt") == true and not passenger) then
			return
		end
	end
	if (passenger) then
		if (getElementData(passenger, "seatbelt") == true) then
			if (driver) then
				if (getElementData(driver, "seatbelt") == true) then
					return
				end
			end
		end
	end
	

	if (alarmfound) then
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for _, arrayPlayer in ipairs(players) do
			local x, y, z = getElementPosition(source)
			local vDim = getElementDimension(source)
			local vInt = getElementInterior(source)
			local px, py, pz = getElementPosition(arrayPlayer)
			local pDim = getElementDimension(arrayPlayer)
			local pInt = getElementDimension(arrayPlayer)
			--if (pDim == vDim and pInt == vInt and getDistanceBetweenPoints2D(x, y, px, py) <= 30) then
				triggerClientEvent(arrayPlayer, "startSeatBeltWarning", source)
			--end
		end	
	end
end
addEventHandler("onVehicleEnter", getRootElement(), onVehicleEnter)
addEvent("onVehicleSeatbeltWarning", true)
addEventHandler("onVehicleSeatbeltWarning", getRootElement(), onVehicleEnter)

function checkData(dataName, oldValue)
	if getElementType(source) == "vehicle" then
		if dataName == "engine" then
			if getElementData(source, "engine") == 1 then
				triggerEvent("onVehicleSeatbeltWarning", source)
			end
		end
	elseif getElementType(source) == "player" then
		if dataName == "seatbelt" then
			local vehicle = getPedOccupiedVehicle(source)
			if not getElementData(source, "seatbelt") then
				if vehicle then
				triggerEvent("onVehicleSeatbeltWarning", vehicle)
			end
			end
		end
	end
end
addEventHandler("onElementDataChange", getRootElement(), checkData)

function tamirciaktif(thePlayer, cmd)
	local gorevdekiTamirciler = gorevdekiOyuncular(1, thePlayer)
	outputChatBox("[!]#779292 Aktif Onaylı Tamirciler: "..gorevdekiTamirciler,thePlayer,0,100,255,true)
end
addCommandHandler("tamirci", tamirciaktif)

function gorevdekiOyuncular(meslek_id, oyuncu2)
	if not meslek_id then return "Meslek id girilmemiş" end
	local sayac = 0
	for _, oyuncu in ipairs(getElementsByType("player")) do
		local oyuncuMeslek = tonumber(getElementData(oyuncu, "tamirci"))
		if oyuncuMeslek then
			if oyuncuMeslek == tonumber(meslek_id) then
				local playerItems = exports["vrp_items"]:getItems(oyuncu)
				local pnumber
				for index, value in ipairs(playerItems) do
					if value[1] == 2 then
						pnumber = value[2]
					end
				end
				sayac = sayac + 1
				setTimer(function()outputChatBox("[!]#779292 "..getPlayerName(oyuncu):gsub("_"," ").." - "..pnumber, oyuncu2, 0, 100, 255, true) end,250,1)
			end
		end
	end
	return sayac
end

addCommandHandler("ssmod",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			screenshot_mode = setElementData(player, "screenshot:mode", not getElementData(player, "screenshot:mode"))
			if getElementData(player, "screenshot:mode") then
				fadeCamera(player, false, 1)
			else
				fadeCamera(player, true, 1)
			end
		end
	end
)

function checkCarJack(thePlayer, seat, jacked)
   if jacked and seat == 0 then
      cancelEvent()
      outputChatBox("[!]#FFFFFF Binmeye çalıştığınız arabanın sürücü koltuğunda birisi var!", thePlayer,25,25,255,true)
   end
end
addEventHandler("onVehicleStartEnter", getRootElement(), checkCarJack)

function soyun(thePlayer)
    local oynamasaati = getElementData(thePlayer, "hoursplayed")
	local cinsiyet = getElementData(thePlayer, "gender") or 0
	if ( oynamasaati > 2 ) then
	        if tonumber(cinsiyet) == 0 then --herif
		        setElementModel(thePlayer, 68)
	        elseif tonumber(cinsiyet) == 1 then --arvat
		        setElementModel(thePlayer, 64)
		    end           			
	        exports.vrp_global:sendLocalMeAction(thePlayer, "üzerindeki kıyafetleri çıkartır.")
	    else
	        outputChatBox("[!]#ffffff Karakteri 1 oynama saatini geçmeyenler soyunamaz.", thePlayer, 255, 0, 0, true)
		end	
    end
addCommandHandler ("soyun", soyun)