addEvent('clothing:list', true)
addEventHandler('clothing:list', resourceRoot,
	function()
		if type(savedClothing) == 'table' then
			triggerLatentClientEvent(client, 'clothing:list', resourceRoot, savedClothing)
		else
			outputChatBox('Clothing list is currently not available.', client, 255, 0, 0)
		end
	end, false)

-- buying stuff
addEvent('clothing:buy', true)
addEventHandler('clothing:buy', resourceRoot,
	function(id)
		local clothing = savedClothing[id]
		if clothing and (canBuySkin(client, clothing) or canEdit(client)) then
			-- enough money to steal?
			if clothing.price == 0 or exports.vrp_global:hasMoney(client, clothing.price) then
				-- enough backpack space?
				if exports.vrp_global:giveItem(client, 16, clothing.skin .. ':' .. clothing.id) then
					outputChatBox('You purchased some clothing for $' .. exports.vrp_global:formatMoney(clothing.price) .. '.', client, 0, 255, 0)

					-- take & give some money
					if clothing.price > 0 then
						exports.vrp_global:takeMoney(client, clothing.price)

						local dimension = getElementDimension(client)
						if dimension > 0 then
							exports.vrp_global:giveMoney(exports.vrp_factions:getTeamFromFactionID(55), clothing.price)
						end
					end
				else
					outputChatBox('You do not have enough space in your inventory.', client, 255, 0, 0)
				end
			else
				outputChatBox('You do not have the required $' .. exports.vrp_global:formatMoney(clothing.price) .. '.', client, 255, 0, 0)
			end
		end
	end, false)

-- saving new or old clothes
addEvent('clothing:save', true)
addEventHandler('clothing:save', resourceRoot,
	function(values)
		if canEdit(client) then
			if not values.id then
				-- new clothing stuff
				dbExec(mysql:getConnection(), "INSERT INTO clothing (skin, url, description, price) VALUES (" .. tonumber(values.skin) .. ", '" .. (values.url) .. "', '" .. (values.description) .. "', " .. tonumber(values.price) .. ")")
				dbQuery(
					function(qh, client)
						local res, rows, err = dbPoll(qh, 0)
						local values = res[1]	
						if values.id then
							savedClothing[values.id] = values
							outputChatBox('Clothes added.', client, 0, 255, 0)
						else
							outputChatBox('Unable to add clothes.', client, 255, 0, 0)
						end
					end,
				{client}, mysql:getConnection(), "SELECT * FROM clothing WHERE id = LAST_INSERT_ID()")
			else
				-- old clothing stuff
				local existing = savedClothing[values.id]
				if existing then
					if dbExec(mysql:getConnection(), 'UPDATE clothing SET skin = ' .. tonumber(values.skin) .. ', description = "' .. (values.description) .. '", price = ' .. tonumber(values.price) .. ' WHERE id = ' .. tonumber(values.id)) then
						--url = "' .. (values.url) .. '",
						outputChatBox('Saved clothing.', client, 0, 255, 0)

						existing.skin = tonumber(values.skin)
						--existing.url = tostring(values.url)
						existing.description = tostring(values.description)
						existing.price = tonumber(values.price)
					else
						outputChatBox('Clothes couldn\'t be saved.', client, 255, 0, 0)
					end
				else
					outputChatBox('Unable to find clothes?', client, 255, 0, 0)
				end
			end
		end
	end, false)

addEvent('clothing:delete', true)
addEventHandler('clothing:delete', resourceRoot,
	function(id)
		if canEdit(client) and type(id) == 'number' and savedClothing[id] then
			dbExec(mysql:getConnection(), 'DELETE FROM clothing WHERE id = ' .. tonumber(id))
			savedClothing[id] = nil

			local path = getPath(id)
			if fileExists(path) then
				fileDelete(path)
			end

			outputChatBox('Clothing deleted.', client, 0, 255, 0)
		end
	end, false)
