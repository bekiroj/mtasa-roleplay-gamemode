local tollElements = { }
local tollElementsName = { }
local tollElementsLocked = { }
local gateSpeed = 1000
local timerCloseToll = {}
local timerEarlyOpen = {}
function startSystem()
	for key, group in ipairs(tollPorts) do
		tollElements[key] = { }
		tollElementsName[key] = group.name
		tollElementsLocked[key] = false
		for dataKey, dataGroup in ipairs (group.data) do
			local pedName = "Unnamed Person"
			local skinID = math.random(1, 2)
			if #pedMaleNames == 0 then
				skinID = 1
			elseif #pedFemaleNames == 0 then
				skinID = 2
			end
			local array = skinID == 1 and pedFemaleNames or pedMaleNames
			local k = math.random(1, #array)
			pedName = array[k]
			table.remove(array, k)

			if skinID == 1 then
				skinID = 211
			else
				skinID = 71
			end


			tollElements[key][dataKey] = { }

			tollElements[key][dataKey]["object"] = createObject(968,dataGroup.barrierClosed[1],dataGroup.barrierClosed[2],dataGroup.barrierClosed[3],dataGroup.barrierClosed[4],dataGroup.barrierClosed[5],dataGroup.barrierClosed[6])

			tollElements[key][dataKey]["ped"] = createPed(skinID, dataGroup.ped[1], dataGroup.ped[2], dataGroup.ped[3])
			setPedRotation(tollElements[key][dataKey]["ped"], dataGroup.ped[4])
			setElementFrozen(tollElements[key][dataKey]["ped"], true)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "talk",1, true)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "name", pedName:gsub("_", " "), true)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "ped:type", "toll", true)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "ped:tollped",true, true)

			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang1" , 1, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang1skill", 100, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang2" , 2, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.lang2skill", 100, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "languages.current", 1, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:object", tollElements[key][dataKey]["object"], false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:data", dataGroup, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:busy", false, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:state", false, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:name", group.name, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(tollElements[key][dataKey]["ped"], "toll:key", key, false)

			--
			-- Toll Pass
			--
			local x, y, z = dataGroup.ped[1], dataGroup.ped[2], dataGroup.ped[3]
			local r = dataGroup.ped[4]
			x = x - math.sin(math.rad(r)) * 2.5
			z = z + math.cos(math.rad(r)) * 2.5

			local col = createColSphere(x, y, z, 6)
			exports.vrp_anticheat:changeProtectedElementDataEx(col, "toll:ped", tollElements[key][dataKey]["ped"], false)
			addEventHandler("onColShapeHit", col,
				function( thePlayer, match )
					if match and getElementType(thePlayer) == "player" and getPedOccupiedVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
						local thePed = getElementData(source, "toll:ped")
						if getElementData(thePed, "earlyOpened") then
							return false
						end
						local tollKey = getElementData(thePed, "toll:key")
						processOpenTolls(tollKey, thePed, thePlayer, true)
					end
				end
			)
			addEventHandler("onColShapeLeave", col,
				function( thePlayer, match )
					if match and getElementType(thePlayer) == "player" and getPedOccupiedVehicle(thePlayer) and getPedOccupiedVehicleSeat(thePlayer) == 0 then
						local thePed = getElementData(source, "toll:ped")
						if getElementData(thePed, "earlyOpened") then
							return false
						end
						local tollKey = getElementData(thePed, "toll:key")
						if timerCloseToll[thePed] and isElement(timerCloseToll[thePed]) and isTimer(timerCloseToll[thePed]) then
							killTimer(timerCloseToll[thePed])
							timerCloseToll[thePed] = nil
						end
						timerCloseToll[thePed] = setTimer(processCloseTolls,  gateSpeed, 1, tollKey, thePed, thePlayer)
					end
				end
			)

			--Early Open Zone / maxime
			local col2 = createColSphere(x, y, z, 40)
			exports.vrp_anticheat:changeProtectedElementDataEx(col2, "toll:ped", tollElements[key][dataKey]["ped"], false)
			addEventHandler("onColShapeHit", col2,
				function( thePlayer, match )
					if match and getElementType(thePlayer) == "player" and getPedOccupiedVehicleSeat(thePlayer) == 0 and canAccessEarlyZone(getPedOccupiedVehicle(thePlayer), thePlayer)  then
						local thePed = getElementData(source, "toll:ped")
						local tollKey = getElementData(thePed, "toll:key")
						triggerGate(thePed, true)
					end
				end
			)
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), startSystem)

function isTollLocked(tollKey)
	if tollElementsLocked[tollKey] then
		return true
	else
		return false
	end
end

function triggerGate(gateKeeperPed, earlyOpenZone) -- OPEN GATE
	local isGateBusy = getElementData(gateKeeperPed, "toll:busy")
	local isGateOpened = getElementData(gateKeeperPed, "toll:opened")
	if isGateBusy or isGateOpened then
		return false
	end

	local tollData = getElementData(gateKeeperPed, "toll:data")
	local tollObject = getElementData(gateKeeperPed, "toll:object")

	exports.vrp_anticheat:changeProtectedElementDataEx(gateKeeperPed, "toll:busy", true, false)
	local newX, newY, newZ, offsetRX, offsetRY, offsetRZ

	newX = tollData.barrierOpen[1]
	newY = tollData.barrierOpen[2]
	newZ = tollData.barrierOpen[3]
	offsetRX = tollData.barrierClosed[4] - tollData.barrierOpen[4]
	offsetRY = tollData.barrierClosed[5] - tollData.barrierOpen[5]
	offsetRZ = tollData.barrierClosed[6] - tollData.barrierOpen[6]

	offsetRX = fixRotation(offsetRX)
	offsetRY = fixRotation(offsetRY)
	offsetRZ = fixRotation(offsetRZ)

	exports.vrp_anticheat:changeProtectedElementDataEx(gateKeeperPed, "toll:opened", true, false)
	moveObject ( tollObject, gateSpeed, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )


	exports.vrp_anticheat:changeProtectedElementDataEx(gateKeeperPed, "toll:busy", true, false)
	setTimer(resetBusyState, gateSpeed+200, 1, gateKeeperPed)

	--This makes sure the toll will be closed eventually. /maxime
	if timerCloseToll[gateKeeperPed] and isElement(timerCloseToll[gateKeeperPed]) and isTimer(timerCloseToll[gateKeeperPed]) then
		killTimer(timerCloseToll[gateKeeperPed])
		timerCloseToll[gateKeeperPed] = nil
	end
	timerCloseToll[gateKeeperPed] = setTimer(processCloseTolls, 30*1000, 1, nil, gateKeeperPed )

	--This makes sure once one hits the early open zone, the barrier stay opened for awhile no matter what. / maxime
	if earlyOpenZone then
		if timerEarlyOpen[gateKeeperPed] and isElement(timerEarlyOpen[gateKeeperPed]) and isTimer(timerEarlyOpen[gateKeeperPed]) then
			killTimer(timerEarlyOpen[gateKeeperPed])
			timerEarlyOpen[gateKeeperPed] = nil
		end
		exports.vrp_anticheat:changeProtectedElementDataEx(gateKeeperPed, "earlyOpened", true, false)
		timerEarlyOpen[gateKeeperPed] = setTimer(function()
			exports.vrp_anticheat:changeProtectedElementDataEx(gateKeeperPed, "earlyOpened", false, false)
		end, 30*1000, 1, nil, gateKeeperPed )
	end
end

function processCloseTolls(tollKey, thePed, thePlayer, payByBank) -- CLOSE GATE
	local isGateBusy = getElementData(thePed, "toll:busy")
	local isGateOpened = getElementData(thePed, "toll:opened")
	if isGateOpened then
		if isGateBusy then
			setTimer(function()
				processCloseTolls(tollKey, thePed, thePlayer, payByBank)
			end, gateSpeed, 1)
			return false
		end
	else
		return false
	end

	local tollData = getElementData(thePed, "toll:data")
	local tollObject = getElementData(thePed, "toll:object")

	local newX, newY, newZ, offsetRX, offsetRY, offsetRZ

	newX = tollData.barrierClosed[1]
	newY = tollData.barrierClosed[2]
	newZ = tollData.barrierClosed[3]
	offsetRX = tollData.barrierOpen[4] - tollData.barrierClosed[4]
	offsetRY = tollData.barrierOpen[5] - tollData.barrierClosed[5]
	offsetRZ = tollData.barrierOpen[6] - tollData.barrierClosed[6]
	gateState = false

	offsetRX = fixRotation(offsetRX)
	offsetRY = fixRotation(offsetRY)
	offsetRZ = fixRotation(offsetRZ)

	moveObject ( tollObject, gateSpeed, newX, newY, newZ, offsetRX, offsetRY, offsetRZ )
	exports.vrp_anticheat:changeProtectedElementDataEx(thePed, "toll:opened", false, false)
	exports.vrp_anticheat:changeProtectedElementDataEx(thePed, "toll:busy", true, false)
	setTimer(resetBusyState, gateSpeed+200, 1, thePed)

end

--- PEDS
function startTalkToPed ()
	thePed = source
	thePlayer = client

	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 7) then
		return
	end

	if (isPedInVehicle(thePlayer)) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (exports['vrp_vehicle']:isVehicleWindowUp(theVehicle)) then
			outputChatBox("Dışardaki kişiye araç içinden konuşmak için camını açmalısın.", thePlayer, 255,0,0)
			return
		end
	end

	local isGateBusy = getElementData(thePed, "toll:busy")
	if (isGateBusy) then
		processMessage(thePed, "Mh..")
		return
	end

	processMessage(thePed, "Geçmek mi istiyorsun, geçmek için yeni zama göre 30$ vermek zorundasın.")
	setConvoState(thePlayer, 1)
	local responseArray = { "Geçeceğim.", "Geçmek istemiyorum." }
	triggerClientEvent(thePlayer, "toll:interact", thePed, responseArray)
end
addEvent( "toll:startConvo", true )
addEventHandler( "toll:startConvo", getRootElement(), startTalkToPed )

function processOpenTolls(tollKey, thePed, thePlayer, payByBank)
	if not tollElementsLocked[tollKey] or exports.vrp_global:hasItem(thePlayer, 64) or exports.vrp_global:hasItem(thePlayer, 65) or exports.vrp_global:hasItem(thePlayer, 112) then
		if payByBank then
			if not exports.vrp_global:hasItem(getPedOccupiedVehicle(thePlayer), 118) then
				return -- Has no Toll Pass
			end

			local money = getElementData(thePlayer, "bankmoney") - 30
			if money >= 0 then
				exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "bankmoney", money, false)
				dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney=bankmoney-30 WHERE id=" .. (getElementData( thePlayer, "dbid" )))
				outputChatBox("[Santos Gişeleri] Banka hesabınızdan 30$ alındı.", thePlayer, 0, 255, 0)
			else
				return "Bankada yeterli paran yok."
			end
		else
			if not exports.vrp_global:takeMoney(thePlayer, 30) then
				return "Paran yoksa geçemezsin."
			end
		end

		triggerGate(thePed)
		exports.vrp_global:giveMoney( getTeamFromName("Government of Los Santos"), 3 )
		exports.vrp_global:giveMoney( getTeamFromName("Los Santos Police Department"), 2 )
		return "Peki, geçebilirsiniz.."
	else
		return "Üzgünüm gişeler şuan herkese kapalı."
	end
end

function talkToPed(answer, answerStr)
	thePed = source
	thePlayer = client

	local posX, posY, posZ = getElementPosition(thePlayer)
	local pedX, pedY, pedZ = getElementPosition(thePed)
	if not (getDistanceBetweenPoints3D(posX, posY, posZ, pedX, pedY, pedZ) <= 12) then
		return
	end

	local convState = getConvoState(thePlayer)
	local currSlot = getElementData(thePlayer, "languages.current")
	local currLang = getElementData(thePlayer, "languages.lang" .. currSlot)
	processMessage(thePlayer, answerStr, currLang)
	if (convState == 1) then --  "Hey, want to pass? That'll be six dollar please."
		local languageSkill = exports['vrp_languages']:getSkillFromLanguage(thePlayer, 1)
		if (languageSkill < 60) or (currLang ~= 1) then
			processMessage(thePed, "Seni anlıyamıyorum, dilimizi konuşur musun?")
			setConvoState(thePlayer, 0)
			return
		end

		if (answer == 1) then -- "Yes please."
			local placeName = getElementData(thePed, "toll:name")
			local isBusy = getElementData(thePed, "toll:busy")
			if not isBusy then
				local tollKey = getElementData(thePed, "toll:key")
				processMessage(thePed, processOpenTolls(tollKey, thePed, thePlayer, false))
			end
			setConvoState(thePlayer, 0)
		elseif (answer == 2) then -- "No thanks."
			processMessage(thePed, "Peki sen bilirsin...")
			setConvoState(thePlayer, 0)
		end
	end
end
addEvent( "toll:interact", true )
addEventHandler( "toll:interact", getRootElement(), talkToPed )

function testToggle(thePlayer, commandName, gateID, silent)
	local factionID = getElementData(thePlayer, "faction")
	if factionID ~= 1 and factionID ~= 87 and factionID ~= 59 and not exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		return
	end

	if not gateID or not tonumber(gateID) then
		outputChatBox("Syntax: /"..commandName.." [ID]", thePlayer)
		--return ]]
		for tollID, tollName in ipairs(tollElementsName) do
			local state = "open"
			if tollElementsLocked[tollID] then
				state = "locked"
			end
			outputChatBox(" "..tostring(tollID).. " - "..tollName .." - State: "..state, thePlayer)
		end
		return
	end
	gateID = tonumber(gateID)

	if not tollElementsName[gateID] then
		outputChatBox("Does not exists.", thePlayer)
	end

	tollElementsLocked[gateID] = not tollElementsLocked[gateID]
	if tollElementsLocked[gateID] then
		local first = true
		exports['vrp_chat']:departmentradio(thePlayer, "d", "Please lock down the "..tollElementsName[gateID].." tolls, how copy?, over.")
		for _, thePed in ipairs(getElementsByType('ped')) do
			local tollKey = getElementData(thePed, "toll:key")
			if tollKey and tollKey == gateID then
				if first then
					exports['vrp_chat']:departmentradio(thePed, "d", "10-4, locking down "..tollElementsName[gateID]..", out.")
					first = false
				end
				processRadio(thePed, "Comms to the units at "..tollElementsName[gateID]..", don't let anyone through, out!", thePed)
			end
		end
	else
		local first = true
		exports['vrp_chat']:departmentradio(thePlayer, "d", "Please open the "..tollElementsName[gateID].." tolls, how copy?, over.")
		for _, thePed in ipairs(getElementsByType('ped')) do
			local tollKey = getElementData(thePed, "toll:key")
			if tollKey and tollKey == gateID then
				if first then
					exports['vrp_chat']:departmentradio(thePed, "d", "10-4, opening up "..tollElementsName[gateID]..", out.")
					first = false
				end
				processRadio(thePed, "Comms to the units at "..tollElementsName[gateID]..", open the toll booth again, out!", thePed)
			end
		end
	end
end
addCommandHandler("tolllock", testToggle)

--- Functions
function getConvoState(thePlayer)
	return getElementData(thePlayer, "toll:convoState", state) or 0
end

function setConvoState(thePlayer, state)
	exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "toll:convoState", state, false)
end

function processMessage(thePed, message, language)
	if not (language) then
		language = 1
	end
	exports['vrp_chat']:localIC(thePed, message, language)
end

function processRadio(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['vrp_global']:sendLocalText(source, "[English] " .. name .. "'s Radio: "..message, 255, 255, 255)
end

function processMeMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['vrp_global']:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
end

function processDoMessage(thePed, message, source)
	local name = getElementData(thePed, "name") or getPlayerName(thePed)
	exports['vrp_global']:sendLocalText(source, " * " .. message .. " *      ((" .. name:gsub("_", " ") .. "))", 255, 51, 102)
end

function fixRotation(value)
	local invert = false
	if value < 0 then
		while value < -360 do
			value = value + 360
		end
		if value < -180 then
			value = value + 180
			value = value - value - value
		end
	else
		while value > 360 do
			value = value - 360
		end
		if value > 180 then
			value = value - 180
			value = value - value - value
		end
	end

	return value
end

function resetBusyState(theGate)
	local isGateBusy = getElementData(theGate, "toll:busy")
	if (isGateBusy) then
		--outputDebugString("Reset")
		exports.vrp_anticheat:changeProtectedElementDataEx(theGate, "toll:busy", false, false)
	end
end

function tollCommand(thePlayer)
	local duty = tonumber(getElementData(thePlayer, "duty")) or 0
	if duty > 0 and getElementDimension( thePlayer ) == 0 then
		-- find nearby gates
		local x, y, z = getElementPosition( thePlayer )
		local any = false
		for key, value in ipairs( tollElements ) do
			local name
			for k, v in ipairs( value ) do
				local ped = v.ped
				if ped then
					if getDistanceBetweenPoints3D( x, y, z, getElementPosition( ped ) ) < 100 then
						name = getElementData( ped, "toll:name" )
						break
					end
				end
			end

			if name then
				outputChatBox( "Opening " .. name .. " toll gates.", thePlayer, 0, 255, 0 )
				for k, v in ipairs(value) do
					if v.ped then
						exports.vrp_logs:dbLog(thePlayer, 35, v.ped, "TOLL OPEN " .. name)
						triggerGate(v.ped, false, thePlayer, 15000)
						any = true
					end
				end
			end
		end

		if not any then
			outputChatBox("You are not near any toll gates.", thePlayer, 255, 0, 0)
		end
	end
end
addCommandHandler("toll", tollCommand)
