function ehliyet(thePlayer, commandName, targetPlayer)
	if not (targetPlayer) then
				outputChatBox("Kullanım: /" .. commandName .. " [User/ID] ", thePlayer, 255, 194, 14)
			else
				local username = getPlayerName(thePlayer)
				local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
	local carlicense = getElementData(thePlayer, "license.car")
	local bikelicense = getElementData(thePlayer, "license.bike")
	local boatlicense = getElementData(thePlayer, "license.boat")
     local meslek = getElementData(thePlayer,"job")
	 if (carlicense==1) then
		carlicense = "#66CCFF[Var]"
	elseif (carlicense==3) then
		carlicense = "#66CCFF[Teori testi geçti]"
	else
		carlicense = "#66CCFF[Yok]"
	end
	if (bikelicense==1) then
		bikelicense = "#66CCFF[Var]"
	elseif (bikelicense==3) then
		bikelicense = "#66CCFF[Teori testi geçti]"
	else
		bikelicense = "#66CCFF[Yok]"
	end
	if (boatlicense==1) then
		boatlicense = "#66CCFF[Var]"
	else
		boatlicense = "#66CCFF[Yok]"
	end
				if targetPlayer then
					if targetPlayer == thePlayer then
						outputChatBox("#cc0000[!]#ffffff Bu eylemi kendinize uygulayamazsınız!", thePlayer, 155, 0, 0, true)
						return
					end
					
					if not getElementData(thePlayer, "ehliyet") == true then
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
						local theVehicle = getPedOccupiedVehicle(thePlayer)
						local theVehicleT = getPedOccupiedVehicle(targetPlayer)
						
							if distance < 3 then
							    outputChatBox("#66FF33[!]#ffffff "..getPlayerName(thePlayer):gsub(" ", " ").." isimli kişi size ehliyet durumunu gösterdi.", targetPlayer, 155, 0, 0, true)							
								outputChatBox("[!]#ffffff Araba ehliyeti:".. carlicense .." #ffffff- Motorsiklet ehliyeti:".. bikelicense .."#ffffff - Bot lisansı:".. boatlicense .."#ffffff.",targetPlayer, 255, 255, 0, true)
	                            outputChatBox("#66FF33[!]#ffffff "..getPlayerName(targetPlayer):gsub(" ", " ").." isimli kişiye ehliyetinizi gösterdiniz.", thePlayer, 155, 0, 0, true)
							else
								outputChatBox("#cc0000[!]#ffffff Bir kişiye kimliğini gostermek için yanında olmalısın.", thePlayer, 155, 0, 0, true)
							end
					end
				end
			end
end
addCommandHandler("ehliyetgoster", ehliyet)


