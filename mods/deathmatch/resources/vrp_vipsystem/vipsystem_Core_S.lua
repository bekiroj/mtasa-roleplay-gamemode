--[[
* ***********************************************************************************************************************
* Copyright (c) 2017 Inception Roleplay - All Rights Reserved
* Written by Furkan Ozulus aka OzulusTR <furkanozulus@gmail.com>, 14.07.2017
* ***********************************************************************************************************************
]]

local mysql = exports.vrp_mysql
vipPlayers = {}

addEventHandler("onResourceStart", resourceRoot, function()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					loadVIP(row.char_id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `char_id` FROM `vipPlayers`")
end)

addEventHandler("onResourceStop", resourceRoot, function()
	for _, player in pairs(getElementsByType("player")) do
		local charID = tonumber(getElementData(player, "dbid"))
		if charID then
			saveVIP(charID)
		end
	end
end)

addEventHandler("onPlayerQuit", root, function()
	local charID = getElementData(source, "dbid")
	if not charID then return false end
	saveVIP(charID)
end)

function loadVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					local vipType = tonumber(row["vip_type"]) or 0
					local endTick = tonumber(row["vip_end_tick"]) or 0
					if vipType > 0 then
						vipPlayers[charID] = {}
						vipPlayers[charID].type = vipType
						vipPlayers[charID].endTick = endTick
						local targetPlayer = exports.vrp_global:getPlayerFromCharacterID(charID)
						if targetPlayer then
							setElementData(targetPlayer, "vip", vipType)
						end
					end
				end
			end
		end,
	mysql:getConnection(), "SELECT `vip_type`, `vip_end_tick` FROM `vipPlayers` WHERE char_id='"..charID.."'")
end

function saveVIP(charID)
	local charID = tonumber(charID)
	if not charID then return false end
	if not vipPlayers[charID] then return false end
	
	--outputDebugString("saved vip endTick: "..vipPlayers[charID].endTick.." ")
	local success = dbExec(mysql:getConnection(), "UPDATE `vipPlayers` SET vip_end_tick='"..(vipPlayers[charID].endTick).."' WHERE char_id="..charID.." LIMIT 1")
	if not success then
		--outputDebugString("@vipsystem_Core_S: mysql hatası. 79.satır")
		return
	end
end

function removeVIP(charID)
	if not vipPlayers[charID] then return false end	
	local query = dbExec(mysql:getConnection(), "DELETE FROM `vipPlayers` WHERE char_id="..charID.." LIMIT 1")
	if query then
		local targetPlayer = exports.vrp_global:getPlayerFromCharacterID(charID)
		if targetPlayer then
			setElementData(targetPlayer, "vip", 0)
			outputChatBox("[!] #ffffffVIP süreniz doldu.", targetPlayer, 0, 125, 255, true)
		end
		vipPlayers[charID] = nil
		return true
	end
	return false
end

function checkExpireTime()
	for charID, data in pairs(vipPlayers) do
		if (charID and data) then
			if vipPlayers[charID] then
				if vipPlayers[charID].endTick and vipPlayers[charID].endTick <= 0 then

					local success = removeVIP(charID)
					if success then
						--outputDebugString("Remove vip: "..charID.." from database [VIP TIME EXPIRED]")
					end

				elseif vipPlayers[charID].endTick and vipPlayers[charID].endTick > 0 then

					vipPlayers[charID].endTick = math.max(vipPlayers[charID].endTick - (60 * 1000), 0)
					--outputDebugString("Update vip: "..charID.." to "..vipPlayers[charID].endTick.." [1 MINUTE PASSED] ")
					saveVIP(charID)
					
					if vipPlayers[charID].endTick == 0 then
						local success = removeVIP(charID)
						if success then
							--outputDebugString("Remove vip: "..charID.." from database [VIP TIME EXPIRED]")
						end
					end

				end
			end
		end
	end
end
setTimer(checkExpireTime, 60 * 1000, 0)




function pmKapatOzelligi(thePlayer, cmd)
local charID = getElementData(thePlayer, "dbid")

	if getElementData(thePlayer, "vip") == 0 and getElementData(thePlayer, "PMDurumuVIP") == 1 and getElementData(thePlayer, "admin_level") == 0 and getElementData(thePlayer, "supporter_level") == 0 and getElementData(thePlayer, "youtuberEtiketi") == 0 then
		setElementData(thePlayer, "PMDurumuVIP", 0)
		outputChatBox("[!] #ffffffÖzel mesajlarınızı başarıyla aktif ettiniz.", thePlayer, 0, 255, 0, true)
		dbExec(mysql:getConnection(), "UPDATE characters SET PMDurumuVIP='0' WHERE id = '" .. charID .. "'")
	end
	
	if getElementData(thePlayer, "vip") > 0 or exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) or getElementData(thePlayer, "youtuberEtiketi") == 1 then
		if getElementData(thePlayer, "PMDurumuVIP") == 0 then
			setElementData(thePlayer, "PMDurumuVIP", 1)
			outputChatBox("[!] #ffffffÖzel mesajlarınızı başarıyla kapattınız.", thePlayer, 0, 255, 0, true)
			dbExec(mysql:getConnection(), "UPDATE characters SET PMDurumuVIP='1' WHERE id = '" .. charID .. "'")
		elseif getElementData(thePlayer, "PMDurumuVIP") == 1 then
			setElementData(thePlayer, "PMDurumuVIP", 0)
			outputChatBox("[!] #ffffffÖzel mesajlarınızı başarıyla aktif ettiniz.", thePlayer, 0, 255, 0, true)
			dbExec(mysql:getConnection(), "UPDATE characters SET PMDurumuVIP='0' WHERE id = '" .. charID .. "'")
		end
	else
		outputChatBox("[!] #ffffffBu komudu kullanabilmek için VIP veya Admin olmalısınız.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("pmkapat", pmKapatOzelligi)