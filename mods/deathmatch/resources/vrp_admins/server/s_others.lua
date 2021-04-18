local mysql = exports.vrp_mysql

function getKey(thePlayer, commandName)
	if exports.vrp_integration:isPlayerHeadAdmin(thePlayer) then
		local adminName = getPlayerName(thePlayer):gsub(" ", "_")
		local veh = getPedOccupiedVehicle(thePlayer)
		if veh then
			local vehID = getElementData(veh, "dbid")
			
			givePlayerItem(thePlayer, "giveitem" , adminName, "3" , tostring(vehID))
			
			return true
		else
			local intID = getElementDimension(thePlayer)
			if intID then
				local foundIntID = false
				local keyType = false
				local possibleInteriors = getElementsByType("interior")
				for _, theInterior in pairs (possibleInteriors) do
					if getElementData(theInterior, "dbid") == intID then
						local intType = getElementData(theInterior, "status")[1] 
						if intType == 0 or intType == 2 or intType == 3 then
							keyType = 4 --Yellow key
						else
							keyType = 5 -- Pink key
						end
						foundIntID = intID
						break
					end
				end
				
				if foundIntID and keyType then
					givePlayerItem(thePlayer, "giveitem" , adminName, tostring(keyType) , tostring(foundIntID))
					
					return true
				else
					outputChatBox(" You're not in any vehicle or possible interior.", thePlayer, 255,0 ,0 )
					return false
				end
			end
		end
	end
end
addCommandHandler("getkey", getKey, false, false)

function generateFakeIdentity(player, cmd)
	local birlik = getElementData(player, "faction")
	if birlik == 4 then
		if getElementData(player, "fakename") then
			exports.vrp_anticheat:changeProtectedElementDataEx(player, "fakename", false, true)
			exports["vrp_infobox"]:addBox(player, "error", "Sahte kimliğini sildin.")
			return false
		end
		
		local name = exports.vrp_global:createRandomMaleName()
		
		exports.vrp_anticheat:changeProtectedElementDataEx(player, "fakename", name, true)
		exports["vrp_infobox"]:addBox(player, "success", "Başarıyla sahte kimliğini aktif ettin.")
		triggerEvent("fakemyid", player)
	end
end
addCommandHandler("sahtekimlik", generateFakeIdentity, false, false)

function setSvPassword(thePlayer, commandName, password)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Password without spaces, empty to remove pw] - Set/remove server's password", thePlayer, 255, 194, 14)
		if password and string.len(password) > 0 then
			if setServerPassword(password) then
				exports.vrp_global:sendMessageToStaff("[SYSTEM] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has set server's password to '"..password.."'.", true)
			end
		else
			if setServerPassword('') then
				exports.vrp_global:sendMessageToStaff("[SYSTEM] "..exports.vrp_global:getPlayerFullIdentity(thePlayer).." has removed server's password.", true)
			end
		end
	end
end
addCommandHandler("setserverpassword", setSvPassword, false, false)
addCommandHandler("setserverpw", setSvPassword, false, false)

--Sehre
function sehreGonder(thePlayer, cmd, target)
	if exports.vrp_integration:isPlayerSupporter(thePlayer) or exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		if not target then
			outputChatBox("| Komut |: /" .. cmd .. " [Oyuncunun Adı]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, target )
			if isPedInVehicle(targetPlayer) then
				outputChatBox("[!] #f0f0f0Kişi araçta olduğu için işlem iptal edildi.", thePlayer, 0, 255, 0, true)
			return end
			setElementPosition(targetPlayer, 1539.7998046875, -1722.1484375, 13.55456161499)
			setElementInterior(targetPlayer, 0)
			setElementDimension(targetPlayer, 0)
			outputChatBox("[!] #f0f0f0Başarıyla şehre gönderildiniz!", targetPlayer, 0, 255, 0, true)
			outputChatBox("[!] #f0f0f0Kişi başarıyla şehre gönderildi!", thePlayer, 0, 255, 0, true)
			exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuyu şehre ışınladı")
		end
	end
end
addCommandHandler("sehre", sehreGonder)

function infoRolDersi(thePlayer)
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		exports["vrp_infobox"]:addBox(thePlayer, "info", "Sohbete bakınız.")
		outputChatBox("-#f9f9f9 /rdonayla [Karakter Adı & ID] - Rol dersi almış kişiyi doğrular.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdeksik [Karakter Adı & ID] - Rol dersi almış kişinin rol bilgisini eksik işaretler.", thePlayer, 230, 30, 30, true)		
		outputChatBox("-#f9f9f9 /rdalabilecekler - 50 saat ve altı rol dersi alması gereken oyuncuları gösterir.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdkontrol [Karakter Adı & ID] - Rol dersi kontrolü.", thePlayer, 230, 30, 30, true)
		outputChatBox("-#f9f9f9 /rdeksikler - Rol dersi testini geçememiş kişileri görüntüler.", thePlayer, 230, 30, 30, true)
	end
end
addCommandHandler("roldersilistele", infoRolDersi)

function giveRolDersi(thePlayer, commandName, targetPlayer, ...)
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)	
		if targetPlayer then
				if getElementData(targetPlayer, "roldersi") == 1 then exports["vrp_infobox"]:addBox(thePlayer, "error", "Bu şahısın zaten rol dersi onaylanmış.") return end
		    local affectedElements = { }
			exports['vrp_admins']:addAdminHistory(targetPlayer, thePlayer, "Rol Dersini Geçti", 8, 1)
			setElementData(targetPlayer, "roldersi", 1)
			dbExec(mysql:getConnection(), "UPDATE characters SET roldersi=1 WHERE id=" .. (getElementData(targetPlayer, "dbid")))	
			setElementData(thePlayer, "rdstats", getElementData(thePlayer, "rdstats")+1)
			dbExec(mysql:getConnection(), "UPDATE accounts SET rdstats="..(getElementData(thePlayer, "rdstats")+1).." WHERE id=" .. (getElementData(thePlayer, "dbid")))			
			exports["vrp_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncunun rol bilgisinin olduğunu doğruladınız.")
			exports["vrp_infobox"]:addBox(targetPlayer, "success", "Rol bilginizin yeterli olduğu bir yetkili tarafından doğrulandı.")
			exports.vrp_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun rol bilgisini doğruladı.")
		else
			exports["vrp_infobox"]:addBox(thePlayer, "error", "Kullanımı: /rdonayla [Karakter Adı & ID]")
		end
	end
end
addCommandHandler("rdonayla", giveRolDersi)

function takeRolDersi(thePlayer, commandName, targetPlayer, ...)
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)				
		if targetPlayer then
				if getElementData(targetPlayer, "roldersi") == 2 then exports["vrp_infobox"]:addBox(thePlayer, "error", "Bu şahısın zaten rol dersi eksik olarak girilmiş.") return end
		    local affectedElements = { }
			exports['vrp_admins']:addAdminHistory(targetPlayer, thePlayer, "Rol Dersini Geçemedi", 8, 0)
			setElementData(targetPlayer, "roldersi", 2)
			dbExec(mysql:getConnection(),  "UPDATE characters SET roldersi=2 WHERE id=" .. (getElementData(targetPlayer, "dbid")))

			dbExec(mysql:getConnection(), "UPDATE accounts SET rdstats=1 WHERE id="..getElementData(thePlayer, "dbid"))
			exports["vrp_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncunun rol bilgisinin eksik olduğunu doğruladınız.")
			exports["vrp_infobox"]:addBox(targetPlayer, "error", "Rol dersi testini geçemediniz, rol bilginiz: eksik.")
			exports.vrp_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun rol bilgisini 'Eksik' olarak girdi.")
		else
			exports["vrp_infobox"]:addBox(thePlayer, "error", "Kullanımı: /rdeksik [Karakter Adı & ID]")
		end
	end
end
addCommandHandler("rdeksik", takeRolDersi)

function infoRdSuccess(thePlayer, cmd) 
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		exports["vrp_infobox"]:addBox(thePlayer, "info", "Sohbette rol dersi almaya müsait kişiler listelendi.")
		for _, player in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
			    if getElementData(player, "roldersi") == 0 or getElementData(player, "roldersi") == false or not getElementData(player, "roldersi") then
				    if getElementData(player, "hoursplayed") < 50 then -- 50 saati geçmeyenleri göster
					    outputChatBox("- #999fffID: #ffffff"..getElementData(player, "playerid").. "#999fff | Kişinin Adı: #ffffff"..getPlayerName(player).."#999fff | Toplam Saati: #ffffff"..getElementData(player, "hoursplayed").." saat.", thePlayer, 255, 0, 0, true)
					end
				end
			end
		end
	end
end
addCommandHandler("rdalabilecekler", infoRdSuccess)

function eksikRD(thePlayer, cmd) 
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		exports["vrp_infobox"]:addBox(thePlayer, "info", "Sohbette rol dersi eksik olan kişiler listelendi.")
		for _, player in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
			    if getElementData(player, "roldersi") == 2 then
					   outputChatBox("- #f54242ID: #ffffff"..getElementData(player, "playerid").. "#f54242 | Kişinin Adı: #ffffff"..getPlayerName(player).."#f54242 | Rol Dersi:#ffffff Eksik", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("rdeksikler", eksikRD)

function controlRd(thePlayer, cmd, targetPlayer, ...) 
	if (exports.vrp_integration:isPlayerAdminI(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
	    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)				
		local rd = getElementData(targetPlayer, "roldersi")
		
		if getElementData(targetPlayer, "loggedin") == 1 then
			if rd == 0 then
				exports["vrp_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersi almamış.")
			elseif rd == 1 then
				exports["vrp_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersini geçmiş.")
			elseif rd == 2 then
				exports["vrp_infobox"]:addBox(thePlayer, "info", getPlayerName(targetPlayer).." isimli oyuncu rol dersini eksik tamamlamış.")
			end
		end
		
	end
end
addCommandHandler("rdkontrol", controlRd)


function moneyFarmingControl(thePlayer, cmd) 
	if (exports.vrp_integration:isPlayerAdminI(thePlayer)) then
		exports["vrp_infobox"]:addBox(thePlayer, "info", "70 saatten az oynayıp 15.000 TL'den fazla parası olan kişiler listelendi.")
		for _, player in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do 
		    if getElementData(player, "loggedin") == 1 then
				local para = getElementData(player, "money")
				local banka = getElementData(player, "bankmoney")
				local toplam = para + banka
			    if getElementData(player, "hoursplayed") <= 70 and toplam > 15000 then
					   outputChatBox("- #ff825cKişi: #ffffff"..getPlayerName(player).." ("..getElementData(player, "playerid")..")#ff825c | Toplam Parası:#ffffff "..(getElementData(player, "money") + getElementData(player, "bankmoney")).. " TL#ff825c | Saati:#ffffff "..getElementData(player, "hoursplayed").. " saat.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("moneyfarming", moneyFarmingControl)

function AdminLoungeTeleport(sourcePlayer)
	if (exports.vrp_integration:isPlayerDeveloper(sourcePlayer) or exports.vrp_integration:isPlayerSupporter(sourcePlayer)) then
		setElementPosition(sourcePlayer, 275.761475, -2052.245605, 3085.291962 )
		setPedGravity(sourcePlayer, 0.008)
		setElementDimension(sourcePlayer, 0)
		setElementInterior(sourcePlayer, 0)
		
	end
end

addCommandHandler("adminlounge", AdminLoungeTeleport)
addCommandHandler("gmlounge", AdminLoungeTeleport)

function setetiket(thePlayer, commandName, targetPlayerName, etiketLevel)
local targetName = exports.vrp_global:getPlayerFullIdentity(thePlayer, 1)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if not targetPlayerName or not tonumber(etiketLevel)  then
			outputChatBox("Kullanım: #ffffff/" .. commandName .. " [İsim/ID] [VİP]", thePlayer, 255, 194, 14, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
				
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Player is not logged in.", thePlayer, 255, 0, 0 )
			else
				dbExec(mysql:getConnection(),"UPDATE `characters` SET `etiket`="..etiketLevel.." WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
				setElementData(targetPlayer, "etiket", tonumber(etiketLevel))
				outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin etiket seviyesini " .. etiketLevel .. " yaptın.", thePlayer, 0, 255, 0, true)
			    outputChatBox("[!]#ffffff"..targetName.." tarafından etiket seviyeniz " .. etiketLevel .. " yapıldı.", targetPlayer, 0, 255, 0,true)
			
			end
		end
	else
	    outputChatBox( "[!]#ffffffBu işlemi yapmaya yetkiniz bulunmamaktadır.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("etiketver", setetiket)

function youtuberd(thePlayer, cmd, komut, targetPlayerName)

    if not (exports.vrp_integration:isPlayerDeveloper(thePlayer)) then return end
    
    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
    local targetName = exports.vrp_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /youtuber [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /youtuber [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `youtuber`='1' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "youtuber", 1)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " Adlı Kişiye Youtuber Yetkisi Verildi.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." Tarafından size Youtuber yetkisi verildi.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `youtuber`='0' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "youtuber", 0)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin Youtuber yetkisini aldın.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından Youtuber yetkin alındı.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("youtuber", youtuberd)

function uykver(thePlayer, cmd, komut, targetPlayerName)

    if not exports.vrp_integration:isPlayerDeveloper(thePlayer) then return end
    
    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
    local targetName = exports.vrp_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /uyk [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /uyk [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `accounts` SET `uyk`='1' WHERE `id`='"..getElementData(targetPlayer, "account:id").."'")
		setElementData(targetPlayer, "uyk", 1)
		setElementData(targetPlayer, "uyk_duty", false)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " Adlı kişiyi Üst Yönetim Kuruluna Aldınız.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." Sizi Üst Yönetim Kuruluna Aldı.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `accounts` SET `uyk`='0' WHERE `id`='"..getElementData(targetPlayer, "account:id").."'")
		setElementData(targetPlayer, "uyk", 0)
		setElementData(targetPlayer, "uyk_duty", false)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " Adlı Kişiyi Üst Yönetim Kurulundan Aldınız.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." Tarafından Üst Yönetim Kurulundan Çıkarıldınız.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("uyk", uykver)

function _uduty(player, command)
	if getElementData(player, "loggedin") == 1 then
		if getElementData(player, "uyk") == 1 then
			if getElementData(player, "uyk_duty") then
				setElementData(player, "uyk_duty", false)
				exports.vrp_global:updateNametagColor(player)
			else
				setElementData(player, "uyk_duty", true)
				exports.vrp_global:updateNametagColor(player)
			end
		end
	end
end
addCommandHandler("uduty", _uduty)
