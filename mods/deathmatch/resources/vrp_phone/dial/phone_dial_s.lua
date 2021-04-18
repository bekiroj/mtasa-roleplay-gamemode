local dialingTimers = {}
local tmpElement = {}
function startDialing(to, from)
    if not canPlayerCall(source) then
        outputChatBox("You can not use cellphone at the moment.", source, 255,0,0)
        triggerClientEvent(source, "phone:slidePhoneOut", source)
        return false
    end

    setEDX(source, "phonestate", 1, false) -- caller, started dialing
    setEDX(source, "callingwith", tonumber(from), false)
    local delay = math.random(3000, 5000)
    if not dialingTimers[tonumber(from)] then 
        dialingTimers[tonumber(from)] = {}
    end
    local hotlineName = isNumberAHotline(tonumber(to))
    local contact = {}
    if hotlineName then
        contact = { ["entryNumber"] = to,  ["entryName"] = hotlineName }        
        triggerClientEvent(source, "phone:updateDialingScreen", source, "start_dialing_tone", contact, true)
        setEDX(source, "phonestate", 2, false)
        killDialingTimers(from)
        local timer1 = setTimer(setEDX, delay, 1, source, "calling", tonumber(contact.entryNumber), false)
        local timer2 = setTimer(setEDX, delay, 1, source, "phonestate", 4, false)
        local timer3 = setTimer(routeHotlineCall, delay, 1, source, tonumber(contact.entryNumber), tonumber(from), true, "")
        local timer4 = setTimer(triggerClientEvent, delay, 1, source, "phone:updateDialingScreen", source, "connected", contact)
        local timer5 = setTimer(writeCellphoneLog, delay+50, 1, source, nil, "Calls", nil, true )
        table.insert(dialingTimers[tonumber(from)], timer1)
        table.insert(dialingTimers[tonumber(from)], timer2)
        table.insert(dialingTimers[tonumber(from)], timer3)
        table.insert(dialingTimers[tonumber(from)], timer4)
        table.insert(dialingTimers[tonumber(from)], timer5)
        --addPhoneHistory(from, to, 1, isSecret)
        
        return true
    end

    local contact = getPhoneContact(to, from)
    if not contact then
        if not tonumber(to) then
            triggerClientEvent(source, "phone:updateDialingScreen", source, "start_invalid_or_busy_tone" , "not_existed")
            local timer1 = setTimer(triggerEvent,delay, 1, "phone:cancelPhoneCall", source, "not_existed")
            table.insert(dialingTimers[tonumber(from)], timer1)
            return false
        end
        contact = { ["entryNumber"] = to }
    end

    exports.vrp_anticheat:changeProtectedElementDataEx(source, "callingContact", contact, false)
    
   		local isSecret = 0
        local foundInGame, targetPlayer = searchForPhone(contact.entryNumber)

        if not foundInGame then
            triggerClientEvent(source, "phone:updateDialingScreen", source, "start_invalid_or_busy_tone", "out_of_service")
            local timer1 = setTimer(triggerEvent,delay, 1, "phone:cancelPhoneCall", source, "out_of_service")
            table.insert(dialingTimers[tonumber(from)], timer1)
            --addPhoneHistory(from, contact.entryNumber, 2, isSecret)
            return false
        else
            if not dialingTimers[tonumber(contact.entryNumber)] then
                dialingTimers[tonumber(contact.entryNumber)] = {}
            end
            if not canPlayerPhoneRing(targetPlayer) then
                triggerClientEvent(source, "phone:updateDialingScreen", source, "start_invalid_or_busy_tone", "out_of_service")
                local timer1 = setTimer(triggerEvent,delay, 1, "phone:cancelPhoneCall", source, "out_of_service")
                table.insert(dialingTimers[tonumber(from)], timer1)
                --addPhoneHistory(from, contact.entryNumber, 2, isSecret)
                return false
            end
            --addPhoneHistory(from, contact.entryNumber, 1, isSecret)
            -- make sure the target phone is slided out before ringing him.
            if getElementData(targetPlayer, "cellphoneGUIStateSynced") then
                triggerEvent("phone:applyPhone", targetPlayer, "phone_out") 
                triggerClientEvent(targetPlayer, "phone:slidePhoneOut", targetPlayer, true)
            end

            -- Note down some needed details.
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "call.col", publicphone, false)
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "calling", tonumber(contact.entryNumber), false)
            exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "calling", tonumber(from), false)
            exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "callingwith", tonumber(contact.entryNumber), false)
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "called", false, false)
            exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "called", true, false)
            exports.vrp_anticheat:changeProtectedElementDataEx(source, "phonestate", 2, false)
            exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "phonestate", 3, false)

            killDialingTimers(from)
            triggerClientEvent(source, "phone:updateDialingScreen", source, "start_dialing_tone", contact)
            --Start ringing the phone.
            if t_ringtone > 1 and tone_volume > 0 then
                for _,nearbyPlayer in ipairs(exports.vrp_global:getNearbyElements(targetPlayer, "player"), 10) do
                    triggerClientEvent(nearbyPlayer, "startRinging", targetPlayer, 1, t_ringtone, tone_volume)
                end
                --outputChatBox(contact.entryNumber)
                triggerClientEvent(targetPlayer, "phone:startRingingOwner", targetPlayer, contact.entryNumber, canPlayerAnswerCall(targetPlayer), isSecret == 1 and "Private" or from)
                if t_ringtone > 2 then 
                    triggerEvent('sendAme', targetPlayer, "' cep telefonu çalmaya başlar.")
                end
            end
            
            
            local timer7 = setTimer(triggerEvent, 15000, 1, "phone:cancelPhoneCall", source) --Timer to make sure ringing will be killed at all the exceptional cases server sided
            local timer8 = setTimer(triggerEvent, 15000, 1, "phone:cancelPhoneCall", targetPlayer)
            table.insert(dialingTimers[tonumber(from)], timer7)
            table.insert(dialingTimers[tonumber(contact.entryNumber)], timer8)

           
            return true
       
    end
    return false
end
addEvent("phone:startDialing", true)
addEventHandler("phone:startDialing", root, startDialing)

function makeCall(thePlayer, commandName, phoneNumber)
    if not (phoneNumber) then
        outputChatBox("SYNTAX /" .. commandName .. " [Phone Number / Contact name]", thePlayer, 255, 194, 14)
    else
        if not canPlayerCall(thePlayer) then
            outputChatBox("You're unable to make phone call at the moment.", thePlayer, 255,0,0)
            return false
        end

        local hasCellphone, itemKey, itemValue, itemID = exports.vrp_global:hasItem(thePlayer, 2)
        if itemValue then
            triggerClientEvent(thePlayer, "phone:slidePhoneIn", thePlayer, itemValue, nil, phoneNumber)
            --triggerEvent("phone:startDialing", thePlayer, phoneNumber, itemValue )
        else
            for k, v in ipairs( getElementsByType( "colshape", resourceRoot ) ) do
                if isElementWithinColShape( thePlayer, v ) then
                    callSomeone(thePlayer, commandName, phoneNumber, -1)
                    return
                end
            end
            outputChatBox("You don't have a phone.", thePlayer, 255, 0, 0)
        end
    end
end
addCommandHandler("call", makeCall)


--[[
phonestate = 1 / caller, started dialing
phonestate = 2 / caller, started dialing and target is ringing.
phonestate = 3 / called, is being rang
phonestate = 4 / caller, connected.
phonestate = 5 / called, connected.
]]
function cancelPhoneCall(reason) 
    local phonestate = getElementData(source, "phonestate") or 0
    outputDebugString("[Phone] "..getPlayerName(source).." triggered cancelPhoneCall / "..(reason and reason or "").." / "..phonestate)
    local caller1 = source
    local caller2 = nil

    local caller1No = tonumber(getElementData(caller1, "callingwith"))
    local caller2No = tonumber(getElementData(caller1, "calling"))
    
    local caller1Called = getElementData(caller1, "called")
    local caller2Called = nil

    local caller1Phonestate = phonestate
    local caller2Phonestate = 0

    if caller1No then
        killDialingTimers(caller1No)
    end
    if caller2No then
        killDialingTimers(caller2No)
    end

    if caller2No then
        local found, caller = searchForPhone(caller2No)
        if found and getElementData(caller, "calling") == caller1No then
            caller2 = caller
            caller2Called = getElementData(caller2, "called")
            caller2Phonestate = getElementData(caller2, "phonestate")
        end
    end

    if caller1Called then
        writeCellphoneLogToClient(caller1)
        resetPhoneState(caller1)
        if caller1Phonestate == 3 then
            triggerClientEvent("stopRinging", caller1)
        elseif caller1Phonestate == 5 then
            triggerClientEvent(caller1, "phone:updateDialingScreen", caller1, isQuitType(reason) and reason or "called, answered but they canceled")
        end

        if caller2 then
            writeCellphoneLogToClient(caller2)
            resetPhoneState(caller2)
            if caller2Phonestate == 1 then
                if reason then
                    local timer = setTimer(triggerClientEvent, 5000,1 ,caller2, "phone:updateDialingScreen", caller2, reason)
                    table.insert(dialingTimers[tonumber(caller2No)], timer)
                else
                    triggerClientEvent(caller2, "phone:updateDialingScreen", caller2, isQuitType(reason) and reason or "caller, started dialing but canceled")
                end
            elseif caller2Phonestate == 2 then
                triggerClientEvent(caller2, "phone:updateDialingScreen", caller2, isQuitType(reason) and reason or "caller, started dialing and target is ringing. but canceled")
            elseif caller2Phonestate == 4 then
                triggerClientEvent(caller2, "phone:updateDialingScreen", caller2, isQuitType(reason) and reason or "called, answered but they canceled")
            end
        end
    else
        writeCellphoneLogToClient(caller1)
        resetPhoneState(caller1)
        if caller1Phonestate == 1 then
            if reason then
                local timer = setTimer(triggerClientEvent, 5000,1 ,caller1, "phone:updateDialingScreen", caller1, reason)
                table.insert(dialingTimers[tonumber(caller1No)], timer)
            else
                triggerClientEvent(caller1, "phone:updateDialingScreen", caller1, isQuitType(reason) and reason or "caller, started dialing but canceled")
            end
        elseif caller1Phonestate == 2 then
            triggerClientEvent(caller1, "phone:updateDialingScreen", caller1, isQuitType(reason) and reason or "caller, started dialing and target is ringing. but canceled")
        elseif caller1Phonestate == 4 then
            triggerClientEvent(caller1, "phone:updateDialingScreen", caller1, isQuitType(reason) and reason or "called, answered but they canceled")
        end

        if caller2 then
            writeCellphoneLogToClient(caller2)
            resetPhoneState(caller2)
            if caller2Phonestate == 3 then
                triggerClientEvent("stopRinging", caller2)
            elseif caller2Phonestate == 5 then
                triggerClientEvent(caller2, "phone:updateDialingScreen", caller2, isQuitType(reason) and reason or "called, answered but they canceled")
            end
        end
    end

    return true
end
addEvent("phone:cancelPhoneCall", true)
addEventHandler("phone:cancelPhoneCall", root, cancelPhoneCall)
addEventHandler("accounts:characters:change", root, cancelPhoneCall)
addEventHandler("onPlayerQuit", root, cancelPhoneCall)

function acceptPhoneCall()
    if not canPlayerAnswerCall(source) then
        outputChatBox("You can not use cellphone at the moment.", source, 255,0,0)
        triggerClientEvent("stopRinging", source)
        return false
    end
    local phonestate = getElementData(source, "phonestate") or 0
    if phonestate ~= 3 then
        outputChatBox("You phone is not ringing.", source, 255,0,0)
        triggerClientEvent("stopRinging", source)
        return false
    end

    triggerClientEvent("stopRinging", source)

    local calledNo = tonumber(getElementData(source, "callingwith"))
    local callerNo = tonumber(getElementData(source, "calling"))
    killDialingTimers(calledNo)
    killDialingTimers(callerNo)
    triggerClientEvent(source,"phone:slidePhoneIn", source, calledNo, true)
    local found, caller = searchForPhone(callerNo)
    triggerClientEvent(caller, "phone:updateDialingScreen", caller, "connected", getElementData(caller,"callingContact"))
    exports.vrp_anticheat:changeProtectedElementDataEx(caller, "phonestate", 4, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(source, "phonestate", 5, false)
    setElementData(caller , "phonetel" , getPlayerName(source))
    setElementData(source , "phonetel" , getPlayerName(source))
    updatePhoneHistoryState(calledNo, 3)
    writeCellphoneLog(caller, source, "Calls", nil, true )
    return true
end
addEvent("phone:acceptPhoneCall", true)
addEventHandler("phone:acceptPhoneCall", root, acceptPhoneCall)

function takeCallCost(cost, fromNumber, duration)
    if cost > 0 then
        if exports.vrp_bank:takeBankMoney(source, cost) then
            local foundFaction = nil
            for _, faction in pairs(getElementsByType("team")) do
                --outputDebugString(tonumber(getElementData(faction, "id")) )
                if tonumber(getElementData(faction, "id")) == 20 then --LSN
                    foundFaction = faction
                    break
                end
            end

            if not foundFaction then 
                outputDebugString ("phone / takeCallCost / didn't find the faction from id ")
                return false
            end

            if exports.vrp_global:giveMoney(foundFaction, cost) then
                return exports.vrp_bank:addBankTransactionLog(getElementData(source, "dbid"), -20, cost, 2, "Cellphone's phone call fee", "Call made from #"..fromNumber..", duration: "..duration, nil, nil)
            end
        end
    end
    return false
end
addEvent("phone:takeCallCost", true)
addEventHandler("phone:takeCallCost", root, takeCallCost)


function loudSpeaker(thePlayer, commandName)
    local logged = getElementData(thePlayer, "loggedin")
    
    if (logged==1) then
        if (exports.vrp_global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then -- 2 = Cell phone item
            local phonestate = getElementData(thePlayer, "phonestate") or 0
            if phonestate == 4 or phonestate == 5 then
                local loudspeaker = getElementData(thePlayer, "call.loudspeaker")
                if (not loudspeaker) then
                    triggerEvent('sendAme', thePlayer, "Telefondaki hoparlörü açar.")
                    outputChatBox("You flick your phone onto loudspeaker.", thePlayer)
                    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.loudspeaker", true, false)
                else
                    triggerEvent('sendAme', thePlayer, "Telefondaki hoparlörü kapatır.")
                    outputChatBox("You flick your phone off of loudspeaker.", thePlayer)
                    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.loudspeaker", false, false)
                end
            end
        end
    end
end
addCommandHandler("loudspeaker", loudSpeaker)

function talkPhone(thePlayer, commandName, ...)
    local affected = { }
    local logged = getElementData(thePlayer, "loggedin")
    
    if (logged==1) then
        if (exports.vrp_global:hasItem(thePlayer, 2)) or getElementData(thePlayer, "call.col") then
            if not (...) then
                outputChatBox("SYNTAX: /p [Message]", thePlayer, 255, 194, 14)
            elseif getElementData(thePlayer, "injuriedanimation")  then
                outputChatBox("You can't use your phone while knocked out.", thePlayer, 255, 0, 0)
            else
                local phoneState = getElementData(thePlayer, "phonestate")
                
                if (phoneState == 4 or phoneState == 5) then 
                    local message = table.concat({...}, " ")
                    local username = getPlayerName(thePlayer):gsub("_", " ")
                    
                    local languageslot = getElementData(thePlayer, "languages.current")
                    local language = getElementData(thePlayer, "languages.lang" .. languageslot)
                    local languagename = call(getResourceFromName("vrp_languages"), "getLanguageName", language)
                    
                    local callingNumber = getElementData(thePlayer, "calling")
                    local callingNumberWith = getElementData(thePlayer, "callingwith")
                    table.insert(affected, thePlayer)
                    table.insert(affected, "ph"..tostring(callingNumberWith))
                    local found, target = searchForPhone(callingNumber)
                    if not (found and target and isElement(target) and (getElementData(target, "loggedin") == 1)) and not isNumberAHotline(callingNumber) then
                        triggerEvent("phone:cancelPhoneCall", found or target)
                        return
                    end
                    
                    table.insert(affected, target)
                    table.insert(affected, "ph"..tostring(callingNumber))
                    
                    message = call( getResourceFromName( "vrp_chat" ), "trunklateText", thePlayer, message )
                    
                    local callprogress = getElementData(thePlayer, "callprogress")
                    if (callprogress) then
                        outputChatBox("Senin [Telefon]: " ..message, thePlayer)
                        triggerEvent("phone:applyPhone", thePlayer, "phone_talk")
                        -- Send it to nearby players of the speaker
                        exports.vrp_global:sendLocalText(thePlayer, username .. " [Telefon]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
                        
                        if isNumberAHotline(callingNumber) then
                            writeCellphoneLog(thePlayer, nil, "Calls", message )
                            exports['vrp_logs']:dbLog(thePlayer, 29, affected, "[" .. languagename .. "] " ..message) 
                            routeHotlineCall(thePlayer, tonumber(callingNumber), tonumber(callingNumberWith), false, message)       
                            return
                        end
                    end
                    ---------------------------------PEDROLANGES---------------------------------
                    ------------------------------ BU ALANA UĞRADI ------------------------------
                    local telefonCinsiyet = getElementData(thePlayer, "gender")
                    if (telefonCinsiyet == 0) then
                        telefonCinsiyet = "E"
                    else
                        telefonCinsiyet = "K"
                    end
                    local message2 = call(getResourceFromName("vrp_languages"), "applyLanguage", thePlayer, target, call( getResourceFromName( "vrp_chat" ), "trunklateText", target, message ), language)
                    local taksiciItems = exports["vrp_items"]:getItems(thePlayer)
                        for i, val in ipairs(taksiciItems) do
                            if val[1] == 2 then
                                taksiciTel = val[2]
                            end
                        end
                            outputChatBox("[Telefon "..taksiciTel.."]["..telefonCinsiyet.."]: " .. message2, target, 247, 157, 16, true)
                            --exports.global:sendLocalText(target, username .. "[Telefon "..taksiciTel.."]["..telefonCinsiyet.."] (Arka Ses): " .. message, 178, 178, 178, 10, {[thePlayer] = true})
                            triggerEvent("phone:applyPhone", target, "phone_talk")
                    -- Send the message to the person on the other end of the line
                    outputChatBox(""..getPlayerName(thePlayer):gsub("_", " ").." (cep telefonu): " ..message, thePlayer, 230, 230, 230, true)
                    triggerEvent("phone:applyPhone", thePlayer, "phone_talk")
                    -- Send it to nearby players of the speaker
                    --exports.global:sendLocalText(thePlayer, username .. " [Telefon]: " .. message, nil, nil, nil, 10, {[thePlayer] = true})
                    ---------------------------------------------------------------------------------------------
                    local loudspeaker = getElementData(target, "call.loudspeaker")
                    -- Send it to the listener, if they have loud speaker
                    if (loudspeaker) then -- Loudspeaker
                        local x, y, z = getElementPosition(target)
                        local username = getPlayerName(target):gsub("_", " ")
                        
                        for index, nearbyPlayer in ipairs(getElementsByType("player")) do
                            if isElement(nearbyPlayer) and nearbyPlayer ~= target and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 40 and getElementDimension(nearbyPlayer) == getElementDimension(target) then
                                local message2 = call(getResourceFromName("vrp_languages"), "applyLanguage", thePlayer, nearbyPlayer, call( getResourceFromName( "vrp_chat" ), "trunklateText", target, message ), language)
                                outputChatBox("[" .. languagename .. "] " .. username .. " Telefon Hopörlörü: " .. message2, nearbyPlayer)
                                table.insert(affected, nearbyPlayer)
                            end
                        end
                    end
                    writeCellphoneLog(thePlayer, target, "Calls", message )
                    exports['vrp_logs']:dbLog(thePlayer, 29, affected, "[" .. languagename .. "] " ..message) 
                else
                    outputChatBox("Bir telefon çağrısı yok.", thePlayer, 255, 0, 0)
                end
            end
        else
            outputChatBox("Believe it or not, it's hard to use a cellphone you do not have.", thePlayer, 255, 0, 0)
        end
    end
end
addCommandHandler("p", talkPhone)

--Functions
function getPhoneContact(clue, fromPhone)
    if not clue or string.len(clue) < 1 or not fromPhone or string.len(fromPhone) < 1 then return false end

    local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT * FROM `phone_contacts` WHERE `entryName`='" .. (tostring(clue)) .. "' OR `entryNumber`='" .. (tostring(clue)) .. "' AND `phone`='" .. (tostring(fromPhone)) .."' LIMIT 1"), -1)
    if not result then
        return false
    end
    return result
end

function killDialingTimers(phone)
    phone = tonumber(phone)
    if dialingTimers[phone] then
        for i, timer in pairs(dialingTimers[phone]) do
            if isTimer(timer) then
                if killTimer(timer) then
                    timer = nil
                    outputDebugString("[Phone] killDialingTimers killed.")
                end
            end
        end
    else
        dialingTimers[phone] = {}
    end
end

function resetPhoneState(thePlayer)
    setElementData(thePlayer , "phonetel" , false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "callingwith", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "calling", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "called", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "phonestate", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "calltimer", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "callingContact", nil, false)

    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.col", nil, false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "callprogress", false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.situation", false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.location", false)
    exports.vrp_anticheat:changeProtectedElementDataEx(thePlayer, "call.loudspeaker", false)
    outputDebugString("[Phone] resetPhoneState for "..tostring(getPlayerName(thePlayer)))
end

function playerQuit()
    local callingNumber = getElementData(source, "calling")
    if callingNumber then
        triggerEvent("phone:calledCancelCall", source)
    end
end
addEventHandler("onPlayerQuit", root, playerQuit)

function outputChange(dataName,oldValue)
    if getElementType(source) == "player" and dataName == "phonestate"  then -- check if the element is a player
        local newValue = getElementData(source,dataName) -- find the new value
        outputDebugString("[Phone] "..getPlayerName(source).."'s "..tostring(dataName).."' has changed from '"..tostring(oldValue).."' to '"..tostring(newValue).."'") -- output the change for the affected player
    end
end
--addEventHandler("onElementDataChange",getRootElement(),outputChange)


