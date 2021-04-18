addEvent ( "newtexture:showTextureSelection", true )
addEvent ( "newtexture:loadClientInteriorTexture", true )
addEvent ( "newtexture:removeClientInteriorTextures", true )

local frameGUI = { }
local shaders = { }
worldShaders = { }
local rendering = false
local selectedID = 1
local frameURL = ""
local sw, sh = guiGetScreenSize ( )
local visibleTextures = { }
local extensions = { 
	[".jpg"] = true,
	[".png"] = true,
}
local invalidModels = {
	--["fridge_1b"] = false,
	["radardisc"] = true,
	["shad_ped"] = true,
	["radar_north"] = true,
	["radar_centre"] = true,
	["shad_exp"] = true,
	["coronastar"] = true,
	["cloudmasked"] = true,
}

local KEYS =
{
	PREVIOUS = 'a',
	CONFIRM = 's',
	NEXT = 'd',
	CANCEL = 'w'
}


function frames_keySwitch ( key, state )
	if key == KEYS.PREVIOUS then -- Previous
		
				engineRemoveShaderFromWorldTexture ( shaders[localPlayer], visibleTextures[selectedID] )
			
				if selectedID > 1 then
					selectedID = selectedID - 1
				else
					selectedID = #visibleTextures
				end
		
	elseif key == KEYS.NEXT then -- Next
		
			engineRemoveShaderFromWorldTexture ( shaders[localPlayer], visibleTextures[selectedID] )
		
			if selectedID < #visibleTextures then
				selectedID = selectedID + 1
			else
				selectedID = 1

			end
	
	elseif key == KEYS.CONFIRM then -- Enter

			--buraya kaydetme gelecek.
			if isElement(checkWindow) then return end
			sW,sH = guiGetScreenSize()
			width,height = 350,120
			x,y = sW/2-350/2,sH/2-120/2
			checkWindow = guiCreateWindow(x,y,width,height,"Onay Penceresi",false)
			checkLabel = guiCreateLabel(8,25,width,height,"Texture uygulanacak, bu işlemi geri alamayacaksın\nEmin misin?",false,checkWindow)
	
			guiWindowSetMovable(checkWindow,false)
			guiWindowSetSizable(checkWindow,false)
			guiSetInputEnabled(true)

			okButton = guiCreateButton(5,80,160,30,"Kabul Et ("..price.."$)",false,checkWindow)
			closeButton = guiCreateButton(175,80,160,30,"Vazgeç",false,checkWindow)
			addEventHandler("onClientGUIClick",root,function(b,s)
				if b == "left" then	
					if source == closeButton then
						destroyElement(checkWindow)
						guiSetInputEnabled(false)
					elseif source == okButton then
						if exports["global"]:hasMoney(localPlayer,price) then
					
							if triggerServerEvent("newtexture:addOneTexture",localPlayer,localPlayer,imageSRC,visibleTextures[selectedID],price) then
								destroyElement(checkWindow)
								guiSetInputEnabled(false)
							end
						else
							outputChatBox("[!]#ffffff Yeterli paranız yok!",255,0,0,true)
						end
					end
				end
			end)

		
	elseif key == KEYS.CANCEL then
		frames_hidePreview ( )
	end
end
local font = dxCreateFont("files/2.ttf",9)
function frames_renderTextureSelection ( )
	dxDrawText ( selectedID .. "/" .. #visibleTextures .. ": " .. visibleTextures[selectedID].."\nGeri: A\nİleri: D\nKaydet: S\nÇıkış: W", 10, sh * 0.6, sw, sh, tocolor ( 255, 255, 255, 255 ), 1.0, font )
	int2 = getElementInterior(localPlayer)
	int2 = tonumber(int2)
	dim2 = getElementDimension(localPlayer)
	dim2 = tonumber(dim2)

	if isElement ( texture ) then
		engineApplyShaderToWorldTexture ( shaders[localPlayer], visibleTextures[selectedID], nil, true )
	end
	
end


function frames_hidePreview ( )
	rendering = false
	
	for _, v in pairs(KEYS) do
		unbindKey ( v, "down", frames_keySwitch )
	end
	setElementFrozen(localPlayer, false)
	
	engineRemoveShaderFromWorldTexture ( shaders[localPlayer], visibleTextures[selectedID] )
		toggleControl("walk",true)--jesse
	selectedID = 1
	
	if isElement ( texture ) then
		destroyElement ( texture )
	end
	
	removeEventHandler ( "onClientRender", root, frames_renderTextureSelection )
	triggerEvent("closeTexPanel",localPlayer,localPlayer,localPlayer)
end
addEvent("newtexture:hidePreview",true)
addEventHandler("newtexture:hidePreview",root,frames_hidePreview)

function frames_loadClientInteriorTexture ( imgData, textureName, interior )
	if not worldShaders[interior] then
		worldShaders[interior] = {
			textures = {
				{
					name = textureName,
					texture = dxCreateTexture ( imgData, "argb", true, "clamp", "2d", 1 ),
					shader = dxCreateShader ( "newtexture/texturechanger.fx", 1, 100, true, "world,object" ),
				},
			},
		}
	else
		table.insert ( worldShaders[interior].textures,
			{
				name = textureName,
				texture = dxCreateTexture ( imgData, "argb", true, "clamp", "2d", 1 ),
				shader = dxCreateShader ( "newtexture/texturechanger.fx", 1, 100, true, "world,object" ),
			}
		)
	end
	
	for i,v in ipairs ( worldShaders[interior].textures ) do
		local width, height = dxGetMaterialSize ( v.texture )
		
		if width > 1000 or height > 1000 then
			if exports.global:hasItem ( localPlayer, 4, interior ) or exports.global:hasItem ( localPlayer, 5, interior ) then
				outputChatBox ( "Not loading " .. v.name .. " as the width or height is greater than 1000px, please remove it with /texlist.", 255, 0, 0, false )
			end
			
			return
		end
		
		dxSetShaderValue ( v.shader, "Tex0", v.texture )
		engineApplyShaderToWorldTexture ( v.shader, v.name, nil, true )
	end
end

function frames_removeClientInteriorTextures ( dimension )
	if not worldShaders[dimension] then return end
	
	for i, _ in pairs ( worldShaders ) do
		--if i ~= dim then
			local textures = worldShaders[i].textures
			
			if not textures then return end
			
			for texIndex,v in ipairs ( textures ) do
				engineRemoveShaderFromWorldTexture ( v.shader, v.name )
				--outputDebugString ( "Removed " .. v.name )
				
				if isElement ( v.texture ) then 
					destroyElement ( v.texture )
				end
				
				if isElement ( v.shader ) then
					destroyElement ( v.shader )
				end
				
				worldShaders[i].textures[texIndex] = nil
			end
		--end
	end
end

addEventHandler ( "onClientRender", root,
	function ( )

		local dim = getElementDimension ( localPlayer )
		
		for i, _ in pairs ( worldShaders ) do
			if i ~= dim then -- delete the fucking textures
				local textures = worldShaders[i].textures
				
				if not textures then return end
				
				for texIndex,v in ipairs ( textures ) do
					engineRemoveShaderFromWorldTexture ( v.shader, v.name )
					--outputDebugString ( "Removed " .. v.name )
					
					if isElement ( v.texture ) then 
						destroyElement ( v.texture )
					end
					
					if isElement ( v.shader ) then
						destroyElement ( v.shader )
					end
					
					worldShaders[i].textures[texIndex] = nil
				end
			end
		end
	end )

function  openTextureEditor( imgData,yOffset, pricee )
	element = localPlayer
	local integration = exports.integration
	local global = exports.global
	local dimension = getElementDimension ( element )
		
	if dimension >= 1 or (integration:isPlayerLeadAdmin(element) and global:isAdminOnDuty(element)) or integration:isPlayerScripter(element) then
		if exports.global:hasItem ( element, 4, dimension ) or exports.global:hasItem ( element, 5, dimension ) or (integration:isPlayerAdmin(element) and global:isAdminOnDuty(element)) or (dimension==0) then
			rendering = not rendering
	
			if rendering then
				selectedID = 1
				visibleTextures = { }
				for _, name in ipairs ( engineGetVisibleTextureNames ( ) ) do
					if not invalidModels[name] then
						table.insert ( visibleTextures, name )
					end
				end
				newY = yOffset
				price = pricee
				imageSRC = imgData
				triggerEvent("openTexPanel",localPlayer,localPlayer)
				texture = dxCreateTexture ( imgData, "argb", true, "clamp", "2d", 1 )

				shaders[localPlayer] = dxCreateShader ( "newtexture/texturechanger.fx", 1, 100, true, "world,object" )
			--	if element == localPlayer then
					if shaders[localPlayer] then
						dxSetShaderValue ( shaders[localPlayer], "Tex0", texture )
						engineApplyShaderToWorldTexture ( shaders[localPlayer], visibleTextures[selectedID], nil, true )
						
							for _, v in pairs(KEYS) do
								bindKey ( v, "down", frames_keySwitch )
							end
							toggleControl("walk",false)--jesse
							setElementFrozen(element, true)
						
						addEventHandler ( "onClientRender", root, frames_renderTextureSelection )
					end
			--	end
			else
				frames_hidePreview ( )
			end
		else
			outputChatBox ( "You do not own this interior.", 255, 0, 0, false )
		end
	elseif dimension <= 0 then
		outputChatBox ( "You are not inside an interior.", 255, 0, 0, false )
	end
end


addEventHandler ( "newtexture:showTextureSelection", root,  openTextureEditor)
addEventHandler ( "newtexture:loadClientInteriorTexture", root, frames_loadClientInteriorTexture )
addEventHandler ( "newtexture:removeClientInteriorTextures", root, frames_removeClientInteriorTextures )

