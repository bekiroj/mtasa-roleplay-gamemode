local posx, posy, posz = 277.298828125, -19.857421875, 988.79840087891
local alan = createColSphere(posx,posy,posz, 1) 

local tablo = {
	[1] = {isim = "Sopa", price = 150, command = "sopa", vip = false, silah = true, weaponid = 5},
	[2] = {isim = "Sırt Çantası", price = 250, command = "sirtcanta", vip = false, silah = nil, itemid = 48},
	[3] = {isim = "Spor Çantası", price = 250, command = "sporcanta", vip = false, silah = nil, itemid = 163},
	[4] = {isim = "Siyah Maske", price = 400, command = "maske", vip = true, silah = nil, itemid = 56},
}

addCommandHandler("sporbilgi",function(plr)
	if isElementWithinColShape ( plr, alan) then
	outputChatBox("================[ #ffffffStok Eşyalar#00ff00 ]================",plr,0,255,0,true)
		for k, v in ipairs(tablo) do
		outputChatBox(">>#ffffff "..v.isim.." $"..v.price, plr, 100,100,255,true)
		end
	outputChatBox("================[ #ffffffKomutlar#00ff00 ]================",plr,0,255,0,true)
		for k, v in ipairs(tablo) do
		outputChatBox(">>#ffffff /satinal "..v.command.." $"..v.price, plr, 100,100,255,true)
		end
	end
end)

addCommandHandler("satinal", function(plr, cmd, komut)
	if isElementWithinColShape ( plr, alan) then
		for k,v in ipairs(tablo) do
			if komut == v.command then
				
						if v.silah then -- silah olarak çıkanlar
							if exports.vrp_global:takeMoney(plr, v.price) then
							local serials = tonumber(getElementData(plr, "account:character:id"))
								local weaponserials = exports.vrp_global:createWeaponSerial( 1, serials)
								exports.vrp_global:giveItem(plr, 115, v.weaponid..":"..weaponserials..":"..getWeaponNameFromID(v.weaponid).."::") 
								outputChatBox("[!]#ffffff "..v.isim.." 1 adet satın aldınız.$"..v.price, plr, 0,255,0,true)
								end
							else -- normal item olarak çıkanlar
								if  v.vip then
								
									if not getElementData(plr, "vip") then
									outputChatBox("[!]#ffffff Maalesef vip değilsiniz.",plr,255,0,0,true)
									return end
									outputChatBox("[!]#ffffff 1 adet vip eşyası aldınız.",plr,0,255,0,true)
								else
								if exports.vrp_global:takeMoney(plr, v.price) then
									exports.vrp_global:giveItem(plr, v.itemid, 1)
									outputChatBox("[!]#ffffff "..v.isim.." 1 adet satın aldınız.$"..v.price, plr, 0,255,0,true)
									end
								end
							
					
				end
			end
		end
	end
end)