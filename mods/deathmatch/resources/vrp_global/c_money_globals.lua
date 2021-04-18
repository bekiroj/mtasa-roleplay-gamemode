function hasMoney(thePlayer, amount)
	amount = tonumber( amount ) or 0
	if thePlayer and isElement(thePlayer) and amount > 0 then
		amount = math.floor( amount )
		
		return getMoney(thePlayer) >= amount
	end
	return false
end

function getMoney(thePlayer)
	return getElementData(thePlayer, "money") or 0
end

-- ////////////////////////////////////

function formatMoney(amount)
	--if not amount or not tonumber(amount) or amount==0 then
		--return 0
	--end
	local left,num,right = string.match(tostring(amount),'^([^%d]*%d)(%d*)(.-)$')
	return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function takeMoney(thePlayer, amount)
	return triggerServerEvent("global:takeMoney", thePlayer, thePlayer, amount)
end