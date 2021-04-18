local modsTable = {}
local index = 1314
modsTable[index] = {
	txd = "mods/icons.txd",
	dff = "mods/disabledicon.dff",
}

local index = 14776
modsTable[index] = {
	col = "mods/fixes/interior24.col",
}

local index = 3916
modsTable[index] = {
	txd = "items/armour.txd",
	dff = "items/armour.dff",
}

local index = 3027
modsTable[index] = {
	txd = "items/Ciggy1.txd",
	dff = "items/Ciggy1.dff",
}

local index = 2012
modsTable[index] = {
	dff = "items/exhale.dff",
}

local index = 494
modsTable[index] = {
	txd = "mods/hsu.txd",
	dff = "mods/hsu.dff",
}

local index = 417
modsTable[index] = {
	txd = "mods/levi.txd",
	dff = "mods/levi.dff",
}

local index = 470
modsTable[index] = {
	txd = "mods/vehicles/patriot.txd",
	dff = "mods/vehicles/patriot.dff",
}

local index = 578
modsTable[index] = {
	txd = "mods/vehicles/dft30.txd",
	dff = "mods/vehicles/dft30.dff",
}

local index = 538
modsTable[index] = {
	txd = "mods/vehicles/streak.txd",
	dff = "mods/vehicles/streak.dff",
}

local index = 570
modsTable[index] = {
	txd = "mods/vehicles/streakc.txd",
	dff = "mods/vehicles/streakc.dff",
}

local index = 611
modsTable[index] = {
	txd = "mods/vehicles/trailer.txd",
	dff = "mods/vehicles/trailer.dff",
}

local index = 582
modsTable[index] = {
	txd = "mods/vehicles/newsvan.txd",
}

local index = 488
modsTable[index] = {
	txd = "mods/vehicles/vcnmav.txd",
}

local index = 2287
modsTable[index] = {
	col = "mods/cols/frame_4.col",
}

local index = 330
modsTable[index] = {
	txd = "mods/items/cellphone.txd",
	dff = "mods/items/cellphone.dff",
}

local index = 2880
modsTable[index] = {
	txd = "items/cola.txd",
	dff = "items/cola.dff",
}
--[[
local index = 283
modsTable[index] = {
	txd = "skins/283.txd",
	dff = "skins/283.dff",
}

local index = 266
modsTable[index] = {
	txd = "skins/266.txd",
	dff = "skins/266.dff",
}

local index = 27
modsTable[index] = {
	txd = "skins/27.txd",
	dff = "skins/27.dff",
}

local index = 37
modsTable[index] = {
	txd = "skins/37.txd",
	dff = "skins/37.dff",
}

local index = 127
modsTable[index] = {
	txd = "skins/127.txd",
	dff = "skins/127.dff",
}
]]--
local index = 416
modsTable[index] = {
	txd = "mods/vehicles/ambulance.txd",
	dff = "mods/vehicles/ambulance.dff",
}

--create temp skin table
local skins = {1,2,7,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,43,44,45,46,47,48,49,51,52,54,55,56,57,58,59,60,61,62,63,66,67,91,93,97,102,103,104,105,106,107,108,109,110,111,112,114,115,116,117,118,173,174,175,176,184,217,240,271,292,293,299,303,306}

--for index, value in ipairs(skins) do
--	modsTable[value] = {
--		txd = "skins/"..value..".txd",
--		dff = "skins/"..value..".dff",
--	}
--end

function getModdedSkins()
	return skins or {}
end

function loadMods()
	for index, value in pairs(modsTable) do
	--thread:foreach(modsTable, function(value)
		if value.txd and fileExists(value.txd) then
			txd = engineLoadTXD(value.txd)
			engineImportTXD(txd, index)
		end
		if value.dff and fileExists(value.dff) then
			dff = engineLoadDFF(value.dff)
			engineReplaceModel(dff, index)
		end
		if value.col and fileExists(value.col) then
			col = engineLoadCOL(value.col)
			engineReplaceCOL(col, index)
		end
	end
end

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadMods()
	end
)