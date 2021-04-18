local mysql = exports.vrp_mysql

addCommandHandler("vipver", function(thePlayer, cmdName, idOrNick, vipRank, days)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if (not idOrNick or not tonumber(vipRank) or not tonumber(days) or (tonumber(vipRank) < 0 or tonumber(vipRank) > 4)) then
			outputChatBox("[!] #ffffffKullanım: /"..cmdName.." <oyuncu id> <vip rank (1-2-3-4)> <gün>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
				end
				
				local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
				if not isPlayerVIP(charID) then
					local id = SmallestID()
					
					local success = dbExec(mysql:getConnection(),"INSERT INTO `vipPlayers` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..(vipRank).."', '"..(endTick).."')") or false
					if not success then
						return outputDebugString("@vipsystem_Commands_S: mysql hatası. 26.satır")
					end
				
					outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla "..days.." günlük VIP verdiniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size "..days.." günlük VIP ["..vipRank.."] verdi.", targetPlayer, 0, 255, 0, true)
				
					--exports.vrp_global:updateNametagColor(targetPlayer)
					loadVIP(charID)
				else
					local success = dbExec(mysql:getConnection(),"UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
					if not success then
						return outputDebugString("@vipsystem_Core_S: mysql hatası. 37.satır")
					end
					
					outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun VIP süresine "..days.." gün eklediniz.", thePlayer, 0, 255, 0, true)
					outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili VIP ["..vipRank.."] sürenizi "..days.." gün uzattı.", targetPlayer, 0, 255, 0, true)
					
					loadVIP(charID)
				end
			else
				outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end)
addCommandHandler("worldvipdagit", function(thePlayer, cmdName)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		--for i, player in ipairs(getElementsByType("player")) do
		Async:foreach(getElementsByType("player"), function(player)
			if getElementData(player, "loggedin") == 1 and (tonumber(getElementData(player, "vipver")) or 0) <= 2 then
				local charID = tonumber(getElementData(player, "dbid"))
				if not isPlayerVIP(charID) then
					addVIP(player, 2, 3) -- 3 gün VIP VER
					outputChatBox("[!]#ffffff Tebrikler, etkinlik tarafından 3 günlük VIP [2] kazandınız.", player, 0, 255, 0, true)
				elseif isPlayerVIP(charID) and tonumber(getElementData(player, "vipver")) == 2 then
					addVIP(player, 2, 3) -- 3 gün ekle
					outputChatBox("[!]#ffffff Etkinlik dolayısıyla VIP 2 kazandınız, sürenize 3 gün eklendi.", player, 0, 255, 0, true)
				elseif tonumber(getElementData(player, "vipver")) == 1 then
					local remaining = vipPlayers[charID].endTick/1000
					local vipDays = math.floor ( remaining /86400 )
			
					if tonumber(vipDays) <= 5 then
						removeVIP(charID)
						addVIP(player, 2, 3)
						outputChatBox("[!]#ffffff VIP 1'iniz 5 günden az olduğu için silindi ve 3 günlük VIP 2 kazandınız.", player, 0, 255, 0, true)
					end
				end
			end
		end)
		outputChatBox("[!]#ffffff Tüm oyunculara 3 günlük VIP 2 verildi.", thePlayer, 0, 255, 0, true)
	end
end)

addCommandHandler("vipal", function(thePlayer, cmdName, idOrNick)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if (not idOrNick) then
			outputChatBox("[!] #ffffffKullanım: /"..cmdName.." <oyuncu id/isim>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, idOrNick)
			if targetPlayer then
				local charID = tonumber(getElementData(targetPlayer, "dbid"))
				if not charID then
					return outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
				end
				
				if isPlayerVIP(charID) then
					local success = removeVIP(charID)
					if success then
						outputChatBox("[!] #ffffff"..targetPlayerName.." adlı oyuncunun VIP üyeliğini aldınız.", thePlayer, 0, 255, 0, true)
					end
				else
					outputChatBox("[!] #ffffffOyuncunun VIP üyeliği yok.", thePlayer, 255, 0, 0, true)
				end
			else
				outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end)

addCommandHandler("vipsure", function(thePlayer, cmd, id)
	if id then
	local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, id)
	local id = getElementData(targetPlayer, "dbid")
		if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
			if vipPlayers[id] then
				local vipType = vipPlayers[id].type
				local remaining = vipPlayers[id].endTick
				local remainingInfo = secondsToTimeDesc(remaining/1000)
	
				return outputChatBox("[!] #ffffff"..getPlayerName(targetPlayer).." idli karakterin kalan VIP ["..vipType.."]  süresi: "..remainingInfo, thePlayer, 0, 125, 255, true)
			end
			return outputChatBox("[!] #ffffff"..getPlayerName(targetPlayer).." idli karakterin VIP üyeliği bulunmamaktadır.", thePlayer, 255, 0, 0, true)
		end
	end

	local charID = getElementData(thePlayer, "dbid")
	if not charID then return false end

	if vipPlayers[charID] then
		local vipType = vipPlayers[charID].type
		local remaining = vipPlayers[charID].endTick
		local remainingInfo = secondsToTimeDesc(remaining/1000)

		outputChatBox("[!] #ffffffKalan VIP ["..vipType.."] süreniz: "..remainingInfo, thePlayer, 0, 125, 255, true)
	else
		outputChatBox("[!] #ffffffVIP üyeliğiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end)

function addVIP(targetPlayer, vipRank, days)
	if targetPlayer and vipRank and days then
		local charID = tonumber(getElementData(targetPlayer, "dbid"))
		if not charID then
			return false--outputChatBox("[!] #ffffffOyuncu bulunamadı.", thePlayer, 255, 0, 0, true)
		end
		
		local endTick = math.max(days, 1) * 24 * 60 * 60 * 1000
		if not isPlayerVIP(charID) then
			local id = SmallestID()
			local success = dbExec(mysql:getConnection(), "INSERT INTO `vipPlayers` (`id`, `char_id`, `vip_type`, `vip_end_tick`) VALUES ('"..id.."', '"..charID.."', '"..(vipRank).."', '"..(endTick).."')") or false
			if not success then
				return outputDebugString("@vipsystem_Commands_S addVIP: mysql hatası. 26.satır")
			end
			loadVIP(charID)
		else
		
			local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick= vip_end_tick + "..endTick.." WHERE char_id="..charID.." and vip_type="..vipRank.." LIMIT 1")
			if not success then
				return outputDebugString("@vipsystem_Core_S: mysql hatası. 52.satır")
			end
			
			loadVIP(charID)
		end
	end
end

addCommandHandler("pmkapat", function(p)
	if getElementData(p, "vip") >= 1 then
		if not getElementData(p, "pm:off") then
			outputChatBox("[!]#ffffff PM Kapattınız.",p,0,255,0,true)
			setElementData(p, "pm:off", true)
		else
			outputChatBox("[!]#ffffff PM Açtınız.",p,0,255,0,true)
			setElementData(p, "pm:off", nil)
		end
	end	
end)