function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
	removePedFromVehicle(player)
	setElementData(player, "realinvehicle", 0, false)

	return triggerClientEvent(player,"doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
	return triggerClientEvent(player,"doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecamTV:state")
end
-- bekiroj's rework
function asyncActivateFreecam ()
	if not isEnabled(source) then
		outputDebugString("[FREECAM] asyncActivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 0)
		setElementFrozen(source, true)
		if not exports.vrp_integration:isPlayerTrialAdmin(source) then
			exports.vrp_global:sendMessageToAdmins("[FREECAM] "..exports.vrp_global:getAdminTitle1(source).." has activated temporary /freecam.")
		end
		setElementData(source, "freecam:state", true, false)
		exports.vrp_logs:dbLog(source, 4, {source}, "FREECAM")
	end
end
addEvent("freecam:asyncActivateFreecam", true)
addEventHandler("freecam:asyncActivateFreecam", root, asyncActivateFreecam)

function asyncDeactivateFreecam ()
	if true or isEnabled(source) then
		outputDebugString("[FREECAM] asyncDeactivateFreecam / Ran")
		removePedFromVehicle(source)
		setElementAlpha(source, 255)
		setElementFrozen(source, false)
		setElementData(source, "freecam:state", false, false)
	end
end
addEvent("freecam:asyncDeactivateFreecam", true)
addEventHandler("freecam:asyncDeactivateFreecam", root, asyncDeactivateFreecam)

-- Default position on start of the resource
local x = 1662.669921875
local y = -1646.29296875
local z = 87.375
local int = 0
local dim = 0

--
local LSN_MONEY = 20

-- Some variables needed
local marker = nil
local cameraRadius = 15

function setPlayerFreecamEnabled(player)
	if not isPlayerFreecamEnabled(player) then
		removePedFromVehicle(player)
		setElementData(player, "realinvehicle", 0, false)

		setElementAlpha(player, 0)
		setElementData(player, "reconx", true)

		local startX, startY, startZ = getElementPosition(player)
		setElementData(player, "tv:dim", getElementDimension(player), false)
		setElementData(player, "tv:int", getElementInterior(player), false)
		setElementData(player, "tv:x", startX, false)
		setElementData(player, "tv:y", startY, false)
		setElementData(player, "tv:z", startZ, false)
		setElementDimension(player, dim)
		setElementInterior(player, int)

		return triggerClientEvent(player,"doSetFreecamEnabledTV", getRootElement(), x,y,z, false)
	else
		return false
	end
end

function moveCamera(newx, newy, newz, newint, newdim)
	if (marker) then
		destroyElement(marker)
	end
	marker = createMarker( newx, newy, newz, 'corona', 4, 255, 127, 0, 127)
	setElementInterior(marker, newint)
	setElementDimension(marker, 65535)
	
	x = newx
	y = newy
	z = newz
	int = newint
	dim = newdim
	return true
end

-- Move to the default position
moveCamera(x, y, z, int, dim)

function setPlayerFreecamDisabled(player)
	if isPlayerFreecamEnabled(player) then
		setElementDimension(player, getElementData(player, "tv:dim"))
		setElementInterior(player, getElementData(player, "tv:int"))
		setElementAlpha(player, 255)
		removeElementData(player, "reconx", true)
		
		return triggerClientEvent(player,"doSetFreecamDisabledTV", getRootElement(), false)
	else
		return false
	end
end

function setPlayerFreecamOption(player, theOption, value)
	return triggerClientEvent(player,"doSetFreecamOptionTV", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
	return getElementData(player,"freecamTV:state")
end



-- 

local earnings = 0
local watching = 0

--

function tv(player)
	local hasTV = exports.vrp_global:hasItem(player, 104, 1)
	local getDim = getElementDimension(player)
	if not getElementData(localPlayer, "adminjailed") and hasTV or (getDim > 0) or isPlayerFreecamEnabled(player) then
		if isPlayerFreecamEnabled(player) then
			setPlayerFreecamDisabled(player)
		elseif getCameraTarget(player) ~= player then
			outputChatBox("Can't put you into TV mode at the moment.", player, 255, 0, 0)
		elseif isTVRunning() then
			setPlayerFreecamEnabled(player)
		else
			outputChatBox("Herhangi bir aktif kanal yok.", player, 255, 194, 14)
		end
	else
		outputChatBox("Etrafinda televizyon yok.", player, 255, 194, 14)
	end
end
addCommandHandler("tv", tv)
addEvent("useTV", true)
addEventHandler("useTV", getRootElement(), tv)

addCommandHandler("movetv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if isTVRunning() then
				outputChatBox("Zaten televizyonu izliyorsun!", player, 255, 0, 0)
			else
				-- I like to ... move it!
				local posX, posY, posZ = getElementPosition(player)
				local posDim = getElementDimension(player)
				local posInt = getElementInterior(player)
				if moveCamera(posX, posY, posZ + 1, posInt, posDim) then
					for k, v in ipairs( getElementsByType( "player" ) ) do
						if getElementData(v, "faction") == 20 then
							outputChatBox("[BBC] ".. getPlayerName(player):gsub("_", " ") .. " kamera pozisyonunu degistirdi.", v, 200, 100, 200)
						end
					end
				else
					outputChatBox("Hata!", player, 255, 0,0)
				end
			end
		end
	end
)

addCommandHandler("starttv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if not isTVRunning() then
				outputChatBox("[BBC] " .. getPlayerName(player):gsub("_", " ") .. " televizyon yayinini baslatti (( /tv yazarak izle ))", getRootElement( ), 200, 100, 200)
				exports.vrp_logs:dbLog(player, 23, player, "TV START")
				watching = 0
				earnings = 0
				setElementDimension(marker, dim)
			else
				outputChatBox("Televizyonu zaten izliyorsun.", player, 255, 0, 0)
			end
		end
	end
)

addCommandHandler("endtv",
	function(player)
		if getElementData(player, "faction") == 20 then
			if isTVRunning() then
				setElementDimension(marker, 65535)
				outputChatBox("[BBC] " .. getPlayerName(player):gsub("_", " ") .. " televizyon yayinini durdurdu!.", getRootElement( ), 200, 100, 200)
				
				for k, v in ipairs( getElementsByType( "player" ) ) do
					if isPlayerFreecamEnabled(v) then
						setPlayerFreecamDisabled(v)
					end
					
					if getElementData(v, "faction") == 20 then
						outputChatBox("[BBC] Max. İzleyiciler: " .. watching .. ", Bağışlar: $" .. exports.vrp_global:formatMoney(earnings), v, 200, 100, 200)
					end
				end
				
				exports.vrp_logs:dbLog(player, 23, player, "BBC STOP - VIEWERS: " .. watching .. " EARNINGS: " .. earnings)
			else
				outputChatBox("Aktif kanal yok!", player, 255, 0, 0)
			end
		end
	end
)

addCommandHandler("watchers",
	function(player)
		if getElementData(player, "faction") == 20 then
			if isTVRunning() then
				local count = 0
				for k, v in ipairs( getElementsByType( "player" ) ) do
					if isPlayerFreecamEnabled(v) then
						count = count + 1
					end
				end
				
				outputChatBox("[BBC] İzleyiciler: " .. count .. " televizyonda.", player, 200, 100, 200)
				outputChatBox("[BBC] Max. İzleyiciler: " .. watching .. ", Kazanç: $" .. exports.vrp_global:formatMoney(earnings), player, 200, 100, 200)
			else
				outputChatBox("Aktif TV Yayını yok.", player, 255, 0, 0)
			end
		end
	end
)

function isTVRunning()
	return getElementDimension(marker) ~= 65535
end

--[[
function isPlayerInCameraRadius(sourceplayer)
	local x,y,z = getElementPosition(sourceplayer)  
	local xx, xy, xz = getElementPosition(marker) 
	if (getDistanceBetweenPoints2D ( x, y, xx, xy ) < 15) then
		return true
	end
	return false
end
]]

isPlayerInCameraRadius = isPlayerFreecamEnabled

function add( affectedPlayers )
	if type(affectedPlayers) ~= 'table' then
		return
	end

	local shownto = 0
	for i, player in ipairs(affectedPlayers) do
		if type(player) == 'userdata' and isPlayerFreecamEnabled(player) then
			shownto = shownto + 1
		end
	end

	if isTVRunning() and shownto > 0 then
		watching = math.max( shownto, watching )
		earnings = earnings + LSN_MONEY * shownto
		
		exports.vrp_global:giveMoney(getTeamFromName"BBC News", LSN_MONEY * shownto)
		--exports.vrp_logs:dbLog(player, 23, player, "TV $" .. ( 10 * shownto ) .. " " .. message)
	else
		--exports.vrp_logs:dbLog(player, 23, player, "TV OFF " .. message)
	end
end