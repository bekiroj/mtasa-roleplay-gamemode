local mysql = exports.vrp_mysql

function getElementDataEx(theElement, theParameter)
	return getElementData(theElement, theParameter)
end

function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	setElementData(theElement, theParameter, theValue)
	return true
end

function resourceStart(resource)
	setWaveHeight ( 0 )
	setGameType("Roleplay")
	setMapName("Los Santos")
	setRuleValue("Mode Version", exports.vrp_global:getScriptVersion())
	setRuleValue("Açıklama", "Valhalla")
	setRuleValue("Website", "N/A")
	for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
		triggerEvent("playerJoinResourceStart", value, resource)
	end
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), resourceStart)

function onJoin()
	local skipreset = false
	local loggedIn = getElementData(source, "loggedin")
	if loggedIn == 1 then
		skipreset = true
		setElementDataEx(source, "account:seamless:validated", true, false, true)
	end
	if not skipreset then 
		setElementData(source, "loggedin", 0, false)
		setElementData(source, "account:loggedin", false, false)
		setElementData(source, "account:username", "", false)
		setElementData(source, "account:id", "", false)
		setElementData(source, "dbid", false)
		setElementData(source, "admin_level", 0, false)
		setElementData(source, "hiddenadmin", 0, false)
		setElementData(source, "globalooc", 1, false)
		setElementData(source, "muted", 0, false)
		setElementData(source, "loginattempts", 0, false)
		setElementData(source, "timeinserver", 0, false)
		setElementData(source, "chatbubbles", 0, false)
		setElementDimension(source, 9999)
		setElementInterior(source, 0)
	end
	exports.vrp_global:updateNametagColor(source)
end
addEventHandler("onPlayerJoin", getRootElement(), onJoin)
addEvent("playerJoinResourceStart", false)
addEventHandler("playerJoinResourceStart", getRootElement(), onJoin)

function resetNick(oldNick, newNick)
	setElementData(client, "legitnamechange", 1)
	setPlayerName(client, oldNick)
	setElementData(client, "legitnamechange", 0)
	exports.vrp_global:sendMessageToAdmins("Admin Warn: " .. tostring(oldNick) .. " kendi adını değiştirmek için çalıştı " .. tostring(newNick) .. ".")
end
addEvent("resetName", true )
addEventHandler("resetName", getRootElement(), resetNick)

function clientReady()
	local thePlayer = source
	local resources = getResources()
	local missingResources = false
	for key, value in ipairs(resources) do
		local resourceName = getResourceName(value)
		if resourceName == "global" or resourceName == "mysql" or resourceNmae == "pool" then
			if getResourceState(value) == "loaded" or getResourceState(value) == "stopping" or getResourceState(value) == "failed to load" then
				missingResources = true
				outputChatBox("Sunucu bağımlı kaynak eksik '"..getResourceName(value).."'.", thePlayer, 255, 0, 0)
				outputChatBox("Kısa bir süre sonra tekrar deneyiniz", thePlayer, 255, 0, 0)
				break
			end
		end
	end
	if missingResources then return end
	if not willPlayerBeBanned then
		triggerClientEvent(thePlayer, "beginLogin", thePlayer)
	else
		triggerClientEvent(thePlayer, "beginLogin", thePlayer, "Banned.")
	end
end
addEvent("onJoin", true)
addEventHandler("onJoin", getRootElement(), clientReady)

addEventHandler("accounts:login:request", getRootElement(), 
	function ()
		local seamless = getElementData(client, "account:seamless:validated")
		if seamless == true then
			setElementData(client, "account:seamless:validated", false, false, true)
			triggerClientEvent(client, "accounts:options", client)
			triggerClientEvent(client, "item:updateclient", client)
			return
		end
		triggerClientEvent(client, "accounts:login:request", client)
	end
);

local accountCharacters = {}
local onlineForPlayer = {}

function validateCredentials(username,password,checksave)
	if not (username == "") then
		if not (password == "") then	
			return true
		else
			triggerClientEvent(client,"set_warning_text",client,"Login","Please enter your password!")
		end
	else
		triggerClientEvent(client,"set_warning_text",client,"Login","Please enter your username!")
	end
	return false
end
addEvent("onRequestLogin",true)
addEventHandler("onRequestLogin",getRootElement(),validateCredentials)

function playerLogin(username,password,checksave)
	if not validateCredentials(username,password,checksave) then
		return false
	end

	dbQuery(loginCallback, {client,username,password}, mysql:getConnection(), "SELECT * FROM `accounts` WHERE `username`='".. username .."'")
end
addEvent("accounts:login:attempt",true)
addEventHandler("accounts:login:attempt",getRootElement(),playerLogin)

function loginCallback(queryHandler,source,username,password)
	local result, rows, err = dbPoll(queryHandler, 0)
	if rows > 0 then
		row = result[1]

		local encryptionRule = row["salt"]
		local encryptedPW = string.lower(md5(string.lower(md5(password))..encryptionRule))
		if row["password"] ~= encryptedPW then
			triggerClientEvent(source,"set_warning_text",source,"Login",username.." kullanıcı adı için şifreler eşleşmiyor!")
			return
		end

		if (onlineForPlayer[row["id"]]) then
			thePlayer = onlineForPlayer[tonumber(row["id"])]
			if (thePlayer ~= source) then
				kickPlayer(thePlayer, thePlayer, "Bir kullanıcı hesabınıza giriş yaptı!")
				--triggerClientEvent(source,"set_authen_text",source,"Login","Hesabınızda başka bir kullanıcı bulunuyor, diğer kullanıcı sunucudan uzaklaştırıldı!")
			end
		end
		onlineForPlayer[tonumber(row["id"])] = source
		dbExec(mysql:getConnection(), "UPDATE accounts SET online='1' WHERE id = ?", tonumber(row["id"]))
		
		
		triggerClientEvent(source, "items:inventory:hideinv", source)
		
		setElementDataEx(source, "account:loggedin", true, true)
		setElementDataEx(source, "account:id", tonumber(row["id"]), true)
		local acID = tonumber(row['id'])
		setElementDataEx(source, "account:username", row["username"], true)
		setElementDataEx(source, "account:charLimit", tonumber(row["characterlimit"]), true)
		setElementDataEx(source, "electionsvoted", row["electionsvoted"], true)
		setElementDataEx(source, "account:email", row["email"])
		setElementDataEx(source, "account:creationdate", row["registerdate"])
		setElementDataEx(source, "account:email", row["email"])
		setElementDataEx(source, "credits", tonumber(row["credits"]))
		
		setElementDataEx(source, "admin_level", tonumber(row['admin']), true)
		setElementDataEx(source, "supporter_level", tonumber(row['supporter']), true)
		setElementDataEx(source, "vct_level", tonumber(row['vct']), true)
		setElementDataEx(source, "mapper_level", tonumber(row['mapper']), true)
		setElementDataEx(source, "scripter_level", tonumber(row['scripter']), true)
		setElementDataEx(source, "uyk", tonumber(row["uyk"]), true)
		setElementDataEx(source, "bakiye", tonumber(row["bakiye"]) or 0, true)
		local tablolar = row["custom_animations"]
        if type(fromJSON(tablolar)) ~= "table" then tablolar = toJSON ( { } ) end
        local animler = fromJSON(tablolar or toJSON ( { } ))
        table.insert(animler, block)
        setElementData(source, "custom_animations", animler)
		exports['vrp_reports']:reportLazyFix(source)
		setElementDataEx(source, "adminreports", tonumber(row["adminreports"]), true)
		setElementDataEx(source, "adminreports_saved", tonumber(row["adminreports_saved"]))
		if tonumber(row['referrer']) and tonumber(row['referrer']) > 0 then
			setElementDataEx(source, "referrer", tonumber(row['referrer']), false, true)
		end
		
		if exports.vrp_integration:isPlayerLeadAdmin(source) then
			setElementDataEx(source, "hiddenadmin", row["hiddenadmin"], true)
		else
			setElementDataEx(source, "hiddenadmin", 0, true)
		end

		local vehicleConsultationTeam = exports.vrp_integration:isPlayerVehicleConsultant(source)
		setElementDataEx(source, "vehicleConsultationTeam", vehicleConsultationTeam, false)

		if tonumber(row["adminjail"]) == 1 then
			setElementDataEx(source, "adminjailed", true, true)
		else
			setElementDataEx(source, "adminjailed", false, true)
		end
		setElementDataEx(source, "jailtime", tonumber(row["adminjail_time"]), true)
		setElementDataEx(source, "jailadmin", row["adminjail_by"], true)
		setElementDataEx(source, "jailreason", row["adminjail_reason"], true)

		if row["monitored"] ~= "" then
			setElementDataEx(source, "admin:monitor", row["monitored"], true)
		end

		dbExec(mysql:getConnection(), "UPDATE `accounts` SET `ip`='" .. getPlayerIP(source) .. "', `mtaserial`='" .. getPlayerSerial(source) .. "' WHERE `id`='".. tostring(row["id"]) .."'")
		setElementDataEx(source, "jailreason", row["adminjail_reason"], true)

		setElementData(source, "forum_name", row["forum_name"])

		-- Militan
		for i=1, 6 do
			setElementData(source, "job_level:"..i, row["jlevel_"..i])
		end

		loadAccountSettings(source, row["id"])

	
		triggerClientEvent (source,"hideLoginWindow",source)
		triggerClientEvent(source, "vehicle_rims", source)
		local characters = {}
		dbQuery(
			function(qh, source)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						if value.cked == 0 then
							local i = #characters + 1
							if not characters[i] then
								characters[i] = {}
							end
							characters[i][1] = value.id
							characters[i][2] = value.charactername
							characters[i][3] = tonumber(value.cked)
							characters[i][4] = ""
							characters[i][5] = value.age
							characters[i][6] = value.gender
							characters[i][9] = value.skin
							characters[i][11] = value.height
							characters[i][12] = value.weight
						end
					end
				end
				setElementData(source, "account:characters", characters)
				triggerClientEvent(source, "accounts:login:attempt", source, 0 )
				triggerEvent( "social:vrp_account", source, tonumber( row["id"] ) )
			end,
		{source}, mysql:getConnection(), "SELECT * FROM characters WHERE account = ?", tonumber(row["id"]))
				
			
	else
		triggerClientEvent(source,"set_warning_text",source,"Login","Kullanıcı adı veritabanında bulunamadı! ('".. username .."')")
	end
end

addEventHandler("onPlayerQuit", root,
	function()
		onlineForPlayer[getElementData(source, "account:id")] = false
		dbExec(mysql:getConnection(), "UPDATE accounts SET online='0' WHERE id = ?", tonumber(getElementData(source, "account:id")))
	end
)

function playerRegister(username,password,confirmPassword, email)
	local mtaSerial = getPlayerSerial(client)
	local encryptionRule = tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))
	local encryptedPW = string.lower(md5(string.lower(md5(password))..encryptionRule))
	local ipAddress = getPlayerIP(client)
	
	dbQuery(playerRegisterCallback, {client, username, password, mtaSerial, ipAddress, encryptedPW, encryptionRule, email}, mysql:getConnection(), "SELECT username,mtaserial FROM accounts WHERE (username = ? or mtaserial = ?)", username, mtaSerial)
end
addEvent("accounts:register:attempt",true)
addEventHandler("accounts:register:attempt",getRootElement(),playerRegister)

function playerRegisterCallback(queryHandler, client, username, password, serial, ip, encryptedPW, encryptionRule, email)
	local result, rows, err = dbPoll(queryHandler, 0)
	if rows > 0 then
		triggerClientEvent(client,"set_warning_text",client,"Register","Kullanıcı adı/email kullanılıyor veya yeni bir hesap oluşturmaya çalışıyorsun! ("..result[1]["username"]..")")
	else
		dbExec(mysql:getConnection(), "INSERT INTO `accounts` SET `username`='"..username.."', `password`='"..encryptedPW.."', `email`='"..email.."', `registerdate`=NOW(), `ip`='"..ip.."', `salt`='"..encryptionRule.."', `mtaserial`='"..serial.."', `activated`='1' ")
		triggerClientEvent(client,"accounts:register:complete",client, username, password)
	end
end


function myCallback( responseData, errno, id )
    if errno == 0 then
        exports.vrp_cache:addImage(id, responseData)
	end
end

addEventHandler("onResourceStart", resourceRoot,
	function()
		imported_accounts = {}
		imported_characters = {}
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						imported_accounts[#imported_accounts + 1] = row_info
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `accounts`")
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						row_info = {}
						for count, data in pairs(value) do
							row_info[count] = data
						end
						imported_characters[#imported_characters + 1] = row_info
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM `characters`")
	end
)

function updateTables()
	imported_accounts, imported_characters = {}, {}
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_accounts[#imported_accounts + 1] = row_info
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `accounts`")
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					row_info = {}
					for count, data in pairs(value) do
						row_info[count] = data
					end
					imported_characters[#imported_characters + 1] = row_info
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `characters`")
end

function getTableInformations()
	return imported_accounts, imported_characters
end

function characterList(theClient)
	local dbid = getElementData(theClient, "account:id")
	local accounts, character = getTableInformations() -- // Militan

	local characters = {}
	for index, value in ipairs(character) do
		if value.account == dbid and value.cked == 0 then
			local i = #characters + 1
			if not characters[i] then
				characters[i] = {}
			end
			characters[i][1] = value.id
			characters[i][2] = value.charactername
			characters[i][3] = tonumber(value.cked)
			characters[i][4] = ""
			characters[i][5] = value.age
			characters[i][6] = value.gender
			characters[i][9] = value.skin
			characters[i][11] = value.height
			characters[i][12] = value.weight
		end
	end
	return characters
end

function reloadCharacters()
	local chars = characterList(source)
	--setElementData(source, "account:characters", chars, true)
	setElementData(source, "account:characters", chars)
end
addEvent("updateCharacters", true)
addEventHandler("updateCharacters", getRootElement(), reloadCharacters)


function reconnectMe()
    redirectPlayer(client, "", 0 )
end
addEvent("accounts:reconnectMe", true)
addEventHandler("accounts:reconnectMe", getRootElement(), reconnectMe)
 

function adminLoginToPlayerCharacter(thePlayer, commandName, ...)
    if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) then
        if not (...) then
            outputChatBox("KULLANIM: /" .. commandName .. " [Tam karakter adı]", thePlayer, 255, 194, 14, false)
            outputChatBox("Oyuncunun karakterine ait loglar görüntüleniyor.", thePlayer, 255, 194, 0, false)
        else
            targetChar = table.concat({...}, "_")
            dbQuery(loginCharacterAdminCallback, {thePlayer, targetChar}, mysql:getConnection(), "SELECT `characters`.`id` AS `targetCharID` , `characters`.`account` AS `targetUserID` , `accounts`.`admin` AS `targetAdminLevel`, `accounts`.`username` AS `targetUsername` FROM `characters` LEFT JOIN `accounts` ON `characters`.`account`=`accounts`.`id` WHERE `charactername`='"..targetChar.."' LIMIT 1")
        end
    end
end
addCommandHandler("loginto", adminLoginToPlayerCharacter, false, false)
 
function loginCharacterAdminCallback(qh, thePlayer, name)
	local res, rows, err = dbPoll(qh, 0)
	if rows > 0 then
		local fetchData = res[1]
		local targetCharID = tonumber(fetchData["targetCharID"]) or false
        local targetUserID = tonumber(fetchData["targetUserID"]) or false
        local targetAdminLevel = tonumber(fetchData["targetAdminLevel"]) or 0
        local targetUsername = fetchData["targetUsername"] or false
        local theAdminPower = exports.vrp_global:getPlayerAdminLevel(thePlayer)
        if targetCharID and  targetUserID then
            local adminTitle = exports.vrp_global:getPlayerFullIdentity(thePlayer)
            if targetAdminLevel > theAdminPower then
                local adminUsername = getElementData(thePlayer, "account:username")
                outputChatBox("Sizden daha yüksek yetkiye sahip kişinin karakterine giriş yapamazsın.", thePlayer, 255,0,0)
                exports.vrp_global:sendMessageToAdmins("[GİRİŞ]: " .. tostring(adminTitle) .. " yüksek yetkiye sahip bir yöneticinin karakterine girmeye çalıştı ("..targetUsername..").")
                return false
            end
           
            spawnCharacter(targetCharID, targetUserID, thePlayer, targetUsername)  
            exports.vrp_global:sendMessageToAdmins("[GİRİŞ]: " .. tostring(adminTitle) .. " hesabına giriş yaptı, '"..targetUsername.."'.")
        end
	else
		outputChatBox("Karakter adı bulunamadı.", thePlayer, 255,0,0)
	end
end

addEvent("account:charactersQuotaCheck", true)
addEventHandler("account:charactersQuotaCheck", root,
    function(player)
        triggerClientEvent(player, "account:charactersQuotaCheck", player, true, "Onaylandı")
    end
)

function spawnCharacter(characterID, remoteAccountID, theAdmin, targetAccountName, location)
	if theAdmin then
		client = theAdmin
	end
	
	if not client then
		return false
	end
	
	if not characterID then
		return false
	end
	
	if not tonumber(characterID) then
		return false
	end
	characterID = tonumber(characterID)
	
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)

	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0, true)
	
	local timer = getElementData(client, "pd.jailtimer")
	if isTimer(timer) then
		killTimer(timer)
	end
	
	if (getPedOccupiedVehicle(client)) then
		removePedFromVehicle(client)
	end
	-- End cleaning up
	
	local accountID = tonumber(getElementDataEx(client, "account:id"))
	
	local characterData = false
	
	if theAdmin then
		accountID = remoteAccountID
		sqlQuery = "SELECT * FROM `characters` LEFT JOIN `jobs` ON `characters`.`id` = `jobs`.`jobCharID` AND `characters`.`job` = `jobs`.`jobID` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "'"
	else
		sqlQuery = "SELECT * FROM `characters` LEFT JOIN `jobs` ON `characters`.`id` = `jobs`.`jobCharID` AND `characters`.`job` = `jobs`.`jobID` WHERE `id`='" .. tostring(characterID) .. "' AND `account`='" .. tostring(accountID) .. "' AND `cked`=0"
	end
	
	dbQuery(
		function(qh, client, characterID, remoteAccountID, theAdmin, targetAccountName, location)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				characterData = res[1]
				if characterData then
					if characterData["description"] then
						setElementDataEx(client, "look", fromJSON(characterData["description"]) or {"", "", "", "", characterData["description"], ""})
					end
					setElementDataEx(client, "weight", characterData["weight"])
					setElementDataEx(client, "height", characterData["height"])
					setElementDataEx(client, "race", tonumber(characterData["skincolor"]))
					setElementDataEx(client, "maxvehicles", tonumber(characterData["maxvehicles"]))
					setElementDataEx(client, "maxinteriors", tonumber(characterData["maxinteriors"]))
					--DATE OF BIRTH
					setElementDataEx(client, "age", tonumber(characterData["age"]))
					setElementDataEx(client, "month", tonumber(characterData["month"]))
					setElementDataEx(client, "day", tonumber(characterData["day"]))
					
					-- LANGUAGES
					local lang1 = tonumber(characterData["lang1"])
					local lang1skill = tonumber(characterData["lang1skill"])
					local lang2 = tonumber(characterData["lang2"])
					local lang2skill = tonumber(characterData["lang2skill"])
					local lang3 = tonumber(characterData["lang3"])
					local lang3skill = tonumber(characterData["lang3skill"])
					local currentLanguage = tonumber(characterData["currlang"]) or 1
					setElementDataEx(client, "languages.current", currentLanguage, false)
									
					if lang1 == 0 then
							lang1skill = 0
					end
					
					if lang2 == 0 then
							lang2skill = 0
					end
					
					if lang3 == 0 then
							lang3skill = 0
					end
					
					setElementDataEx(client, "languages.lang1", lang1, false)
					setElementDataEx(client, "languages.lang1skill", lang1skill, false)
					
					setElementDataEx(client, "languages.lang2", lang2, false)
					setElementDataEx(client, "languages.lang2skill", lang2skill, false)
					
					setElementDataEx(client, "languages.lang3", lang3, false)
					setElementDataEx(client, "languages.lang3skill", lang3skill, false)
					-- END OF LANGUAGES
					
					setElementDataEx(client, "timeinserver", tonumber(characterData["timeinserver"]), false)
					setElementDataEx(client, "account:character:id", characterID, false)
					setElementDataEx(client, "dbid", characterID, true) -- workaround
					exports['vrp_items']:loadItems( client, true )
					
					
					setElementDataEx(client, "loggedin", 1, true)
					
					-- Check his name isn't in use by a squatter
					local playerWithNick = getPlayerFromName(tostring(characterData["charactername"]))
					if isElement(playerWithNick) and (playerWithNick~=client) then
						if theAdmin then
							local adminTitle = exports.vrp_global:getPlayerAdminTitle(theAdmin)
							local adminUsername = getElementData(theAdmin, "account:username")
							kickPlayer(playerWithNick, getRootElement(), adminTitle.." "..adminUsername.." has logged into your account.")
							outputChatBox(""..targetAccountName.." ("..tostring(characterData["charactername"]):gsub("_"," ")..") adlı hesap oyundan atıldı.", theAdmin, 0, 255, 0 )
						else
							kickPlayer(playerWithNick, getRootElement(), "Başkası senin karakterinde oturum açmış olabilir.")
						end
					end
					
					setElementDataEx(client, "bleeding", 0, false)
					
					-- Set their name to the characters
					setElementDataEx(client, "legitnamechange", 1)
					setPlayerName(client, tostring(characterData["charactername"]))
					local pid = getElementData(client, "playerid")
					local fixedName = string.gsub(tostring(characterData["charactername"]), "_", " ")

					setElementDataEx(client, "legitnamechange", 0)
					
					setPlayerNametagShowing(client, false)
					setElementFrozen(client, true)
					setPedGravity(client, 0)
					
					local locationToSpawn = {}
					if location then
						locationToSpawn.x = location[1]
						locationToSpawn.y = location[2]
						locationToSpawn.z = location[3]
						locationToSpawn.rot = location[4]
						locationToSpawn.int = location[5]
						locationToSpawn.dim = location[6]
					else
						locationToSpawn.x = tonumber(characterData["x"])
						locationToSpawn.y = tonumber(characterData["y"])
						locationToSpawn.z = tonumber(characterData["z"])
						locationToSpawn.rot = tonumber(characterData["rotation"])
						locationToSpawn.int = tonumber(characterData["interior_id"])
						locationToSpawn.dim = tonumber(characterData["dimension_id"])
					end
					spawnPlayer(client, locationToSpawn.x ,locationToSpawn.y ,locationToSpawn.z , locationToSpawn.rot, tonumber(characterData["skin"]))
					setElementDimension(client, locationToSpawn.dim)
					setElementInterior(client, locationToSpawn.int , locationToSpawn.x, locationToSpawn.y, locationToSpawn.z)
					setCameraInterior(client, locationToSpawn.int)
					

					exports["vrp_items"]:loadItems(client)

					setCameraTarget(client, client)
					setElementHealth(client, tonumber(characterData["health"]))
					setPedArmor(client, tonumber(characterData["armor"]))
					
					local teamElement = nil
					if (tonumber(characterData["faction_id"])~=-1) then
						teamElement = exports.vrp_pool:getElement('team', tonumber(characterData["faction_id"]))
						if not (teamElement) then       -- Facshun does not exist?
							characterData["faction_id"] = -1
							dbExec(mysql:getConnection(), "UPDATE characters SET faction_id='-1', faction_rank='1' WHERE id='" .. tostring(characterID) .. "' LIMIT 1")
						end
					end
					
					if teamElement then
						setPlayerTeam(client, teamElement)
					else
						setPlayerTeam(client, getTeamFromName("Citizen"))
					end

					
					local adminLevel = getElementDataEx(client, "admin_level")
					local gmLevel = getElementDataEx(client, "account:gmlevel")
					exports.vrp_global:updateNametagColor(client)
					-- ADMIN JAIL
					local jailed = getElementData(client, "adminjailed")
					local jailed_time = getElementData(client, "jailtime")
					local jailed_by = getElementData(client, "jailadmin")
					local jailed_reason = getElementData(client, "jailreason")

					if location then
							setElementPosition(client, location[1], location[2], location[3])
							setElementPosition(client, location[4], 0, 0)
					end
					
					if jailed then
						local incVal = getElementData(client, "playerid")
								
						setElementDimension(client, 55000+incVal)
						setElementInterior(client, 6)
						setCameraInterior(client, 6)
						setElementPosition(client, 263.821807, 77.848365, 1001.0390625)
						setPedRotation(client, 267.438446)
												
						setElementDataEx(client, "jailserved", 0, false)
						setElementDataEx(client, "adminjailed", true)
						setElementDataEx(client, "jailreason", jailed_reason, false)
						setElementDataEx(client, "jailadmin", jailed_by, false)
						
						if jailed_time ~= 999 then
							if not getElementData(client, "jailtimer") then
								setElementDataEx(client, "jailtime", jailed_time+1, false)
								--exports['vrp_admins']:timerUnjailPlayer(client)
								triggerEvent("admin:timerUnjailPlayer", client, client)
							end
						else
							setElementDataEx(client, "jailtime", "Unlimited", false)
							setElementDataEx(client, "jailtimer", true, false)
						end

						
						setElementInterior(client, 6)
						setCameraInterior(client, 6)
					end
					
					setElementDataEx(client, "faction", tonumber(characterData["faction_id"]), true)
					setElementDataEx(client, "factionMenu", 0)
					local factionPerks = type(characterData["faction_perks"]) == "string" and fromJSON(characterData["faction_perks"]) or { }
					setElementDataEx(client, "factionPackages", factionPerks, true)
					setElementDataEx(client, "factionrank", tonumber(characterData["faction_rank"]), true)
					setElementDataEx(client, "factionphone", tonumber(characterData["faction_phone"]), true)
					setElementDataEx(client, "factionleader", tonumber(characterData["faction_leader"]), true)
					local factionPerks = type(characterData["faction_perms"]) == "string" and fromJSON(characterData["faction_perms"]) or {}
					setElementDataEx(client, "factionperms", factionPerms, true)
					
					setElementDataEx(client, "businessprofit", 0, false)
					setElementDataEx(client, "legitnamechange", 0)
					setElementDataEx(client, "muted", tonumber(muted))
					setElementDataEx(client, "minutesPlayed",  tonumber(characterData["minutesPlayed"]), true)
					setElementDataEx(client, "hoursplayed",  tonumber(characterData["hoursplayed"]), true)
					setPlayerAnnounceValue ( client, "score", characterData["hoursplayed"] )
					setElementDataEx(client, "alcohollevel", tonumber(characterData["alcohollevel"]) or 0, true)
					exports.vrp_global:setMoney(client, tonumber(characterData["money"]), true)
					exports.vrp_global:checkMoneyHacks(client)
					
					setElementDataEx(client, "restrain", tonumber(characterData["cuffed"]), true)
					setElementDataEx(client, "tazed", false, false)
					setElementDataEx(client, "realinvehicle", 0, false)
					
					local duty = tonumber(characterData["duty"]) or 0
					setElementDataEx(client, "duty", duty, true)
					
					-- Job system - MAXIME
					setElementDataEx(client, "job", tonumber(characterData["jobID"]) or 0, true)
					setElementDataEx(client, "jobLevel", tonumber(characterData["jobLevel"]) or 0, true)
					setElementDataEx(client, "jobProgress", tonumber(characterData["jobProgress"]) or 0, true)
					
					-- MAXIME JOB SYSTEM
					if tonumber(characterData["job"]) == 1 then
						if characterData["jobTruckingRuns"] then
							setElementDataEx(client, "job-system-trucker:truckruns", tonumber(characterData["jobTruckingRuns"]), true)
							dbExec(mysql:getConnection(), "UPDATE `jobs` SET `jobTruckingRuns`='0' WHERE `jobCharID`='"..tostring(characterID).."' AND `jobID`='1' " )
						end
						triggerClientEvent(client,"restoreTruckerJob",client)
					end
					triggerEvent("restoreJob", client)
					--triggerClientEvent(client, "updateCollectionValue", client, tonumber(characterData["photos"]))
					--------------------------------------------------------------------------
					setElementDataEx(client, "license.car", tonumber(characterData["car_license"]), true)
					setElementDataEx(client, "license.bike", tonumber(characterData["bike_license"]), true)
					setElementDataEx(client, "license.boat", tonumber(characterData["boat_license"]), true)
					setElementDataEx(client, "license.pilot", tonumber(characterData["pilot_license"]), true)
					setElementDataEx(client, "license.fish", tonumber(characterData["fish_license"]), true)
					setElementDataEx(client, "license.gun", tonumber(characterData["gun_license"]), true)
					setElementDataEx(client, "license.gun2", tonumber(characterData["gun2_license"]), true)
					
					setElementDataEx(client, "bankmoney", tonumber(characterData["bankmoney"]), true)
					setElementDataEx(client, "fingerprint", tostring(characterData["fingerprint"]), false)
					setElementDataEx(client, "tag", tonumber(characterData["tag"]))
					setElementDataEx(client, "blindfold", tonumber(characterData["blindfold"]), false)
					setElementDataEx(client, "gender", tonumber(characterData["gender"]))
					setElementDataEx(client, "deaglemode", 1, true) -- Default to lethal
					setElementDataEx(client, "shotgunmode", 1, true) -- Default to lethal
					setElementDataEx(client, "firemode", 0, true) -- Default to auto
					setElementDataEx(client, "tamirci", tonumber(characterData["tamirci"]), true)
					setElementDataEx(client, "youtuber", tonumber(characterData["youtuber"]), true)
					setElementDataEx(client, "etiket", tonumber(characterData["etiket"]), true)
					setElementDataEx(client, "hunger", tonumber(characterData["hunger"]), true)
					setElementDataEx(client, "thirst", tonumber(characterData["thirst"]), true)
					setElementDataEx(client, "level", tonumber(characterData["level"]), true)
					setElementDataEx(client, "hoursaim", tonumber(characterData["hoursaim"]), true)
					setElementDataEx(client, "roldersi", tonumber(characterData["roldersi"]), true)
					setElementDataEx(client, "box", tonumber(characterData["box"]), true)
					setElementDataEx(client, "boxexp", tonumber(characterData["boxexp"]), true)
					exports["vrp_vipsystem"]:loadVIP(tonumber(characterData["id"] ))
					setElementDataEx(client, "hapis_sure", tonumber(characterData["hapis_sure"]))
                    setElementDataEx(client, "hapis_sebep", characterData["hapis_sebep"], true)
					setElementDataEx(client, "clothing:id", tonumber(characterData["clothingid"]) or nil, true)
					if (tonumber(characterData["restrainedobj"])>0) then
						setElementDataEx(client, "restrainedObj", tonumber(characterData["restrainedobj"]), false)
					end
					
					if ( tonumber(characterData["restrainedby"])>0) then
						setElementDataEx(client, "restrainedBy",  tonumber(characterData["restrainedby"]), false)
					end

					takeAllWeapons(client)
					
					if (getElementType(client) == 'player') then
						triggerEvent("updateLocalGuns", client)
					end
					
					setPedStat(client, 70, 999)
					setPedStat(client, 71, 999)
					setPedStat(client, 72, 999)
					setPedStat(client, 74, 999)
					setPedStat(client, 76, 999)
					setPedStat(client, 77, 999)
					setPedStat(client, 78, 999)
					setPedStat(client, 77, 999)
					setPedStat(client, 78, 999)
					setPedStat(client, 79, 999) -- Strafeing fix
					
					toggleAllControls(client, true, true, true)
					triggerClientEvent(client, "onClientPlayerWeaponCheck", client)
					setElementFrozen(client, false)
					
					
					-- Player is cuffed
					if (tonumber(characterData["cuffed"])==1) then
						toggleControl(client, "sprint", false)
						toggleControl(client, "fire", false)
						toggleControl(client, "jump", false)
						toggleControl(client, "next_weapon", false)
						toggleControl(client, "previous_weapon", false)
						toggleControl(client, "accelerate", false)
						toggleControl(client, "brake_reverse", false)
						toggleControl(client, "aim_weapon", false)
					end            
					
					
					setPedFightingStyle(client, tonumber(characterData["fightstyle"]))     
					triggerEvent("onCharacterLogin", client, charname, tonumber(characterData["faction_id"]))
					triggerClientEvent(client, "accounts:characters:spawn", client, fixedName, adminLevel, gmLevel, tonumber(characterData["faction_id"]), tonumber(characterData["faction_rank"]))
					triggerClientEvent(client, "item:updateclient", client)
					
					
					if not theAdmin then
					--	dbExec(mysql:getConnection(), "UPDATE characters SET online='1', lastlogin=NOW() WHERE id='" .. characterID .. "'")
						local monitored = getElementData(client, "admin:monitor")
						if monitored then
							if monitored ~= "New Player" then
								exports.vrp_global:sendMessageToAdmins("[MONITOR] ".. getPlayerName(client):gsub("_", " ") .." ("..pid.."): "..monitored)
								exports.vrp_global:sendMessageToSupporters("[MONITOR] ".. getPlayerName(client):gsub("_", " ") .." ("..pid.."): "..monitored)
							end
						end
					end
					
					setTimer(setPedGravity, 2000, 1, client, 0.008)
					setElementAlpha(client, 255)
					
					-- WALKING STYLE
					triggerEvent("realism:applyWalkingStyle", client, characterData["walkingstyle"] or 128, true)

					if duty > 0 then
						local foundPackage = false
						for key, value in ipairs(factionPerks) do
							if tonumber(value) == tonumber(duty) then
								foundPackage = true
									break
							end
						end
						
						if not foundPackage then
							triggerEvent("duty:offduty", client)
							outputChatBox("Artık kullandığınız göreve erişiminiz yok - bu nedenle, kaldırıldı.", client, 255, 0, 0)
						end
					end
					triggerEvent("social:character", client)
					
					if theAdmin then
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(theAdmin)
						local adminUsername = getElementData(theAdmin, "account:username")
						outputChatBox("You've logged into player's character successfully!", theAdmin, 0, 255, 0 )
						local hiddenAdmin = getElementData(theAdmin, "hiddenadmin")
						if hiddenAdmin == 0 then
							exports.vrp_global:sendMessageToAdmins("AdmKmt: " .. tostring(adminTitle) .. " "..adminUsername.." başka bir hesaba girdi, ("..targetAccountName..") "..tostring(characterData["charactername"]):gsub("_"," ")..".")
						end
					end
					

					if (tonumber(characterData["blindfold"])==1) then
						setElementDataEx(client, "blindfold", 1)
						outputChatBox("Karakterinin gözü kapalı. eğer bu OCC bir eylem ise, F2 tuşunu kullanarak yönetici ile iletişime geç.", client, 255, 194, 15)
						fadeCamera(client, false)
					else
						fadeCamera(client, true, 4)
					end

					if (tonumber(characterData["cuffed"])==1) then
						outputChatBox("Karakterin sınırlandırılmış.", client, 255, 0, 0)
					end

					loadCharacterSettings(client,characterID)
					
					triggerClientEvent(client, "drawAllMyInteriorBlips", client)

					triggerEvent("playerGetMotds", client)
					triggerEvent( "accounts:character:select", client )
				end
			end
		end,
	{client, characterID, remoteAccountID, theAdmin, targetAccountName, location}, mysql:getConnection(), sqlQuery)
end
addEventHandler("accounts:characters:spawn", getRootElement(), spawnCharacter)
 
function Characters_onCharacterChange()
	triggerClientEvent(client, "items:inventory:hideinv", client)
	triggerEvent("savePlayer", client, "Change Character")
	triggerEvent('setDrunkness', client, 0)
	setElementDataEx(client, "alcohollevel", 0, true)
	setElementDataEx(client, "clothing:id", nil, true)
	removeMasksAndBadges(client)
	
	setElementDataEx(client, "pd.jailserved")
	setElementDataEx(client, "pd.jailtime")
	setElementDataEx(client, "pd.jailtimer")
	setElementDataEx(client, "pd.jailstation")
	setElementDataEx(client, "loggedin", 0, true)
	setElementDataEx(client, "bankmoney", 0)
	setElementDataEx(client, "account:character:id", false)
	setElementAlpha(client, 0)

	removeElementData(client, "jailed")
	removeElementData(client, "jail_time")
	removeElementData(client, "jail:id")
	removeElementData(client, "jail:cell") 
	removeElementData(client, "enableGunAttach")
	triggerEvent("destroyWepObjects", client)
	
	if (getPedOccupiedVehicle(client)) then
			removePedFromVehicle(client)
	end
	exports.vrp_global:updateNametagColor(client)
	local clientAccountID = getElementDataEx(client, "account:id") or -1
	
	setElementInterior(client, 0)
	setElementDimension(client, 1)
	setElementPosition(client, -26.8828125, 2320.951171875, 24.303373336792)
	
	setElementDataEx(client, "legitnamechange", 1)
	setElementDataEx(client, "legitnamechange", 0)
	
	exports.vrp_logs:dbLog("ac"..tostring(clientAccountID), 27, { "ac"..tostring(clientAccountID), client } , "Went to character selection" )
	triggerEvent("shop:removeMeFromCurrentShopUser",client, client)
	triggerClientEvent(client, "hideGeneralshopUI", client)
	--triggerEvent("artifacts:removeAllOnPlayer",client, client)

	local padId = getElementData(client, "padUsing")
	if padId then
		removeElementData(client, "padUsing")
		for key, thePad in pairs(getElementsByType("object", getResourceRootElement(getResourceFromName("vrp_item_world")))) do
			if getElementData(thePad, "id") == padId then
				removeElementData(thePad, "playerUsing")
				break
			end
		end
	end
	triggerEvent("accounts:character:select", client)
end
addEventHandler("accounts:characters:change", getRootElement(), Characters_onCharacterChange)

addEvent("checkAlreadyUsingName", true)
addEventHandler("checkAlreadyUsingName", root,
	function(player, cname)
		local accounts, characters = getTableInformations()
		for index, value in ipairs(characters) do
			if value.charactername == cname:gsub(" ", "_") then
				triggerClientEvent(player, "response:nameCheck", player, cname, false)
			else
				triggerClientEvent(player, "response:nameCheck", player, cname, "ok")

			end
		end
	end
)

function removeMasksAndBadges(client)
    for k, v in ipairs({exports['vrp_items']:getMasks(), exports['vrp_items']:getBadges()}) do
        for kx, vx in pairs(v) do
            if getElementData(client, vx[1]) then
               setElementDataEx(client, vx[1], false, true)
            end
        end
    end
end

function newCharacter_create(characterName, characterDescription, race, gender, skin, height, weight, age, nationselected, month, day, location)
	if not (checkValidCharacterName(characterName)) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 1) -- State 1:1: error validating data
		return
	end

	if not (race > -1 and race < 3) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 2) -- State 1:2: error validating data
		return
	end
	
	if not (gender == 0 or gender == 1) then
		triggerClientEvent(client, "accounts:characters:new", client, 1, 3) -- State 1:3: error validating data
		return
	end
	
	characterName = string.gsub(tostring(characterName), " ", "_")
	
	accountIDs = getElementData(client, "account:id")
	
	local accountID = getElementData(client, "account:id")
	local accountUsername = getElementData(client, "account:username")
	local fingerprint = md5((characterName) .. accountID .. race .. gender .. age)
	
	if month == "Ocak" then
		month = 1
	end
	
	local walkingstyle = 128
	if gender == 1 then
		walkingstyle = 129
	end
	languageselected = 1

	dbExec(mysql:getConnection(), "INSERT INTO `characters` SET `charactername`='" .. (characterName).. "', `x`='378.54296875', `y`=' -2014.740234375', `z`='7.8300905227661', `rotation`='"..location[4].."', `interior_id`='"..location[5].."', `dimension_id`='"..location[6].."', `lastarea`='"..(location[7]).."', `gender`='" .. (gender) .. "', `skincolor`='" .. (race) .. "', `weight`='" .. (weight) .. "', `height`='" .. (height) .. "', `description`='', `account`='" .. (accountID) .. "', `skin`='" .. (skin) .. "', `age`='" .. (age) .. "', `fingerprint`='" .. (fingerprint) .. "', `nation`='" .. (nationselected) .. "', `lang1`='" .. (languageselected) .. "', `lang1skill`='100', `lang2`='1', `lang2skill`='100', `currLang`='2', `month`='" .. (month or "1") .. "', `day`='" .. (day or "1").."', `walkingstyle`='" .. (walkingstyle).."' ")

	local characters = {}
		dbQuery(
			function(qh, source)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, value in ipairs(res) do
						if value.cked == 0 then
							local i = #characters + 1
							if not characters[i] then
								characters[i] = {}
							end
							characters[i][1] = value.id
							characters[i][2] = value.charactername
							characters[i][3] = tonumber(value.cked)
							characters[i][4] = ""
							characters[i][5] = value.age
							characters[i][6] = value.gender
							characters[i][9] = value.skin
							characters[i][11] = value.height
							characters[i][12] = value.weight
						end
					end
				end
				setElementData(source, "account:characters", characters)
				triggerClientEvent(source, "accounts:login:attempt", source, 0 )
				triggerEvent( "social:vrp_account", source, acID)
			end,
		{client}, mysql:getConnection(), "SELECT * FROM characters WHERE account = ?", tonumber(getElementData(client, "account:id")))
end
addEventHandler("accounts:characters:new", getRootElement(), newCharacter_create)