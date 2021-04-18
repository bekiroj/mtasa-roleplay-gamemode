mysql = exports.vrp_mysql


function givePlayerJob(thePlayer, commandName, targetPlayer, jobID, jobLevel, jobProgress)
	jobID = tonumber(jobID)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		local jobTitle = getJobTitleFromID(jobID)
		if not (targetPlayer) then
			printSetJobSyntax(thePlayer, commandName)
			return
		else
			
			if jobTitle == "Unemployed" then
				jobID = 0
			end
			
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				
				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				else
					if (jobID==4) then -- CITY MAINTENANCE
						exports.vrp_global:giveItem(targetPlayer, 115, "41:1:Spraycan", 2500)
						outputChatBox("Use this spray to paint over the graffiti you find.", targetPlayer, 255, 194, 14)
						exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "tag", 9, true)
						dbExec(mysql:getConnection(), "UPDATE characters SET tag=9 WHERE id = " .. (getElementData(targetPlayer, "dbid")) )
					end
					
					dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='" .. (jobID) .. "' WHERE `id`='"..tostring(getElementData(targetPlayer, "dbid")).."' " )
					
					
					
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
					if hiddenAdmin == 0 then
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". ", targetPlayer, 0, 255,0)
					else
						outputChatBox("Your job has been set to '" .. jobTitle .. "' by a hidden admin. ", targetPlayer, 0, 255,0)
					end
					outputChatBox("You have set " .. targetPlayerName .. "'s job to '"..jobTitle.."'.", thePlayer)
				end
			end
		end
	end
end
addCommandHandler("setjob", givePlayerJob, false, false)

function printSetJobSyntax(thePlayer, commandName)
	outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Job ID, 0 = Unemployed]", thePlayer, 255, 194, 14)
	outputChatBox("ID#1: Delivery Driver", thePlayer)
	outputChatBox("ID#2: Taxi Driver", thePlayer)
	outputChatBox("ID#3: Bus Driver", thePlayer)
	outputChatBox("ID#4: City Maintenance", thePlayer)
	outputChatBox("ID#5: Mechanic", thePlayer)
	outputChatBox("ID#6: Locksmith", thePlayer)
	outputChatBox("ID#7: Long Haul Truck Driver", thePlayer)
end

function setjobLevel(thePlayer, commandName, target, level, progress )
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		if not target or not tonumber(level) or (tonumber(level) < 1) then
			outputChatBox( "SYNTAX: /" .. commandName .. " [player ID or Name] [Level] [Progress, optional]", thePlayer, 255, 194, 14 )
			return false
		end
		
		if not tonumber(progress) or (tonumber(progress) < 0) then
			progress = 0
		end
		
		level = math.floor(tonumber(level))
		local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
			
		if not targetPlayer then
			outputChatBox("Player '"..target.."' not found.", thePlayer, 255,0,0)
			return false
		end
		
		jobID = getElementData(targetPlayer, "job")
		
		if jobID <=0 then
			outputChatBox("Player is currently unemployed, please use /setjob first.", thePlayer, 255,0,0)
			return false
		end
		
		local sucess, msg = setPlayerJobLevel(targetPlayer, jobID, level, progress)
		if (getPlayerName(thePlayer) ~= getPlayerName(targetPlayer)) then
			outputChatBox(msg, thePlayer, 255, 194, 14)
			outputChatBox(msg, targetPlayer, 255, 194, 14)
		else
			outputChatBox(msg, targetPlayer, 255, 194, 14)
		end
		
		if sucess then
			return true
		else
			return false
		end
	else
		outputChatBox("Only Super Admin and above can access /"..commandName..".", thePlayer, 255,0,0)
	end
end
addCommandHandler("setjoblevel", setjobLevel, false, false)

function setPlayerJobLevel(targetPlayer, jobID, level, progress)
	if dbExec(mysql:getConnection(), "UPDATE `jobs` SET `jobLevel`='"..level.."', `jobProgress`='"..progress.."' WHERE `jobCharID`='"..getElementData(targetPlayer, "dbid").."' AND `jobID`='"..jobID.."' " ) then
		
		return true, getPlayerName(targetPlayer):gsub("_", " ").." now has '"..getJobTitleFromID(jobID).."' job (Level: "..level..", Progress: "..progress..")"
	else
		return false, "Database Error, please report to Maxime"
	end
end

function delJob( thePlayer, commandName, targetPlayerName )
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		if targetPlayerName then
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if targetPlayer then
				if getElementData( targetPlayer, "loggedin" ) == 1 then
					local result = dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='0' WHERE `id`='"..tostring(getElementData(targetPlayer, "dbid")).."' " )
					
					
					if result then
						outputChatBox( "Deleted job for " .. targetPlayerName..".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
							outputChatBox("Your job has been deleted by "..tostring(adminTitle) .. " " .. getPlayerName(thePlayer)..". Please relog (F10) to get it affected.", targetPlayer, 0, 255,0)
						else
							outputChatBox("Your job has been deleted by a hidden admin.", targetPlayer, 0, 255,0)
						end
					else
						outputChatBox( "Failed to delete job.", thePlayer, 255, 0, 0 )
					end
				else
					outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
				end
			end
		else
			outputChatBox( "SYNTAX: /" .. commandName .. " [player]", thePlayer, 255, 194, 14 )
		end
	end
end
addCommandHandler("deljob", delJob, false, false)

function adminRespawnAllTrucks(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("Respawned " .. tostring(respawnAllTrucks()) .. " Trucks.", thePlayer)
	else
		outputChatBox("Only Admin and above can access /"..commandName..".", thePlayer, 255,0,0)
	end
end
addCommandHandler("respawntrucks", adminRespawnAllTrucks, false, false)

function scripterSkipRoute(thePlayer, commandName, target)
	if not exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("Only Super Admin and above can access /"..commandName..".", thePlayer, 255,0,0)
		return false
	end
	if not target then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player/ID]", thePlayer, 255, 194, 14)
		return
	end
	local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
	if targetPlayer then
		spawnRoute(targetPlayer, true)
	end
end
addCommandHandler("skiproute", scripterSkipRoute, false, false)

addEventHandler("onResourceStart", resourceRoot,
	function()
		for index, value in pairs(Jobs) do
			if value[3] ~= false then
				local x, y, z = unpack(value[2])
				local pickup = createPickup(x, y, z, 3, 1239)
				local marker = createMarker(x, y, z-1, "cylinder", 1.5, 255, 255, 255, 0)
				marker:setData("jobID", index)
				pickup:setData("informationicon:information", "#7f8fa6/meslek#ffffff\n"..value[1])
			end
		end
	end
)

addEventHandler("onVehicleStartEnter", root,
	function(player)
		local job = source:getData("job")
		if job and job > 0 and player:getData("duty_admin") == 0 then
			player_job = player:getData("job")
			player_work = player:getData("worked")
			if player_job ~= job then
				outputChatBox("(( İçinde yer almadığın mesleğin aracına binemezsin. ))", player, 255, 0, 0)
				cancelEvent()
			elseif player_job == job and not player_work then
				outputChatBox("(( İşbaşı yapmadan araca binemezsin. ))", player, 255, 0, 0)
				cancelEvent()
			end
		end
	end
)

addCommandHandler("meslek",
	function(player, cmd, verb)
		if player:getData("loggedin") == 1 then
			if not verb then
				outputChatBox("Komut Dizini: bul, isbasi, gir, cik", player, 225, 225, 225, true)
				return
			end
			if (verb == "bul") then
				triggerClientEvent(player, "push.showJob", player)
			elseif (verb == "cik") then
				outputChatBox("Bulunduğunuz meslekten başarıyla ayrıldınız.", player, 225, 225, 225, true)
				dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='0' WHERE `id`='"..tostring(getElementData(player, "dbid")).."' " )
				player:setData("job", 0)
				player:setData("worked", false)
			elseif (verb == "gir") then
				local canUseThisCmd = false
				local jobID = -1
				for _, marker in pairs(getElementsByType("marker", resourceRoot)) do
					if isElement(marker) then
						if isElementWithinMarker(player, marker) then
							jobID = getElementData(marker, "jobID")
							canUseThisCmd = true
							break
						end
					end
				end
				if canUseThisCmd and player:getData("job") ~= jobID then
					outputChatBox("(( Mesleğe başarıyla giriş yaptınız, unutmayın meslek araçlarını kişisel kullanım yasaktır. ))", player, 245, 246, 250, true)
					dbExec(mysql:getConnection(), "UPDATE `characters` SET `job`='"..jobID.."' WHERE `id`='"..tostring(getElementData(player, "dbid")).."' " )
					player:setData("job", jobID)
				end
			elseif (verb == "isbasi") then
				local canUseThisCmd = false
				local jobID = -1
				for _, marker in pairs(getElementsByType("marker", resourceRoot)) do
					if isElement(marker) then
						if isElementWithinMarker(player, marker) then
							jobID = getElementData(marker, "jobID")
							canUseThisCmd = true
							break
						end
					end
				end
				if canUseThisCmd and player:getData("job") == jobID then
					-- İşbaşı durumu:
					if player:getData("worked") then
						outputChatBox("(( Başarıyla işbaşından ayrıldınız. ))", player, 245, 246, 250, true)
						player:setData("worked", false)
					else
						outputChatBox("(( Başarıyla işbaşı yaptınız. ))", player, 245, 246, 250, true)
						player:setData("worked", true)
					end
				end
			end
		end
	end
)