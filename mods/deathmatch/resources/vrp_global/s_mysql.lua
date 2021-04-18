function toSQL(stuff)
	return stuff
end

function getSmallestIdFromDbTable(tableName) -- finds the smallest ID in the SQL instead of auto increment
	if not tableName then
		return false
	end
	local result = dbPoll(dbQuery(exports.vrp_mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM "..tableName.." AS e1 LEFT JOIN "..tableName.." AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
	if result then
		local id = tonumber(result["nextID"]) or 1
		return id
	end
	return false
end

addEventHandler("onPlayerCommand",root,function(command)
	if (command == "fakelag") then
		cancelEvent()
	end
	if (command == "debuguptime") then
		cancelEvent()
	end
	if (command == "debugjoinflood") then
		cancelEvent()
	end
	if (command == "sfakelag") then
		cancelEvent()
	end
	if (command == "loadmodule") then
		cancelEvent()
	end
end)