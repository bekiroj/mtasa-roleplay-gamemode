
--give player license
function givePlayerLicense(thePlayer, commandName, targetPlayerName, licenseType)
	if exports.vrp_integration:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2" or licenseType == "3" or licenseType == "4" or licenseType == "5") or licenseType == "6" or licenseType == "7" or licenseType == "8" or licenseType == "9" or licenseType == "10" or licenseType == "11" or licenseType == "12" or licenseType == "13") then
			outputChatBox("Kullanım:#f9f9f9 /" .. commandName .. " [Karakter Adı & ID] [Tip]", thePlayer, 255, 194, 14, true)
			outputChatBox("Tip 1 = Araç Ehliyeti", thePlayer, 255, 194, 14)
			outputChatBox("Tip 2 = Motosiklet Ehliyeti", thePlayer, 255, 194, 14)
			outputChatBox("Tip 3 = Tekne Ehliyeti", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			local username = getPlayerName(thePlayer)
			local user = getElementData(thePlayer, "account:username")

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local name = getPlayerName(targetPlayer):gsub("_", " ")

				if (logged==0) then
					outputChatBox("Kullanıcı oyunda degil.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if licenseType == "1" then licenseTypeOutput = "Drivers License"	licenseType = "car" end
					if licenseType == "2" then licenseTypeOutput = "Motorcycle License"	licenseType = "bike" end
					if licenseType == "3" then licenseTypeOutput = "Boating License"	licenseType = "boat" end
					if licenseType == "11" then licenseTypeOutput = "Fishing Permit"	licenseType = "fish" end
					if licenseType == "12" then licenseTypeOutput = "Tier 1 F/A License"	licenseType = "gun" end
					if licenseType == "13" then licenseTypeOutput = "Tier 2 F/A License"	licenseType = "gun2" end


					if getElementData(targetPlayer, "license."..licenseType) == 1 then
						outputChatBox(getPlayerName(thePlayer).." has already a "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "car") then -- DRIVERS LICENSE
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='1' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")

							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE CAR")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a drivers license.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "bike") then -- BIKE LICENSE
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='1' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")

							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE BIKE")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a motorcycle license.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "boat") then -- BOATING LICENSE
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='1' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")

							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE BOAT")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a boating license.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "fish") then -- BOATING LICENSE
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 1, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='1' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")

							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." gives you a "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVELICENSE FISH")
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " gave " .. targetPlayerName .. " a fishing permit.")
							else
								outputChatBox("Player "..targetPlayerName.." now has a "..licenseTypeOutput.." license.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "gun") then
							if exports.vrp_integration:isPlayerAdmin(thePlayer) then
								outputChatBox("Please use /weaponlicenses.", thePlayer)
							else
								outputChatBox("You are not allowed to spawn Tier 1 licenses.", thePlayer, 255, 0, 0)
							end
						elseif (licenseType == "gun2") then
							if exports.vrp_integration:isPlayerAdmin(thePlayer) then
								outputChatBox("Please use /weaponlicenses.", thePlayer)
							else
								outputChatBox("You are not allowed to spawn Tier 2 licenses.", thePlayer, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("agivelicense", givePlayerLicense)
addCommandHandler("agl", givePlayerLicense)
addCommandHandler("givelicense", givePlayerLicense)

--take player license
function takePlayerLicense(thePlayer, commandName, dtargetPlayerName, licenseType)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		if not dtargetPlayerName or not (licenseType and (licenseType == "1" or licenseType == "2" or licenseType == "3" or licenseType == "4" or licenseType == "5" or licenseType == "6" or licenseType == "7")) then
			outputChatBox("* Valhalla * /" .. commandName .. " [Player Nick] [Type]", thePlayer, 255, 194, 14)
			outputChatBox("Type 1 = Drivers License", thePlayer, 255, 194, 14)
			outputChatBox("Type 2 = Motorcycle License", thePlayer, 255, 194, 14)
			outputChatBox("Type 3 = Boating License", thePlayer, 255, 194, 14)
			--outputChatBox("Type 4 = Pilots License (Any)", thePlayer, 255, 194, 14)
			outputChatBox("Type 5 = Fishing Permit", thePlayer, 255, 194, 14)
			outputChatBox("Type 6 = Tier 1 F/A", thePlayer, 255, 194, 14)
			outputChatBox("Type 7 = Tier 2 F/A", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(nil, dtargetPlayerName)
			local username = getPlayerName(thePlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					if licenseType == "1" then licenseTypeOutput = "Drivers License"	licenseType = "car" end
					if licenseType == "2" then licenseTypeOutput = "Motorcycle License"	licenseType = "bike" end
					if licenseType == "3" then licenseTypeOutput = "Boating License"	licenseType = "boat" end
					--if licenseType == "4" then licenseTypeOutput = "Pilots License"	licenseType = "pilot" end
					if licenseType == "5" then licenseTypeOutput = "Fishing Permit"	licenseType = "fish" end
					if licenseType == "6" then licenseTypeOutput = "Tier 1 F/A License"	licenseType = "gun" end
					if licenseType == "7" then licenseTypeOutput = "Tier 2 F/A License"	licenseType = "gun2" end
					if getElementData(targetPlayer, "license."..licenseType) == 0 then
						outputChatBox(getPlayerName(thePlayer).." has no "..licenseTypeOutput.." license.", thePlayer, 255, 255, 0)
					else
						if (licenseType == "car") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE CAR")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "bike") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "boat") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "fish") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "gun") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						elseif (licenseType == "gun2") then
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "license."..licenseType, 0, false)
							dbExec(mysql:getConnection(), "UPDATE characters SET "..(licenseType).."_license='0' WHERE id = "..(getElementData(targetPlayer, "dbid")).." LIMIT 1")
							outputChatBox("Admin "..getPlayerName(thePlayer):gsub("_"," ").." revokes your "..licenseTypeOutput.." license.", targetPlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKELICENSE GUN2")

							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							if (hiddenAdmin==0) then
								local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. targetPlayerName .. " "..licenseTypeOutput.." license.")
							else
								outputChatBox("Player "..targetPlayerName.." now  has their  "..licenseTypeOutput.." license revoked.", thePlayer, 0, 255, 0)
							end
						end
					end
				end
			else
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							resultSet = res[1]
							if resultSet then
								licenseType = licenseType == "1" and "car" or "gun" or "gun2"
								if (tonumber(resultSet[licenseType.."_license"]) ~= 0) then
									local resultQry = dbExec(mysql:getConnection(), "UPDATE `characters` SET `"..licenseType.."_license`=0 WHERE `charactername`='"..(dtargetPlayerName).."'")
									if (resultQry) then
										exports.vrp_logs:dbLog(thePlayer, 4, { "ch"..resultSet["id"] }, "TAKELICENSE "..licenseType)
										local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
										if (hiddenAdmin==0) then
											local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
											exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " revoked " .. dtargetPlayerName .. " his ".. licenseType .." license.")
										else
											outputChatBox("Player "..dtargetPlayerName.." now  has his  "..licenseType.." license revoked.", thePlayer, 0, 255, 0)
										end
									else
										outputChatBox("Wups, atleast something went wrong there..", thePlayer, 255, 0, 0)
									end
								else
									outputChatBox("The player doesn't have this license.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox("No player found.", thePlayer, 255, 0, 0)
							end
						end
					end,
				mysql:getConnection(), "SELECT `id`,`car_license`,`gun_license`,`gun2_license` FROM `characters` where `charactername`='"..(dtargetPlayerName).."'")
				
			end
		end
	end
end
addCommandHandler("atakelicense", takePlayerLicense)
addCommandHandler("atl", takePlayerLicense)
addCommandHandler("takelicense", takePlayerLicense)

