local mysql = exports.mysql
savedTextures = {}
integration = exports.integration
global = exports.global

addEventHandler("onPlayerInteriorChange", getRootElement( ),
	function( a, b, toDimension, toInterior)	
		if toDimension then
			triggerEvent("newtexture:loadInteriorTextures", source, getElementDimension(source))
		end
	end
)
addEventHandler("onPlayerSpawn", root,
	function()
		triggerEvent("newtexture:loadInteriorTextures", source, getElementDimension(source))
	end
)

function listenEvent(toDim)
	triggerEvent("newtexture:loadInteriorTextures", source, toDim)
end
addEventHandler("frames:loadInteriorTextures",root,listenEvent)

addEventHandler('onResourceStart', resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, row in ipairs(res) do
						row.interior = tonumber(row.interior)
						row.id = tonumber(row.id)
						if not savedTextures[row.interior] then
							savedTextures[row.interior] = {}
						end
						savedTextures[row.interior][row.id] = { id = row.id, texture = row.texture, url = row.url }
					end
				end
			end,
		mysql:getConnection(), "SELECT * FROM furnitures_texture")
	end
)



addEvent("newtexture:delete", true)
addEventHandler("newtexture:delete", resourceRoot,
	function(id)
		local interior = getElementDimension(client)
		if global:hasItem(client, 4, interior) or global:hasItem(client, 5, interior) or (integration:isPlayerAdmin(client) and global:isAdminOnDuty(client)) or (interior==0) then
			local data = savedTextures[interior]
			if not data or not data[id] then
				outputChatBox("This isn't even your texture?", client, 255, 0, 0)
			else
				local query = dbExec(mysql:getConnection(), "DELETE FROM interior_textures WHERE id = '" ..  ( id ) .. "' AND interior = '" .. ( interior ) .. "'")
				if query then
					outputChatBox("[!]#ffffff Texture başarıyla kaldırıldı. (ID #" .. id .. ").", client, 0, 255, 0,true)

					for k,v in ipairs(getElementsByType"player") do
						if getElementDimension(v) == interior then
							triggerClientEvent(v, 'newtexture:removeOne', resourceRoot, interior, id)
						end
					end

					local thisData = data[id]
				
					savedTextures[interior][id] = nil
				else
					outputChatBox("MySQL error: " .. id .. " // Contact the Jesse", client, 255, 0, 0)
				end
			end
		else
			outputChatBox("[!]#ffffff Anahtarın olmadan bu işlemi yapamazsın!", client, 255, 0, 0,true)
		end
	end
)

addEvent("newtexture:loadInteriorTextures", true)
addEventHandler("newtexture:loadInteriorTextures", root,
	function(dimension)
		triggerClientEvent(client or source, 'newtexture:list', resourceRoot, dimension, savedTextures[dimension])
	end
)

addEvent("newtexture:addOneTexture",true)
function newTexture(source, url, texture,price)
	local dimension = getElementDimension(source)

	if dimension >= 1 or (integration:isPlayerLeadAdmin(source) and global:isAdminOnDuty(source)) or integration:isPlayerScripter(source) then
		if global:hasItem(source, 4, dimension) or global:hasItem(source, 5, dimension) or (integration:isPlayerAdmin(source) and global:isAdminOnDuty(source)) or (dimension==0) then
			if savedTextures[dimension] then
				for k, v in pairs(savedTextures[dimension]) do
					if v.texture:lower() == texture:lower() then
						outputChatBox ( "[!]#ffffff Texture atmak istediğiniz alanda zaten texture var, kaldırmak için '/duvarkagidi'.", source, 255, 0, 0,true )
						return false
					end
				end
			end

			local id = dbExec(mysql:getConnection(), "INSERT INTO furnitures_texture SET interior = '" .. (dimension) .. "', texture = '" .. (texture) .. "', url = '" .. (url) .. "'")
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						local id = res[1]['id']
						if id then
							triggerClientEvent(source,"newtexture:hidePreview",source,source)
							local row = { id = id, texture = texture, url = url }
							if not savedTextures[dimension] then
								savedTextures[dimension] = {}
							end
							savedTextures[dimension][id] = row

							for k, v in ipairs(getElementsByType"player") do
								if getElementDimension(v) == dimension then
									triggerClientEvent(v, 'newtexture:addOne', resourceRoot, dimension, row)
								end
							end
							exports["global"]:takeMoney(source,price)
							outputChatBox ( "[!]#ffffff Texture başarıyla atıldı, kaldırmak için '/duvarkagidi'.", source, 0, 255, 0,true )
							return true
						end
					end
				end,
			mysql:getConnection(), "SELECT * FROM furnitures_texture WHERE id = LAST_INSERT_ID()")
		else
			outputChatBox("[!]#ffffff Bu mülkün sahibi sen değilsin!", source, 255, 0, 0, true)
			return false
		end
	else
		outputChatBox("[!]#ffffff Bu alana texture atılamaz!", source, 255, 0, 0, true)
		return false
	end
	return false
end
addEventHandler("newtexture:addOneTexture",root,newTexture)