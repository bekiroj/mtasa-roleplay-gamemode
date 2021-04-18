function getInteriorsOwnedByCharacter(thePlayer)
	local dbid = tonumber(getElementData(thePlayer, "dbid"))
	
	local intids = { }
	local numints = 0

	for key, value in ipairs(getElementsByType("interior")) do
		local owner = tonumber(getElementData(value, "status")[4])

		if (owner) and (owner==dbid) then
			local id = getElementData(value, "dbid")
			intids[numints+1] = id
			numints = numints + 1
		end
	end
	return numints, intids
end

function canPlayerBuyInterior(thePlayer)
	if (isElement(thePlayer)) then
		if getElementData(thePlayer, "loggedin") == 1 then
			local maxinteriors = getElementData(thePlayer, "maxinteriors") or 0
			local noInteriors, intArray = getInteriorsOwnedByCharacter(thePlayer)
			if (noInteriors < maxinteriors) then
				return true
			end
			return false, "Too much interiors." 
			
		end
		return false, "Player not logged in"
	end
	return false, "Element not found"
end

function getInteriorsOwnByFaction(theFaction) -- bekiroj
	local ints = {}
	local factionId = getElementData(theFaction, "id")
	local possibleInteriors = exports.vrp_pool:getPoolElementsByType("interior")
	for key, interior in pairs(possibleInteriors) do
		if getElementData(interior, "status")[7] == factionId then
			table.insert(ints, interior)
		end
	end
	return ints
end

function canPlayerFactionBuyInterior(thePlayer, cost) -- Maxime
	local factionId = getElementData(thePlayer, "faction")
	local theFaction = exports.vrp_pool:getElement("team", factionId)

	local can, reason = canFactionBuyInterior(theFaction, cost)
	if not can then
		return can, reason
	end

	local hasSpace = hasSpaceForItem(thePlayer, 4 or 5, 1)
	if not hasSpace then
		return false, "You do not have the space for the keys."
	end
	return theFaction
end

function canFactionBuyInterior(theFaction, cost) -- Maxime
	if not theFaction then
		return false, "Faction not found."
	end

	local max_interiors = getElementData(theFaction, "max_interiors") or 15
	local cur = #getInteriorsOwnByFaction(theFaction)
	--outputDebugString(cur)
	--outputDebugString(max_interiors)
	if cur >= max_interiors then
		return false, getTeamName(theFaction).." has already reached the maximum number of interiors ("..cur.."/"..max_interiors..")."
	end

	if cost and tonumber(cost) then
		local hasMoney = hasMoney(theFaction, cost)
		if not hasMoney then
			return hasMoney, getTeamName(theFaction).." lacks of money to buy this property."
		end
	end
	return theFaction
end