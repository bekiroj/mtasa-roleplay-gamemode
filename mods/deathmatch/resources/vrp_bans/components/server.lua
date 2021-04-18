local mysql = exports.vrp_mysql
local banCache = {}
local banAffectedSerial = {}
local banAffectedIP = {}
local banAffectedAccount = {}
local lastBan = nil
local lastBanTimer = nil
local removeBan_ = removeBan

function banAPlayer(thePlayer, commandName, targetPlayer, hours, ...)
	if exports["vrp_integration"]:isPlayerSeniorAdmin(thePlayer) then
		if not (targetPlayer) or not (hours) or not tonumber(hours) or tonumber(hours)<0 or not (...) then
			outputChatBox("[!] #ffffff /" .. commandName .. " [Oyuncu İsmi / ID] [0 = Sınırsız, Saat girin] [Açıklama]", thePlayer, 0, 55, 255, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			local targetPlayerSerial = getPlayerSerial(targetPlayer)
			local targetPlayerIP = getPlayerIP(targetPlayer)
			hours = tonumber(hours)

			if not (targetPlayer) then
			elseif (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
			else
				local thePlayerPower = exports.vrp_global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.vrp_global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")

				if (targetPlayerPower <= thePlayerPower) then -- Check the admin isn't banning someone higher rank them him
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					local accountID = getElementData(targetPlayer, "player.dbid")
					local username = getElementData(targetPlayer, "player.username") or "N/A"

					local seconds = ((hours*60)*60)
					local rhours = hours
					-- text value
					if (hours==0) then
						hours = "Sınırsız"
					elseif (hours==1) then
						hours = "1 Saat"
					else
						hours = hours .. " Saat"
					end

					if hours == "Sınırsız" then
						reason = reason .. " (" .. hours .. ")"
					else
						reason = reason .. " (" .. hours .. ")"
					end

					
					exports['vrp_admins']:addAdminHistory(targetPlayer, thePlayer, reason, 2 , rhours)
					local banId = nil
					if (seconds == 0) then
						banId = addToBan(accountID, targetPlayerSerial, targetPlayerIP, getElementData(thePlayer, "player.dbid"), reason)
						if banId  then
							dbQuery(
								function(qh)
									local res, rows, err = dbPoll(qh, 0)
									if rows > 0 then
										lastBan = res[1]
										if lastBanTimer and isTimer(lastBanTimer) then
											killTimer(lastBanTimer)
											lastBanTimer = nil
										end
										banCache[lastBan.id] = lastBan
										banAffectedIP[lastBan.ip] = lastBan
										banAffectedSerial[lastBan.serial] = lastBan
										banAffectedAccount[lastBan.account] = lastBan
										lastBanTimer = setTimer(function()
											lastBan = nil
										end, 1000*60*5,1)
									end
								end,
							mysql:getConnection(), "SELECT * FROM bans WHERE id=LAST_INSERT_ID()")
						end
					else
						addBan(nil, nil, targetPlayerSerial, thePlayer, reason, seconds)
					end

					local adminUsername = getElementData(thePlayer, "player.username")
					local adminUserID = getElementData(thePlayer, "player.dbid")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == targetPlayerSerial then
							local ip = "92.222.155.174"
							local port = "22003"
						end
					end

					adminTitle = exports.vrp_global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "Gizli Yetkili"
					end

					if string.lower(commandName) == "sban" then
						exports.vrp_global:sendMessageToAdmins("[SESSIZ BAN] " .. adminTitle .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu yasakladı. (" .. hours .. ")")
						exports.vrp_global:sendMessageToAdmins("[SESSIZ BAN] Açıklama: " .. reason .. ".")
					elseif string.lower(commandName) == "forceapp" then
						outputChatBox("[FA] "..adminTitle .. " " .. playerName .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu yasakladı.", root, 255,0,0)
						hours = "Sınırsız"
						reason = "Kaldırtmak için www.inceptionroleplay.com"
						outputChatBox("[FA]: Açıklama: " .. reason .. "." ,root, 255,0,0)
					else
						for i, player in ipairs(getElementsByType("player")) do
							if getElementData(player, "jd.en") then
								outputChatBox("[YASAKLAMA] " .. adminTitle .. " isimli yetkili " .. targetPlayerName .. " isimli oyuncuyu yasakladı. (" .. hours .. ")", player, 255,0,0)
								outputChatBox("[YASAKLAMA] Açıklama: " .. reason .. ".", player, 255,0,0)
							end
						end
						
					end
					exports.vrp_global:sendMessageToAdmins("/showban yazarak detaylara bakabilirsiniz.")
				else
					outputChatBox("[!] #ffffffYetkisi sizden yüksek.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("pban", banAPlayer, false, false)
addCommandHandler("sban", banAPlayer, false, false)

function karakterBanla(thePlayer, commandName, targetPlayer, ...)
	local logged = getElementData(thePlayer, "loggedin")
	local message = nil
	if(logged==1) and (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("[!] #ffffff/cban [OyuncuID/Isim] [Mesaj]", thePlayer, 0, 125, 255, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local affectedElements = { }
				local message = table.concat({...}, " ")
				local charID = getElementData(targetPlayer, "dbid")
				local time = getRealTime()
				local saat = time.hour
				local saniye = time.minute
				setElementData(targetPlayer, "activeCharacter", 0)
				exports['vrp_admins']:addAdminHistory(targetPlayer, thePlayer, message.." | Sınırsız. (( "..targetPlayerName.." ))", 2 , 0)
				outputChatBox("(( " .. targetPlayerName .. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: ".. message .. " - " ..string.format("%02d", saat)..":"..string.format("%02d", saniye).. " ))", arrarPlayer, 255, 0, 0)
				dbExec(mysql:getConnection(), "UPDATE characters SET active=0 WHERE id = "..(charID))
				dbExec(mysql:getConnection(), "UPDATE characters SET activeDescription='"..message.."' WHERE id = "..(charID))

				exports.vrp_global:updateTableCache("characters", getElementData(targetPlayer, "dbid"), {["active"] = 0, ["activeDescription"] = message})

				redirectPlayer(targetPlayer, "", "")
			end
		end
	end
end
addCommandHandler("cban", karakterBanla, false, false)

addEvent("selfckPlayer", true)
addEventHandler("selfckPlayer", root,
	function(targetPlayer)
		local message = "Karakter Ölümü"
		local targetPlayerName = getPlayerName(targetPlayer)
		setElementData(targetPlayer, "activeCharacter", 0)
		local charID = getElementData(targetPlayer, "dbid")
		local time = getRealTime()
		local saat = time.hour
		local saniye = time.minute
		exports['vrp_admins']:addAdminHistory(targetPlayer, targetPlayer, message.." | Sınırsız. (( "..targetPlayerName.." ))", 2 , 0)
		outputChatBox("(( " .. targetPlayerName .. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: ".. message .. " - " ..string.format("%02d", saat)..":"..string.format("%02d", saniye).. " ))", root, 255, 0, 0)
		dbExec(mysql:getConnection(), "UPDATE characters SET `active`='0', `activeDescription`='"..message.."' WHERE `id` = '"..charID.."'")
		exports.vrp_global:updateTableCache("characters", getElementData(targetPlayer, "dbid"), {["active"] = 0, ["activeDescription"] = message})

		redirectPlayer(targetPlayer, "", "")
	end
)

addCommandHandler("unsban",
	function(thePlayer, commandName, username)
		if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
			if not username then
				outputChatBox("SYNTAX: /" .. commandName .. " [Username]", thePlayer, 255, 194, 14)
				return
			end
			local row = exports.vrp_global:getAccountDetails(username)
			if row then
				for _, banElement in ipairs(getBans()) do
					if getBanSerial(banElement) == row.mtaserial or getBanIP(banElement) == row.ip then
						removeBan_(banElement)
						outputChatBox(row.username.." adlı kullanıcının süreli yasağı başarıyla kaldırıldı.", thePlayer, 255, 194, 14)
						return
					end
				end
				outputChatBox(row.username.." adlı kullanıcının süreli yasağı yok.", thePlayer, 255, 194, 14)
			else
				outputChatBox("Kullanıcı adı bulunamadı.", thePlayer, 255, 194, 14)				
			end
		end
	end
)

function offlineBanAPlayer(thePlayer, commandName, targetUsername, hours, ...)
	if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
		if not (targetUsername) or not (hours) or not tonumber(hours) or (tonumber(hours)<0) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Username] [Time in Hours, 0 = Infinite] [Reason]", thePlayer, 255, 194, 14)
		else
			hours = tonumber(hours) or 0
			if (hours>168) then
				outputChatBox("You cannot ban for more than 7 days (168 Hours).", thePlayer, 255, 194, 14)
				return false
			end

			local user = exports.vrp_global:getCache("accounts", targetUsername, "username")
			if user and user['id'] and tonumber(user['id']) then
				targetUsername = user['username']
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							printBanInfo(thePlayer, res[1])
						end
					end,
				mysql:getConnection(), "SELECT * FROM bans WHERE account='"..user["id"].."' LIMIT 1")
				
				local thePlayerPower = exports.vrp_global:getPlayerAdminLevel(thePlayer)
				local adminTitle = exports.vrp_global:getAdminTitle1(thePlayer)
				local adminUsername = getElementData(thePlayer, "player.username" )
				if (tonumber(user['admin']) > thePlayerPower) then
					outputChatBox(" '"..targetUsername.."' is a higher level admin than you.", thePlayer, 255, 0, 0)
					exports.vrp_global:sendMessageToAdmins("AdmWrn: "..adminTitle.." attempted to execute the ban command on higher admin '"..targetUsername.."'.")
					return false
				end

				--check online players
				for i, player in pairs(getElementsByType("player")) do
					if getElementData(player, "player.dbid") == tonumber(user['id'])  then
						local cmd = "pban"
						if string.lower(commandName) == "soban" then
							cmd = "sban"
						end
						banAPlayer(thePlayer, cmd, getElementData(player, "playerid"), hours, (...))
						return true
					end
				end

				local reason = table.concat({...}, " ")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
				local playerName = getPlayerName(thePlayer)

				local seconds = ((hours*60)*60)
				local rhours = hours
				-- text value
				if (hours==0) then
					hours = "Sınırsız"
				elseif (hours==1) then
					hours = "1 Saat"
				else
					hours = hours .. " Saat"
				end
				reason = reason .. " (" .. hours .. ")"
				exports['vrp_admins']:addAdminHistory(user['id'], thePlayer, reason, 2, rhours)

				local targetSerial = nil
				if user['mtaserial'] ~= nil then
					targetSerial = user['mtaserial']
				end
				local banId = nil
				if seconds == 0 then
					banId = addToBan(user['id'], user['mtaserial'], user['ip'], getElementData(thePlayer, "player.dbid"), reason)
					if banId  then
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									lastBan = res[1]
									if lastBanTimer and isTimer(lastBanTimer) then
										killTimer(lastBanTimer)
										lastBanTimer = nil
									end
									banCache[lastBan.id] = lastBan
									banAffectedIP[lastBan.ip] = lastBan
									banAffectedSerial[lastBan.serial] = lastBan
									banAffectedAccount[lastBan.account] = lastBan
									lastBanTimer = setTimer(function()
										lastBan = nil
									end, 1000*60*5,1)
								end
							end,
						mysql:getConnection(), "SELECT * FROM bans WHERE id=LAST_INSERT_ID()")

						
					end
				elseif targetSerial then
					addBan(nil, nil, targetSerial, thePlayer, reason, seconds)
				end
				local adminUsername = getElementData(thePlayer, "player.username")
				local adminUserID = getElementData(thePlayer, "player.dbid")
				adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
				if targetSerial then
					for key, value in ipairs(getElementsByType("player")) do
						if getPlayerSerial(value) == targetSerial then
							--kickPlayer(value, thePlayer, reason)
							local ip = "92.222.155.174"
							local port = "22003"
						end
					end
				end

				if (hiddenAdmin==1) then
					adminTitle = "Gizli Yetkili"
				end
				if string.lower(commandName) == "soban" then
					exports.vrp_global:sendMessageToAdmins("[ÇEVRİMDIŞI-BAN]: " .. adminTitle .. " " .. adminUsername .. " isimli yetkili " .. targetUsername .. " kullanici adli oyuncuyu yasakladi. (" .. hours .. ")")
					exports.vrp_global:sendMessageToAdmins("[ÇEVRİMDIŞI-BAN]: Açıklama: " .. reason .. ".")
				else
					outputChatBox("[ÇEVRİMDIŞI-BAN]: " .. adminTitle .. " " .. adminUsername .. " isimli yetkili " .. targetUsername .. " kullanici adli oyuncuyu yasakladi. (" .. hours .. ")", getRootElement(), 255, 0, 51)
					outputChatBox("[ÇEVRİMDIŞI-BAN]: Açıklama: " .. reason .. ".", getRootElement(), 255, 0, 51)
				end

				exports.vrp_global:sendMessageToAdmins("/showban yazarak detaylara bakabilirsiniz.")
			else
				outputChatBox("[!] #ffffffKullanıcı adı tespit edilemedi.", thePlayer, 255, 0, 0, true)
				return false
			end
		end
	end
end
addCommandHandler("oban", offlineBanAPlayer, false, false)
addCommandHandler("soban", offlineBanAPlayer, false, false)

function banPlayerSerial(thePlayer, commandName, serial, ...)
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not serial or not string.len(serial) or not string.len(serial) == 32 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Serial Number] [Reason]", thePlayer, 255, 194, 14)
		else

			local reason = table.concat({...}, " ")
			serial = string.upper(serial)
			local id = addToBan(nil, serial, nil, getElementData(thePlayer,"player.dbid"), reason)
			if id and tonumber(id) then
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							lastBan = res[1]
							if lastBanTimer and isTimer(lastBanTimer) then
								killTimer(lastBanTimer)
								lastBanTimer = nil
							end
							banCache[lastBan.id] = lastBan
							banAffectedIP[lastBan.ip] = lastBan
							banAffectedSerial[lastBan.serial] = lastBan
							banAffectedAccount[lastBan.account] = lastBan
							lastBanTimer = setTimer(function()
								lastBan = nil
							end, 1000*60*5,1)
						end
					end,
				mysql:getConnection(), "SELECT * FROM bans WHERE id=LAST_INSERT_ID()")
				
				for key, value in ipairs(getElementsByType("player")) do
					if getPlayerSerial(value) == serial then
						kickPlayer(value, thePlayer, reason)
					end
				end
				exports.vrp_global:sendMessageToAdmins("[BAN] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has banned serial number '"..serial.."' permanently for '"..reason.."'. /showban for details.")
			
			else

			end
		end
	end
end
addCommandHandler("banserial", banPlayerSerial, false, false)
addCommandHandler("serialban", banPlayerSerial, false, false)

function banPlayerIP(thePlayer, commandName, ip, ...)
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not ip or not string.len(ip) or string.len(ip) > 15 or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [IP Address] [Reason]", thePlayer, 255, 194, 14)
			outputChatBox("You can use * for IP range ban. For example: 192.168.*.*", thePlayer, 255, 194, 14)
		else
			local reason = table.concat({...}, " ")
			local id = addToBan(nil, nil, ip, getElementData(thePlayer,"player.dbid"), reason)
			if id and tonumber(id) then
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							lastBan = res[1]
							if lastBanTimer and isTimer(lastBanTimer) then
								killTimer(lastBanTimer)
								lastBanTimer = nil
							end
							banCache[lastBan.id] = lastBan
							banAffectedIP[lastBan.ip] = lastBan
							banAffectedSerial[lastBan.serial] = lastBan
							banAffectedAccount[lastBan.account] = lastBan
							lastBanTimer = setTimer(function()
								lastBan = nil
							end, 1000*60*5,1)
						end
					end,
				mysql:getConnection(), "SELECT * FROM bans WHERE id=LAST_INSERT_ID()")
				
				for key, value in ipairs(getElementsByType("player")) do
					if getPlayerIP(value) == ip then
						kickPlayer(value, thePlayer, reason)
					end
				end
				exports.vrp_global:sendMessageToAdmins("[BAN] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has banned IP Address '"..ip.."' permanently for '"..reason.."'. /showban for details.")
			
			end
		end
	end
end
addCommandHandler("ipban", banPlayerIP, false, false)
addCommandHandler("banip", banPlayerIP, false, false)

function banPlayerAccount(thePlayer, commandName, account, ...)
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not account or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Username] [Reason]", thePlayer, 255, 194, 14)
		else
			local account = exports.vrp_global:getCache("accounts", account, "username")
			if not account or account.id == nil then
				outputChatBox("Account '"..account.."' does not existed.", thePlayer, 255, 0, 0)
				return false
			end
			local reason = table.concat({...}, " ")
			local id = addToBan(account.id, nil, nil, getElementData(thePlayer,"player.dbid"), reason)
			if id and tonumber(id) then
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							lastBan = res[1]
							banCache[lastBan.id] = lastBan
							banAffectedIP[lastBan.ip] = lastBan
							banAffectedSerial[lastBan.serial] = lastBan
							banAffectedAccount[lastBan.account] = lastBan
							if lastBanTimer and isTimer(lastBanTimer) then
								killTimer(lastBanTimer)
								lastBanTimer = nil
							end
							lastBanTimer = setTimer(function()
								lastBan = nil
							end, 1000*60*5,1)
						end
					end,
				mysql:getConnection(), "SELECT * FROM bans WHERE id=LAST_INSERT_ID()")
				
				for key, value in ipairs(getElementsByType("player")) do
					if getElementData(value, "player.dbid") == tonumber(account.id) then
						kickPlayer(value, thePlayer, reason)
					end
				end
				exports.vrp_global:sendMessageToAdmins("[BAN] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has banned account '"..(account.username).."' permanently for '"..reason.."'. /showban for details.")
			
			end
		end
	end
end
addCommandHandler("banaccount", banPlayerAccount, false, false)
addCommandHandler("accountban", banPlayerAccount, false, false)

-- /UNBAN
function unbanPlayer(thePlayer, commandName, id)
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not id or not tonumber(id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Ban ID]", thePlayer, 255, 194, 14)
			outputChatBox("/showban [Username or serial or IP] to retrieve ban ID.", thePlayer, 255, 194, 14)
		else
			if tonumber(getElementData(thePlayer, "cmd:unban")) ~= tonumber(id) then
				dbQuery(
					function(qh, thePlayer)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							local ban = res[1]
							if ban and ban['id'] and tonumber(ban['id']) then
								printBanInfo(thePlayer,ban)
								outputChatBox("You're about to remove this ban record. Please type /unban "..ban['id'].." once again to proceed.", thePlayer, 255, 194, 14)
								setElementData(thePlayer, "cmd:unban", ban['id'])
							end
						end
					end,
				{thePlayer}, mysql:getConnection(), "SELECT * FROM bans WHERE id='"..id.."'")
			else
				local res, rows = banCache[tonumber(id)], #banCache[tonumber(id)]
				if rows then
					local ban = res
					if ban and ban['id'] and tonumber(ban['id']) then
						lastBan = ban
						if lastBanTimer and isTimer(lastBanTimer) then
							killTimer(lastBanTimer)
							lastBanTimer = nil
						end
						banCache[lastBan.id] = nil
						banAffectedIP[lastBan.ip] = nil
						banAffectedSerial[lastBan.serial] = nil
						banAffectedAccount[lastBan.account] = nil
						collectgarbage("collect")
						lastBanTimer = setTimer(function()
							lastBan = nil
						end, 1000*60*5,1)
						if dbExec(mysql:getConnection(), "DELETE FROM bans WHERE id='"..id.."'") then
							for _, banElement in ipairs(getBans()) do
								if getBanSerial(banElement) == ban['serial'] or getBanIP(banElement) == ban['ip'] then
									removeBan_(banElement)
									break
								end
							end
							if ban['account'] ~= nil then
								exports['vrp_admins']:addAdminHistory(ban['account'], thePlayer, "UNBAN", 2 , 0)
							end
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							exports.vrp_global:sendMessageToAdmins("[UNBAN] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has removed ban record #"..ban['id']..". /showban for details.")
						end
					end
				end
			end
		end
	end
end
addCommandHandler("unban", unbanPlayer, false, false)

function checkAccountBan(userid)
	
	return false
end

function showBanDetails(thePlayer, commandName, clue)
	if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
		if clue then
			clue = (clue)
			local bans = {}
			if tostring(clue) and exports.vrp_global:getCache("accounts", clue, "username", true) then
				clue = exports.vrp_global:getCache("accounts", clue, "username", true).id
			end
			if banAffectedAccount[clue] or banAffectedSerial[clue] or banAffectedIP[clue] then
				printBanInfo(thePlayer, banAffectedAccount[clue] or banAffectedSerial[clue] or banAffectedIP[clue])
			end
		elseif lastBan then
			printBanInfo(thePlayer, lastBan)
		else
			outputChatBox("SYNTAX: /" .. commandName .. " [Serial or IP or Username]", thePlayer, 255, 194, 14)
		end
	end
end
addCommandHandler("showban", showBanDetails, false, false)
addCommandHandler("findban", showBanDetails, false, false)

function printBanInfo(thePlayer, result)
	outputChatBox("===========BAN RECORD #"..result['id'].."============", thePlayer, 255, 194, 14)

	local bannedAccount = exports.vrp_cache:getUsernameFromId(result['account'])
	outputChatBox("Account: "..(bannedAccount and bannedAccount or "N/A"), thePlayer, 255, 194, 14)

	local bannedSerial = nil
	if result['serial'] ~= nil then
		bannedSerial = result['serial']
	end
	outputChatBox("Serial: "..(bannedSerial and bannedSerial or "N/A"), thePlayer, 255, 194, 14)

	local bannedIp = nil
	if result['ip'] ~= nil then
		bannedIp = result['ip']
	end
	outputChatBox("IP: "..(bannedIp and bannedIp or "N/A"), thePlayer, 255, 194, 14)

	local banningAdmin = exports.vrp_cache:getUsernameFromId(result['admin'])
	outputChatBox("Banned by admin: "..(banningAdmin and banningAdmin or "N/A"), thePlayer, 255, 194, 14)

	local bannedDate = nil
	if result['date'] ~= nil then
		bannedDate = result['date']
	end
	outputChatBox("Banned Date: "..(bannedDate and bannedDate or "N/A"), thePlayer, 255, 194, 14)
	local bannedReason = nil
	if result['reason'] ~= nil then
		bannedReason = result['reason']
	end
	outputChatBox("Reason: "..(bannedReason and bannedReason or "N/A"), thePlayer, 255, 194, 14)
end

function addToBan(account, serial, ip, admin, reason)
	local tail = ''
	if serial then
		tail = tail..", serial='"..serial.."'"
	end
	if ip then
		tail = tail..", ip='"..ip.."'"
	end
	if admin and tonumber(admin) then
		tail = tail..", admin='"..admin.."'"
	end
	if reason then
		tail = tail..", reason='"..(reason).."'"
	else
		tail = tail..", reason='"..("N/A").."'"
	end
	if account and tonumber(account) then
		tail = tail..", account='"..account.."'"
	end
	return dbExec(mysql:getConnection(), "INSERT INTO bans SET date=NOW() "..tail)
end

function checkForSerialOrIpBan()
	local playerNick = getPlayerName(source)
	local playerIP = getPlayerIP(source)
	local playerUsername = getPlayerName(source)
	local playerSerial = getPlayerSerial(source)
	
    dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                local result = res[1]
                lastBan = result
                if lastBanTimer and isTimer(lastBanTimer) then
                    killTimer(lastBanTimer)
                    lastBanTimer = nil
                end
                lastBanTimer = setTimer(function()
                    lastBan = nil
                end, 1000*60*5,1)

                local banText = "Sunucumuzdan uzaklaştırıldınız"
                local bannedSerial = false
                local bannedIp = false
                if result['serial'] == playerSerial then
                     banText = "Sunucumuzda yasaklısınız"
					 
                     bannedSerial = playerSerial
                end
                if result['ip'] == playerIP then
                    bannedIp = playerIP
                    banText = "Sunucumuzda IP Adresiniz banli durumda"
                end
                kickPlayer(source, "Sunucudan yasaklısınız.")
                exports.vrp_global:sendMessageToAdmins("[BAN] "..(bannedSerial and (" serial: '"..tostring(bannedSerial).."'") or "" ).." "..(bannedIp and (" IP: '"..tostring(bannedIp).."'") or "").." oyuna girmeye çalıştı, /showban komutuyla detayları öğrenin.")
                return true
            end
        end,
    {source}, mysql:getConnection(), "SELECT * FROM bans WHERE serial='"..playerSerial.."' OR ip='"..playerIP.."' LIMIT 1")
end
addEventHandler("onPlayerJoin", getRootElement(), checkForSerialOrIpBan)

function checkBan(type, indexValue)
	if type == "all" then
		return banCache, banAffectedAccount, banAffectedSerial, banAffectedIP
	else
		if type == "serial" then
			return banAffectedSerial[indexValue]
		elseif type == "ip" then
			return banAffectedIP[indexValue]
		elseif type == "account" then
			return banAffectedAccount[indexValue]
		elseif type == "id" then
			return banCache[indexValue]
		end
	end
end

function removeBan(type, indexValue)
	if type == "serial" then
		banAffectedSerial[indexValue] = nil
	elseif type == "ip" then
		banAffectedIP[indexValue] = nil
	elseif type == "account" then
		banAffectedAccount[indexValue] = nil
	elseif type == "id" then
		banCache[indexValue] = nil
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						banCache[row.id] = {}
						for key, data in pairs(row) do
							banCache[row.id][key] = data
						end
						banAffectedAccount[row.account] = banCache[row.id]
						banAffectedSerial[row.serial] = banCache[row.id]
						banAffectedIP[row.ip] = banCache[row.id]
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `bans`")
	end
)