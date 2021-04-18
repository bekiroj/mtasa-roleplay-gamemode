local mysql = exports.vrp_mysql;

addEventHandler('onResourceStart', resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						local id = tonumber(row["id"])
						local x = tonumber(row["x"])
						local y = tonumber(row["y"])
						local z = tonumber(row["z"])

						local rotation = tonumber(row["rotation"])
						local dimension = tonumber(row["dimension"])
						local interior = tonumber(row["interior"])
						local deposit = tonumber(row["deposit"])
						local limit = tonumber(row["limit"])
						
						local object = createObject(2942, x, y, z, 0, 0, rotation-180)
						exports.vrp_pool:allocateElement(object)
						setElementDimension(object, dimension)
						setElementInterior(object, interior)
						setElementData(object, "depositable", deposit)
						setElementData(object, "limit", limit)
						setElementData(object, "bank-operation", true)
						
						local px = x + math.sin(math.rad(-rotation)) * 0.8
						local py = y + math.cos(math.rad(-rotation)) * 0.8
						local pz = z
						
						setElementData(object, "dbid", id, true)
					end
				end
			end,
		mysql:getConnection(), "SELECT id, x, y, z, rotation, dimension, interior, deposit, `limit` FROM atms")
	end
)

function hasBankMoney(thePlayer, amount)
	amount = tonumber(amount) 
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return getElementData(thePlayer, "bankmoney") >= amount
	elseif getElementType(thePlayer) == "team" then
		return getElementData(thePlayer, "money") >= amount
	end
end

function takeBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if not hasBankMoney(thePlayer, amount) then
		return false, "Lack of money in bank"
	end
	if getElementType(thePlayer) == "player" then
		return setElementData(thePlayer, "bankmoney", getElementData(thePlayer, "bankmoney")-amount, true) and dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bankmoney`=bankmoney-"..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementData(thePlayer, "money", getElementData(thePlayer, "money")-amount, true) and dbExec(mysql:getConnection(),  "UPDATE `factions` SET `bankbalance`=bankbalance-"..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end

function giveBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return setElementData(thePlayer, "bankmoney", getElementData(thePlayer, "bankmoney")+amount, true) and dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bankmoney`=bankmoney+"..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementData(thePlayer, "money", getElementData(thePlayer, "money")+amount, true) and dbExec(mysql:getConnection(),  "UPDATE `factions` SET `bankbalance`=bankbalance+"..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end

function setBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return setElementData(thePlayer, "bankmoney", amount, true) and dbExec(mysql:getConnection(),  "UPDATE `characters` SET `bankmoney`="..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementData(thePlayer, "money", amount, true) and dbExec(mysql:getConnection(),  "UPDATE `factions` SET `bankbalance`="..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end

function updateBankMoney(thePlayer, charID, money, transfer)
	if not charID or not tonumber(charID) or not money or not tonumber(money) then
		return false
	else
		charID = tonumber(charID)
		money = math.abs(money)
	end

	if charID < 0 then -- faction id
		local factionId = -charID
		local foundFaction = nil
		--outputDebugString(factionId)
		for _, faction in pairs(getElementsByType("team")) do
			--outputDebugString(tonumber(getElementData(faction, "id")) )
			if factionId == tonumber(getElementData(faction, "id")) then
				foundFaction = faction
				break
			end
		end

		if not foundFaction then 
			outputDebugString ("bank / atm / didn't find the faction from id ")
			return false
		end

		if not transfer then
			return exports.vrp_global:setMoney(foundFaction, money)
		else
			if transfer == "minus" then
				return exports.vrp_global:takeMoney(foundFaction, money)
			elseif transfer == "plus" then
				return exports.vrp_global:giveMoney(foundFaction, money)
			else
				return false
			end
		end
	else
		if not transfer then
			for _, player in pairs(getElementsByType("player")) do
				if tonumber(charID) == tonumber(getElementData(player, "dbid")) then
					setElementData(player, "bankmoney", tonumber(money) or 0, true)
				end
			end
			
			--UPDATE TO SQL
			if not dbExec(mysql:getConnection(), "UPDATE `characters` SET `bankmoney`='"..money.."' WHERE `id`='"..charID.."' ") then
				return false
			end
			return true
		else
			if transfer == "minus" then
				for _, player in pairs(getElementsByType("player")) do
					if tonumber(charID) == tonumber(getElementData(player, "dbid")) then
						local current = getElementData(player, "bankmoney")
						if tonumber(money) > current then
							return false
						end
						setElementData(player, "bankmoney", current-tonumber(money), true)
					end
				end
				--UPDATE TO SQL
				if not dbExec(mysql:getConnection(), "UPDATE `characters` SET `bankmoney`=bankmoney-"..money.." WHERE `id`='"..charID.."' ") then
					return false
				end
				return true
			elseif transfer == "plus" then
				for _, player in pairs(getElementsByType("player")) do
					if tonumber(charID) == tonumber(getElementData(player, "dbid")) then
						setElementData(player, "bankmoney", getElementData(player, "bankmoney")+tonumber(money), true)
					end
				end
				--UPDATE TO SQL
				if not dbExec(mysql:getConnection(), "UPDATE `characters` SET `bankmoney`=bankmoney+"..money.." WHERE `id`='"..charID.."' ") then
					return false
				end
				return true
			else
				return false
			end
		end
	end
end

function deleteATM(thePlayer, commandName, id)
	if (exports.vrp_integration:isPlayerAdmin(thePlayer)) then
		if not (id) then
			outputChatBox("SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
		else
			id = tonumber(id)
				
			local counter = 0
			local objects = getElementsByType("object", getResourceRootElement())
			for k, theObject in ipairs(objects) do
				local objectID = getElementData(theObject, "dbid")
				if (objectID==id) then
					destroyElement(theObject)
					counter = counter + 1
				end
			end
			
			if (counter>0) then
				local query = dbExec(mysql:getConnection(), "DELETE FROM atms WHERE id='" .. id .. "'")
				
				outputChatBox("ATM başarıyla silindi.", thePlayer, 0, 255, 0)
			else
				outputChatBox("ATM ID bulunamadı.", thePlayer, 255, 0, 0)
			end
		end
	end
end
addCommandHandler("delatm", deleteATM, false, false)

function getNearbyATMs(thePlayer, commandName)
	if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local posX, posY, posZ = getElementPosition(thePlayer)
		outputChatBox("Etrafta bulunan ATM listesi:", thePlayer, 255, 126, 0)
		local count = 0
		
		for k, theObject in ipairs(getElementsByType("object", resourceRoot)) do
			local x, y, z = getElementPosition(theObject)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			if (distance<=10) then
				local dbid = getElementData(theObject, "dbid")
				outputChatBox("   ATM ID: " .. dbid .. ".", thePlayer)
				count = count + 1
			end
		end
		
		if (count==0) then
			outputChatBox("   Yok.", thePlayer, 255, 126, 0)
		end
	end
end
addCommandHandler("nearbyatms", getNearbyATMs, false, false)

local unallowedStrings = {"\'", "\"", "\`", "\*", "\="}

function addBankTransactionLog(fromAccount, toAccount, amount, type, reason, details, fromCard, toCard)
	if not amount or not tonumber(amount) or not type or not tonumber(type) or fromAccount == toAccount then
		return false
	end

	local sql = "INSERT INTO wiretransfers SET `amount` = '"..amount.."', type = '"..type.."' "
	if fromAccount then
		--fromAccount = fromAccount:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `from` = '"..(fromAccount).."' "
	end
	if fromCard then
		--fromCard = fromCard:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `from_card` = '"..(fromCard).."' "
	end
	if toCard then
		--toCard = toCard:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `to_card` = '"..(toCard).."' "
	end
	if toAccount then
		--toAccount = toAccount:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `to` = '"..(toAccount).."' "
	end 
	if reason then
		reason = reason:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `reason` = '"..(reason).."' "
	end
	if details then
		details = details:gsub("["..table.concat(unallowedStrings).."]", "")
		sql = sql..", `details` = '"..(details).."' "
	end

	return dbExec(mysql:getConnection(), sql) 
end
addEvent("addBankTransactionLog", true)
addEventHandler("addBankTransactionLog", getRootElement(), addBankTransactionLog)

function getATMName(theAtm)
	return "ATM Machine ID#"..getElementData(theAtm, "dbid").." at "..exports.vrp_global:getElementZoneName(theAtm)
end

addEvent('BankBrowser-DepositMoney', true)
addEventHandler('BankBrowser-DepositMoney', root,
	function(amount)
		if exports.vrp_global:hasMoney(source, amount) and amount > 0 then
			exports.vrp_global:takeMoney(source, amount)
			source:setData('bankmoney', source:getData('bankmoney') + amount)
			dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney='"..source:getData('bankmoney').."' WHERE id='"..source:getData('dbid').."'")
			dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. source:getData('dbid') .. ", 0, " .. amount .. ", '', 1)");
			outputChatBox("Bank of Santos:#ffffff Para başarıyla banka hesabına aktarıldı.", source, 100, 100, 100, true)
		end
	end
)

addEvent('BankBrowser-WidthrawMoney', true)
addEventHandler('BankBrowser-WidthrawMoney', root,
	function(amount)
		if source:getData('bankmoney') >= amount and amount > 0 then
			exports.vrp_global:giveMoney(source, amount)
			source:setData('bankmoney', source:getData('bankmoney') - amount)
			dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney='"..source:getData('bankmoney').."' WHERE id='"..source:getData('dbid').."'");
			dbExec(mysql:getConnection(), "INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. source:getData('dbid') .. ", 0, " .. amount .. ", '', 0)");
			outputChatBox("Bank of Santos:#ffffff Banka hesabınızdan başarıyla para çekildi.", source, 100, 100, 100, true)
		end
	end
)


function transferMoneyToPersonal(business, name, amount, reason)
	local state = tonumber(getElementData(client, "loggedin")) or 0
	if (state == 0) then
		return
	end
	
	reason = (reason)
	local reciever = getTeamFromName(name) or getPlayerFromName(string.gsub(name," ","_"))
	local dbid = nil
	if not reciever then
		outputChatBox("Kişi bulunamadı.", client)
		return
	else
		dbid = getElementData(reciever, "id") and -getElementData(reciever, "id") or getElementData(reciever, "dbid")
	end
	
	if not dbid and not reciever then
		outputChatBox("Player not found. Please enter the full character name.", client, 255, 0, 0)
	else
		if business then
			local theTeam = getPlayerTeam(client)
			if -getElementData(theTeam, "id") == dbid then
				outputChatBox("You can't wiretransfer money to yourself.", client, 255, 0, 0)
				return
			end
			if exports.vrp_global:takeMoney(theTeam, amount) then
				dbExec(mysql:getConnection(),"INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. (( -getElementData( theTeam, "id" ) )) .. ", " .. (dbid) .. ", " .. (amount) .. ", '" .. (reason) .. "', 3)" )
			end
		else
			if reciever == client then
				outputChatBox("You can't wiretransfer money to yourself.", client, 255, 0, 0)
				return
			end
			if getElementData(client, "bankmoney") - amount >= 0 then
				setElementData(client, "bankmoney", getElementData(client, "bankmoney") - amount, true)
				dbExec(mysql:getConnection(),"INSERT INTO wiretransfers (`from`, `to`, `amount`, `reason`, `type`) VALUES (" .. (getElementData(client, "dbid")) .. ", " .. (dbid) .. ", " .. (amount) .. ", '" .. (reason) .. "', 2)" ) 
			else
				outputChatBox( "No.", client, 255, 0, 0 )
				return
			end
		end
		
		if reciever then
			if dbid < 0 then
				exports.vrp_global:giveMoney(reciever, amount)
			else
				setElementData(reciever, "bankmoney", getElementData(reciever, "bankmoney") + amount, true)
				saveBank(reciever)
			end
		else
			dbExec(mysql:getConnection(),"UPDATE characters SET bankmoney=bankmoney+" .. (amount) .. " WHERE id=" .. (dbid))
		end
		triggerClientEvent(client, "hideBankUI", client)
		outputChatBox("You transfered $" .. exports.vrp_global:formatMoney(amount) .. " from your "..(business and "business" or "personal").." account to "..name..(string.sub(name,-1) == "s" and "'" or "'s").." account.", client, 255, 194, 14)
		
		if business then
			exports.vrp_logs:dbLog(client, 25, { getPlayerTeam(client), "ch" .. dbid }, "TRANSFER FROM BUSINESS " .. amount .. " TO " .. name)
		else
			exports.vrp_logs:dbLog(client, 25, { client, "ch" .. dbid }, "TRANSFER " .. amount .. " TO " .. name)
		end
		
		saveBank(client)
	end
end
addEvent("transferMoneyToPersonal", true)
addEventHandler("transferMoneyToPersonal", getRootElement(), transferMoneyToPersonal)


function saveBank( thePlayer )
	if getElementData( thePlayer, "loggedin" ) == 1 then
		dbExec(mysql:getConnection(), "UPDATE characters SET bankmoney=" .. ((tonumber(getElementData( thePlayer, "bankmoney" )) or 0)) .. " WHERE id=" .. (getElementData( thePlayer, "dbid" )))
	end
end