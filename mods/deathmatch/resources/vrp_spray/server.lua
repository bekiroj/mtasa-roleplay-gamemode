local sprey = createColSphere( 1225.1787109375, -1758.359375, 1869.4250488281, 1)

function satinal (thePlayer, cmd, komut)
	if (getElementData(thePlayer, "tamirci" ) == 1) then
		if (getElementInterior(thePlayer) == 107) then
			if not komut then
			    outputChatBox("[!]#ffffff /"..cmd.." sprey", thePlayer, 255, 194, 14, true)
			return end
			if komut == "sprey" then
				local para = 150
				local sprey = 41
				if (exports.vrp_global:takeMoney(thePlayer,para)) then
					local serial1 = tonumber(getElementData(thePlayer, "account:character:id"))
					local mySerial = exports.vrp_global:createWeaponSerial( 1, serial1)
					exports.vrp_global:giveItem(thePlayer, 115, sprey..":"..mySerial..":"..getWeaponNameFromID(sprey).."::")
				 	outputChatBox("[!]#ffffff 1 Adet sprey satın aldınız. ("..para..")$", thePlayer, 0, 255, 0, true)
				else
				 	outputChatBox("[!]#ffffff Sprey satın almak için ("..para..")$'a ihtiyacınız var.", thePlayer, 0, 255, 0, true)
				end 
			end
		end
	end
end
addCommandHandler("satinal", satinal)	

function tamiret (thePlayer, cmd)
if (getElementData(thePlayer, "tamirci" ) == 1) then
	if ( getElementInterior(thePlayer) == 107 ) then
	    local araba = getPedOccupiedVehicle( thePlayer )
		if (araba) then
		    if (exports.vrp_global:takeMoney(thePlayer, 150)) then
				setElementHealth(araba, 1000)
				fixVehicle(araba)
				for i = 0, 5 do
						setVehicleDoorState(araba, i, 0)
					end
		       end	 
		    end
	    end
	end
end
addCommandHandler("tamiret", tamiret)