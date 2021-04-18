--MAXIME / 2015.01.07
function isActive(interiorElement)
	local interiorStatus = getElementData(interiorElement, "status")
	local interiorType = interiorStatus[INTERIOR_TYPE] or 2
	local interiorOwner = interiorStatus[INTERIOR_OWNER] or 0
	local interiorFaction = interiorStatus[INTERIOR_FACTION] or 0
	local interiorDisabled = interiorStatus[INTERIOR_DISABLED] or false
	if interiorDisabled or interiorType == 2 or interiorFaction ~= 0 or interiorOwner < 1 then
		return true
	else
		local oneDay = 60*60*24
		local owner_last_login = getElementData(interiorElement, "owner_last_login")
		if owner_last_login and tonumber(owner_last_login) then
			local owner_last_login_text, owner_last_login_sec = exports.vrp_datetime:formatTimeInterval(owner_last_login)
			if owner_last_login_sec > oneDay*30 then
				return false, "Aktif değil İnterior | Sahip etkin değil ("..owner_last_login_text..")", owner_last_login_sec
			end
		end
		local lastused = getElementData(interiorElement, "lastused")
		if lastused and tonumber(lastused) then
			local lastusedText, lastusedSeconds = exports.vrp_datetime:formatTimeInterval(lastused)
			if lastusedSeconds > oneDay*14 then
				return false, "Aktif değil İnterior | Son Kullanılan "..lastusedText, lastusedSeconds
			end
		end
	end
	return true 
end

function isProtected(interiorElement)
	local interiorStatus = getElementData(interiorElement, "status")
	local interiorType = interiorStatus[INTERIOR_TYPE] or 2
	local interiorOwner = interiorStatus[INTERIOR_OWNER] or 0
	local interiorFaction = interiorStatus[INTERIOR_FACTION] or 0
	if interiorType == 2 or interiorFaction > 0  or interiorOwner < 1 then
		return false
	end
	local protected_until = getElementData(interiorElement, "protected_until") or -1
	local protectText, protectSeconds = exports.vrp_datetime:formatFutureTimeInterval(protected_until)
	return protectSeconds > 0, protectText, protectSeconds
end