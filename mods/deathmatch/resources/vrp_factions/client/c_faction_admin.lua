-- ADMIN GUI's
wFactionList, bFactionListClose,gridFactions = nil
function showFactionList(factions)
	if not (wFactionList) then
		wFactionList = guiCreateWindow(0.25, 0.25, 0.5, 0.5, "Faction List", true)
		gridFactions = guiCreateGridList(0.025, 0.1, 0.95, 0.775, true, wFactionList)
		
		local colID = guiGridListAddColumn(gridFactions, "ID", 0.1)
		local colName = guiGridListAddColumn(gridFactions, "Faction Name", 0.6)
		local colPlayers = guiGridListAddColumn(gridFactions, "Players", 0.14)
		local colType = guiGridListAddColumn(gridFactions, "Type", 0.14)
		
		for key, value in pairs(factions) do
			local factionID = factions[key][1]
			local factionName = tostring(factions[key][2])
			local factionType = tonumber(factions[key][3])
			local factionPlayers = factions[key][4]
			
			-- Parse the type
			if (factionType==0) then
				factionType = "Gang"
			elseif (factionType==1) then
				factionType = "Mafia"
			elseif (factionType==2) then
				factionType = "Law"
			elseif (factionType==3) then
				factionType = "Government"
			elseif (factionType==4) then
				factionType = "Medical"
			elseif (factionType==5) then
				factionType = "Other"
			elseif (factionType==6) then
				factionType = "News"
			elseif (factionType==7) then  -- Added Mechanic type \ Adams
				factionType = "Mechanic"
			end
			
			local row = guiGridListAddRow(gridFactions)
			guiGridListSetItemText(gridFactions, row, colID, factionID, false, false)
			guiGridListSetItemText(gridFactions, row, colName, factionName, false, false)
			guiGridListSetItemText(gridFactions, row, colPlayers, factionPlayers, false, false)
			guiGridListSetItemText(gridFactions, row, colType, factionType, false, false)
		end
		
		addEventHandler( "onClientGUIDoubleClick", gridFactions,
			function( button )
				local row, col = guiGridListGetSelectedItem( source )
				if row ~= -1 and col ~= -1 then
					local gridID = guiGridListGetItemText( source , row, col )
					
					if button == "left" then
						triggerServerEvent("faction:admin:showplayers", getLocalPlayer(), gridID )
					elseif button == "right" then
						triggerServerEvent("faction:admin:showf3", getLocalPlayer(), gridID, exports.vrp_integration:isPlayerAdmin(getLocalPlayer()) )
					end
				else
					outputChatBox( "You need to pick an faction.", 255, 0, 0 )
				end
			end,
			false
		)

		bFactionListClose = guiCreateButton(0.025, 0.9, 0.95, 0.1, "Close", true, wFactionList)
		addEventHandler("onClientGUIClick", bFactionListClose, closeFactionList, false)
	else
		guiSetInputEnabled(false)
		destroyElement(wFactionList)
		wFactionList = nil
	end
end
addEvent("showFactionList", true)
addEventHandler("showFactionList", getRootElement(), showFactionList)

function closeFactionList(button, state)
	if (source==bFactionListClose) and (button=="left") and (state=="up") then
		guiSetInputEnabled(false)
		destroyElement(wFactionList)
		wFactionList, bFactionListClose = nil, nil
	end
end

-- // Chaos - Duty allow script

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = guiGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    guiSetPosition(center_window, x, y, false)
end

DutyAllow = {
    label = {},
    edit = {},
    button = {},
    window = {},
    gridlist = {},
    combobox = {}
}

weapBanList = {
	[-8] = true, -- Katana
	[-35] = true, -- RPG
	[-36] = true, -- Homing RPG
	[-37] = true, -- Flamethrower
	[-38] = true, -- Minigun
	[-39] = true, -- C4 Charge
	[-40] = true, -- C4 Det
}

function createAdminDuty(factionT, dutyT)
	if isElement(DutyAllow.window[1]) then
		destroyElement(DutyAllow.window[1])
	end

	factionTable = factionT
	dutyChanges = dutyT

    DutyAllow.window[1] = guiCreateWindow(562, 250, 564, 351, "Admin Duty Settings", false)
    centerWindow(DutyAllow.window[1])
    guiWindowSetSizable(DutyAllow.window[1], false)
    guiWindowSetMovable(DutyAllow.window[1], true)
    guiSetInputEnabled(true)

	DutyAllow.gridlist[1] = guiCreateGridList(9, 75, 545, 224, false, DutyAllow.window[1])
    guiGridListAddColumn(DutyAllow.gridlist[1], "ID", 0.1)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Name", 0.3)
    guiGridListAddColumn(DutyAllow.gridlist[1], "Description", 0.6)
    DutyAllow.label[1] = guiCreateLabel(10, 308, 73, 21, "Item ID:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[1], "center")
    DutyAllow.edit[1] = guiCreateEdit(83, 308, 78, 21, "", false, DutyAllow.window[1])
    DutyAllow.button[1] = guiCreateButton(318, 303, 108, 30, "Allow", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[1], "NormalTextColour", "FFAAAAAA")
    DutyAllow.button[2] = guiCreateButton(436, 303, 108, 30, "Remove", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[2], "NormalTextColour", "FFAAAAAA")
    DutyAllow.label[2] = guiCreateLabel(11, 59, 543, 16, "Allowed Items", false, DutyAllow.window[1])
    guiLabelSetHorizontalAlign(DutyAllow.label[2], "center", false)
    DutyAllow.label[3] = guiCreateLabel(9, 348, 74, 24, "View:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[3], "center")
    DutyAllow.label[4] = guiCreateLabel(163, 308, 68, 20, "Item Value:", false, DutyAllow.window[1])
    guiLabelSetVerticalAlign(DutyAllow.label[4], "center")
    DutyAllow.edit[2] = guiCreateEdit(230, 308, 78, 21, "1", false, DutyAllow.window[1])   
    DutyAllow.combobox[1] = guiCreateComboBox(1, 25, 242, 998, "Make a faction selection.", false, DutyAllow.window[1])
    exports.vrp_global:guiComboBoxAdjustHeight(DutyAllow.combobox[1], #factionT)
    DutyAllow.button[3] = guiCreateButton(442, 25, 102, 35, "Done", false, DutyAllow.window[1])
    guiSetProperty(DutyAllow.button[3], "NormalTextColour", "FFAAAAAA")
    DutyAllow.combobox[2] = guiCreateComboBox(255, 25, 124, 19, "", false, DutyAllow.window[1])
    exports.vrp_global:guiComboBoxAdjustHeight(DutyAllow.combobox[2], 2)
    guiComboBoxAddItem(DutyAllow.combobox[2], "Items")
    guiComboBoxAddItem(DutyAllow.combobox[2], "Weapons")  
    guiComboBoxSetSelected( DutyAllow.combobox[2], 0 )

    local row = guiGridListAddRow( DutyAllow.gridlist[1] )
    guiGridListSetItemText ( DutyAllow.gridlist[1], row, 2, "Make a faction selection...", false, false )

    for k,v in pairs(factionT) do
    	guiComboBoxAddItem( DutyAllow.combobox[1], "(".. v[1] ..") " .. v[2] )
    end
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[1], toggleFaction) 
    addEventHandler("onClientGUIComboBoxAccepted", DutyAllow.combobox[2], toggleView)

    addEventHandler("onClientGUIClick", DutyAllow.button[1], allowItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[2], removeItem, false)
    addEventHandler("onClientGUIClick", DutyAllow.button[3], closeGUI, false)
end
addEvent("adminDutyAllow", true)
addEventHandler("adminDutyAllow", resourceRoot, createAdminDuty)

function populateList(key) -- Type 1 is weapons, 0 is items
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	guiGridListClear( DutyAllow.gridlist[1] )
	if selection == 0 then -- Items
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) > 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])

				guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["vrp_items"]:getItemName(v[2]), false, false)
				guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, exports["vrp_items"]:getItemDescription(v[2], v[3]), false, false)
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	elseif selection == 1 then -- Weapons
		for k,v in pairs(factionTable[key][3]) do
			if tonumber(v[2]) < 0 then
				local row = guiGridListAddRow(DutyAllow.gridlist[1])
				if tonumber(v[2]) == -100 then
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, "Armor", false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				else
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 1, v[2], false, true)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 2, exports["vrp_items"]:getItemName(v[2]), false, false)
					guiGridListSetItemText(DutyAllow.gridlist[1], row, 3, v[3], false, false)
				end
				guiGridListSetItemData(DutyAllow.gridlist[1], row, 1, tonumber(v[1]))
			end
		end
	end
	guiSetText(DutyAllow.edit[1], "")
	guiSetText(DutyAllow.edit[2], "")
end

function toggleView()
	local item = guiComboBoxGetSelected (DutyAllow.combobox[2])
    guiGridListClear( DutyAllow.gridlist[1] )

	if item == 1 then -- Weapons
		guiSetText(DutyAllow.label[2], "Allowed Weapons")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Max Ammo")

        guiSetText(DutyAllow.label[1], "Weapon ID:")
        guiSetText(DutyAllow.label[4], "Max Ammo:")
	elseif item == 0 then -- Items
		guiSetText(DutyAllow.label[2], "Allowed Items")

        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 2, "Name")
        guiGridListSetColumnTitle(DutyAllow.gridlist[1], 3, "Description")

        guiSetText(DutyAllow.label[1], "Item ID:")
        guiSetText(DutyAllow.label[4], "Item Value:")
	end
	if guiComboBoxGetSelected(DutyAllow.combobox[1]) and guiComboBoxGetSelected(DutyAllow.combobox[1]) > -1 then
		populateList(guiComboBoxGetSelected(DutyAllow.combobox[1])+1)
	end
end

function toggleFaction()
	local selected = guiComboBoxGetSelected(DutyAllow.combobox[1])
	if selected and selected > -1 then
		populateList(selected+1)
	end
end

function closeGUI()
	destroyElement(DutyAllow.window[1])
	guiSetInputEnabled(false)
	triggerServerEvent("dutyAdmin:Save", resourceRoot, factionTable, dutyChanges)
end

function allowItem()
	local itemID = guiGetText(DutyAllow.edit[1])
	local itemValue = guiGetText(DutyAllow.edit[2])
	local selection = guiComboBoxGetSelected (DutyAllow.combobox[2])
	local faction = guiComboBoxGetSelected (DutyAllow.combobox[1])+1
	
	local maxIndex = getElementData(resourceRoot, "maxIndex")+1
	if not tonumber(itemID) then return end

	if not exports['vrp_items']:isItem(itemID) and selection == 0 then
		outputChatBox("That's not even a item...", 255, 0, 0)
		return
	elseif not getWeaponNameFromID(itemID) and selection == 1 and tonumber(itemID) ~= 100 then
		outputChatBox("That's not even a weapon...", 255, 0, 0)
		return
	end

	if faction and faction > 0 then
		--[[for k,v in pairs(factionTable[faction][3]) do
			if tonumber(v[2]) == tonumber(selection == 1 and -itemID or itemID) then
				outputChatBox("You already allow this item.", 255, 0, 0)
				return
			end
		end]]

		if tonumber(itemID) then
			if selection == 0 then -- Item
				table.insert(factionTable[faction][3], { maxIndex, tonumber(itemID), itemValue })
				table.insert(dutyChanges, { faction, 1, maxIndex, tonumber(itemID), itemValue })
				setElementData(resourceRoot, "maxIndex", maxIndex)
			elseif selection == 1 then -- Weapon
				if tonumber(itemValue) then
					if not weapBanList[-tonumber(itemID)] then -- Check if its banned.
						table.insert(factionTable[faction][3], { maxIndex, -tonumber(itemID), itemValue })
						table.insert(dutyChanges, { faction, 1, maxIndex, -tonumber(itemID), itemValue })
						setElementData(resourceRoot, "maxIndex", maxIndex)
					else
						outputChatBox("This weapon is banned from being added.", 255, 0, 0)
					end
				else
					outputChatBox("The Max Ammo must be a number!", 255, 0, 0)
				end
			end
			populateList(faction)
		else
			outputChatBox("The Item ID must be a number!", 255, 0, 0)
		end
	else
		outputChatBox("Please make a selection first.", 255, 0, 0)
	end
end

function removeItem()
	local r, c = guiGridListGetSelectedItem ( DutyAllow.gridlist[1] )
	local faction = guiComboBoxGetSelected(DutyAllow.combobox[1])+1
    if r and r>=0 and c and c>=0 and faction and faction > 0 then
    	local id = guiGridListGetItemData(DutyAllow.gridlist[1], r, 1)
    	for k,v in pairs(factionTable[faction][3]) do
    		if tonumber(id) == tonumber(v[1]) then
    			table.insert(dutyChanges, { faction, 0, k })
    			table.remove(factionTable[faction][3], k)
    			populateList(faction)
    		end
    	end
    else
    	outputChatBox("Please make a selection first.", 255, 0, 0)
    end
end