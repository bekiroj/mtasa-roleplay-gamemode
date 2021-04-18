--MAXIME
local mysql = exports.vrp_mysql
local refreshCacheRate = 10
local usernameCache = {}
local searched = {}
function getUsername( clue )
	if not clue or string.len(clue) < 1 then
		outputDebugString("Server cache: clue is empty.")
		return false
	end
	
	for i, username in pairs(usernameCache) do
		if username and string.lower(username) == string.lower(clue) then
			outputDebugString("Server cache: Username found in cache - "..username) 
			return username
		end
	end
	
	outputDebugString("Server cache: Username not found in cache. Searching in all current online players.")
	for i, player in pairs(exports.vrp_pool:getPoolElementsByType("player")) do
		local username = getElementData(player, "account:username")
		if username and string.lower(username) == string.lower(clue) then
			usernameCache[getElementData(player, "account:id")] = username
			outputDebugString("Server cache: Username found in current online players. - "..username) 
			return username
		end
	end
	
	outputDebugString("Server cache: Username not found in all current online players. Searching in database.")
	if not searched[clue] then
		local accounts, characters = exports.vrp_account:getTableInformations()
		for index, value in ipairs(accounts) do
			if value.username == clue then
				usernameCache[tonumber(value["id"])] = value["username"]
				return value["username"]
			end
		end
		outputDebugString("Server cache: Username does not exist in database.")
		searched[clue] = true
		setTimer(function()
			local index = clue
			searched[index] = nil
		end, refreshCacheRate*1000*60, 1)
	else
		outputDebugString("Server cache: Previously requested for server's cache. Searching cancelled within refresh rate ("..refreshCacheRate.." minutes).")
	end
	return false
end

function checkUsernameExistance(clue)
	if not clue or string.len(clue) < 1 then
		return false, "Please enter account name."
	end 
	local found = getUsername( clue )
	if found then
		return true, "Account name '"..found.."' is existed and valid!"
	else
		return false, "Account name '"..clue.."' does not exist."
	end
end

function requestUsernameCacheFromServer(clue)
	local found = getUsername( clue )
	outputDebugString("Server cache: Checked server's cache and responding to client")
	triggerClientEvent(client, "retrieveUsernameCacheFromServer", source, found)
end
addEvent("requestUsernameCacheFromServer", true)
addEventHandler("requestUsernameCacheFromServer", root, requestUsernameCacheFromServer)

function getUsernameFromId(id)
	if not id or not tonumber(id) then
		outputDebugString("Server cache: id is empty.")
		return false
	else
		id = tonumber(id)
	end
	
	if usernameCache[id] then
		outputDebugString("Server cache: Username found in cache - "..usernameCache[id]) 
		return usernameCache[id]
	end
	
	outputDebugString("Server cache: Username not found in cache. Searching in all current online players.")
	for i, player in pairs(exports.vrp_pool:getPoolElementsByType("player")) do
		if id == getElementData(player, "account:id") then
			usernameCache[id] = getElementData(player, "account:username")
			outputDebugString("Server cache: Username found in current online players. - "..usernameCache[id]) 
			return usernameCache[id]
		end
	end
	
	if searched[id] then
		outputDebugString("Server cache: Previously requested for server's cache but not found. Searching cancelled.")
		return false
	end
	searched[id] = true

	outputDebugString("Server cache: Username not found in all current online players. Searching in database.")
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.id == id then
			usernameCache[tonumber(value["id"])] = value["username"]
			return value["username"]
		end
	end

	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	outputDebugString("Server cache: Username does not exist in database.")
	return false
end

local accountCache = {}
local accountCacheSearched = {}
function getAccountFromCharacterId(id)
	if id and tonumber(id) then
		id = tonumber(id)
	else
		return false
	end
	if accountCache[id] then
		return accountCache[id]
	end
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "dbid") == id then
			accountCache[id] = {id = getElementData(player, "account:id"), username = getElementData(player, "account:username")}
			return accountCache[id]
		end
	end

	if accountCacheSearched[id] then
		return false
	end
	accountCacheSearched[id] = true

	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.account == id then
			usernameCache[tonumber(value["id"])] = value["username"]
			accountCache[id] = {id = tonumber(value.id), username = value.username}
			return accountCache[id]
		end
	end

	setTimer(function()
		local index = id
		accountCacheSearched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	return false
end