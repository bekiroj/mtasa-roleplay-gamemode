savedTextures = {}
local loaded = {}
local streaming = {}


--dbid, dimension, resim url'si, import edeceği texture.
function addTexture(id)
	-- current dimension?
	local dimension = getElementDimension(localPlayer)
	local data = savedTextures[dimension] and savedTextures[dimension][id]
	if not data then return end

	local path = data.url

		streaming[id] = nil

		
	local texture = dxCreateTexture(path, "argb", true, "clamp", "2d", 1)
	if texture then
		local shader, t = dxCreateShader('newtexture/texturechanger.fx', 0, 0, true, 'world,object')
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
end

addEvent('newtexture:list', true)
addEventHandler('newtexture:list', resourceRoot,
	function(dimension, textures)
		outputDebugString('received updated texture list')
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

addEvent('newtexture:removeOne', true)
addEventHandler('newtexture:removeOne', resourceRoot,
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
addEvent('newtexture:addOne', true)
addEventHandler('newtexture:addOne', resourceRoot,
	function(dimension, data)
		if not savedTextures[dimension] then
			savedTextures[dimension] = {}
		end
		savedTextures[dimension][data.id] = data
		addTexture(data.id)
	end)


local sw, sh = guiGetScreenSize ( )
local gui = { }
localPlayer = getLocalPlayer()

function frames_showTexGUI ( )
	local interiorID = getElementDimension ( localPlayer )
	
	if interiorID >= 1 or (exports.integration:isPlayerSeniorAdmin(localPlayer) and exports.global:isAdminOnDuty(localPlayer)) or exports.integration:isPlayerScripter(localPlayer) then
		if exports.global:hasItem ( localPlayer, 4, interiorID ) or exports.global:hasItem ( localPlayer, 5, interiorID ) or (exports.integration:isPlayerAdmin(localPlayer) and exports.global:isAdminOnDuty(localPlayer)) or (interiorID==0) then
			if not gui.window then
				addEventHandler("onClientRender",root,checkImage)
				local width = 300
				local height = 420
				local x = ( sw - width ) / 2
				local y = ( sh - height ) / 2
				
				local windowTitle = "Mülk Kaplamaları - Mülk ID: #" .. interiorID
				if(not exports.global:hasItem(localPlayer, 4, interiorID) and not exports.global:hasItem(localPlayer, 5, interiorID)) then
					windowTitle = "Mülk Kaplamaları - Mülk ID: #" .. interiorID.." (Yetkili İzni)"
				end
				gui.window = guiCreateWindow ( x, y, width, height+10, windowTitle, false )
				guiWindowSetMovable(gui.window,false)
				guiWindowSetSizable(gui.window,false)
				guiSetEnabled(gui.window,false)
				openLibrary("convert",gui.window)
				gui.list = guiCreateGridList ( x+10, y+25, width - 20, height - 90, false, false )
				
				gui.remove = guiCreateButton ( x+10, y+height - 60, width - 20, 25, "Seçilen Kaplamayı Kaldır", false, false )
				setElementData(gui.remove,"child",true)
				gui.cancel = guiCreateButton ( x+10, y+height - 30, width - 20, 25, "İptal", false, false )
				setElementData(gui.cancel,"child",true)
				
				guiGridListAddColumn ( gui.list, "ID", 0.1 ) 
				guiGridListAddColumn ( gui.list, "Texture", 0.7) 
				--guiGridListAddColumn ( gui.list, "Kaynak", 0.8 ) 

	
				guiSetEnabled ( gui.remove, false )
				showCursor ( true )
				
				frames_fillTexList( savedTextures[getElementDimension(localPlayer)] or {})
				
				addEventHandler ( "onClientGUIClick", root, frames_texWindowClick )
			else
				frames_hideTexGUI ( )
			end
		else
			outputChatBox ( "You do not own this interior.", 255, 0, 0, false )
		end
	else
		outputChatBox ( "You are not inside an interior.", 255, 0, 0, false )
	end
end


function frames_texWindowClick ( button, state )
	if button == "left" and state == "up" then
		if source == gui.cancel then
			frames_hideTexGUI ( )
			
		elseif source == gui.list then
			local texID = guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 )
			
			if texID ~= "" then
				guiSetEnabled ( gui.remove, true )
			else
				guiSetEnabled ( gui.remove, false )
			end
		elseif source == gui.remove then
			local texID = guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 )
			
			if texID ~= "" then
				frames_hideTexGUI ( )
				triggerServerEvent ( "newtexture:delete", resourceRoot, tonumber( texID ) )
			end
		end
	end
end

function frames_hideTexGUI ( )
	if gui.window then
		destroyElement ( gui.window )
		gui.window = nil
		destroyElement(gui.remove)
		destroyElement(gui.list)
		destroyElement(gui.cancel)
		removeEventHandler("onClientRender",root,checkImage)
		showCursor ( false )
	end
end

function checkImage()
if guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 ) ~= "" then
	dxDrawImage(sw-135,sh/2-128/2,128,128,guiGridListGetItemData(gui.list,guiGridListGetSelectedItem ( gui.list ),1))
end
end

function frames_fillTexList ( texList )
	if gui.list then
		guiGridListClear ( gui.list )
	end
	
	local any = false
	for _, tex in pairs ( texList ) do
		any = true
		local row = guiGridListAddRow ( gui.list )
		
		guiGridListSetItemText ( gui.list, row, 1, tex.id, false, false )
		guiGridListSetItemData ( gui.list, row, 1, tex.url)
		guiGridListSetItemText ( gui.list, row, 2, tex.texture, false, false )
		--guiGridListSetItemText ( gui.list, row, 3, tex.url, false, false )
	end

	if not any then
		guiGridListSetItemText ( gui.list, guiGridListAddRow ( gui.list ), 1, "None", true, false )
		return
	end
end

addCommandHandler ( "duvarkagidi", frames_showTexGUI )
