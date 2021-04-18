--Militan tarafından yeniden kodlandı.
local mysql = exports.vrp_mysql
local staffTitles = exports.vrp_integration:getStaffTitles()
function getStaffInfo(username, error)
	local accounts = exports.vrp_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.username == username then
			user = {
				["id"] = value.id,
				["username"] = value.username,
				["admin"] = value.admin,
				["supporter"] = value.supporter,
				["vct"] = value.vct,
				["scripter"] = value.scripter,
				["mapper"] = value.mapper,
 			}
		end
	end
	local changelogs = {}
	dbQuery(
		function(qh, source, user)
			local res, rows, err = dbPoll(qh, 0)
			--if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(changelogs, row )
				end
				local staffInfo = {}
				staffInfo.user = user
				staffInfo.changelogs = changelogs
				staffInfo.error = error
				exports.vrp_account:updateTables()
				triggerClientEvent(source, "openStaffManager", source, staffInfo)
			--end
		end,
	{source, user}, mysql:getConnection(), "SELECT (CASE WHEN to_rank>from_rank THEN 1 ELSE 0 END) AS promoted, s.id, a1.username, team, from_rank, to_rank, a2.username AS `by`, details, DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS date FROM staff_changelogs s LEFT JOIN accounts a1 ON s.userid=a1.id LEFT JOIN accounts a2 ON s.`by`=a2.id WHERE s.userid="..user.id.." ORDER BY id DESC")
end
addEvent("staff:getStaffInfo", true)
addEventHandler("staff:getStaffInfo", root, getStaffInfo)

function getTeamsData()
	staffTitles = exports.vrp_integration:getStaffTitles()
	local users = {}
	dbQuery(
		function(qh, source)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					for i, k in ipairs(staffTitles) do
						if not users[i] then users[i] = {} end
						if tonumber(row.admin) > 0 and i == 1 then
							if not row.rank then row.rank = {} end
							row.rank[i] = tonumber(row.admin)
							table.insert(users[i], row)
						end
						if tonumber(row.supporter) > 0 and i == 2 then
							if not row.rank then row.rank = {} end
							row.rank[i] = tonumber(row.supporter)
							table.insert(users[i], row)
						end
						if tonumber(row.vct) > 0 and i == 3 then
							if not row.rank then row.rank = {} end
							row.rank[i] = tonumber(row.vct)
							table.insert(users[i], row)
						end
						if tonumber(row.scripter) > 0 and i == 4 then
							if not row.rank then row.rank = {} end
							row.rank[i] = tonumber(row.scripter)
							table.insert(users[i], row)
						end
						if tonumber(row.mapper) > 0 and i == 5 then
							if not row.rank then row.rank = {} end
							row.rank[i] = tonumber(row.mapper)
							table.insert(users[i], row)
						end
					end
				end
				triggerClientEvent(source, "openStaffManager", source, nil, users )
			end
		end,
	{source}, mysql:getConnection(), "SELECT a.id, username, admin, supporter, vct, scripter, mapper, adminreports, AVG(rating) AS rating, COUNT(f.staff_id) AS feedbacks FROM accounts a LEFT JOIN feedbacks f ON a.id=f.staff_id WHERE admin > 0 OR supporter > 0 OR vct > 0 OR scripter>0 OR mapper>0 GROUP BY a.id ORDER BY admin DESC, adminreports DESC, supporter DESC, vct DESC, scripter DESC, mapper DESC")
end
addEvent("staff:getTeamsData", true)
addEventHandler("staff:getTeamsData", root, getTeamsData)

function getChangelogs()
	local changelogs = {}
	dbQuery(
		function(qh, source)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(changelogs, row )
				end
				triggerClientEvent(source, "openStaffManager", source, nil, nil, changelogs )
			end
		end,
	{source}, mysql:getConnection(), "SELECT (CASE WHEN to_rank>from_rank THEN 1 ELSE 0 END) AS promoted, s.id, a1.username, team, from_rank, to_rank, a2.username AS `by`, details, DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS date FROM staff_changelogs s LEFT JOIN accounts a1 ON s.userid=a1.id LEFT JOIN accounts a2 ON s.`by`=a2.id ORDER BY id DESC")
end
addEvent("staff:getChangelogs", true)
addEventHandler("staff:getChangelogs", root, getChangelogs)

function editStaff(userid, ranks, details)
	local error = nil
	if not userid or not tonumber(userid) then
		outputChatBox("Internal Error!", source, 255, 0, 0)
		return false
	else
		userid = tonumber(userid)
	end
	local target = nil
	for i, player in pairs(getElementsByType("player")) do
		if getElementData(player, "account:id") == userid then
			target = player
			break
		end
	end
	staffTitles = exports.vrp_integration:getStaffTitles()
	local accounts = exports.vrp_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.id == userid then
			user = {
				["id"] = value.id,
				["username"] = value.username,
				["admin"] = value.admin,
				["supporter"] = value.supporter,
				["vct"] = value.vct,
				["scripter"] = value.scripter,
				["mapper"] = value.mapper,
 			}
		end
	end


	local tail = ''
	if details and string.len(details)>0 then
		details = "'"..(details).."'"
	else
		details = "NULL"
	end
	if ranks[1] and ranks[1] ~= tonumber(user.admin) then
		tail = tail.."admin="..ranks[1]..","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid="..userid..", details="..details..", `by`="..getElementData(source, "account:id")..", team=1, from_rank="..user.admin..", to_rank="..ranks[1])
		exports.vrp_global:sendMessageToStaff("[Yetki Güncellemesi] "..exports.vrp_global:getPlayerFullIdentity(source, 1, true).." adlı yetkili "..(ranks[1] > tonumber(user.admin) and "promoted" or "demoted").." '"..user.username.."' from "..staffTitles[1][tonumber(user.admin)].." to "..staffTitles[1][ranks[1]]..".", true)
		if target then exports.vrp_anticheat:changeProtectedElementDataEx(target, "admin_level", ranks[1], true) end
	end
	if ranks[2] and ranks[2] ~= tonumber(user.supporter) then
		tail = tail.."supporter="..ranks[2]..","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid="..userid..", details="..details..", `by`="..getElementData(source, "account:id")..", team=2, from_rank="..user.supporter..", to_rank="..ranks[2])
		exports.vrp_global:sendMessageToStaff("[Yetki Güncellemesi] "..exports.vrp_global:getPlayerFullIdentity(source, 1, true).." adlı yetkili "..(ranks[2] > tonumber(user.supporter) and "promoted" or "demoted").." '"..user.username.."' from "..staffTitles[2][tonumber(user.supporter)].." to "..staffTitles[2][ranks[2]]..".", true)
		if target then exports.vrp_anticheat:changeProtectedElementDataEx(target, "supporter_level", ranks[2], true) end
	end
	if ranks[3] and ranks[3] ~= tonumber(user.vct) then
		tail = tail.."vct="..ranks[3]..","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid="..userid..", details="..details..", `by`="..getElementData(source, "account:id")..", team=3, from_rank="..user.vct..", to_rank="..ranks[3])
		exports.vrp_global:sendMessageToStaff("[Yetki Güncellemesi] "..exports.vrp_global:getPlayerFullIdentity(source, 1, true).." adlı yetkili "..(ranks[3] > tonumber(user.vct) and "promoted" or "demoted").." '"..user.username.."' from "..staffTitles[3][tonumber(user.vct)].." to "..staffTitles[3][ranks[3]]..".", true)
		if target then exports.vrp_anticheat:changeProtectedElementDataEx(target, "vct_level", ranks[3], true) end
		
	end
	if ranks[4] and ranks[4] ~= tonumber(user.scripter) then
		tail = tail.."scripter="..ranks[4]..","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid="..userid..", details="..details..", `by`="..getElementData(source, "account:id")..", team=4, from_rank="..user.scripter..", to_rank="..ranks[4])
		exports.vrp_global:sendMessageToStaff("[Yetki Güncellemesi] "..exports.vrp_global:getPlayerFullIdentity(source, 1, true).." adlı yetkili "..(ranks[4] > tonumber(user.scripter) and "promoted" or "demoted").." '"..user.username.."' from "..staffTitles[4][tonumber(user.scripter)].." to "..staffTitles[4][ranks[4]]..".", true)
		if target then exports.vrp_anticheat:changeProtectedElementDataEx(target, "scripter_level", ranks[4], true) end
		 exports.vrp_account:updateTables()
		
	end
	if ranks[5] and ranks[5] ~= tonumber(user.mapper) then
		tail = tail.."mapper="..ranks[5]..","
		dbExec(mysql:getConnection(), "INSERT INTO staff_changelogs SET userid="..userid..", details="..details..", `by`="..getElementData(source, "account:id")..", team=5, from_rank="..user.mapper..", to_rank="..ranks[5])
		exports.vrp_global:sendMessageToStaff("[Yetki Güncellemesi] "..exports.vrp_global:getPlayerFullIdentity(source, 1, true).." adlı yetkili "..(ranks[5] > tonumber(user.mapper) and "promoted" or "demoted").." '"..user.username.."' from "..staffTitles[5][tonumber(user.mapper)].." to "..staffTitles[5][ranks[5]]..".", true)
		if target then exports.vrp_anticheat:changeProtectedElementDataEx(target, "mapper_level", ranks[5], true) end
	end
	if tail ~= '' then
		tail = string.sub(tail, 1, string.len(tail)-1)
		if not dbExec(mysql:getConnection(), "UPDATE accounts SET "..tail.." WHERE id="..userid) then
			outputChatBox("Internal Error!", source, 255, 0, 0)
			return false
		end
	end
	triggerEvent("staff:getStaffInfo", source, user.username, "Staff rank for "..user.username.." has been set!")
	exports.vrp_account:updateTables()
end
addEvent("staff:editStaff", true)
addEventHandler("staff:editStaff", root, editStaff)