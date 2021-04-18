function createItem(id, itemID, itemValue, ...)
	local o = createObject(...)
	if o then
		anticheat:changeProtectedElementDataEx(o, "id", id)
		anticheat:changeProtectedElementDataEx(o, "itemID", itemID)
		anticheat:changeProtectedElementDataEx(o, "itemValue", itemValue, itemValue ~= 1)

		local scale = items:getItemScale(itemID)
		if scale then
			setObjectScale(o, scale)
		end
		local dblSided = items:getItemDoubleSided(itemID)
		if dblSided then
			setElementDoubleSided(o, dblSided)
		end
		local texture = items:getItemTexture(itemID, itemValue)
		if texture then
			for k,v in ipairs(texture) do
				itemtexture:addTexture(o, v[2], v[1])
			end
		end

		return o
	else
		if dbExec(mysql:getConnection(),"DELETE FROM `worlditems` WHERE `id` = '" .. (id).."'" ) then
			outputDebugString("Deleted bugged Item ID #"..id)
		else
			outputDebugString("Failed to delete bugged Item ID #"..id)
		end
		return false
	end
end

function updateItemValue(element, newValue)
	if getElementParent(getElementParent(element)) == getResourceRootElement(getThisResource()) then
		local id = tonumber(getElementData(element, "id")) or 0
		if dbExec(mysql:getConnection(),"UPDATE `worlditems` SET `itemvalue`='"..(tostring(newValue)).."' WHERE `id`='"..(tostring(id)).."'") then
			anticheat:changeProtectedElementDataEx(element, "itemValue", newValue)
			return true
		end
	end
	return false
end

function setData(element, key, value)
	if getElementParent(getElementParent(element)) == getResourceRootElement(getThisResource()) then
		local id = tonumber(getElementData(element, "id")) or 0
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					result = dbExec(mysql:getConnection(),"UPDATE `worlditems_data` SET `value`='"..(tostring(valueInsert)).."' WHERE `item`='"..(tostring(id)).."' AND `key`='"..(tostring(key)).."'")
					if result then
						anticheat:changeProtectedElementDataEx(element, "worlditemData."..tostring(key), value)
						return true
					end
				else
					result = dbExec(mysql:getConnection(),"INSERT INTO `worlditems_data` (`item`, `key`, `value`) VALUES ('"..(tostring(id)).."', '"..(tostring(key)).."', '"..(tostring(valueInsert)).."');")
					if result then
						anticheat:changeProtectedElementDataEx(element, "worlditemData."..tostring(key), value)
						return true
					end
				end
			end,
		mysql:getConnection(), "SELECT `id` FROM `worlditems_data` WHERE `item`='"..(tostring(id)).."' AND `key`='"..(tostring(key)).."' LIMIT 1")
	end
	return false
end

function getData(element, key, format)
	if getElementParent(getElementParent(element)) == getResourceRootElement(getThisResource()) then
		if getElementData(element, "worlditems.loaded.data."..tostring(key)) then
			return getElementData(element, "worlditemData."..tostring(key)) or false
		else
			return getDataFromDB(element, key, format)
		end
	end
	return false
end

function getDataFromDB(element, key, format)
	if getElementParent(getElementParent(element)) ~= getResourceRootElement(getThisResource()) then
		return false
	end
	id = tonumber(getElementData(element, "id")) or 0
	if id < 1 then return false end
	local value
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					value = row.value
					if value and format then
						if format == "table" or format == "json" then
							value = fromJSON(value)
						elseif format == "number" then
							value = tonumber(value)
						elseif format == "bool" or format == "boolean" then
							if type(value) == "string" then
								if value == "false" then
									value = false
								elseif value == "true" then
									value = true
								end
							else
								value = false
							end
						end
					end
					anticheat:changeProtectedElementDataEx(element, "worlditemData."..tostring(key), value)
					anticheat:changeProtectedElementDataEx(element, "worlditems.loaded.data."..tostring(key), true)
				end
			end
		end,
	mysql:getConnection(), "SELECT `value` FROM `worlditems_data` WHERE `item`='"..(tostring(id)).."' AND `key`='"..(tostring(key)).."' LIMIT 1")

	return value
end

function getAllDataFromDB(id, element)
	if element then
		if getElementParent(getElementParent(element)) ~= getResourceRootElement(getThisResource()) then
			return false
		end
	end
	if not id and element then
		id = tonumber(getElementData(element, "id")) or 0
		if id < 1 then return false end
	end
	if not id then return false end
	local table = {}
	dbQuery(
		function(qh, element)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					table[tostring(row.key)] = row.value
					if element then
						anticheat:changeProtectedElementDataEx(element, "worlditemData."..tostring(row.key), row.value)
					end
				end
			end
		end,
	{element}, mysql:getConnection(), "SELECT `key`, `value` FROM `worlditems_data` WHERE `item`='"..(tostring(id)).."'")
	return table
end

function setPermissions(element, permissions)
	if getElementParent(getElementParent(element)) == getResourceRootElement(getThisResource()) then
		local id = tonumber(getElementData(element, "id")) or 0
		result = dbExec(mysql:getConnection(),"UPDATE `worlditems` SET `perm_use`='"..(tostring(permissions.use)).."', `perm_move`='"..(tostring(permissions.move)).."', `perm_pickup`='"..(tostring(permissions.pickup)).."', `perm_use_data`='"..(tostring(toJSON(permissions.useData))).."', `perm_move_data`='"..(tostring(toJSON(permissions.moveData))).."', `perm_pickup_data`='"..(tostring(toJSON(permissions.pickupData))).."' WHERE `id`='"..(tostring(id)).."'")
		if result then
			anticheat:changeProtectedElementDataEx(element, "worlditem.permissions", permissions)
			return true
		end
	end
	return false
end

function getPermissions(element)
	if getElementParent(getElementParent(element)) == getResourceRootElement(getThisResource()) then
		local perm = getElementData(element, "worlditem.permissions")
		if perm then
			return perm
		else
			return getPermissionsFromDB(element)
		end
	end
	return false
end

function getPermissionsFromDB(element)
	if getElementParent(getElementParent(element)) ~= getResourceRootElement(getThisResource()) then
		return false
	end
	id = tonumber(getElementData(element, "id")) or 0
	if id < 1 then return false end
	local permissions
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					permissions = { use = tonumber(row.perm_use), move = tonumber(row.perm_move), pickup = tonumber(row.perm_pickup), useData = fromJSON(row.perm_use_data), moveData = fromJSON(row.perm_move_data), pickupData = fromJSON(row.perm_pickup_data) }
				end
				anticheat:changeProtectedElementDataEx(element, "worlditem.permissions", permissions)
			end
		end,
	mysql:getConnection(), "SELECT `perm_use`, `perm_move`, `perm_pickup`, `perm_use_data`, `perm_move_data`, `perm_pickup_data` FROM `worlditems` WHERE `id`='"..(tostring(id)).."' LIMIT 1")
	return permissions
end