
local mysql = exports.vrp_mysql
local ramp_cache = {}
function ramp_init ( )
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    if not ramp_cache[row.id] then ramp_cache[row.id] = {} end
                    for key, value in pairs(row) do
                        ramp_cache[row.id][key] = value
                    end
                    ramp_load(row.id)
                end
            end
        end,
    mysql:getConnection(), "SELECT * FROM ramps")
	removeWorldModel(2053, 10000, 0, 0, 0)
	removeWorldModel(2054, 10000, 0, 0, 0)
end

function ramp_load ( id )
    if ramp_cache[id] then
        local row = ramp_cache[id]
        if row then
            for k, v in pairs( row ) do
                if v == null then
                    row[k] = nil
                else
                    row[k] = tonumber(v) or v
                end
            end
            
            local x, y, z = unpack ( fromJSON ( row.position ) )
            local rz = row.rotation
            local int = row.interior
            local dim = row.dimension
            
            local frame = createObject ( 2052, x, y, z, 0, 0, rz )
            local lift = createObject ( 2053, x, y, z, 0, 0, rz )
            
            setElementDimension(frame, dim)
            setElementDimension(lift, dim)
            setElementInterior(frame, int)
            setElementInterior(lift, int)
            
            if tonumber ( row.state ) == 1 then
                setElementPosition ( lift, x, y, z + 2.5 )
                setElementData ( frame, "lift.up", true )
            else
                setElementPosition ( lift, x, y, z + 0.17 )
            end
            
            setElementData ( frame, "garagelift", true )
            setElementData ( frame, "lift", lift )
            setElementData ( frame, "dbid", tonumber ( id ) )
            setElementData ( frame, "creator", row.creator )
        end
    else
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        if not ramp_cache[row.id] then ramp_cache[row.id] = {} end
                        for key, value in pairs(row) do
                            ramp_cache[row.id][key] = value
                        end
                        ramp_load(row.id)
                    end
                end
            end,
        mysql:getConnection(), "SELECT * FROM ramps WHERE id='"..id.."'")
        return
    end
end

function getNearbyRamps ( p )
	if exports.vrp_integration:isPlayerTrialAdmin(p) then
    
		local px, py, pz = getElementPosition ( p )
		local dimension = getElementDimension ( p )
		local count = 0
		
		outputChatBox ( "Nearby Ramps:", p, 255, 126, 0, false )
		
		for i,v in ipairs ( getElementsByType ( "object" ) ) do
			if getElementData ( v, "garagelift" ) and getElementDimension ( v ) == dimension then
				local x, y, z = getElementPosition ( v )
				local distance = getDistanceBetweenPoints3D ( px, py, pz, x, y, z )
				
				if distance < 11 then
					local dbid = getElementData ( v, "dbid" )
					local creator = getElementData ( v, "creator" )
					
					outputChatBox ( " ID " .. dbid .. " | Creator: " .. creator, p, 255, 126, 0, false )
					count = count + 1
				end
			end
		end
		
		if count == 0 then
			outputChatBox ( "   None.", p, 255, 126, 0, false )
		end
	end
end
addCommandHandler ( "nearbyramps", getNearbyRamps )

function gotoRamp ( p, commandName, target )
    if exports.vrp_integration:isPlayerTrialAdmin(p) then
	if not target then
		outputChatBox("SYNTAX: /" .. commandName .. " [Ramp ID]", p, 255, 194, 14)
		else
		for i,v in ipairs ( getElementsByType ( "object" ) ) do
			if getElementData ( v, "garagelift" ) then
				local dbid = getElementData ( v, "dbid" )
				if (tonumber(target) == tonumber(dbid)) then
				local x, y, z = getElementPosition ( v )
				local int = getElementInterior ( v )
				local dim = getElementDimension ( v )
					
				setElementPosition(p, x, y, z)
				setElementInterior(p, int)
				setElementDimension(p, dim)
				
				outputChatBox ( "Teleported to ramp ID " .. dbid .. ".", p, 255, 126, 0, false )
				end
			end
		end
	end
	end
end
addCommandHandler ( "gotoramp", gotoRamp )

addEventHandler ( "onResourceStart", resourceRoot, ramp_init )