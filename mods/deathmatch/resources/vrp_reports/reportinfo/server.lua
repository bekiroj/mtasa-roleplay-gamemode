
addCommandHandler("rapordurum", function(thePlayer,cmd,komut)
	if (exports.vrp_global:isStaffOnDuty(thePlayer)) then

	if not komut then
		outputChatBox("[-]#f9f9f9 /"..cmd.." [ac & kapat] yazarak sistemi aktif/deaktif edebilirsiniz.", thePlayer, 255, 194, 14, true)
	return end
	
	if komut == "ac" then
		triggerClientEvent ( thePlayer, "raporac:tetikle", thePlayer, true )
		outputChatBox("[-]#f9f9f9 Başarıyla rapor kontrol arayüzünü aktif ettiniz.", thePlayer, 122, 255, 158, true)
	end

	if komut == "kapat" then
		outputChatBox("[-]#f9f9f9 Başarıyla rapor kontrol arayüzünü aktif ettiniz.", thePlayer, 250, 115, 87, true)
		triggerClientEvent ( thePlayer, "raporkapat:tetikle", thePlayer, true )
	end
	
	else
		outputChatBox("[-]#f9f9f9 Bu komutu kullanabilmek için görevde olmalısınız.", thePlayer, 200,0,0, true)
	end
	
end)
