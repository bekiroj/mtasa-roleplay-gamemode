--MAXIME
addEvent("phone:requestShowPhoneGUI", true)
function requestPhoneGUI(itemValue, newSource)
    
end
addEventHandler("phone:requestShowPhoneGUI", getRootElement(), requestPhoneGUI)
--

function requestContacts(player, fromNumber)
    dbQuery(
        function(qh, player)
            local res, rows, err = dbPoll(qh, 0)
            local contacts = {}
            if rows > 0 then
                for index, row in ipairs(res) do
                     table.insert(contacts, row )
                end
                outputChatBox(toJSON({contacts}), player)
                   
            end
            triggerClientEvent(player, "phone:receiveContacts", player, contacts, 20)  
        end,
    {player}, mysql:getConnection(), "SELECT * from `phone_contacts` WHERE `phone`='".. ( fromNumber ) .."' ORDER BY `entryName` ")    
end
addEvent("phone:requestContacts", true)
addEventHandler("phone:requestContacts", root, requestContacts)

function forceUpdateContactList(player, fromPhone)
    if player then
        source = player
    end
     dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                local contacts, limit = {}, {}
                for index, row in ipairs(res) do
                    if not phoneSettings then
                        dbExec(mysql:getConnection(),"INSERT INTO `phones` (`phonenumber`) VALUES ('".. (fromPhone) .."')")
                        callerphoneIsSecretNumber = 0
                        callerphoneIsTurnedOn = 1
                        callerphoneRingTone = 1
                        callerphonePhoneBook = 1
                        callerphoneBoughtBy = -1
                    else
                        callerphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
                        callerphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
                        callerphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
                        callerphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
                        callerphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
                    end
                    dbQuery(
                        function(qh, source)
                            local res, rows, err = dbPoll(qh, 0)
                            if rows > 0 then
                                for index, row in ipairs(res) do
                                     table.insert(contacts, row )
                                end
                                dbQuery(
                                    function(qh, source)
                                        local res, rows, err = dbPoll(qh, 0)
                                        if rows > 0 then
                                            for index, row in ipairs(res) do
                                                limit = tonumber(row["contact_limit"])
                                            end
                                            triggerClientEvent(source, "phone:forceUpdateContactList", source, contacts, limit)
                                        end
                                    end,
                                {source}, mysql:getConnection(), "SELECT `contact_limit` FROM `phones` WHERE `phonenumber`='"..(fromPhone).."' LIMIT 1")
                            end
                        end,
                    {source}, mysql:getConnection(), "SELECT * from `phone_contacts` WHERE `phone`='".. ( fromPhone ) .."' ORDER BY `entryName` ")
                end
            end
        end,
    {source}, mysql:getConnection(), "SELECT * FROM `phones` WHERE `phonenumber`='"..(fromPhone).."' LIMIT 1")
end
addEvent("phone:forceUpdateContactList", true)
addEventHandler("phone:forceUpdateContactList", root, forceUpdateContactList)

--
addEvent("phone:deleteContact", true)
function deletePhoneContact(name, number, phoneBookPhone)
    if (client) then
        if not phoneBookPhone then
            return
        end
        
        if not exports.vrp_global:hasItem(client,2, tonumber(phoneBookPhone)) then
            return
        end
        if name and number then
            if tonumber(number) then
                local result = dbExec(mysql:getConnection(),"DELETE FROM `phone_contacts` WHERE `phone`='" ..  (phoneBookPhone).."' AND `entryName`='".. (name) .."' AND `entryNumber`='".. (number) .."'")
                if result then
                    requestPhoneGUI(phoneBookPhone, client)
                    return
                end
            end
        end
        outputChatBox("Error, please try it again.", client, 255,0,0)
    end
end
addEventHandler("phone:deleteContact", getRootElement(), deletePhoneContact)

function saveCurrentRingtone(itemValue, phoneBookPhone)
    if client and itemValue then
        if not phoneBookPhone then
            outputChatBox("one")
            return
        end
        
        if not exports.vrp_global:hasItem(client,2, tonumber(phoneBookPhone)) then
            --outputCh
            atBox("two")
            return
        end
        
        if not tonumber(itemValue) then
            outputChatBox("three")
            return
        end

        local result = dbExec(mysql:getConnection(),"UPDATE `phones` SET `ringtone`='" ..  (itemValue).."' WHERE `phonenumber`='"..(phoneBookPhone).."'")
        if not result then
            outputChatBox("Error, please try it again.", client, 255,0,0)
            return
        end
    end
end
addEvent("saveRingtone", true)
addEventHandler("saveRingtone", getRootElement(), saveCurrentRingtone)