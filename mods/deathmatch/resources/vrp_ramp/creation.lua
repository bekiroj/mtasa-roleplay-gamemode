-- Made with love by Shmorf
-- Copyright (c), Immersion Gaming.

local radius = 3

function ramp_add ( p, cmd )
    if exports.vrp_integration:isPlayerTrialAdmin(p) then
    local x, y, z = getElementPosition ( p )
    local _, _, rz = getElementRotation ( p )
	local interior = getElementInterior ( p )
	local dimension = getElementDimension ( p )
    local tx = x + - ( radius ) * math.sin ( math.rad ( rz ) )
    local ty = y + radius * math.cos ( math.rad ( rz ) )
    
		local id = SmallestID ( )
		local position = toJSON ( { tx, ty, z - 1.15 } )
		local creator = string.gsub ( getPlayerName ( p ), "_", " " )
		local query = dbExec(mysql:getConnection(), "INSERT INTO ramps SET id=" .. id .. ",position='" .. position .. "',interior='" .. interior .. "',dimension='" .. dimension .. "',rotation=" .. math.ceil ( rz ) .. ",creator='" .. creator .. "', state=0" )
		
		if query then
			ramp_load ( id )
			outputChatBox ( "Created Ramp with ID " .. id ..".", p, 0, 255, 0, false )
			exports.vrp_global:giveItem ( p, 151, id )
			exports.vrp_global:sendMessageToAdmins ( "AdmWarn: " .. creator .. " created a ramp with ID " .. id )
		else
			outputChatBox ( "Failed to create ramp.", p, 255, 0, 0, false )
		end
	end
end
addCommandHandler ( "addramp", ramp_add )

function ramp_delete ( p, cmd, id )
	if exports.vrp_integration:isPlayerTrialAdmin(p) then
    local query = dbExec(mysql:getConnection(), "DELETE FROM ramps WHERE id = " .. id )
        
		if query then
			local deleter = string.gsub ( getPlayerName ( p ), "_", " " )
				
			for i,v in ipairs ( getElementsByType ( "object" ) ) do
				if isElement ( v ) and getElementData ( v, "garagelift" ) and getElementData ( v, "dbid" ) == tonumber ( id ) then
					local lift = getElementData ( v, "lift" )
					destroyElement ( lift )
					destroyElement ( v )
				end
			end
			
			outputChatBox ( "Deleted Ramp with ID " .. id ..".", p, 255, 0, 0, false )
			exports.vrp_global:sendMessageToAdmins ( "AdmWarn: " .. deleter .. " deleted a ramp with ID " .. id )
		else
			outputChatBox ( "Invalid ramp ID specified.", p, 255, 0, 0, false )
		end
	end
end
addCommandHandler ( "delramp", ramp_delete )