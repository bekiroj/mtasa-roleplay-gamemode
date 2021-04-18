function getCharacterIDFromName(charName)
	if not charName then return false end
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.charactername == charName then
			return characters[index]['id']
		end
	end
	return false
end
function getCharacterNameFromID(charID)
	if not charID then return false end
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.id == charID then
			return characters[index]['charactername']
		end
	end
	return false
end

local userNamesCache = {}
function getUserNameFromID(userID)
	if not userID then return false end
	if userNamesCache[userID] then
		return userNamesCache[userID]
	end
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.id == userID then
			return characters[index]['username']
		end
	end
	return false
end

function getPlayerFromCharacterID(charID)
	local players = exports.vrp_pool:getPoolElementsByType("player")
	for k,v in ipairs(players) do
		if(tonumber(getElementData(v, "dbid")) == tonumber(charID)) then
			return v
		end
	end
	return false
end