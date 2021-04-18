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
	["blip"] = {},
	["playerByDbid"] = {},
}

indexedPools =
{
	player = {},
	interior = {},
	elevator = {},
	vehicle = {},
	team = {},
	ped = {},
	playerByDbid = {},
	object = {},
}

idelementdata =
{
	player = "playerid",
	interior = "dbid",
	elevator = "dbid",
	vehicle = "dbid",
	team = "id",
	ped = "dbid",
	playerByDbid = "dbid",
	object = 'dbid',
}

function isValidType(elementType)
	return poolTable[elementType] ~= nil
end

function deallocateElement(element)
	if not isElement(element) then
		return false
	end
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
	if not isElement(element) then
		return false
	end

	local elementType = getElementType(element)
	if (isElement(element) and isValidType(elementType)) then
		deallocateElement(element)
		table.insert (poolTable[elementType], element)
		if indexedPools[elementType] then
			if not id then
				id = getElementData(element, idelementdata[elementType])
			end
			if id and tonumber(id) then
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

function getElement(elementType, id)
	return indexedPools[elementType] and indexedPools[elementType][tonumber(id)]
end

local syntaxs = {
	["s"] = "#00a8ff",
	["e"] = "#e84118",
	["w"] = "#fbc531",
}

function getServerSyntax(text, type)
	if syntaxs[type] then
		if (text == false) then
			return syntaxs[type].."[Valhalla]#ffffff "
		else
			return syntaxs[type].."[Valhalla - "..text.."]#ffffff "
		end
		return ""
	end
	return ""
end

function getServerMoneyType()
	return "$"
end