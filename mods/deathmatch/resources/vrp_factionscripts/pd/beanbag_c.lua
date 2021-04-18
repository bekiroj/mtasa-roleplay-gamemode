cooldown = 0
cooldownTimer = nil
localPlayer = getLocalPlayer()


function isPD()
	return getElementData(getLocalPlayer(), "faction") == 1 or getElementData(getLocalPlayer(), "faction") == 6
end

function switchModex()
	if isPD() and (getPedWeapon(localPlayer)==25) and (getPedTotalAmmo(localPlayer)>0) then -- has an un-empty Shotgun
		local mode = getElementData(localPlayer, "shotgunmode")
		if mode == 0 then -- bean bag
			triggerServerEvent("shotgunmode", localPlayer, 1)
			outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Silah modu başarıyla Lethal mod olarak ayarlandı.", 0, 255, 0, true)
		elseif mode == 1 then -- lethal gun mode
			outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Silah modu başarıyla Beanbag mod olarak ayarlandı.", 0, 255, 0, true)
			triggerServerEvent("shotgunmode", localPlayer, 0)
		end
	end
end

function bindKeysX(res)
	bindKey("n", "down", switchModex)
	
	local mode = getElementData(localPlayer, "shotgunmode")
	if not (mode) then triggerServerEvent("shotgunmode", localPlayer, 0) end
end
addEventHandler("onClientResourceStart", getResourceRootElement(), bindKeysX)

function enableCooldownX()
	cooldown = 1
	cooldownTimer = setTimer(disableCooldownX, 500, 1)
	toggleControl("fire", false)
	setElementData(getLocalPlayer(), "shotgun:reload", true)
end

function disableCooldownX()
	cooldown = 0
	--toggleControl("fire", true)
	setElementData(getLocalPlayer(), "shotgun:reload", false)

	if (cooldownTimer~=nil) then
		killTimer(cooldownTimer)
		cooldownTimer = nil
	end
end
addEventHandler("onClientPlayerWeaponSwitch", getRootElement(), disableCooldownX)

function weaponFireX(weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement)
	if (weapon==25) then -- shotgun
		local mode = getElementData(localPlayer, "shotgunmode")
		if (mode==0) then -- bean bag mode
			enableCooldown()
			playSoundFrontEnd(38)
			triggerServerEvent("beanbagFired", localPlayer, hitX, hitY, hitZ, hitElement) 
		end
	end
end
addEventHandler("onClientPlayerWeaponFire", localPlayer, weaponFireX)

-- code for the target/bean bagged person
function cancelBeanbagDamage(attacker, weapon, bodypart, loss)
	if (weapon==25) then -- shotgun
		local mode = getElementData(attacker, "shotgunmode")
		if (mode==0) then -- bean bag mode
			cancelEvent()
		end
	end
end
addEventHandler("onClientPlayerDamage", localPlayer, cancelBeanbagDamage)



local underfire = false
local fireelement = nil
local localPlayer = getLocalPlayer()
local originalRot = 0
local shotsfired = 0

function onTargetPDPedx(element)
	if (isElement(element)) then
		if (getElementType(element)=="ped") and (getElementModel(element)==282) and not (underfire) and (getPedControlState("aim_weapon")) then
			underfire = true
			fireelement = element
			originalRot = getPedRotation(element)
			addEventHandler("onClientRender", getRootElement(), makeCopFireOnPlayerX)
			addEventHandler("onClientPlayerWasted", getLocalPlayer(), onDeathX)
		end
	end
end
addEventHandler("onClientPlayerTarget", getLocalPlayer(), onTargetPDPedx)

function makeCopFireOnPlayerX()
	if (underfire) and (fireelement) then
		local rot = getPedRotation(localPlayer)
		local x, y, z = getPedBonePosition(localPlayer, 7)
		
		setPedRotation(fireelement, rot - 180)
		
		setPedControlState(fireelement, "aim_weapon", true)
		setPedAimTarget(fireelement, x, y, z)
		setPedControlState(fireelement, "fire", true)
		shotsfired = shotsfired + 1
		
		if (shotsfired>40) then
			triggerServerEvent("killmebyped", getLocalPlayer(), fireelement)
		end
	end
end

function onDeathX()
	if (fireelement) and (underfire) then
		setPedControlState(fireelement, "aim_weapon", false)
		setPedControlState(fireelement, "fire", false)
		setPedRotation(fireelement, originalRot)
		
		fireelement = nil
		underfire = false
		removeEventHandler("onClientRender", getRootElement(), makeCopFireOnPlayerX)
		removeEventHandler("onClientPlayerWasted", getLocalPlayer(), onDeathX)
	end
end