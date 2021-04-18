
function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		
		if day > 0 then table.insert( results, day .. ( day == 1 and " gün" or " gün" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and " saat" or " saat" ) ) end
		if min > 0 then table.insert( results, min .. ( min == 1 and " dakika" or " dakika" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and " saniye" or " saniye" ) ) end
		
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", " ev ", 1 ) )
	end
	return ""
end

function SmallestID()
	local result = dbQuery(exports.vrp_mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vipPlayers AS e1 LEFT JOIN vipPlayers AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result2 = dbPoll(result, -1)
	if result2 then
		local id = tonumber(result2[1]["nextID"]) or 1
		return id
	end
	return false
end

function isPlayerVIP(charID)
	return vipPlayers[charID] and true or false
end