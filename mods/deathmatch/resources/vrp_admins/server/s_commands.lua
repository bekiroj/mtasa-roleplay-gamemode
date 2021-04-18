mysql = exports.vrp_mysql

local getPlayerName_ = getPlayerName
getPlayerName = function( ... )
	s = getPlayerName_( ... )
	return s and s:gsub( "_", " " ) or s
end

local _setElementData = setElementData
function setElementData(element, data, index)
	return _setElementData(element, data, index)
end

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if string.len(text) > 128 then -- MTA Chatbox size limit
		MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
		outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
	else
		MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
	end
end

function getAmmoPerClip(id)
	if id == 0 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.fist' ))
	elseif id == 1 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.brassknuckle' ))
	elseif id == 2 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.golfclub' ))
	elseif id == 3 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightstick' ))
	elseif id == 4 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.knife' ))
	elseif id == 5 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.bat' ))
	elseif id == 6 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shovel' ))
	elseif id == 7 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.poolstick' ))
	elseif id == 8 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.katana' ))
	elseif id == 9 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.chainsaw' ))
	elseif id == 10 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.dildo' ))
	elseif id == 11 then
		return tostring(get( getResourceName( getThisResource( ) ).. 'dildo2' ))
	elseif id == 12 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator' ))
	elseif id == 13 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.vibrator2' ))
	elseif id == 14 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.flower' ))
	elseif id == 15 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.cane' ))
	elseif id == 16 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.grenade' ))
	elseif id == 17 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.teargas' ))
	elseif id == 18 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.molotov' ))
	elseif id == 22 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.colt45' ))
	elseif id == 23 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.silenced' ))
	elseif id == 24 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.deagle' ))
	elseif id == 25 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.shotgun' ))
	elseif id == 26 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sawed-off' ))
	elseif id == 27 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.combatshotgun' ))
	elseif id == 28 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.uzi' ))
	elseif id == 29 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.mp5' ))
	elseif id == 30 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.ak-47' ))
	elseif id == 31 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.m4' ))
	elseif id == 32 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.tec-9' ))
	elseif id == 33 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rifle' ))
	elseif id == 34 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.sniper' ))
	elseif id == 35 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.rocketlauncher' ))
	elseif id == 41 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.spraycan' ))
	elseif id == 42 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.fireextinguisher' ))
	elseif id == 43 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.camera' ))
	elseif id == 44 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.nightvision' ))
	elseif id == 45 then
		return tostring(get( getResourceName( getThisResource( ) ).. '.infrared' ))
	elseif id == 46 then -- Parachute
		return tostring(get( getResourceName( getThisResource( ) ).. '.parachute' ))	
	else
		return "disabled"
	end
	return "disabled"
end
addEvent("onGetAmmoPerClip", true)
addEventHandler("onGetAmmoPerClip", getRootElement(), getAmmoPerClip)

function loadWeaponStats()
	for id = 0, 45, 1 do
		if id ~= 19 and id ~= 20 and id ~=21 then
			local tmp = getAmmoPerClip(id)
			if tmp == "disable" then
				setWeaponProperty( id , "std", "maximum_clip_ammo", 0)
			else
			end
		end
	end
end
addEventHandler ( "onResourceStart", resourceRoot, loadWeaponStats )

function adminUncuff(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				if (logged==0) then
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					if not getElementData(targetPlayer, "kelepce") and not getElementData(targetPlayer, "ipbagli") then
						outputChatBox("Oyuncu kelepçeli değil.", thePlayer, 255, 0, 0)
					else
						outputChatBox("" .. username .. " isimli yetkili kelepçenizi çıkardı.", targetPlayer)
						outputChatBox("" .. targetPlayerName .. " isimli oyuncunun kelepçesini çıkardınız.", thePlayer)
						exports.vrp_handcuff:kelepcele(targetPlayer, "al")
						exports.vrp_handcuff:kelepcele(targetPlayer, "ipal")
						exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun kelepçesini çözdü.")
					end
				end
			end
		end
	end
end
addCommandHandler("auncuff", adminUncuff, false, false)

function adminUnblindfold(thePlayer, commandName, targetPlayer)
	local uyk = getElementData(thePlayer, "ustyk")==1
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) or uyk then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)
				if (logged==0) then
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				else
					local blindfolded = getElementData(targetPlayer, "rblindfold")
					if (blindfolded==0) then
						outputChatBox("Player is not blindfolded", thePlayer, 255, 0, 0)
					else
						setElementData(targetPlayer, "gözbandajı",nil)
						fadeCamera(targetPlayer, true)
						outputChatBox("You have unblindfolded " .. targetPlayerName .. ".", thePlayer)
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("You have been unblindfolded by admin " .. username .. ".", thePlayer)
						else
							outputChatBox("You have been unblindfolded by a Hidden Admin.", thePlayer)
						end
						dbExec(mysql:getConnection(), "UPDATE characters SET blindfold = 0 WHERE id = " .. (getElementData( targetPlayer, "dbid" )) )
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "UNBLINDFOLD")
						exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun göz bandını çözdü.")
					end
				end
			end
		end
	end
end
addCommandHandler("aunblindfold", adminUnblindfold, false, false)

--/AUNMASK
function adminUnmask(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				local username = getPlayerName(thePlayer)

				if (logged==0) then
					exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				else
					local any = false
					local masks = exports['vrp_items']:getMasks()
					for key, value in pairs(masks) do
						if getElementData(targetPlayer, value[1]) then
							any = true
							exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, value[1], false, true)
						end
					end

					if any then
						local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
						if hiddenAdmin == 0 then
							outputChatBox("[*] Maskeniz "..username.. " isimli yetkili tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						else
							outputChatBox("[*] Maskeniz gizli bir yetkili tarafından çıkartılmıştır.", targetPlayer, 255, 0, 0)
						end
						exports["vrp_infobox"]:addBox(thePlayer, "success", targetPlayerName .. " isimli oyuncunun maskesi çıkartılmıştır.")
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "UNMASK")
					else
						outputChatBox("[*] Oyuncu maskeli değil.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("maskecikar", adminUnmask, false, false)

function disarmPlayer(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerAdminIII(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (logged==1) then
					for i = 115, 116 do
						while exports['vrp_items']:takeItem(targetPlayer, i) do
						end
					end
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
					if (hiddenAdmin==0) then
						outputChatBox(""..tostring(adminTitle) .. " " .. getPlayerName(thePlayer).." isimli yetkili silahlarınızı sildi.", targetPlayer, 255, 0, 0)
					else
						outputChatBox(""..tostring(adminTitle) .. " " .. getPlayerName(thePlayer).." isimli yetkili silahlarınızı sildi.", targetPlayer, 255, 0, 0)
					end
					outputChatBox(targetPlayerName .. " isimli oyuncunun silahlarını sildin.", thePlayer, 255, 0, 0)
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "DISARM")
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun silahlarını sildi.")
				end
			end
		end
	end
end
addCommandHandler("disarm", disarmPlayer, false, false)

function consoleSetFightingStyle ( thePlayer, commandName, id )
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
	if ( thePlayer and id ) then                                                
		local status = setPedFightingStyle ( thePlayer, tonumber(id) )    
		if ( not status ) then                                              
			outputConsole ( "Failed to set fighting style.", thePlayer ) 
		end
	end
	end
end
addCommandHandler ( "setstyle",  consoleSetFightingStyle )

function getPlayerID(thePlayer, commandName, target)
	if not (target) then
		outputChatBox("KULLANIM: /" .. commandName .. " [Karakter Adı & ID]", thePlayer, 255, 194, 14)
	else
		local username = getPlayerName(thePlayer)
		local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)

		if targetPlayer then
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==1) then
				local id = getElementData(targetPlayer, "playerid")
				outputChatBox("-#f9f9f9 " .. targetPlayerName .. " isimli oyuncunun ID'si: " .. id .. "", thePlayer, 255, 194, 14,true)
			else
				outputChatBox("[-]#f9f9f9 Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
			end
		end
	end
end
addCommandHandler("getid", getPlayerID, false, false)
addCommandHandler("id", getPlayerID, false, false)

-- FIND IP --
local function showIPAlts(thePlayer, ip)
	local result = exports.vrp_global:getCache("accounts", ip, "ip")
	if result then
		local count = 0
		
		outputChatBox( " IP Address: " .. ip, thePlayer)
	
        if result["lastlogin"] == nil then
            result["lastlogin"] = "Never"
        end
        
        local text = " #" .. count .. ": " .. tostring(result["username"])
    
        outputChatBox( text, thePlayer)
	else
		outputChatBox( "Error #9101 - Report on Forums", thePlayer, 255, 0, 0)
	end
end

function findAltAccIP(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerTrialAdmin( thePlayer ) then
		if not (...) then
			outputChatBox("|| Valhalla || /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports.vrp_global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				targetPlayerName = table.concat({...}, " ")
				
				-- select by accountname
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "username")
				if result then
					showIPAlts(thePlayer, result.ip)
					return
				end

				-- select by ip
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "ip")
				if result then
					showIPAlts(thePlayer, result.ip)
					return
				end

				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else -- select by online player
				if not exports.vrp_integration:isPlayerDeveloper(targetPlayer) then
					showIPAlts( thePlayer, getPlayerIP(targetPlayer) )
				end
			end
		end
	end
end
addCommandHandler( "findip", findAltAccIP )

local function showAlts(thePlayer, id, creation)
	local result = exports.vrp_global:getCache("characters", id, "account")
	if result then
		local name = exports.vrp_global:getCache("accounts", id, "id")
		if name then
			local uname = name["username"]
			if uname and uname ~= nil then
				outputChatBox( "WHOIS " .. uname .. ": ", thePlayer, 255, 194, 14 )
				if (tonumber(name["appstate"])) < 3 then
					outputChatBox( "This account didn't pass an application yet.", thePlayer, 255, 0, 0 )	
				end
			else
				outputChatBox( "?", thePlayer )
			end
		else
			outputChatBox( "?", thePlayer )
		end
		
        local count = 0
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    local count = 0
                    for index, row in ipairs(res) do
                        count = count + 1
                        local r = 255
                        if getPlayerFromName( row["charactername"] ) then
                            r = 0
                        end
                        
                        local text = "#" .. count .. ": " .. row["charactername"]:gsub("_", " ")
                        if tonumber( row["cked"] ) == 1 then
                            text = text .. " (Missing)"
                        elseif tonumber( row["cked"] ) == 2 then
                            text = text .. " (Buried)"
                        end
                        
                        if row['lastlogin'] ~= nil then
                            text = text .. " - " .. tostring( row['lastlogin'] )
                        end
                        
                        if creation and row['creationdate'] ~= nil then
                            text = text .. " - Created " .. tostring( row['creationdate'] )
                        end
                        
                        local faction = tonumber( row["faction_id"] ) or 0
                        if faction > 0 and exports.vrp_integration:isPlayerAdmin( thePlayer ) then -- Maxime | Hide faction from Trial and below
                            local theTeam = exports.vrp_pool:getElement("team", faction)
                            if theTeam then
                                text = text .. " - " .. getTeamName( theTeam )
                            end
                        end
                        
                        local hours = tonumber(row.hoursplayed)
                        local newhours = tonumber(row.hoursplayed) + tonumber(row.hoursplayed)
                        if hours and hours > 0 then
                            text = text .. " - " .. hours .. " hours"
                        end
                        local activated = tonumber(row.active)
                        local activeDescription = tostring(row.activeDescription) or "Bilgi Yok"
                        if activated then
                            if activated == 0 then
                                text = text .. " (Aktif Değil - "..activeDescription..")"
                            end
                        end
                        outputChatBox( text, thePlayer, r, 255, 0)
                    end
                end
            end,
        mysql:getConnection(), "SELECT * FROM characters WHERE account='"..id.."'")
	else
		outputChatBox( "Şahısın account adını değil, karakter adını giriniz.", thePlayer, 255, 0, 0)
	end
end

function findAltChars(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not (...) then
			outputChatBox("|| Valhalla || /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local creation = commandName == "findalts2"
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = targetPlayerName == "*" and thePlayer or exports.vrp_global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer or getElementData( targetPlayer, "loggedin" ) ~= 1 then
				-- select by character name
				local result = exports.vrp_global:getCache("characters", targetPlayerName, "charactername")
				if result then
                    showAlts(thePlayer, result.account, creation )
                    return
				end
				
				targetPlayerName = table.concat({...}, " ")
				
				-- select by account name
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "username")
				if result then
                    showAlts(thePlayer, result.account, creation )
                    return
				end
				
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				local id = getElementData( targetPlayer, "account:id" )
				if id then
					showAlts( thePlayer, id, creation )
				else
					outputChatBox("Game Account is unknown.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler( "findalts", findAltChars)

local function showSerialAlts(thePlayer, serial)
	local result = exports.vrp_global:getMultipleCache("accounts", serial, "mtaserial")
	if result and #result > 0 then
		local count = 0
        local continue = true
        outputChatBox("Serial: "..serial, thePlayer)
        for index, row in ipairs(result) do
            count = count + 1
            local text = "#" .. count .. ": " .. row["username"]
			
			if tonumber( row["appstate"] ) < 3 then
				text = text .. " (Application not passed)"
            end
            
            outputChatBox( text, thePlayer)
        end
	else
		outputChatBox( "Error #9101 - Report on Forums", thePlayer, 255, 0, 0)
	end
end

function findAltAccSerial(thePlayer, commandName, ...)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		if not (...) then
			outputChatBox("|| Valhalla || /" .. commandName .. " [Player Nick/Serial]", thePlayer, 255, 194, 14)
		else
			local targetPlayerName = table.concat({...}, "_")
			local targetPlayer = exports.vrp_global:findPlayerByPartialNick(nil, targetPlayerName)
			
			if not targetPlayer then --or getElementData( targetPlayer, "loggedin" ) ~= 1 then
			
                local targetPlayerName = table.concat({...}, " ")
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "username")
				if result then
                    showSerialAlts(thePlayer, result.mtaserial)
                    return
                end
                
				-- select by ip
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "ip")
				if result then
					showSerialAlts(thePlayer, result.mtaserial)
                    return
				end
				
				-- select by serial
				local result = exports.vrp_global:getCache("accounts", targetPlayerName, "mtaserial")
				if result then
                    showSerialAlts(thePlayer, result.mtaserial)
                    return
				end
				
				outputChatBox("Player not found or multiple were found.", thePlayer, 255, 0, 0)
			else
				showSerialAlts( thePlayer, getPlayerSerial(targetPlayer) )
			end
		end
	end
end
addCommandHandler( "findserial", findAltAccSerial )

function checkSkin ( thePlayer, commandName)
	outputChatBox ( "[-]#f9f9f9 Üzerindeki Skin ID'si: " .. getPedSkin ( thePlayer ), thePlayer, 255,0,194,true)
end
addCommandHandler ( "checkskin", checkSkin )

function asetPlayerGender(thePlayer, commandName, targetPlayer, gender)
   if (exports.vrp_integration:isPlayerAdminI(thePlayer)) then
      if not (gender) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [0= Male, 1= Female]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local genderint = tonumber(gender)
         if (genderint>1) or (genderint<0) then
            outputChatBox("Error: Please choose either 0 for male, or 1 for female.", thePlayer, 255, 0, 0)
         else
         dbExec(mysql:getConnection(), "UPDATE characters SET gender='" .. (gender) .. "' WHERE id = " .. (dbid))
		 setElementData(targetPlayer, "gender", gender, true)
			if (genderint==0) then
			    outputChatBox("You changed " .. targetPlayerName .. "'s gender to Male.", thePlayer, 0, 255, 0)
			    outputChatBox("Your gender was set to Male.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			elseif (genderint==1) then
				outputChatBox("You changed " .. targetPlayerName .. "'s gender to Female.", thePlayer, 0, 255, 0)
			    outputChatBox("Your gender was set to Female.", targetPlayer, 0, 255, 0)
				outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
			end
			exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..genderint)
         end
      end
   end
end
addCommandHandler("setgender", asetPlayerGender)

function asetPlayerAge(thePlayer, commandName, targetPlayer, age)
   if (exports.vrp_integration:isPlayerAdminI(thePlayer)) then
      if not (age) or not (targetPlayer) then
         outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Age]", thePlayer, 255, 194, 14)
      else
         local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
         local dbid = getElementData(targetPlayer, "dbid")
         local ageint = tonumber(age)
         if (ageint>150) or (ageint<1) then
            outputChatBox("You cannot set the age to that.", thePlayer, 255, 0, 0)
         else
            dbExec(mysql:getConnection(), "UPDATE characters SET age='" .. (age) .. "' WHERE id = " .. (dbid))
			setElementData(targetPlayer, "age", tonumber(age), true)
            outputChatBox("You changed " .. targetPlayerName .. "'s age to " .. age .. ".", thePlayer, 0, 255, 0)
            outputChatBox("Your age was set to " .. age .. ".", targetPlayer, 0, 255, 0)
			exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..age)
         end
      end
   end
end
addCommandHandler("setage", asetPlayerAge)

function aSetDateOfBirth(thePlayer, commandName, targetPlayer, dob, mob)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if not (targetPlayer) or not dob or not mob then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [Date] [Month]", thePlayer, 255, 194, 14)
		else
			if getElementData(targetPlayer, "loggedin") ~= 1 then
				exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				return false
			end

			if not tonumber(dob) or not tonumber(mob) then
				outputChatBox("Date and Month of birth must be numeric.", thePlayer, 255, 194, 14)
				return false
			else
				dob = tonumber(dob)
				mob = tonumber(mob)
			end

			local dbid = getElementData(targetPlayer, "dbid")
			if dbExec(mysql:getConnection(), "UPDATE `characters` SET `day`='" ..(dob) .. "', `month`='" .. (mob) .. "' WHERE id = '" .. (dbid).."' " ) then
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "day", dob, true)
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "month", mob, true)
				outputChatBox("You changed " .. targetPlayerName .. "'s date of birth to " .. exports.vrp_global:getPlayerDoB(targetPlayer) .. ".", thePlayer, 0, 255, 0)
				outputChatBox("Your date of birth was set to " .. exports.vrp_global:getPlayerDoB(targetPlayer) .. ".", targetPlayer, 0, 255, 0)
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..dob.."/"..mob)
			else
				outputChatBox("Failed to set DoB, DB error.", thePlayer, 0, 255, 0)
			end
		end
	end
end
addCommandHandler("setdob", aSetDateOfBirth)
addCommandHandler("setdateofbirth", aSetDateOfBirth)

function asetPlayerRace(thePlayer, commandName, targetPlayer, race)
       if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
          if not (race) or not (targetPlayer) then
             outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [0= Black, 1= White, 2= Asian]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local raceint = tonumber(race)
             if (raceint>2) or (raceint<0) then
                outputChatBox("Error: Please chose either 0 for black, 1 for white, or 2 for asian.", thePlayer, 255, 0, 0)
             else
         dbExec(mysql:getConnection(), "UPDATE characters SET skincolor='" .. (race) .. "' WHERE id = " .. (dbid))
				if (raceint==0) then
				    outputChatBox("You changed " .. targetPlayerName .. "'s race to black.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to black.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==1) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to white.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to white.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				elseif (raceint==2) then
					outputChatBox("You changed " .. targetPlayerName .. "'s race to asian.", thePlayer, 0, 255, 0)
				    outputChatBox("Your race was changed to asian.", targetPlayer, 0, 255, 0)
					outputChatBox("Please F10 for changes to take effect.", targetPlayer, 255, 194, 14)
				end
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..raceint)
             end
          end
       end
end
addCommandHandler("setrace", asetPlayerRace)

function asetPlayerHeight(thePlayer, commandName, targetPlayer, height)
       if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
          if not (height) or not (targetPlayer) then
             outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [Height (150 - 200)]", thePlayer, 255, 194, 14)
          else
             local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
             local dbid = getElementData(targetPlayer, "dbid")
             local heightint = tonumber(height)
             if (heightint>200) or (heightint<150) then
                outputChatBox("You cannot set the height to that.", thePlayer, 255, 0, 0)
             else
            dbExec(mysql:getConnection(), "UPDATE characters SET height='" .. (height) .. "' WHERE id = " .. (dbid))
				exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "height", height, true)
                outputChatBox("You changed " .. targetPlayerName .. "'s height to " .. height .. " cm.", thePlayer, 0, 255, 0)
                outputChatBox("Your height was set to " .. height .. " cm.", targetPlayer, 0, 255, 0)
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, commandName.." "..height)
             end
          end
       end
end
addCommandHandler("setheight", asetPlayerHeight)

function adminDuty(thePlayer, commandName)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		local adminduty = getElementData(thePlayer, "duty_admin")
		local username = getPlayerName(thePlayer)
		if adminduty == 1 then
			setElementData(thePlayer, "duty_admin", 0)
			exports.vrp_global:updateNametagColor(thePlayer)
			exports.vrp_global:sendMessageToAdmins("ADMIN DUTY: " .. username .. " Artık görevde değil.")
			outputChatBox("(( Başarıyla görevden ayrıldınız. ))", thePlayer, 255, 0, 0)
			if getElementData(thePlayer, "supervising") == true then
				setElementData(thePlayer, "supervising", false)
				setElementData(thePlayer, "supervisorBchat", false)
				setElementAlpha(thePlayer, 255)
			end
		else
			setElementData(thePlayer, "duty_admin", 1)
			exports.vrp_global:sendMessageToAdmins("ADMIN DUTY: " .. username .. " Şuanda Görevde.")
			outputChatBox("(( Başarıyla göreve başladınız. ))", thePlayer, 255, 0, 0)
			exports.vrp_global:updateNametagColor(thePlayer)
		end
	end
end
addCommandHandler("adminduty", adminDuty, false, false)
addCommandHandler("aduty", adminDuty, false, false)
addEvent("admin-system:adminduty", true)
addEventHandler("admin-system:adminduty", getRootElement(), adminDuty)

function gmDuty(thePlayer, commandName)
	if exports.vrp_integration:isPlayerSupporter(thePlayer) or exports.vrp_integration:isPlayerHeadAdmin(thePlayer) then
		local gmDuty = getElementData(thePlayer, "duty_supporter") or 0
		local username = getPlayerName(thePlayer)
		if gmDuty == 1 then
			setElementData(thePlayer, "duty_supporter", 0)
			setPlayerNametagColor(thePlayer, 255, 255, 255)
			exports.vrp_global:sendMessageToAdmins("REHBER DUTY: " .. username .. " Artık görevde değil.")
		else
			setElementData(thePlayer, "duty_supporter", 1)
			exports.vrp_global:sendMessageToAdmins("REHBER DUTY: " .. username .. " Şuanda Görevde.")
			setPlayerNametagColor(thePlayer, 0, 255, 0)
		end
	end
end
addCommandHandler("sduty", gmDuty, false, false)
addCommandHandler("gduty", gmDuty, false, false)
addEvent("admin-system:gmduty", true)
addEventHandler("admin-system:gmduty", getRootElement(), gmDuty)

function freezePlayer(thePlayer, commandName, target)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, true)
					toggleAllControls(targetPlayer, false, true, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				else
					detachElements(targetPlayer)
					toggleAllControls(targetPlayer, false, true, false)
					setElementFrozen(targetPlayer, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					setPedWeaponSlot(targetPlayer, 0)
					setElementData(targetPlayer, "freeze", 1, false)
					outputChatBox(" You have been frozen by an ".. textStr ..". Take care when following instructions.", targetPlayer)
					outputChatBox(" You have frozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " froze " .. targetPlayerName .. ".")
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "FREEZE")
			end
		end
	end
end
addCommandHandler("freeze", freezePlayer, false, false)
addEvent("remoteFreezePlayer", true )
addEventHandler("remoteFreezePlayer", getRootElement(), freezePlayer)

function unfreezePlayer(thePlayer, commandName, target)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		if not (target) then
			outputChatBox("SYNTAX: /" .. commandName .. " /unfreeze [Partial Player Nick]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				local textStr = "admin"
				local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)

				local veh = getPedOccupiedVehicle( targetPlayer )
				if (veh) then
					setElementFrozen(veh, false)
					toggleAllControls(targetPlayer, true, true, true)
					triggerClientEvent(targetPlayer, "onClientPlayerWeaponCheck", targetPlayer)
					if (isElement(targetPlayer)) then
						outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					end

					if (isElement(thePlayer)) then
						outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
					end
				else
					toggleAllControls(targetPlayer, true, true, true)
					setElementFrozen(targetPlayer, false)
					if getElementData(targetPlayer, "restrain") == 1 then
						setPedWeaponSlot(targetPlayer, 0)
						toggleControl(targetPlayer, "next_weapon", false)
						toggleControl(targetPlayer, "previous_weapon", false)
					end
					setElementData(targetPlayer, "freeze", false, false)
					outputChatBox(" You have been unfrozen by an ".. textStr ..". Thanks for your co-operation.", targetPlayer)
					outputChatBox(" You have unfrozen " ..targetPlayerName.. ".", thePlayer)
				end

				local username = getPlayerName(thePlayer)
				exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. username .. " unfroze " .. targetPlayerName .. ".")
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "UNFREEZE")
			end
		end
	end
end
addCommandHandler("unfreeze", unfreezePlayer, false, false)

function takeMoney(thePlayer, commandName, target, money, ...)
	if exports.vrp_integration:isPlayerDeveloper( thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				money = tonumber(money) or 0
				local amount = exports.vrp_global:formatMoney(money)
				if not exports.vrp_global:takeMoney(targetPlayer, money) then
					outputChatBox("Oyuncudan $"..amount.." miktar para alınamadı.", thePlayer, 255, 0, 0)
					return false
				end
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKEMONEY " ..money)
				outputChatBox("" .. targetPlayerName .. " isimli oyuncudan $" .. amount .. " miktar para kesildi.", thePlayer)
				outputChatBox("" .. username .. " isimli yetkili sizden $" .. amount .. " miktar para kesti.", targetPlayer)
				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)
				reason = table.concat({...}, " ")
				if tonumber(money) >= 5000 then
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncudan $" .. amount .. " miktar para kesti.("..reason..")")
				else
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncudan $" .. amount .. " miktar para kesti.("..reason..")")
				end
			end
		end
	end
end
addCommandHandler("takemoney", takeMoney, false, false)

function setMoney(thePlayer, commandName, target, money, ...)
	if exports.vrp_integration:isPlayerDeveloper( thePlayer) then
		if not (target) or not money or not tonumber(money) or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)
			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 5000 then
					outputChatBox("Güvenlik sebebiyle bir seferde sadece $50.000 oluşturabilirsin.", thePlayer, 255, 0, 0)
					return false
				end
				if not exports.vrp_global:setMoney(targetPlayer, money) then
					outputChatBox("Could not set that amount.", thePlayer, 255, 0, 0)
					return false
				end
				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "SETMONEY "..money)
				local amount = exports.vrp_global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox(targetPlayerName .. " isimli oyuncunun parasını $" .. amount .. " olarak değiştirdiniz.", thePlayer)
				outputChatBox("" .. username .. " isimli yetkili sizin paranızı $" .. amount .. " olarak değiştirdi.", targetPlayer)
				outputChatBox("Gerekçe: " .. reason .. ".", targetPlayer)
				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)

				if tonumber(money) >= 5000 then
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun parasını $" .. amount .. " olarak değiştirdi .("..reason..")")
				else
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun parasını $" .. amount .. " olarak değiştirdi .("..reason..")")
				end
			end
		end
	end
end
addCommandHandler("setmoney", setMoney, false, false)

--MAXIME
function giveMoney(thePlayer, commandName, target, money, ...)
	if exports.vrp_integration:isPlayerDeveloper( thePlayer) then
		if not (target) or not money or not (...) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Partial Player Nick] [Money] [Reason]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				money = tonumber(money) or 0
				if money and money > 100000 then
					outputChatBox("Güvenlik sebebiyle bir seferde sadece $100.000 para oluşturabilirsin.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.vrp_global:giveMoney(targetPlayer, money) then
					outputChatBox("Could not give player that amount.", thePlayer, 255, 0, 0)
					return false
				end

				local amount = exports.vrp_global:formatMoney(money)
				reason = table.concat({...}, " ")
				outputChatBox("" .. targetPlayerName .. " isimli oyuncuya $" .. amount .. " para verildi.", thePlayer)
				outputChatBox("" .. username .. " isimli yetkili sana $" .. amount .. " para oluşturdu.", targetPlayer)
				outputChatBox("Gerekçe: " .. reason .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)


				if tonumber(money) >= 100000 then
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuya $" .. amount .. " para verdi.("..reason..")")
				else
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuya $" .. amount .. " para verdi.("..reason..")")
				end

			end
		end
	end
end
addCommandHandler("givemoney", giveMoney, false, false)

function kickAPlayer(thePlayer, commandName, targetPlayer, ...)
	if exports["vrp_integration"]:isPlayerTrialAdmin(thePlayer) then
		if not (targetPlayer) or not (...) then
			outputChatBox("Komut: /" .. commandName .. " [Partial Player Nick] [Reason]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local thePlayerPower = exports.vrp_global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.vrp_global:getPlayerAdminLevel(targetPlayer)
				reason = table.concat({...}, " ")
				if (targetPlayerPower <= thePlayerPower) then
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					local playerName = getPlayerName(thePlayer)
					addAdminHistory(targetPlayer, thePlayer, reason, 1 , 0)
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "PKICK "..reason)
					if (hiddenAdmin)==0 then
						if commandName ~= "skick" then
							local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
							exports.vrp_global:sendMessageToAdmins("[KICK]: " .. targetPlayerName .. " isimli oyuncu " .. adminTitle .. " " .. playerName .. " tarafından oyundan atıldı.")
							exports.vrp_global:sendMessageToAdmins("[KICK]: Sebep: " .. reason .. ".")

						end
						kickPlayer(targetPlayer, thePlayer, reason)
					else
						if commandName ~= "skick" then
							exports.vrp_global:sendMessageToAdmins("[KICK]: "..targetPlayerName.." oyundan atıldı.")
							exports.vrp_global:sendMessageToAdmins("[KICK]: Sebep: " .. reason .. ".")
						end
						kickPlayer(targetPlayer, getRootElement(), reason)
					end
				else
					outputChatBox(" Bu oyuncu sizden daha üst düzey bir yönetici.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("pkick", kickAPlayer, false, false)

function slapPlayer(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local thePlayerPower = exports.vrp_global:getPlayerAdminLevel(thePlayer)
				local targetPlayerPower = exports.vrp_global:getPlayerAdminLevel(targetPlayer)
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==0) then
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				elseif (targetPlayerPower > thePlayerPower) then -- Check the admin isn't slapping someone higher rank them him
					outputChatBox("Sizden daha yüksek bir yönetici sıralaması oldukları için bu oynatıcıyı tokatlayamazsınız.", thePlayer, 255, 0, 0)
				else
					local x, y, z = getElementPosition(targetPlayer)
					if (isPedInVehicle(targetPlayer)) then
						setElementData(targetPlayer, "realinvehicle", 0, false)
						removePedFromVehicle(targetPlayer)
					end
					detachElements(targetPlayer)
					setElementPosition(targetPlayer, x, y, z+15)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

					if (hiddenAdmin==0) then
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
						exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuyu tokatladı.")
					end
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "SLAP")
				end
			end
		end
	end
end
addCommandHandler("slap", slapPlayer, false, false)

function hideAdmin(thePlayer, commandName)
	if exports.vrp_integration:isPlayerLeadAdmin(thePlayer) then
		local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
		if (hiddenAdmin==0) then
			setElementData(thePlayer, "hiddenadmin", 1, true)
			outputChatBox("Hidden Admin - ON", thePlayer, 255, 194, 14)
			exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili gizli yetkiyi açtı.")
		elseif (hiddenAdmin==1) then
			setElementData(thePlayer, "hiddenadmin", 0, true)
			outputChatBox("Hidden Admin - OFF", thePlayer, 255, 194, 14)
			exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili gizli yetkiyi kapattı.")
		end
		exports.vrp_global:updateNametagColor(thePlayer)
		dbExec(mysql:getConnection(), "UPDATE accounts SET hiddenadmin=" .. (getElementData(thePlayer, "hiddenadmin")) .. " WHERE id = " .. (getElementData(thePlayer, "account:id")) )
	end
end
addCommandHandler("hideadmin", hideAdmin, false, false)

function asetPlayerName(thePlayer, commandName, targetPlayer, ...)
	if (exports.vrp_integration:isPlayerHeadAdmin(thePlayer)) then
		if not (...) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Player New Nick]", thePlayer, 255, 194, 14)
		else
			local newName = table.concat({...}, "_")
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local hoursPlayed = getElementData( targetPlayer, "hoursplayed" )
				if hoursPlayed > 5 and not exports.vrp_integration:isPlayerAdmin(thePlayer) then
					outputChatBox( "Only Regular Admin or higher up can change character name which is older than 5 hours.", thePlayer, 255, 0, 0)
					return false
				end
				if newName == targetPlayerName then
					outputChatBox( "The player's name is already that.", thePlayer, 255, 0, 0)
				else
					local dbid = getElementData(targetPlayer, "dbid")
					
						setElementData(targetPlayer, "legitnamechange", 1, false)
						local name = setPlayerName(targetPlayer, tostring(newName))

						if (name) then
							exports['vrp_cache']:clearCharacterName( dbid )
							dbExec(mysql:getConnection(), "UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

							local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
							local processedNewName = string.gsub(tostring(newName), "_", " ")
							if (hiddenAdmin==0) then
								exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " changed " .. targetPlayerName .. "'s Name to " .. newName .. ".")
								outputChatBox("You character's name has been changed from '"..targetPlayerName .. "' to '" .. tostring(newName) .. "' by "..adminTitle.." "..getPlayerName(thePlayer)..".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("You character's name has been changed from '"..targetPlayerName .. "' to " .. processedNewName .. "' by a Hidden Admin.", targetPlayer, 0, 255, 0)
							end
							outputChatBox("You changed " .. targetPlayerName .. "'s name to '" .. processedNewName .. "'.", thePlayer, 0, 255, 0)

							setElementData(targetPlayer, "legitnamechange", 0, false)

							--triggerClientEvent(targetPlayer, "updateName", targetPlayer, getElementData(targetPlayer, "dbid"))
							exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun ismini değiştirdi.")
						else
							outputChatBox("Failed to change name.", thePlayer, 255, 0, 0)
						end
						setElementData(targetPlayer, "legitnamechange", 0, false)
				end
			end
		end
	end
end
addCommandHandler("changename", asetPlayerName, false, false)

function setPlayerHealth(thePlayer, commandName, targetPlayer, health)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not tonumber(health) or not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Health]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				if tonumber( health ) < getElementHealth( targetPlayer ) and getElementData( thePlayer, "admin_level" ) < getElementData( targetPlayer, "admin_level" ) then
					outputChatBox("NAH.", thePlayer, 255, 0, 0)
				elseif not setElementHealth(targetPlayer, tonumber(health)) then
					outputChatBox("Invalid health value.", thePlayer, 255, 0, 0)
				else
					outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
					triggerEvent("onPlayerHeal", targetPlayer, true)
					exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "SETHP "..health)
					exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun sağlık değerini değiştirdi.")
				end
			end
		end
	end
end
addCommandHandler("sethp", setPlayerHealth, false, false)

function adminHeal(thePlayer, commandName, targetPlayer)
	if (exports.vrp_global:isStaffOnDuty(thePlayer)) then
		local health = 100
		local targetPlayerName = getPlayerName(thePlayer):gsub("_", " ")
		if not (targetPlayer) then
			targetPlayer = thePlayer
		else
			targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		end

		if targetPlayer then
			setElementHealth(targetPlayer, tonumber(health))
			outputChatBox("Player " .. targetPlayerName .. " has received " .. health .. " Health.", thePlayer, 0, 255, 0)
			triggerEvent("onPlayerHeal", targetPlayer, true)
			exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "AHEAL "..health)
			exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun canını doldurdu.")
		end
	end
end
addCommandHandler("aheal", adminHeal, false, false)

function setPlayerArmour(thePlayer, theCommand, targetPlayer, armor)
	if (exports.vrp_integration:isPlayerAdminII(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (targetPlayer) or not (armor) then
			outputChatBox("SYNTAX: /" .. theCommand .. " [Player Partial Nick / ID] [Armor]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")
				if (logged==1) then
					if (tostring(type(tonumber(armor))) == "number") then
						local targetPlayerFaction = getElementData(targetPlayer, "faction")
						if (targetPlayerFaction == 1) or (targetPlayerFaction == 15) or (targetPlayerFaction == 59) then
							local setArmor = setPedArmor(targetPlayer, tonumber(armor))
							outputChatBox("" .. targetPlayerName .. " isimli oyuncuya " .. armor .. " miktar zırh verildi.", thePlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "SETARMOR " ..tostring(armor))
						elseif (targetPlayerFaction ~= 1) or (targetPlayerFaction ~= 15) or (targetPlayerFaction ~= 59) then
							if (exports.vrp_integration:isPlayerAdmin(thePlayer)) then
								local setArmor = setPedArmor(targetPlayer, tonumber(armor))
								outputChatBox("" .. targetPlayerName .. " isimli oyuncuya " .. armor .. " miktar zırh verildi.", thePlayer, 0, 255, 0)
								exports.vrp_logs:dbLog(thePlayer, 4, tagetPlayer, "SETARMOR " ..tostring(armor))
								exports.vrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncunun zırh değerini değiştirdi.")
							else
							end
						end
					else
						outputChatBox("Geçersiz zırh değeri.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox(exports.vrp_pool:getServerSyntax(false, "e").."Karşı kullanıcı giriş yapmadığı için işlem gerçekleştirilemedi.", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("setarmor", setPlayerArmour, false, false)

function givePlayerGun(thePlayer, commandName, targetPlayer, ...)
	if exports.vrp_integration:isPlayerHeadAdmin(thePlayer) then  
		local args = {...}
		if not (targetPlayer) or (#args < 2) then
			exports["vrp_infobox"]:addBox(thePlayer, "warning", "/makegun [Karakter Adı & ID] [Silah ID] [Tek Kelimeli Sebep]")
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then

				
				local weaponID 	 = tonumber(args[1])
				local weaponName = args[1]
				local reason     = tostring(args[2])	
				
				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Hatalı Silah Adı veya ID'si, /gunlist'ten kontrol edin.")
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Hatalı Silah Adı veya ID'si, /gunlist'ten kontrol edin.")
						return
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Oyuncu henüz giriş yapmamış.")
				elseif (logged==1) then
				
					local adminDBID = tostring(getElementData(thePlayer, "account:username"))
					local playerDBID = tostring(getElementData(targetPlayer, "account:username"))

					if quantity == nil then
						quantity = 1
					end

					local maxAmountOfWeapons = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfWeapons' ))
					if quantity > maxAmountOfWeapons then
						quantity = maxAmountOfWeapons
						outputChatBox("[MAKEGUN] Aynı anda "..maxAmountOfWeapons.." silahdan daha fazla silah veremezsiniz. "..maxAmountOfWeapons.." silah oluşturulmaya çalışılıyor...", thePlayer, 150, 150, 150)
					end

					local count = 0
					local fails = 0
					local allSerials = ""
					local give, error = ""
					for variable = 1, quantity, 1 do
						local mySerial = exports.vrp_global:createWeaponSerial( 1, adminDBID, playerDBID)
						--outputChatBox(mySerial)
						give, error = exports.vrp_global:giveItem(targetPlayer, 115, weaponID..":"..mySerial..":"..getWeaponNameFromID(weaponID).."::")
						if give then
					
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEWEAPON "..getWeaponNameFromID(weaponID).." "..tostring(mySerial))
							dbExec(mysql:getConnection(), "INSERT INTO makegunlog(admin, player, gun, gunserial, reason, date) VALUE('"..adminDBID.."', '"..playerDBID.."', '"..getWeaponNameFromID(weaponID).."', '"..tostring(mySerial).."', '"..tostring(reason).."', NOW())")
							
							if count == 0 then
								allSerials = mySerial
							else
								allSerials = allSerials.."', '"..mySerial
							end
							count = count + 1
						else
							fails = fails + 1
						end
					end
					if count > 0 then
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							outputChatBox("[SİLAH OLUŞTURMA] "..count.." adet ".. getWeaponNameFromID(weaponID).." silahını "..targetPlayerName.." adlı oyuncuya teslim ettin. Veritabanına kayıt edildi.", thePlayer, 0, 255, 0)
							outputChatBox("[-]#f9f9f9 "..adminTitle.." "..getPlayerName(thePlayer).." adlı yetkili sana "..count.." adet ".. getWeaponNameFromID(weaponID).." markalı silah verildi.", targetPlayer, 0, 255, 0, true)
							exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. ", " .. targetPlayerName .. " isimli oyuncuya "..count.." adet " .. getWeaponNameFromID(weaponID) .. " verdi. Sebep: '"..tostring(reason).."'")
							exports.vrp_global:sendMessageToAdmins("AdmCmd: Silahın Seriali: '"..allSerials.."'")
						else 
							outputChatBox("[SİLAH OLUŞTURMA] "..count.." adet ".. getWeaponNameFromID(weaponID).." silahını "..targetPlayerName.." adlı oyuncuya teslim ettin.", thePlayer, 0, 255, 0)
							outputChatBox("[-]#f9f9f9 "..adminTitle.." "..getPlayerName(thePlayer).." adlı yetkili sana "..count.." adet ".. getWeaponNameFromID(weaponID).." markalı silah verildi. Veritabanına kayıt edildi.", targetPlayer, 0, 255, 0, true)
							exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. ", " .. targetPlayerName .. " isimli oyuncuya "..count.." adet " .. getWeaponNameFromID(weaponID) .. " verdi. Sebep: '"..tostring(reason).."'")
							exports.vrp_global:sendMessageToAdmins("AdmCmd: Silahın Seriali: '"..allSerials.."'")
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEGUN] "..fails.." weapons couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." weapons couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("makegun", givePlayerGun, false, false)
addEvent("onMakeGun", true)
addEventHandler("onMakeGun", getRootElement(), givePlayerGun)

function givePlayerGunAmmo(thePlayer, commandName, targetPlayer, ...)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		local args = {...}
		if not (targetPlayer) or (#args < 1) then
			exports["vrp_infobox"]:addBox(thePlayer, "warning", "/makeammo [Karakter Adı & ID] [Silah ID] [Mermi Miktarı] [Şarjör] [Tek Kelimeli Sebep]")
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				--local ammo =  tonumber(args[2]) or 1
				local weaponID = tonumber(args[1])
				local weaponName = args[1]
				local ammo = tonumber(args[2]) or -1
				local quantity = tonumber(args[3]) or -1
				local reason     = tostring(args[4])	



				if weaponID == nil then
					local cWeaponName = weaponName:lower()
					if cWeaponName == "colt45" then
						weaponID = 22
					elseif cWeaponName == "rocketlauncher" then
						weaponID = 35
					elseif cWeaponName == "combatshotgun" then
						weaponID = 27
					elseif cWeaponName == "fireextinguisher" then
						weaponID = 42
					else
						if getWeaponIDFromName(cWeaponName) == false then
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Hatalı Silah Adı veya ID'si, /gunlist'ten kontrol edin.")
							return
						else
							weaponID = getWeaponIDFromName(cWeaponName)
						end
					end
				end

				if getAmmoPerClip(weaponID) == "disabled" then --If weapon is not allowed
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Hatalı Silah Adı veya ID'si, /gunlist'ten kontrol edin.")
					return
				elseif getAmmoPerClip(weaponID) == tostring(0)  then-- if weapon doesn't need ammo to work
						exports["vrp_infobox"]:addBox(thePlayer, "error", "Bu silahın mermisini alamazsın.")
					return
				else
				end

				local logged = getElementData(targetPlayer, "loggedin")
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				if (logged==0) then
					exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				elseif (logged==1) then
					if ammo == -1 then -- if full ammopack
						ammo = getAmmoPerClip(weaponID)
					end

					if quantity == -1 then
						quantity = 1
					end

					local maxAmountOfAmmopacks = tonumber(get( getResourceName( getThisResource( ) ).. '.maxAmountOfAmmopacks' ))
					if quantity > maxAmountOfAmmopacks then
						quantity = maxAmountOfAmmopacks
						outputChatBox("[MAKEAMMO] You can't give more than "..maxAmountOfAmmopacks.." magazines at a time. Trying to spawn "..maxAmountOfAmmopacks.."...", thePlayer, 150, 150, 150)
					end
					local adminDBID = tostring(getElementData(thePlayer, "account:username"))
					local playerDBID = tostring(getElementData(targetPlayer, "account:username"))

					local count = 0
					local fails = 0
					local give, error = ""
					for variable = 1, quantity, 1 do
						give, error = exports.vrp_global:giveItem(targetPlayer, 116, weaponID..":"..ammo..":Ammo for "..getWeaponNameFromID(weaponID))
						if give then				
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEBULLETS "..getWeaponNameFromID(weaponID).." "..tostring(bullets))
							dbExec(mysql:getConnection(), "INSERT INTO makeammolog(admin, player, gun, ammovalue, reason, date) VALUE('"..adminDBID.."', '"..playerDBID.."', '"..getWeaponNameFromID(weaponID).."', '"..tostring(ammo).."', '"..tostring(reason).."', NOW())")
							count = count + 1
						else
							fails = fails + 1
						end
					end

					if count > 0 then
						local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
						if (hiddenAdmin==0) then
							outputChatBox("[MERMİ OLUŞTURMA]#f9f9f9 "..getWeaponNameFromID(weaponID).." silahına toplam "..ammo.." mermi verdin. Verdiğin Oyuncu: "..targetPlayerName.."", thePlayer, 0, 255, 0, true)
							outputChatBox("#575757Valhalla:#f9f9f9 Verdiğin mermi logu veritabanına kaydedildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("#575757Valhalla:#f9f9f9 Bir yetkili senin "..getWeaponNameFromID(weaponID).." silahına toplam "..ammo.." mermi iadesinde bulundu.", targetPlayer, 0, 255, 0, true)
							exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. ", " .. targetPlayerName .. " isimli oyuncuya "..ammo.." adet " .. getWeaponNameFromID(weaponID) .. " mermisi verdi. Sebep: '"..tostring(reason).."'")

						else -- If hidden admin
							outputChatBox("[MERMİ OLUŞTURMA]#f9f9f9 "..getWeaponNameFromID(weaponID).." silahına toplam "..ammo.." mermi verdin. Verdiğin Oyuncu: "..targetPlayerName.."", thePlayer, 0, 255, 0, true)
							outputChatBox("#575757Valhalla:#f9f9f9 Verdiğin mermi logu veritabanına kaydedildi.", thePlayer, 0, 255, 0, true)
							outputChatBox("#575757Valhalla:#f9f9f9 Bir yetkili senin "..getWeaponNameFromID(weaponID).." silahına toplam "..ammo.." mermi iadesinde bulundu.", targetPlayer, 0, 255, 0, true)
							exports.vrp_global:sendMessageToAdmins("AdmCmd: " .. tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. ", " .. targetPlayerName .. " isimli oyuncuya "..ammo.." adet " .. getWeaponNameFromID(weaponID) .. " mermisi verdi. Sebep: '"..tostring(reason).."'")					
						end
					end
					if fails > 0 then
						outputChatBox("[MAKEAMMO] "..fails.." ammopacks couldn't be created. Player's ".. error ..".", thePlayer, 255, 0, 0)
						outputChatBox("[ERROR] "..fails.." ammopacks couldn't be received from Admin. Your ".. error ..".", targetPlayer, 255, 0, 0)
					end


				end
			end
		end
	end
end
addCommandHandler("makeammo", givePlayerGunAmmo, false, false)
addEvent("onMakeAmmo", true)
addEventHandler("onMakeAmmo", getRootElement(), givePlayerGunAmmo)

function givePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.vrp_integration:isPlayerDeveloper(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			itemID = tonumber(itemID)

			if (itemID == 169 or itemID == 150) and getElementData(thePlayer, "account:id") ~= 1 then
				outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
				return false
			end

			if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.vrp_integration:isPlayerSeniorAdmin( thePlayer) then -- Banned Items
				exports.vrp_hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
				return false
			end
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue

			if itemID == 114 and exports['vrp_shop']:getDisabledUpgrades()[tonumber(itemValue)] then
				outputChatBox("This item is temporarily disabled.", thePlayer, 255, 0, 0)
				return false
			end
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			local preventSpawn = exports["vrp_items"]:getItemPreventSpawn(itemID, itemValue)
			if preventSpawn then
				exports.vrp_hud:sendBottomNotification(thePlayer, "Non-Spawnable Item", "This item cannot be spawned. It might be temporarily restricted or only obtainable IC.")
				return false
			end

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if ( itemID == 84 ) and not exports.vrp_integration:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.vrp_integration:isPlayerTrialAdmin( thePlayer ) then
				elseif (itemID == 115 or itemID == 116 or itemID == 68 or itemID == 134 --[[or itemID == 137)]]) then
					outputChatBox("Sorry, you cannot use this with /giveitem.", thePlayer, 255, 0, 0)
				elseif (logged==0) then
					exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				elseif (logged==1) then
					local name = call( getResourceFromName( "vrp_items" ), "getItemName", itemID, itemValue )

					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.vrp_global:giveItem(targetPlayer, itemID, itemValue)
						if success then
							outputChatBox("Player " .. targetPlayerName .. " has received a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVEITEM "..name.." "..tostring(itemValue))
							triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
							local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
							local adminTitle = exports.vrp_global:getPlayerAdminTitle(thePlayer)
							if (hiddenAdmin==0) then
								outputChatBox(tostring(adminTitle) .. " " .. getPlayerName(thePlayer) .. " has given you a " .. name .. " with value " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							else
								outputChatBox("A Hidden Admin has given you a " .. name .. " with value " .. itemValue .. ".", targetPlayer, 0, 255, 0)
							end
						else
							outputChatBox("Couldn't give " .. targetPlayerName .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
	end
addCommandHandler("giveitem", givePlayerItem, false, false)

function givePedItem(thePlayer, commandName, ped, itemID, ...)
	if (exports.vrp_integration:isPlayerDeveloper(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (ped) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Ped dbid] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			if ped then
				local element = exports.vrp_pool:getElement("ped", tonumber(ped))
				local pedname = getElementData(element, "rpp.npc.name")
				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue
				
				if ( itemID == 74 or itemID == 150 or itemID == 75 or itemID == 78 or itemID == 2) and not exports.vrp_integration:isPlayerSeniorAdmin( thePlayer) then -- Banned Items
					exports.vrp_hud:sendBottomNotification(thePlayer, "Banned Items", "Only Lead+ Admin can spawn this kind of item.")
					return false
				elseif ( itemID == 84 ) and not exports.vrp_global:isPlayerAdmin( thePlayer ) then
				elseif itemID == 114 and not exports.vrp_global:isPlayerTrialAdmin( thePlayer ) then
				else
					local name = call( getResourceFromName( "vrp_items" ), "getItemName", itemID, itemValue )
					
					if itemID > 0 and name and name ~= "?" then
						local success, reason = exports.vrp_global:giveItem(element, itemID, itemValue)
						if success then
							outputChatBox("Ped "..tostring(pedname) or "".." (".. tostring(ped) ..") now has a " .. name .. " with value " .. itemValue .. ".", thePlayer, 0, 255, 0)
							exports.vrp_logs:dbLog(thePlayer, 4, ped, "GIVEITEM "..name.." "..tostring(itemValue))
							if element then
								exports['vrp_items']:npcUseItem(element, itemID)
							else
								outputChatBox("Failed to get ped element from dbid.", thePlayer, 255, 255, 255)
							end
						else
							outputChatBox("Couldn't give ped " .. tostring(ped) .. " a " .. name .. ": " .. tostring(reason), thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Invalid Item ID.", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("givepeditem", givePedItem, false, false)

function takePlayerItem(thePlayer, commandName, targetPlayer, itemID, ...)
	if (exports.vrp_integration:isPlayerDeveloper(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (itemID) or not (...) or not (targetPlayer) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [Item ID] [Item Value]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				itemID = tonumber(itemID)
				local itemValue = table.concat({...}, " ")
				itemValue = tonumber(itemValue) or itemValue

				if (logged==0) then
					exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				elseif (logged==1) then
					if exports.vrp_global:hasItem(targetPlayer, itemID, itemValue) then
						outputChatBox("You took item " .. itemID .. " with the value of (" .. itemValue .. ") from " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
						exports.vrp_global:takeItem(targetPlayer, itemID, itemValue)
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "TAKEITEM "..tostring(itemID).." "..tostring(itemValue))

						triggerClientEvent(targetPlayer, "item:updateclient", targetPlayer)
					else
						outputChatBox("Player doesn't have that item", thePlayer, 255, 0, 0)
					end
				end
			end
		end
	end
end
addCommandHandler("takeitem", takePlayerItem, false, false)

function setPlayerSkinCmd(thePlayer, commandName, targetPlayer, skinID, clothingID)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if not (skinID) or not (targetPlayer) then -- Clothing ID is a optional argument
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID] [Skin ID] (Clothing ID)", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not exports.vrp_integration:isPlayerDeveloper(thePlayer) then
					if tonumber(skinID) == 99 then
						outputChatBox("[-]#f9f9f9 Bu kostümü sadece bekiroj veya bekiroj kullanabilir.",thePlayer,255,194,50,true)
					return end
			end		

			if targetPlayer then
				local logged = getElementData(targetPlayer, "loggedin")

				if (logged==0) then

					exports["vrp_infobox"]:addBox(thePlayer, "warning", "Oyuncu henüz giriş yapmamış.")
				elseif tostring(type(tonumber(skinID))) == "number" and tonumber(skinID) ~= 0 then
					local fat = getPedStat(targetPlayer, 21)
					local muscle = getPedStat(targetPlayer, 23)

					setPedStat(targetPlayer, 21, 0)
					setPedStat(targetPlayer, 23, 0)
					local oldSkin = getElementModel(targetPlayer)
					local skin = setElementModel(targetPlayer, tonumber(skinID))

					setPedStat(targetPlayer, 21, fat)
					setPedStat(targetPlayer, 23, muscle)

					if not (skin) and tonumber(oldSkin) ~= tonumber(skin) then
						outputChatBox("Invalid skin ID.", thePlayer, 255, 0, 0)
					else
						if not tonumber(clothingID) then
							clothingID = nil
						end

						outputChatBox(targetPlayerName .. " adlı oyuncunun skinini değiştirdin.", thePlayer, 0, 255, 0)
						setElementData(targetPlayer, 'skin', tonumber(skinID), true)
						dbExec(mysql:getConnection(), "UPDATE characters SET skin = " .. (skinID) .. " WHERE id = " .. (getElementData( targetPlayer, "dbid" )) )
						exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "SETSKIN "..tostring(skinID).." CLOTHING "..tostring(clothingID))
					end
				else
					outputChatBox("[-]#f9f9f9 Hatalı Skin ID!", thePlayer, 255, 0, 0, true)
				end
			end
		end
	end
end
addCommandHandler("setskin", setPlayerSkinCmd, false, false)

function nudgePlayer(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
			   exports["vrp_infobox"]:addBox(thePlayer, "error", "Bu oyuncu oyunda değil.")			
			   else
				triggerClientEvent ( "durtmeSesi", targetPlayer)
				outputChatBox("#575757Valhalla:#f9f9f9 '" .. targetPlayerName .. "' isimli oyuncuyu dürttünüz.", thePlayer, 255, 194, 14, true)
				outputChatBox("[-]#f9f9f9 '" .. getPlayerName(thePlayer) .. "' isimli yetkili tarafından dürtüldünüz.", targetPlayer, 255,0,0,true)
			end
		end
	end
end
addCommandHandler("nudge", nudgePlayer, false, false)
addCommandHandler("dürt", nudgePlayer, false, false)

-- /AHVER by bekiroj
function ahlatPlayer(thePlayer, commandName, targetPlayer)
	if (exports.vrp_integration:isPlayerDeveloper(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Oyuncu İsmi / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if not targetPlayer then
				return false
			end
			local logged = getElementData(targetPlayer, "loggedin")
			if (logged==0) then
			   exports["vrp_infobox"]:addBox(thePlayer, "error", "Bu oyuncu oyunda değil.")			
			   else
				triggerClientEvent ( "ahlayanSesi", targetPlayer)
				outputChatBox("#575757Valhalla:#f9f9f9 '" .. targetPlayerName .. "' isimli oyuncuyu ahlatarak dürttünüz.", thePlayer, 255, 194, 14, true)
				outputChatBox("[-]#f9f9f9 '" .. getPlayerName(thePlayer) .. "' isimli yetkili tarafından ahlayarak dürtüldünüz.", targetPlayer, 255,0,0,true)
			end
		end
	end
end
addCommandHandler("ahver", ahlatPlayer, false, false)

local syntaxTable = {
	["s"] = "#00a8ff[Valhalla]#ffffff ",
	["e"] = "#e84118[Valhalla]#ffffff ",
	["w"] = "#fbc531[Valhalla]#ffffff ",
}

addCommandHandler("paradagit",
	function(player, cmd, amount)
		if exports["vrp_integration"]:isPlayerDeveloper(player) then
			if amount and tonumber(amount) then
				outputChatBox(syntaxTable["w"].."Para dağıtma işlemi başlatıldı.", player, 255, 255, 255, true)
				for index, value in ipairs(getElementsByType("player")) do
					if getElementData(value, "loggedin") == 1 then
						exports["vrp_global"]:giveMoney(value, amount)
						outputChatBox(syntaxTable["s"].."Valhalla Roleplay'dan herkese "..exports["vrp_global"]:formatMoney(amount).."$ hediye!", value, 255, 255, 255, true)
					end
				end
			end
		end
	end
)

local quitingPlayers = {}

addEvent("quitingPlayer:addRow", true)
addEventHandler("quitingPlayer:addRow", root,
	function(table)
		quitingPlayers[#quitingPlayers + 1] = table
	end
)

addEvent("quitingPlayer:receiveTable", true)
addEventHandler("quitingPlayer:receiveTable", root,
	function(player)
		triggerClientEvent(player, "quitingPlayer:updateTable", player, quitingPlayers, true)
	end
)

function makeGenericItem(thePlayer, commandName, price, quantity, ...)
	if exports.vrp_global:isStaffOnDuty(thePlayer) and getElementData(thePlayer, "loggedin") == 1 then
		if not (price) or not (...) or not tonumber(price) or not (tonumber(price) > 0) or not (quantity) or not (tonumber(quantity) > 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Price] [Quantity, max=10] [Name:ObjectModel]", thePlayer, 255, 194, 14)
			outputChatBox("This command creates to yourself a generic item after taking away an amount of money as item's value.", thePlayer, 200, 200, 200)
			outputChatBox("Maximum quantity is 10. Will be spawned until you reach maximum weight.", thePlayer, 200, 200, 200)
		else
			if (tonumber(quantity) > 11) then
				outputChatBox("Your quantity was above 10. 10 have been requested.", thePlayer, 255, 0, 0)
				quantity = 10
			end
			local itemValue = table.concat({...}, " ")
			price = tonumber(price) * tonumber(quantity)
			local fPrice = exports.vrp_global:formatMoney(price)
			if not exports.vrp_global:takeMoney(thePlayer, price) then
				outputChatBox("You could not afford $"..fPrice.." for a '"..itemValue.."'.", thePlayer, 255, 0, 0)
				return false
			end

			local success, reason = setTimer ( function ()
				exports.vrp_global:giveItem(thePlayer, 80, itemValue)
			end, 250, quantity )
			if success then
				local playerName = exports.vrp_global:getAdminTitle1(thePlayer)
				exports.vrp_global:sendWrnToStaff(playerName.." has created "..quantity.." '"..itemValue.."' to themselves for $"..fPrice.." (total: "..tonumber(quantity)*tonumber(fPrice).."$).", "MAKEGENERIC")

				exports.vrp_logs:dbLog(thePlayer, 4, thePlayer, commandName.." x"..quantity.." "..itemValue.." for "..fPrice)
				triggerClientEvent(thePlayer, "item:updateclient", thePlayer)
				return true
			else
				outputChatBox("Failed to created generic item. Reason: " .. tostring(reason), thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end

function createCargoGenericPed()
	local thePed = createPed(27, 1613.6572265625, 1321.0185546875, 10.8225440979)
	setElementDimension(thePed, 0)
	setElementInterior(thePed, 0)
	setElementData( thePed, "name", "Michael Dupont")
    setElementFrozen(thePed, true)
    setElementData( thePed, "nametag", true)
    setPedRotation(thePed, 89.136)
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), createCargoGenericPed)

function makeGenericItemCargo(thePlayer, commandName, price, ...)
	if getElementData(thePlayer, "factionleader") == 1 and getElementData(thePlayer, "loggedin") == 1 and tostring(getTeamName(getPlayerTeam(thePlayer))) == "Cargo Group" then
		if getDistanceBetweenPoints3D(1613.6572265625, 1321.0185546875, 10.8225440979, getElementPosition(thePlayer)) > 20 then return end
		if not (price) or not (...) or not tonumber(price) or not (tonumber(price) > 0) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Price] [Name:ObjectModel] OR use the NPC GUI", thePlayer, 255, 194, 14)
			outputChatBox("This command creates to yourself a generic item after taking away an amount of money as item's value.", thePlayer, 200, 200, 200)
		else
			local itemValue = table.concat({...}, " ")
			price = tonumber(price)
			local fPrice = exports.vrp_global:formatMoney(price)
			if not exports.vrp_global:takeMoney(getTeamFromName("Cargo Group"), price) then
				outputChatBox("You could not afford $"..fPrice.." for a '"..itemValue.."'.", thePlayer, 255, 0, 0)
				return false
			end
			local success, reason = exports.vrp_global:giveItem(thePlayer, 80, itemValue)
			if success then
				local playerName = exports.vrp_global:getPlayerFullIdentity(thePlayer)
				exports.vrp_global:sendMessageToStaff("[CARGO GROUP] "..playerName.." has created a '"..itemValue.."' to themselves for $"..fPrice..".")
				exports.vrp_logs:dbLog(thePlayer, 4, thePlayer, "Cargo Group "..commandName.." "..itemValue.." for "..fPrice)
				triggerClientEvent(thePlayer, "item:updateclient", thePlayer)
				return true
			else
				outputChatBox("Failed to created generic item. Reason: " .. tostring(reason), thePlayer, 255, 0, 0)
				return false
			end
		end
	end
end
addEvent("createCargoGeneric", true)
addEventHandler("createCargoGeneric", getResourceRootElement(), makeGenericItemCargo)

function vehicleLimit(admin, command, player, limit)
	if getElementData(thePlayer, "account:username") == "bekiroj" or getElementData(thePlayer, "account:username") == "Helyumm" then
		if (not player and not limit) then
			outputChatBox("SYNTAX: /" .. command .. " [Player] [Limit]", admin, 255, 194, 14)
		else
			local tplayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(admin, player)
			if (tplayer) then
				
					local oldvl = tplayer:getData("maxvehicles")
					local newl = tonumber(limit)
					if (newl) then
						if (newl>0) then
							dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = " .. (newl) .. " WHERE id = " .. (getElementData(tplayer, "dbid")))

							setElementData(tplayer, "maxvehicles", newl, false)

							outputChatBox("You have set " .. targetPlayerName:gsub("_", " ") .. " vehicle limit to " .. newl .. ".", admin, 255, 194, 14)
							outputChatBox("Admin " .. getPlayerName(admin):gsub("_"," ") .. " has set your vehicle limit to " .. newl .. ".", tplayer, 255, 194, 14)

							exports.vrp_logs:dbLog(thePlayer, 4, tplayer, "SETVEHLIMIT "..oldvl.." "..newl)
						else
							outputChatBox("You can not set a level below 0", admin, 255, 194, 14)
						end
					end
				
			else
				outputChatBox("Something went wrong with picking the player.", admin)
			end
		end
	end
end
addCommandHandler("setvehlimit", vehicleLimit)

function giveChip(thePlayer, commandName, target, chip, ...)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if not (target) or not chip or not (...) then
			outputChatBox("[*] SÖZDİZİMİ: /" .. commandName .. " [Karakter Adı & ID] [Chip] [Sebep]", thePlayer, 255, 194, 14)
		else
			local username = getPlayerName(thePlayer)
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, target)

			if targetPlayer then
				chip = tonumber(chip) or 0
				if chip and chip > 500000 then
					outputChatBox("Güvenlik sebebiyle 500.000 TL'den yüksek bir değer giremezsin.", thePlayer, 255, 0, 0)
					return false
				end

				if not exports.vrp_casino:giveChip(targetPlayer, chip) then
					outputChatBox("Could not give player that amount.", thePlayer, 255, 0, 0)
					return false
				end

				exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "GIVECHIP " ..chip)


				local amount = exports.vrp_global:formatMoney(chip)
				reason = table.concat({...}, " ")
				outputChatBox("Başarıyla " .. targetPlayerName .. " isimli oyuncuya toplam " .. amount .. " TL verdin.", thePlayer)
				outputChatBox("Yetkili " .. username .. " sana toplam " .. amount .. " TL verdi.", targetPlayer)
				outputChatBox("Sebep: " .. reason .. ".", targetPlayer)

				local targetUsername = string.gsub(getElementData(targetPlayer, "account:username"), "_", " ")
				targetUsername = (targetUsername)
				local targetCharacterName = (targetPlayerName)


				if tonumber(chip) >= 5000 then
					exports.vrp_global:sendMessageToAdmins("[GIVECHIP] " .. username .. " isimli yetkili ("..targetUsername..") "..targetCharacterName.." isimli oyuncuya " .. amount .. " Chip verdi. ("..reason.."). Bilgi: https://www.Valhallaroleplay.com/")
				else
					exports.vrp_global:sendMessageToAdmins("[GIVECHIP] " .. username .. " isimli yetkili ("..targetUsername..") "..targetCharacterName.." isimli oyuncuya " .. amount .. " Chip verdi. ("..reason..").")
				end

			end
		end
	end
end
addCommandHandler("givechip", giveChip, false, false)

function charIDtoName(thePlayer, commandName, input)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		if not input then
			outputChatBox("SYNTAX: /"..commandName.." [input] - Input can either be an exact character name (with underscore) or a character ID. ", thePlayer)
		else
			if tonumber(input) then
				local queryhandle = dbQuery(mysql:getConnection(), "SELECT `charactername` FROM characters WHERE `id`='"..(tonumber(input)).."'")
				local result = dbPoll(queryhandle, -1)
				for rid, row in ipairs (result) do 
				    for column, value in pairs (row) do
				        outputChatBox("#"..input.." returns character name: "..value, thePlayer)
				    end
				end
			else
				local queryhandle = dbQuery(mysql:getConnection(), "SELECT `id` FROM characters WHERE `charactername`='"..(input).."'")
				local result = dbPoll(queryhandle, -1)
				for rid, row in ipairs (result) do 
				    for column, value in pairs (row) do
				        outputChatBox("Character name "..input.." returns id: #"..value, thePlayer)
				    end
				end
			end
		end
	end
end
addCommandHandler("charid", charIDtoName)

function gotopos(thePlayer, cmd, x, y, z)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if tonumber(x) and tonumber(y) and tonumber(z) then
			setElementPosition(thePlayer, x, y, z)
		end
	end
end
addCommandHandler("gotopos", gotopos)