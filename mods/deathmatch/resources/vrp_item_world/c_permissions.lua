
localPlayer = getLocalPlayer()
local currentObject
local currentUseData, currentMoveData, currentPickupData = {}, {}, {}

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

function itemPropertiesGUI(object)
	if not object then return end
	if canEditItemProperties(localPlayer, object) then
		currentObject = object
		if propertiesWindow then
			destroyElement(propertiesWindow)
		end

		GUIEditor = {
		    tab = {},
		    tabpanel = {},
		    label = {},
		    button = {},
		    combobox = {}
		}
		
		local sx, sy = guiGetScreenSize()
		local w, h = 332, 391
		local x = (sx/2)-(w/2)
		local y = (sy/2)-(h/2)
		propertiesWindow = guiCreateWindow(x, y, w, h, "Item Properties", false)
		guiWindowSetSizable(propertiesWindow, false)

		--get data
		local id = tonumber(getElementData(object, "id")) or 0
		local itemID = tonumber(getElementData(object, "itemID")) or 0
		local itemValue = getElementData(object, "itemValue")
		local creator = tonumber(getElementData(object, "creator")) or 0
		local createdDate = tostring(getElementData(object, "createdDate"))
		local protected = getElementData(object, "protected") == 1 or false
		permissions = getPermissions(object) or {}
		outputDebugString("#permissions = "..tostring(#permissions))
		local itemName = tostring(exports.vrp_global:getItemName(itemID))

		local protectedText = ""
		if protected then
			protectedText = "Yes"
		else
			protectedText = "No"
		end

		local creatorName = tostring(creator)

		GUIEditor.button[4] = guiCreateButton(158, 354, 164, 27, "Save", false, propertiesWindow)
		GUIEditor.button[5] = guiCreateButton(9, 354, 147, 27, "Cancel", false, propertiesWindow)
			addEventHandler("onClientGUIClick", GUIEditor.button[5], hideItemPropertiesGUI, false)
			addEventHandler("onClientGUIClick", GUIEditor.button[4], saveItemProperties, false)

		GUIEditor.tabpanel[1] = guiCreateTabPanel(9, 27, 314, 323, false, propertiesWindow)

		GUIEditor.tab[1] = guiCreateTab("Details", GUIEditor.tabpanel[1])

		GUIEditor.label[1] = guiCreateLabel(7, 8, 300, 19, itemName, false, GUIEditor.tab[1])
		guiSetFont(GUIEditor.label[1], "default-bold-small")
		GUIEditor.label[2] = guiCreateLabel(7, 32, 299, 21, "Placed by: "..creatorName, false, GUIEditor.tab[1])
		GUIEditor.label[3] = guiCreateLabel(7, 53, 299, 21, "Placed date: "..createdDate, false, GUIEditor.tab[1])
		GUIEditor.label[4] = guiCreateLabel(7, 74, 299, 21, "Protected: "..protectedText, false, GUIEditor.tab[1])

		GUIEditor.tab[2] = guiCreateTab("Permissions", GUIEditor.tabpanel[1])

		GUIEditor.label[5] = guiCreateLabel(9, 11, 46, 18, "Use:", false, GUIEditor.tab[2])

		GUIEditor.button[1] = guiCreateButton(62, 35, 240, 25, "Define", false, GUIEditor.tab[2])
			addEventHandler("onClientGUIClick", GUIEditor.button[1], 
				function ()
					local num = 1
					local action = "use"
					local type
					local text = guiComboBoxGetItemText(GUIEditor.combobox[num], guiComboBoxGetSelected(GUIEditor.combobox[num]) or 1)
					for k,v in ipairs(permissionTypes) do
						if v[1] == text then
							type = v[2]
							break
						end
					end
					local oldData
					if permissions[action] == type then
						oldData = permissions[action.."Data"]
					end 	
					showDataSet(type, action, oldData)
				end
			, false)

		GUIEditor.button[2] = guiCreateButton(62, 99, 240, 25, "Define", false, GUIEditor.tab[2])
			addEventHandler("onClientGUIClick", GUIEditor.button[2], 
				function ()
					local num = 2
					local action = "move"
					local type
					local text = guiComboBoxGetItemText(GUIEditor.combobox[num], guiComboBoxGetSelected(GUIEditor.combobox[num]) or 1)
					for k,v in ipairs(permissionTypes) do
						if v[1] == text then
							type = v[2]
							break
						end
					end
					local oldData
					if permissions[action] == type then
						oldData = permissions[action.."Data"]
					end 	
					showDataSet(type, action, oldData)
				end
			, false)

		GUIEditor.button[3] = guiCreateButton(62, 166, 240, 25, "Define", false, GUIEditor.tab[2])
			addEventHandler("onClientGUIClick", GUIEditor.button[3], 
				function ()
					local num = 3
					local action = "pickup"
					local type
					local text = guiComboBoxGetItemText(GUIEditor.combobox[num], guiComboBoxGetSelected(GUIEditor.combobox[num]) or 1)
					for k,v in ipairs(permissionTypes) do
						if v[1] == text then
							type = v[2]
							break
						end
					end
					local oldData
					if permissions[action] == type then
						oldData = permissions[action.."Data"]
					end 	
					showDataSet(type, action, oldData)
				end
			, false)

		GUIEditor.combobox[1] = guiCreateComboBox(60, 9, 244, 115, "", false, GUIEditor.tab[2])
			for k,v in ipairs(permissionTypes) do
				local row = guiComboBoxAddItem(GUIEditor.combobox[1], v[1])
				if v[2] == permissions.use then
					guiComboBoxSetSelected(GUIEditor.combobox[1], row)
					if v[3] then
						guiSetVisible(GUIEditor.button[1], true)
					else
						guiSetVisible(GUIEditor.button[1], false)
					end
				end
			end
			addEventHandler("onClientGUIComboBoxAccepted", GUIEditor.combobox[1], 
				function ()
					local num = 1
					local combo = GUIEditor.combobox[num]
					local btn = GUIEditor.button[num]
					local name = guiComboBoxGetItemText(combo, guiComboBoxGetSelected(combo))
					for k,v in ipairs(permissionTypes) do
						if name == v[1] then
							if v[3] then
								guiSetVisible(btn, true)
							else
								guiSetVisible(btn, false)
							end
							break
						end
					end
				end
			, false)
		GUIEditor.combobox[2] = guiCreateComboBox(60, 73, 244, 115, "", false, GUIEditor.tab[2])
			for k,v in ipairs(permissionTypes) do
				local row = guiComboBoxAddItem(GUIEditor.combobox[2], v[1])
				if v[2] == permissions.move then
					guiComboBoxSetSelected(GUIEditor.combobox[2], row)
					if v[3] then
						guiSetVisible(GUIEditor.button[2], true)
					else
						guiSetVisible(GUIEditor.button[2], false)
					end
				end
			end
			addEventHandler("onClientGUIComboBoxAccepted", GUIEditor.combobox[2], 
				function ()
					local num = 2
					local combo = GUIEditor.combobox[num]
					local btn = GUIEditor.button[num]
					local name = guiComboBoxGetItemText(combo, guiComboBoxGetSelected(combo))
					for k,v in ipairs(permissionTypes) do
						if name == v[1] then
							if v[3] then
								guiSetVisible(btn, true)
							else
								guiSetVisible(btn, false)
							end
							break
						end
					end
				end
			, false)
		GUIEditor.combobox[3] = guiCreateComboBox(60, 138, 244, 115, "", false, GUIEditor.tab[2])
			for k,v in ipairs(permissionTypes) do
				local row = guiComboBoxAddItem(GUIEditor.combobox[3], v[1])
				if v[2] == permissions.pickup then
					guiComboBoxSetSelected(GUIEditor.combobox[3], row)
					if v[3] then
						guiSetVisible(GUIEditor.button[3], true)
					else
						guiSetVisible(GUIEditor.button[3], false)
					end
				end
			end
			addEventHandler("onClientGUIComboBoxAccepted", GUIEditor.combobox[3], 
				function ()
					local num = 3
					local combo = GUIEditor.combobox[num]
					local btn = GUIEditor.button[num]
					local name = guiComboBoxGetItemText(combo, guiComboBoxGetSelected(combo))
					for k,v in ipairs(permissionTypes) do
						if name == v[1] then
							if v[3] then
								guiSetVisible(btn, true)
							else
								guiSetVisible(btn, false)
							end
							break
						end
					end
				end
			, false)

		GUIEditor.label[6] = guiCreateLabel(9, 75, 46, 18, "Move:", false, GUIEditor.tab[2])
		GUIEditor.label[7] = guiCreateLabel(9, 140, 46, 18, "Pick up:", false, GUIEditor.tab[2])
		GUIEditor.label[8] = guiCreateLabel(9, 239, 296, 56, "These settings define who can use, move and pick up this item. The character that dropped the item, admins and anyone with key to the interior can edit these settings. Items set as 'protected' by an admin cannot be moved or picked up before the item has been unprotected by an admin.", false, GUIEditor.tab[2])
		guiSetFont(GUIEditor.label[8], "default-small")
		guiLabelSetHorizontalAlign(GUIEditor.label[8], "left", true)
		GUIEditor.label[9] = guiCreateLabel(9, 204, 112, 18, "Protected: "..protectedText, false, GUIEditor.tab[2])
		
		local newCreatorName
		for k,v in ipairs(getElementsByType("player")) do
			local dbid = tonumber(getElementData(v, "dbid")) or 0
			if dbid == creator then
				newCreatorName = getPlayerName(v):gsub("_", " ")
				break
			end
		end
		if newCreatorName then
			guiSetText(GUIEditor.label[2], "Placed by: "..newCreatorName)
		else
			triggerServerEvent("item-world:getItemPropertiesData", getResourceRootElement(), object)
		end
	end
end
addEvent("showItemProperties", true)
addEventHandler("showItemProperties", getRootElement(), itemPropertiesGUI)

function hideItemPropertiesGUI()
	if propertiesWindow then
		if isElement(propertiesWindow) then
			destroyElement(propertiesWindow)
		end
		propertiesWindow = nil
	end
end

function itemPropertiesGUIFillData(object, creatorName)
	if currentObject == object then
		if creatorName and isElement(GUIEditor.label[2]) then
			guiSetText(GUIEditor.label[2], "Placed by: "..creatorName)
		end
	end
end
addEvent("item-world:fillItemPropertiesGUI", true)
addEventHandler("item-world:fillItemPropertiesGUI", getResourceRootElement(), itemPropertiesGUIFillData)

function saveItemProperties(button, state)	
	local object = currentObject
	if not object then return end
	
	local useText = guiComboBoxGetItemText(GUIEditor.combobox[1], guiComboBoxGetSelected(GUIEditor.combobox[1]) or 1)
	local moveText = guiComboBoxGetItemText(GUIEditor.combobox[2], guiComboBoxGetSelected(GUIEditor.combobox[2]) or 1)
	local pickupText = guiComboBoxGetItemText(GUIEditor.combobox[3], guiComboBoxGetSelected(GUIEditor.combobox[3]) or 1)

	local use, move, pickup
	local useData, moveData, pickupData = {}, {}, {}
	for k,v in ipairs(permissionTypes) do
		if v[1] == useText then
			use = v[2]
			if v[3] then
				useData = currentUseData or {}
			end
		end
		if v[1] == moveText then
			move = v[2]
			if v[3] then
				moveData = currentMoveData or {}
			end
		end
		if v[1] == pickupText then
			pickup = v[2]
			if v[3] then
				pickupData = currentPickupData or {}
			end
		end	
	end

	triggerServerEvent("item-world:saveItemProperties", getResourceRootElement(), object, use, useData, move, moveData, pickup, pickupData)
	
	hideItemPropertiesGUI()
end

function showDataSet(type, action, oldData)
	if dataWindow then
		if isElement(dataWindow) then
			destroyElement(dataWindow)
		end
		dataWindow = nil
	end

	dataAction = action

	local newData = {}

	--[[
	local currentData
	if action == "use" then
		currentData = currentUseData
	elseif action == "move" then
		currentData = currentMoveData
	elseif action == "pickup" then
		currentData = currentPickupData
	end
	--]]

	if type == 4 then --factions

	elseif type == 5 then --characters
		local sx, sy = guiGetScreenSize()
		local w, h = 385, 445
		local x = (sx/2)-(w/2)
		local y = (sy/2)-(h/2)
		dataWindow = guiCreateWindow(x, y, w, h, "Select Characters", false)
		guiWindowSetSizable(dataWindow, false)

		inputCharName = guiCreateEdit(9, 50, 276, 27, "", false, dataWindow)
		local btnAdd = guiCreateButton(288, 52, 88, 25, "Add", false, dataWindow)
		local label = guiCreateLabel(12, 26, 361, 22, "Enter full name of a character to add.", false, dataWindow)
		inputGridlist = guiCreateGridList(9, 88, 367, 265, false, dataWindow)
			guiGridListAddColumn(inputGridlist, "Character Name", 0.9)
			guiGridListAddRow(inputGridlist)
			guiGridListSetItemText(inputGridlist, 0, 1, "Jacob Goldsmith", false, false)
		
		local btnSave = guiCreateButton(10, 401, 366, 31, "Save", false, dataWindow)
		local btnRemove = guiCreateButton(9, 357, 116, 30, "Remove selected", false, dataWindow)
		local btnRemoveAll = guiCreateButton(130, 357, 116, 30, "Remove all", false, dataWindow)


	elseif type == 8 then --query string
		local sx, sy = guiGetScreenSize()
		local w, h = 429, 168
		local x = (sx/2)-(w/2)
		local y = (sy/2)-(h/2)
        dataWindow = guiCreateWindow(x, y, w, h, "Write Exciter Query String", false)
        guiWindowSetSizable(dataWindow, false)
        local oldText = ""
        if oldData then
        	if oldData[1] then
        		oldText = tostring(oldData[1])
        	end
        end
        inputDataMemo = guiCreateMemo(13, 32, 402, 91, oldText, false, dataWindow)
        local btn = guiCreateButton(16, 126, 392, 32, "Set Data", false, dataWindow)
			addEventHandler("onClientGUIClick", btn, 
				function ()
					local querystring = guiGetText(inputDataMemo)
					local newData = {querystring}

					if dataAction == "use" then
						currentUseData = newData
					elseif dataAction == "move" then
						currentMoveData = newData
					elseif dataAction == "pickup" then
						currentPickupData = newData
					end
					hideDataSet()
				end
			, false)
	end
end

function hideDataSet()
	if dataWindow then
		if isElement(dataWindow) then
			destroyElement(dataWindow)
		end
		dataWindow = nil
	end
end