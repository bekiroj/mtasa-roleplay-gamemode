local mysql = exports.vrp_mysql
local bone = exports.vrp_bone_attach
local playerWearables = {};

addEventHandler("onResourceStart", resourceRoot,
    function()
        for index, player in ipairs(getElementsByType("player")) do
            playerWearables[player] = {}
            player:setData("usingArtifacts", {})
        end
    end
);

addEventHandler("onPlayerJoin", root,
    function()
        playerWearables[source] = {}
        source:setData("usingArtifacts", {})
    end
);

addEventHandler("onPlayerQuit", root,
    function()
        for index, value in ipairs(playerWearables[source]) do
            if isElement(value['object']) then
                value['object']:destroy();
            end
        end
        playerWearables[source] = {}
    end
)

function addWearablePlayer(player, temp_table)
    if tonumber(player:getData("loggedin")) == 1 then
        x, y, z = player.position
        createdObject = Object(temp_table.model, x, y, z);
        createdObject:setData("dbid", temp_table.id)
        createdObject:setScale(temp_table.sx, temp_table.sy, temp_table.sz);
        createdObject.interior = player.interior;
        createdObject.dimension = player.dimension;

        bone:attachElementToBone(createdObject, player, temp_table.bone, temp_table.x, temp_table.y, temp_table.z, temp_table.rx, temp_table.ry, temp_table.rz);
        
        playerWearables[player][#playerWearables[player] + 1] = {
            ['id'] = temp_table.id,
            ['object'] = createdObject,
            ['model'] = createdObject.model,
            ['data'] = {temp_table.bone, temp_table.x, temp_table.rx, temp_table.ry, temp_table.rz},
        };
      	usingArtifacts = player:getData("usingArtifacts") or {}
      	table.insert(usingArtifacts, {temp_table.id});
      	player:setData("usingArtifacts", usingArtifacts)
        setElementData(player, "playerWearables", playerWearables[player]);
    end
end

function removeWearableToPlayer(player, object)
    if tonumber(player:getData("loggedin")) == 1 then
        if isElement(object) then

            usingArtifacts = player:getData("usingArtifacts")
            for index, value in ipairs(usingArtifacts) do
                if getElementData(object, "dbid") == value then
                    usingArtifacts[index] = nil
                    table.remove(usingArtifacts, index)
                end
            end

            for index, value in ipairs(playerWearables[player]) do
                if value['object'] == object then
                    table.remove(playerWearables[player], index);
                end
            end
           
            player:setData("usingArtifacts", usingArtifacts)
            bone:detachElementFromBone(object);
            object:destroy();
            setElementData(player, "playerWearables", playerWearables[player]);
        end
    end
end

addEventHandler("onPlayerQuit", root,
    function()
        for index, value in ipairs(playerWearables[source]) do
            if isElement(value['object']) then
               value['object']:destroy();
            end
        end
        playerWearables[source] = {};
    end
);

addEventHandler("accounts:characters:change", root,
    function()
        for index, value in ipairs(playerWearables[source]) do
            if isElement(value['object']) then
                value['object']:destroy();
            end
        end
        playerWearables[source] = {};
    end
);

addEvent("wearable.updatePosition", true)
addEventHandler("wearable.updatePosition", root,
    function(object, int, dim)
        object.interior = int;
        object.dimension = dim;
    end
);

addEvent("wearable.delete", true)
addEventHandler("wearable.delete", root,
    function(player, dbid)
        dbExec(mysql:getConnection(), "DELETE FROM `wearables` WHERE `id` = ?", dbid)
        loadPlayerWearables(player);
        outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Seçili aksesuar başarıyla silindi.", player, 255, 255, 255, true)
    end
)

addEvent("wearable.savePositions", true)
addEventHandler("wearable.savePositions", root,
    function(player, data)
        local self = {};
        self.x, self.y, self.z, self.rx, self.ry, self.rz, self.sx, self.sy, self.sz, self.bone, self.dbid = data['position'][1], data['position'][2], data['position'][3], data['position'][4], data['position'][5], data['position'][6], data['position'][7], data['position'][8], data['position'][9], data['bone'], data['dbid']
    
        dbExec(mysql:getConnection(), "UPDATE `wearables` SET `x` = ?, `y` = ?, `z` = ?, `rx` = ?, `ry` = ?, `rz` = ?, `sx` = ?, `sy` = ?, `sz` = ?, `bone` = ? WHERE `id` = ?", self.x, self.y, self.z, self.rx, self.ry, self.rz, self.sx, self.sy, self.sz, self.bone, self.dbid)

        outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Aksesuarınızın pozisyonu başarıyla kaydedildi!", player, 255, 255, 255, true)
        loadPlayerWearables(player);
    end
);

addEvent("wearable.useArtifact", true)
addEventHandler("wearable.useArtifact", root,
    function(player, data)
        addWearablePlayer(player, data)
    end
);

addEvent("wearable.detachArtifact", true)
addEventHandler("wearable.detachArtifact", root,
    function(player, data)
        for index, value in ipairs(playerWearables[player]) do
            if (tonumber(value.model) == tonumber(data.model)) then
                removeWearableToPlayer(player, value.object);
            end
        end
    end
);

function loadPlayerWearables(player)
    local pWearables = {};
    dbQuery(
        function(qh)
            local res, query_lines, err = dbPoll(qh, 0);
            if query_lines > 0 then
                thread:foreach(res, function(v)
                    local id = tonumber(v.id)
                    local objectID = tonumber(v.model)
                    local owner = tonumber(v.owner);
                    local bone = tonumber(v.bone);
                    local x = tonumber(v.x);
                    local y = tonumber(v.y);
                    local z = tonumber(v.z);
                    local rx = tonumber(v.rx);
                    local ry = tonumber(v.ry);
                    local rz = tonumber(v.rz);
                    local sx = tonumber(v.sx);
                    local sy = tonumber(v.sy);
                    local sz = tonumber(v.sz);
                    pWearables[#pWearables + 1 ] = {
                        ['id'] = id, 
                        ['model'] = objectID, 
                        ['owner'] = owner, 
                        ['bone'] = bone, 
                        ['x'] = x, 
                        ['y'] = y, 
                        ['z'] = z, 
                        ['rx'] = rx, 
                        ['ry'] = ry, 
                        ['rz'] = rz, 
                        ['sx'] = sx, 
                        ['sy'] = sy, 
                        ['sz'] = sz
                    };
                    --addWearablePlayer(player, {objectID, bone, x, y, z, rx, ry, rz});
                end)
                triggerClientEvent(player, "wearable.loadWearables", player, pWearables);
            end
        end,
    mysql:getConnection(), "SELECT * FROM `wearables` WHERE `owner` = ?", player:getData("dbid"));
end
addEvent("wearable.loadMyWearables", true)
addEventHandler("wearable.loadMyWearables", root, loadPlayerWearables)