--Vehicle textures
--Script that handles texture replacements for vehicles
--Created by Exciter, 01.01.2015 (DD.MM.YYYY).

local vehicle = nil

local extraVehTexNames = {
	[596] = {"vehiclepoldecals128","vehiclepoldecals128lod"},
	[597] = {"vehiclepoldecals128","vehiclepoldecals128lod"},
	[598] = {"vehiclepoldecals128","vehiclepoldecals128lod"},
}

local gui = {}
function vehTex_showGui(editVehicle)
	if gui.window then
		vehTex_hideGui()
	end

	vehicle = editVehicle
	if not vehicle then
		outputDebugString("item-texture/c_vehtex: No vehicle given")
		return false
	end

	local sw, sh = guiGetScreenSize()
	local width = 600
	local height = 400
	local x = ( sw - width ) / 2
	local y = ( sh - height ) / 2
	
	local vehID = getElementData(vehicle, "dbid")

	local windowTitle = "Texture list for vehicle ID #"..tostring(vehID)
	gui.window = guiCreateWindow ( x, y, width, height, windowTitle, false )
	gui.list = guiCreateGridList ( 10, 25, width - 20, height - 120, false, gui.window )
	gui.remove = guiCreateButton ( 10, height - 90, width - 20, 25, "Remove selected texture", false, gui.window )
	gui.add = guiCreateButton ( 10, height - 60, width - 20, 25, "Add new texture", false, gui.window )
	gui.cancel = guiCreateButton ( 10, height - 30, width - 20, 25, "Cancel", false, gui.window )
	
	guiGridListAddColumn ( gui.list, "Texture", 0.2 ) 
	guiGridListAddColumn ( gui.list, "URL", 0.8 ) 

	guiWindowSetSizable ( gui.window, false )
	guiSetEnabled ( gui.remove, false )
	showCursor ( true )

	local currentTextures = getElementData(vehicle, "textures")
	for k,v in ipairs(currentTextures) do
		local row = guiGridListAddRow ( gui.list )
		guiGridListSetItemText ( gui.list, row, 1, v[1], false, false )
		guiGridListSetItemText ( gui.list, row, 2, v[2], false, false )
	end
	
	addEventHandler ( "onClientGUIClick", gui.window, vehTex_WindowClick )
end
addEvent("item-texture:vehtex")
addEventHandler("item-texture:vehtex", getRootElement(), vehTex_showGui)

function vehTex_WindowClick ( button, state )
	if button == "left" and state == "up" then
		if source == gui.cancel then
			vehTex_hideGui ( )
		elseif source == gui.list then
			local texID = guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 )
			
			if texID ~= "" then
				guiSetEnabled ( gui.remove, true )
			else
				guiSetEnabled ( gui.remove, false )
			end
		elseif source == gui.add then
			vehTex_addGui()
		elseif source == gui.remove then
			local row, column = guiGridListGetSelectedItem(gui.list)
			local texname = guiGridListGetItemText ( gui.list, row, 1 )
			if texname ~= "" then
				guiGridListRemoveRow(gui.list, row)
				triggerServerEvent("vehtex:removeTexture", getLocalPlayer(), vehicle, texname)
			end
		end
	end
end
function vehTex_hideGui()
	if gui.window then
		if gui.window2 then
			destroyElement ( gui.window2 )
			gui.window2 = nil
			guiSetInputEnabled(false)
		end
		if gui.window3 then
			destroyElement ( gui.window3 )
			gui.window3 = nil
		end
		destroyElement ( gui.window )
		gui.window = nil
		vehicle = nil
		
		showCursor ( false )
	end
end

function vehTex_addGui()
	if gui.window2 then
		vehTex_addGui_hide()
	end

	gui.window2 = guiCreateWindow(634, 416, 456, 166, "Add New Vehicle Texture", false)
	guiWindowSetSizable(gui.window2, false)

	gui.addLabel1 = guiCreateLabel(31, 63, 30, 17, "URL:", false, gui.window2)
	gui.addUrl = guiCreateEdit(71, 59, 374, 25, "", false, gui.window2)
	gui.addLabel2 = guiCreateLabel(10, 27, 51, 18, "Texture:", false, gui.window2)
	gui.addCombo = guiCreateComboBox(69, 24, 199, 79, "", false, gui.window2)
	gui.addCancel = guiCreateButton(16, 109, 199, 43, "Cancel", false, gui.window2)
	gui.addApply = guiCreateButton(230, 109, 214, 43, "Apply", false, gui.window2)

	addEventHandler ( "onClientGUIClick", gui.addCancel, vehTex_addGui_hide, false )
	addEventHandler ( "onClientGUIClick", gui.addApply, vehTex_addGui_apply, false )

	guiSetInputEnabled(true)

	local alreadyAdded = {}
	local currentTextures = getElementData(vehicle, "textures")
	for k,v in ipairs(currentTextures) do
		alreadyAdded[v[1]] = true
	end
	local model = getElementModel(vehicle)
	local texnames = engineGetModelTextureNames(tostring(model))
	if extraVehTexNames[model] then
		for k,v in ipairs(extraVehTexNames[model]) do
			table.insert(texnames, v)
		end
	end
	for k,v in ipairs(texnames) do
		if not alreadyAdded[tostring(v)] then
			guiComboBoxAddItem(gui.addCombo, tostring(v))
		end
	end
end
function vehTex_addGui_hide()
	if gui.window2 then
		destroyElement ( gui.window2 )
		gui.window2 = nil
		guiSetInputEnabled(false)
		if gui.window3 then
			destroyElement ( gui.window3 )
			gui.window3 = nil
		end
	end
end
function vehTex_error(msg)
	if gui.window3 then
		vehTex_error_hide()
	end

	local sw, sh = guiGetScreenSize()
	local width = 400
	local height = 150
	local x = ( sw - width ) / 2
	local y = ( sh - height ) / 2

	gui.window3 = guiCreateWindow(x, y, width, height, "Error", false)
	guiWindowSetSizable(gui.window3, false)

	gui.errorLabel = guiCreateLabel(10, 20, width-20, height-40, tostring(msg), false, gui.window3)
		guiLabelSetHorizontalAlign(gui.errorLabel, "center", true)
		guiLabelSetVerticalAlign(gui.errorLabel, "center")
	gui.errorBtn = guiCreateButton(10, height-35, width-20, 30, "OK", false, gui.window3)
	addEventHandler ( "onClientGUIClick", gui.errorBtn, vehTex_error_hide, false )
end
function vehTex_error_hide()
	if gui.window3 then
		destroyElement ( gui.window3 )
		gui.window3 = nil
	end
	if gui.addApply then
		guiSetEnabled(gui.addApply, true)
		guiSetText(gui.addApply, "Apply")
	end
end
function vehTex_addGui_apply()
	guiSetEnabled(gui.addApply, false)
	guiSetText(gui.addApply, "Please wait...")
	local texurl = guiGetText(gui.addUrl)
	local texname = tostring(guiComboBoxGetItemText(gui.addCombo, guiComboBoxGetSelected(gui.addCombo)))
	if (not texname or texname == "" or texname == " ") then
		vehTex_error("You did not select what texture you want to replace.")
		return false
	end
	if not isURLValid(texurl) then
		vehTex_error("Invalid URL! Allowed filetypes are jpg and png.")
		return false
	end

	--validate file
	local path = getPath(texurl)
	if fileExists(path) then --file already exists, so we dont need to validate
		outputDebugString("item-texture/c_vehtex: Skip validation")
		vehTex_apply(texname, texurl)
	else
		--we need to download :(
		triggerServerEvent("vehtex:validateFile", resourceRoot, vehicle, texname, texurl)
		guiSetText(gui.addApply, "Please wait. Downloading...")
	end
end
function vehTex_fileValidationResult(editVehicle, texname, texurl, approved, msg)
	if not editVehicle or not vehicle then return false end
	if editVehicle ~= vehicle then return false end
	if approved then
		vehTex_apply(texname, texurl)
		return true
	else
		vehTex_error("File validation failed! \n"..tostring(msg))
		return false		
	end
end
addEvent("vehtex:fileValidationResult", true)
addEventHandler("vehtex:fileValidationResult", resourceRoot, vehTex_fileValidationResult)

function vehTex_apply(texname, texurl)
	local row = guiGridListAddRow ( gui.list )
	guiGridListSetItemText ( gui.list, row, 1, texname, false, false )
	guiGridListSetItemText ( gui.list, row, 2, texurl, false, false )
	triggerServerEvent("vehtex:addTexture", getLocalPlayer(), vehicle, texname, texurl)
	vehTex_addGui_hide()
end
local extensions = { 
	[".jpg"] = true,
	[".png"] = true,
}
function isURLValid ( url )
	local url = url:lower()
	local _extensions = ""
	
	for extension, _ in pairs ( extensions ) do
		if _extensions ~= "" then
			_extensions = _extensions .. ", " .. extension
		else
			_extensions = extension
		end
		
		if string.find ( url, extension, 1, true ) then
			return true
		end
	end
	
	return false
end