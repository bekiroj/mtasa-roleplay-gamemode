addCommandHandler("aracat",
	function(thePlayer, commandName, fonksiyon, targetPlayerNick, koltukID)
		local logged = getElementData(thePlayer, "loggedin")
	
		if (logged==1) then
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
			if (factionType==2) or (factionType == 3) then
				if not (targetPlayerNick) or not (fonksiyon) or not (koltukID) then
					outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [at/bindir] [ID] [koltukID]", thePlayer, 255, 194, 14)
				else
					if not ((tonumber(koltukID)) >= 0 and (tonumber(koltukID) <= 3)) then
						outputChatBox("Koltuk ID'leri:", thePlayer, 255, 194, 14)
						outputChatBox("=> 0 - Sürücü Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 1 - Ön Yolcu Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 2 - Sol Arka Yolcu Koltuğu", thePlayer, 255, 194, 14)
						outputChatBox("=> 3 - Sağ Arka Yolcu Koltuğu", thePlayer, 255, 194, 14)
						return
					end
					local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
					local theVehicle = exports.vrp_pool:getElement("vehicle", getElementData(thePlayer, "lastvehid"))
				
					if targetPlayer then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local vx, vy, vz = getElementPosition(theVehicle)
						
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local distance2 = getDistanceBetweenPoints3D(tx, ty, tz, vx, vy, vz)
						
						if (distance<=10) then
							if not (distance2<=10) then
								outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahıs en son bindiğiniz araçtan uzakta.", thePlayer, 255, 0, 0, true)
								return
							end
							if getVehicleOccupant(theVehicle, tonumber(koltukID)) then
								outputChatBox("[!] #f0f0f0Kişiyi atmak istediğiniz koltuk şu an dolu.", thePlayer, 255, 0, 0, true)
								return
							end
							local vehicleID = getElementData(thePlayer, "lastvehid")
							outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahsı #" .. vehicleID .. " ID'li aracın '" .. koltukID .. "' ID'li koltuğuna bindirdiniz.", thePlayer, 0, 255, 0, true)
							outputChatBox("[!] #f0f0f0" .. getPlayerName(thePlayer) .. " isimli şahıs tarafından #" .. vehicleID .. " ID'li aracın '" .. koltukID .. "' ID'li koltuğuna bindirildiniz.", targetPlayer, 0, 255, 0, true)
							warpPedIntoVehicle(targetPlayer, theVehicle, tonumber(koltukID))
						else
							outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
						end
					end
				end
			end
		end
	end
)