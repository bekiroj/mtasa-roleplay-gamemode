addCommandHandler("callsign",function(plr,cmd,...)
	if plr:getData("faction") == 1 or plr:getData("faction") == 78 then
		if not plr:getOccupiedVehicle() then
			outputChatBox("[!]#ffffff Maalesef bu işlemi yapmak için araçda olmanız lazım.",plr,255,0,0,true)
		return end
			if not ... then 
			outputChatBox("[!]#ffffff /"..cmd.." <Birim Kodu>",plr,255,194,14,true)
			plr:getOccupiedVehicle():setData("callsign", nil)
			return end
			local kod = table.concat({...}, " ")
			plr:getOccupiedVehicle():setData("callsign", kod)
	end
end)