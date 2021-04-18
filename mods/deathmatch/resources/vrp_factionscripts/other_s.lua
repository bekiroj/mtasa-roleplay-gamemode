addCommandHandler("surukle",
	function(thePlayer, commandName, targetPlayerNick)
		local logged = getElementData(thePlayer, "loggedin")
	
		if (logged==1) then
			if getElementData(thePlayer, "surukle") then
				outputChatBox("[!] #f0f0f0Aynı anda birden fazla kişi sürükleyemezsiniz!", thePlayer, 255, 0, 0, true)
				return false
			end
			local theTeam = getPlayerTeam(thePlayer)
			local factionType = getElementData(theTeam, "type")
		
				if not (targetPlayerNick) then
					outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick]", thePlayer, 255, 194, 14)
				else
					local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
				
					if targetPlayer then
						if getElementData(targetPlayer, "kelepce") or getElementData(targetPlayer, "ipbagli") or getElementData(targetPlayer, "dead") == 1 then
							local x, y, z = getElementPosition(thePlayer)
							local tx, ty, tz = getElementPosition(targetPlayer)
							
							local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
							
							if (distance<=10) then
								exports.vrp_global:applyAnimation( targetPlayer, "ped", "FLOOR_hit_f", -1, false, false, false)
								attachElements(targetPlayer, thePlayer, 0, 1, 0)
								setElementData(thePlayer, "surukle", targetPlayer)
								setElementFrozen(targetPlayer, true)
								outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemektesiniz. Sürüklemeyi bırakmak için /suruklemeyibirak", thePlayer, 0, 255, 0, true)
								outputChatBox("[!] #f0f0f0" .. getPlayerName(thePlayer) .. " isimli şahıs sizi sürüklüyor.", targetPlayer, 0, 255, 0, true)
							else
								outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahısdan uzaksınız.", thePlayer, 255, 0, 0, true)
							end
						else
							outputChatBox("[!] #f0f0f0 Sürüklemek istediğiniz kişi pasif durumda değil.",thePlayer,255,0,0,true)
						end
					end
			end
		end
	end
)

addCommandHandler("suruklemeyibirak",
	function(thePlayer)
		local surukle = getElementData(thePlayer, "surukle")
		if surukle then
			local dim = getElementDimension(thePlayer)
			local int = getElementInterior(thePlayer)
			setElementDimension(surukle, dim)
			setElementInterior(surukle, int)
			detachElements(surukle, thePlayer)
			setElementFrozen(surukle, false)
			setElementData(thePlayer, "surukle", false)
			local targetPlayerName = getPlayerName(surukle)
			outputChatBox("[!] #f0f0f0" .. targetPlayerName .. " isimli şahsı sürüklemeyi bıraktınız.", thePlayer, 0, 255, 0, true)
			exports.vrp_global:removeAnimation(surukle)
			outputChatBox("[!] #f0f0f0" .. getPlayerName(thePlayer).. " sizi sürüklemeyi bıraktı.", surukle, 0, 255, 0, true)
		else
			outputChatBox("[!] #f0f0f0Şu anda hiçkimseyi sürüklememektesiniz.", thePlayer, 255, 0, 0, true)
		end
	end
)