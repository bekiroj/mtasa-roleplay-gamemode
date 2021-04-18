local mysql = exports.vrp_mysql
savedTextures = {}
integration = exports.vrp_integration
global = exports.vrp_global
textureItemID = 147

addEventHandler('onResourceStart', resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				for i, row in ipairs(res) do
					row.interior = tonumber(row.interior)
					row.id = tonumber(row.id)
					if not savedTextures[row.interior] then
						savedTextures[row.interior] = {}
					end
					savedTextures[row.interior][row.id] = { id = row.id, texture = row.texture, url = row.url }
				end
			end,
		mysql:getConnection(), "SELECT * FROM interior_textures")	
	end
)

--
function getPath(url)
	return 'cache/' .. md5(tostring(url)) .. '.tex'
end

-- loads a skin from an url
function loadFromURL(url, interior, id)
	fetchRemote(url, function(str, errno)
			if str == 'ERROR' then
				outputDebugString('texture:stream - unable to fetch ' .. url)
			else
				local file = fileCreate(getPath(url))
				fileWrite(file, str)
				fileClose(file)

				local data = savedTextures[interior][id]
				if data and data.pending then
					triggerLatentClientEvent(data.pending, 'frames:file', resourceRoot, id, url, str, #str)
					data.pending = nil
				end
			end
		end)
end


-- send frames to the client
addEvent( 'frames:stream', true )
addEventHandler( 'frames:stream', resourceRoot,
	function(interior, id)
		local interior = tonumber(interior)
		local id = tonumber(id)
		-- if its not a number, this'll fail
		if type(id) == 'number' and type(interior) == 'number' then
			local data = savedTextures[interior] and savedTextures[interior][id]
			if data then
				local path = getPath(data.url)
				if fileExists(path) then
					local file = fileOpen(path, true)
					if file then
						local size = fileGetSize(file)
						if tonumber(size) then
							local content = fileRead(file, size)

							if #content == size then
								triggerLatentClientEvent(client, 'frames:file', resourceRoot, id, data.url, content, size)
							else
								outputDebugString('frames:stream - file ' .. path .. ' read ' .. #content .. ' bytes, but is ' .. size .. ' bytes long')
							end
							fileClose(file)
						end
					else
						outputDebugString('frames:stream - file ' .. path .. ' existed but could not be opened?')
					end
				else
					-- try to reload the file from the given url
					if data.pending then
						table.insert(data.pending, client)
					else
						data.pending = { client }
						loadFromURL(data.url, interior, id)
					end
				end
			else
				outputDebugString('frames:stream - frames #' .. interior .. '/' .. id .. ' do not exist.')
			end
		end
	end, false)

--

addEvent("frames:loadInteriorTextures", true)
addEventHandler("frames:loadInteriorTextures", root,
	function(dimension)
		triggerClientEvent(client or source, 'frames:list', resourceRoot, dimension, savedTextures[dimension])
	end)

--

addEvent("frames:delete", true)
addEventHandler("frames:delete", resourceRoot,
	function(id)
		local interior = getElementDimension(client)
		if global:hasItem(client, 4, interior) or global:hasItem(client, 5, interior) or (integration:isPlayerAdmin(client) and global:isAdminOnDuty(client)) or (interior==0) then
			local data = savedTextures[interior]
			if not data or not data[id] then
				outputChatBox("This isn't even your texture?", client, 255, 0, 0)
			else
				local success = dbExec(mysql:getConnection(), "DELETE FROM interior_textures WHERE id = '" ..  ( id ) .. "' AND interior = '" .. ( interior ) .. "'" )
				if success then
					outputChatBox("Deleted Texture with ID " .. id .. ".", client, 0, 255, 0)

					-- sorta tell everyone who is inside
					for k,v in ipairs(getElementsByType"player") do
						if getElementDimension(v) == interior then
							triggerClientEvent(v, 'frames:removeOne', resourceRoot, interior, id)
						end
					end

					local thisData = data[id]
					--give the removed texture as a picture frame item with the same values
					exports['vrp_items']:giveItem(client, textureItemID, tostring(thisData.url)..";"..tostring(thisData.texture))

					savedTextures[interior][id] = nil
				else
					outputChatBox("Failed to remove texture ID " .. id .. ".", client, 255, 0, 0)
				end
			end
		else
			outputChatBox("You need a key.", client, 255, 0, 0)
		end
	end)

-- exported
function newTexture(source, url, texture)
	local dimension = getElementDimension(source)
	if dimension >= 1 or (integration:isPlayerLeadAdmin(source) and global:isAdminOnDuty(source)) or integration:isPlayerScripter(source) then
		if global:hasItem(source, 4, dimension) or global:hasItem(source, 5, dimension) or (integration:isPlayerAdmin(source) and global:isAdminOnDuty(source)) or (dimension==0) then
			-- check if said texture is already replaced
			if savedTextures[dimension] then
				for k, v in pairs(savedTextures[dimension]) do
					if v.texture:lower() == texture:lower() then
						outputChatBox('This texture is already replaced, please remove it first with /texlist.', source, 255, 0, 0)
						return false
					end
				end
			end

            local id = dbExec(mysql:getConnection(), "INSERT INTO interior_textures SET interior = '" .. (dimension) .. "', texture = '" .. (texture) .. "', url = '" .. (url) .. "'")
            if id then
                dbQuery(
                    function(qh)
                        local res, rows, err = dbPoll(qh, 0)
                        if rows > 0 then
                            local id = res[1].id
                            if id then
                                local row = { id = id, texture = texture, url = url }
                                if not savedTextures[dimension] then
                                    savedTextures[dimension] = {}
                                end
                                savedTextures[dimension][id] = row
                
                                for k, v in ipairs(getElementsByType"player") do
                                    if getElementDimension(v) == dimension then
                                        triggerClientEvent(v, 'frames:addOne', resourceRoot, dimension, row)
                                    end
                                end
                
                                outputChatBox ( "Texture successfully replaced!", source, 0, 255, 0 )
                            end
                        end
                    end,
                mysql:getConnection(), "SELECT id FROM interior_textures WHERE id=LAST_INSERT_ID()")
			
				return true
			end
			outputChatBox ( "Failed to replace texture.", source, 255, 0, 0 )
			return false
		else
			outputChatBox("You do not own this interior.", source, 255, 0, 0, false)
			return false
		end
	else
		outputChatBox("You need to be in an interior to retexture.", source, 255, 0, 0, false)
		return false
	end
	return false
end
