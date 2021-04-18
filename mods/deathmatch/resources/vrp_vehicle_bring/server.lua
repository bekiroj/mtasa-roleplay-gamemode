local vehicleGets = {}
local hoursRefreshRate = 10
--@tablo yapısı: vehicleGets[player:getData("dbid")] = sayı;

function secondsToTimeDesc( seconds )
	if seconds then
		local results = {}
		local sec = ( seconds %60 )
		local min = math.floor ( ( seconds % 3600 ) /60 )
		local hou = math.floor ( ( seconds % 86400 ) /3600 )
		local day = math.floor ( seconds /86400 )
		
		if day > 0 then table.insert( results, day .. ( day == 1 and " gün" or " gün" ) ) end
		if hou > 0 then table.insert( results, hou .. ( hou == 1 and " saat" or " saat" ) ) end
		if min > 0 then table.insert( results, min .. ( min == 1 and " dakika" or " dakika" ) ) end
		if sec > 0 then table.insert( results, sec .. ( sec == 1 and " saniye" or " saniye" ) ) end
		
		return string.reverse ( table.concat ( results, ", " ):reverse():gsub(" ,", " ev ", 1 ) )
	end
	return ""
end


addCommandHandler("aracgetir",
	function(thePlayer, commandName, id)
		--	if tonumber(getElementData(thePlayer, "hapis:süre")) > 0 then
		--	return false end
		if not (id) then
			outputChatBox("[!] #ffffff/aracgetir [id]", thePlayer, 255, 194, 14, true)
		else
			local theVehicle = exports.vrp_pool:getElement("vehicle", tonumber(id))
			if getElementData(thePlayer, "adminjailed") == true then outputChatBox("[!] #ffffffHapiste olduğunuz için araç çekemezsiniz.", thePlayer, 255, 0, 0, true) return end
			if not vehicleGets[thePlayer:getData("dbid")] then vehicleGets[thePlayer:getData("dbid")] = 0; end
			if vehicleGets and vehicleGets[thePlayer:getData("dbid")] and vehicleGets[thePlayer:getData("dbid")] < 3 then
				
				local dbid = getElementData(thePlayer, "account:id")
				if theVehicle and dbid then
					local vehOwner = getElementData(theVehicle, "owner")
					local playerID = getElementData(thePlayer, "dbid")
					local dbid = getElementData(thePlayer, "account:id")
					if vehOwner == playerID then
						if getElementData(theVehicle, "forsale") == 1 then
							outputChatBox("[!] #ffffffIkinci el'de satılık olan aracınızı çekemezsiniz.", thePlayer, 255, 0, 0, true)
							return
						end
						if getElementData(theVehicle, "Impounded") ~= 0 then
							outputChatBox("[!] #ffffffAracınız polis tarafından çekilmiş.", thePlayer, 255, 0, 0, true)
							return
						end
						local r = getPedRotation(thePlayer)
						local x, y, z = getElementPosition(thePlayer)
						x = x + ( ( math.cos ( math.rad ( r ) ) ) * 5 )
						y = y + ( ( math.sin ( math.rad ( r ) ) ) * 5 )

						if	(getElementHealth(theVehicle)==0) then
							spawnVehicle(theVehicle, x, y, z, 0, 0, r)
						else
							setElementPosition(theVehicle, x, y, z)
							setElementRotation(theVehicle, 0, 0, r)
						end
						setElementInterior(theVehicle, getElementInterior(thePlayer))
						setElementDimension(theVehicle, getElementDimension(thePlayer))
						exports.vrp_logs:dbLog(thePlayer, 6, theVehicle, commandName)
						vehicleGets[thePlayer:getData("dbid")]= vehicleGets[thePlayer:getData("dbid")] + 1
						outputChatBox("[!] #ffffffAracınız başarıyla çekildi.", thePlayer, 0, 255, 0, true)
					else
						outputChatBox("[!] #ffffffAraç size ait değildir.", thePlayer, 255, 0, 0, true)
					end
				else
					outputChatBox("[!] #ffffffGeçersiz araç ID'si girdiniz.", thePlayer, 255, 0, 0, true)
				end
			else
				local remainingSeconds = secondsToTimeDesc(math.ceil(getTimerDetails(refreshRate)/1000))
				outputChatBox("[!] #ffffffGünlük hakkınız bitmiş bulunmaktadır.", thePlayer, 255, 0, 0, true)
				outputChatBox("[!] #ffffffAraç çekme hakkı "..remainingSeconds.." sonra yenilenecek.", thePlayer, 255, 0, 0, true)
			end
		end
	end
)

refreshRate = Timer(
	function()
		vehicleGets = {}
	end,
1000*60*60*24, 0)