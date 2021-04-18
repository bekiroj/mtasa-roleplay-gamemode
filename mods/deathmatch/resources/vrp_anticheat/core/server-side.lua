function showSpeedToAdmins(velocity)
	kph = math.ceil(velocity * 1.609344)
	exports.vrp_global:sendMessageToAdmins("[Possible Speedhack/HandlingHack] " .. getPlayerName(client) .. ": " .. velocity .. "Mph/".. kph .." Kph")
end
addEvent("alertAdminsOfSpeedHacks", true)
addEventHandler("alertAdminsOfSpeedHacks", getRootElement(), showSpeedToAdmins)

function showDMToAdmins(kills)
	exports.vrp_global:sendMessageToAdmins("[Possible DeathMatching] " .. getPlayerName(client) .. ": " .. kills .. " kills in <=2 Minutes.")
end
addEvent("alertAdminsOfDM", true)
addEventHandler("alertAdminsOfDM", getRootElement(), showDMToAdmins)

function scanMoneyHacks()
	local tick = getTickCount()
	local hackers = { }
	local hackersMoney = { }
	local counter = 0
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for key, value in ipairs(players) do
		local logged = getElementData(value, "loggedin")
		if (logged==1) then
			if not (exports.vrp_integration:isPlayerTrialAdmin(value)) then
				
				local money = getPlayerMoney(value)
				local truemoney = exports.vrp_global:getMoney(value)
				if (money) then
					if (money > truemoney) then
						counter = counter + 1
						hackers[counter] = value
						hackersMoney[counter] = (money-truemoney)
					end
				end
			end
		end
	end
	local tickend = getTickCount()
	local theConsole = getRootElement()
	for key, value in ipairs(hackers) do
		local money = hackersMoney[key]
		local accountID = getElementData(value, "account:id")
		local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
		outputChatBox("AntiCheat: " .. targetPlayerName .. " was auto-banned for Money Hacks. (" .. tostring(money) .. "$)", getRootElement(), 255, 0, 51)
	end
end
setTimer(scanMoneyHacks, 3600000, 0)

local secretHandle = 'some_shit_that_is_really_secured'

function changeProtectedElementData(thePlayer, index, newvalue)
	setElementData(thePlayer, index, newvalue)
end

function changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
	if (thePlayer) and (index) then
		setElementData(thePlayer, index, newvalue)
		return true
	end
	return false
end

function changeEld(thePlayer, index, newvalue)
	if source then thePlayer = thePlayer end
	return setElementData(thePlayer, index, newvalue)
end
addEvent("anticheat:changeEld", true)
addEventHandler("anticheat:changeEld", root, changeEld)

function setEld(thePlayer, index, newvalue, sync)
	if source then thePlayer = thePlayer end
	local sync2 = false
	local nosyncatall = true
	if sync == "one" then
		sync2 = false
		nosyncatall = false
	elseif sync == "all" then
		sync2 = true
		nosyncatall = false
	else
		sync2 = false
		nosyncatall = true
	end
	return changeProtectedElementDataEx(thePlayer, index, newvalue, sync2, nosyncatall)
end
addEvent("anticheat:setEld", true)
addEventHandler("anticheat:setEld", root, setEld)


function genHandle()
	local hash = ''
	for Loop = 1, math.random(5,16) do
		hash = hash .. string.char(math.random(65, 122))
	end
	return hash
end

function fetchH()
	return secretHandle
end

secretHandle = genHandle()