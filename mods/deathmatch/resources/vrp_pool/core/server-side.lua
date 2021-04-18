poolTable = {
	["player"] = {},
	["interior"] = {},
	["elevator"] = {},
	["vehicle"] = {},
	["colshape"] = {},
	["ped"] = {},
	["marker"] = {},
	["object"] = {},
	["pickup"] = {},
	["team"] = {},
	["blip"] = {}
}

local indexedPools =
{
	player = {},
	interior = {},
	elevator = {},
	vehicle = {},
	team = {},
	ped = {}
}

local idelementdata =
{
	player = "playerid",
	interior = "dbid",
	elevator = "dbid",
	vehicle = "dbid",
	team = "id",
	ped = "dbid"
}

function isValidType(elementType)
	return poolTable[elementType] ~= nil
end

function showsize(thePlayer)
	if not exports.vrp_integration:isPlayerScripter(thePlayer) then
		return false
	end
	local players = #poolTable["player"]
	local interiors = #poolTable["interior"]
	local elevators = #poolTable["elevator"]
	local vehicles = #poolTable["vehicle"]
	local colshapes = #poolTable["colshape"]
	local peds = #poolTable["ped"]
	local markers = #poolTable["marker"]
	local objects = #poolTable["object"]
	local pickups = #poolTable["pickup"]
	local teams = #poolTable["team"]
	local blips = #poolTable["blip"]
	
	local tplayers = #getElementsByType("player")
	local tinteriors = #getElementsByType("interior")
	local televators = #getElementsByType("elevator")
	local tvehicles = #getElementsByType("vehicle")
	local tcolshapes = #getElementsByType("colshape")
	local tpeds = #getElementsByType("ped")
	local tmarkers = #getElementsByType("marker")
	local tobjects = #getElementsByType("object")
	local tpickups = #getElementsByType("pickup")
	local tteams = #getElementsByType("team")
	local tblips = #getElementsByType("blip")
	
	outputChatBox("------POOLED ELEMENTS------", thePlayer)
	outputChatBox("PLAYERS: " .. tostring(players) .. "/" .. tostring(tplayers), thePlayer)
	outputChatBox("INTERIORS: " .. tostring(interiors) .. "/" .. tostring(tinteriors), thePlayer)
	outputChatBox("ELEVATORS: " .. tostring(elevators) .. "/" .. tostring(televators), thePlayer)
	outputChatBox("VEHICLES: " .. tostring(vehicles) .. "/" .. tostring(tvehicles), thePlayer)
	outputChatBox("COLSHAPES: " .. tostring(colshapes) .. "/" .. tostring(tcolshapes), thePlayer)
	outputChatBox("PEDS: " .. tostring(peds) .. "/" .. tostring(tpeds), thePlayer)
	outputChatBox("MARKERS: " .. tostring(markers) .. "/" .. tostring(tmarkers), thePlayer)
	outputChatBox("OBJECTS: " .. tostring(objects) .. "/" .. tostring(tobjects), thePlayer)
	outputChatBox("PICKUPS: " .. tostring(pickups) .. "/" .. tostring(tpickups), thePlayer)
	outputChatBox("TEAMS: " .. tostring(teams) .. "/" .. tostring(tteams), thePlayer)
	outputChatBox("BLIPS: " .. tostring(blips) .. "/" .. tostring(tblips), thePlayer)
end
addCommandHandler("poolsize", showsize)

function deallocateElement(element)
	local elementType = getElementType(element)
	if (isValidType(elementType)) then
		local elementPool = poolTable[elementType]
		local i = 0
		for k = #elementPool, 1, -1 do
			if elementPool[k] == element then
				table.remove(elementPool, k)
			end
		end
		
		if indexedPools[elementType] then
			local id = tonumber(getElementData(element, idelementdata[elementType]))
			if id and indexedPools[elementType][id] then
				indexedPools[elementType][id] = nil
			else
				for k, v in pairs(indexedPools[elementType]) do
					if v == element then
						indexedPools[elementType][k] = nil
					end
				end
			end
		end
	end
end

function allocateElement(element, id, skipChildren)
	local elementType = getElementType(element)
	if (isElement(element) and isValidType(elementType)) then
		deallocateElement(element)
		table.insert (poolTable[elementType], element)
		if indexedPools[elementType] then
			if not id then
				id = getElementData(element, idelementdata[elementType])
			else
				indexedPools[elementType][tonumber(id)] = element
			end
		end
	end
	
	-- add all children
	if not skipChildren and getElementChildren(element) then
		for k, e in ipairs(getElementChildren(element)) do
			allocateElement(e)
		end
	end
end

function getPoolElementsByType(elementType)
	if (elementType=="pickup") then
		return getElementsByType("pickup")
	end

	if isValidType(elementType) then
		return poolTable[elementType]
	end
	return false
end

addEventHandler("onResourceStop", resourceRoot, function () --Maxime
	exports.vrp_data:save(poolTable, "poolTable")
	exports.vrp_data:save(indexedPools, "indexedPools")
end)

addEventHandler("onResourceStart", resourceRoot, function() --Maxime
	local loaded = exports.vrp_data:load("poolTable")
	if loaded then
		poolTable = loaded
	end
	loaded = exports.vrp_data:load("indexedPools")
	if loaded then
		indexedPools = loaded
	end
	if not indexedPools["ped"] then
		indexedPools["ped"] = {}
		outputDebugString("pool: Added missing indexed pool for peds")
	end
end)




addEventHandler("onPlayerJoin", getRootElement(),
	function ()
		allocateElement(source)
	end
)

addEventHandler("onPlayerQuit", getRootElement(),
	function ()
		deallocateElement(source)
	end
)

addEventHandler("onElementDestroy", getRootElement(),
	function ()
		deallocateElement(source)
	end
)

function getElement(elementType, id)
	return indexedPools[elementType] and indexedPools[elementType][tonumber(id)]
end