-- bekiroj
gezn = getElementZoneName

-- caching to improve efficiency
local zoneCache = {}

function getElementZoneName( theElement )
	--outputDebugString("ran")
	if not theElement or not isElement(theElement) then
		return "Unknown Area"
	end

	local int = getElementInterior(theElement)
	local dim = getElementDimension(theElement)

	if zoneCache[dim] then 
		--return zoneCache[dim]
	end

	if int == 0 and dim == 0 then
		if getElementType(theElement) == "interior" then
			local text = getElementData(theElement, "name")..", "..gezn( theElement )..", "..gezn( theElement, true )
			zoneCache[dim] = text
			return zoneCache[dim]
		else
			local text = gezn( theElement )..", "..gezn( theElement, true )
			zoneCache[dim] = text
			return zoneCache[dim]
		end
	else
		local dimension, entrance, exit, interiorType, interiorElement = exports['vrp_interiors']:findProperty( theElement )
		if interiorElement then
			return getElementZoneName ( interiorElement ) 
		else
			zoneCache[dim] = "Unknown Area"
			return zoneCache[dim] 
		end
	end
end