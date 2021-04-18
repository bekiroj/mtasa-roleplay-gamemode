local advertisementMessages = { "samp", "arıyorum", "aranır", "istiyom", "arıyorum", "lazım", "istiyorum", "SA-MP", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "inception", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local adverts = {}
local timers = {}
addEvent("deepweb:receive", true)
addEventHandler("deepweb:receive", root,
	function(player, message)
		if isTimer(timers[getElementData(player, "dbid")]) then
			exports["vrp_infobox"]:addBox(player, "error", "Yalnızca 30 dakikada bir paylaşımda bulunabilirsiniz.")
		return
		end
		
		if exports.vrp_global:hasMoney(player, 300) or player:getData("vip") > 0 then
			timers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*30, 1)
			for k,v in ipairs(advertisementMessages) do
				local found = string.find(string.lower(message), "%s" .. tostring(v))
				local found2 = string.find(string.lower(message), tostring(v) .. "%s")
				if (found) or (found2) or (string.lower(message)==tostring(v)) then
					exports.vrp_global:sendMessageToAdmins("AdmWrn: " .. tostring(getPlayerName(player)) .. " paylaşımda bulunurken tehlikeli kelimelere rastlandı.")
					exports.vrp_global:sendMessageToAdmins("AdmWrn: Paylaşım mesajı: " .. tostring(message))
					exports["vrp_infobox"]:addBox(player, "error", "Paylaşımda bulunurken hatalı kelimelere rastladınız.")
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
			local playerItems = exports["vrp_items"]:getItems(player)
			local phoneNumber = "-"
			for index, value in ipairs(playerItems) do
				if value[1] == 2 then
					phoneNumber = value[2]
				end
			end
			advertID = #adverts + 1;
			adverts[advertID] = player:getData("dbid");
			if player:getData("vip") == 0 then
				exports.vrp_global:takeMoney(player, 300)
			end
			exports["vrp_infobox"]:addBox(player, "success", "Başarıyla paylaşımda bulundunuz, 15 saniye içerisinde doğrulanıp paylaşılacak.")
			exports["vrp_infobox"]:addBox(player, "error", "İptal etmek için: /paylasimiptal "..advertID)
			exports["vrp_progressbar"]:drawProgressBar("Deep Web", "Paylaşımın doğrulanıyor.",player, 255, 0, 0, 15000)			
			exports.vrp_global:sendMessageToAdmins("AdmWrn: "..player.name.." paylaşım gönderdi:")
			exports.vrp_global:sendMessageToAdmins("AdmWrn: Paylaşım içeriği: "..message.." - Paylaşım iptali için /paylasimiptal "..advertID)
			
			Timer(
				function(adID, plr)
					if isElement(player) then
						if adverts[advertID] then
							for _, arrPlayer in ipairs(getElementsByType("player")) do
								local theTeam = getPlayerTeam(arrPlayer)
								local factionType = getElementData(theTeam, "type")
								
								if factionType == 0 or factionType == 1 or factionType == 5 then
									if not getElementData(arrPlayer, "togNews") then
										outputChatBox("[Deep Web] "..message, arrPlayer, 120, 65, 111)
										outputChatBox("[Deep Web] Bana Hemen Ulaşın: "..phoneNumber.." // "..getPlayerName(player):gsub("_", " "), arrPlayer, 120, 65, 111, true)
									end
								end
							end
						else
							exports.vrp_global:giveMoney(player, 300)
						end
					end
				end,
			15000, 1, advertID, plr)
	
			
		else
			exports["vrp_infobox"]:addBox(player, "error", "Paylaşımda bulunabilmeniz için 300 TL'ye ihtiyacınız var.")
		end
	end
)

addCommandHandler("paylasimiptal",
	function(player, cmd, id)
		id = tonumber(id)
		if id and exports.vrp_integration:isPlayerTrialAdmin(player) or adverts[id] == player:getData("dbid") and adverts[id] and id and adverts[id] then
			adverts[(id)] = false
			exports["vrp_infobox"]:addBox(player, "success", "Başarıyla paylaşımı iptal ettiniz.")
			exports.vrp_global:sendMessageToAdmins("AdmWrn: ["..player.name.."] son paylaşımı iptal etti, yayınlanmayacak.")
		end
	end
)
