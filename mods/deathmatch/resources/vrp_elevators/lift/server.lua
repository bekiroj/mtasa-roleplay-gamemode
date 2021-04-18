mysql = exports.vrp_mysql
null = nil

local toLoad = { }
local threads = { }

function createLift(thePlayer, commandName, lift, floor, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		local name = table.concat({...}, " ")
		if(not lift or not floor or not name) then
			outputChatBox("SYNTAX: /" .. commandName .. " [lift ID] [floor] [name]", thePlayer, 255, 194, 14)
			outputChatBox("Set lift ID to 0 to create a new lift. Use ID to add a floor to existing lift.", thePlayer, 255, 194, 14)
			return false
		end
		if(string.len(floor) > 3) then
			outputChatBox("AddLift: floor must be 1-3 characters. E.g. '1', '203' or 'U1'.", thePlayer, 255, 0, 0)
			return false
		end
		
		local lift = tonumber(lift)
		
		local x, y, z = getElementPosition(thePlayer)
		local interior = getElementInterior(thePlayer)
		local dimension = getElementDimension(thePlayer)
		
		if(lift == 0) then
			id = SmallestLiftID()
			if id then
				local comment = tostring(getPlayerName(thePlayer))..":"..tostring(now())..": "..tostring(name)
				local query = dbExec(mysql:getConnection(), "INSERT INTO lifts SET id='" .. (id) .. "', comment='" .. (comment) .. "'")
				if (query) then
					local floorID = SmallestLiftFloorID()
					local query2 = dbExec(mysql:getConnection(), "INSERT INTO lift_floors SET id='" .. (floorID) .. "', lift='" .. (id) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', dimension='" .. (dimension) .. "', interior='" .. (interior) .. "', floor='" .. (floor) .. "', name='" .. (name) .. "'")
					if(query2) then
						loadOneLiftFloor(floorID)
						outputChatBox("Lift created with ID #" .. id .. ".", thePlayer, 0, 255, 0)
					end
				end
			else
				outputChatBox("There was an error while creating a lift. Try again.", thePlayer, 255, 0, 0)
			end
		elseif(lift > 0) then
			id = SmallestLiftFloorID()
			if id then
				local query = dbExec(mysql:getConnection(), "INSERT INTO lift_floors SET id='" .. (id) .. "', lift='" .. (lift) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', dimension='" .. (dimension) .. "', interior='" .. (interior) .. "', floor='" .. (floor) .. "', name='" .. (name) .. "'")
				if (query) then
					loadOneLiftFloor(id)
					outputChatBox("Floor with ID #"..id.." added to lift #".. lift ..".", thePlayer, 0, 255, 0)
				end
			else
				outputChatBox("There was an error while creating a lift. Try again.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("addlift", createLift, false, false)


function findLift(id)
	id = tonumber(id)
	if id > 0 then
		local possibleInteriors = getElementsByType("lift")
		for _, elevator in ipairs(possibleInteriors) do
			local eleID = getElementData(elevator, "dbid")
			if eleID == id then
				local elevatorStatus = getElementData(elevator, "status")
				
				return id, elevatorStatus, elevator
			end
		end
	end
	return 0
end

function findLiftElement(id)
	id = tonumber(id)
	if id > 0 then
		local possibleInteriors = getElementsByType("lift")
		for _, elevator in ipairs(possibleInteriors) do
			local eleID = getElementData(elevator, "dbid")
			if eleID == id then
				return  elevator
			end
		end
	end
	return false
end

function reloadOneLift(elevatorID, skipcheck)
	local dbid, status, elevatorElement = findLift( elevatorID )
	if (dbid > 0 or skipcheck)then
		local realElevatorElement = findLiftElement(dbid)
		if not realElevatorElement then
			outputDebugString("elevators/s_elevator_lift.lua: [reloadOneLift] Can't find element")
		end
		triggerClientEvent("deleteInteriorElement", realElevatorElement, tonumber(dbid))
		destroyElement(realElevatorElement)
		loadOneLift(tonumber(dbid), false)
	else
		outputDebugString("elevators/s_elevator_lift.lua: Tried to reload elevator without ID.")
	end
end

function loadOneLift(elevatorID, hasCoroutine)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					if not row then outputDebugString("row="..tostring(row).." result="..tostring(result)) break end
					for k, v in pairs( row ) do
						if v == null then
							row[k] = nil
						else
							row[k] = tonumber(v) or v
						end
					end
					local elevatorElement = createElement("lift", "lif"..tostring(row.id))
					setElementDataEx(elevatorElement, "dbid", row.id, true)
					setElementDataEx(elevatorElement, "liftset", elevatorID, true)
					setElementDataEx(elevatorElement, "status", row.disabled == 1, true)
					local pickup = createPickup(row.x, row.y, row.z, 3,  1318)
				end
			end
		end,
	mysql:getConnection(), "SELECT id, x, y, z, dimension, interior FROM `lift_floors` WHERE lift = "..elevatorID.." ORDER BY `id` ASC")
end

function loadOneLiftFloor(id, hasCoroutine)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					for k, v in pairs( row ) do
						if v == null then
							row[k] = nil
						else
							row[k] = tonumber(row[k]) or row[k]
						end
					end
					
					local liftElement = findLiftElement(row.lift)
					if not liftElement then
						liftElement = createElement("lift", "lif"..tostring(row.lift))
						setElementDataEx(liftElement, "dbid", row.lift, true)
					end	
					local pickup = createPickup(row.x, row.y, row.z, 3,  1318)
					setElementParent(pickup, liftElement)
					setElementInterior(pickup, row.interior)
					setElementDimension(pickup, row.dimension)
					setElementDataEx(pickup, "rpp.lift.floor.id", row.id, true)
					--setElementDataEx(pickup, "rpp.lift.set", row.lift, true)
					setElementDataEx(pickup, "rpp.lift.floor.floor", row.floor, true)
					setElementDataEx(pickup, "rpp.lift.floor.name", row.name, true)
					addEventHandler("onPickupHit", pickup, pickupHit)
					addEventHandler("onPickupLeave", pickup, pickupLeave)
				end
			end
		end,
	mysql:getConnection(), "SELECT id, lift, x, y, z, dimension, interior, floor, name FROM `lift_floors` WHERE id = " .. (id) .. " LIMIT 1")
end

function pickupHit(thePlayer)
	triggerClientEvent(thePlayer, "lift:hit", source, thePlayer)
	cancelEvent()
end

function pickupLeave(thePlayer)
	--outputDebugString("pickupHit()")
	triggerClientEvent(thePlayer, "lift:leave", source, thePlayer)
	cancelEvent()
end

function loadAllLifts(res)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadOneLiftFloor(row["id"])
				end
			end
		end,
	mysql:getConnection(), "SELECT id FROM `lift_floors` ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllLifts)

function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end

function enterLiftFloor(id)
	local player = client
	local element = findLiftElement(id)
	local dimension = getElementDimension(element)
	local interior = getElementInterior(element)
	local x, y, z = getElementPosition(element)
	
	local lifttable = {x, y, z, interior, dimension}
	
	if(not isInteriorLocked(dimension)) then	
		if isElement(player) then
			triggerClientEvent(player, "setPlayerInsideInterior", element or getRootElement(), lifttable, element  or getRootElement())
		end
	else
		outputChatBox("You push the elevator button, but nothing happens.", player, 255, 0,0, true)
	end
	
end
addEvent("lift:use", true)
addEventHandler("lift:use", getRootElement(), enterLiftFloor)

function deleteLift(thePlayer, commandName, id)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or tostring(getElementData(thePlayer, "account:username")) == "bekiroj") then
		if not (tonumber(id)) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			
			local dbid, status, element = findLift( id )
			
			if element then
				local queryFloors = dbExec(mysql:getConnection(), "DELETE FROM lift_floors WHERE lift='" .. (dbid) .. "'")
				local query = dbExec(mysql:getConnection(), "DELETE FROM lifts WHERE id='" .. (dbid) .. "'")
				if query then
					reloadOneLift(dbid)
					outputChatBox("Elevator #" .. id .. " Deleted!", thePlayer, 0, 255, 0)
				else
					outputChatBox("ELE0015 Error, please report to a scripter.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("Elevator ID does not exist!", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("dellift", deleteLift, false, false)

function getNearbyLifts(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or tostring(getElementData(thePlayer, "account:username")) == "bekiroj") then
		local posX, posY, posZ = getElementPosition(thePlayer)
		local dimension = getElementDimension(thePlayer)
		outputChatBox("Nearby Lifts:", thePlayer, 255, 126, 0)
		local found = false
		
		local possibleElevators = getElementsByType("lift")
		for _, elevator in ipairs(possibleElevators) do
			local x, y, z = getElementPosition(elevator)
			if (getElementDimension(elevator) == dimension) then
				local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
				if (distance <= 11) then
					local dbid = getElementData(elevator, "dbid")
					outputChatBox(" ID " .. dbid, thePlayer, 255, 126, 0)
					found = true
				end
			end
		end
		if not found then
			outputChatBox("   None.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbylifts", getNearbyLifts, false, false)

function SmallestLiftID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM lifts AS e1 LEFT JOIN lifts AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		if result["nextID"] == null then
			return 1
		else
			return tonumber(result["nextID"])
		end
	end
	return false
end
function SmallestLiftFloorID()
	local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM lift_floors AS e1 LEFT JOIN lift_floors AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		if result["nextID"] == null then
			return 1
		else
			return tonumber(result["nextID"])
		end
	end
	return false
end

function toggleLift( thePlayer, commandName, id )
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or tostring(getElementData(thePlayer, "account:username")) == "bekiroj") then
		id = tonumber( id )
		if not id then
			outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14 )
		else
			local dbid, status, element = findLift( id )
			
			if element then
				if status == 1 then
					dbExec(mysql:getConnection(), "UPDATE lifts SET disabled = 0 WHERE id = " .. (dbid) )
				else
					dbExec(mysql:getConnection(), "UPDATE lifts SET disabled = 1 WHERE id = " .. (dbid) )
				end
				reloadOneLift(dbid)
				
			else
				outputChatBox( "Elevator not found.", thePlayer, 255, 194, 14 )
			end
		end
	end
end
addCommandHandler( "togglelift", toggleLift )

function liftOutputMe(text)
	if text then
		exports.vrp_global:sendLocalMeAction(client, tostring(text))
	end	
end
addEvent("lift:me", true)
addEventHandler("lift:me", getRootElement(), liftOutputMe)

local time = 0
local timeSet = 0
function now()
	local ticksec = ( getTickCount( ) - timeSet ) / 1000
	return math.floor( time + ticksec )
end