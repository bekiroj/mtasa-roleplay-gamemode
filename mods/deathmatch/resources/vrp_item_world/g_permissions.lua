mysql = exports.vrp_mysql
anticheat = exports.vrp_anticheat
items = exports['vrp_items']
itemtexture = exports['vrp_item_texture']
global = exports.vrp_global
integration = exports.vrp_integration

function canEditItemProperties(thePlayer, object)
	if not object then return false end
	local interiorID = getElementDimension(object)
	if exports.vrp_global:hasItem(localPlayer, 4, interiorID) or exports.vrp_global:hasItem(localPlayer, 5, interiorID) or (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) and exports.vrp_global:isAdminOnDuty(thePlayer)) or exports.vrp_integration:isPlayerScripter(thePlayer) then
		return true
	end
	return false
end
permissionTypes = {
	--name, id, hasData
	{"No-one", 0, false},
	{"Everyone", 1, false},
	{"Interior key holders", 2, false},
	{"Admin only", 3, false},
	--{"Factions", 4, true},
	--{"Characters", 5, true},
	{"Interior owner", 6, false},
	{"Item placer", 7, false},
	--{"Exciter Query String", 8, true},
}
function getPermissionTypeIDFromName(name)
	for k,v in ipairs(permissionTypes) do
		if name == v[1] then
			return v[2]
		end
	end
	return false
end

function can(player, action, element)
	if not action or not element or not player then return false end
	local perm = getPermissions(element)
	if not perm then return false end
	local usePerm, useData
	if action == "use" then
		usePerm = perm.use
		useData = perm.useData
	elseif action == "move" then
		usePerm = perm.move
		useData = perm.moveData
	elseif action == "pickup" then
		usePerm = perm.pickup
		useData = perm.pickupData
	else
		return false
	end
	if usePerm == 0 then --no-one
		return false
	elseif usePerm == 1 then --everyone
		return true
	elseif usePerm == 2 then --interior/property owner
		local dimension = getElementDimension(element)
		if global:hasItem(player, 4, dimension) or global:hasItem(player, 5, dimension) then
			return true
		end
	elseif usePerm == 3 then --admin only
		if (integration:isPlayerAdmin(player) and global:isAdminOnDuty(player)) then
			return true
		end
	elseif usePerm == 4 then --factions
		local playerFaction = tonumber(getElementData(player, "faction")) or 0
		for k,v in ipairs(useData) do
			if v == playerFaction then
				return true
			end
		end
	elseif usePerm == 5 then --char names
		local playerFaction = tonumber(getElementData(player, "faction")) or 0
		for k,v in ipairs(useData) do
			if v == playerFaction then
				return true
			end
		end
	elseif usePerm == 6 then --interior owner
		local thisInterior = getElementDimension(element)
		local interiorElement = getElementByID("int"..tostring(thisInterior))
		if interiorElement and isElement(interiorElement) then
			local interiorData = getElementData(interiorElement, "status")
			local interiorOwner = tonumber(interiorData[4])
			if interiorOwner and interiorOwner > 0 then
				local thisCharacterID = tonumber(getElementData(player, "dbid"))
				if thisCharacterID then
					if thisCharacterID == interiorOwner then
						return true
					end
				end
			end
		end
	elseif usePerm == 7 then --item placer
		local creator = tonumber(getElementData(element, "creator"))
		if creator then
			local charid = tonumber(getElementData(player, "dbid"))
			if charid then
				if charid == creator then
					return true
				end
			end
		end
	elseif usePerm == 8 then --query string
		local querystring = useData[1]
		if not querystring then return false end
		querystring = tostring(querystring)
		local thePlayer = player
		local tempAccess = split(querystring, " AND ")
		local badges = exports["vrp_items"]:getBadges()
		--outputDebugString("badges:"..tostring(badges).." ("..tostring(#badges)..")")
		local count = 0
		for _, itemID in ipairs(tempAccess) do
			local orString = split(itemID, " OR ")
			if(#orString > 1) then
				--outputDebugString("or alternatives found")
				local countOr = 0
				for k, v in ipairs(orString) do
					local theItem = split(orString[k], "=")
					if isNumeric(theItem[1]) then --if number, then treat it as a itemID
						local hasItem, key, value2, value3 = exports.vrp_global:hasItem(thePlayer, tonumber(theItem[1]))
						if hasItem then
							--outputDebugString("has item")
							if theItem[2] then
								--outputDebugString("value match requested")
								--outputDebugString(tostring(value2).." == "..tostring(theItem[2]))
								--if(tostring(value2) == tostring(theItem[2])) then
								if(isNumeric(theItem[2])) then theItem[2] = tonumber(theItem[2]) else theItem[2] = tostring(theItem[2]) end
								--outputDebugString(tostring(exports['item-system']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])))
								if(tonumber(exports['vrp_items']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])) > 0) then
									countOr = countOr + 1
									--outputDebugString("has value, +1")
								end
							else
								--outputDebugString("badges["..tostring(theItem[1]).."] = "..tostring(badges[theItem[1]]))
								--if badges[theItem[1]] then
								--if exports["item-system"]:isBadge(theItem[1]) then
									--if(getElementData(thePlayer, badges[theItem[1]][1])) then
									--if exports["item-system"]:isWearingBadge(thePlayer, theItem[1]) then
									--	countOr = countOr + 1
										--outputDebugString("badge on, +1")
									--end
								--else
									countOr = countOr + 1
									--outputDebugString("has item, +1")
								--end
							end						
						end
					else --if not numeric, check the text value agains the special conditions
						local textFunction = tostring(theItem[1])
						if textFunction == "PILOT" then --check for pilot licenses
							local pilotlicenses = exports['vrp_mdc']:getPlayerPilotLicenses(thePlayer) or {}
							if theItem[2] then --if a value is specified
								local requireLicense = split(theItem[2], "-")
								if isNumeric(requireLicense[1]) then --if value is number, check against license IDs
									for licenseKey, licenseValue in ipairs(pilotlicenses) do
										if licenseValue[1] == tonumber(requireLicense[1]) then
											if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then --if a second value is specified, also match typerating
												if tonumber(requireLicense[2]) == licenseValue[2] then
													countOr = countOr + 1
												end
											else
												countOr = countOr + 1
											end
										end
									end
								else --if not number, check against license names
									for licenseKey, licenseValue in ipairs(pilotlicenses) do
										if tostring(licenseValue[3]) == tostring(requireLicense[1]) then
											if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then --if a second value is specified, also match typerating
												if tonumber(requireLicense[2]) == licenseValue[2] then
													countOr = countOr + 1
												end
											else
												countOr = countOr + 1
											end
										end
									end
								end
							else --if no value
								if #pilotlicenses > 0 then
									--check if player has one of the following licenses: ROT, SER (the lowest pilot licenses that any pilot will have also if they have higher ratings)
									for licenseKey,licenseValue in ipairs(pilotlicenses) do
										if licenseValue[1] == 3 or licenseValue[1] == 4 then
											countOr = countOr + 1
											break
										end
									end
								end
							end
						elseif textFunction == "F" or textFunction == "FACTION" then --check for faction membership
							if theItem[2] then --if a value is specified
								local checkFaction = split(theItem[2], "-")
								if isNumeric(checkFaction[1]) then --if it is a number, we're checking for faction ID
									if isNumeric(checkFaction[2]) then --if faction rank is specified and is a number (valid)
										if exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2])) then
											countOr = countOr + 1
										end
									else
										if exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1])) then
											countOr = countOr + 1
										end
									end
								else --if not a number, we're checking for faction name
									local checkFactionName = tostring(theItem[2]) --we cant check ranks on faction names, since the names may contain '-'
									local factionID = exports.vrp_factions:getFactionIDFromName(checkFactionName)
									if factionID then
										if exports.vrp_factions:isPlayerInFaction(thePlayer, factionID) then
											countOr = countOr + 1
										end
									end
								end
							end
						elseif textFunction == "FL" or textFunction == "FACTIONLEADER" then --check for faction leadership
							if theItem[2] then --if a value is specified
								local checkFaction = split(theItem[2], "-")
								if isNumeric(checkFaction[1]) then --if it is a number, we're checking for faction ID
									if isNumeric(checkFaction[2]) then --if faction rank is specified and is a number (valid)
										local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2]))
										if isMember and isLeader then
											countOr = countOr + 1
										end
									else
										local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]))
										if isMember and isLeader then
											countOr = countOr + 1
										end
									end
								else --if not a number, we're checking for faction name
									local checkFactionName = tostring(theItem[2]) --we cant check ranks on faction names, since the names may contain '-'
									local factionID = exports.vrp_factions:getFactionIDFromName(checkFactionName)
									if factionID then
										local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, factionID)
										if isMember and isLeader then
											countOr = countOr + 1
										end
									end
								end
							end
						end
					end
				end
				if(countOr > 0) then
					count = count + 1
				end
			else
				local theItem = split(orString[1], "=")
				if isNumeric(theItem[1]) then --if number, then treat it as a itemID
					local hasItem, key, value2, value3 = exports.vrp_global:hasItem(thePlayer, tonumber(theItem[1]))
					if hasItem then
						if theItem[2] then
							if(isNumeric(theItem[2])) then theItem[2] = tonumber(theItem[2]) else theItem[2] = tostring(theItem[2]) end
							--outputDebugString(tostring(exports['item-system']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])))
							if(tonumber(exports['vrp_items']:countItems(thePlayer, tonumber(theItem[1]), theItem[2])) > 0) then
								count = count + 1
							end
							--if(tonumber(value2) == tonumber(theItem[2])) then
							--	count = count + 1
							--end
						else
							--[[
							if badges[itemID] then
								if(getElementData(thePlayer, badges[itemID][1])) then
									count = count + 1
								end
							else
								count = count + 1
							end
							--]]
							count = count + 1
						end
					end
				else --if not numeric, check the text value agains the special conditions
					local textFunction = tostring(theItem[1])
					if textFunction == "PILOT" then --check for pilot licenses
						local pilotlicenses = exports['vrp_mdc']:getPlayerPilotLicenses(thePlayer) or {}
						if theItem[2] then --if a value is specified
							local requireLicense = split(theItem[2], "-")
							if isNumeric(requireLicense[1]) then --if value is number, check against license IDs
								for licenseKey, licenseValue in ipairs(pilotlicenses) do
									if licenseValue[1] == tonumber(requireLicense[1]) then
										if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then --if a second value is specified, also match typerating
											if tonumber(requireLicense[2]) == licenseValue[2] then
												count = count + 1
											end
										else
											count = count + 1
										end
									end
								end
							else --if not number, check against license names
								for licenseKey, licenseValue in ipairs(pilotlicenses) do
									if tostring(licenseValue[3]) == tostring(requireLicense[1]) then
										if licenseValue[1] == 7 and requireLicense[2] and tonumber(requireLicense[2]) then --if a second value is specified, also match typerating
											if tonumber(requireLicense[2]) == licenseValue[2] then
												count = count + 1
											end
										else
											count = count + 1
										end
									end
								end
							end
						else --if no value
							if #pilotlicenses > 0 then
								--check if player has one of the following licenses: ROT, SER (the lowest pilot licenses that any pilot will have also if they have higher ratings)
								for licenseKey,licenseValue in ipairs(pilotlicenses) do
									if licenseValue[1] == 3 or licenseValue[1] == 4 then
										count = count + 1
										break
									end
								end
							end
						end
					elseif textFunction == "F" or textFunction == "FACTION" then --check for faction membership
						if theItem[2] then --if a value is specified
							local checkFaction = split(theItem[2], "-")
							if isNumeric(checkFaction[1]) then --if it is a number, we're checking for faction ID
								if isNumeric(checkFaction[2]) then --if faction rank is specified and is a number (valid)
									if exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2])) then
										count = count + 1
									end
								else
									if exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1])) then
										count = count + 1
									end
								end
							else --if not a number, we're checking for faction name
								local checkFactionName = tostring(theItem[2]) --we cant check ranks on faction names, since the names may contain '-'
								local factionID = exports.vrp_factions:getFactionIDFromName(checkFactionName)
								if factionID then
									if exports.vrp_factions:isPlayerInFaction(thePlayer, factionID) then
										count = count + 1
									end
								end
							end
						end
					elseif textFunction == "FL" or textFunction == "FACTIONLEADER" then --check for faction leadership
						if theItem[2] then --if a value is specified
							local checkFaction = split(theItem[2], "-")
							if isNumeric(checkFaction[1]) then --if it is a number, we're checking for faction ID
								if isNumeric(checkFaction[2]) then --if faction rank is specified and is a number (valid)
									local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]), tonumber(checkFaction[2]))
									if isMember and isLeader then
										count = count + 1
									end
								else
									local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, tonumber(checkFaction[1]))
									if isMember and isLeader then
										count = count + 1
									end
								end
							else --if not a number, we're checking for faction name
								local checkFactionName = tostring(theItem[2]) --we cant check ranks on faction names, since the names may contain '-'
								local factionID = exports.vrp_factions:getFactionIDFromName(checkFactionName)
								if factionID then
									local isMember, rank, isLeader = exports.vrp_factions:isPlayerInFaction(thePlayer, factionID)
									if isMember and isLeader then
										count = count + 1
									end
								end
							end
						end
					end
				end
			end
		end
		--outputDebugString("#tempAccess:"..tostring(#tempAccess).." count:"..tostring(count))
		if(#tempAccess == count) then
			return true
		end
		
		return false
	end
	return false
end

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function isNumeric(a)
	if tonumber(a) ~= nil then return true else return false end
end