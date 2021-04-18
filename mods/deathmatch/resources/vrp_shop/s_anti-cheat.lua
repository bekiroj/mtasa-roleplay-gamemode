-- bekiroj

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function() 
	for i, player in pairs(getElementsByType("player")) do
		exports.vrp_anticheat:changeProtectedElementDataEx(player, "usingThisShop", false, false, true)
	end
end)

function setShopCurrentUser(shop, player)
	local oldShop = getElementData(player, "usingThisShop")
	if oldShop then
		return false
	end
	if shop and getElementType(shop) == "ped" and getElementType(player) == "player" then
		exports.vrp_anticheat:changeProtectedElementDataEx(shop, "usingThisShop", player, false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(player, "usingThisShop", shop, false, true)
		outputDebugString("Created")
		return true
	else
		return false
	end
end

function isPlayerUsingThisShop(thePlayer, theShop)
	if not isElement(thePlayer) or not isElement(theShop) then
		return false, "Player or shop doesn't exist anymore."
	end
	local usingShop = getElementData(thePlayer, "usingThisShop")
	if not usingShop or not isElement(usingShop) then
		return false, "Player isn't using any shop at the moment."
	end
	local usingPlayer = getElementData(usingShop, "usingThisShop")
	if not usingPlayer or not isElement(usingPlayer) then
		return false, "Noone is using this shop at the moment."
	end
	if usingPlayer == thePlayer and usingShop == theShop then
		return true
	else
		return false, "This player isn't using this shop."
	end
end

function removeMeFromCurrentShopUser(player)
	if player then
		source = player
	end
	
	local shop = getElementData(source, "usingThisShop")
	exports.vrp_anticheat:changeProtectedElementDataEx(source, "usingThisShop", nil, false, true)
	if not shop or not isElement(shop) or not (getElementType(shop) == "ped") then
		outputDebugString("Can't get shop from client")
		return false
	end
	exports.vrp_anticheat:changeProtectedElementDataEx(shop, "usingThisShop", nil, false, true)
	
	outputDebugString("Removed")
	return true
end
addEvent("shop:removeMeFromCurrentShopUser", true)
addEventHandler("shop:removeMeFromCurrentShopUser", root, removeMeFromCurrentShopUser)

function canIAccessThisShop(shop, player)
	if not shop or not isElement(shop) or not (getElementType(shop) == "ped") or not player or not isElement(player) or not (getElementType(player) == "player") then
		return false, "Unknown"
	end
	local whoIsUsingIt = getElementData(shop, "usingThisShop")
	if not whoIsUsingIt then
		--outputDebugString("Checked : Good")
		return true
	elseif not whoIsUsingIt then
		--outputDebugString("Checked : Good")
		return true
	else
		--outputDebugString("Checked: Bad")
		if whoIsUsingIt and isElement(whoIsUsingIt) and getElementType(whoIsUsingIt) == "player" then
			return false , exports.vrp_global:getPlayerName(whoIsUsingIt)
		else
			return true
		end
	end
end