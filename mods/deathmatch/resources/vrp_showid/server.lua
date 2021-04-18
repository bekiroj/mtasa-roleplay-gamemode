function kimlik(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
				outputChatBox("[+] Sözdizimi:#999999 /" .. commandName .. " [ADI/ID] ", thePlayer, 255, 194, 14,true)
			else
				local username = getPlayerName(thePlayer)
				local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
				local cinsiyet = getElementData(thePlayer, "gender")
				if (cinsiyet==0) then
				cinsiyet = "Erkek"
				elseif (cinsiyet==1) then
				cinsiyet = "Kadın"
				end
				local gun = getElementData(thePlayer, "day")
				local ay = getElementData(thePlayer, "month")
				local yas = getElementData(thePlayer, "age")
				if (ay==1) then
				ay = "Ocak"
				elseif (ay==2) then
				ay = "Subat"
				elseif (ay==3) then
				ay = "Mart"
				elseif (ay==4) then
				ay = "Nisan"
				elseif (ay==5) then
				ay = "Mayıs"
				elseif (ay==6) then
				ay = "Haziran"
				end

				if targetPlayer then
					if targetPlayer == thePlayer then
						outputChatBox("#cc0000[!]#ffffff Bu eylemi kendinize uygulayamazsınız!", thePlayer, 155, 0, 0, true)
						return
				     end
					
					if not getElementData(thePlayer, "kimlik") == true then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local theVehicle = getPedOccupiedVehicle(thePlayer)
						local theVehicleT = getPedOccupiedVehicle(targetPlayer)
						if distance < 3 then
	                		exports.vrp_hud:sendBottomNotification(targetPlayer, "Aşağıdakiler '"..username.."' isimli kişinin kimlik bilgileridir.", "Adı ve Soyadı: "..getPlayerName(thePlayer):gsub("_", " ").." | Cinsiyeti: "..cinsiyet.." | Dogum tarihi: Gün: "..gun.." Ay: "..ay..": Yaş: "..yas)
                  			outputChatBox("#66FF33[!]#ffffff "..getPlayerName(targetPlayer):gsub(" ", " ").." isimli kişiye kimliğinizi gösterdiniz.", thePlayer, 155, 0, 0, true)
                 			outputChatBox("#66FF33[!]#ffffff "..getPlayerName(thePlayer):gsub(" ", " ").." isimli kişi size kimliğini gösterdi.",targetPlayer, 155, 0, 0, true)	
						else
							outputChatBox("#cc0000[!]#ffffff Bir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 155, 0, 0, true)
						end
					end
				end
			end
end
addCommandHandler("kimlikgoster", kimlik)