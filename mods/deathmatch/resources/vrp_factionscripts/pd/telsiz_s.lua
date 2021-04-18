
function yakaTelsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
		if not (...) then
			outputChatBox("KOMUT: /(t)elsiz [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, arrayPlayer, 0, 100, 205, true)
					triggerClientEvent(thePlayer,"telsiz",thePlayer)
					triggerClientEvent(arrayPlayer,"telsiz",arrayPlayer)
				end
			end
		end
		 else
	end
end
addCommandHandler("telsiz", yakaTelsiz, false, false)
addCommandHandler("t", yakaTelsiz, false, false)


function yakaTelsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
		if not (...) then
			outputChatBox("KOMUT: /kyt [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
            	local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(arrayPlayer)
				if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<70) then
						outputChatBox("[YAKA TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, arrayPlayer, 0, 100, 205, true)
						triggerClientEvent(thePlayer,"telsiz",thePlayer)
						triggerClientEvent(arrayPlayer,"telsiz",arrayPlayer)
					end
				end				
			end
		end
		 else
	end
end
addCommandHandler("ykt", yakaTelsiz, false, false)

function panic(thePlayer, commandName)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local username = getPlayerName(thePlayer)
			exports.vrp_global:sendLocalMeAction(thePlayer, "Panik butonuna basar.")
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==1 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " panik butonuna bastı, yönelmeniz bekleniyor.", arrayPlayer, 0,0,0,true)
					triggerClientEvent(thePlayer,"panic",thePlayer)
					triggerClientEvent(arrayPlayer,"panic",arrayPlayer)
				end				
			end
		else
	end
end
addCommandHandler("panik", panic, false, false)

function operator(thePlayer, cmd, ...)
	if not (...) then
		outputChatBox("[!]#ffffff /operator [Mesaj]",thePlayer,100,100,255,true)
	return end

	if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 2 or getElementData(thePlayer, "faction") == 78 then
		local theTeam = getPlayerTeam(thePlayer)
		local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
		local factionRanks = getElementData(theTeam, "ranks")
		local factionRankTitle = factionRanks[factionRank]
		local message = table.concat({...}, " ")
		local username = getPlayerName(thePlayer)
		exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
		for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do  -- Kodun Uygulanacağı Fact Adı
			outputChatBox("[operator] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message.."",pdplayer,100,100,255,true)
		end

		for k, mdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Medical Department"))) do  -- Kodun Uygulanacağı Fact Adı
			outputChatBox("[operator] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message.."",mdplayer,100,100,255,true)
		end

		for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff's Department"))) do  -- Kodun Uygulanacağı Fact Adı
			outputChatBox("[operator] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message.."",lscsdplayer,100,100,255,true)
		end
	end
end
addCommandHandler("operator", operator)