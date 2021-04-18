doorCount = {[583] = 1, [574] = 1} -- 1 means two doors, 2 = 3 doors, etc. Tugs have two doors, hence.
controllableDoors = {
	-- 	Type				Pos	# doors		Controlled by seat	Vehicles without that sort of stuff
	--							
	-- Note: 0 can always control all the doors as he's in the driver seat.
	--
	{	"Hood", 			0, 	1, 			0, {Bike = true, BMX = true, Boat = true, Quad = true, Trailer = true, Plane = true, Helicopter = true, ["Monster Truck"] = true, [441] = true, [564] = true, [568] = true, [424] = true, [457] = true, [483] = true, [571] = true, [530] = true, [583] = true, [532] = true, [486] = true, [573] = true, [588] = true, [403] = true, [514] = true, [407] = true, [544] = true, [432] = true, [601] = true, [574] = true, [431] = true, [437] = true}},
	{	"Trunk", 			1,	1, 			0, {Bike = true, BMX = true, Boat = true, Quad = true, Trailer = true, Plane = true, Helicopter = true, ["Monster Truck"] = true, [485] = true, [564] = true, [568] = true, [424] = true, [457] = true, [483] = true, [508] = true, [571] = true, [459] = true, [422] = true, [482] = true, [605] = true, [530] = true, [418] = true, [572] = true, [582] = true, [413] = true, [440] = true, [543] = true, [478] = true, [554] = true, [583] = true, [524] = true, [532] = true, [578] = true, [486] = true, [455] = true, [573] = true, [403] = true, [514] = true, [423] = true, [414] = true, [443] = true, [515] = true, [531] = true, [456] = true, [416] = true, [433] = true, [427] = true, [528] = true, [407] = true, [544] = true, [432] = true, [601] = true, [408] = true, [525] = true, [574] = true, [431] = true, [437] = true, [552] = true}},
	{	"Front left door", 	2, 	1, 			0, {Bike = true, BMX = true, Boat = true, Quad = true, Trailer = true, [485] = true, [464] = true, [501] = true, [465] = true, [564] = true, [568] = true, [424] = true, [457] = true, [571] = true, [530] = true, [572] = true, [486] = true, [531] = true}},
	{	"Front right door", 3, 	1, 			1, {Bike = true, Plane = true, [464] = true, [501] = true, [465] = true, [424] = true, [457] = true}},
	{	"Back left door", 	4, 	3, 			2, {[431] = true, [437] = true}},
	{	"Back right door", 	5, 	4, 			3, {[431] = true, [437] = true}}
}

function getDoorsFor( model, seat )
	local t = {}
	for k, v in ipairs( controllableDoors ) do
		if ( seat == -1 or seat == 0 or seat == v[4] ) and v[4] <= ( doorCount[model] or getVehicleMaxPassengers( model ) or 0 ) then
			if not v[5][model] and not v[5][getVehicleType(model)]then -- some models may be disabled
				table.insert( t, v )
			end
		end
	end
	return t
end

windowless = { [568]=true, [601]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [528]=true, [530]=true, [531]=true, [532]=true, [571]=true, [572]=true }
roofless = { [568]=true, [500]=true, [439]=true, [424]=true, [457]=true, [480]=true, [485]=true, [486]=true, [530]=true, [531]=true, [533]=true, [536]=true, [555]=true, [571]=true, [572]=true, [575]=true }
enginelessVehicle = { [510]=true, [509]=true, [481]=true }
lightlessVehicle = { [592]=true, [577]=true, [511]=true, [548]=true, [512]=true, [593]=true, [425]=true, [520]=true, [417]=true, [487]=true, [553]=true, [488]=true, [497]=true, [563]=true, [476]=true, [447]=true, [519]=true, [460]=true, [469]=true, [513]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [510]=true, [509]=true, [481]=true }
locklessVehicle = { [581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true }
armoredCars = { [427]=true, [528]=true, [432]=true, [601]=true, [428]=true }
platelessVehicles = { [592] = true, [553] = true, [577] = true, [488] = true, [511] = true, [497] = true, [548] = true, [563] = true, [512] = true, [476] = true, [593] = true, [447] = true, [425] = true, [519] = true, [520] = true, [460] = true, [417] = true, [469] = true, [487] = true, [513] = true, [509] = true, [481] = true, 
[510] = true, [472] = true, [473] = true, [493] = true, [595] = true, [484] = true, [430] = true, [453] = true, [452] = true, [446] = true, [454] = true, [571] = true }
bike = { [581]=true, [509]=true, [481]=true, [462]=true, [521]=true, [463]=true, [510]=true, [522]=true, [461]=true, [448]=true, [468]=true, [586]=true, [536]=true, [575]=true, [567]=true, [480]=true, [555]=true }

g_cabriolet = {
	[500] = {1,0}, --Mesa
	[439] = {2,1}, --Stallion
	[506] = {255,0}, --Super GT
	[555] = {255,0}, --Windsor
}

function isVehicleImpounded(theVehicle)
	if (type(getElementData(theVehicle, "Impounded")) == "number") then
		if (getElementData(theVehicle, "Impounded") ~= 0) then
			return true
		end
	end
	return false
end

function isVehicleWindowUp(theVehicle, real)
	if (hasVehicleWindows(theVehicle)) then
		if (hasVehicleRoof(theVehicle)) or (real) then
			local windowState = getElementData(theVehicle, "vehicle:windowstat")
			if (tonumber(windowState) == 0) then
				return true
			end
		end
	end
	return false
end

function hasVehicleWindows(theVehicle)
	if (getVehicleType(theVehicle) == "Automobile") then
		local vehicleModel = getElementModel(theVehicle)
		if not windowless[vehicleModel] then
			return true
		end
	end
	return false
end

function hasVehicleRoof(theVehicle)
	if (getVehicleType(theVehicle) == "Automobile") then
		local vehicleModel = getElementModel(theVehicle)
		if not roofless[vehicleModel] then
			return true
		end
	end
	return false
end

function hasVehiclePlates(theVehicle)
	return not (platelessVehicles[theVehicle] or platelessVehicles[getElementModel(theVehicle)] or false)
end

function hasVehicleEngine(theVehicle)
	return not enginelessVehicle[getElementModel(theVehicle)]
end

function hasVehicleLights(theVehicle)
	return not lightlessVehicle[getElementModel(theVehicle)]
end

function isCabriolet(theVehicle) -- bekiroj
	local model = getElementModel(theVehicle)
	if g_cabriolet[model] then
		local variant, variant2 = getVehicleVariant(theVehicle)
		if(g_cabriolet[model][1] == variant or g_cabriolet[model][2] == variant) then
			return true
		end
	end
	return false
end

function isActive(veh)
	local job = getElementData(veh, "job") or 0
	local owner = getElementData(veh, "owner") or -1
	local faction = getElementData(veh, "faction") or -1
	local Impounded = getElementData(veh, "Impounded") or 0
	if job ~= 0 or owner <= 0 or faction ~= -1 or Impounded ~= 0 then
		return true
	elseif getVehicleType(veh) == "Trailer" then
		return true
	else
		local oneDay = 60*60*24
		local owner_last_login = getElementData(veh, "owner_last_login")
		if owner_last_login and tonumber(owner_last_login) then
			local owner_last_login_text, owner_last_login_sec = exports.vrp_datetime:formatTimeInterval(owner_last_login)
			if owner_last_login_sec > oneDay*30 then
				return false, "Inactive Vehicle | Owner is inactive ("..owner_last_login_text..")", owner_last_login_sec
			end
		end

		local int = getElementInterior(veh)
		local dim = getElementDimension(veh)
		if int == 0 and dim == 0 then
			local lastused = getElementData(veh, "lastused")
			if lastused and tonumber(lastused) then
				local lastusedText, lastusedSeconds = exports.vrp_datetime:formatTimeInterval(lastused)
				if lastusedSeconds > oneDay*14 then
					return false, "Inactive Vehicle | Last used "..lastusedText.." while parking outdoor", lastusedSeconds
				end
			end
		end
	end
	return true 
end

function isProtected(veh)
	local job = getElementData(veh, "job") or 0
	local owner = getElementData(veh, "owner") or -1
	local faction = getElementData(veh, "faction") or -1
	if job ~= 0 or owner <= 0 or faction ~= -1 then
		return false
	end
	local protected_until = getElementData(veh, "protected_until") or -1
	local protectText, protectSeconds = exports.vrp_datetime:formatFutureTimeInterval(protected_until)
	return protectSeconds > 0, protectText, protectSeconds
end