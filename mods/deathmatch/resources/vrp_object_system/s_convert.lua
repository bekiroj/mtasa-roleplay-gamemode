function moveTempToRealDimension(dimension)
    if dimension then
        dbExec(mysql:getConnection(),"DELETE FROM `objects` WHERE dimension='".. tostring(dimension) .."'")
        local result = dbExec(mysql:getConnection(),"INSERT INTO `objects` (`model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `comment`, `solid`, `doublesided`, `scale`, `breakable`, `alpha`) SELECT `model`, `posX`, `posY`, `posZ`, `rotX`, `rotY`, `rotZ`, `interior`, `dimension`, `comment`, `solid`, `doublesided`, `scale`, `breakable`, `alpha` FROM `tempobjects` WHERE `dimension` =" .. tostring(dimension))
        if (result) then
            local result2 = dbExec(mysql:getConnection(),"DELETE FROM `tempobjects` WHERE `dimension` = " .. tostring(dimension))
            if (result2) then
                dbQuery(
                    function(qh)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            for index, result3 in ipairs(res) do
                                 if (result3) then
                                    local result4 = dbExec(mysql:getConnection(),"UPDATE `interiors` SET `interiorx`='".. result3["posX"] .."', `interiory`='".. result3["posY"] .."', `interiorz`='".. result3["posZ"] .."', `interior`='".. result3["interior"] .."' WHERE `id`='".. tostring(dimension) .."'")   
                                    local result5 = dbExec(mysql:getConnection(),"DELETE FROM `tempinteriors` WHERE `id` = " .. tostring(dimension))
                                    if (result4) and (result5) then
                                        exports['vrp_interiors']:realReloadInterior(tonumber(dimension))
                                        loadDimension(dimension)
                                        return true
                                    end
                                end
                            end
                        end
                    end,
                mysql:getConnection(), "SELECT * FROM `tempinteriors` WHERE `id`='".. tostring(dimension) .."'")
               
            end
        end
    end
    return false
end

function deleteInterior(dimensionID)
    loadDimension(tonumber(dimensionID))
    exports['vrp_interiors']:realReloadInterior(dimensionID)
    local result1 = dbExec(mysql:getConnection(),"DELETE FROM `tempobjects` WHERE `dimension` = " .. tostring(dimensionID))
    local result2 = dbExec(mysql:getConnection(),"DELETE FROM `tempinteriors` WHERE `id` = " .. tostring(dimensionID))
    if result1 and result2 then
        exports.vrp_global:sendMessageToAdmins( "[UCP] Custom interior processing for interior #"..tostring(dimensionID).." has completed!")
    else
        exports.vrp_global:sendMessageToAdmins( "[UCP] Warning! Could not clean temp objects.")
        return false
    end
end
--addCommandHandler("deltestinterior", deleteInterior, false, false)

--[[ Command to save the interior ]]--MAXIME
function saveInterior(dimensionID)
    local result = moveTempToRealDimension(tonumber(dimensionID))
    if result then
        exports.vrp_global:sendMessageToAdmins( "[UCP] Custom interior has been saved! Now reloading..")
        deleteInterior(dimensionID)
    else
        exports.vrp_global:sendMessageToAdmins( "[UCP] Failed! Something went wrong. Error code: x0983CF")
    end
end
--addCommandHandler("savetestinterior", saveInterior, false, false)

--[[ Test the uploaded interior ]]--MAXIME
function testInterior(thePlayer, dimensionID)
    triggerClientEvent("object:clear", getRootElement(), dimensionID)
    local count = loadDimension(tonumber(dimensionID), true)
    if (count > 0) then
        exports.vrp_global:sendMessageToAdmins("[UCP] Loaded " .. count .. " interior custom objects to interior ID#".. dimensionID)
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, result in ipairs(res) do
                        if (result) then
                            if thePlayer and isElement(thePlayer) then
                                transferDimension(thePlayer, tonumber(dimensionID))
                                setElementPosition(thePlayer, tonumber(result["posX"]), tonumber(result["posY"]), tonumber(result["posZ"]))
                                setElementInterior(thePlayer, tonumber(result["interior"]))
                                setElementDimension(thePlayer, tonumber(result["id"]))
                                outputChatBox( "[UCP] Teleported you to the marker.", thePlayer, 0, 255, 0 )
                            end
                            saveInterior(dimensionID)
                        else
                            exports.vrp_global:sendMessageToAdmins( "[UCP] Failed! Internal error code: x9889DF")
                            return false
                        end
                    end
                end
            end,
        mysql:getConnection(), "SELECT * FROM `tempinteriors` WHERE `id`='".. (dimensionID).."'")
    else 
        exports.vrp_global:sendMessageToAdmins( "[UCP] ERROR: No temporary objects found for interior ID#".. dimensionID)
        return false
    end
    return true
end
--addCommandHandler("testinterior", testInterior, false, false)

--MAXIME
function processCustomInterior(thePlayer, commandName, dimensionID, playerUsername)
    if thePlayer and isElement(thePlayer) then
        if exports.vrp_integration:isPlayerSeniorAdmin(thePlayer) or exports.vrp_integration:isPlayerScripter(thePlayer) then
            if not dimensionID or not tonumber(dimensionID) then
                outputChatBox("SYNTAX: /"..commandName.." [interior ID]", thePlayer)
            end
        end
    else 
        if not dimensionID or not tonumber(dimensionID) then
            return false
        end
    end

    if thePlayer and isElement(thePlayer) then
        outputChatBox("[CUSTOM INT] Checking uploaded custom interiors..", thePlayer)
    else
        exports.vrp_global:sendMessageToAdmins("[UCP] Player "..playerUsername.." has uploaded a custom interior for property ID#"..dimensionID.."." )
    end
    testInterior(thePlayer, tonumber(dimensionID))
end
addCommandHandler("processcustominterior", processCustomInterior, false, false)

function initiateChecker ( )
    outputDebugString("[CUSTOM INT] STARTED CHECKING.")
    setTimer(toCheckInterior, 1000*60*5, 0, false, false,false)--every 5 minutes
end
--addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), initiateChecker )