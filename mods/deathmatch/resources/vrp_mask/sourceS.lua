addCommandHandler("maske",function(plr)
	if plr:getData("vip") > 1 then		
		if not plr:getData("maske:tak") then
			plr:outputChat("[!]#ffffff Maskenizi taktınız.",0,255,0,true)
			plr:setData("maske:tak", true)
			random = "(Gizli #"..getElementData(plr, "dbid")..")"
			exports.anticheat:changeProtectedElementDataEx(plr, "fakename", random, true)
		else
			plr:outputChat("[!]#ffffff Maskenizi çıkardınız.",0,255,0,true)
			exports.anticheat:changeProtectedElementDataEx(plr, "fakename", false, true)
			plr:setData("maske:tak", nil)
		end
	end
end)

addCommandHandler("maskeliler",function(plr)
	if exports.integration:isPlayerTrialAdmin(plr) then
		for theKey,v in ipairs(getElementsByType ( "player" )) do
			if v:getData("maske:tak") then
				plr:outputChat("Maske id: ("..v:getData("fakename")..") Gerçek İD: ("..v:getData("playerid")..") Gerçek isim: ("..getPlayerName(v)..")",255,194,14)
			end
		end	
	end
end)