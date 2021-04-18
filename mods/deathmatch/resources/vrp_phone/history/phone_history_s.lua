local mysql = exports.vrp_mysql
addedPhoneHistories = {}
function addPhoneHistory(from, to, state, private)
	from = tonumber(from)
	to = tonumber(to)
	state = tonumber(state)
	private = tonumber(private) == 1 and 1 or 0
	addedPhoneHistories[to] = dbExec(mysql:getConnection(),"INSERT INTO `phone_history` SET `from`='"..from.."', `to`='"..to.."', `state`='"..state.."', private="..private)
end

function updatePhoneHistoryState(to, state)
	to = tonumber(to)
	state = tonumber(state)
	if dbExec(mysql:getConnection(),"UPDATE `phone_history` SET `state`='"..state.."' WHERE `to`='"..to.."'   ") then
		addedPhoneHistories[to] = nil
	end
end

function getHistoryData(fromPhone, forceUpdateContactList1, xoffset, yoffset)
	fromPhone = tonumber(fromPhone)
	if forceUpdateContactList1 then
		forceUpdateContactList(source, fromPhone)
	end
	local limit = 9
	local results = {}
	local condition = "(`from`='"..fromPhone.."' OR `to`='"..fromPhone.."') AND !(`state`=2 AND `to`='"..fromPhone.."') "
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table.insert(results, row)
				end
				triggerClientEvent(source, "phone:refreshHistory", source, results, xoffset, yoffset, true)
				dbExec(mysql:getConnection(),"DELETE FROM `phone_history` WHERE DATEDIFF(NOW(),`date`) > 30")
			end
		end,
	{client}, mysql:getConnection(), "SELECT *, TO_SECONDS(`date`) AS `datesec` FROM `phone_history` WHERE "..condition.." ORDER BY `date` DESC LIMIT "..limit)
end
addEvent("phone:getHistoryData", true)
addEventHandler("phone:getHistoryData", root, getHistoryData)