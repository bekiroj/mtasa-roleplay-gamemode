--Maxime
function getPropertyTaxRate(interiorType)
	if not interiorType then
		interiorType = 0
	end
	local propertyTaxRate = 0.0005
	if interiorType == 1 then
		propertyTaxRate = propertyTaxRate+0.0002
	end
	return propertyTaxRate
end