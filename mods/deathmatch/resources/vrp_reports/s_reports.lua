mysql = exports.vrp_mysql
reports = { }
local reportsToAward = 30
local gcToAward = 1

local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	if not (...) or not isElement((...)) then
		return "Unknown"
	else
		s = getPlayerName_( ... )
		return s and s:gsub( "_", " " ) or s
	end
end

function reportLazyFix(player, cmd) -- / bekiroj
	--if exports.vrp_integration:isPlayerStaff(player) then
		groups = ','
		local admin_level = getElementData(player, "admin_level") or 0
	    if (admin_level == 1) then
	        groups=groups..'18,'
	    elseif (admin_level == 2) then
	        groups=groups..'17,'
	    elseif (admin_level == 3) then
	        groups=groups..'64,'
	    elseif (admin_level == 4) then
	        groups=groups..'15,'
	    end

	    local supporter_level = getElementData(player, "supporter_level") or 0
	    if (supporter_level == 1) then
	        groups=groups..'30,'
	    end

	    local vct_level = getElementData(player, "vct_level") or 0
	    if (vct_level == 1) then
	        groups=groups..'43,'
	    elseif (vct_level == 2) then
	        groups=groups..'39,'
	    end

	    local scripter_level = getElementData(player, "scripter_level") or 0
	    if (scripter_level > 0) then
	        groups=groups..'32,'
	    end

	    local mapper_level = getElementData(player, "mapper_level") or 0
	    if (mapper_level == 1) then
	        groups=groups..'28,'
	    elseif (mapper_level == 2) then
	        groups=groups..'44,'
	    end
	    if string.len(groups) > 0 then
			groups = string.sub(groups,1, string.len(groups)-1)
		end
		--outputDebugString("[reportLazyFix] "..getElementData(player,"account:username").." - "..groups)
	    exports.vrp_anticheat:changeProtectedElementDataEx(player, "forum_perms", groups, false, true)
	--end
end
addCommandHandler("reportlazyfix", reportLazyFix)


function toggleStatus(thePlayer, section, status)
	local newstatus
	if status == "Kapalı" then
		newstatus = "Açık"
	end
	if status == "Açık" then
		newstatus = "Kapalı"
	end
	exports.vrp_global:sendWrnToStaff(getPlayerName(thePlayer).." has toggled "..section.." to "..newstatus, "STATUS")
end
addEvent("toggleStatus", true)
addEventHandler("toggleStatus", getRootElement(), toggleStatus)


-- bekiroj TWEAKS
MTAoutputChatBox = outputChatBox
local function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if showExternalReportBox(visibleTo) then
		showToAdminPanel(text, visibleTo, r,g,b)
		outputConsole ( text, visibleTo)
	else
		--showToAdminPanel(text, visibleTo, r,g,b)
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end

function resourceStart(res)
	reports = exports.vrp_data:loadReports() or {}
end
addEventHandler("onResourceStart", getResourceRootElement(), resourceStart)

function resourceStop(res)
	exports.vrp_data:saveReports(reports)
end
addEventHandler("onResourceStop", getResourceRootElement(), resourceStop)

function getAdminCount()
	local online, duty, lead, leadduty, gm, gmduty = 0, 0, 0, 0,0,0
	for key, value in ipairs(getElementsByType("player")) do
		if (isElement(value)) then
			local level = getElementData( value, "admin_level" ) or 0
			if level >= 1 and level <= 6 then
				online = online + 1

				local aod = getElementData( value, "duty_admin" ) or 0
				if aod == 1 then
					duty = duty + 1
				end

				if level >= 5 then
					lead = lead + 1
					if aod == 1 then
						leadduty = leadduty + 1
					end
				end
			end

			if exports.vrp_integration:isPlayerSupporter(value) then
				gm = gm + 1

				local aod = (getElementData( value, "duty_supporter" ) == 1 )
				if aod == true then
					gmduty = gmduty + 1
				end
			end
		end
	end
	return online, duty, lead, leadduty, gm, gmduty
end

function updateReportCount()
	local open = {}
	local handled = {}

	unanswered = {}
	local byadmin = {}
	local alreadyTold = {}

	for k, v in ipairs(getElementsByType("player")) do
		unanswered[v] = { }
		byadmin[v] = { }
		open[v] = 0
		handled[v] = 0
		if exports.vrp_integration:isPlayerTrialAdmin(v) and getElementData(v, "loggedin") == 1 then
			local alreadyTold = {}
			for key, value in pairs(reports) do
				local staff, _, n, abrv = getReportInfo(value[7])
				if staff then
					for g, u in ipairs(staff) do
						if (value[5] == v) and not alreadyTold[key] then
							open[v] = open[v] + 1
							alreadyTold[key] = true
							if value[5] then
								handled[v] = handled[v] + 1
								if not byadmin[v][value[5]] then
									byadmin[v][value[5]] = { key }
								else
									table.insert(byadmin[v][value[5]], key)
								end
							else
								table.insert(unanswered[v], abrv..""..tostring(key))
							end
						end
					end
				end
			end
		end
	end
	local answeredReports, unansweredReports = "", ""
	for i = 1, #reports do
		local report = reports[i]
		if report then
			local reporter = report[1]
			local reported = report[2]
			local timestring = report[4]
			local admin = report[5]
			local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
			local seenReport = { }
			local handler = ""

			if (isElement(admin)) then
				local adminName = getElementData(admin, "account:username")
				handler = tostring(getPlayerName(admin)).." ("..adminName..")"
			else
				handler = false
			end
			if handler then
				answeredReports = answeredReports..", #"..i.." ("..abrv..")"
			else
				unansweredReports = unansweredReports..", #"..i.." ("..abrv..")"
			end
		end
	end

	-- admstr
	local online, duty, lead, leadduty, gm, gmduty = getAdminCount()

	for key, value in ipairs(getElementsByType("player")) do
		if exports.vrp_integration:isPlayerStaff(value) then
			if exports.vrp_integration:isPlayerTrialAdmin(value) then
				str = ":: "..gmduty.."/"..gm.." SUP :: " .. duty .."/".. online .." admins"
			elseif exports.vrp_integration:isPlayerSupporter(value) then
				str = ":: "..gmduty.."/"..gm.." SUP"
			else
				str = ""
			end

			triggerClientEvent( value, "updateReportsCount", value, answeredReports, "", unansweredReports, byadmin[value][value], str)
		end
	end
end

addEventHandler( "onElementDataChange", getRootElement(),
	function(n)
		if getElementType(source) == "player" and ( n == "admin_level" or n == "duty_admin" or  n == "account:gmlevel" or n == "duty_supporter" ) then
			sortReports(false)
			updateReportCount()
		end
	end
)

function maximeReportsReminder()
	for key, value in ipairs(getElementsByType("player")) do
		local level = getElementData( value, "admin_level" ) or 0
		local aod = getElementData( value, "duty_admin" ) or 0
		local god = getElementData( value, "duty_supporter" ) or false
		if (exports.vrp_integration:isPlayerSupporter(value) and god == 1) or (exports.vrp_integration:isPlayerTrialAdmin(value) and aod == 1) then
			showUnansweredReports(value)
		end
	end
end
setTimer(maximeReportsReminder, 5*60*1000 , 0) -- every 5 mins.

function sortReports(showMessage) -- bekiroj
	-- reports[slot] = { }
	-- reports[slot][1] = source -- Reporter
	-- reports[slot][2] = reportedPlayer -- Reported Player
	-- reports[slot][3] = reportedReason -- Reported Reason
	-- reports[slot][4] = timestring -- Time reported at
	-- reports[slot][5] = nil -- Admin dealing with the report
	-- reports[slot][6] = alertTimer -- Alert timer of the report
	-- reports[slot][7] = reportType -- Type report
	-- reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime
	local sortedReports = {}
	local adminNotice = ""
	local gmNotice = ""
	local unsortedReports = reports

	for key , report in pairs(reports) do
		table.insert(sortedReports, report)
	end

	reports = sortedReports

	for key , report in pairs(reports) do
		if report[8] ~= key then
			if isSupporterReport(report[7]) then
				adminNotice = adminNotice.."#"..report[8]..", "
				if showMessage then
					outputChatBox("[-]#f9f9f9 "..report[8].." numaralı raporun ID#"..key.." sırasına taşındı.", report[1], 70, 200, 30,true)
				end
			else -- Admin report
				adminNotice = adminNotice.."#"..report[8]..", "
				gmNotice = gmNotice.."#"..report[8]..", "
				if showMessage then
					outputChatBox("[-]#f9f9f9 "..report[8].." numaralı raporun ID#"..key.." sırasına taşındı.", report[1], 255, 195, 15,true)
				end
			end
			setElementData(report[1], "reportNum", key)
			report[8] = key
		end
	end

	if showMessage then
		if adminNotice ~= "" then
			adminNotice = string.sub(adminNotice, 1, (string.len(adminNotice) - 2))
			local admins = exports.vrp_global:getAdmins()
			for key, value in ipairs(admins) do
				local adminduty = getElementData(value, "duty_admin")
				if (adminduty==1) then
					--outputChatBox("[ADM]#f9f9f9 "..adminNotice.." numaralı raporlar önceki sıraya kaydırıldı.", value, 255, 195, 15,true)
				end
			end
		end
		if gmNotice ~= "" then
			gmNotice = string.sub(gmNotice, 1, (string.len(gmNotice) - 2))
			local gms = exports.vrp_global:getGameMasters()
			for key, value in ipairs(gms) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					--outputChatBox("[SUP]#f9f9f9 "..gmNotice.." numaralı raporlar önceki sıraya kaydırıldı.", value, 70, 200, 30,true)
				end
			end
		end

	end

end

function showCKList(thePlayer)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("~~~~~~~~~ Self-CK Requests ~~~~~~~~~", thePlayer, 255, 194, 15)

		local ckcount = 0
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				local reason = getElementData(value, "ckreason")
				local pname = getPlayerName(value):gsub("_", " ")
				local playerID = getElementData(value, "playerid")
				if requested=="requested" then
					ckcount = 1
					outputChatBox("Self-CK Request from '" .. pname .. "' ("..playerID..") for the reason '" .. reason .. "'.", thePlayer, 255, 195, 15)
				end
			end
		end

		if ckcount == 0 then
		--	outputChatBox("- Yok.", thePlayer, 255, 255, 255)
		else
			outputChatBox("Use /cka [id] or /ckd [id] to answer the request(s).", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("cks", showCKList)

function reportInfo(thePlayer, commandName, id)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 194, 15)
		else
			local isOverlayDisabled = getElementData(thePlayer, "hud:isOverlayDisabled")
			id = tonumber(id)
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local admin = reports[id][5]
				local staff, _, n, abrv, r, g, b = getReportInfo(reports[id][7])

				local playerID = getElementData(reporter, "playerid") or "Unknown"
				local reportedID = getElementData(reported, "playerid") or "Unknown"


				if staff then
					outputChatBox("["..abrv.." #" .. id .."]#f9f9f9 (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " raporladı (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " saat " .. timestring .. ".", thePlayer, r, g, b,true)
					outputChatBox("Sebep: " .. reason, thePlayer, 70, 200, 30,true)
					--outputDebugString(getElementData(thePlayer, "report_panel_mod")) -- shit
					local handler = ""
					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						outputChatBox("[#" .. id .."]#f9f9f9 Bu rapor " .. getPlayerName(admin) .. " ("..adminName..") adlı yetkilinin kontrolü altında.", thePlayer, 70, 200, 30,true)
					else
						--outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
						--outputChatBox("   Type /ar " .. id .. " to accept this report. Type /togautocheck to turn on/off auto-check when accepting reports.", thePlayer, 255, 194, 15)
					end
				end


			else
				outputChatBox("[-]#f9f9f9 Hatalı Rapor ID'si.", thePlayer, 255, 0, 0,true)
			end
		end
	end
end
addCommandHandler("reportinfo", reportInfo, false, false)
addCommandHandler("ri", reportInfo, false, false)

function changeReportType(thePlayer, commandName, id, rID)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not (id) or not (rID) then
			outputChatBox("KULLANIM: " .. commandName .. " [Report ID] [Report Type ID]", thePlayer, 255, 194, 15)
			outputChatBox("KULLANIM: REPORT TYPES:", thePlayer, 255, 194, 15)
			for ha, lol in ipairs(reportTypes) do
				outputChatBox("#"..ha.." - "..lol[1], thePlayer, 255, 194, 15)
			end
		else
			id = tonumber(id)
			reportID = tonumber(rID)
			if reportID > #reportTypes or reportID < 1 then
				outputChatBox("Error: No report type with that ID found.", thePlayer, 255, 0, 0)
				return
			end
			if reports[id] then
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local timestring = reports[id][4]
				local oldReportType = reports[id][7]

				if oldReportType == reportID then
					outputChatBox("Error: Report was already of that type.", thePlayer, 255, 0, 0)
					return
				end

				local ostaff, _, oname, oabrv = getReportInfo(oldReportType)
				reports[id][7] = reportID
				local staff, _, name, abrv, r, g, b = getReportInfo(reportID)

				if not staff then
					outputChatBox("No Auxiliary staff members of that type online.", thePlayer, 255, 0, 0)
					reports[id][7] = oldReportType
					return
				end
				updateReportCount()
				local playerID = getElementData(reporter, "playerid")
				local reportedID = getElementData(reported, "playerid")
				local adminUser = getElementData(thePlayer, "account:username")

				local players = exports.vrp_pool:getPoolElementsByType("player")

				local GMs = exports.vrp_global:getGameMasters()
				local admins = exports.vrp_global:getAdmins()

				outputChatBox("Your report has been changed from '"..oname.."'' to '"..name.."' by "..adminUser, reporter, 255, 126, 0)
				for k, v in ipairs(staff) do
					if string.find(auxiliaryTeams, v) then
						outputChatBox("Report #"..id.." - Type changed to "..name..".", thePlayer, 255, 126, 0)
						for key, value in pairs(players) do
							if getElementData(value, "loggedin") == 1 then
								outputChatBox(" ["..abrv.." #" .. id .."] (" .. playerID .. ") " .. tostring(getPlayerName(reporter)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reported)) .. " at " .. timestring .. ".", value, r, g, b)--200, 240, 120)
								outputChatBox("Reason: " .. reason, value, 200, 240, 120)
							end
						end
					else
						if isSupporterReport(oldReportType) then
							for key, value in pairs(GMs) do
								local gmDuty = getElementData(value, "duty_supporter")
								if (gmDuty == 1) then
									outputChatBox("Report #"..id.." - Type changed from '"..oname.. "'' to '"..name.."'", value, 255, 126, 0)
								end
							end
							for key, value in pairs(admins) do
								local aDuty = getElementData(value, "duty_admin")
								if aDuty == 1 then
									outputChatBox("Report #"..id.." - Type changed from '"..oname.. "'' to '"..name.."'", value, 255, 126, 0)
								end
							end
							return
						else
							if isSupporterReport(reportID) then
								for key, value in pairs(GMs) do
									local gmDuty = getElementData(value, "duty_supporter")
									if (gmDuty == 1) then
										outputChatBox("Report #"..id.." - Type changed from '"..oname.. "'' to '"..name.."'", value, 255, 126, 0)
									end
								end
								for key, value in pairs(admins) do
									local aDuty = getElementData(value, "duty_admin")
									if aDuty == 1 then
										outputChatBox("Report #"..id.." - Type changed from '"..oname.. "'' to '"..name.."'", value, 255, 126, 0)
									end
								end
								return
							else
								for key, value in pairs(admins) do
									local aDuty = getElementData(value, "duty_admin")
									if aDuty == 1 then
										outputChatBox("Report #"..id.." - Type changed from '"..oname.. "'' to '"..name.."'", value, 255, 126, 0)
									end
								end
								return
							end
						end
					end
				end

			else
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("changereport", changeReportType, false, false)
addCommandHandler( "cp", changeReportType, false, false )

function playerQuit()
	local originalReportID = getElementData(source, "adminreport")
	local update = false
	local alreadyTold = { }

	if originalReportID then
		-- find the actual report id
		local report = nil
		for i = 1, originalReportID do
			if reports[i] and reports[i][1] and reports[i][1] == source then
				report = i
				break
			end
		end
		if report and reports[report] then
			local theAdmin = reports[report][5]
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[report][7])


			if (isElement(theAdmin)) then
					outputChatBox(" ["..abrv.." #" .. report .."] Player " .. getPlayerName(source) .. " left the game.", theAdmin, 255, 126, 0)--200, 240, 120)
			else
				if staff then -- Check if the aux players are online
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										outputChatBox(" ["..abrv.." #" .. report .."] Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("players")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										local gmduty = getElementData(value, "duty_supporter")
										local adminduty = getElementData(value, "duty_admin")
										if adminduty == 1 or gmduty == 1 then
											outputChatBox(" ["..abrv.." #" .. report .."] Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
				end
			end

			local alertTimer = reports[report][6]
			--local timeoutTimer = reports[report][7]

			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end

			--[[if isTimer(timeoutTimer) then
				killTimer(timeoutTimer)
			end]]
			if reports[report] then
				reports[report] = nil -- Destroy any reports made by the player
			end
			update = true
		else
			outputDebugString('report/onPlayerQuit: ' .. getPlayerName(source) .. ' has undefined report pending')
		end
	end

	local alreadyTold = { }
	-- check for reports assigned to him, unassigned if neccessary
	for i = 1, #reports do
		if reports[i] and reports[i][5] == 5 then
			reports[i][5] = nil
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox(" ["..abrv.." #" .. i .."] Report is unassigned (" .. adminName .. " left the game)", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										local adminName = getElementData(source, "account:username")
										outputChatBox(" ["..abrv.." #" .. i .."] Report is unassigned (" .. adminName .. " left the game)", value, 255, 126, 0)--200, 240, 120)
										alreadyTold[value] = true
										update = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
		elseif reports[i] and reports[i][2] == source then
			local staff, _, name, abrv, r, g, b = getReportInfo(reports[i][7])
			if staff then -- Check if the aux players are online
				for k, usergroup in ipairs(staff) do
					if string.find(auxiliaryTeams, usergroup) then
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local adminName = getElementData(source, "account:username")
									outputChatBox(" ["..abrv.." #" .. i .."] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)
									alreadyTold[value] = true
									update = true
								end
							end
						end
					else
						for key, value in ipairs(getElementsByType("players")) do
							if getElementData(value, "loggedin") == 1 then
								if not alreadyTold[value] then
									local gmduty = getElementData(value, "duty_supporter")
									local adminduty = getElementData(value, "duty_admin")
									if adminduty == 1 or gmduty == 1 then
										outputChatBox(" ["..abrv.." #" .. i .."] Reported Player " .. getPlayerName(source) .. " left the game.", value, 255, 126, 0)--200, 240, 120)
										update = true
										alreadyTold[value] = true
									end
								end
							end
						end
					end
				end
			else
				update = true
			end
			local reporter = reports[i][1]
			if reporter ~= source then
				local adminName = getElementData(source, "account:username")
				outputChatBox("Your report "..abrv.."#" .. i .. " has been closed (" .. adminName .. " left the game)", reporter, 255, 126, 0)--200, 240, 120)
				exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "adminreport", false, true)
				exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "gmreport", false, true)
				exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
			end

			local alertTimer = reports[i][6]
			--local timeoutTimer = reports[i][7]
			if isTimer(alertTimer) then
				killTimer(alertTimer)
			end
			--[[if isTimer(timeoutTimer) then
				killTimer(timeoutTimer)
			end]]
			reports[i] = nil -- Destroy any reports made by the player
		end
	end

	if exports.vrp_integration:isPlayerStaff(source) then -- Check if a Aux staff member went offline and there is noone left to handle the report.
		for i = 1, #reports do
			if reports[i] then
				local staff, _ = getReportInfo(reports[i][7], source)
				if not staff then
					outputChatBox(_, reports[i][1], 255, 0, 0)
					outputChatBox("Your report has automatically been closed.", reports[i][1], 255, 0, 0)
					reports[i] = nil
					update = true
				end
			end
		end
	end

	local requested = getElementData(source, "ckstatus") -- Clear any Self-CK requests the player may have.
	if (requested=="requested") then
		for key, value in ipairs(exports.vrp_global:getAdmins()) do
			triggerClientEvent( value, "subtractOneFromCKCount", value )
		end
		setElementData(source, "ckstatus", 0)
		setElementData(source, "ckreason", 0)
	end

	if update then
		sortReports(true)
		updateReportCount()
	end


end
addEventHandler("onPlayerQuit", getRootElement(), playerQuit)
addEventHandler("accounts:characters:change", getRootElement(), playerQuit)

function playerConnect()
	if exports.vrp_integration:isPlayerTrialAdmin(source) then
		local players = exports.vrp_pool:getPoolElementsByType("player")
		for key, value in ipairs(players) do
			local logged = getElementData(value, "loggedin")
			if (logged==1) then
				local requested = getElementData(value, "ckstatus")
				if requested=="requested" then
					triggerClientEvent( source, "addOneToCKCountFromSpawn", source )
				end
			end
		end
	end
end
addEventHandler("accounts:characters:spawn", getRootElement(), playerConnect)


function handleReport(reportedPlayer, reportedReason, reportType)
	local staff, errors, name, abrv, r, g, b = getReportInfo(reportType)
	if not staff then
		outputChatBox(errors, source, 255, 0, 0)
		return
	end

	if getElementData(reportedPlayer, "loggedin") ~= 1 then
		outputChatBox("The player you are reporting is not logged in.", source, 255, 0, 0)
		return
	end
	-- Find a free report slot
	local slot = nil

	sortReports(false)

	for i = 1, getMaxPlayers() do
		if not reports[i] then
			slot = i
			break
		end
	end

	local hours, minutes = getTime()

	-- Fix hours
	if (hours<10) then
		hours = "0" .. hours
	end

	-- Fix minutes
	if (minutes<10) then
		minutes = "0" .. minutes
	end

	local timestring = hours .. ":" .. minutes


	--local alertTimer = setTimer(alertPendingReport, 123500, 2, slot)
	--local alertTimer = setTimer(alertPendingReport, 123500, 0, slot)
	--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, slot)

	-- Store report information
	reports[slot] = { }
	reports[slot][1] = source -- Reporter
	reports[slot][2] = reportedPlayer -- Reported Player
	reports[slot][3] = reportedReason -- Reported Reason
	reports[slot][4] = timestring -- Time reported at
	reports[slot][5] = nil -- Admin dealing with the report
	reports[slot][6] = alertTimer -- Alert timer of the report
	reports[slot][7] = reportType -- Report Type, table row for new report types / Chaos
	reports[slot][8] = slot -- Report ID/Slot, used in rolling queue function / Maxime

	local playerID = getElementData(source, "playerid")
	local reportedID = getElementData(reportedPlayer, "playerid")
	setElementData(source, "reportNum", slot)

	exports.vrp_anticheat:changeProtectedElementDataEx(source, "adminreport", slot, true)
	exports.vrp_anticheat:changeProtectedElementDataEx(source, "reportadmin", false)
	local count = 0
	local nigger = 0
	local skipadmin = false
	local gmsTold = false
	local playergotit = false
	local alreadyCalled	= { }

	for _, usergroup in ipairs(staff) do
		if string.find(SUPPORTER, usergroup) then -- Supporters
			exports.vrp_anticheat:changeProtectedElementDataEx(source, "gmreport", slot, true)
			local GMs = exports.vrp_global:getGameMasters()

			for key, value in ipairs(GMs) do
				local gmDuty = getElementData(value, "duty_supporter")
				if (gmDuty == 1) then
					nigger = nigger + 1
					outputChatBox(" ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " Adlı Oyuncu yeni bir soru gonderdi", value, r, g, b)
					outputChatBox("Rapor icerigi: " .. reportedReason, value, 200, 240, 120)
					-- if reason2 and #reason2 > 0 then
						-- outputChatBox(reason2, value, 70, 220, 30)
					-- end
					skipadmin = true
				end
				count = count + 1
			end


			-- No GMS online
			if not skipadmin then
				local GMs = exports.vrp_global:getAdmins()
				-- Show to GMs
				--local reason1 = reportedReason:sub( 0, 70 )
				--local reason2 = reportedReason:sub( 71 )
				for key, value in ipairs(GMs) do
					local gmDuty = getElementData(value, "duty_admin")
					if (gmDuty == 1) then
						outputChatBox(" ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " Adlı Oyuncu yeni bir rapor gonderdi.", value, r, g, b)--200, 240, 120)
						outputChatBox("Rapor icerigi: " .. reportedReason, value, 200, 240, 120)
						skipadmin = true
						-- if reason2 and #reason2 > 0 then
							-- outputChatBox(reason2, value, 200, 240, 120)
						-- end
					end
					count = count - 1
				end
			end

			--outputChatBox("Raporunuzu gönderdiğiniz için teşekkür ederiz. (Rapor ID: #" .. tostring(slot) .. ").", source, 70, 200, 30)
			exports["vrp_infobox"]:addBox(source, "success", "Başarıyla rapor gönderdiniz. (Sıra ID: #"..tostring(slot)..") /er yazarak raporu kapatabilirsiniz.")

			--outputChatBox("/er yazarak istediğiniz zaman raporu kapatabilirsiniz.", source, 70, 200, 30)
		elseif string.find(auxiliaryTeams, usergroup) then -- Auxiliary Teams
			for key, value in ipairs(getElementsByType("player")) do
				if getElementData(value, "loggedin") == 1 then
				--	if string.find(getElementData(value, "forum_perms"), usergroup) then -- Opens up functionality to have reports ONLY go to leaders or only members
						outputChatBox(" ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, r, g, b)--200, 240, 120)
						outputChatBox("Reason: " .. reportedReason, value, 200, 240, 120)
				--	end
				end
			end
			outputChatBox("Thank you for submitting your "..name.." report. (Report ID: #" .. tostring(slot) .. ").", source, 200, 240, 120)
			outputChatBox("You reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. ". Reason: ", source, 237, 145, 33 )
			outputChatBox(reportedReason, source, 200, 240, 120)
			outputChatBox("You can close this report at any time by typing /er.", source, 200, 240, 120)
			break
		else -- Admins
			local admins = exports.vrp_global:getAdmins()
			local count = 0
			local faggots = 0

			if not skipadmin then
				for key, value in ipairs(admins) do
					local adminduty = getElementData(value, "duty_admin")
					local forum_perms = getElementData(value, "forum_perms")
					if (adminduty==1) and not alreadyCalled[value] then
						faggots = faggots + 1
						outputChatBox(" ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, r, g, b)--200, 240, 120)
						outputChatBox("Reason: " .. reportedReason, value, 200, 240, 120)
						alreadyCalled[value] = true
					end
					if getElementData(value, "hiddenadmin") ~= 1 then
						count = count + 1
					end
				end

				if not gmsTold then
					local GMs = exports.vrp_global:getGameMasters()
					for key, value in ipairs(GMs) do
						local gmDuty = getElementData(value, "duty_supporter")
						if (gmDuty == 1) and getElementData(value, "report-system:subcribeToAdminReports") then
							outputChatBox(" ["..abrv.." #" .. slot .."] (" .. playerID .. ") " .. tostring(getPlayerName(source)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, r, g, b)--200, 240, 120)
							outputChatBox("Reason: " .. reportedReason, value, 200, 240, 120)
							gmsTold = true
						end
					end
				end

				if not playergotit then
					outputChatBox("Thank you for submitting your "..name.." report. (Report ID: #" .. tostring(slot) .. ").", source, 200, 240, 120)
					outputChatBox("You reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. ". Reason: ", source, 237, 145, 33 )
					outputChatBox(reportedReason, source, 200, 240, 120)
					-- if reason2 and #reason2 > 0 then
						-- outputChatBox(reason2, source, 200, 240, 120)
					-- end
					outputChatBox("An admin will respond to your report ASAP. Currently there are " .. faggots .. " admin" .. ( count == 1 and "" or "s" ) .. " available.", source, 200, 240, 120)
					outputChatBox("You can close this report at any time by typing /er.", source, 200, 240, 120)
					playergotit = true
				end
			end
		end
	end
	updateReportCount()
end

function subscribeToAdminsReports(thePlayer)
	if exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if getElementData(thePlayer, "report-system:subcribeToAdminReports") then
			setElementData(thePlayer, "report-system:subcribeToAdminReports", false)
			outputChatBox("You've unsubscribed from admin reports.",thePlayer, 255,0,0)
		else
			setElementData(thePlayer, "report-system:subcribeToAdminReports", true)
			outputChatBox("You've subscribed to admin reports.",thePlayer, 0,255,0)
		end
	end
end
addCommandHandler("showadminreports", subscribeToAdminsReports)

addEvent("clientSendReport", true)
addEventHandler("clientSendReport", getRootElement(), handleReport)

function alertPendingReport(id)
	if (reports[id]) then
		local reportingPlayer = reports[id][1]
		local reportedPlayer = reports[id][2]
		local reportedReason = reports[id][3]
		local timestring = reports[id][4]
		local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
		local playerID = getElementData(reportingPlayer, "playerid")
		local reportedID = getElementData(reportedPlayer, "playerid")
		local alreadyTold = { }

		if staff then
			for k, usergroup in ipairs(staff) do
				if string.find(auxiliaryTeams, usergroup) then
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if not alreadyTold[value] then
								outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 200, 240, 120)
								alreadyTold[value] = true
							end
						end
					end
				else
					for key, value in ipairs(getElementsByType("player")) do
						if getElementData(value, "loggedin") == 1 then
							if not alreadyTold[value] then
								local gmduty = getElementData(value, "duty_supporter")
								local adminduty = getElementData(value, "duty_admin")
								if (gmduty==1) or (adminduty==1) then
									outputChatBox(" [#" .. id .. "] is still not answered: (" .. playerID .. ") " .. tostring(getPlayerName(reportingPlayer)) .. " reported (" .. reportedID .. ") " .. tostring(getPlayerName(reportedPlayer)) .. " at " .. timestring .. ".", value, 200, 240, 120)
								end
							end
						end
					end
				end
			end
		end
	end
end

function falseReport(thePlayer, commandName, id)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not (id) then
			outputChatBox("Kullanım:#f9f9f9 /" .. commandName .. " [Rapor ID]", thePlayer, 255, 194, 14,true)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("[-]#f9f9f9 Hatalı Rapor ID.", thePlayer, 255, 0, 0,true)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) then

					outputChatBox("[-]#f9f9f9 Rapor #" .. id .. " ID'li raporun kontrolü " .. getPlayerName(reportHandler) .. " ("..getElementData(reportHandler,"account:username")..") adlı yetkilide.", thePlayer, 255, 0, 0,true)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					--[[
					if reportedPlayer == thePlayer and not exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) and not isAuxiliaryReport(reports[id][7]) then
						outputChatBox("You better let someone else to handler this report because it's against you.",thePlayer, 255,0,0)
						return false
					end
					]] -- Disabled because staff report is not going to be handled in game anyway / MAXIME / 2015.1.26

					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					local timeoutTimer = reports[id][7]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])

					--local found = false
					--if not found and not exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
					--	outputChatBox("You may not false a report that does not have to do with your staff division.", thePlayer, 255, 0, 0)
					--	return
					--end

					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)

					local adminUsername = getElementData(thePlayer, "account:username")

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end
					removeElementData(reportingPlayer, "reportNum")
					if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end

					reports[id] = nil
					local alreadyTold = { }
					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local timestring = hours .. ":" .. minutes
					exports.vrp_anticheat:changeProtectedElementDataEx(reportingPlayer, "adminreport", false, true)
					exports.vrp_anticheat:changeProtectedElementDataEx(reportingPlayer, "gmreport", false, true)
					exports.vrp_anticheat:changeProtectedElementDataEx(reportingPlayer, "reportadmin", true, true)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox("[#" .. id .. "]#f9f9f9 "..adminTitle.." ("..adminUsername..") adlı yetkili #" .. id .. " ID'li raporu yalanladı. -", value, r, g, b,true)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("[#" .. id .. "]#f9f9f9 "..adminTitle.." ("..adminUsername..") adlı yetkili #" .. id .. " ID'li raporu yalanladı. -", value, r, g, b,true)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("[" .. timestring .. "]#f9f9f9 (#" .. id .. ") ID'li raporun "..adminTitle.." ".. getPlayerName(thePlayer) .. " adlı yetkili tarafından yalanlandı.", reportingPlayer, r, g, b,true)--200, 240, 120)
					triggerClientEvent ( reportingPlayer, "playNudgeSound", reportingPlayer)
					--local accountID = getElementData(thePlayer, "account:id")
					--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " maked a report as false. Report: " .. reason )
					sortReports(true)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("falsereport", falseReport, false, false)
addCommandHandler("fr", falseReport, false, false)

addCommandHandler("fixim", function(plr)

setElementData(plr, "reportNum", nil)
end)

function arBind()
	if exports.vrp_integration:isPlayerTrialAdmin(client) then
		exports.vrp_global:sendMessageToAdmins("AdmWarn: ".. getPlayerName(client) .. " has accept report bound to keys.")
	end
end
addEvent("arBind", true)
addEventHandler("arBind", getRootElement(), arBind)

function acceptReport(thePlayer, commandName, id)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Report ID]", thePlayer, 255, 194, 14)
		else
			local id = tonumber(id)
			if not (reports[id]) then
				outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
			else
				local reportHandler = reports[id][5]

				if (reportHandler) then
					outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
				else

					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]

					if reportingPlayer == thePlayer and not exports.vrp_integration:isPlayerScripter(thePlayer) then
						outputChatBox("You can not accept your own report.",thePlayer, 255,0,0)
						return false
					end

					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])


					local reason = reports[id][3]
					local alertTimer = reports[id][6]
					--local timeoutTimer = reports[id][7]
					local alreadyTold = { }

					if isTimer(alertTimer) then
						killTimer(alertTimer)
					end

					--[[if isTimer(timeoutTimer) then
						killTimer(timeoutTimer)
					end]]

					reports[id][5] = thePlayer -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					exports.vrp_anticheat:changeProtectedElementDataEx(reportingPlayer, "reportadmin", thePlayer, false)

					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")

					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)


					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox("["..abrv.." #" .. id .. "] "..adminTitle.." ("..adminName..") adlı yetkili raporu kabul etti. #" .. id .. " -", value, 255, 84, 84, true)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox("["..abrv.." #" .. id .. "] "..adminTitle.." ("..adminName..") adlı yetkili raporu kabul etti. #" .. id .. " -", value, r, g, b,true)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					outputChatBox("[-] "..adminTitle.." " .. getPlayerName(thePlayer) .. " ("..adminName..") raporunu kabul etti (#" .. id .. ") l "..timestring..", Lütfen sizinle iletişim kurmasını bekleyin.", reportingPlayer, 255,126, 0,true)--200, 240, 120)
					triggerClientEvent ( reportingPlayer, "playNudgeSound", reportingPlayer)

					outputChatBox("[-] Bir raporu kabul ettin Rapor #" .. id .. ". Oyuncu ID #" .. playerID .. " (" .. getPlayerName(reportingPlayer) .. ").", thePlayer, r, g, b,true)--200, 240, 120)

					if getElementData(thePlayer, "report:autocheck") then
						triggerClientEvent( thePlayer, "report:onOpenCheck", thePlayer, tostring(playerID) )
					end

					setElementData(thePlayer, "targetPMer", reportingPlayer, false)
					--setElementData(reportingPlayer, "targetPMed", thePlayer, false)

					--local accountID = getElementData(thePlayer, "account:id")
					--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " accepted a report. Report: " .. reason )
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("acceptreport", acceptReport, false, false)
addCommandHandler("ar", acceptReport, false, false)

function toggleAutoCheck(thePlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		if getElementData(thePlayer, "report:autocheck") then
			setElementData(thePlayer, "report:autocheck", false)
			outputChatBox(" You've just disabled auto /check on /ar.", thePlayer, 255, 0,0)
		else
			setElementData(thePlayer, "report:autocheck", true)
			outputChatBox(" You've just enabled auto /check on /ar.", thePlayer, 0, 255,0)
		end
	end
end
addCommandHandler("toggleautocheck", toggleAutoCheck, false, false)
addCommandHandler("togautocheck", toggleAutoCheck, false, false)

function acceptAdminReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Report ID] [Adminname]", thePlayer, 255, 194, 14)
		else
			local targetAdmin, username = exports.vrp_global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
				else
					local reportHandler = reports[id][5]

					if (reportHandler) then
						outputChatBox("Report #" .. id .. " is already being handled by " .. getPlayerName(reportHandler) .. ".", thePlayer, 255, 0, 0)
					else
						local reportingPlayer = reports[id][1]
						local reportedPlayer = reports[id][2]
						local reason = reports[id][3]
						local alertTimer = reports[id][6]
						--local timeoutTimer = reports[id][7]
						local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
						if isTimer(alertTimer) then
							killTimer(alertTimer)
						end

						--[[if isTimer(timeoutTimer) then
							killTimer(timeoutTimer)
						end]]

						reports[id][5] = targetAdmin -- Admin dealing with this report

						local hours, minutes = getTime()

						-- Fix hours
						if (hours<10) then
							hours = "0" .. hours
						end

						-- Fix minutes
						if (minutes<10) then
							minutes = "0" .. minutes
						end

						exports.vrp_anticheat:changeProtectedElementDataEx(reportingPlayer, "reportadmin", targetAdmin, false)

						local timestring = hours .. ":" .. minutes
						local playerID = getElementData(reportingPlayer, "playerid")
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(targetAdmin)

						outputChatBox("[" .. timestring .. "] "..adminTitle.." " .. getPlayerName(targetAdmin) .. "  raporunu kabul etti (#" .. id .. "), Lütfen sizinle iletişim kurmalarını bekleyin.", reportingPlayer, 200, 240, 120)
						outputChatBox("A head admin assigned report #" .. id .. " to you. Please proceed to contact the player ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 200, 240, 120)
						local alreadyTold = { }

						if staff then
							for k, usergroup in ipairs(staff) do
								if string.find(auxiliaryTeams, usergroup) then
									for key, value in ipairs(getElementsByType("player")) do
										if getElementData(value, "loggedin") == 1 then
											if not alreadyTold[value] then
												outputChatBox(" ["..abrv.." #" .. id .. "] - " .. getPlayerName(theAdmin) .. " has accepted report #" .. id .. " (Assigned) -", value, r, g, b)
												alreadyTold[value] = true
											end
										end
									end
								else
									for key, value in ipairs(getElementsByType("player")) do
										if getElementData(value, "loggedin") == 1 then
											if not alreadyTold[value] then
												local adminduty = getElementData(value, "duty_admin")
												local gmduty = getElementData(value, "duty_supporter")
												if (adminduty==1) or (gmduty==1) then
													outputChatBox(" ["..abrv.." #" .. id .. "] - " .. getPlayerName(theAdmin) .. " has accepted report #" .. id .. " (Assigned) -", value, r, g, b)--200, 240, 120)
													alreadyTold[value] = true
												end
											end
										end
									end
								end
							end
						end

						--local accountID = getElementData(thePlayer, "account:id")
						--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " was assigned a report. Report: " .. reason )
						sortReports(false)
						updateReportCount()
					end
				end
			end
		end
	end
end
addCommandHandler("ara", acceptAdminReport, false, false)


function transferReport(thePlayer, commandName, id, ...)
	local adminName = table.concat({...}, " ")
	if (exports.vrp_integration:isPlayerSeniorAdmin(thePlayer)) then
		if not (...) then
			outputChatBox("KULLANIM: /" .. commandName .. " [Report ID] [Adminname]", thePlayer, 200, 240, 120)
		else
			local targetAdmin, username = exports.vrp_global:findPlayerByPartialNick(thePlayer, adminName)
			if targetAdmin then
				local id = tonumber(id)
				if not (reports[id]) then
					outputChatBox("Invalid report ID.", thePlayer, 255, 0, 0)
				elseif (reports[id][5] ~= thePlayer) and not (exports.vrp_integration:isPlayerAdmin(thePlayer)) then
					outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
				else
					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local report = reports[id][3]
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					reports[id][5] = targetAdmin -- Admin dealing with this report

					local hours, minutes = getTime()

					-- Fix hours
					if (hours<10) then
						hours = "0" .. hours
					end

					-- Fix minutes
					if (minutes<10) then
						minutes = "0" .. minutes
					end

					local alreadyTold ={ }
					local timestring = hours .. ":" .. minutes
					local playerID = getElementData(reportingPlayer, "playerid")

					outputChatBox("[" .. timestring .. "] " .. getPlayerName(thePlayer) .. " handed your report to ".. getPlayerName(targetAdmin) .." (#" .. id .. "), Please wait for him/her to contact you.", reportingPlayer, 200, 240, 120)
					outputChatBox(getPlayerName(thePlayer) .. " handed report #" .. id .. " to you. Please proceed to contact the player ( (" .. playerID .. ") " .. getPlayerName(reportingPlayer) .. ").", targetAdmin, 200, 240, 120)

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " handed report #" .. id .. " over to  ".. getPlayerName(targetAdmin) , value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" [#" .. id .. "] - " .. getPlayerName(thePlayer) .. " handed report #" .. id .. " over to  ".. getPlayerName(targetAdmin) , value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end

					--local accountID = getElementData(thePlayer, "account:id")
					--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " had a report transfered to them. Report: " .. reason )
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("transferreport", transferReport, false, false)
addCommandHandler("tr", transferReport, false, false)

function closeReport(thePlayer, commandName, id)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			closeAllReports(thePlayer)
			--outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
			if (reports[id]==nil) then
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			elseif (reports[id][5] ~= thePlayer) then
				outputChatBox("This is not your report, pal.", thePlayer, 255, 0, 0)
			else
				local reporter = reports[id][1]
				local reported = reports[id][2]
				local reason = reports[id][3]
				local alertTimer = reports[id][6]
				local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
				local alreadyTold = { }

				if isTimer(alertTimer) then
					killTimer(alertTimer)
				end

				--[[if isTimer(timeoutTimer) then
					killTimer(timeoutTimer)
				end]]

				reports[id] = nil

				local adminName = getElementData(thePlayer,"account:username")
				local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)

				if (isElement(reporter)) then
					exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "adminreport", false, true)
					exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "gmreport", false, true)
					exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
					removeElementData(reporter, "reportNum")
					outputChatBox("[-] "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") adlı yetkili raporunu kapattı.", reporter, r, g, b, true)
					triggerClientEvent(reporter, "feedback:form", thePlayer) -- Staff feedback / Maxime / 2015.1.29
				end

				if staff then
					for k, usergroup in ipairs(staff) do
						if string.find(auxiliaryTeams, usergroup) then
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										outputChatBox("["..abrv.."#" .. id .. "] "..adminTitle.." ("..adminName..") adlı yetkili raporu sonlandırdı. #" .. id .. ". -", value, r, g, b, true)
										updateVeri(thePlayer)
											setTimer(function()
										    executeCommandHandler ( "raporum", thePlayer )
											end, 5000, 1)
										alreadyTold[value] = true
									end
								end
							end
						else
							for key, value in ipairs(getElementsByType("player")) do
								if getElementData(value, "loggedin") == 1 then
									if not alreadyTold[value] then
										local adminduty = getElementData(value, "duty_admin")
										local gmduty = getElementData(value, "duty_supporter")
										if (adminduty==1) or (gmduty==1) then
											outputChatBox("["..abrv.."#" .. id .. "] "..adminTitle.." ("..adminName..") adlı yetkili raporu sonlandırdı. #" .. id .. ". -", value, r, g, b, true)--200, 240, 120)
											updateVeri(thePlayer)
											setTimer(function()
										    executeCommandHandler ( "raporum", thePlayer )
											end, 5000, 1)
											alreadyTold[value] = true
										end
									end
								end
							end
						end
					end
											setTimer(function()
					outputChatBox("[-]#f9f9f9 Güncel Raporun: "..getElementData(thePlayer, "adminreports"), thePlayer, 255, 194, 14,true)
					end, 5000, 1)
				end

				--local accountID = getElementData(thePlayer, "account:id")
				--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reporter, reported}, getPlayerName(thePlayer) .. " closed a report. Report: " .. reason )

				sortReports(true)
				updateReportCount()
				updateStaffReportCount(thePlayer)
			end
		end
	end
end
addCommandHandler("closereport", closeReport, false, false)
addCommandHandler("cr", closeReport, false, false)

function closeAllReports(thePlayer)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		--outputChatBox("~~~~~~~~~ Cevaplanmamış Raporlar ~~~~~~~~~", thePlayer, 0, 255, 15)
		--reports = sortReportsByTime(reports)
		local count = 0
		for i = 1, getMaxPlayers() do
			local report = reports[i]
			if report then
				local admin = report[5]
				if isElement(admin) and admin == thePlayer then
					closeReport(thePlayer, "cr" , i)
					count = count + 1
				end
			end
		end

		if count == 0 then
			outputChatBox("[-]#f9f9f9 Kapatılmayan rapor yok.", thePlayer, 255, 126, 0,true)--255, 194, 15)
		else
			outputChatBox("[-]#f9f9f9 Toplam "..count.." raporu sonlandırdın.", thePlayer, 255, 126, 0, true)--255, 194, 15)
		end
	end
end
addCommandHandler("closeallreports", closeAllReports, false, false)
addCommandHandler("car", closeAllReports, false, false)

function dropReport(thePlayer, commandName, id)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		if not (id) then
			outputChatBox("KULLANIM: " .. commandName .. " [ID]", thePlayer, 255, 195, 14)
		else
			id = tonumber(id)
			if (reports[id] == nil) then
				outputChatBox("Invalid Report ID.", thePlayer, 255, 0, 0)
			else
				if (reports[id][5] ~= thePlayer) then
					outputChatBox("You are not handling this report.", thePlayer, 255, 0, 0)
				else
					--local alertTimer = setTimer(alertPendingReport, 123500, 2, id)
					--local timeoutTimer = setTimer(pendingReportTimeout, 300000, 1, id)

					local reportingPlayer = reports[id][1]
					local reportedPlayer = reports[id][2]
					local reason = reports[id][3]
					reports[id][5] = nil
					reports[id][6] = alertTimer
					local staff, _, name, abrv, r, g, b = getReportInfo(reports[id][7])
					--reports[id][7] = timeoutTimer

					local adminName = getElementData(thePlayer,"account:username")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
					local alreadyTold = { }

					local reporter = reports[id][1]
					if (isElement(reporter)) then
						exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "adminreport", id, true)
						exports.vrp_anticheat:changeProtectedElementDataEx(reporter, "reportadmin", false, false)
						outputChatBox(adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has released your report. Please wait until another member of staff accepts your report.", reporter, r, g, b)
					end

					if staff then
						for k, usergroup in ipairs(staff) do
							if string.find(auxiliaryTeams, usergroup) then
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has dropped report #" .. id .. ". -", value, r, g, b)
											alreadyTold[value] = true
										end
									end
								end
							else
								for key, value in ipairs(getElementsByType("player")) do
									if getElementData(value, "loggedin") == 1 then
										if not alreadyTold[value] then
											local adminduty = getElementData(value, "duty_admin")
											local gmduty = getElementData(value, "duty_supporter")
											if (adminduty==1) or (gmduty==1) then
												outputChatBox(" ["..abrv.." #" .. id .. "] - "..adminTitle.." "..getPlayerName(thePlayer) .. " ("..adminName..") has dropped report #" .. id .. ". -", value, r, g, b)--200, 240, 120)
												alreadyTold[value] = true
											end
										end
									end
								end
							end
						end
					end
					--local accountID = getElementData(thePlayer, "account:id")
					--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, {reportingPlayer, reportedPlayer}, getPlayerName(thePlayer) .. " dropped a report. Report: " .. reason )
					sortReports(false)
					updateReportCount()
				end
			end
		end
	end
end
addCommandHandler("dropreport", dropReport, false, false)
addCommandHandler("dr", dropReport, false, false)

function endReport(thePlayer, commandName)
	local adminreport = getElementData(thePlayer, "adminreport")
	local gmreport = getElementData(thePlayer, "gmreport")

	local report = false
	for i=1, getMaxPlayers() do
		if reports[i] and (reports[i][1] == thePlayer) then
			report = i
			break
		end
	end

	if not adminreport or not report then
		outputChatBox("[-]#f9f9f9 Bekleyen bir raporunuz yok. F2 tuşuna basarak bir tane oluşturabilirsiniz.", thePlayer, 255, 0, 0, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "adminreport", false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "gmreport", false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)
	else
		local hours, minutes = getTime()

		-- Fix hours
		if (hours<10) then
			hours = "0" .. hours
		end

		-- Fix minutes
		if (minutes<10) then
			minutes = "0" .. minutes
		end

		local timestring = hours .. ":" .. minutes
		local reportedPlayer = reports[report][2]
		--local reason = reports[report][3]
		local reportHandler = reports[report][5]
		local alertTimer = reports[report][6]
		--local timeoutTimer = reports[report][7]

		if isTimer(alertTimer) then
			killTimer(alertTimer)
		end

		--[[if isTimer(timeoutTimer) then
			killTimer(timeoutTimer)
		end]]
		removeElementData(thePlayer, "reportNum")
		reports[report] = nil
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "adminreport", false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "gmreport", false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "reportadmin", false, false)

		outputChatBox("[" .. timestring .. "]#f9f9f9 Raporunuzu iptal ettiniz. Rapor ID #"..report, thePlayer, 200, 240, 120,true)
		local otherAccountID = nil
		if (isElement(reportHandler)) then
			outputChatBox("[-]#f9f9f9 "..getPlayerName(thePlayer) .. " başarıyla raporu sonlandırdı. (ID #" .. report .. ").", reportHandler, 255, 126, 0,true)--200, 240, 120)
			otherAccountID = getElementData(reportHandler, "account:id")
			updateStaffReportCount(reportHandler)
			triggerClientEvent(thePlayer, "feedback:form", reportHandler) -- Staff feedback / Maxime / 2015.1.29
		end

		--local accountID = getElementData(thePlayer, "account:id")
		--local affected = { }
		-- table.insert(affected, reportedPlayer)
		-- if isElement(reportHandler) then
			-- table.insert(affected, reportHandler)
			-- table.insert(affected, "ac"..tostring(otherAccountID))
		-- end
		--exports.vrp_logs:dbLog({"ac"..tostring(accountID), thePlayer }, 38, affected, getPlayerName(thePlayer) .. " accepted a report. Report: " .. reason )
		sortReports(true)
		updateReportCount()
	end
end
addCommandHandler("endreport", endReport, false, false)
addCommandHandler("er", endReport, false, false)

-- Output unanswered reports for staff.
function showUnansweredReports(thePlayer)
	if exports.vrp_integration:isPlayerStaff(thePlayer) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 1, true)
		else
			--outputChatBox("[#ed2b2bCevaplanmamış Raporlar#ffffff]", thePlayer, 255, 255, 255, true)
			--reports = sortReportsByTime(reports)
			local count = 0
			local seenReport = { }
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])

					local handler = ""
					if (isElement(admin)) then
						--handler = tostring(getPlayerName(admin))
					else
						handler = ""
						if staff then
							for k,v in ipairs(staff) do
								if not seenReport[i] then
									outputChatBox("[-]#f9f9f9 Rapor "..abrv.."#" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' şikayet ettiği '" .. tostring(getPlayerName(reported)) .. "' saat " .. timestring .. ".", thePlayer, r, g, b,true)
									count = count + 1
									seenReport[i] = true
								end
							end
						end
					end
				end
			end

			if count == 0 then
				--outputChatBox("- Yok", thePlayer, 255, 255, 255)
			else
				outputChatBox("[Tüyo]#f9f9f9 /ri <raporID> yazarak raporları okuyabilirsin.", thePlayer, 255, 228, 94,true)
			end
		end
	end
end
addCommandHandler("ur", showUnansweredReports, false, false)

function showReports(thePlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		if showTopRightReportBox(thePlayer) then
			setElementData(thePlayer, "report:topRight", 3, true)
		else
			--outputChatBox("[#999fffCevaplanmamış Raporlar#f9f9f9]", thePlayer, 240,240,240,true)
			--reports = sortReportsByTime(reports)
			local count = 0
			for i = 1, #reports do
				local report = reports[i]
				if report then
					local reporter = report[1]
					local reported = report[2]
					local timestring = report[4]
					local admin = report[5]
					local staff, _, name, abrv, r, g, b = getReportInfo(report[7])
					local seenReport = { }
					local handler = ""

					if (isElement(admin)) then
						local adminName = getElementData(admin, "account:username")
						handler = tostring(getPlayerName(admin)).." ("..adminName..")"
					else
						handler = "Yok."
					end
					if staff then
						for k,v in ipairs(staff) do
							if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) and not seenReport[i] then
								outputChatBox("[-]#f9f9f9 Rapor "..abrv.."#" .. tostring(i) .. ": '" .. tostring(getPlayerName(reporter)) .. "' şikayet ediyor '" .. tostring(getPlayerName(reported)) .. "' saat " .. timestring .. ". Okuyan: " .. handler .. "", thePlayer, r, g, b,true)
								count = count + 1
								seenReport[i] = true
							end
						end
					end
				end
			end

			if count == 0 then
				outputChatBox("[-]#f9f9f9 Yok.", thePlayer, 255, 228, 94,true)
			else
				--outputChatBox("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~", thePlayer, 255, 221, 117)
				--outputChatBox("Type /ri [id] to obtain more information about the report.", thePlayer, 255, 228, 94)
			end
		end
	end
end
addCommandHandler("reports", showReports, false, false)

function updateStaffReportCount(thePlayer)
	local adminreports = getElementData(thePlayer, "adminreports")
	adminreports = adminreports + 1
	exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "adminreports", adminreports, false)
end

function saveReportCount()
	local adminreports = getElementData(source, "adminreports")
	if tonumber(adminreports) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports`='"..adminreports.."' WHERE `id` = " .. (getElementData( source, "account:id" )) )	
	end

	local adminreports_saved = getElementData(source, "adminreports_saved")
	if tonumber(adminreports_saved) then
		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `adminreports_saved`='"..adminreports_saved.."' WHERE `id` = " .. (getElementData( source, "account:id" )) )
	end
end
addEventHandler("onPlayerQuit", getRootElement(), saveReportCount)

function getSavedReports(thePlayer)
	local adminreports_saved = getElementData(thePlayer, "adminreports_saved") or 0
	outputChatBox(" You have saved "..adminreports_saved.." reports. "..reportsToAward-adminreports_saved.." more to a reward!", thePlayer, 255, 126, 0)
end
addCommandHandler("getsavedreports", getSavedReports)

function setSavedReports(thePlayer, cmd, reports)
	if getElementData(thePlayer, "account:id") ~= 1 then
		return false
	end
	if reports and tonumber(reports) and tonumber(reports) >=0 then
		reports = tonumber(reports)
	else
		reports = 0
	end
	exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "adminreports_saved", reports , false)
	outputChatBox(" You have set saved report count to "..reports..".", thePlayer, 255, 126, 0)
end
addCommandHandler("setsavedreports", setSavedReports)

function updateVeri(thePlayer)
local dbid = getElementData(thePlayer, "account:id")
local r = getElementData(thePlayer, "adminreports")
local guncelle = dbExec(mysql:getConnection(), "UPDATE accounts SET adminreports='"..(r).."' WHERE id='" .. dbid .. "'")
end
addCommandHandler("raporum", updateVeri)