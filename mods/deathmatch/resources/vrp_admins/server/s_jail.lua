
----------------------[JAIL]--------------------
function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("Sunucu: /" .. commandName .. " [Oyuncu Adi/ID] [Minutes(>=1) 5000=Sinirsiz] [Aciklama]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account:id")
				local dbid = getElementData(targetPlayer, "dbid")
				upNew = false
				if isTimer(jailTimer) then
					killTimer(jailTimer)
					local jailTime = getElementData(targetPlayer, "jailtime")
					local jailReason = getElementData(targetPlayer, "jailreason")
					if jailReason then
						reason = jailReason.." ve "..reason
					end
					upNew = true
					minutes= minutes + jailTime
				end
				
				if (isPedInVehicle(targetPlayer)) then
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)
				
				if (minutes>=5000) then
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
					dbExec(mysql:getConnection(), "UPDATE characters SET OOCHapisKontrol='1' WHERE id='" .. (tonumber(dbid)) .. "'")
					minutes = "sinirsiz"
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", true, false)
				else
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
					dbExec(mysql:getConnection(), "UPDATE characters SET OOCHapisKontrol='1' WHERE id='" .. (tonumber(dbid)) .. "'")
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailserved", 0, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", theTimer, false)
				end
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", true, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", reason, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", minutes)
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				addAdminHistory(targetPlayer, thePlayer, reason, 0 , (tonumber(minutes) and ( minutes == 5000 and 0 or minutes ) or 0))
				
				local adminTitle = exports.vrp_global:getAdminTitle1(thePlayer)
				local time = getRealTime()
				local saat = time.hour
				local saniye = time.minute
				--outputChatBox ( "Server Time: "..hours..":"..minutes )
				if (hiddenAdmin==1) then
					adminTitle = "Hidden admin"
				end
				
				if commandName == "sjail" then
					if tonumber(minutes) then
						
						for i, v in ipairs(getElementsByType("player")) do
							if exports.vrp_integration:isPlayerTrialAdmin(v) then
								outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " Sebep: ".. reason .. " - " ..string.format("%02d", saat)..":"..string.format("%02d", saniye).. " ))", v, 255, 0, 0)
							end
						end
						
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." for "..minutes.." mins, reason: "..reason)
					else
						exports.vrp_global:sendMessageToAdmins("[HAPIS]: " .. adminTitle .. " hapise atti " .. targetPlayerName .. " isimli oyuncuyu "..minutes.." dakika.")
						exports.vrp_global:sendMessageToAdmins("[HAPIS] Aciklama: " .. reason)
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." "..minutes..", reason: "..reason)
					end
				else
					if tonumber(minutes) then
						outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " Sebep: ".. reason .. " - " ..string.format("%02d", saat)..":"..string.format("%02d", saniye).. " ))", root, 255, 0, 0)
						--outputChatBox("[HAPIS] Aciklama: " .. reason, root, 255, 0, 0)
						if upNew then
							outputChatBox("(( " .. targetPlayerName .. " oyuncunun son aldığı ceza ile varolan cezası birleştirildi. ))", root, 255, 0, 0)					
						end
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." for "..minutes.." mins, reason: "..reason)
					else
						outputChatBox("[HAPIS]: " .. adminTitle .. " adlı yetkili " .. targetPlayerName .. " adlı oyuncuyu "..minutes.." dakika hapise attı.", root, 255, 0, 0)
						outputChatBox("[HAPIS] Açıklama: " .. reason, root, 255, 0, 0)
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." "..minutes..", reason: "..reason)
					end
				end
				
				
				setElementDimension(targetPlayer, 65400+getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				setElementData(targetPlayer, "adminAttigiJail", 1)
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminAttigiJail='1' WHERE id = '" .. escapedID .. "'")
				setElementData(targetPlayer, "OOCHapisKontrol", getElementData(targetPlayer, "OOCHapisKontrol") + 1)
				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)
				
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)
addCommandHandler("sjail", jailPlayer, false, false)

function addJail(who, minutes, reason, admin, adminID)
	--Found Element:
	minutes, who = tonumber(minutes), tostring(who)
	target = nil
	accountUsername, accountID = "[Veri Eşleşmedi]", -1
	--Async:foreach(onlinePlayers, function(player)
	for index, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
		if who == getElementData(value, "account:username") then
			target = value
		end
	end
	local playerName = getPlayerName(thePlayer)
	
    if target == nil then--isElement(target) then
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        accountID = row["id"] 
                        accountUsername = row["username"]

                        if (minutes>=5000) then
                            dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (admin) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
                            minutes = 9999999
                        else
                            dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (admin) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
                        end
                        
                        addAdminHistory(target, adminID, reason, 0)
                        outputChatBox("[HAPIS]: " .. admin .. " adlı yetkili " .. accountUsername .. " kullanıcı adlı oyuncuyu " .. minutes .. " dakika hapise attı.", root, 255, 0, 0)
                        outputChatBox("[HAPIS] Açıklama: " .. reason.. " (( Oyuncu Şikayetleri ))", root, 255, 0, 0)
                        
                        exports.vrp_logs:dbLog(thePlayer, 4, thePlayer, "FORUM JAIL "..accountUsername.." for "..minutes.." mins, reason: "..reason)
                    end
                else
                    return
                end
            end,
        mysql:getConnection(), "SELECT `id`, `username`, `mtaserial`, `admin` FROM `accounts` WHERE `username`='".. ( who ) .."'")
        return
	else
		accountID = getElementData(target, "account:id")
		accountUsername = getElementData(target, "account:username")
		setElementDimension(target, 65400+getElementData(target, "playerid"))
		setElementInterior(target, 6)
		setCameraInterior(target, 6)
		setElementPosition(target, 263.821807, 77.848365, 1001.0390625)
		setPedRotation(target, 267.438446)
		setElementData(target, "adminAttigiJail", 1)
		local dbid = getElementData(target, "account:id")
		local escapedID = (dbid)
		dbExec(mysql:getConnection(), "UPDATE accounts SET adminAttigiJail='1' WHERE id = '" .. escapedID .. "'")
		setElementData(target, "OOCHapisKontrol", getElementData(target, "OOCHapisKontrol") + 1)
		toggleControl(target,'next_weapon',false)
		toggleControl(target,'previous_weapon',false)
		toggleControl(target,'fire',false)
		toggleControl(target,'aim_weapon',false)
		setPedWeaponSlot(target,0)
		local theTimer = setTimer(timerUnjailPlayer, 60000, 1, target)
		if (minutes>=5000) then
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailserved", 0, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailtimer", true, false)
		else
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailtimer", theTimer, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "adminjailed", true, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailreason", reason, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailtime", minutes, false)
			exports.vrp_anticheat:changeProtectedElementDataEx(target, "jailadmin", admin, false)
		end
	end

	if (minutes>=5000) then
		dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (admin) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
		minutes = 9999999
	else
		dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (admin) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
	end
	
	addAdminHistory(target, adminID, reason, 0)
	outputChatBox("[HAPIS]: " .. admin .. " adlı yetkili " .. accountUsername .. " kullanıcı adlı oyuncuyu " .. minutes .. " dakika hapise attı.", root, 255, 0, 0)
	outputChatBox("[HAPIS] Açıklama: " .. reason.. " (( Oyuncu Şikayetleri ))", root, 255, 0, 0)
	
	exports.vrp_logs:dbLog(thePlayer, 4, thePlayer, "FORUM JAIL "..accountUsername.." for "..minutes.." mins, reason: "..reason)
end

function offlineJailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("Sunucu: /" .. commandName .. " [Exact Username] [Minutes(>=1) 999=Perm] [Reason]", thePlayer, 255, 194, 14)
		else
			-- If player is still online
			local reason = table.concat({...}, " ")
			local onlinePlayers = getElementsByType("player")
			--Async:foreach(onlinePlayers, function(player)
			for _, player in ipairs(onlinePlayers) do
				if who:lower() == tostring(getElementData(player, "account:username")):lower() then
					local commandNameTemp = "jail"
					if commandName:lower() == "sojail" then
						commandNameTemp = "sjail"
					end
					jailPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), minutes, reason)
					return true
				end
			--end
			end
            -- if player is acutally offline.
            dbQuery(
                function(qh)
                    local res, rows, err = dbPoll(qh, 0)
                    if rows > 0 then
                        for index, row in ipairs(res) do
                            accountID = row["id"] 
                            accountUsername = row["username"]
                            offline_minutes = row["adminjail_time"]

                            local playerName = getPlayerName(thePlayer)
                            if not offline_minutes then offline_minutes = 0 end
                            offline_minutes = offline_minutes + minutes
                            if (minutes>=5000) then
                                dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
                                minutes = 9999999
                            else
                                dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
                            end
                            
                            local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
                            --local res = dbExec(mysql:getConnection(), "INSERT INTO adminhistory (user_char, admin, hiddenadmin, action, duration, reason) VALUES ('N/A','"..accountID.."', '"..(tostring(getElementData(thePlayer, "account:id") or 0)).."','"..(hiddenAdmin).."', '0', '"..(( minutes == 999 and 0 or minutes )).."', '"..(reason).."')")
                            local res = dbExec(mysql:getConnection(), "INSERT INTO adminhistory SET admin="..(getElementData(thePlayer, "account:id") or 0)..", user="..accountID..", user_char='N/A', action=6, duration="..minutes..", reason='"..(reason).."' ")
                
                            local adminTitle = exports.vrp_global:getAdminTitle1(thePlayer)
                            if (hiddenAdmin==1) then
                                adminTitle = "Hidden admin"
                            end
                            
                            if commandName == "sojail" then
                                exports.vrp_global:sendMessageToAdmins("[HAPIS]: " .. adminTitle .. " hapise atti " .. accountUsername .. " kullanici adli oyuncuyu " .. minutes .. " dakika.")
                                exports.vrp_global:sendMessageToAdmins("[HAPIS] Aciklama: " .. reason)
                            else
                                outputChatBox("[HAPIS]: " .. adminTitle .. " hapise atti " .. accountUsername .. " kullanici adli oyuncuyu " .. minutes .. " dakika.", root, 255, 0, 0)
                                outputChatBox("[HAPIS] Aciklama: " .. reason, root, 255, 0, 0)
                            end
                            exports.vrp_logs:dbLog(thePlayer, 4, thePlayer,commandName.." "..accountUsername.." for "..minutes.." mins, reason: "..reason)
                        end
                    else
                        outputChatBox("Username not found!", thePlayer, 255, 0, 0)
				return false
                    end
                end,
            mysql:getConnection(), "SELECT `id`, `username`, `mtaserial`, `admin`, `adminjail_time` FROM `accounts` WHERE `username`='".. ( who ) .."'")
		end
	end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account:id")
		if (timeServed) then
			exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailserved", timeServed+1, false)
			local timeLeft = timeLeft - 1
			exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", timeLeft, false)
		
			if (timeLeft<=0) and not (getElementData(jailedPlayer, "pd.jailtime")) then
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. (accountID) .. "'")
				exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtimer", false, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "adminjailed", false, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailreason", false, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", false, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailadmin", false, false)
				setElementPosition(jailedPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
				setPedRotation(jailedPlayer, 303)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				setElementData(jailedPlayer, "adminAttigiJail", 0)
				local dbid = getElementData(jailedPlayer, "account:id")
				local escapedID = (dbid)
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminAttigiJail='0' WHERE id = '" .. escapedID .. "'")
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				outputChatBox("#575757Valhalla: #ffffffHapis süreniz bitti ve hapisten başarıyla çıktınız.", jailedPlayer, 0, 255, 0, true)
				local gender = getElementData(jailedPlayer, "gender")
				local genderm = "his"
				if (gender == 1) then
					genderm = "her"
				end
				exports.vrp_global:sendMessageToAdmins("[JAIL]: " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " has served " .. genderm .. " jail time.")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, nil)
			else
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='" .. (timeLeft) .. "' WHERE id='" .. (accountID) .. "'")
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer, false)
				local jailCounter = {}
				jailCounter.minutesleft = timeLeft
				jailCounter.reason = getElementData(jailedPlayer, "jailreason")
				jailCounter.admin = getElementData(jailedPlayer, "jailadmin")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, jailCounter)
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", getRootElement(), timerUnjailPlayer)
function onStartResource()
	for index, player in ipairs(getElementsByType("player")) do
		if getElementData(player, "loggedin") == 1 then
			jailed = getElementData(player, "jailtimer")
			if jailed then
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, player)
				setElementData(player, "jailtimer", theTimer, false)
			end		
		end
	end
end
addEventHandler("onResourceStart", getResourceRootElement(), onStartResource)

function unjailPlayer(thePlayer, commandName, who)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("Sunucu: /" .. commandName .. " [Player Partial Name/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer")
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				if not (jailed) then
					outputChatBox(targetPlayerName .. " isimli oyuncu hapiste degil.", thePlayer, 255, 0, 0)
				else
					local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. (accountID) .. "'")

					if isTimer(jailed) then
						killTimer(jailed)
					end
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", false, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", false, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", false, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", false, false)
					exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", false, false)
					setElementPosition(targetPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
					setPedRotation(targetPlayer, 303)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					setElementData(targetPlayer, "adminAttigiJail", 0)
					local dbid = getElementData(targetPlayer, "account:id")
					local escapedID = (dbid)
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminAttigiJail='0' WHERE id = '" .. escapedID .. "'")
					toggleControl(targetPlayer,'next_weapon',true)
					toggleControl(targetPlayer,'previous_weapon',true)
					toggleControl(targetPlayer,'fire',true)
					toggleControl(targetPlayer,'aim_weapon',true)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					local adminTitle = exports.vrp_global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "Hidden admin"
					end
			
					outputChatBox("#575757Valhalla: #ffffff"..getElementData(thePlayer, "account:username").." isimli yetkili sizi hapisten başarıyla çıkarttı.", targetPlayer, 0, 125, 255, true)
					exports.vrp_global:sendMessageToAdmins("[HAPIS]: " .. getElementData(targetPlayer, "account:username") .. " isimli oyuncu "..adminTitle.." isimli yetkili tarafindan cikartildi.")
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayerName,commandName)
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("----- Jailed -----", thePlayer, 255, 194, 15)
		local players = exports.vrp_pool:getPoolElementsByType("player")
		local count = 0
		for key, value in ipairs(players) do
			if getElementData(value, "adminjailed") then
				if tonumber(getElementData(value, "jailtime")) then
					outputChatBox("#8b30d8============================================", thePlayer, 0, 0, 0, true)
					outputChatBox("#ff0000[HAPIS] #359dce" .. getPlayerName(value) .. "#ffffff hapiste, hapise atan yetkili #359dce" .. tostring(getElementData(value, "jailadmin")) .. "#ffffff ||  " .. tostring(getElementData(value, "jailserved")) .. " #ffffffdakikadir iceride, "..tostring(getElementData(value,"jailtime")).." #ffffffdakikasi kaldi", thePlayer, 255, 194, 15, true)
					outputChatBox("#ff0000[HAPIS] #ecb530Aciklama:#ffffff " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15, true)
				else
					outputChatBox("#ff0000[HAPIS] #359dce" .. getPlayerName(value) .. "#ffffff, hapiste, hapise atan yetkili #359dce" .. tostring(getElementData(value, "jailadmin")) .. "#ffffff, sınırsız,", thePlayer, 255, 194, 15, true)
					outputChatBox("#ff0000[HAPIS] #ecb530Aciklama:#ffffff " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15, true)
				end
				count = count + 1
			elseif getElementData(value, "jailed") then
				outputChatBox("[IC Hapis] ".. getPlayerName(value).. " || Cell:"..getElementData(value, "jail:cell").." || Prisoner ID:".. tostring(getElementData(value, "jail:id")) .." || Use /arrest for more info.", thePlayer, 0, 102, 255, true)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("Hapis'te kimse yok.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)