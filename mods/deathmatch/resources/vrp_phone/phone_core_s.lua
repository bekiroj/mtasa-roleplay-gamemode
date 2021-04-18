--MAXIME

mysql = exports.vrp_mysql
local phoneO = { }

MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
    if string.len(text) > 128 then -- MTA Chatbox size limit
        MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
        outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
    else
        MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
    end
end

function initiatePhoneGUI(phone, popOutOnPhoneCall)
    if not phone or not tonumber(phone) or string.len(phone) < 5 then
        triggerClientEvent(source, "phone:slidePhoneOut", source)
        return false
    end
    if popOutOnPhoneCall then
        if tonumber(popOutOnPhoneCall) then
            popOutOnPhoneCall = tonumber(popOutOnPhoneCall)
        else
            popOutOnPhoneCall = "popOutOnPhoneCall"
        end
    end
    dbQuery(
        function(qh, source)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, phoneSettings in ipairs(res) do
                    callerphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
                    callerphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
                    callerphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
                    callerphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
                    callerphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
                    callerphoneBoughtByName = phoneSettings["charactername"] or "Unknown"
                    callerphoneBoughtDate = phoneSettings["bought_date"] or "Unknown"
                    sms_tone = tonumber(phoneSettings["sms_tone"]) or 1
                    keypress_tone = tonumber(phoneSettings["keypress_tone"]) or 1
                    tone_volume = tonumber(phoneSettings['tone_volume']) or 10
                end
                triggerClientEvent(source, "phone:updatePhoneGUI", source, popOutOnPhoneCall or "initiate", {phone, callerphoneIsTurnedOn, callerphoneRingTone, callerphoneIsSecretNumber, callerphonePhoneBook, callerphoneBoughtById, callerphoneBoughtByName, callerphoneBoughtDate, sms_tone, keypress_tone, tone_volume})
                triggerEvent("phone:applyPhone", source, "phone_in")
            end
        end,
    {source}, mysql:getConnection(), "SELECT *, `charactername`, DATE_FORMAT(`bought_date`,'%b %d %Y %h:%i %p') AS `bought_date` FROM `phones` LEFT JOIN `characters` ON `phones`.`boughtby` = `characters`.`id` WHERE `phonenumber`='"..(tostring(phone)).."' LIMIT 1")
    
    return true
end
addEvent("phone:initiatePhoneGUI", true)
addEventHandler("phone:initiatePhoneGUI", root, initiatePhoneGUI)

local connection = exports["vrp_mysql"]:getConnection()
addEventHandler("onResourceStart", root, 
    function(startedRes)
        if getResourceName(startedRes) == "vrp_mysql" then
            connection = exports["vrp_mysql"]:getConnection()
            restartResource(getThisResource())
        end
    end
)
addEvent("receivePhoneSetupCache", true)
addEventHandler("receivePhoneSetupCache", root,
    function(player, phoneNumber, alwaysGoesHome)
        if not alwaysGoesHome then
            alwaysGoesHome = false
        end
        dbQuery(
            function(queryHandler, player, phoneNumber, alwaysGoesHome)
                local result, rows, err = dbPoll(queryHandler, 0)
                if rows > 0 then
                    for index, value in ipairs(result) do
                        setupCache = value["phoneSetup"]
                        setupPassword = value["phonePassword"]
                        state = value["phonePasswordActive"]
                        triggerClientEvent(player, "phone:createSetup", player, setupCache, setupPassword, state, alwaysGoesHome)
                    end
                else
                    triggerClientEvent(player, "phone:createSetup", player, 2, "", false, alwaysGoesHome)
                end
            end,
        {player, phoneNumber, alwaysGoesHome}, connection, "SELECT * FROM phones WHERE phonenumber=?", phoneNumber)
    end
)

addEvent("updatePhonePassTable", true)
addEventHandler("updatePhonePassTable", root,
    function(player, state, number)
        if state == true then
            state = 1
        else
            state = 0
        end
        dbExec(connection, "UPDATE phones SET phonePasswordActive=? WHERE phonenumber=?",state,number)
    end
)

addCommandHandler("telefonsifrem",
    function(player, cmd, phoneNumber)
        if getElementData(player, "loggedin") == 1 then
            
        end
    end
)

addEvent("receiveWhatsappTable", true)
addEventHandler("receiveWhatsappTable", root, -- from GÖNDEREN to ALAN
    function(player,phonenumber)
        query = dbQuery(connection, "SELECT * FROM phone_sms", phonenumber)
        pollHash = dbPoll(query, -1)


        local messagesTable = {}
        if #pollHash > 0 then
            for k,v in ipairs(pollHash) do
                if v["to"] == phonenumber and v["isWhatsapp"] == 1 then
                    dquery = dbQuery(connection, "SELECT * FROM phone_contacts WHERE entryNumber=?", v["from"])
                    contactName = dbPoll(dquery, -1)
                    if #contactName > 0 then
                        for _, i in ipairs(contactName) do
                            name = i["entryName"]
                        end
                        dbFree(dquery)
                    else
                        name = v["from"]
                    end

                    messagesTable[#messagesTable + 1] = {name, v["content"]}
                end
            end
            dbFree(query)
        end
        triggerClientEvent(player, "exportWhatsappTable", player, messagesTable)
    end
)


addEvent("completePhoneSetup", true)
addEventHandler("completePhoneSetup", root,
    function(player, phoneNumber, phonePassword)
        exec = dbExec(connection, "UPDATE phones SET phoneSetup=?, phonePassword=? where phonenumber=?",2,phonePassword, phoneNumber)
        if exec then
            outputChatBox("[!]#ffffff Telefon kurulumu tamamlandı, şifreniz: "..phonePassword,player,0,255,0,true)
            triggerClientEvent(player, "phone:completeSetup", player)
            --dbFree(exec)
        end
    end
)

addEvent("logIn:lsbank",true)
addEventHandler("logIn:lsbank", root,
    function(player,cardnumber,cardpassword)
        query = dbQuery(connection, "SELECT * FROM atm_cards WHERE card_number=?",cardnumber)
        poll = dbPoll(query,-1)
        if #poll > 0 then
            for k,v in ipairs(poll) do
                if v["card_pin"] == cardpassword then
                    triggerClientEvent(player, "logging:lsBank", player)
                else
                    outputChatBox("[!]#ffffff Yanlış kart şifresi girdiniz. ( Eğer ilk defa aldıysanız şifre 0000'dır. )",player,255,0,0,true)
                end
            end
        else
            outputChatBox("[!]#ffffff Kart numarası bulunamadı.",player,255,0,0,true)
        end
        dbFree(query)
    end
)


function powerOn(phone, state)
    if not phone or not tonumber(phone) or string.len(phone) < 5 then
        triggerClientEvent(source, "phone:powerOn:response", source, false, state)
        return false
    end
    return triggerClientEvent(source, "phone:powerOn:response", source, dbExec(mysql:getConnection(), "UPDATE `phones` SET `turnedon`='"..state.."' WHERE `phonenumber`='"..(tostring(phone)).."'"), state)
end
addEvent("phone:powerOn", true)
addEventHandler("phone:powerOn", root, powerOn)

function applyPhone(string, popOutOnPhoneCall)
    if not canPlayerCall(source) and string ~= "phone_out" then
        --return false
    end

    local phonestate = getElementData(source, "phonestate") or 0
    outputDebugString("[Phone] applyPhone / phonestate = "..phonestate.. " / action = "..string)

    items = exports["vrp_items"]:getItems(source)
    phoneName = "iPhone 7s"
    for index, row in ipairs(items) do
        if row[1] == 2 then
            phoneName = exports["vrp_items"]:getItemName(2, row[2], row[5])
        end
    end
    if phoneName == "Cellphone" then phoneName = "iPhone 7s" end
    if string == "phone_in" then
        triggerEvent('sendAme', source, phoneName.."'i eline alır.")
        if getElementData(source, "phone_anim") ~= "0" then
            if not isElement(phoneO[source]) then
                phoneO[source] = createObject(330, 0, 0, 0)
            end
            setElementDimension(phoneO[source], getElementDimension(source))
            setElementInterior(phoneO[source], getElementInterior(source))
            exports.vrp_bone_attach:attachElementToBone(phoneO[source], source, 12, -0.05, 0.02, 0.02, 20, -90, -10)
            
        
            triggerClientEvent(source,"replacePhoneAnimation",source, source,true)
                

        else
            if isElement(phoneO[source]) then
                destroyPhone(source)
            end
            
        end
        if getElementData(source, "cellphoneGUIStateSynced") ~= 1 then
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
        end
        exports.vrp_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
    elseif string == "phone_talk" then
        if getElementData(source, "phone_anim") ~= "0" then
            if not isElement(phoneO[source]) then
                phoneO[source] = createObject(330, 0, 0, 0)
            end
            setElementDimension(phoneO[source], getElementDimension(source))
            setElementInterior(phoneO[source], getElementInterior(source))
            exports.vrp_bone_attach:attachElementToBone(phoneO[element], source, 12, -0.03, 0.02, 0.02, 20, -90, -10)
            setPedAnimation(source, "ped", string, 1, false)
        else
            if isElement(phoneO[source]) then
                destroyPhone(source)
            end
        end
        if getElementData(source, "cellphoneGUIStateSynced") ~= 1 then
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", 1 , true)
        end
    elseif string == "phone_out" then
        --outputDebugString("[Phone] "..getPlayerName(source).." / phone_out")
        if phonestate > 0 and not popOutOnPhoneCall then
            triggerEvent("phone:cancelPhoneCall", source)
        end
        --resetPhoneState(source)
        if getElementData(source, "cellphoneGUIStateSynced") then
            if not popOutOnPhoneCall then

                triggerEvent('sendAme', source, phoneName.."'i elinden bırakır.")
            end
            if getElementData(source, "phone_anim") ~= "0" then
                setPedAnimation(source, "ped", string, 1, false)
            end
        end
        exports.vrp_anticheat:changeProtectedElementDataEx(source, "cellphoneGUIStateSynced", nil , true)
        if isElement(phoneO[source]) then
            setTimer(destroyPhone, 2000, 1, source)
        
        end

    end
end
addEvent("phone:applyPhone", true)
addEventHandler("phone:applyPhone", root, applyPhone)

function destroyPhone(element)
    if canPlayerCall(element) then
        exports.vrp_global:removeAnimation(element) 
    end
    if isElement(phoneO[element]) then
        exports.vrp_bone_attach:detachElementFromBone(phoneO[element])
        destroyElement(phoneO[element]) 
        phoneO[element] = nil
    end
end

function callSomeone(thePlayer, commandName, phoneNumber, withNumber)
    local logged = getElementData(thePlayer, "loggedin")
    if not withNumber then
        withNumber = false
    else
        withNumber = tonumber(withNumber)
    end
    
    local outboundPhoneNumber = -1
    if (logged==1) then
        local publicphone = nil
        for k, v in pairs( getElementsByType( "colshape", getResourceRootElement( ) ) ) do
            if isElementWithinColShape( thePlayer, v ) then
                for kx, vx in pairs( getElementsByType( "player" ) ) do
                    if getElementData( vx, "call.col" ) == v then
                        outputChatBox( "Someone else is already using this phone.", thePlayer, 255, 0, 0 )
                        return
                    end
                end
                publicphone = v
                break
            end
        end
        if getElementData(thePlayer, "tlfkulubesi") then
            publicphone = getElementData(thePlayer, "tlfkulubesi")
        end
        
        
        if publicphone or exports.vrp_global:hasItem(thePlayer, 2) then
            -- Determine the outbound number, -1 is secret
            if publicphone then
                outboundPhoneNumber = math.random(51111510, 58111510)
            elseif withNumber and withNumber > 10 then
                if exports.vrp_global:hasItem(thePlayer, 2, tonumber(withNumber))  then
                    outboundPhoneNumber = tonumber(withNumber)
                else
                    local fPhone = getElementData(thePlayer, "factionphone")
                    local factionPhone = getElementData(getPlayerTeam(thePlayer), "phone")
                    local ignore = false
                    if fPhone and factionPhone then
                        num = string.format("%02d%02d", factionPhone, fPhone)

                        if tostring(withNumber) == num then
                            ignore = true
                            outboundPhoneNumber = tonumber(withNumber)
                        end
                    end

                    if not ignore then
                        outputDebugString(getPlayerName(thePlayer).." tried to call with a phone he doesn't have?")
                        return
                    end
                end
            end
            
            if not publicphone and not outboundPhoneNumber or outboundPhoneNumber == -1 then
                outputChatBox("Error: please report on F2.", thePlayer, 255, 0, 0)
                return
            end
            
            if not (phoneNumber) then
                outputChatBox("Press 'i' and click the phone you want to use, please.", thePlayer)
                return
                --requestPhoneGUI(1, thePlayer)
            end

            if not tonumber(phoneNumber) then
                outputChatBox("Couldn't find a number/number for the contact name specified.", thePlayer, 255, 0, 0)
                return
            end

            if not tonumber(phoneNumber) then
                outputChatBox("Invalid phonenumber.", thePlayer)
                return
            end
            local realOutboundPhoneNumber = tonumber(outboundPhoneNumber)
            
            local callerphoneIsSecretNumber = 1
            local callerphoneIsTurnedOn = 1
            local callerphoneRingTone = 1
            local callerphonePhoneBook = 1
            local callerphoneBoughtBy = -1
                    
            if not publicphone then
                local testNumber = tostring(realOutboundPhoneNumber)
                if #testNumber == 4 then
                    testNumber = fetchFirstPhoneNumber(thePlayer)
                end
                callerphoneIsSecretNumber = 0
                callerphoneIsTurnedOn = 1
                callerphoneRingTone = 1
                callerphonePhoneBook = 1
                callerphoneBoughtBy = -1
            end
            
            
            
            if callerphoneIsTurnedOn == 0 then
                outputChatBox("Your phone is off.", thePlayer, 255, 0, 0)
            else
                local calling = getElementData(thePlayer, "calling")
                
                if (calling) then -- Using phone already
                    outputChatBox("You are already using a phone.", thePlayer, 255, 0, 0)
                elseif getElementData(thePlayer, "injuriedanimation") then
                    outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
                else
                    -- /me it
                    if publicphone then
                        triggerEvent('sendAme', thePlayer, " telefona ulaşıyor.")
                    else
                        --triggerEvent('sendAme', thePlayer, "takes out a cell phone.")
                    end
                    
                    -- If the number is a hotline aka automated machine, then..
                    if isNumberAHotline(phoneNumber) then
                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "phonestate", 1, false)
                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "calling", phoneNumber, false)
                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "callingwith", outboundPhoneNumber, false)    
                        routeHotlineCall(thePlayer, tonumber(phoneNumber), tonumber(outboundPhoneNumber), true, "")     
                                
                        --applyPhone(thePlayer, 1, "phone_talk")
                    
                    -- Otherwise find a fool to answer it
                    else
                        -- Search for the phone
                        local found, foundElement = searchForPhone(phoneNumber)
                        
                        -- Some basic checks.
                        -- Can we afford it?
                        local bankMoney = getElementData(thePlayer, "bankmoney") -- done by Anthony to take money from bank instead
                        if bankMoney >= 1 then
                            if not exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "bankmoney", tonumber(bankMoney) - 1, false) then
                                outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
                                return
                            end
                        else
                            outputChatBox("You cannot afford a call.", thePlayer, 255, 0, 0)
                            return
                        end
                        
                        -- Yes, Is the target phone online or found at all?
                        if not found then
                            outputChatBox("You get a dead tone...", thePlayer, 255, 194, 14)
                            return
                        end
                        
                        -- Fetch some details
                        local calledphoneIsSecretNumber = 1
                        local calledphoneIsTurnedOn = 1
                        local calledphoneRingTone = 1
                        local calledphonePhoneBook = 1
                        local calledphoneBoughtBy = -1

                        local testNumber = phoneNumber
                        if #testNumber == 4 then
                            testNumber = fetchFirstPhoneNumber(foundElement)
                        end

                        dbQuery(
                            function(qh, thePlayer)
                                local res, rows, err = dbPoll(qh, 0)
                                if rows > 0 then
                                    for index, phoneSettings in ipairs(res) do
                                        if not phoneSettings then
                                            dbExec(mysql:getConnection(), "INSERT INTO `phones` (`phonenumber`) VALUES ('".. (tostring(testNumber)) .."')")
                                            calledphoneIsSecretNumber = 0
                                            calledphoneIsTurnedOn = 1
                                            calledphoneRingTone = 1
                                            calledphonePhoneBook = 1
                                            calledphoneBoughtBy = -1
                                        else
                                            calledphoneIsSecretNumber = tonumber(phoneSettings["secretnumber"]) or 0
                                            calledphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 1
                                            calledphoneRingTone =  tonumber(phoneSettings["ringtone"]) or 1
                                            calledphonePhoneBook =  tonumber(phoneSettings["phonebook"]) or 1
                                            calledphoneBoughtBy =  tonumber(phoneSettings["boughtby"]) or -1
                                        end
                                        
                                        -- Yes, It is perchance off?
                                        if calledphoneIsTurnedOn == 0 then
                                            outputChatBox("The phone you are trying to call is switched off.", thePlayer, 255, 194, 14)
                                            return
                                        end
                                        
                                        -- No, Is the player already calling?
                                        if getElementData(foundElement, "calling") or foundElement == thePlayer then
                                            outputChatBox("You get a busy tone.", thePlayer)
                                            return
                                        end
                                        
                                        -- Note down some needed details.
                                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.col", publicphone, false)
                                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "calling", tonumber(phoneNumber), false)
                                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "called", true, false)
                                        exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "callingwith", outboundPhoneNumber, false)
                                        exports.vrp_anticheat:changeProtectedElementDataEx(foundElement, "calling", tonumber(outboundPhoneNumber), false)
                                        exports.vrp_anticheat:changeProtectedElementDataEx(foundElement, "called", nil, false)
                                        
                                        --applyPhone(thePlayer, 1, "phone_in")
                                        
                                                                            
                                        local reconning = getElementData(foundElement, "reconx")
                                        if not reconning then 
                                            if calledphoneRingTone ~= 0 then
                                                for _,nearbyPlayer in ipairs(exports.vrp_global:getNearbyElements(foundElement, "player"), 10) do
                                                    triggerClientEvent(nearbyPlayer, "startRinging", foundElement, 1, calledphoneRingTone)
                                                end
                                            end
                                            triggerEvent('sendAme', foundElement, "' telefonu çalmaya başlar.")
                                        end
                                        
                                        local display = "Unknown Number"
                                        if (callerphoneIsSecretNumber == 1) or publicphone then
                                            display = "Unknown Number"
                                            outputChatBox("Your phone #"..tostring(phoneNumber).." is ringing. The display shows '".. display .."' (( /pickup to answer ))", foundElement, 255, 194, 14)
                                        else
                                            dbQuery(
                                                function(qh, thePlayer)
                                                    local res, rows, err = dbPoll(qh, 0)
                                                    if rows > 0 then
                                                        for index, row in ipairs(res) do
                                                            display =  row["entryName"] .." (#".. outboundPhoneNumber .. ")"
                                                        end
                                                        outputChatBox("Your phone #"..tostring(phoneNumber).." is ringing. The display shows '".. display .."' (( /pickup to answer ))", foundElement, 255, 194, 14)
                                                    end
                                                end,
                                            {thePlayer}, mysql:getConnection(), "SELECT `entryName` FROM `phone_contacts` WHERE `phone`='".. (phoneNumber) .."' AND `entryNumber`='".. (outboundPhoneNumber ).."' LIMIT 1")
                                        end
                                        
                                        -- Give the target 30 seconds to answer the call
                                        setTimer(cancelCall, 30000, 1, { tonumber(phoneNumber), tonumber(outboundPhoneNumber) } )
                                    end
                                end
                            end,
                        {thePlayer}, mysql:getConnection(), "SELECT * FROM `phones` WHERE `phonenumber`='"..(tostring(testNumber)).."'")
                        
                        
                    end
                end
            end
        else
            outputChatBox("Believe it or not, it's hard to dial on a cellphone you do not have.", thePlayer, 255, 0, 0)
        end
    end
end
addEvent("remoteCall", true)
addEventHandler("remoteCall", getRootElement(), callSomeone)

function makeFCall(thePlayer, commandName, phoneNumber)
    local fPhone = getElementData(thePlayer, "factionphone")
    local factionPhone = getElementData(getPlayerTeam(thePlayer), "phone")
    if fPhone and factionPhone then
        num = string.format("%02d%02d", factionPhone, fPhone)
        if not (phoneNumber) then
            outputChatBox("SYNTAX /" .. commandName .. " [Phone Number]", thePlayer, 255, 194, 14)
        else
            local hasCellphone, itemKey, itemValue, itemID = exports.vrp_global:hasItem(thePlayer, 2)
            if itemValue then
                callSomeone(thePlayer, commandName, phoneNumber, num)
            end
        end
    end
end
addCommandHandler("fcall", makeFCall)

function cancelCall(phoneNumbers)
    for _, phoneNumber in ipairs(phoneNumbers) do
        local found, foundElement = searchForPhone(phoneNumber)
        if found and foundElement and isElement(foundElement) then
            local phoneState = getElementData(foundElement, "phonestate")
            
            if (phoneState==0) then
                exports.vrp_anticheat:changeProtectedElementDataEx(foundElement, "calling", nil, false)
                exports.vrp_anticheat:changeProtectedElementDataEx(foundElement, "called", nil, false)
                exports.vrp_anticheat:changeProtectedElementDataEx(foundElement, "call.col", nil, false)
            end
        end
    end
end

addEventHandler("savePlayer", root,
    function(reason)
        if reason == "Change Character" then
            triggerEvent("phone:cancelPhoneCall", source)
        end
    end)


addEventHandler( "onColShapeLeave", getResourceRootElement(),
    function( thePlayer )
        if getElementData( thePlayer, "call.col" ) == source then
            executeCommandHandler( "hangup", thePlayer )
        end
    end
)
addEventHandler( "onPlayerQuit", getRootElement(),
    function( )
        local calling = getElementData( source, "calling" )
        if isElement( calling ) then
            executeCommandHandler( "hangup", source )
        end
    end
)


function phoneBook(thePlayer, commandName, partialNick)
    local logged = getElementData(thePlayer, "loggedin")
    
    if (logged==1) then
        if (exports.vrp_global:hasItem(thePlayer, 7)) then
            if not (partialNick) then
                outputChatBox("SYNTAX: /phonebook [Partial Subscriber Name / Number]", thePlayer, 255, 194, 14)
            else
                triggerEvent('sendAme', thePlayer, "telefon rehberine bakar.")
                dbQuery(
                    function(qh, thePlayer)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            for index, row in ipairs(res) do
                                local phoneNumber = tonumber(row["phonenumber"])
                                local username = tostring(row["charactername"]):gsub("_", " ")
                        
                                outputChatBox(username .. " - #" .. phoneNumber .. ".", thePlayer)
                            end
                        end
                    end,
                {thePlayer}, mysql:getConnection(), "SELECT `charactername`, `phonenumber` FROM `phones` LEFT JOIN `characters` ON `phones`.`boughtby`=`characters`.`id` WHERE `phonebook`=1 AND (`charactername` LIKE '%" .. (partialNick) .. "%' OR `phonenumber` LIKE '%" .. (partialNick) .. "%') AND `secretnumber` = 0 LIMIT 20")
            end
        else
            outputChatBox("Believe it or not, it's hard to use a phonebook you do not have.", thePlayer, 255, 0, 0)
        end
    end
end
addCommandHandler("phonebook", phoneBook)

function sendSMS(thePlayer, commandName, sourcePhone, number, ...)
   -- Militan tarafından yakında tekrardan yazılacak. 05/05/19
end


function togglePhone(thePlayer, commandName, phoneNumber)
    local logged = getElementData(thePlayer, "loggedin")
    
    if logged == 1 then
        if not phoneNumber then
            local foundPhone,_,foundPhoneNumber = exports.vrp_global:hasItem(thePlayer, 2)
            if foundPhone and foundPhoneNumber then
                phoneNumber = foundPhoneNumber
            end
        elseif tonumber(phoneNumber) < 10 then
            local count = 0
            local items = exports['vrp_items']:getItems(thePlayer)
            for k, v in ipairs(items) do
                if v[1] == 2 then
                    count = count + 1
                    if count == phoneNumber then
                        phoneNumber = v[2]
                        break
                    end
                end
            end
        else
            if not (exports.vrp_global:hasItem(thePlayer, 2, tonumber(phoneNumber))) then
                outputChatBox("Bu telefon numarasına sahip değilsin.", thePlayer, 255, 0, 0)
                return
            end
        end
        local calledphoneIsTurnedOn = 0
        dbQuery(
            function(qh, thePlayer)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, phoneSettings in ipairs(res) do
                        if not phoneSettings then
                            dbExec(mysql:getConnection(), "INSERT INTO `phones` (`phonenumber`) VALUES ('".. (tostring(phoneNumber)) .."')")
                        else
                            calledphoneIsTurnedOn = tonumber(phoneSettings["turnedon"]) or 0
                        end
                        if getElementData( thePlayer, "calling" ) then
                            outputChatBox("Telefonunu kullanıyorsun!", thePlayer, 255, 0, 0)
                        else
                            if calledphoneIsTurnedOn == 0 then
                                outputChatBox("Telefonunu numara ile değiştirdin '"..tostring(phoneNumber).."' .", thePlayer, 0, 255, 0)
                            else
                                outputChatBox("Telefonunu numara ile değiştirdin '"..tostring(phoneNumber).."' .", thePlayer, 255, 0, 0)
                            end
                            dbExec(mysql:getConnection(),  "UPDATE `phones` SET `turnedon`='"..( 1 - calledphoneIsTurnedOn ) .."' WHERE `phonenumber`='".. (tostring(phoneNumber)) .."'")
                        end
                    end
                end
            end,
        {thePlayer}, mysql:getConnection(), "SELECT * FROM `phones` WHERE `phonenumber`='"..(tostring(phoneNumber)).."'")
    end
end
addCommandHandler("togglephone", togglePhone)

function setPhoneBook(thePlayer, commandName, phoneNumber, ...)
    local logged = getElementData(thePlayer, "loggedin")
    
    if logged == 1 then
        if not phoneNumber then
            outputChatBox("Usage: /" .. commandName .. " [phone no.] [text to be found under via /phonebook]", thePlayer, 255, 194, 14)
            return
        end
        
        if tonumber(phoneNumber) < 10 then
            local count = 0
            local items = exports['vrp_items']:getItems(thePlayer)
            for k, v in ipairs(items) do
                if v[1] == 2 then
                    count = count + 1
                    if count == phoneNumber then
                        phoneNumber = v[2]
                        break
                    end
                end
            end
        else
            if not (exports.vrp_global:hasItem(thePlayer, 2, tonumber(phoneNumber))) then
                outputChatBox("Bu telefon numarasına sahip değilsin", thePlayer, 255, 0, 0)
                return
            end
        end
        local name = table.concat({...}, " ") or nil
        dbQuery(
            function(qh, thePlayer)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                   
                    local success = false
                    if name then
                        name = name:sub(1, 40)
                        success = dbExec(mysql:getConnection(),  "UPDATE `phones` SET `phonebook`='"..(name) .."' WHERE `phonenumber`='".. (tostring(phoneNumber)) .."'")
                        outputChatBox("Telefon rehberi girişinizi '" .. name .. "'.", thePlayer, 0, 255, 0)
                    else
                        success = dbExec(mysql:getConnection(),  "UPDATE `phones` SET `phonebook`=NULL WHERE `phonenumber`='".. (tostring(phoneNumber)) .."'")
                        outputChatBox("Telefon defteri girişinizi kaldırdınız.", thePlayer, 0, 255, 0)
                    end
                else
                    dbExec(mysql:getConnection(), "INSERT INTO `phones` (`phonenumber`) VALUES ('".. (tostring(phoneNumber)) .."')")
                end
            end,
        {thePlayer}, mysql:getConnection(), "SELECT * FROM `phones` WHERE `phonenumber`='"..(tostring(phoneNumber)).."'")        
    end
end
addCommandHandler("setphonebook", setPhoneBook)
addCommandHandler("setphonebookname", setPhoneBook)
addCommandHandler("setpbname", setPhoneBook)

function searchForPhone(phoneNumber)
    phoneNumber = tonumber(phoneNumber)
    if phoneNumber then
        for key, value in ipairs(getElementsByType("player")) do
            local logged = getElementData(value, "loggedin")
            if (tonumber(logged)==1) then
                if phoneNumber >= 10000 then                 
                    local foundPhone,_,foundPhoneNumber = exports.vrp_global:hasItem(value, 2, tonumber(phoneNumber))
                    if foundPhone then
                        return true, value
                    end
                elseif phoneNumber >= 1000 and exports.vrp_global:hasItem(value, 2) then -- 4 digit number for factions (2 digits for faction, 2 digits for specific player)
                    local fPhone = getElementData(value, "factionphone")
                    local factionPhone = getElementData(getPlayerTeam(value), "phone")
                    if fPhone and factionPhone then
                        num = string.format("%02d%02d", factionPhone, fPhone)
                        if tostring(phoneNumber) == num then
                            return true, value
                        end
                    end
                end
            end
        end
    end
    return false, nil
end

function fetchFirstPhoneNumber(target)
    local foundPhone,_,foundPhoneNumber = exports.vrp_global:hasItem(target, 2, tonumber(phoneNumber))
    return foundPhoneNumber
end

function setEDX(thePlayer, index, newvalue, sync, nosyncatall)
    return exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, index, newvalue, sync, nosyncatall)
end

function cleanUp()
    for i, player in pairs(getElementsByType("player")) do
        cleanUpOnePlayer(player)
    end
end
addEventHandler("onResourceStop", resourceRoot, cleanUp)

function cleanUpOnePlayer(player)
    --if source then player = source end
    resetPhoneState(player)
    exports.vrp_anticheat:changeProtectedElementDataEx(player, "cellphoneGUIStateSynced", nil, true)
end
--addEventHandler("accounts:characters:change", root, cleanUpOnePlayer)


addEvent("phone:konumAt",true)
addEventHandler("phone:konumAt",root,function(player,bendekiNo,gidenNo,text,state)

    --triggerEvent("phone:sendSMS", player, bendekiNo, gidenNo, "(Haritada blip işareti ve marker işaretlendi)", true)

    x,y,z = getElementPosition(player)
    otherPlayer = findToNumber(player,gidenNo)

    
    
    if getElementData(player,"konum->attigiKisi") == otherPlayer then
        outputChatBox("Zaten bu kullanıcıya konum atmışsın, işlemin devamı gerçekleşmeyecek!",player,255,0,0)
        return
    end
    triggerEvent("phone:sendSMS", player, bendekiNo, gidenNo, text, true)
    setElementData(player,"konum->attigiKisi",otherPlayer)
    if otherPlayer then
        --p,x,y,z
        triggerClientEvent(otherPlayer,"konum:markerAc",otherPlayer,player,otherPlayer,x,y,z)
    end
end)


function findToNumber(player,number)
    found = 0
    for k,v in ipairs(getElementsByType("player")) do
        if getElementData(v,"loggedin") == 1 then
            if exports["vrp_global"]:hasItem(v,2,number) then
                found = found + 1
                if found == 1 then
                    outputChatBox("[!]#ffffff "..getPlayerName(player):gsub("_", " ").." adlı kullanıcı sana konum yolladı!",v,0,255,0,true)
                    outputChatBox("[!]#ffffff SMS ile konum gönderildi, gitmek istediğin alan blip ile işaretlenecek.",v,0,255,0,true)
                    return v
                else
                    outputChatBox("[!]#ffffff Konum atmak istediğiniz oyuncu oyunda olmadığı için yalnızca SMS gönderildi!",player,255,0,0,true)
                    return false
                end
            end
        end
    end
end