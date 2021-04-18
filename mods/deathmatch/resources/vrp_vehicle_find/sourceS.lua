local gpsBlips = {}
local gpsMarkers = {}
function gpsFunc(thePlayer, cmd, vehID)
	local playerID = getElementData(thePlayer, "dbid")
	if not vehID then
		outputChatBox("[!]#ffffff /aracbul [Araç Numarası(ID)]",thePlayer,100,100,255,true)
		return false
	end
	if not gpsBlips[playerID] then
		local vehicle = exports.vrp_pool:getElement("vehicle", vehID)
		if vehicle then
			local vehicleOwner = getElementData(vehicle, "owner")
			if vehicleOwner == playerID then
				local vehposX, vehposY, vehposZ = getElementPosition(vehicle)
				gpsBlips[playerID] = createBlip(vehposX, vehposY, vehposZ, 19, 2, 255, 0, 0, 255, 0, 99999.0, thePlayer)
				gpsMarkers[playerID] = createMarker(vehposX, vehposY, vehposZ, "checkpoint", 3, 255, 0, 0, 255, thePlayer)
				attachElements(gpsMarkers[playerID], vehicle)
				attachElements(gpsBlips[playerID], vehicle)
				if gpsBlips[playerID] then
					outputChatBox("[!]#ffffff Aracın lokasyonu haritda işaretlendi.",thePlayer,100,100,255,true)
				end
			else
				outputChatBox("[!]#ffffff Size ait olmayan bir aracın lokasyonunu öğrenemezsiniz.",thePlayer,100,100,255,true)
			end
		end
	else
		outputChatBox("[!]#ffffff Şu an GPS çalışmaktadır. Tekrar kullanabilmek için önce /kgps ile öncekini kapatın.",thePlayer,100,100,255,true)
	end
end
addCommandHandler("aracbul", gpsFunc)

function kgpsFunc(thePlayer, cmd)
	local playerID = getElementData(thePlayer, "dbid")
	if gpsBlips[playerID] then
		destroyElement(gpsMarkers[playerID])
		gpsMarkers[playerID] = false
		destroyElement(gpsBlips[playerID])
		gpsBlips[playerID] = false
		outputChatBox("#f0f0f0GPS'i başarıyla kapattınız.", thePlayer, 0, 255, 0, true)
	end
end
addCommandHandler("kgps", kgpsFunc)