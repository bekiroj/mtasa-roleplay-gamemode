-- OKAROSA
local GUIEditor_Window = {}
local GUIEditor_Button = {}
local GUIEditor_Grid = {}
local GUIEditor_Label = {}
local GUIEditor_Edit = {}
local GUIEditor_Memo = {}
local GUIEditor_Checkbox = {}
local col = {}
local sx, sy = guiGetScreenSize()
local gui = {}
carshops = {}
--[[
{
	[1] = {"grotti", "Grotti's Cars"},
	[2] = {"JeffersonCarShop", "Jefferson Car Shop"},
	[3] = {"IdlewoodBikeShop", "Idlewood Bike Shop"},
	[4] = {"SandrosCars", "Sandro's Cars"},
	[5] = {"IndustrialVehicleShop", "Industrial Vehicle Shop"},
}
]]
function showLibrary(vehs, thePed)
	if isElement(GUIEditor_Window[1]) then
		closeLibrary()
	end
	
	if not vehs then
		--return false
	end
	
	showCursor(true)
	
	local w, h = 784, 562
	
	GUIEditor_Window[1] = guiCreateWindow((sx-w)/2,(sy-h)/2,w,h,"Araç Kütüphanesi - Sourcelua Development Team]",false)
	guiWindowSetSizable(GUIEditor_Window[1],false)
	grid = guiCreateGridList(0.0115,0.0463,0.9758,0.8541,true,GUIEditor_Window[1])
	--guiGridListSetSelectionMode(grid,2)
	
	col.id = guiGridListAddColumn(grid,"ID",0.06)
	col.enabled = guiGridListAddColumn(grid,"Enabled",0.06)
	col.mtamodel = guiGridListAddColumn(grid,"MTA Model",0.15)
	col.brand = guiGridListAddColumn(grid,"Brand",0.15)
	col.model = guiGridListAddColumn(grid,"Model",0.15)
	col.year = guiGridListAddColumn(grid,"Year",0.1)
	col.price = guiGridListAddColumn(grid,"Price",0.1)
	col.tax = guiGridListAddColumn(grid,"Tax",0.1)
	col.updatedby = guiGridListAddColumn(grid,"Updated By",0.15)
	col.updatedate = guiGridListAddColumn(grid,"Update Date",0.2)
	col.createdby = guiGridListAddColumn(grid,"Created By",0.15)
	col.createdate = guiGridListAddColumn(grid,"Create Date",0.2)
	col.notes = guiGridListAddColumn(grid,"Notes",0.5)
	col.spawnto = guiGridListAddColumn(grid,"Spawn to",0.2)
	
	
	for i = 1, #vehs do
		local row = guiGridListAddRow(grid)
		guiGridListSetItemText(grid, row, col.id, vehs[i].id or "", false, true)
		guiGridListSetItemText(grid, row, col.enabled, ((vehs[i].enabled == "1") and "Yes" or "No"), false, true)
		guiGridListSetItemText(grid, row, col.mtamodel, getVehicleNameFromModel(tonumber(vehs[i].vehmtamodel)).." ("..vehs[i].vehmtamodel..")", false, false)
		guiGridListSetItemText(grid, row, col.brand, vehs[i].vehbrand, false, false)
		guiGridListSetItemText(grid, row, col.model, vehs[i].vehmodel, false, false)
		guiGridListSetItemText(grid, row, col.year, vehs[i].vehyear, false, false) 
		guiGridListSetItemText(grid, row, col.price, "$"..exports.vrp_global:formatMoney(vehs[i].vehprice), false, false) 
		guiGridListSetItemText(grid, row, col.tax, "$"..exports.vrp_global:formatMoney(vehs[i].vehtax), false, false) 
		guiGridListSetItemText(grid, row, col.notes, vehs[i].notes, false, false) 
		guiGridListSetItemText(grid, row, col.createdby, (vehs[i].createdby or "No-one") , false, false)
		guiGridListSetItemText(grid, row, col.createdate, (vehs[i].createdate or "No-one"), false, true)
		guiGridListSetItemText(grid, row, col.updatedby, (vehs[i].updatedby or "No-one"), false, false)
		guiGridListSetItemText(grid, row, col.updatedate, vehs[i].updatedate, false, true)
		local spawntoText = ""
		
		guiGridListSetItemText(grid, row, col.spawnto, (spawntoText or vehs[i].spawnto), false, false)
	end
	if thePed and isElement(thePed) and getElementData(thePed, "carshop") then
		local drivetestPrice = 25
		local orderPrice = 0
		GUIEditor_Button["testdrive"] = guiCreateButton(0.0115,0.9181,0.1237,0.0587,"Test Drive ($"..drivetestPrice..")",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button["testdrive"],"default-bold-small")
		--guiSetEnabled(GUIEditor_Button["testdrive"], false)
		addEventHandler( "onClientGUIClick", GUIEditor_Button["testdrive"],
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local row, col = guiGridListGetSelectedItem(grid)
					if row ~= -1 and col ~= -1 then
						local vehShopID = guiGridListGetItemText( grid , row, 1 )
						--outputChatBox(vehShopID)
						triggerServerEvent("vehicle_manager:handling:createTestVehicle", localPlayer, tonumber(vehShopID), thePed, false)
						closeLibrary()
						playSuccess() 
					else
						guiSetText(GUIEditor_Window[1], "You need to select a vehicle from the list above first.")
						playError()
						triggerServerEvent("shop:storeKeeperSay", localPlayer, localPlayer, "Which one do you want to test?" , getElementData(thePed, "name"))
					end
				end
			end,
		false)
		--guiSetEnabled(GUIEditor_Button["testdrive"], false)
		
		GUIEditor_Button["ordervehicle"] = guiCreateButton(0.148,0.9181,0.1237,0.0587,"Order Vehicle",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button["ordervehicle"],"default-bold-small")
		--guiSetEnabled(GUIEditor_Button["testdrive"], false)
		addEventHandler( "onClientGUIClick", GUIEditor_Button["ordervehicle"],
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local row, col = guiGridListGetSelectedItem(grid)
					if row ~= -1 and col ~= -1 then
						local vehShopID = guiGridListGetItemText( grid , row, 1 )
						--outputChatBox(vehShopID)
						triggerServerEvent("vehicle_manager:handling:orderVehicle", localPlayer, tonumber(vehShopID), thePed)
						closeLibrary()
						playSuccess() 
					else
						guiSetText(GUIEditor_Window[1], "You need to select a vehicle from the list above first.")
						playError()
						triggerServerEvent("shop:storeKeeperSay", localPlayer, localPlayer, "Which one do you want to order?" , getElementData(thePed, "name"))
					end
				end
			end,
		false)
		
		
		local playerOrderedFromShop = getElementData(localPlayer, "carshop:grotti:orderedvehicle:"..getElementData(thePed, "carshop"))
		if playerOrderedFromShop then
			guiSetEnabled(GUIEditor_Button["ordervehicle"], false)
			GUIEditor_Button["cancelorder"] = guiCreateButton(0.148,0.9181,0.1237,0.0587,"Cancel Order",true,GUIEditor_Window[1])
			guiSetFont(GUIEditor_Button["cancelorder"],"default-bold-small")
			addEventHandler( "onClientGUIClick", GUIEditor_Button["cancelorder"],
				function( button )
					if button == "left" then
						triggerServerEvent("vehicle_manager:handling:orderVehicle:cancel", localPlayer, getElementData(thePed, "carshop"))
						triggerServerEvent("shop:storeKeeperSay", localPlayer, localPlayer, "Sure!" , getElementData(thePed, "name"))
						closeLibrary()
						playSuccess() 
					end
				end,
			false)
		end
		
	else
		GUIEditor_Button[1] = guiCreateButton(0.0115,0.9181,0.1237,0.0587,"Create",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[1],"default-bold-small")
		addEventHandler( "onClientGUIClick", GUIEditor_Button[1], function()
			if source == GUIEditor_Button[1] then
				local veh = {}
				addNewVehicle(veh)
			end
		end)
		guiSetEnabled(GUIEditor_Button[1], false)
		
		GUIEditor_Button[2] = guiCreateButton(0.148,0.9181,0.1237,0.0587,"View/Modify",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[2],"default-bold-small")
		addEventHandler( "onClientGUIClick", GUIEditor_Button[2],
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local row, col = guiGridListGetSelectedItem(grid)
					if row ~= -1 and col ~= -1 then
						--[[
						local veh = {}
						veh.mtaModel = guiGridListGetItemText( grid , row, 2 )
						veh.brand = guiGridListGetItemText( grid , row, 3 )
						veh.model = guiGridListGetItemText( grid , row, 4 )
						veh.year = guiGridListGetItemText( grid , row, 5 )
						veh.price = string.gsub(guiGridListGetItemText( grid , row, 6 ), "$", "")
						veh.tax = string.gsub(guiGridListGetItemText( grid , row, 7 ), "$", "")
						veh.note = guiGridListGetItemText( grid , row, 12 )
						veh.update = guiGridListGetItemText( grid , row, 1 )
						]]
						triggerServerEvent("vehlib:getCurrentVehicleRecord", localPlayer, tonumber(guiGridListGetItemText( grid , row, 1 )))
						--addNewVehicle(veh)
					else
						guiSetText(GUIEditor_Window[1], "You need to select a record from the list above first.")
						playError()
					end
				end
			end,
		false)
		guiSetEnabled(GUIEditor_Button[2], false)
		
		GUIEditor_Button[3] = guiCreateButton(0.2844,0.9181,0.1237,0.0587,"Handling",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[3],"default-bold-small")
		guiSetEnabled(GUIEditor_Button[3], false)
		addEventHandler( "onClientGUIClick", GUIEditor_Button[3],
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local row, col = guiGridListGetSelectedItem(grid)
					if row ~= -1 and col ~= -1 then
						local vehShopID = guiGridListGetItemText( grid , row, 1 )
						exports.vrp_global:fadeToBlack()
						setTimer(function ()
							triggerServerEvent("vehicle_manager:handling:createTestVehicle", getLocalPlayer(), tonumber(vehShopID), thePed, true)
						end, 1000, 1)
						closeLibrary()
					else
						guiSetText(GUIEditor_Window[1], "You need to select a record from the list above first.")
						playError()
					end
				end
			end,
		false)
		
		GUIEditor_Button[4] = guiCreateButton(0.4209,0.9181,0.1237,0.0587,"Delete",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[4],"default-bold-small")
		addEventHandler( "onClientGUIClick", GUIEditor_Button[4],
			function( button )
				if button == "left" then
					local row, col = -1, -1
					local row, col = guiGridListGetSelectedItem(grid)
					if row ~= -1 and col ~= -1 then
						local createdby = guiGridListGetItemText( grid , row, 11 )
						if createdby ~= getElementData(localPlayer, "account:username") and not exports.vrp_integration:isPlayerVehicleConsultant(localPlayer)  then
							guiSetText(GUIEditor_Window[1], "You can only delete vehicles you added. Notify "..createdby.." if this vehicle isn't appropriate.")
							playError()
						else
							local id = guiGridListGetItemText( grid , row, 1 )
							local brand = guiGridListGetItemText( grid , row, 4 )
							local model = guiGridListGetItemText( grid , row, 5 )
							showConfirmDelete(id, brand, model, createdby)
						end
					else
						guiSetText(GUIEditor_Window[1], "You need to select a record from the list above first.")
						playError()
					end
				end
			end,
		false)
		guiSetEnabled(GUIEditor_Button[4], false)
		
		GUIEditor_Button[5] = guiCreateButton(0.5574,0.9181,0.1237,0.0587,"Refresh",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[5],"default-bold-small")
		addEventHandler( "onClientGUIClick", GUIEditor_Button[5], function()
			if source == GUIEditor_Button[5] then
				refreshLibrary()
			end
		end)
		--guiSetEnabled(GUIEditor_Button[5], false)
		
		GUIEditor_Button[7] = guiCreateButton(0.6939,0.9181,0.1237,0.0587,"Restart Shops",true,GUIEditor_Window[1])
		guiSetFont(GUIEditor_Button[7],"default-bold-small")
		
		guiSetEnabled(GUIEditor_Button[7], false)
		
		
		if exports.vrp_integration:isPlayerVehicleConsultant(localPlayer) or exports.vrp_integration:isPlayerSeniorAdmin(localPlayer) then
			guiSetEnabled(GUIEditor_Button[1], true) -- CREATE
			guiSetEnabled(GUIEditor_Button[2], true) -- EDIT
			guiSetEnabled(GUIEditor_Button[3], true) -- HANDLING
			guiSetEnabled(GUIEditor_Button[4], true) -- DELETE
			guiSetEnabled(GUIEditor_Button[7], true) -- RESTART CARSHOP
		elseif exports.vrp_integration:isPlayerTrialAdmin(localPlayer) or exports.vrp_integration:isPlayerVCTMember(localPlayer) then
			guiSetEnabled(GUIEditor_Button[7], true) -- RESTART CARSHOP
			guiSetEnabled(GUIEditor_Button[3], true) -- HANDLING
		end
	end
	
	GUIEditor_Button[6] = guiCreateButton(0.8304,0.9181,0.1569,0.0587,"Close",true,GUIEditor_Window[1])
	guiSetFont(GUIEditor_Button[6],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[6], function()
		if source == GUIEditor_Button[6] then
			closeLibrary()
		end
	end)
	
end
addEvent("vehlib:showLibrary", true)
addEventHandler("vehlib:showLibrary",getLocalPlayer(), showLibrary)


function closeLibrary()
	if isElement(GUIEditor_Window[1]) then
		destroyElement(GUIEditor_Window[1])
		GUIEditor_Window[1] = nil
	end
	showCursor(false)
end

function refreshLibrary()
	triggerServerEvent("vehlib:sendLibraryToClient", localPlayer)
end


function addNewVehicle(veh)
	if GUIEditor_Window[1] then
		guiSetEnabled(GUIEditor_Window[1], false)
	end
	
	if GUIEditor_Window[2] then
		closeAddNewVehicle()
		return false
	end
	guiSetInputEnabled(true)
	
	this = {}
	local fuel = veh.fuel or {}

	local w, h = 438,392+30+40
	GUIEditor_Window[2] = guiCreateWindow((sx-w)/2,(sy-h)/2,w,h,(veh.update and "Edit Vehicle" or "Add new vehicle"),false)
	guiSetProperty(GUIEditor_Window[2],"AlwaysOnTop","true")
	guiSetProperty(GUIEditor_Window[2],"SizingEnabled","false")
	
	GUIEditor_Label[1] = guiCreateLabel(0.0251,0.06,0.4292,0.0459,"MTA Vehicle Model (Name or ID):",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[1],"default-bold-small")
	GUIEditor_Edit[1] = guiCreateEdit(0.0388,0.11,0.4155,0.06,(veh.mtaModel or ""),true,GUIEditor_Window[2])
	if veh.update then
		guiSetEnabled(GUIEditor_Edit[1], false)
	end
	GUIEditor_Label[2] = guiCreateLabel(0.0251,0.185,0.4292,0.0459,"Brand:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[2],"default-bold-small")
	GUIEditor_Edit[2] = guiCreateEdit(0.0388,0.235,0.4155,0.06,(veh.brand or ""),true,GUIEditor_Window[2])
	GUIEditor_Label[3] = guiCreateLabel(0.0251,0.31,0.4292,0.0459,"Model:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[3],"default-bold-small")
	GUIEditor_Edit[3] = guiCreateEdit(0.0388,0.36,0.4155,0.06,(veh.model or ""),true,GUIEditor_Window[2])
	GUIEditor_Label[4] = guiCreateLabel(0.516,0.06,0.4292,0.0459,"Year:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[4],"default-bold-small")
	GUIEditor_Edit[4] = guiCreateEdit(0.5411,0.11,0.4155,0.06,(veh.year or ""),true,GUIEditor_Window[2])
	GUIEditor_Label[5] = guiCreateLabel(0.516,0.185,0.4292,0.0459,"Price:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[5],"default-bold-small")
	GUIEditor_Edit[5] = guiCreateEdit(0.5388,0.235,0.4178,0.06,(veh.price or ""),true,GUIEditor_Window[2])
	GUIEditor_Label[6] = guiCreateLabel(0.516,0.31,0.4292,0.0459,"Tax:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[6],"default-bold-small")
	GUIEditor_Edit[6] = guiCreateEdit(0.5434,0.36,0.4132,0.06,(veh.tax or ""),true,GUIEditor_Window[2])
	
	GUIEditor_Label["spawnto"] = guiCreateLabel(0.0251,0.435,0.4292,0.0459,"Spawn to carshop:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label["spawnto"],"default-bold-small")
	
	
	gui["spawnto"] =  guiCreateComboBox ( 0.0388,0.485,0.4155,0.06, "None", true, GUIEditor_Window[2])
	
	guiComboBoxAddItem(gui["spawnto"], "None")
	
	guiComboBoxSetSelected(gui["spawnto"],tonumber(veh.spawnto) or -1 )

	GUIEditor_Label["doortype"] = guiCreateLabel(0.516,0.435,0.4292,0.0459,"Doors:",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label["doortype"],"default-bold-small")

	gui["doortype"] = guiCreateComboBox( 0.5388,0.485,0.2,0.06, "Default", true, GUIEditor_Window[2])
	guiComboBoxAdjustHeight(gui["doortype"], 3)
--	outputDebugString(tostring(veh.doortype))
	guiComboBoxAddItem(gui["doortype"], "Default")
	guiComboBoxAddItem(gui["doortype"], "Scissor")
	guiComboBoxAddItem(gui["doortype"], "Butterfly")
	guiComboBoxSetSelected(gui["doortype"], veh.doortype or 0 )

	local fuelType, fuelConsumption, fuelCapacity
	if not fuel.type then
		fuelType = "Petrol"
		fuel.type = "petrol"
	else
		if fuel.type == "petrol" then
			fuelType = "Petrol"
		elseif fuel.type == "diesel" then
			fuelType = "Diesel"
		elseif fuel.type == "electric" then
			fuelType = "Electricity"
		elseif fuel.type == "jet" then
			fuelType = "JET A-1"
		elseif fuel.type == "avgas" then
			fuelType = "100LL AVGAS"
		else
			fuelType = "Petrol"
			fuel.type = "petrol"
		end
	end
	if not fuel.con then
		fuelConsumption = "0"
		fuel.con = 0
	else
		fuelConsumption = tostring(fuel.con)
	end
	if not fuel.cap then
		fuelCapacity = 50
		fuel.cap = 50
	else
		fuelCapacity = tostring(fuel.cap)
	end
	this.fuel = fuel

	--[[
	GUIEditor_Button[10] = guiCreateButton(0.0251,0.56,0.9178,0.08,"FUEL: "..fuelType.." | "..fuelConsumption.." ltr/km | "..fuelCapacity.." ltr",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Button[10],"default-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[10], function()
		if source == GUIEditor_Button[10] then
			editFuel(fuel)
		end
	end)
	--]]

	--outputChatBox(veh.spawnto)
	GUIEditor_Label[7] = guiCreateLabel(0.0251,0.5383+0.1046+0.015,0.4292,0.0459,"Note(s):",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Label[7],"default-bold-small")
	
	GUIEditor_Memo[1] = guiCreateMemo(0.0388,0.6224+0.07,0.9178,0.15,(veh.note or ""),true,GUIEditor_Window[2])
	
	
	GUIEditor_Checkbox[1] = guiCreateCheckBox(0.8,0.435,0.15,0.0459,"Enabled",false,true,GUIEditor_Window[2]) --0.5383
	if veh.enabled and tonumber(veh.enabled) == 1 then
		guiCheckBoxSetSelected(GUIEditor_Checkbox[1], true)
	end
	
	if veh.update then
		GUIEditor_Checkbox[2] = guiCreateCheckBox(0.8,0.495,0.151,0.0459,"Copy",false,true,GUIEditor_Window[2])
	end

	--shit
	GUIEditor_Button[8] = guiCreateButton(0.0388,0.8622,0.4475,0.0944,"Cancel",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Button[8],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[8], function()
		if source == GUIEditor_Button[8] then
			closeAddNewVehicle()
		end
	end)
	
	GUIEditor_Button[9] = guiCreateButton(0.516,0.8622,0.4406,0.0944,"Validate",true,GUIEditor_Window[2])
	guiSetFont(GUIEditor_Button[9],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[9], function()
		if source == GUIEditor_Button[9] then
			validateCreateVehicle(veh)
		end
	end)

	
end
addEvent("vehlib:showEditVehicleRecord", true)
addEventHandler("vehlib:showEditVehicleRecord",getLocalPlayer(), addNewVehicle)

function editFuel(fuel)
	if GUIEditor_Window[3] then
		closeEditFuel()
		return false
	end
	
	--local fuel = this.fuel

	local w, h = 438,392+30
	GUIEditor_Window[3] = guiCreateWindow((sx-w)/2,(sy-h)/2,w,h,"Fuel settings",false)
	guiSetProperty(GUIEditor_Window[3],"AlwaysOnTop","true")
	guiSetProperty(GUIEditor_Window[3],"SizingEnabled","false")

	GUIEditor_Label["engine"] = guiCreateLabel(0.0251,0.0867,0.4292,0.0459,"Engine Type:",true,GUIEditor_Window[3])
	guiSetFont(GUIEditor_Label["doortype"],"default-bold-small")

	gui["engine"] = guiCreateComboBox( 0.0388,0.1327,0.2,0.0791, "Petrol", true, GUIEditor_Window[3])
	guiComboBoxAdjustHeight(gui["engine"], 5)
	--String(tostring(fuel.engine))
	guiComboBoxAddItem(gui["engine"], "Petrol")
	guiComboBoxAddItem(gui["engine"], "Diesel")
	guiComboBoxAddItem(gui["engine"], "Electric")
	guiComboBoxAddItem(gui["engine"], "Turbine (jet a-1)")
	guiComboBoxAddItem(gui["engine"], "Piston (avgas)")
	guiComboBoxSetSelected(gui["engine"], fuel.engine or 0 )

	GUIEditor_Label[8] = guiCreateLabel(0.0251,0.185,0.4292,0.0459,"Consumption (litres/kilometer):",true,GUIEditor_Window[3])
	guiSetFont(GUIEditor_Label[8],"default-bold-small")

	GUIEditor_Edit[8] = guiCreateEdit(0.0388,0.235,0.4155,0.06,(fuel.con or ""),true,GUIEditor_Window[3])

	GUIEditor_Label[9] = guiCreateLabel(0.516,0.185,0.4292,0.0459,"Capacity (litres):",true,GUIEditor_Window[3])
	guiSetFont(GUIEditor_Label[9],"default-bold-small")

	GUIEditor_Edit[9] = guiCreateEdit(0.5388,0.235,0.4178,0.06,(fuel.cap or ""),true,GUIEditor_Window[3])

	--shit
	GUIEditor_Button[11] = guiCreateButton(0.0388,0.8622,0.4475,0.0944,"Cancel",true,GUIEditor_Window[3])
	guiSetFont(GUIEditor_Button[11],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[11], function()
		if source == GUIEditor_Button[11] then
			closeEditFuel()
		end
	end)
	
	GUIEditor_Button[12] = guiCreateButton(0.516,0.8622,0.4406,0.0944,"Update",true,GUIEditor_Window[3])
	guiSetFont(GUIEditor_Button[12],"default-bold-small")
	addEventHandler( "onClientGUIClick", GUIEditor_Button[12], function()
		if source == GUIEditor_Button[12] then
			--validateCreateVehicle(veh)
		end
	end)
end

function closeEditFuel()
	if GUIEditor_Window[3] then
		destroyElement(GUIEditor_Window[3])
		GUIEditor_Window[3] = nil
	end
end

function closeAddNewVehicle()
	if GUIEditor_Window[3] then
		destroyElement(GUIEditor_Window[3])
		GUIEditor_Window[3] = nil
	end
	if GUIEditor_Window[2] then
		destroyElement(GUIEditor_Window[2])
		GUIEditor_Window[2] = nil
	end
	
	if GUIEditor_Window[1] then
		guiSetEnabled(GUIEditor_Window[1], true)
	end
	
	guiSetInputEnabled(false)
end

function validateCreateVehicle(data)
	if guiGetText(GUIEditor_Button[9]) == "Create" or guiGetText(GUIEditor_Button[9]) == "Update" then
		playSoundCreate()
		local veh = {}
		veh.mtaModel = guiGetText(GUIEditor_Edit[1])
		if not tonumber(veh.mtaModel) then
			veh.mtaModel = getVehicleModelFromName(veh.mtaModel)
		end
		veh.brand = guiGetText(GUIEditor_Edit[2])
		veh.model = guiGetText(GUIEditor_Edit[3])
		veh.year = guiGetText(GUIEditor_Edit[4])
		veh.price = guiGetText(GUIEditor_Edit[5])
		veh.tax = guiGetText(GUIEditor_Edit[6])
		veh.note = guiGetText(GUIEditor_Memo[1])
		if data and data.update then 
			veh.update = true
			veh.id = data.id
		else
			veh.update = false
		end
		
		
		if GUIEditor_Checkbox[1] and isElement(GUIEditor_Checkbox[1]) and guiCheckBoxGetSelected(GUIEditor_Checkbox[1]) then
			veh.enabled = true
		else
			veh.enabled = false
		end
		
		if GUIEditor_Checkbox[2] and isElement(GUIEditor_Checkbox[2]) and guiCheckBoxGetSelected(GUIEditor_Checkbox[2]) then
			veh.copy = true
		else
			veh.copy = false
		end
		
		
		local item = guiComboBoxGetSelected ( gui["spawnto"] )
		veh.spawnto = (item == -1) and 0 or item

		local item = guiComboBoxGetSelected ( gui["doortype"] )
		veh.doortype = (item == -1) and 0 or item
		
		triggerServerEvent("vehlib:createVehicle", localPlayer, veh)
		closeAddNewVehicle()
	else
	
		local allGood = true
		--VALIDATE MTA MODEL
		local input = guiGetText(GUIEditor_Edit[1])
		local vehName = getVehicleNameFromModel(input)
		local vehModel = getVehicleModelFromName(input)
		if input == "584" or input == "611" or input == "606" or input == "607" or input == "608" then
			guiSetText(GUIEditor_Label[1], "MTA Vehicle Model (OK!):")
			guiLabelSetColor(GUIEditor_Label[1], 0, 255,0)
		elseif vehName and vehName ~= "" then
			guiSetText(GUIEditor_Label[1], "MTA Vehicle Model (OK!):")
			guiLabelSetColor(GUIEditor_Label[1], 0, 255,0)
		elseif vehModel and tonumber(vehModel) then
			guiSetText(GUIEditor_Label[1], "MTA Vehicle Model (OK!):")
			guiLabelSetColor(GUIEditor_Label[1], 0, 255,0)
		elseif exports.vrp_integration:isPlayerScripter(getLocalPlayer()) then
			guiSetText(GUIEditor_Label[1], "MTA Vehicle Model (OK!):")
			guiLabelSetColor(GUIEditor_Label[1], 0, 255,0)			
		else
			guiSetText(GUIEditor_Label[1], "MTA Vehicle Model (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[1], 255, 0,0)
			allGood = false
		end
		
		--VALIDATE BRAND
		if string.len(guiGetText(GUIEditor_Edit[2])) > 0 then
			guiSetText(GUIEditor_Label[2], "Brand (OK!):")
			guiLabelSetColor(GUIEditor_Label[2], 0, 255,0)
		else
			guiSetText(GUIEditor_Label[2], "Brand (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[2], 255, 0,0)
			allGood = false
		end
		
		--VALIDATE MODEL
		if string.len(guiGetText(GUIEditor_Edit[3])) > 0 then
			guiSetText(GUIEditor_Label[3], "Model (OK!):")
			guiLabelSetColor(GUIEditor_Label[3], 0, 255,0)
		else
			guiSetText(GUIEditor_Label[3], "Model (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[3], 255, 0,0)
			allGood = false
		end
		
		--VALIDATE YEAR
		input = guiGetText(GUIEditor_Edit[4])
		if string.len(input) > 0 and tonumber(input) and tonumber(input) > 1000 and tonumber(input) < 3000 then
			guiSetText(GUIEditor_Label[4], "Year (OK!):")
			guiLabelSetColor(GUIEditor_Label[4], 0, 255,0)
		else
			guiSetText(GUIEditor_Label[4], "Year (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[4], 255, 0,0)
			allGood = false
		end
		
		--VALIDATE PRICE
		input = guiGetText(GUIEditor_Edit[5])
		if string.len(input) > 0 and tonumber(input) and tonumber(input) > 0 then
			guiSetText(GUIEditor_Label[5], "Price (OK!):")
			guiLabelSetColor(GUIEditor_Label[5], 0, 255,0)
		else
			guiSetText(GUIEditor_Label[5], "Price (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[5], 255, 0,0)
			allGood = false
		end
		
		--VALIDATE TAX
		input = guiGetText(GUIEditor_Edit[6])
		if string.len(input) > 0 and tonumber(input) and tonumber(input) >= 0 then
			guiSetText(GUIEditor_Label[6], "Tax (OK!):")
			guiLabelSetColor(GUIEditor_Label[6], 0, 255,0)
		else
			guiSetText(GUIEditor_Label[6], "Tax (Invalid!):")
			guiLabelSetColor(GUIEditor_Label[6], 255, 0,0)
			allGood = false
		end
		
		--CONCLUSION
		if allGood then
			if data and data.update then
				guiSetText(GUIEditor_Button[9], "Update")
			else
				guiSetText(GUIEditor_Button[9], "Create")
			end
			playSuccess()
		else
			guiSetText(GUIEditor_Button[9], "Validate")
			playError()
		end
	end
end

function showConfirmDelete(id, brand, model, createdby)
	local w, h = 394,111
	GUIEditor_Window[3] = guiCreateWindow((sx-w)/2,(sy-h)/2,w,h,"",false)
	guiWindowSetSizable(GUIEditor_Window[3],false)
	guiSetProperty(GUIEditor_Window[3],"AlwaysOnTop","true")
	guiSetProperty(GUIEditor_Window[3],"TitlebarEnabled","false")
	GUIEditor_Label[8] = guiCreateLabel(0.0254,0.2072,0.9645,0.1982,"Are you sure you want to delete veh #"..id.."("..brand.." "..model..")?",true,GUIEditor_Window[3])
	guiLabelSetHorizontalAlign(GUIEditor_Label[8],"center",false)
	GUIEditor_Label[9] = guiCreateLabel(0.0254,0.4054,0.9492,0.2162,"This action can't be undone!",true,GUIEditor_Window[3])
	guiLabelSetHorizontalAlign(GUIEditor_Label[9],"center",false)
	GUIEditor_Button[10] = guiCreateButton(0.0254,0.6577,0.4695,0.2613,"Cancel",true,GUIEditor_Window[3])
	addEventHandler( "onClientGUIClick", GUIEditor_Button[10], function()
		if source == GUIEditor_Button[10] then
			closeConfirmDelete()
		end
	end)
	GUIEditor_Button[11] = guiCreateButton(0.5051,0.6577,0.4695,0.2613,"Confirm",true,GUIEditor_Window[3])
	addEventHandler( "onClientGUIClick", GUIEditor_Button[11], function()
		if source == GUIEditor_Button[11] then
			triggerServerEvent("vehlib:deleteVehicle", localPlayer, id)
			closeConfirmDelete()
			playSuccess()
		end
	end)
end

function closeConfirmDelete()
	if GUIEditor_Window[3] then
		destroyElement(GUIEditor_Window[3])
		GUIEditor_Window[3] = nil
	end
end

function playError()
	playSoundFrontEnd(4)
end

function playSuccess()
	playSoundFrontEnd(13)
end

function playSoundCreate()
	playSoundFrontEnd(6)
end

function guiComboBoxAdjustHeight ( combobox, itemcount )
	if getElementType ( combobox ) ~= "gui-combobox" or type ( itemcount ) ~= "number" then error ( "Invalid arguments @ 'guiComboBoxAdjustHeight'", 2 ) end
	local width = guiGetSize ( combobox, false )
	return guiSetSize ( combobox, width, ( itemcount * 20 ) + 20, false )
end
