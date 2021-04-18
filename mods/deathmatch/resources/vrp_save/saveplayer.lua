mysql = exports.vrp_mysql
local playersToBeSaved = { }

function beginSave()
	outputDebugString("All players data saved.") -- !bekiroj
	for key, value in ipairs(getElementsByType("player")) do
		table.insert(playersToBeSaved, value)
	end
	local timerDelay = 0
	for key, thePlayer in ipairs(playersToBeSaved) do
		timerDelay = timerDelay + 1000
		setTimer(savePlayer, timerDelay, 1, "Save All", thePlayer)
	end
end

function syncTIS()
	for key, value in ipairs(getElementsByType("player")) do
		local tis = getElementData(value, "timeinserver")
		if (tis) and (getPlayerIdleTime(value) < 600000)  then
			exports.vrp_anticheat:changeProtectedElementDataEx(value, "timeinserver", tonumber(tis)+1, false)
		end
	end
end
setTimer(syncTIS, 60000, 0)
local connection = mysql:getConnection()
addEventHandler("onResourceStart", root,
    function(startedRes)
        if getResourceName(startedRes) == "vrp_mysql" then
            connection = exports.vrp_mysql:getConnection()
            restartResource(getThisResource())
        end
    end
)
function savePlayer(reason, player)
	if source ~= nil then
		player = source
	end
	if isElement(player) then
		local logged = getElementData(player, "loggedin")
		if (logged==1 or reason=="Change Character") then
			local vehicle = getPedOccupiedVehicle(player)
		
			if (vehicle) then
				local seat = getPedOccupiedVehicleSeat(player)
				triggerEvent("onVehicleExit", vehicle, player, seat)
			end
		
			local x, y, z, rot, health, armour, interior, dimension, cuffed, skin, duty, timeinserver, businessprofit, alcohollevel
		
			local x, y, z = getElementPosition(player)
			local rot = getPedRotation(player)
			local health = getElementHealth(player)
			local armor = getPedArmor(player)
			local interior = getElementInterior(player)
			local dimension = getElementDimension(player)
			local alcohollevel = getElementData(player, "alcohollevel")
			local d_addiction = ( getElementData(player, "drug.1") or 0 ) .. ";" .. ( getElementData(player, "drug.2") or 0 ) .. ";" .. ( getElementData(player, "drug.3") or 0 ) .. ";" .. ( getElementData(player, "drug.4") or 0 ) .. ";" .. ( getElementData(player, "drug.5") or 0 ) .. ";" .. ( getElementData(player, "drug.6") or 0 ) .. ";" .. ( getElementData(player, "drug.7") or 0 ) .. ";" .. ( getElementData(player, "drug.8") or 0 ) .. ";" .. ( getElementData(player, "drug.9") or 0 ) .. ";" .. ( getElementData(player, "drug.10") or 0 )
			money = getElementData(player, "stevie.money")
			if money and money > 0 then
			money = 'money = money + ' .. money .. ', '
			else
				money = ''
			end
			skin = getElementModel(player)
		
			if getElementData(player, "help") then
				dimension, interior, x, y, z = unpack( getElementData(player, "help") )
			end
		
			if getElementData(player, "businessprofit") and ( reason == "Quit" or reason == "Timed Out" or reason == "Unknown" or reason == "Bad Connection" or reason == "Kicked" or reason == "Banned" ) then
				businessprofit = 'bankmoney = bankmoney + ' .. getElementData(player, "businessprofit") .. ', '
			else
				businessprofit = ''
			end
		
			if exports['vrp_freecam']:isPlayerFreecamEnabled(player) then 
				x = getElementData(player, "tv:x")
				y = getElementData(player, "tv:y")
				z =  getElementData(player, "tv:z")
				interior = getElementData(player, "tv:int")
				dimension = getElementData(player, "tv:dim") 
			end
		
			local  timeinserver = getElementData(player, "timeinserver")
			local zone = exports.vrp_global:getElementZoneName(player)
			if not zone or #zone == 0 then
				zone = "Unknown"
			end
			local level = getElementData(player, "level") or 1
			local hunger = getElementData(player, "hunger") or 100
			local thirst = getElementData(player, "thirst") or 100
			local hoursplayed = getElementData(player, "hoursplayed")
			local bankmoney = getElementData(player, "bankmoney")
			local boxexp = getElementData(player, "boxexp") or 0
			local box = getElementData(player, "box") or 0
		
			local update = dbExec(connection, "UPDATE characters SET thirst='"..(thirst) .. "', box='"..(box) .. "', boxexp='"..(boxexp) .. "', hoursplayed='"..(hoursplayed) .. "', bankmoney='"..(bankmoney).."', hunger='" .. (hunger) .. "', level='" .. (level) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotation='" .. (rot) .. "', health='" .. (health) .. "', armor='" .. (armor) .. "', dimension_id='" .. (dimension) .. "', interior_id='" .. (interior) .. "', " ..(money) .. (businessprofit) .. "lastlogin=NOW(), lastarea='" .. (zone) .. "', timeinserver='" .. (timeinserver) .. "' WHERE id=" .. (getElementData(player, "dbid")))
			if not (update) then
				outputDebugString( "Saveplayer Update:" )
			end
			local bakiye = getElementData(player, "bakiye") or 0
			local update3 = dbExec(mysql:getConnection(), "UPDATE accounts SET bakiye='"..bakiye.."' WHERE id = " .. (getElementData(player,"account:id")))
			if not (update3) then
				outputDebugString( "Saveplayer Update2: " )
			end
		end
	end
end
addEventHandler("onPlayerQuit", getRootElement(), savePlayer)
addEvent("savePlayer", false)
addEventHandler("savePlayer", getRootElement(), savePlayer)
setTimer(beginSave, 3600000, 0)
addCommandHandler("saveall", function(p) if exports.vrp_integration:isPlayerSeniorAdmin(p) then beginSave() outputChatBox("Done.", p) end end)
addCommandHandler("saveme", function(p) triggerEvent("savePlayer", p, "Save Me", p) end)