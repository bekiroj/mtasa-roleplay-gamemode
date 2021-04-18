-- Acıkma ve Susama Fonksiyonu 
addEventHandler ("onClientResourceStart",getResourceRootElement(getThisResource()),
function ()
  setTimer (azaltAcikma,250000,0,getLocalPlayer())
  setTimer (azaltSusuzluk,250000,0,getLocalPlayer())
end)

setTimer(function(player)
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerHunger(getLocalPlayer()) <= 0) and getElementData(getLocalPlayer(), "dead") == 0 then
			setElementHealth(getLocalPlayer(), getElementHealth(getLocalPlayer()) - 15)
		end
		
		if (getPlayerThirst(getLocalPlayer()) <= 0) and getElementData(getLocalPlayer(), "dead") == 0 then
			setElementHealth(player, getElementHealth(getLocalPlayer()) - 15)
	end	end end, 60000, 0, getLocalPlayer())
		
setTimer(function(player)
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerHunger(getLocalPlayer()) >= 50) and (getPlayerThirst(getLocalPlayer()) >= 50) then
			if --[[getElementHealth(getLocalPlayer()) => 3 and]] getElementHealth(getLocalPlayer()) <= 99 then -- Hata
				setElementHealth(getLocalPlayer(), getElementHealth(getLocalPlayer()) + 2)
	end	end end end, 12000, 0, getLocalPlayer())
		
function getPlayerHunger(player) -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (player == getLocalPlayer()) then
			return getElementData(player, "hunger")
		end
	end
end

function getPlayerThirst(player) -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (player == getLocalPlayer()) then
			return getElementData(player, "thirst")
		end
	end
end

function azaltAcikma(player) -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (player == getLocalPlayer()) then
			if not (getPlayerHunger(player) <= 0) then
				triggerServerEvent("anticheat:changeEld", player, player, "hunger", getPlayerHunger(player) - 1)
			end
		end
	end
end

function azaltSusuzluk(player) -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (player == getLocalPlayer()) then
			if not (getPlayerThirst(player) <= 0) then
				triggerServerEvent("anticheat:changeEld", player, player, "thirst", getPlayerThirst(player) - 1)
			end
		end
	end
end

addEventHandler ("onClientResourceStart",getResourceRootElement(getThisResource()),
function () -- Hatasız
  setTimer (bugFixAcikma1,1000,0,getLocalPlayer())
  setTimer (bugFixAcikma2,1000,0,getLocalPlayer())
  setTimer (bugFixSusama1,1000,0,getLocalPlayer())
  setTimer (bugFixSusama2,1000,0,getLocalPlayer())
end)

function bugFixAcikma1() -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerHunger(getLocalPlayer()) >= 101) then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "hunger", 100)
		end
	end
end

function bugFixAcikma2() -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerHunger(getLocalPlayer()) <= -1) then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "hunger", 0)
		end
	end
end

function bugFixSusama1() -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerThirst(getLocalPlayer()) >= 101) then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "thirst", 100)
		end
	end
end

function bugFixSusama2() -- Hatasız
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if (getPlayerThirst(getLocalPlayer()) <= -1) then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "thirst", 0)
		end
	end
end

-- Seviye - Oynanan Dakika - Oynanan Saat -  Amaç Saat
addEventHandler ("onClientResourceStart",getResourceRootElement(getThisResource()),
function () -- Hatasız
  setTimer (minutesPlayed,60000,0,getLocalPlayer())
  setTimer (updateLevelAndLevelAims,1000,0,getLocalPlayer())
  setTimer (LevelUP,60000,0,getLocalPlayer())
  setTimer (updateLevelAims,60000,0,getLocalPlayer())
end)

function minutesPlayed() -- Hatasız
	local minutesPlayed = getElementData(getLocalPlayer(), "minutesPlayed")
	local hoursplayed = getElementData(getLocalPlayer(), "hoursplayed")
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if minutesPlayed <= 59 then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "minutesPlayed", minutesPlayed+1)
		elseif minutesPlayed >= 60 then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "minutesPlayed", 0)
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "hoursplayed", hoursplayed+1)
		end
		triggerServerEvent("kaydet:dakikavesaat", getLocalPlayer(), getLocalPlayer())
	end
end

function updateLevelAndLevelAims() -- Hatasız
	local level = getElementData(getLocalPlayer(), "level")
	local hoursaim = getElementData(getLocalPlayer(), "hoursaim")
	local minutesPlayed = getElementData(getLocalPlayer(), "minutesPlayed")
	local hoursplayed = getElementData(getLocalPlayer(), "hoursplayed")
	if (tonumber(getElementData(getLocalPlayer(), "loggedin")) == 1) then
		if hoursplayed >= hoursaim then
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "level", level + 1)
			local nlevel = level + 1
			triggerServerEvent("anticheat:changeEld", getLocalPlayer(), getLocalPlayer(), "hoursaim", hoursaim+nlevel*4+4)
		end
		triggerServerEvent("kaydet:dakikavesaat", getLocalPlayer(), getLocalPlayer())
	end
end