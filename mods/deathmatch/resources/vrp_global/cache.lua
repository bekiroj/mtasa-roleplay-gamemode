--@class cache inception
--@author Disco
local toCacheTables = {"accounts", "characters", "vehicles_shop", "vehicles_custom"}
local cacheStorages = {}
local timerOnSpam = {}
local cacheSelections = {}

addEventHandler("onResourceStart", resourceRoot,
	function()
		for i, tableName in ipairs(toCacheTables) do
			timerOnSpam[tableName], cacheSelections[tableName] = {}, {}
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						cacheStorages[tableName] = {}
                                               -- print('cached', tableName)
						for index, value in ipairs(res) do
                                  --                      print('cached', 'id', 'value', value)
							cacheStorages[tableName][value.id] = {}
							for i, d in pairs(value) do
								cacheStorages[tableName][value.id][i] = tonumber(d) or d;
							end
						end
					end
				end,
			mysql:getConnection(), "SELECT * FROM `"..tableName.."`")
		end
	end
)

function getCache(tableName, toNeed, toNeedRow)
	if cacheStorages[tableName] then
		if toNeed and not toNeedRow then
			if cacheStorages[tableName][toNeed] then
				return cacheStorages[tableName][toNeed]
			else
				requestLoadCache(tableName, toNeed)
			end
		elseif toNeed and toNeedRow then
			for i, v in pairs(cacheStorages[tableName]) do
				if v[toNeedRow] == toNeed then
					return cacheStorages[tableName][i]
				end
			end
		end
	end
	return false
end

function getMultipleCache(tableName, toNeed, toNeedRow)
	local temp = {}
        print(cacheStorages[tableName] or true)
	if cacheStorages[tableName] then
		if toNeed and not toNeedRow then
			if cacheStorages[tableName][toNeed] then
				return cacheStorages[tableName][toNeed]
			else
				requestLoadCache(tableName, toNeed)
			end
		elseif toNeed and toNeedRow then
			for i, v in pairs(cacheStorages[tableName]) do
				if v[toNeedRow] == toNeed then
					table.insert(temp, cacheStorages[tableName][i])
					--return cacheStorages[tableName][i]
				end
			end
			return temp
		end
	end
	return false
end

function requestLoadCache(tableName, toNeedID, toNeedIndex, callback)
	--timerOnSpam[tableName][toNeedID] = setTimer(function() end, 1000*5, 1)
	--if timerOnSpam[tableName][toNeedID] and isTimer(timerOnSpam[tableName][toNeedID]) then
	--	return false
	--end
	if not toNeedIndex then
		toNeedIndex = "id"
	end

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					cacheStorages[tableName][value.id] = {}
					for i, d in pairs(value) do
						cacheStorages[tableName][value.id][i] = tonumber(d) or d;
					end
				end
				if callback then
					callback("ok")
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `"..tableName.."` WHERE `"..toNeedIndex.."`='"..toNeedID.."'")
end

function getCharacterIDFromName(charID)
	local row = getCache("characters", charID, "charactername")
	if row then
		return row.id
	end
	return false
end

function getCharacterNameFromID(charID)
	local row = getCache("characters", charID, "id")
	if row then
		return row.charactername
	end
	return false
end

function getUserNameFromID(userID)
	local row = getCache("accounts", userID, "id")
	if row then
		return row.username
	end
	return false
end

function getIDFromUsername(userID)
	local row = getCache("accounts", userID, "username")
	if row then
		return row.id
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