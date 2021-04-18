integration = exports.vrp_integration -- Don't do stuff like this for too many resources cuz it requires a correct ordering of resources in mtaserver.cnf or else your script fails to work everytime server restarts. Can be annoying and impossible sometimes. / Maxime
global = exports.vrp_global
pool = exports.vrp_pool
items = exports['vrp_items']

local pending = {}
local added = {}
local addedServerOnly = {}
local addedElement = {}
local isInitializing = false
local clientsWaitingOnInitial = {}

local debugMode = false

addEventHandler('onResourceStart', resourceRoot,
	function()
		items = exports['vrp_items']
		pool = exports.vrp_pool


		isInitializing = true
		

		--local worldItems = pool:getPoolElementsByType("object")
		local worldItems = getElementsByType("object", getResourceRootElement(getResourceFromName("vrp_item_world")))
		--for k,v in ipairs(getElementsByType("object", getResourceRootElement(getResourceFromName("item-system")))) do
		--	table.insert(worldItems, v)
		--end
		--outputDebugString("item-texture: Loading textures for "..tostring(#worldItems).." world items")
		for k,v in ipairs(worldItems) do
			--if getElementParent(getElementParent(v)) == getResourceRootElement(getResourceFromName("item-world")) then
				local itemID = tonumber(getElementData(v, "itemID")) or 0
				if itemID > 0 then
					local itemValue = getElementData(v, "itemValue")
					local texture = items:getItemTexture(itemID, itemValue)
					if texture then
						for k2,v2 in ipairs(texture) do
							addTexture(v, v2[2], v2[1], true)
						end
					end
				end
			--end
		end
		local vehicles = pool:getPoolElementsByType("vehicle")
		for k,v in ipairs(vehicles) do
			local textures = getElementData(v, "textures")
			if textures then
				if type(textures) == "table" then
					for k2,v2 in ipairs(textures) do
						addTexture(v, v2[1], v2[2], true)
					end
				end
			end
		end
		
		--outputDebugString("item-texture: "..tostring(#clientsWaitingOnInitial).." clients waiting on initial sync.")
		isInitializing = false
		if clientsWaitingOnInitial then
			--outputDebugString("item-texture: "..tostring(#added).." textured elements were added for initial sync.")
			setTimer(triggerClientEvent, 2000, 1, clientsWaitingOnInitial, "item-texture:initialSync", resourceRoot, added)
			--triggerClientEvent(clientsWaitingOnInitial, 'item-texture:initialSync', resourceRoot, added)
		end
		clientsWaitingOnInitial = {}
	end)

function getPath(url)
	return 'cache/' .. md5(tostring(url)) .. '.tex'
end

-- loads a texture from url
function loadFromURL(element, texName, url)
	fetchRemote(url, function(str, errno)
			if str == 'ERROR' then
				outputDebugString('item-texture: loadFromURL - unable to fetch ' .. tostring(url))
			else
				local file = fileCreate(getPath(url))
				fileWrite(file, str)
				fileClose(file)

				if pending[url] then
					triggerLatentClientEvent(pending[url], 'item-texture:file', resourceRoot, element, texName, url, str, #str)
					pending[url] = nil
				end
			end
		end)
end

-- send frames to the client
addEvent( 'item-texture:stream', true )
addEventHandler( 'item-texture:stream', resourceRoot,
	function(element, texName, url)
		local path = getPath(url)
		if fileExists(path) then
			local file = fileOpen(path, true)
			if file then
				local size = fileGetSize(file)
				local content = fileRead(file, size)

				if #content == size then
					triggerLatentClientEvent(client, 'item-texture:file', resourceRoot, element, texName, url, content, size)
				else
					outputDebugString('item-texture:stream - file ' .. path .. ' read ' .. #content .. ' bytes, but is ' .. size .. ' bytes long')
				end
				fileClose(file)
			else
				outputDebugString('item-texture:stream - file ' .. path .. ' existed but could not be opened?')
			end
		else
			-- try to reload the file from the given url
			if pending[url] then
				table.insert(pending[url], client)
			else
				pending[url] = { client }
				loadFromURL(element, texName, url)
			end
		end
	end, false)

-- exported
function addTexture(element, texName, url, serverOnly)
	--outputDebugString("addTexture("..tostring(element)..", "..tostring(texName)..", "..tostring(url)..", "..tostring(serverOnly)..")")
	--TODO: Make it a way so we only add the texture for players that can see/is nearby the element, including a way to check for and add textures when player gets near a untextured element that should be textured
	table.insert(added, {element, texName, url})
	addedElement[element] = true
	if not serverOnly and not isInitializing then
		triggerClientEvent('item-texture:addOne', resourceRoot, element, texName, url)
	else
		--table.insert(addedServerOnly, {element, texName, url})
	end
end

function removeTexture(element, texName)
	for k,v in ipairs(added) do
		if texName then
			if v[1] == element and v[2] == texName then
				table.remove(added, k)
				addedElement[element] = nil
			end
		else
			if v[1] == element then
				table.remove(added, k)
				addedElement[element] = nil
			end
		end
	end
	triggerClientEvent('item-texture:removeOne', resourceRoot, element, texName)
end

addEventHandler("onElementDestroy", root, function()
	if addedElement[source] then
		removeTexture(source)
	end
end)

addEvent("item-texture:syncNewClient", true)
addEventHandler("item-texture:syncNewClient", root, function()
	if isInitializing then
		table.insert(clientsWaitingOnInitial, client)
	else
		triggerClientEvent(client, 'item-texture:initialSync', resourceRoot, added)
	end
end)