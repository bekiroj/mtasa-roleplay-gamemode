
local dupontUsers = {
	["Helyumm"] = true,
	["bekiroj"] = true,
	["Finished"] = true,
}
function canEdit(player)
	return dupontUsers[tostring(getElementData(player, "account:username"))] or false
end

function sortList(list_)
	local newList = {}
	for k, v in pairs(list_) do
		v.id = tonumber(v.id)
		v.skin = tonumber(v.skin)
		v.price = tonumber(v.price)

		table.insert(newList, v)
	end

	table.sort(newList,
		function(a, b)
			if a.model == b.model then
				return a.description < b.description
			else
				return a.model < b.model
			end
		end)

	return newList
end


function getInteriorOwner(player)
	local dbid, theEntrance, theExit, interiorType, interiorElement = exports["vrp_interiors"]:findProperty(player)
	interiorStatus = getElementData(interiorElement, "status")
	local owner = interiorStatus[4]
	
	for key, value in ipairs(getElementsByType("player")) do
		local id = getElementData(value, "dbid")
		if (id==owner) then
			return owner, value
		end
	end
	return owner, nil -- no player found
end

local getPlayerName_ = getPlayerName
function getPlayerName(player)
	return getElementType(player) == 'player' and getPlayerName_(player):gsub('_', ' ') or getElementData(player, 'name') or '(ped)'
end

function canBuySkin(player, clothing)
	if not clothing.description or clothing.price == 0 then
		return false
	end

	local desc = clothing.description:lower()
	if desc:sub(1, 7) == 'private' then -- starts with private
		-- can only buy it if it contains his name
		if desc:find(getPlayerName(player):lower()) then
			return true
		end
		return false
	end
	return true
end
