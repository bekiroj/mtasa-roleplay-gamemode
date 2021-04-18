savedTextures = {}
local loaded = {}
local streaming = {}

local function getPath(url)
	return '@cache/' .. md5(tostring(url)) .. '.tex'
end

function addTexture(id)
	-- current dimension?
	local dimension = getElementDimension(localPlayer)
	local data = savedTextures[dimension] and savedTextures[dimension][id]
	if not data then return end

	local path = getPath(data.url)
	if fileExists(path) then
		streaming[id] = nil

		-- file available locally, just need to really create it
		local texture = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
		if texture then
			local shader, t = dxCreateShader('shaders/replacement.fx', 0, 0, true, 'world,object')
			if shader then
				dxSetShaderValue(shader, 'Tex0', texture)

				local texName = data.texture
				engineApplyShaderToWorldTexture(shader, texName)

				loaded[id] = { texture = texture, shader = shader }
			else
				outputDebugString('creating shader for tex ' .. data.texture .. ' failed.', 2)
				destroyElement(texture)
			end
		else
			outputDebugString('creating texture for tex ' .. data.texture .. ' failed', 2)
		end
	else
		if not streaming[id] then
			streaming[id] = true
			triggerServerEvent('frames:stream', resourceRoot, dimension, id)
		end
	end
end

addEvent('frames:list', true)
addEventHandler('frames:list', resourceRoot,
	function(dimension, textures)
		-- outputDebugString('received updated texture list')
		savedTextures[dimension] = textures

		-- remove all current textures
		for k, v in pairs(loaded) do
			destroyElement(v.texture)
			destroyElement(v.shader)
		end
		loaded = {}

		-- applying all possible textures
		if getElementDimension(localPlayer) == dimension and textures then
			for k in pairs(textures) do
				addTexture(k)
			end
		end
	end)

-- file we asked for is there
addEvent('frames:file', true)
addEventHandler( 'frames:file', resourceRoot,
	function(id, url, content, size)
		local file = fileCreate(getPath(url))
		local written = fileWrite(file, content)
		fileClose(file)

		if written ~= size then
			fileDelete(getPath(url))
		else
			addTexture(id)
		end
	end, false)

addEvent('frames:removeOne', true)
addEventHandler('frames:removeOne', resourceRoot,
	function(interior, id)
		local v = loaded[id]
		if v then
			destroyElement(v.texture)
			destroyElement(v.shader)

			loaded[id] = nil
		end

		local data = savedTextures[interior]
		if data then
			data[id] = nil
		end
	end, false)

addEvent('frames:addOne', true)
addEventHandler('frames:addOne', resourceRoot,
	function(dimension, data)
		if not savedTextures[dimension] then
			savedTextures[dimension] = {}
		end
		savedTextures[dimension][data.id] = data
		addTexture(data.id)
	end)
