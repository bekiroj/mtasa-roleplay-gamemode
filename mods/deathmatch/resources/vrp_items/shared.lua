function getItemRotInfo(id)
	if not g_items[id] then
		return 0, 0, 0, 0
	else
		return  g_items[id][5], g_items[id][6], g_items[id][7], g_items[id][8]
	end
end

local _vehiclecache = {}
local function findVehicleName( value )
	if _vehiclecache[value] then
		return _vehiclecache[value]
	end
	
	for _, theVehicle in pairs( getElementsByType( "vehicle" ) ) do
		if getElementData( theVehicle, "dbid" ) == value then
			_vehiclecache[value] = exports.vrp_global:getVehicleName( theVehicle )
			return _vehiclecache[value]
		end
	end
	return "?"
end

function getItemName(id, value)
	if not id or not tonumber(id) then
		return "Loading.."
	end
	if id == -100 then
		return "Body Armor"	
	elseif id == -46 then -- MTA Client bug
		return "Parachute"
	elseif id < 0 then
		return getWeaponNameFromID( -id )
	elseif not g_items[id] then
		return "?"
	elseif id == 3 and value then
		return g_items[id][1] .. " (" .. findVehicleName(value) .. ")", findVehicleName(value)
	elseif ( id == 4 or id == 5 ) and value then
		local pickup = exports['vrp_interiors']:findParent( nil, value )
		local name = isElement(pickup) and getElementData( pickup, "name" )
		return g_items[id][1] .. ( name and ( " (" .. name .. ")" ) or "" ), name
	elseif ( id == 80 ) and value then
		return value
	elseif ( id == 214 ) and value then
		return value
	elseif ( id == 90 or id == 171 or id == 172 ) and value then
		local itemValue = explode(";", value)
		if itemValue[1] and itemValue[2] then
			local customName = tostring(itemValue[1]).." helmet"
			return customName
		else
			return g_items[id][1]
		end
	elseif ( id == 96 ) and value and value ~= 1 then
		return value
	elseif ( id == 89 or id == 95 or id == 109 or id == 110 ) and value and value:find( ";" ) ~= nil then
		return value:sub( 1, value:find( ";" ) - 1 )
	elseif (id == 115 or id == 116) and value then
		local itemExploded = explode(":", value )
		return itemExploded[3] 
	elseif (id == 150) and value then --ATM card
		local itemExploded = explode(";", value )
		local text = "ATM card"
		if itemExploded and itemExploded[3] then
			if tonumber(itemExploded[3]) == 1 then
				text = text.." - Basic"
			elseif tonumber(itemExploded[3]) == 2 then
				text = text.." - Premium"
			elseif tonumber(itemExploded[3]) == 3 then
				text = text.." - Ultimate"
			end
		end
		return text
	elseif(id == 165) then --video disc
		local disc = tonumber(value) or 0
		if disc > 1 then
			local discData = exports.vrp_fakevideo:getFakevideoData(disc)
			if discData then
				return 'DVD "'..tostring(discData.name)..'"'
			end 
		else
			return "Empty DVD"
		end
		return "DVD"
	elseif(id == 175) then --poster
		if value and not tonumber(value) then
			local itemExploded = explode(";", value)
			local name = tostring(itemExploded[1].." Poster")
			return name
		else
			return g_items[id][1]
		end
	elseif(id == 226) then --bayrak
		if value and not tonumber(value) then
			local itemExploded = explode(";", value)
			local name = tostring(itemExploded[1])
			return name
		else
			return g_items[id][1]
		end
	--[[elseif(id == 178) then
		local yup = split(value, ":")
		return yup[1] or "book".." by ".. yup[2] or ""]]
	else
		return g_items[id][1]
	end
end

silahlar = {
	[22] = true,
	[23] = true,
	[24] = true,
	[25] = true,
	[26] = true,
	[27] = true,
	[28] = true,
	[29] = true,
	[32] = true,
	[30] = true,
	[31] = true,
	[33] = true,
	[34] = true,
	[35] = true,
	[36] = true,
	[1] = true,
	[4] = true,
	[5] = true,
	[9] = true,
}

function getItemValue(id, value)
	if id == 80 then
		return ""
	elseif id == 214 then
		return ""
	--elseif id == 96 then
		--return 1
	elseif id == 10 and tostring(value) == "1" then
		return 6
	elseif (id == 89 or id == 95 or id == 109 or id == 110) and value and value:find( ";" ) ~= nil then
		return value:sub( value:find( ";" ) + 1 )
	elseif (id == 115 and value) then
		local weaponName = explode(":", value)[3]
		if weaponName then
		
		local checkString = string.sub(weaponName, -4) -- envanterde mouse'yi bıçağın üzerine götürdüğümüzde string expected nil hatası veriyor. Envanter buga giriyor.
		if (checkString == " (D)")  then
			return explode(":", value)[2]
		end
		local silahHak = #tostring(explode(":", value)[5])>0 and explode(":", value)[5] or 3
		--local silahHak = #tostring(explode(":", value[2])[6])>0 and tonumber(explode(":", value[2])[6]) or 3
		if silahlar[tonumber(explode(":", value)[1])] then
		erenbaba = explode(":", value)[2].."\n Silah Hakkı: "..silahHak -- SİLAH SERİALİ BURDAN ÇEKİLİYOR.. 
		else
		erenbaba = explode(":", value)[2] -- SİLAH SERİALİ BURDAN ÇEKİLİYOR.. 
		end return erenbaba
		end
	elseif id == 116 and value then
		return value:gsub("^(%d+):(%d+):", "%2 ")
	else
		return value
	end
end
	
	

function getItemDescription(id, value)
	--if true then return "blag" end
	local i = g_items[id]
	if i then
		local desc = i[2]
		if id == 90 or id == 171 or id == 172 then
			local itemValue = explode(";", value)
			if itemValue[3] then
				local helmetDesc = tostring(itemValue[3])
				return helmetDesc
			else
				return desc:gsub("#v",value)
			end
		elseif id == 96 and value ~= 1 then
			return desc:gsub("PDA","Laptop")
		elseif id == 114 then 
			if tonumber(value) == nil then return nil end
			local v = tonumber(value) - 999
			return desc:gsub("#v", vehicleupgrades[v] or "?")
		elseif id == 150 then--ATM card
			local itemExploded = explode(";", value)
			if tonumber( itemExploded[2] ) > 0 then
				return "Card Number: '"..itemExploded[1].."', Owner: '"..tostring(exports.vrp_cache:getCharacterNameFromID(itemExploded[2])):gsub("_", " ").."'"
			else
				return "Card Number: '"..itemExploded[1].."', Owner: '"..tostring(exports.vrp_cache:getBusinessNameFromID(math.abs(itemExploded[2]))).."'"
			end
		elseif id == 152 then--ID card
			local itemExploded = explode(";", value)
			return ""..tostring(itemExploded[1]):gsub("_", " ").." isimli kullanıcının kimlik kartı."
		elseif id == 178 then
			local yup = split(value, ":")
            return yup[1] .." by ".. yup[2]
		else
			return desc:gsub("#v",value)
		end
	end
end

function getItemType(id)
	return ( g_items[id] or { nil, nil, 4 } )[3]
end

function getItemModel(id, value)
	if id == 115 and value then
		--return value
		local itemExploded = explode(":", value )
		return weaponmodels[ tonumber(itemExploded[1]) ] or 1271
	else
		return ( g_items[id] or { nil, nil, nil, 1271 } )[4]
	end
end

function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
	pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

function getItemTab(id)
	if getItemType( id ) == 2 then
		return 3
	elseif getItemType( id ) == 8 or getItemType( id ) == 9 then
		return 4
	elseif getItemType( id ) == 10 then
		return 1
	else
		return 2
	end
end

function getItemWeight( itemID, itemValue )
	local weight = g_items[ itemID ] and g_items[ itemID ].weight
	return type(weight) == "function" and weight( tonumber(itemValue) or itemValue ) or weight 
end

function getItemScale( itemID )
	local scale = g_items[ itemID ] and g_items[ itemID ].scale
	return scale
end
function getItemDoubleSided( itemID )
	local dblsided = g_items[ itemID ] and g_items[ itemID ].doubleSided
	return dblsided
end
function getItemTexture( itemID, itemValue )
	if itemID == 90 or itemID == 171 or itemID == 172 then --helmet
		if itemValue then
			local texname = {
				[90] = "helmet",
				[171] = "helmet_b",
				[172] = "helmet_f"
			}
			itemValue = explode(";", itemValue)
			if itemValue[2] then
				local texture = { {tostring(itemValue[2]), texname[itemID]} }
				return texture
			end
		end
	elseif itemID == 167 and itemValue then --framed picture
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_painting34"} }
			return texture
		end
	elseif itemID == 175 and itemValue then --poster
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "cj_don_post_2"} }
			return texture
		end
	elseif itemID == 226 and itemValue then --poster
		itemValue = explode(";", itemValue)
		if itemValue[2] then
			local texture = { {tostring(itemValue[2]), "goflag"} }
			return texture
		end
	end
	local texture = g_items[ itemID ] and g_items[ itemID ].texture
	return texture
end
function getItemPreventSpawn( itemID, itemValue )
	local preventSpawn = g_items[ itemID ] and g_items[ itemID ].preventSpawn
	return preventSpawn
end
function getItemUseNewPickupMethod( itemID )
	local use = g_items[ itemID ] and g_items[ itemID ].newPickupMethod
	return use
	--return true
end
function getItemHideItemValue( itemID )
	local use = g_items[ itemID ] and g_items[ itemID ].hideItemValue
	return use
end
function isItem( id )
	return g_items[tonumber(id)]
end


itemBannedByAltAltChecker = { 
	[2] = true, --CELLPHONE
	[3] = true, --VEHICLE KEY
	[4] = true, --HOUSE KEY
	[5] = true, --BUSINESS KEY
	[68] = true, --LOTTERY TICKET
	[73] = true, --ELEVATOR REMOTE
	[74] = true, --BOMB
	[75] = true, --BOMB REMOTE
	[98] = true, --GARAGE REMOTE
	[114] = true, --VEHICLE UPGRADE
	[115] = true, --WEAPONS
	[116] = true, --AMMOPACKS
	[134] = true, --MONEY
	[150] = true, --ATM CARD
}

function getPlayerMaxCarryWeight(element)
	local weightCount = 15 -- Default storage capability in kg 

	if hasItem(element, 48) then weightCount = weightCount + 10 end -- backpack
	if hasItem(element, 126) then weightCount = weightCount + 7.5 end -- duty belt
	if hasItem(element, 160) then weightCount = weightCount + 2 end -- briefcase
	if hasItem(element, 163) then weightCount = weightCount + 15 end -- dufflebag
	if hasItem(element, 164) then weightCount = weightCount + 15 end -- medical bag
	return weightCount
end
