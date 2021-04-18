function supplyExtinguisher(thePlayer)
	exports.vrp_global:giveItem(thePlayer, 116, "42:500:Ammo for "..getWeaponNameFromID(42))
end
addEvent("fdextinguisher:supply", true)
addEventHandler("fdextinguisher:supply", resourceRoot, supplyExtinguisher)