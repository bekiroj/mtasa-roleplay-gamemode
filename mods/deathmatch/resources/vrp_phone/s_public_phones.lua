mysql = exports.vrp_mysql
addEventHandler( "onResourceStart", getResourceRootElement( ),
    function( )
        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        local id = tonumber(row["id"])
                        
                        local x = tonumber(row["x"])
                        local y = tonumber(row["y"])
                        local z = tonumber(row["z"])
                            
                        local dimension = tonumber(row["dimension"])
                        
                        local shape = createColSphere(x, y, z, 1)
                        exports.vrp_pool:allocateElement(shape)
                        setElementDimension(shape, dimension)
                        exports.vrp_anticheat:changeProtectedElementDataEx(shape, "dbid", id, false)
                    end
                end
            end,
        mysql:getConnection(), "SELECT id, x, y, z, dimension FROM publicphones")
    end
)

function SmallestID( ) -- finds the smallest ID in the SQL instead of auto increment
    local result = dbPoll(dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM publicphones AS e1 LEFT JOIN publicphones AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL"), -1)
    if result then
        local id = tonumber(result["nextID"]) or 1
        return id
    end
    return false
end

function addPhone(thePlayer, commandName)
    if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
        local x, y, z = getElementPosition(thePlayer)
        local dimension = getElementDimension(thePlayer)
        
        local id = SmallestID()
        local query = dbExec(mysql:getConnection(), "INSERT INTO publicphones SET id=" .. (id) .. ", x="  .. (x) .. ", y=" .. (y) .. ", z=" .. (z) .. ", dimension=" .. (dimension))
        
        if (query) then
            
            local shape = createColSphere(x, y, z, 1)
            exports.vrp_pool:allocateElement(shape)
            setElementDimension(shape, dimension)
            exports.vrp_anticheat:changeProtectedElementDataEx(shape, "dbid", id, false)
            
            outputChatBox("Public Phone spawned with ID #" .. id .. ".", thePlayer, 0, 255, 0)
        else
            outputChatBox("Error 200001 - Report on forums.", thePlayer, 255, 0, 0)
        end
    end
end
addCommandHandler("addphone", addPhone, false, false)

function getNearbyPhones(thePlayer, commandName)
    if (exports.vrp_integration:isPlayerTrialAdmin(thePlayer)) then
        local posX, posY, posZ = getElementPosition(thePlayer)
        outputChatBox("Nearby Phones:", thePlayer, 255, 126, 0)
        local count = 0
        
        for k, theColshape in ipairs(getElementsByType("colshape", getResourceRootElement())) do
            local x, y = getElementPosition(theColshape)
            local distance = getDistanceBetweenPoints2D(posX, posY, x, y)
            if (distance<=20) then
                local dbid = getElementData(theColshape, "dbid")
                outputChatBox("   Public Phone with ID " .. dbid .. ".", thePlayer, 255, 126, 0)
                count = count + 1
            end
        end
        
        if (count==0) then
            outputChatBox("   None.", thePlayer, 255, 126, 0)
        end
    end
end
addCommandHandler("nearbyphones", getNearbyPhones, false, false)

function delPhone(thePlayer, commandName, id)
    if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
        local id = tonumber(id)
        if not id then
            outputChatBox( "SYNTAX: /" .. commandName .. " [id]", thePlayer, 255, 194, 14 )
        else
            local colShape = nil
            
            for key, value in ipairs(getElementsByType("colshape", getResourceRootElement())) do
                if getElementData(value, "dbid") == id then
                    colShape = value
                end
            end
            
            if (colShape) then
                local id = getElementData(colShape, "dbid")
                local result = dbExec(mysql:getConnection(), "DELETE FROM publicphones WHERE id=" .. (id))
                
                outputChatBox("Phone #" .. id .. " deleted.", thePlayer)
                destroyElement(colShape)
            else
                outputChatBox("You are not in a Pay n Spray.", thePlayer, 255, 0, 0)
            end
        end
    end
end
addCommandHandler("delphone", delPhone, false, false)

