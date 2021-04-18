
function yakaTelsiz(thePlayer, commandName, ...)
        local logged = getElementData(thePlayer, "loggedin")
        if (logged==1) and getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
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
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Medical Department"))) do  -- Kodun Uygulanacağı Fact Adı
				if getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
					outputChatBox("[TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, arrayPlayer, 213, 88, 88, true)
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
        if (logged==1) and getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
		if not (...) then
			outputChatBox("KOMUT: /ykt [Mesaj]", thePlayer, 255, 194, 14)
		else
			local theTeam = getPlayerTeam(thePlayer)
			local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
			local factionRanks = getElementData(theTeam, "ranks")
			local factionRankTitle = factionRanks[factionRank]
			local message = table.concat({...}, " ")
			local username = getPlayerName(thePlayer)
			exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak konuşmaya başlar.")
            for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Medical Department"))) do  -- Kodun Uygulanacağı Fact Adı
            	local x, y, z = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(arrayPlayer)
				if getElementData(thePlayer, "faction")==2 then -- Kodun Uygulanacağı Fact ID'ı
					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)<70) then
						outputChatBox("[YAKA TELSIZ] ".. factionRankTitle .. " " .. username:gsub("_", " ") .. " : " .. message, arrayPlayer, 213, 88, 88, true)
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