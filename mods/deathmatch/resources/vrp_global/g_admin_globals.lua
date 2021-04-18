function getAdminTitles()
	return exports.vrp_integration:getAdminTitles()
end

function getAdmins()
	local players = exports.vrp_pool:getPoolElementsByType("player")

	local admins = { }

	for key, value in ipairs(players) do
		if exports.vrp_integration:isPlayerTrialAdmin(value) then
			table.insert(admins,value)
		end
	end
	return admins
end

function getPlayerAdminLevel(thePlayer)
	return (isElement( thePlayer ) and getElementData(thePlayer, "admin_level")) or 0
end

function getPlayerAdminTitle(thePlayer)
	if isElement(thePlayer) then
		if exports.vrp_integration:isPlayerIA( thePlayer ) then
			return "Internal Affairs"
		end
		if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
			local adminTitles = getAdminTitles()
			local text = adminTitles[getPlayerAdminLevel(thePlayer)] or "Player"

			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin") or 0
			if (hiddenAdmin==1) then
				text = text .. " (Gizli)"
			end

			return text
		elseif exports.vrp_integration:isPlayerSupporter(thePlayer) then
			return "Rehber"
		elseif exports.vrp_integration:isPlayerLeadScripter(thePlayer) then
			return "Scripter"
		elseif exports.vrp_integration:isPlayerScripter(thePlayer) then
			return "Trial Scripter"
		elseif exports.vrp_integration:isPlayerVCTMember(thePlayer) then
			return "Vehicle Consultation Member"
		elseif exports.vrp_integration:isPlayerVehicleConsultant(thePlayer) then
			return "Vehicle Consultation Leader"
		elseif exports.vrp_integration:isPlayerMappingTeamMember(thePlayer) then
			return "Mapper"
		else
			return "Player"
		end
	end
end

--[[ GM ]]--
function getGameMasters()
	local players = exports.vrp_pool:getPoolElementsByType("player")
	local gameMasters = { }
	for key, value in ipairs(players) do
		if exports.vrp_integration:isPlayerSupporter(value) then
			table.insert(gameMasters, value)
		end
	end
	return gameMasters
end

--[[ /GM ]]--

local scripters = {
}

local lvl2scripters = {

}

local internalaffairs = {

}

function isPlayerLvl2Scripter(thePlayer)
	return lvl2scripters[thePlayer] or lvl2scripters[ getElementData(thePlayer, "account:username") or "bekiroj" ] or false
end

function isPlayerIA(thePlayer)
	return internalaffairs[thePlayer] or internalaffairs[ getElementData(thePlayer, "account:username") or "bekiroj" ] or false
end

function isPlayerScripter(thePlayer)
	return exports["vrp_integration"]:isPlayerScripter(thePlayer)
end

function getAdminTitle1(thePlayer)
	local adminTitles = getAdminTitles()
	local title = adminTitles[getPlayerAdminLevel(thePlayer)] or false
	local username = getElementData(thePlayer, "account:username")
	if not title then
		if exports.vrp_integration:isPlayerSupporter(thePlayer) then
			return "Rehber "..username
		else
			return "Player "..username
		end
	end
	if getElementData(thePlayer, "hiddenadmin") == 1 then
		return "Gizli Yetkili"
	else
		return title.." "..username
	end
end

function isStaffOnDuty(thePlayer)
	return isAdminOnDuty(thePlayer) or isSupporterOnDuty(thePlayer)
end

function isStaff(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)
	else
		return false
	end
end

function isAdminOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and (getElementData(thePlayer, "duty_admin") == 1)
	else
		return false
	end
end

function isSupporterOnDuty(thePlayer)
	if thePlayer and isElement(thePlayer) and getElementType(thePlayer) == "player" then
		return exports.vrp_integration:isPlayerSupporter(thePlayer) and (getElementData(thePlayer, "duty_supporter") == 1)
	else
		return false
	end
end
