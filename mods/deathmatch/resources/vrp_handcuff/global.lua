tablo = {}

controls = { "fire", "next_weapon", "previous_weapon","jump","action","aim_weapon","vehicle_fire", "vehicle_secondary_fire","vehicle_left", "vehicle_right", "steer_forward", "steer_back", "accelerate", "brake_reverse", "sprint"}

function kelepcele(target, durum)
if not tablo[target]  then tablo[target] = {} end
	if durum == "ver" then
		setPedWeaponSlot(target, 0)
		setElementData(target, "kelepce", true)
		bindKey(target, "fire","both", engelle)
		bindKey(target, "jump","both", engelle)
		bindKey(target, "sprint","both", engelle)
		bindKey(target, "crouch","both", engelle)
		for i, v in ipairs(controls) do
		toggleControl(target, v, false)
			end	
		tablo[target].obje = createObject(364, 0,0,0)
		exports.vrp_bone_attach:attachElementToBone(tablo[target].obje, target, 12, 0,0,0,0,40,-10)
		target:setAnimation("sword", "sword_block", 1000, false, true, false)	
	end
	if durum == "al" then
		if tablo[target].obje then
			destroyElement(tablo[target].obje)
		end
		setPedAnimation(target)
		for i, v in ipairs(controls) do
			toggleControl(target, v, true)
		end	
		setElementData(target, "kelepce", nil)
	end
	if durum == "ipver" then
		setPedWeaponSlot(target, 0)
		setElementData(target, "ipbagli", true)
		bindKey(target, "fire","both", engelle)
		bindKey(target, "jump","both", engelle)
		bindKey(target, "sprint","both", engelle)
		bindKey(target, "crouch","both", engelle)
		for i, v in ipairs(controls) do
		toggleControl(target, v, false)
			end	
		tablo[target].obje = createObject(364, 0,0,0)
		exports.vrp_one_attach:attachElementToBone(tablo[target].obje, target, 12, 0,0,0,0,40,-10)
		target:setAnimation("sword", "sword_block", 1000, false, true, false)	
	end
	if durum == "ipal" then
		if tablo[target].obje then
			destroyElement(tablo[target].obje)
		end
		setPedAnimation(target)
		for i, v in ipairs(controls) do
			toggleControl(target, v, true)
		end	
		setElementData(target, "ipbagli", nil)
	end
end
addEvent("kelepcele",true)
addEventHandler("kelepcele",root,kelepcele)