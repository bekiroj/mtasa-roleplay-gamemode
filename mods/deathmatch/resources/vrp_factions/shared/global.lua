
function isPlayerInFaction(thePlayer, factionID, rank) --returns isMember, rankID, isLeader
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local myRank = tonumber(getElementData(thePlayer, "factionrank")) or 0
		local amLeader = tonumber(getElementData(thePlayer, "factionleader")) or 0
		local isLeader = false
		if amLeader == 1 then
			isLeader = true
		end
		if rank then
			rank = tonumber(rank) or -1
			if rank == myRank then
				return true, myRank, isLeader
			end
		else
			return true, myRank, isLeader
		end
	end
	return false, false, false
end

function getPlayerFactionRank(thePlayer, factionID) --returns rank if member of factionID, false otherwise
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local myRank = tonumber(getElementData(thePlayer, "factionrank")) or 0
		return myRank
	end
	return false
end

function isPlayerFactionLeader(thePlayer, factionID) --returns boolean
	if not thePlayer or not factionID then return false end
	factionID = tonumber(factionID) or -1
	local myFaction = tonumber(getElementData(thePlayer, "faction")) or 0
	if factionID == myFaction then
		local amLeader = tonumber(getElementData(thePlayer, "factionleader")) or 0
		local isLeader = false
		if amLeader == 1 then
			isLeader = true
		end
		return isLeader
	end
	return false
end
