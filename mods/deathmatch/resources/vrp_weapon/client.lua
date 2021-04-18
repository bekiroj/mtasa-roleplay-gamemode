
-- @bekiroj #
local distance = 75
local explostionDistance = 150

local cSoundsEnabled = true
local reloadSoundEnabled = true
local explosionEnabled = true

function playSounds(weapon, ammo, ammoInClip)
	if(cSoundsEnabled)then
		local x,y,z = getElementPosition(source)
		if weapon == 31 then --m4
			if(ammoInClip == 0 and reloadSoundEnabled)then
				mgReload("sounds/weapon/m4.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/m4.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 22 then --pistol
			if(ammoInClip == 0 and reloadSoundEnabled)then
				pistolReload("sounds/weapon/pistole.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/pistole.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 23 then --DANIEL'S WEAPON
			if(ammoInClip == 0 and reloadSoundEnabled)then
				pistolReload("sounds/weapon/pistole.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/pistole.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end	
		elseif weapon == 24 then --deagle
			if(ammoInClip == 0 and reloadSoundEnabled)then
				pistolReload("sounds/weapon/deagle.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/deagle.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 25 or weapon == 26 or weapon == 27 then --shotguns
			if(weapon == 25)then
				local sound = playSound3D("sounds/weapon/shotgun.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				shotgunReload(x,y,z)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			else
				local sound = playSound3D("sounds/weapon/shotgun.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				local shellSound = playSound3D("sounds/reload/shotgun_shell.wav", x,y,z)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
				setElementDimension(shellSound, dimension)
			end
		elseif weapon == 28 then --uzi
			if(ammoInClip == 0)then						
				mgReload("sounds/weapon/uzi.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/uzi.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 29 then --mp5
			if(ammoInClip == 0 and reloadSoundEnabled)then
				mgReload("sounds/weapon/mp5.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/mp5.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 32 then --tec-9
			if(ammoInClip == 0)then						
				tec9Reload(x,y,z)
			else
				local sound = playSound3D("sounds/weapon/tec-9.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 30 then --ak
			if(ammoInClip == 0 and reloadSoundEnabled)then
				mgReload("sounds/weapon/ak.wav", x,y,z)
			else
				local sound = playSound3D("sounds/weapon/ak.wav", x,y,z)
				setSoundVolume(sound, 0.4)
				setSoundMaxDistance(sound, distance)
				local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
			end
		elseif weapon == 33 or weapon == 34 then --snipers
			local sound = playSound3D("sounds/weapon/sniper.wav", x,y,z)
			setSoundVolume(sound, 0.4)
			setSoundMaxDistance(sound, distance)
			local dimension = getElementDimension(getLocalPlayer())
			setElementDimension(sound, dimension)
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), playSounds)

function mgReload(soundPath, x,y,z)
	local sound = playSound3D(soundPath, x,y,z)
	setSoundMaxDistance(sound, distance)
			local dimension = getElementDimension(getLocalPlayer())
			setElementDimension(sound, dimension)
				
	local clipinSound = playSound3D("sounds/reload/mg_clipin.wav", x,y,z)
	setTimer(function()
		local relSound = playSound3D("sounds/reload/mg_clipin.wav", x,y,z)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(relSound, dimension)
	end, 1250, 1)
end

function tec9Reload(x,y,z)
	local sound = playSound3D("sounds/weapon/tec-9.wav", x,y,z)
				setSoundVolume(sound, 0.4)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
	setSoundMaxDistance(sound, distance)
				
	local clipinSound = playSound3D("sounds/reload/mg_clipin.wav", x,y,z)
				setSoundVolume(clipinSound, 0.4)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(clipinSound, dimension)
	setTimer(function()
		local relSound = playSound3D("sounds/reload/mg_clipin.wav", x,y,z)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(relSound, dimension)
	end, 1000, 1)
end

function pistolReload(soundPath, x,y,z)
	local sound = playSound3D(soundPath, x,y,z)
	setSoundMaxDistance(sound, distance)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(sound, dimension)
	setTimer(function()
		local relSound = playSound3D("sounds/reload/pistol_reload.wav", x,y,z)
	end, 500, 1)
end

function shotgunReload(x,y,z)
	setTimer(function()
		local relSound = playSound3D("sounds/reload/shotgun_reload.wav", x,y,z)
		local shellSound = playSound3D("sounds/reload/shotgun_shell.wav", x,y,z)
						local dimension = getElementDimension(getLocalPlayer())
				setElementDimension(relSound, dimension)
				setElementDimension(shellSound, dimension)
	end, 500, 1)
end

addEventHandler("onClientExplosion", getRootElement(), function(x,y,z, theType)
	if(explosionEnabled)then
		if(theType == 0)then--Grenade
			local explSound = playSound3D("sounds/explosion/explosion1.wav", x,y,z)
			setSoundMaxDistance(explSound, explostionDistance)
			local dimension = getElementDimension(getLocalPlayer())
			setElementDimension(explSound, dimension)
		elseif(theType == 4 or theType == 5 or theType == 6 or theType == 7)then --car, car quick, boat, heli
			local explSound = playSound3D("sounds/explosion/explosion3.wav", x,y,z)
			setSoundMaxDistance(explSound, explostionDistance)
			local dimension = getElementDimension(getLocalPlayer())
			setElementDimension(explSound, dimension)
		end
	end
end)

function DonateGun ( ) 
    setWeaponProperty ( 23, "poor", "damage", 70 ) 
	setWeaponProperty ( 23, "std", "damage", 70 ) 
	setWeaponProperty ( 23, "pro", "damage", 70 ) 
	setWeaponProperty(23, "poor", "weapon_range", 70)
    setWeaponProperty(23, "std", "weapon_range", 70)
    setWeaponProperty(23, "pro", "weapon_range", 70)
end 
addEventHandler ( "onResourceStart", resourceRoot, DonateGun ) 
