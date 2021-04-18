local mysql = exports.vrp_mysql
addEvent("phone:addContact", true)
function addPhoneContact(name, number, phoneBookPhone)
	if (client) then
		if not phoneBookPhone then
			triggerClientEvent(client, "phone:addContactResponse", client, false)
			return
		end
		
		if not exports.vrp_global:hasItem(client,2, tonumber(phoneBookPhone)) then
			triggerClientEvent(client, "phone:slidePhoneOut", client)
			return
		end
		
		if name and number then
			if tonumber(number) then
				local inserted = dbExec(mysql:getConnection(),"INSERT INTO `phone_contacts` (`phone`, `entryName`, `entryNumber`) VALUES ('" ..  (tostring(phoneBookPhone)).."', '".. (name) .."', '".. (number) .."')") 
				dbQuery(
					function(qh)
						local res, rows, err = dbPoll(qh, 0)
						if rows > 0 then
							triggerClientEvent(client, "phone:addContactResponse", client, res[1]["id"], name, number)
						end
					end,
				mysql:getConnection(), "SELECT id FROM phone_contacts WHERE id = LAST_INSERT_ID()")
			end
		end

		outputChatBox("Internal Error! Code: RFS45235, please report this on http://bugs.owlgaming.net.", client, 255,0,0)
		triggerClientEvent(client, "phone:addContactResponse", client, false)
	end
end
addEventHandler("phone:addContact", getRootElement(), addPhoneContact)