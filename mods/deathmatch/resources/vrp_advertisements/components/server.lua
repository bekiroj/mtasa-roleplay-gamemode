local advertisementMessages = { "samp", "arıyorum", "aranır", "istiyom", "istiyorum", "SA-MP", "oyuncak", "boncuk", "silah", "peynir", "baharat", "deagle",  "colt", "mp", "ak", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "Kye", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local adverts = {}
local timers = {}
addEvent("adverts:receive", true)
addEventHandler("adverts:receive", root,
	function(player, message)
		if isTimer(timers[getElementData(player, "dbid")]) then
			outputChatBox("Yalnıza 5 dakikada bir reklam atabilirsiniz.", player, 255, 255, 255, true)
		return
		end
		
		if exports.vrp_global:hasMoney(player, 100) then
			timers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*5, 1)
			for k,v in ipairs(advertisementMessages) do
				local found = string.find(string.lower(message), "%s" .. tostring(v))
				local found2 = string.find(string.lower(message), tostring(v) .. "%s")
				if (found) or (found2) or (string.lower(message)==tostring(v)) then
					exports.vrp_global:sendMessageToAdmins("AdmWrn: " .. tostring(getPlayerName(player)) .. " reklam verirken tehlikeli kelimelere rastlandı.")
					exports.vrp_global:sendMessageToAdmins("AdmWrn: Reklam mesajı: " .. tostring(message))
					outputChatBox("[-]#ffffff Reklam verirken hatalı kelimelere rastlandı, silip tekrar reklam atınız.", player, 255, 0, 0, true)
					outputChatBox("[-]#ffffff İl-legal reklam atacaksanız F11'de bulunan Deep Web Reklam Bölgesine gidiniz.", player, 255, 0, 0, true)
					return
				end
			end
			local upperCount = 0
			for i=1, #message do
				local message = message:sub(i, i+1)
				if message == message:upper() then
					upperCount = upperCount + 1
				end
			end
		
			if (upperCount >= #message) then
				message = message:lower()
				message = tostring(message):gsub("^%l", string.upper)
			end
			local playerItems = exports["vrp_vrp_items"]:getItems(player)
			local phoneNumber = "-"
			for index, value in ipairs(playerItems) do
				if value[1] == 2 then
					phoneNumber = value[2]
				end
			end
			advertID = #adverts + 1;
			adverts[advertID] = player:getData("dbid");
			exports.vrp_global:takeMoney(player, 100)
			outputChatBox("[!]#ffffff Reklamınız başarıyla verildi, 10 saniye içinde yayınlanacak.", player, 0, 255, 0, true)
			outputChatBox("[!]#ffffff Reklam iptali için: /reklamiptal "..advertID, player, 0, 255, 0, true)
			--exports["progressbar"]:drawProgressBar("BBC", "Lütfen bekleyiniz..",player, 0, 220, 0, 10000)			
			exports.vrp_global:sendMessageToAdmins("AdmWrn: "..player.name.." reklam verdi:")
			exports.vrp_global:sendMessageToAdmins("AdmWrn: Reklam içeriği: "..message.." - Reklam iptali için /reklamiptal "..advertID)
			
			Timer(
				function(adID, plr)
					if isElement(player) then
						if adverts[advertID] then
							for _, arrPlayer in ipairs(getElementsByType("player")) do
								if not getElementData(arrPlayer, "togNews") then
									outputChatBox("[BBC] "..message, arrPlayer, 0, 255, 0)
									outputChatBox("[BBC] İletişim: "..phoneNumber.." // "..getPlayerName(player):gsub("_", " "), arrPlayer, 0, 255, 0)
								end
							end
						else
							exports.vrp_global:giveMoney(player, 100)
						end
					end
				end,
			10000, 1, advertID, plr)
	
			
		else
			outputChatBox("[!]#ffffff Reklam oluşturabilmek için 100$ gerekiyor.", player, 255, 0, 0, true)
		end
	end
)

addCommandHandler("reklamiptal",
	function(player, cmd, id)
		id = tonumber(id)
		if id and exports.vrp_integration:isPlayerTrialAdmin(player) or adverts[id] == player:getData("dbid") and adverts[id] and id and adverts[id] then
			adverts[(id)] = false
			outputChatBox("[!]#ffffff Reklam başarıyla iptal edildi.", player, 0, 255, 0, true)
			exports.vrp_global:sendMessageToAdmins("AdmWrn: ["..player.name.."] son reklamı iptal etti, yayınlanmayacak.")
		end
	end
)
