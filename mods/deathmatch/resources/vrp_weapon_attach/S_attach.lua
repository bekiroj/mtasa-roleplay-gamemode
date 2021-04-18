--	[weapon_id] = model,
local models = {
	[22] = 346,
	[23] = 347,
	[24] = 348,
	[25] = 349,
	[26] = 350,
	[27] = 351,
	[28] = 352,
	[29] = 353,
	[30] = 355,
	[31] = 356,
	[32] = 372,
	[33] = 357,
	[34] = 358,
}

function createModel(weapon, bone, x, y, z, rx, ry, rz)
	local player = source
	local r = getPedRotation(player)
	local dim = getElementDimension(player)
	local int = getElementInterior(player)
	local slot = getPedWeaponSlot(player)
	local objectID = models[weapon]
	local slotID = getSlotFromWeapon(weapon)
	
	if objectID then
		if getElementData(player, "attachedSlot"..slotID.."") then
			local objectSlot = getElementData(player, "attachedSlot"..slotID.."")
			if isElement(objectSlot) then
				destroyElement(objectSlot) 
			end
		end
		
		local object = createObject(objectID, x, y, z)
		exports.vrp_bone_attach:attachElementToBone(object, player, bone, x, y, z, rx, ry, rz)
		setElementData(player, "attachedSlot"..slotID.."", object)
		setElementData(object, "attachingWeapon", weapon)
		setElementData(object, "attachedSlot"..slotID.."", player)
		setElementCollisionsEnabled(object, false)
		setElementInterior(object, int)
		setElementDimension(object, dim)

		local theVehicle = getPedOccupiedVehicle(player)
		if theVehicle then
			setElementAlpha(object, 0)
		end
	end
end
addEvent("createWeaponModel", true)
addEventHandler("createWeaponModel", root, createModel)

function destroyWeaponModel(receivedID)
	for i = 1, 12 do
		local object = getElementData(source, "attachedSlot"..i.."")
		if isElement(object) then
			local id = getElementData(object, "attachingWeapon") or -1
			if id == receivedID then
				destroyElement(object)
				--setElementData(source, "attachingWeapon"..id.."", nil)
				break
			end
		end
	end
end
addEvent("destroyWeaponModel", true)
addEventHandler("destroyWeaponModel", root, destroyWeaponModel)

function destroyWeaponFromSlot(receivedID)
	local object = getElementData(source, "attachedSlot"..receivedID.."")
	if isElement(object) then
		destroyElement(object)
		--setElementData(source, "attachingWeapon"..id.."", nil)
	end
end
addEvent("destroyWeaponFromSlot", true)
addEventHandler("destroyWeaponFromSlot", root, destroyWeaponFromSlot)

function destroyAll()
	for i = 1, 12 do
		local object = getElementData(source, "attachedSlot"..i.."")
		if isElement(object) then
			local id = getElementData(object, "attachingWeapon")
			if id then
				destroyElement(object)
				setElementData(source, "attachingWeapon"..id.."", nil)
			end
		end
	end
end
addEvent("st.destroyAll",true)
addEventHandler("st.destroyAll",root,destroyAll)
addEventHandler("onPlayerQuit", root, destroyAll)


function alphaWepsVehicle(theVehicle, seat, jacked)
	for i = 1, 12 do
		local object = getElementData(source, "attachedSlot"..i.."")
		if isElement(object) then
			setElementAlpha(object, 255)
		end
	end
end
addEventHandler("onPlayerVehicleEnter", getRootElement(), alphaWepsVehicle)

function unalphaWepsVehicle(theVehicle, seat, jacked)
    for i = 1, 12 do
		local object = getElementData(source, "attachedSlot"..i.."")
		if isElement(object) then 
			setElementAlpha(object, 255)
		end
	end
end
addEventHandler("onPlayerVehicleExit", getRootElement(), unalphaWepsVehicle)