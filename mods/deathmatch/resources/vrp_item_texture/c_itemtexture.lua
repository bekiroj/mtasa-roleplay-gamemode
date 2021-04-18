--item-texture
--Script that handles texture replacements for world items
--Created by Exciter, 24.06.2014 (DD.MM.YYYY).
--Based upon iG texture-system (based on Exciter's uG/RPP texture-system) and OwlGaming/Cat's fixes to texture-system based on mabako-clothingstore. 

local loaded = {}
local streaming = {}
local unshaded = {}

local debugMode = false

function getPath(url)
	return '@cache/' .. md5(tostring(url)) .. '.tex'
end
local function isURL(url)
	if string.find(url, "http://", 1, true) then
		return true
	else
		return false
	end
end

function getStreamedInElements()
	local elements = {}
	for k,v in ipairs(getElementsByType("object")) do
		if isElementStreamedIn(v) then
			table.insert(elements, v)
		end
	end
	return elements
end

function addTexture(element, texName, url)
	if debugMode then
		outputDebugString("element='"..tostring(element).."' texName='"..tostring(texName).."' url='"..tostring(url).."'")
	end
	if not isElement(element) then return false end
	if not unshaded[element] then unshaded[element] = {} end
	if not isElementStreamedIn(element) then
		table.insert(unshaded[element], {texName, url})
		return true
	end
	if unshaded[element] then
		for k,v in ipairs(unshaded[element]) do
			if v[1] == texName then
				table.remove(unshaded[element], k)
			end
		end
	end
	if isURL(url) then --path is a URL (remote)
		if not streaming[element] then streaming[element] = {} end
		local path = getPath(url)
		if fileExists(path) then
			streaming[element][texName] = nil
			local data
			if loaded[element] then
				for k,v in ipairs(loaded[element]) do
					if v.texname == texName then
						data = v
						break
					end
				end
			end

			if data then --shader exist
				local shader = data.shader
				local oldTex = data.texture
				local newTex = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
				destroyElement(oldTex)
				data.texture = newTex
				dxSetShaderValue(shader, "gTexture", newTex)
			else
				local texture = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
				if texture then
					local shader, t = dxCreateShader('shaders/replacement.fx', 0, 0, true, 'world,object,vehicle')
					if shader then
						dxSetShaderValue(shader, 'Tex0', texture)
						engineApplyShaderToWorldTexture(shader, texName, element)
						if not loaded[element] then
							loaded[element] = {}
						end
						table.insert(loaded[element], { texname = texName, texture = texture, shader = shader, url = url })
					else
						outputDebugString('creating shader for tex ' .. texName .. ' failed.', 2)
						destroyElement(texture)
					end
				else
					outputDebugString('creating texture for tex ' .. texName .. ' failed', 2)
				end
			end
		else
			if not streaming[element][texName] then
				streaming[element][texName] = true
				triggerServerEvent('item-texture:stream', resourceRoot, element, texName, url)
			end
		end
	else --path is local file
		local path = url
		if fileExists(path) then
			local data
			if loaded[element] then
				for k,v in ipairs(loaded[element]) do
					if v.texname == texName then
						data = v
						break
					end
				end
			end

			if data then --shader exist
				local shader = data.shader
				local oldTex = data.texture
				local newTex = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
				destroyElement(oldTex)
				data.texture = newTex
				dxSetShaderValue(shader, "gTexture", newTex)
			else
				local texture = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
				if texture then
					local shader, t = dxCreateShader('shaders/replacement.fx', 0, 0, true, 'world,object,vehicle')
					if shader then
						dxSetShaderValue(shader, 'Tex0', texture)
						engineApplyShaderToWorldTexture(shader, texName, element)
						if not loaded[element] then
							loaded[element] = {}
						end
						table.insert(loaded[element], { texname = texName, texture = texture, shader = shader, url = url })
					else
						outputDebugString('creating shader for tex ' .. texName .. ' failed.', 2)
						destroyElement(texture)
					end
				else
					outputDebugString('creating texture for tex ' .. texName .. ' failed', 2)
				end
			end
		else
			outputDebugString("item-texture/c_textureitem: addTexture: local file '"..tostring(path).."' does not exist")
		end
	end
end

function removeTexture(element, texName)
	if texName then
		if unshaded[element] then
			local count = 0
			for k,v in ipairs(unshaded[element]) do
				if v[1] == texName then
					table.remove(unshaded[element], k)
					count = count + 1
				end
			end
			if count > 0 then
				return true
			end
		end
		local loadedEntryNum
		if loaded[element] then
			for k,v in ipairs(loaded[element]) do
				if v.texname == texName then
					data = v
					loadedEntryNum = k
					break
				end
			end
		end
		local result = engineRemoveShaderFromWorldTexture(data.shader, texName, element)
		destroyElement(data.texture)
		destroyElement(data.shader)
		table.remove(loaded[element], loadedEntryNum)
		return result
	else
		if unshaded[element] then unshaded[element] = nil return true end
		if loaded[element] then
			for k,v in ipairs(loaded[element]) do
				engineRemoveShaderFromWorldTexture(v.shader, texName, element)
				destroyElement(v.texture)
				destroyElement(v.shader)			
			end
			loaded[element] = nil
			return true
		end
	end
	return false
end

-- file we asked for is there
addEvent('item-texture:file', true)
addEventHandler( 'item-texture:file', resourceRoot,
	function(element, texName, url, content, size)
		local file = fileCreate(getPath(url))
		local written = fileWrite(file, content)
		fileClose(file)

		if written ~= size then
			fileDelete(getPath(url))
		else
			addTexture(element, texName, url)
		end
	end, false)

addEvent('item-texture:removeOne', true)
addEventHandler('item-texture:removeOne', resourceRoot,
	function(element, texName)
		removeTexture(element, texName)
	end, false)

addEvent('item-texture:addOne', true)
addEventHandler('item-texture:addOne', resourceRoot,
	function(element, texName, url)
		addTexture(element, texName, url)
	end)

function godebug(cmd)
	if exports.vrp_integration:isPlayerScripter(localPlayer) then
		debugMode = not debugMode
		outputChatBox("item-texture debug set to "..tostring(debugMode))
	end
end
addCommandHandler("debugitemtexture", godebug)

--[[
function checkElements()
	local elements = getStreamedInElements()
	for k,v in ipairs(elements) do
		if unshaded[v] and #unshaded[v] > 0 then
			for k2,v2 in ipairs(unshaded[v]) do
				addTexture(v, v2[1], v2[2])
			end
		end
	end
end
--will this lag? Be alert
streamingTimer = setTimer(checkElements, 3000, 0)
--]]

addEventHandler("onClientElementStreamIn", getRootElement(),
    function ( )
        local elementType = getElementType( source )
        if elementType == "object" or elementType == "vehicle" then
        	if unshaded[source] and #unshaded[source] > 0 then
				for k,v in ipairs(unshaded[source]) do
					if debugMode then
						outputDebugString("IN: "..tostring(elementType))
					end
					addTexture(source, v[1], v[2])
				end
        	end
        end
    end
);
addEventHandler("onClientElementStreamOut", getRootElement(),
    function ( )
       local elementType = getElementType( source )
       if elementType == "object" or elementType == "vehicle" then
        	if loaded[source] and #loaded[source] > 0 then
				for k,v in ipairs(loaded[source]) do
					local texname = v.texname
					local url = v.url
					if debugMode then
						outputDebugString("OUT: "..tostring(elementType))
					end
					removeTexture(source, texname)
					if not unshaded[source] then
						unshaded[source] = {}
					end
					table.insert(unshaded[source], {texname, url})
				end
        	end
        end
    end
);

addEvent('item-texture:initialSync', true)
addEventHandler('item-texture:initialSync', resourceRoot, function(cacheTable)
	outputDebugString("item-texture: You received initial sync for "..tostring(#cacheTable).." elements.")
	for k,v in ipairs(cacheTable) do
		addTexture(v[1], v[2], v[3])
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function(res)
	triggerServerEvent('item-texture:syncNewClient', resourceRoot)
end)