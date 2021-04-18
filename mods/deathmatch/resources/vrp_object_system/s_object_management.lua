mysql = exports.vrp_mysql
objects = { }

function loadDimension(dimension, demotable)
    if dimension then
        objects[ dimension ] = { }
        
        local tableselect = "objects"
        
        if demotable then
            tableselect = "tempobjects"
        end
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        for key, value in pairs( row ) do
                            row[key] = tonumber(value)
                        end
                        
                        table.insert( objects[ dimension ], { row.model, row.posX, row.posY, row.posZ, row.rotX, row.rotY, row.rotZ, row.interior, row.solid == 1, row.doublesided == 1, tostring(row.id), row.scale, row.breakable == 1, tonumber(row.alpha) or 255 } )
                    end
                    syncDimension(theDimension)
                end
            end,
        mysql:getConnection(), "SELECT * FROM `".. tableselect .."` WHERE dimension = " .. tostring(dimension))
    end
    return 0
end

function reloadDimension(thePlayer, commandName, dimensionID)
    if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
        if dimensionID then
            triggerClientEvent("object:clear", getRootElement(), dimensionID)
            local count = loadDimension(tonumber(dimensionID))
            if (count > 0) then
                outputChatBox( "Reloaded " .. count .. " items in interior ".. dimensionID, thePlayer, 0, 255, 0 )
            end
        end
    end
end
addCommandHandler("reloadinterior", reloadDimension, false, false)

function reloadInteriorObjects(theDimension)
    if (theDimension) then
        triggerClientEvent("object:clear", getRootElement(), dimensionID)
        loadDimension(tonumber(dimensionID))
    end
end

function removeInteriorObjects(theDimension)
    if (theDimension) and (tonumber(theDimension) >= 0) then
        dbExec(mysql:getConnection(), "DELETE FROM `objects` WHERE `dimension`='".. (theDimension).."'")
        triggerClientEvent("object:clear", getRootElement(), theDimension)
        loadDimension(tonumber(theDimension))
    end
end

function startObjectSystem(res)
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    loadDimension(row.dimension)
                end
            end
        end,
    mysql:getConnection(), "SELECT distinct(`dimension`) FROM `objects` ORDER BY `dimension` ASC")
end
addEventHandler("onResourceStart", getResourceRootElement(), startObjectSystem)