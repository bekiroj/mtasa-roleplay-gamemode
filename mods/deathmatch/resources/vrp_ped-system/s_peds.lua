local tempPeds = {}
local pedMoveTimer = {}
local pedMoveTimerTO = {}
local null = nil
local toLoad = { }
local threads = { }

--[[
NPC BEHAVIOURS:
0: immortal : (almost) never dies
1: scared   : will put hands up or crouch down upon being attacked
2: defending    : will try to shoot back upon being attacked (given it has a weapon, otherwise punch)
3: immortal : (almost) never dies (duplicate to 0)
4: pannicing    : will run away in pannic upon being attacked
5: public transport user : will enter any operated trams
--]]

--skins to random select from for peds with no set skin id
local skinsMale = {7,14,15,17,20,21,24,25,26,29,35,36,37,44,46,57,58,59,60,68,72,98,147,185,186,187,223,227,228,234,235,240,258,259}
local skinsFemale = {9,11,12,40,41,55,56,69,76,88,89,91,93,129,130,141,148,150,151,190,191,192,193,194,196,211,215,216,219,224,225,226,233,263}

local mysql = exports.vrp_mysql

function loadAllPeds(res)
    local mysql = exports.vrp_mysql

    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    loadOnePed(row["id"])
                end
            end
        end,
    mysql:getConnection(), "SELECT id FROM `peds` ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllPeds)

function reloadPed(id)
    outputDebugString("reloadPed("..tostring(id)..")")
    local thePed = exports.vrp_pool:getElement("ped", tonumber(id))
    outputDebugString("ped = "..tostring(thePed))
    if(thePed) then
        destroyElement(thePed)
    end
    loadOnePed(id, false)
    return true
end

function loadOnePed(id)
    local mysql = exports.vrp_mysql
    
    dbQuery(
        function(qh)
            local res, rows, err = dbPoll(qh, 0)
            if rows > 0 then
                for index, row in ipairs(res) do
                    for k, v in pairs( row ) do
                        if v == null then
                            row[k] = nil
                        else
                            row[k] = tonumber(row[k]) or row[k]
                        end
                    end
                    
                    --set/get gender
                    local gender = row.gender

                    --set/get skin
                    local skin = row.skin
                    if skin then
                        if not gender then
                            gender = getGenderFromSkin(skin)
                        end
                    else
                        if not gender then  
                            gender = getRandomName("gender")
                        end
                        if(gender == 0) then
                            skin = skinsMale[math.random(#skinsMale)]
                        elseif(gender == 1) then
                            skin = skinsFemale[math.random(#skinsFemale)]
                        end
                    end
                    
                    local ped = createPed(skin, row.x, row.y, row.z, row.rotation, row.synced == 1)
                    if ped then
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "dbid", row.id)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.dbid", row.id)
                        exports.vrp_pool:allocateElement(ped, row.id, true)
                                            
                        setElementDimension(ped, row.dimension)
                        setElementInterior(ped, row.interior)
                        
                        --for ped respawning purposes - Only needed for non-dbid peds!
                        --exports.anticheat:changeProtectedElementDataEx(ped, "rpp.npc.spawnpos", row.x..","..row.y..","..row.z..","..row.rotation..","..row.interior..","..row.dimension)
                    
                        --set/get name
                        local pedname = row.name
                        if not pedname then
                            pedname = getRandomName("full", gender)
                        end
                        
                        if row.type then
                            exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.type", row.type)
                        end
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.name", pedname)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "ped:name", pedname) -- For chat system
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.gender", gender)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "name", pedname) --for owl
                        if row.nametag then
                            exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.nametag", true)
                            exports.vrp_anticheat:changeProtectedElementDataEx(ped, "nametag", true) --for owl
                        end
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.behav", row.behaviour)
                        if row.money then --if ped have money, set the amount
                            exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.money", row.money)
                        else --if ped does not have money but has a owner, set it so any expenses for the ped is subtracted from the owner
                            if(row.owner_type ~= 0 and row.owner ~= 0) then
                                exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.owner_type", row.owner_type)
                                exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.owner", row.owner)
                            end
                        end
                        
                        if(tonumber(row.frozen) == 1) then
                            setElementFrozen(ped, true)
                        end
                        
                        if row.animation then
                            exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.animation", row.animation)
                            --outputDebugString(tostring(row.animation))
                            local animTable = exports.vrp_global:split(row.animation, ";")
                            local animBlock = animTable[1]
                            local anim = animTable[2]
                            if animBlock and anim then
                                setPedAnimation(ped, animBlock, anim)
                            end
                        end
                        
                        local badges = {}
                        badges = exports['vrp_items']:getBadges()
                        --outputDebugString(tostring(#badges).." badges")
                        for k,v in pairs(badges) do
                            local hasItem = exports['vrp_items']:hasItem(ped, k)
                            if hasItem then
                                local itemresult = exports['vrp_items']:npcUseItem(ped, k)
                                --outputDebugString("ped itemresult = "..tostring(itemresult))
                                break;
                            end
                        end
                        local masks = {}
                        masks = exports['vrp_items']:getMasks()
                        for k,v in pairs(masks) do
                            local hasItem = exports['vrp_items']:hasItem(ped, k)
                            if hasItem then
                                local itemresult = exports['vrp_items']:npcUseItem(ped, k)
                                --outputDebugString("ped itemresult = "..tostring(itemresult))
                                break;
                            end
                        end
                        --exports['item-system']:updateLocalGuns(ped)
                        
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.createdBy", row.created_by)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.createdByUsername", exports.vrp_global:getUserNameFromID(row.created_by))
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.createdAt", row.created_at)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.comment", row.comment)
                        exports.vrp_anticheat:changeProtectedElementDataEx(ped, "rpp.npc.synced", tonumber(row.synced) == 1 or false)
                        
                        --DEBUG / TESTING ONLY:
                        --[[
                        local itemID = 65
                        
                        local itemresult = exports['item-system']:npcUseItem(ped, itemID)
                        outputDebugString("ped itemresult = "..tostring(itemresult))
                        --]]
                    end
                end
            end
        end,
    mysql:getConnection(), "SELECT * FROM peds WHERE id = " .. (id) .. " LIMIT 1" )

end

function savePed(id)
    local mysql = exports.vrp_mysql
    if id then
        local thePed = exports.vrp_pool:getElement("ped", tonumber(id))
        if thePed then
            local money = getElementData(thePed, "rpp.npc.money")
            if money then
                local query = dbExec(mysql:getConnection(), "UPDATE peds SET money = '" .. (money) .. "' WHERE id='" .. (id) .. "'")
                if query then
                    return true
                end
            end
        end
    end
    return false
end

function healByHospitalPed(ped)
    --outputDebugString("healByHospitalPed()")
    local pedname = tostring(getElementData(ped, "rpp.npc.name"))
    local playername = tostring(getPlayerNametagText(source))
    local health = getElementHealth(source)
    local needed = 100 - tonumber(health)
    if(needed < 5) then
        exports.vrp_RPPchat:chatPed(ped, "say", "You seem to be fine, sir. No treatment needed.")
    else
        local cost = math.ceil(1 * needed)
        if(getPlayerMoney(source) > cost or getPlayerMoney(source) == cost) then
            local newHealth = health + needed
            exports.vrp_RPPchat:chatMe(source, false, "takes out a wallet and hands a few dollar notes to "..pedname)
            exports.vrp_RPPchat:chatPed(ped, "me", "takes the money")
            takePlayerMoney(source, tonumber(cost))
            exports.vrp_RPPchat:chatPed(ped, "say", "Thank you sir. I'll get you fixed up.")
            exports.vrp_RPPchat:chatPed(ped, "me", "heals "..playername)
            setElementHealth(source, newHealth)
        else
            exports.vrp_RPPchat:chatMe(source, false, "takes out a wallet and hands a few dollar notes to "..pedname)
            exports.vrp_RPPchat:chatPed(ped, "say", "Sorry sir. I don't think that is enough.")
        end
    end
end
addEvent("clientHealByNPC", true)
addEventHandler("clientHealByNPC", getRootElement(), healByHospitalPed)

function reloadWeaponForPed(ped)
    if ped then
        reloadPedWeapon(ped)
        --outputDebugString("reloaded weapon")
    end
end
addEvent("clientReloadPedWeapon", true)
addEventHandler("clientReloadPedWeapon", getRootElement(), reloadWeaponForPed)

function makeTempPed(thePlayer, command, behav, gender, skin, name) --create temporary ped (no dbid)
    if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
        if not behav then
            behav = 1
        else
            behav = tonumber(behav)
        end
        if(gender == "male") then gender = 0 elseif(gender == "female") then gender = 1 end
        if(gender ~= 1 and gender ~= 0) then
            gender = getRandomName("gender")
        end
        if not skin then
            if(gender == 0) then
                skin = skinsMale[math.random(#skinsMale)]
            elseif(gender == 1) then
                skin = skinsFemale[math.random(#skinsFemale)]
            end
        end
        local x,y,z = getElementPosition(thePlayer)
        local rx,ry,rz = getElementRotation(thePlayer)
        local int = getElementInterior(thePlayer)
        local dim = getElementDimension(thePlayer)
        local i = #tempPeds + 1
        tempPeds[i] = createPed(skin, x, y, z, rz, false)
        outputConsole("PED: "..tostring(skin)..","..tostring(x)..","..tostring(y)..","..tostring(z)..","..tostring(rz),thePlayer)
        setElementInterior(tempPeds[i], int)
        setElementDimension(tempPeds[i], dim)
        if name then
            local splitname = exports.vrp_global:split(name, "_")
            if(#splitname >= 2) then
                name = splitname[1].." "..splitname[2]
            end
        else
            name = getRandomName("full",gender)
        end
        setElementData(tempPeds[i], "dbid", -i)
        setElementData(tempPeds[i], "rpp.npc.dbid", -i)
        setElementData(tempPeds[i], "rpp.npc.name", tostring(name))
        setElementData(tempPeds[i], "rpp.npc.nametag", true)
        setElementData(tempPeds[i], "rpp.npc.behav", tostring(behav))
        setElementData(tempPeds[i], "rpp.npc.spawnpos", {x, y, z, rz, int, dim})
        setElementData(tempPeds[i], "rpp.npc.spawnpos2", tostring(x)..","..tostring(y)..","..tostring(z)..","..tostring(rz)..","..tostring(int)..","..tostring(dim))
        if(behav == 2) then
            giveWeapon(tempPeds[i], 22)
            setPedStat(tempPeds[i], 69, 999)
            setPedStat(tempPeds[i], 76, 999)
        end
        if(behav == 5) then
            local shape = createMarker(x, y, z, "cylinder", 20)
            setMarkerColor(shape, 0, 0, 0, 0)
            local result = addEventHandler("onMarkerHit", shape, npcEnterPCT)
            --outputDebugString(tostring(result).." ("..tostring(shape)..")")
            attachElements(shape, tempPeds[i], 0, 0, -1, 0, 0, 0)
        end
    end
end
addCommandHandler("ped", makeTempPed)

function createPermPed(thePlayer, command, interact) --create temporary ped (no dbid)
    if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
        local mysql = exports.vrp_mysql
        local x,y,z = getElementPosition(thePlayer)
        local rx,ry,rz = getElementRotation(thePlayer)
        local int = getElementInterior(thePlayer)
        local dim = getElementDimension(thePlayer)
        local name = "Unnamed Ped"
        local behav = 1
        local gender = 0
        local skin = 264
        local userID = getElementData(thePlayer, "account:id")
        if not interact then
            interact = ""
        end

        dbExec(mysql:getConnection(), "INSERT INTO `peds` (`name`, `type`, `x`, `y`, `z`, `rotation`, `interior`, `dimension`, `skin`, `gender`, `created_by`, `created_at`) VALUES ('"..name.."', '"..(interact).."', '"..x.."', '"..y.."', '"..z.."', '"..rz.."', '"..int.."', '"..dim.."', '"..skin.."', '"..gender.."', '"..userID.."', NOW());")
        setElementPosition(thePlayer, x+0.5, y, z)

        dbQuery(
            function(qh)
                local res, rows, err = dbPoll(qh, 0)
                if rows > 0 then
                    for index, row in ipairs(res) do
                        loadOnePed(row['id'])
                    end
                end
            end,
        mysql:getConnection(), "SELECT id FROM peds WHERE id = LAST_INSERT_ID()")
        
    end
end
addCommandHandler("makeped", createPermPed)

function pedMoveTowardsElement(ped, element)
    local x,y,z = getElementPosition(element)
    local px,py,pz = getElementPosition(ped)
    local rot = 0
    if ( x >= px ) and ( y > py ) then -- north-east
        rot = 90 - rot
    elseif ( x <= px ) and ( y > py ) then -- north-west
        rot = 270 + rot
    elseif ( x >= px ) and ( y <= py ) then -- south-east
        rot = 90 + rot
    elseif ( x < px ) and ( y <= py ) then -- south-west
        rot = 270 - rot
    end
    setPedRotation(ped, rot)
    --setPedLookAt(ped, x, y, z + 0.5)
    setPedAnimation(ped, "ped", "run_civi", -1, true, true, true, true)
end
function pedMoveTowardsCoordinates(ped, x, y, z, px, py, pz)
    --local x,y,z = getElementPosition(element)
    if not px and py and pz then px,py,pz = getElementPosition(ped) end
    local rot = 0
    if ( x >= px ) and ( y > py ) then -- north-east
        rot = 90 - rot
    elseif ( x <= px ) and ( y > py ) then -- north-west
        rot = 270 + rot
    elseif ( x >= px ) and ( y <= py ) then -- south-east
        rot = 90 + rot
    elseif ( x < px ) and ( y <= py ) then -- south-west
        rot = 270 - rot
    end
    setPedRotation(ped, rot)
    --setPedLookAt(ped, x, y, z + 0.5)
    setPedAnimation(ped, "ped", "run_civi", -1, true, true, true, true)
end
function pedMoveTimeout(ped)
    --outputDebugString("timeout")
    killTimer(pedMoveTimer[ped])
    pedMoveTimer[ped] = nil
    setPedAnimation(ped)
    pedMoveTimerTO[ped] = nil
end
function pedMoveToTram(ped, tram)
    --outputDebugString("pedMoveToTram")
    x,y,z = getElementPosition(tram)
    px,py,pz = getElementPosition(ped)
    local distance = getDistanceBetweenPoints3D(x, y, z, px, py, pz)
    --if distance > 20 then
    --  outputDebugString("moving")
    --  pedMoveTowardsCoordinates(ped, x, y, z, px, py, pz)
    --else
        --outputDebugString("close enough")
        killTimer(pedMoveTimerTO[ped])
        pedMoveTimerTO[ped] = nil
        killTimer(pedMoveTimer[ped])
        pedMoveTimer[ped] = nil
        setPedAnimation(ped)
        exports.vrp_trams:npcEnterTramPassenger(ped, tram)
    --end
end
function npcEnterPCT(hitElement, matchingDimension, marker)
    if not source then
        source = marker
    end
    --outputDebugString("triggered")
    if matchingDimension then
        if(getElementType(hitElement) == "vehicle") then
            if(getElementModel(hitElement) == 449) then
                outputDebugString("is tram")
                if(getVehicleController(hitElement)) then
                    if(getResourceState(getResourceFromName("vrp_trams")) == "running") then
                        outputDebugString("all good")
                        local ped = getElementParent(source)
                        pedMoveTimer[ped] = setTimer(pedMoveToTram, 100, 0, ped, hitElement)
                        pedMoveTimerTO[ped] = setTimer(pedMoveTimeout, 10000, 1, ped)
                    end
                end
            end
        end
    end
end

function respawnPed(player, ped)
    if(getElementType(ped) == "ped") then
        if getElementData(ped, "dbid") then
            local dbid = getElementData(ped, "dbid")
            --if(ped == exports.pool:getElement("ped", tonumber(dbid))) then --extra security check
                local result = reloadPed(tonumber(dbid))
                if result then
                    outputDebugString("Successfully respawned ped with dbid "..tostring(dbid))
                    return true
                else
                    outputDebugString("Failed to respawn ped with dbid "..tostring(dbid).." (#2)")
                    return false
                end
            --else
            --  outputDebugString("Failed to respawn ped with dbid "..tostring(dbid).." (#1) ("..tostring(ped).." = "..tostring(exports.pool:getElement("ped", tonumber(dbid)))..")")
            --  return false
            --end
        elseif getElementData(ped, "rpp.npc.spawnpos") then
            local spawnpos = getElementData(ped, "rpp.npc.spawnpos")
            new = createPed(getElementModel(ped),spawnpos[1],spawnpos[2],spawnpos[3],spawnpos[4])
            setPedRotation(new, spawnpos[4])
            setElementInterior(new, tonumber(spawnpos[5]))
            setElementDimension(new, tonumber(spawnpos[6]))
        elseif getElementData(ped, "rpp.npc.spawnpos2") then
            local posstring = getElementData(ped, "rpp.npc.spawnpos2")
            local pos = exports.vrp_global:split(posstring, ",")
            new = createPed(getElementModel(ped),pos[1],pos[2],pos[3],pos[4])
            setPedRotation(new, getElementData(ped,"rotation"))
            setElementInterior(new, tonumber(pos[5]))
            setElementDimension(new, tonumber(pos[6]))
        else
            new = createPed(getElementModel(ped),getElementPosition(ped))
            local rz, ry, rx = getElementRotation(ped)
            setElementRotation(new, rz, ry, rx)
            setElementInterior(new, getElementInterior(ped))
            setElementDimension(new, getElementDimension(ped))
        end

        for k, v in next, getAllElementData(ped) do
            exports.vrp_anticheat:changeProtectedElementDataEx(new, k, v)
        end
        exports.vrp_anticheat:changeProtectedElementDataEx(new, "activeConvo", 0)
        destroyElement(ped) --destroy old ped
        
        --[[
        local posstring = getElementData(ped, "rpp.npc.spawnpos")
        if posstring then
            local pos = exports.global:split(posstring, ",")
            local nametag = getElementData(ped, "rpp.npc.nametag")
            local name
            if nametag == "true" then
                name = getElementData(ped, "rpp.npc.name")
            end
            local behav = getElementData(ped, "rpp.npc.behav")
            local ptype = getElementData(ped, "rpp.npc.type")
            local fuelPriceratio
            if(ptype == "fuel") then
                fuelPriceratio = getElementData(ped, "fuel:priceratio")
            end
            local skin = getElementModel(ped)
            
            local newPed = createPed(skin, pos[1], pos[2], pos[3], pos[4], false)
            if newPed then
                if nametag and name then
                    setElementData(newPed, "rpp.npc.name", tostring(name))
                    setElementData(newPed, "rpp.npc.nametag", "true")
                end
                setElementData(newPed, "rpp.npc.behav", tostring(behav))
                setElementData(newPed, "rpp.npc.type", tostring(ptype))
                if(ptype == "fuel") then
                    setElementData(newPed, "fuel:priceratio", tostring(fuelPriceratio))
                end
                
                destroyElement(ped) --destroy old ped
            end
        end
        --]]
    end
end
addEvent("peds:respawnPed", true)
addEventHandler("peds:respawnPed", getRootElement(), respawnPed)

function healPed(player, ped)
    if(getElementType(ped) == "ped") then
        local factionType = getElementData(getPlayerTeam(player), "type")
        if not (factionType==4) then
            outputChatBox("You have no basic medic skills, contact the ES.", player, 255, 0, 0)
        else
            local foundkit, slot, itemValue = exports.vrp_global:hasItem(player, 70)
            if foundkit then
                if isPedDead(ped) then
                    respawnPed(player, ped)
                else
                    setElementHealth(ped, 100)
                    local name = getPlayerName(player)
                    local pedName = getElementData(ped, "rpp.npc.name")
                    local message
                    if pedName then
                        message = "opens his medical kit and treats "..tostring(pedName)
                    else
                        message = "opens his medical kit and treats the person"
                    end
                    exports.vrp_global:sendLocalText(source, " *" ..  string.gsub(name, "_", " ").. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message, 255, 51, 102)
                    if itemValue > 1 then
                        exports['vrp_items']:updateItemValue(player, slot, itemValue - 1)
                    else
                        exports.vrp_global:takeItem(thePlayer, 70, itemValue)
                        if not exports.vrp_global:hasItem(thePlayer, 70) then
                            outputChatBox("Warning, you're out of first aid kits. re /duty to get new ones.", player, 255, 0, 0)
                        end
                    end
                    local tax = exports.vrp_global:getTaxAmount()
                    local price = 100                                   
                    exports.vrp_global:giveMoney( getTeamFromName("San Fierro Emergency Services"), math.ceil((1-tax)*price) )
                    exports.vrp_global:giveMoney( getTeamFromName("Government of San Fierro"), math.ceil(tax*price) )
                    if pedName then
                        outputChatBox("You healed " ..pedName.. " (NPC).", player, 0, 255, 0)
                    else
                        outputChatBox("You healed a NPC.", player, 0, 255, 0)
                    end
                    exports.vrp_logs:dbLog(player, 35, ped, "HEAL NPC FOR $" .. price)
                end
            else
                outputChatBox("You need a first aid kit to heal people.", player, 255, 0, 0)
            end
        end
    end
end
addEvent("peds:healPed", true)
addEventHandler("peds:healPed", getRootElement(), healPed)

local allowedFunctionPeds = {
    --["function"] = true/false
}
function deletePed(player, ped)
    if(getElementType(ped) == "ped") then
        if exports.vrp_integration:isPlayerAdmin(player) then
            local dbid = tonumber(getElementData(ped, "rpp.npc.dbid")) or 0
            if dbid > 0 then
                local pedFunction = getElementData(ped, "rpp.npc.type")
                if pedFunction then
                    --if(allowedFunctionPeds[pedFunction] or exports.global:isPlayerHeadAdmin(player)) then
                        deleteDbPed(player, dbid, ped)
                    --end
                else
                    deleteDbPed(player, dbid, ped)
                end
            else
                local pedName = getElementData(ped, "rpp.npc.name")
                if not pedName then
                    pedName = getElementData(ped, "name")
                end
                if not pedName then
                    pedName = "Unnamed"
                end
                destroyElement(ped)
                exports.vrp_global:sendMessageToAdmins("[Peds] Temp NPC '"..tostring(pedName).."' was deleted by " .. getPlayerName(player) .. ".")
            end
        end
    end
end
addEvent("peds:deletePed", true)
addEventHandler("peds:deletePed", getRootElement(), deletePed)

function deleteDbPed(player, pedID, ped)
    local mysql = exports.vrp_mysql
    if exports.vrp_integration:isPlayerTrialAdmin(player) then
        if not ped then
            ped = exports.vrp_global:getPoolElement("ped", pedID)
        end
        if not ped then
            outputChatBox("Ped not found!", player, 255, 0, 0)
            return false
        end
        local pedType = getElementData(ped, "rpp.npc.type")
        if pedType then
            if(not allowedFunctionPeds[pedFunction]) then
                if not exports.vrp_integration:isPlayerAdmin(player) then
                    outputChatBox("Only Admin+ can delete this ped type.", player, 255, 0, 0)
                    return false
                end
            end
        end
        dbExec(mysql:getConnection(), "DELETE FROM peds WHERE id='"..(pedID).."'")
        destroyElement(ped)
    else
        outputChatBox("Only admins can delete permanent peds.", player, 255, 0, 0)
    end
end

function savePedToDB(arguments, element)
    if exports.vrp_integration:isPlayerTrialAdmin(source) then
        local mysql = exports.vrp_mysql
        local dbid = tonumber(arguments[1]) or false
        --argument = {}
        --for i = 1, #arguments do -- 16 arguments
        --  argument[i] = (arguments[i])
        --end

        local keys = {"dbid", "name", "type", "behaviour", "x", "y", "z", "rotation", "interior", "dimension", "skin", "animation", "synced", "nametag", "frozen", "comment"}

        if dbid then
            argument = {}
            for i = 1, #arguments do
                local v = arguments[i]
                if(type(v) == "boolean" and not v) then
                    argument[i] = "NULL"
                elseif(type(v) == "boolean" and v) then
                    argument[i] = "'1'"
                elseif(type(v) == "string") then
                    argument[i] = "'"..(v).."'"
                elseif(type(v) == "number") then
                    argument[i] = "'"..tostring(v).."'"
                else
                    outputChatBox("Error saving ped (invalid value '"..tostring(v).."' for '"..tostring(keys[i]).."').", source, 255, 0, 0)
                    return
                end
            end

            --outputConsole("UPDATE peds SET id="..argument[1]..", name="..argument[2]..", type="..argument[3]..", behaviour="..argument[4]..", x="..argument[5]..", y="..argument[6].."', z="..argument[7].."', rotation="..argument[8].."', interior="..argument[9]..", dimension="..argument[10]..", skin="..argument[11]..", animation="..argument[12]..", synced="..argument[13]..", nametag="..argument[14]..", frozen="..argument[15]..", comment="..argument[16]..";", source)
            dbExec(mysql:getConnection(), "UPDATE peds SET name="..argument[2]..", type="..argument[3]..", behaviour="..argument[4]..", x="..argument[5]..", y="..argument[6]..", z="..argument[7]..", rotation="..argument[8]..", interior="..argument[9]..", dimension="..argument[10]..", skin="..argument[11]..", animation="..argument[12]..", synced="..argument[13]..", nametag="..argument[14]..", frozen="..argument[15]..", comment="..argument[16].." WHERE id="..argument[1]..";")
            
            --outputDebugString("behaviour="..tostring(argument[4]))
            outputDebugString("(frozen="..tostring(arguments[15])..")")
            outputDebugString("frozen="..tostring(argument[15]))

            outputChatBox("Updated ped #"..tostring(argument[1]).." in the database.", source, 0, 255, 0)
            reloadPed(dbid)
            return
        elseif(not dbid and element) then       
            local name = arguments[2]
            local pedType = arguments[3]
            local behaviour = arguments[4]
            local x = arguments[5]
            local y = arguments[6]
            local z = arguments[7]
            local rotation = arguments[8]
            local interior = arguments[9]
            local dimension = arguments[10]
            local skin = arguments[11]
            local animation = arguments[12]
            local synced = arguments[13]
            local nametag = arguments[14]
            local frozen = arguments[15] == 1
            local comment = arguments[16]
            if not gender then
                gender = getRandomName("gender")
            end
            if not skin then
                if(gender == 0) then
                    skin = skinsMale[math.random(#skinsMale)]
                elseif(gender == 1) then
                    skin = skinsFemale[math.random(#skinsFemale)]
                end         
            end

            setElementPosition(element, x, y, z)
            setElementInterior(element, interior)
            setElementDimension(element, dimension)
            setElementRotation(element, 0, 0, rotation)
            setElementModel(element, skin)
            if not name then
                name = getRandomName("full",gender)
            end
            setElementData(element, "rpp.npc.name", tostring(name))
            setElementData(element, "rpp.npc.nametag", nametag)
            setElementData(element, "rpp.npc.behav", behaviour)
            setElementData(element, "rpp.npc.spawnpos", {x, y, z, rotation, interior, dimension})
            setElementData(element, "rpp.npc.spawnpos2", tostring(x)..","..tostring(y)..","..tostring(z)..","..tostring(rotation)..","..tostring(interior)..","..tostring(dimension))
            if(behav == 2) then
                giveWeapon(element, 22)
                setPedStat(element, 69, 999)
                setPedStat(element, 76, 999)
            else

            end
            --[[if(behav == 5) then
                local shape = createMarker(x, y, z, "cylinder", 20)
                setMarkerColor(shape, 0, 0, 0, 0)
                local result = addEventHandler("onMarkerHit", shape, npcEnterPCT)
                --outputDebugString(tostring(result).." ("..tostring(shape)..")")
                attachElements(shape, tempPeds[i], 0, 0, -1, 0, 0, 0)
            end--]]

            setElementFrozen(element, frozen)

            outputChatBox("Updated the temporary ped.", source, 0, 255, 0)
        else
            outputChatBox("No ped to edit.", source, 255, 0, 0)
        end
    end
end
addEvent("peds:saveeditped", true)
addEventHandler("peds:saveeditped", getRootElement( ), savePedToDB)

function hideMyID(thePlayer, command)
    if(exports.vrp_integration:isPlayerScripter(thePlayer)) then
        local hideMyID = getElementData(thePlayer, "hidemyid")
        if hideMyID then
            setElementData(thePlayer, "hidemyid", false)
            outputChatBox("Showing ID",thePlayer)
        else
            setElementData(thePlayer, "hidemyid", true)
            outputChatBox("Hiding ID",thePlayer)
        end
    end
end
addCommandHandler("hidemyid", hideMyID)

function giveFakeName(thePlayer, command)
    if(exports.vrp_integration:isPlayerScripter(thePlayer)) then
        local fakename = getElementData(thePlayer, "fakename")
        if fakename then
            setElementData(thePlayer, "fakename", false)
            outputChatBox("Fake name removed.",thePlayer)
        else
            local gender = tonumber(getElementData("gender",thePlayer)) or 0
            local fakenameName = getRandomName("full", gender)
            setElementData(thePlayer, "fakename", tostring(fakenameName))
            outputChatBox("Fake name set to "..tostring(fakenameName)..".",thePlayer)
        end
    end
end
addCommandHandler("givemefakename", giveFakeName)