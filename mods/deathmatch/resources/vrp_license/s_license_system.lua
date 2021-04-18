mysql = exports.vrp_mysql

function recoveryLicense(licensetext, cost, itemID, npcName)
	if not exports.vrp_global:takeMoney(source, cost) then
		exports.vrp_hud:sendBottomNotification(source, npcName, "Can I have $"..exports.vrp_global:formatMoney(cost).." fee for recovering the "..licensetext.." please?")
		return false
	end

	if exports.vrp_global:giveItem(source, itemID, getPlayerName(source):gsub("_", " ")) then
		exports.vrp_hud:sendBottomNotification(source, npcName, "You have paid $"..exports.vrp_global:formatMoney(cost).." fee for recovering the "..licensetext..".")
	end
end
addEvent("license:recover", true)
addEventHandler("license:recover", root, recoveryLicense)

function onLicenseServer()
	local gender = getElementData(source, "gender")
	if (gender == 0) then
		exports.vrp_global:sendLocalText(source, "Gamze Avcı diyor ki: Merhaba beyefendi, ehliyet için mi başvuracaktınız?", 255, 255, 255, 10)
	else
		exports.vrp_global:sendLocalText(source, "Gamze Avcı diyor ki: Merhaba hanfendi, ehliyet için mi başvuracaktınız?", 255, 255, 255, 10)
	end
end
addEvent("onLicenseServer", true)
addEventHandler("onLicenseServer", getRootElement(), onLicenseServer)

function payFee(amount, reason)
	if exports.vrp_global:takeMoney(source, amount) then
		if not reason then
			reason = "a license"
		end
		exports.vrp_hud:sendBottomNotification(source, "Motorlu Taşıtlar Departmanı", reason.." için $"..exports.vrp_global:formatMoney(amount).." ödediniz.")
	end
end
addEvent("payFee", true)
addEventHandler("payFee", getRootElement(), payFee)

function showLicenses(thePlayer, commandName, targetPlayer)
	--outputChatBox("This command is deprecated. Please show actual license/certificate from your inventory.", thePlayer, 255, 194, 14)
	--return false

	local loggedin = getElementData(thePlayer, "loggedin")
	if (loggedin==1) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then
					outputChatBox("Player is not logged in.", thePlayer, 255, 0, 0)
				elseif (logged==1) then
					local x, y, z = getElementPosition(thePlayer)
					local tx, ty, tz = getElementPosition(targetPlayer)

					if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>5) then -- Are they standing next to each other?
						outputChatBox("You are too far away to show your weapon license to '".. targetPlayerName .."'.", thePlayer, 255, 0, 0)
					else
						outputChatBox("You have shown your weapon licenses to " .. targetPlayerName .. ".", thePlayer, 255, 194, 14)
						outputChatBox(getPlayerName(thePlayer) .. " has shown you their weapon licenses.", targetPlayer, 255, 194, 14)

						local gunlicense = getElementData(thePlayer, "license.gun")
						local gun2license = getElementData(thePlayer, "license.gun2")

						local guns, guns2, cars, bikes, boats, pilots, fish

						if (gunlicense<=0) then
							guns = "No"
						else
							guns = "Yes"
						end

						if (gun2license<=0) then
							guns2 = "No"
						else
							guns2 = "Yes"
						end
						outputChatBox("----- " .. getPlayerName(thePlayer) .. "'s Weapon Licenses -----", targetPlayer, 255, 194, 14)
						outputChatBox("        Tier 1 Firearms License: " .. guns, targetPlayer, 255, 194, 14)
						outputChatBox("        Tier 2 Firearms License: " .. guns2, targetPlayer, 255, 194, 14)
					end
				end
			end
		end
	end

end
addCommandHandler("showlicenses", showLicenses, false, false)
