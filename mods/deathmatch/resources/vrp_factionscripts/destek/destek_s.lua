-- //bekiroj

function destek(thePlayer, cmd, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
			
			if not getElementData(thePlayer, "destekacik") then
				if not tonumber((...)) then
					outputChatBox("İşlem: /destek [Tür]", thePlayer, 255, 194, 14)
				return end
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak destek istediğini belirtir.")
				setElementData(thePlayer, "destekacik", true)
				setElementData(thePlayer, "destek_tur", tonumber(tur))
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " destek istediğini belirtti, yönelmeniz bekleniyor. ("..tur..")", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff's Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " destek istediğini belirtti, yönelmeniz bekleniyor. ("..tur..")", lscsdplayer, 0,0,0,true)
				end
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				setElementData(thePlayer, "destekacik", false)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " destek çağrısını kaldırdı.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff's Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " destek çağrısını kaldırdı.", lscsdplayer, 0,0,0,true)
				end
			end
		end
	end
end
addCommandHandler("destek", destek)

function takip(thePlayer, cmd)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
			
			if not getElementData(thePlayer, "takipacik") then
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				exports.vrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak destek istediğini belirtir.")

				setElementData(thePlayer, "takipacik", true)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " takip ettiğini belirtti.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff's Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " takip ettiğini belirtti.", lscsdplayer, 0,0,0,true)
				end
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				setElementData(thePlayer, "takipacik", false)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Police Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " takipten ayrıldığını belirtti.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos County Sheriff's Department"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 911) " .. username:gsub("_", " ") .. " takipten ayrıldığını belirtti.", lscsdplayer, 0,0,0,true)
				end
			end
		end
	end
end
addCommandHandler("takip", takip)