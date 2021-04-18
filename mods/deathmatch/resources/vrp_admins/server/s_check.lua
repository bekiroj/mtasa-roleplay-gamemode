local mysql = exports.vrp_mysql


function doCheck(sourcePlayer, command, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(sourcePlayer) or exports.vrp_integration:isPlayerSupporter(sourcePlayer)) then
		if not (...) then
			outputChatBox("Kullanım: /" .. command .. " [Karakter Adı & ID]", sourcePlayer, 255, 194, 14)
		else
			local noob = exports.vrp_global:findPlayerByPartialNick(sourcePlayer, table.concat({...},"_"))
			if (noob) then
				local logged = getElementData(noob, "loggedin")
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", sourcePlayer, 255, 0, 0)
				else
					if noob and isElement(noob) then
						local ip = getPlayerIP(noob)
						local adminreports = tonumber(getElementData(noob, "adminreports"))
						local donPoints = nil
						
						-- get admin note
						local note = ""
						local warns = "?"
						local transfers = "?"
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								local result = res[1]
								if result then
									text = result["adminnote"] or "?"
									
									
									warns = result["warns"] or "?"
									donPoints = result["credits"] or "?"
								end

								dbQuery(
									function(qh)
										local res, rows, err = dbPoll(qh, 0)
										history = {}
										for index, row in ipairs(res) do
											if row then
												table.insert(history, {tonumber(row.action), tonumber(row.numbr)})
											end
										end
										hoursAcc = "N/A"
										dbQuery(
											function(qh)
												local res, rows, err = dbPoll(qh, 0)

												hoursAcc = tonumber(res[1].hours)
												local bankmoney = getElementData(noob, "bankmoney") or -1
												local money = getElementData(noob, "money") or -1
												
												local adminlevel = exports.vrp_global:getPlayerAdminTitle(noob)
												
												local hoursPlayed = getElementData( noob, "hoursplayed" )
												local username = getElementData( noob, "account:username" )
												triggerClientEvent( sourcePlayer, "onCheck", noob, ip, adminreports, donPoints, note, history, warns, transfers, bankmoney, money, adminlevel, hoursPlayed, username, hoursAcc)
											end,
										mysql:getConnection(), "SELECT SUM(hoursPlayed) AS hours FROM `characters` WHERE account = " .. (tostring(getElementData(noob, "account:id"))))
									end,
								mysql:getConnection(), "SELECT action, COUNT(*) as numbr FROM adminhistory WHERE user = " .. (tostring(getElementData(noob, "account:id"))) .. " GROUP BY action" )
							end,
						mysql:getConnection(), "SELECT adminnote, warns, credits FROM accounts WHERE id = " .. (tostring(getElementData(noob, "account:id"))))

						
					
						
						
					end
				end
				exports.vrp_logs:dbLog(thePlayer, 4, ..., "CHECK")
			end
		end
	end
end
addEvent("checkCommandEntered", true)
addEventHandler("checkCommandEntered", getRootElement(), doCheck)

function savePlayerNote( target, text )
	if exports.vrp_integration:isPlayerTrialAdmin(client) or exports.vrp_integration:isPlayerSupporter(client) then
		local account = getElementData(target, "account:id")
		if account then
			local result = dbExec(mysql:getConnection(),"UPDATE accounts SET adminnote = '" .. ( text ) .. "' WHERE id = " .. (account) )
			if result then
				outputChatBox( "Note for the " .. getPlayerName( target ):gsub("_", " ") .. " (" .. getElementData( target, "account:username" ) .. ") has been updated.", client, 0, 255, 0 )
			else
				outputChatBox( "Note Update failed.", client, 255, 0, 0 )
			end
		else
			outputChatBox( "Unable to get Account ID.", client, 255, 0, 0 )
		end
	end
end
addEvent( "savePlayerNote", true )
addEventHandler( "savePlayerNote", getRootElement(), savePlayerNote )

function showAdminHistory( target )
	if source and isElement(source) and getElementType(source) == "player" then
		client = source
	end
	
	if not (exports.vrp_integration:isPlayerTrialAdmin( client ) or exports.vrp_integration:isPlayerSupporter( client )) then
		if client ~= target then
			return false
		end
	end
	
	local targetID = getElementData( target, "account:id" )
	if targetID then
		dbQuery(
			function(qh, client)
				local res, rows, err = dbPoll(qh, 0)
				local record = {}
				local info = {}
				for index, row in ipairs(res) do
					record[1] = row["date"]
					record[2] = row["action"]
					record[3] = row["reason"]
					record[4] = row["duration"]
					record[5] = row["username"] == nil and "SYSTEM" or row["username"]
					record[6] = row["user_char"] == nil and "N/A" or row["user_char"]
					record[7] = row["recordid"]
					record[8] = row["hadmin"]
					
					table.insert( info, record )
				end
			
				triggerClientEvent( client, "cshowAdminHistory", target, info, tostring( getElementData( target, "account:username" ) ) )
				
			end,
		{client}, mysql:getConnection(), "SELECT DATE_FORMAT(date,'%b %d, %Y at %h:%i %p') AS date, action, h.admin AS hadmin, reason, duration, a.username as username, c.charactername AS user_char, h.id as recordid FROM adminhistory h LEFT JOIN accounts a ON a.id = h.admin LEFT JOIN characters c ON h.user_char=c.id WHERE user = " .. (targetID) .. " ORDER BY h.id DESC")
	
	else
		outputChatBox("Unable to find the account id.", client, 255, 0, 0)
	end
end
addEvent( "showAdminHistory", true )
addEventHandler( "showAdminHistory", getRootElement(), showAdminHistory )

function removeAdminHistoryLine(ID)
	if not ID then return end

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local sqlQuery = res[1]
				if (tonumber(sqlQuery["action"]) == 4) then -- Warning
					local accountNumber = tostring(sqlQuery["user"])
					dbExec(mysql:getConnection(),"UPDATE `accounts` SET `warns`=warns-1 WHERE `ID`='"..(accountNumber).."' AND `warns` > 0")
					for i, player in pairs(getElementsByType("player")) do
						if getElementData(player, "account:id") == tonumber(accountNumber) then
							local warns = getElementData(player, "warns") - 1
							exports.vrp_anticheat:changeProtectedElementDataEx(player, "warns", warns, false)
							break
						end
					end
				end
			
				dbExec(mysql:getConnection(),"DELETE FROM `adminhistory` WHERE `id`='".. (tostring(ID)) .."'")
				if source then
					outputChatBox("Admin history entry #"..ID.." removed", source, 0, 255, 0)
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `adminhistory` WHERE `id`='".. (tostring(ID)).."'")
end
addEvent( "admin:removehistory", true)
addEventHandler( "admin:removehistory", getRootElement(), removeAdminHistoryLine )

addCommandHandler( "history", 
	function( thePlayer, commandName, ... )
		if not (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
			if (...) then
				outputChatBox("Only Admins or Supporters can check other's player admin history.", thePlayer, 255, 0, 0)
				return false
			end
		end
		
		local targetPlayer = thePlayer
		if (...) then
			targetPlayer = exports.vrp_global:findPlayerByPartialNick(thePlayer, table.concat({...},"_"))
		end
		
		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
				outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
			else
				triggerEvent("showAdminHistory", thePlayer, targetPlayer)
			end
		else
			local targetPlayerName = table.concat({...},"_")
			-- select by charactername
			local accounts, characters = exports.vrp_account:getTableInformations()
			local __index = 0
			for index, value in ipairs(characters) do
				if value.charactername == targetPlayerName then
					__index = index
				end
			end
			local result = characters[__index]
			if result then
				if #result == 1 then
			
					local id = row["account"] or '0'
					triggerEvent("showOfflineAdminHistory", thePlayer, id, targetPlayerName)
					return
				
				end
			
			end

			outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
		end
	end
)


addEvent("admin:showInventory", true)
addEventHandler("admin:showInventory", getRootElement(), 
	function ()
		 executeCommandHandler( "showinv", client, getElementData(source, "playerid") )
	end
)

function addAdminHistory(user, admin, reason, action, duration)
	local user_char = 0
	if not action or not tonumber(action) then
		action = getHistoryAction(action)
	end
	if not action then
		action = 6
	end
	if not duration or not tonumber(duration) then
		duration = 0
	end
	if isElement(user) then
		user_char = getElementData(user, "dbid") or 0
		user = getElementData(user, "account:id") or 0
	end
	if isElement(admin) then
		admin = getElementData(admin, "account:id")
	end
	if not tonumber(user) or not tonumber(admin) or not reason then
		outputDebugString("addAdminHistory failed.")
		return false
	end
	return dbExec(mysql:getConnection(),"INSERT INTO adminhistory SET admin="..admin..", user="..user..", user_char="..user_char..", action="..action..", duration="..duration..", reason='"..(reason).."' ")
end