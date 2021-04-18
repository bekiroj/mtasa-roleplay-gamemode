mysql = exports.vrp_mysql
_sdn = setElementData

function setElementData(element, data, key)
	if isElement(element) then
		if (data == "bakiye") and getElementData(element, "account:id") and getElementData(element, "account:id") > 0 then
			dbExec(mysql:getConnection(), "UPDATE accounts SET bakiye = '"..key.."' WHERE id='"..getElementData(element, "account:id").."'")
		end
		return _sdn(element, data, key)
	end
end

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM vehicles AS e1 LEFT JOIN vehicles AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function bakiyeEkle(thePlayer, commandName, targetPlayer, bakiye)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if (not tonumber(bakiye)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /bakiyever <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncuya başarıyla ["..bakiye.." TL] bakiye eklediniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili size ["..bakiye.." TL] bakiye ekledi.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "bakiye", tonumber(getElementData(targetPlayer, "bakiye") + bakiye))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiye = bakiye + " ..bakiye.. " WHERE id = '" .. escapedID .. "'")
				local from, to, action = thePlayer:getData('account:id'), targetPlayer:getData('account:id'), "/bakiyever"
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyever", bakiyeEkle)

function bakiyeCikar(thePlayer, commandName, targetPlayer, bakiye)
	if exports.vrp_integration:isPlayerDeveloper(thePlayer) then
		if (not tonumber(bakiye)) then
			outputChatBox("[!] #ffffffBirşey yazmadınız. /bakiyeal <id> <miktar>", thePlayer, 255, 0, 0, true)
		else
			local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			if targetPlayer then
				local dbid = getElementData(targetPlayer, "account:id")
				local escapedID = (dbid)
				outputChatBox("[!] #ffffff"..targetPlayerName.." isimli oyuncunun başarıyla ["..bakiye.." TL] bakiyesini eksilttiniz.", thePlayer, 0, 255, 0, true)
				outputChatBox("[!] #ffffff"..getPlayerName(thePlayer).." isimli yetkili sizden ["..bakiye.." TL] bakiye eksiltti.", targetPlayer, 0, 255, 0, true)
				setElementData(targetPlayer, "bakiye", tonumber(getElementData(targetPlayer, "bakiye") - bakiye))
				dbExec(mysql:getConnection(), "UPDATE accounts SET bakiye = bakiye - " ..bakiye.. " WHERE id = '" .. escapedID .. "'")
				local from, to, action = thePlayer:getData('account:id'), targetPlayer:getData('account:id'), "/bakiyeal"
			end
		end
	else 
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyeal", bakiyeCikar)

function bakiyeGoster(thePlayer)
	bakiyeBilgim = getElementData(thePlayer, "bakiye")
	outputChatBox("[!] #ffffffBakiye bilginiz: ["..bakiyeBilgim.." TL] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
end
addCommandHandler("bakiyem", bakiyeGoster)

function bakiyeKontrol(thePlayer, commandName, targetPlayer, bakiyeBilgim)
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) then
		local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
		bakiyeBilgim = getElementData(targetPlayer, "bakiye")
		outputChatBox("[!] #ffffff"..targetPlayerName.." Isimli oyuncunun bakiye bilgisi ["..bakiyeBilgim.." TL] olarak görüntüleniyor.", thePlayer, 0, 0, 255, true)
		end
	else
		outputChatBox("[!] #ffffffBu işlemi yapmak için yetkiniz yok.", thePlayer, 255, 0, 0, true)
	end
end
addCommandHandler("bakiyekontrol", bakiyeKontrol)

function isimDegistirOnayla(isim, fiyat)
	local stat,errort = checkValidCharacterName(isim)
	if not stat then
		outputChatBox("[!] #ffffff"..errort, source, 255, 0, 0, true)
		return false
	end
	isim = string.gsub(tostring(isim), " ", "_")
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(characters) do
		if value.charactername == isim then 
			outputChatBox("[!] #ffffffBu isim zaten kullanımda.", source, 255, 0, 0, true)
			return false
		end
	end
	local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
	if bakiyeCek < 10 then
		outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 0, 0, true)
		return false
	end
	outputChatBox("[!] #ffffffBaşarıyla isim değiştirdiniz.", source, 0, 255, 0, true)
	setElementPosition(source, 2092.373046875, -1779.6650390625, 13.746875)
	setElementRotation(source, 0, 0, 75.315185546875)
	setElementInterior(source, 0)
	setElementDimension(source, 0)
	setElementData(source, "bakiye", getElementData(source, "bakiye") - fiyat)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
	outputChatBox("[!] #ffffff'"..getPlayerName(source) .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 0, 255, 0, true)
	changeName(source, isim)
	
end
addEvent("market->isimDegistirOnayla",true)
addEventHandler("market->isimDegistirOnayla", root, isimDegistirOnayla)

function changeName(targetPlayer,newName)
	exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 1, false)
	local name = setPlayerName(targetPlayer, tostring(newName))
	local dbid = getElementData(targetPlayer, "dbid")
	local targetPlayerName = getPlayerName(targetPlayer)
	if (name) then
		exports['vrp_cache']:clearCharacterName( dbid )
		dbExec(mysql:getConnection(),"UPDATE characters SET charactername='" .. (newName) .. "' WHERE id = " .. (dbid))
		local adminTitle = "[MARKET]"
		local processedNewName = string.gsub(tostring(newName), "_", " ")
		exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
		exports.vrp_logs:dbLog(thePlayer, 4, targetPlayer, "MARKET ISIM DEGISIKLIGI "..targetPlayerName.." -> "..tostring(newName))
	else
		outputChatBox("[!] #ffffffBaşarısız oldu.", thePlayer, 255, 0, 0, true)
	end
	exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "legitnamechange", 0, false)
end

function kisimDegistirOnayla(isim, fiyat)
	local stat,errort = checkValidUsername(isim)
	if not stat then
		outputChatBox("[!] #ffffff"..errort, source, 255, 0, 0, true)
		return false
	end
	local accounts, characters = exports.vrp_account:getTableInformations()
	for index, value in ipairs(accounts) do
		if value.username == isim then 
			outputChatBox("[!] #ffffffBu isim zaten kullanımda.", source, 255, 0, 0, true)
			return false
		end
	end
	local bakiyeCek = tonumber(getElementData(source, "bakiyeMiktar"))
	if bakiyeCek < 10 then
		outputChatBox("[!] #ffffffBu işlem için 10 TL bakiyeniz olması gerekmektedir.", source,255, 0, 0, true)
		return false
	end
	setElementData(source, "bakiye", bakiyeCek - fiyat)
	outputChatBox("[!] #ffffffBaşarıyla isim değiştirdiniz.", source, 0, 255, 0, true)
	setElementData(source, "OOCHapisKontrol", 0)
	outputChatBox("(( " ..getPlayerName(source):gsub("_", " ").. " sunucudan yasaklandı. Sure: Sınırsız Gerekce: Kullanıcı Adı Değişikliği - " ..string.format("%02d", hours)..":"..string.format("%02d", minutes).. " ))", arrarPlayer, 255, 0, 0)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getElementData(source, "account:username") .. "' isimli oyuncu ismini '" .. isim .. "' olarak değiştirildi.")
	outputChatBox("[!] #ffffff'"..getElementData(source, "account:username") .. "' olan isminizi '" .. tostring(isim) .. "' olarak değiştirdiniz.", source, 0, 255, 0, true)
	local dbid = getElementData(source, "account:id")
	setElementData(source, "account:username", isim)
	dbExec(mysql:getConnection(), "UPDATE accounts SET username='" .. (isim) .. "' WHERE id = " .. (dbid))
	setElementData(source, "account:username", isim)
end
addEvent("market->kisimDegistirOnayla",true)
addEventHandler("market->kisimDegistirOnayla", root, kisimDegistirOnayla)

function vipVerdirtme(vipSeviye, vipGun, vipFiyat)
	exports["vrp_vipsystem"]:addVIP(source, vipSeviye, vipGun)
	setElementData(source, "bakiye", getElementData(source, "bakiye") - math.ceil(vipFiyat))
	outputChatBox("[!] #ffffffTebrikler, başarıyla "..vipGun.." günlük VIP ["..vipSeviye.."] aldınız.", source, 0, 255, 0, true)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu "..vipGun.." günlük VIP [" .. vipSeviye .. "] aldı.")
end
addEvent("market->vipVer", true)
addEventHandler("market->vipVer", root, vipVerdirtme)


function karakterSlotArttirmaLOG(fiyat)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(source) .. "' isimli oyuncu +1 karakter slotu arttırma aldı.")
	karakterLimit = getElementData(source, "account:charLimit")
	setElementData(source, "account:charLimit", getElementData(source, "account:charLimit")+1)
	setElementData(source, "bakiye", getElementData(source, "bakiye") - fiyat)
	dbExec(mysql:getConnection(), "UPDATE accounts SET characterlimit = characterlimit+1 WHERE username='"..getElementData(source, "account:username").."'")
end
addEvent("market->karakterSlotLOG", true)
addEventHandler("market->karakterSlotLOG", root, karakterSlotArttirmaLOG)

function aracSlotArttirmaLOG(player, fiyat)
	dbExec(mysql:getConnection(), "UPDATE characters SET maxvehicles = maxvehicles+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "maxvehicles", tonumber(getElementData(player, "maxvehicles"))+1)
	setElementData(player, "bakiye", tonumber(getElementData(player, "bakiye"))-fiyat)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +1 araç slotu arttırma aldı.")
end
addEvent("market->aracSlot", true)
addEventHandler("market->aracSlot", root, aracSlotArttirmaLOG)

function evSlotArttirmaLOG(player, fiyat)
	dbExec(mysql:getConnection(), "UPDATE characters SET maxinteriors = maxinteriors+1 WHERE id = " .. (getElementData(player, "dbid")))
	setElementData(player, "maxinteriors", tonumber(getElementData(player, "maxinteriors"))+1)
	setElementData(player, "bakiye", tonumber(getElementData(player, "bakiye"))-5)
	exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu +1 ev slotu arttırma aldı.")
end
addEvent("market->evSlot", true)
addEventHandler("market->evSlot", root, evSlotArttirmaLOG)

function privateCarCreate(vehid, brandid, rgb, balance, vehname, plateState, plateEditText)
	local player = source

	-- BALANCE CONTROL
	local playerBalance = getElementData(player, "bakiye") or 0
	if playerBalance < balance then
		return
	end

	local r, g, b = unpack(rgb)
	if tonumber(vehid) and tonumber(brandid) then
		setElementData(player, "bakiye", playerBalance - balance)
		outputChatBox("[!]#ffffff Aracı başarıyla satın aldınız, /a park yapmayı unutmayın!", player, 0, 255, 0, true)
		outputChatBox("[!]#ffffff Alınan Araç: "..vehname, player, 0, 255, 0, true)
		
		local hours = getRealTime().hour
		local minutes = getRealTime().minute
		local seconds = getRealTime().second
		local day = getRealTime().monthday
		local month = getRealTime().month+1
		local year = getRealTime().year+1900
		exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." marka araç satın aldı.")

		local pr = getPedRotation(player)
		local dbid = getElementData(player, "dbid")
		local x, y, z = getElementPosition(player)
		x = x + ( ( math.cos ( math.rad ( pr ) ) ) * 5 )
		y = y + ( ( math.sin ( math.rad ( pr ) ) ) * 5 )
		local model = vehid
		local veh = createVehicle(model, x,y,z)
		setVehicleColor(veh, r,g,b)
		local rx, ry, rz = getElementRotation(veh)
		local var1, var2 = exports['vrp_vehicle']:getRandomVariant(vehid)
		local letter1 = string.char(math.random(65,90))
		local letter2 = string.char(math.random(65,90))
		if plateEditText == "" then
			plate = letter1 .. letter2 .. math.random(0, 9) .. " " .. math.random(1000, 9999)
		else
			plate = plateEditText
		end
		local color1 = toJSON( {r,g,b} )
		local color2 = toJSON( {0, 0, 0} )
		local color3 = toJSON( {0, 0, 0} )
		local color4 = toJSON( {0, 0, 0} )
		local interior, dimension = getElementInterior(player), getElementDimension(player)
		local tint = 0
		local factionVehicle = -1
		local smallestID = SmallestID()
		local inserted = dbExec(mysql:getConnection(), "INSERT INTO vehicles SET model='" .. (vehid) .. "', x='" .. (x) .. "', y='" .. (y) .. "', z='" .. (z) .. "', rotx='0', roty='0', rotz='" .. (pr) .. "', color1='" .. (color1) .. "', color2='" .. (color2) .. "', color3='" .. (color3) .. "', color4='" .. (color4) .. "', faction='" .. (factionVehicle) .. "', owner='" .. (dbid) .. "', plate='" .. (plate) .. "', currx='" .. (x) .. "', curry='" .. (y) .. "', currz='" .. (z) .. "', currrx='0', currry='0', currrz='" .. (pr) .. "', locked='1', interior='" .. (interior) .. "', currinterior='" .. (interior) .. "', dimension='" .. (dimension) .. "', currdimension='" .. (dimension) .. "', tintedwindows='" .. (tint) .. "',variant1='"..var1.."',variant2='"..var2.."', creationDate=NOW(), createdBy='-1', `vehicle_shop_id`='"..brandid.."' ")
		if inserted then
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						local insertid = res[1].id
						if not insertid then
							setElementData(player, "bakiye", playerBalance + balance)
							exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu "..vehname.." marka aldığı araç işlenemediği için parası iade edildi.")
							outputChatBox("Aldığın araç veritabanına işlenemediği için paran iade edildi!", player, 255,0,0)
							return false
						end
						call( getResourceFromName( "vrp_items" ), "deleteAll", 3, insertid )
						exports.vrp_global:giveItem( player, 3, insertid )
						--setElementData(veh, "dbid", insertid)
						destroyElement(veh)
						exports['vrp_vehicle']:reloadVehicle(insertid)
					end
				end,
			mysql:getConnection(), "SELECT id FROM vehicles WHERE id=LAST_INSERT_ID() LIMIT 1")
		end
	end
end
addEvent("market->donateSatinAl", true)
addEventHandler("market->donateSatinAl", root, privateCarCreate)



restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end
addEvent("market->silahHakEkle", true)
addEventHandler("market->silahHakEkle", root,
	function(player, itemIndex, price)
		
		
		local itemSlot = exports['vrp_items']:getItems(player)
		for i, v in ipairs(itemSlot) do
			if v[3] == itemIndex then
				if not v[1] == 115 or restrictedWeapons[tonumber(exports.vrp_global:explode(":", v[2])[1])] then
					return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", player, 255, 0, 0, true)
				end
				local eskiHak = (#tostring(exports.vrp_global:explode(":", v[2])[5])>0 and exports.global:explode(":", v[2])[5]) or 3
				eskiHak = not restrictedWeapons[tonumber(exports.vrp_global:explode(":", v[2])[1])] and eskiHak or "-"
				yeniHak = eskiHak + 1
				silahAdi = tostring(exports.vrp_global:explode(":", v[2])[3])
				local checkString = string.sub(exports.vrp_global:explode(":", v[2])[3], -4) == " (D)"
				if checkString then
					return outputChatBox("[!] #ffffffBu komut Duty silahlarında kullanılamaz!", player, 255, 0, 0, true)
				end
				
				exports.vrp_global:takeItem(player, 115, v[2])
				eren = exports.vrp_global:explode(":",v[2])[1]..":"..exports.vrp_global:explode(":",v[2])[2]..":"..exports.vrp_global:explode(":",v[2])[3].."::"..yeniHak
				exports.vrp_global:giveItem(player, 115, eren)
			
				outputChatBox("[!] #ffffff"..exports.vrp_global:explode(":", v[2])[3].." silahının hakkı arttırıldı. Eski Hak: "..eskiHak.." - Yeni Hak: "..yeniHak, player, 0, 55, 255, true)
				
			end
		end
		setElementData(player, "bakiye", getElementData(player, "bakiye")-price)
	end
)

addEvent("market->silahSatinAl", true)
addEventHandler("market->silahSatinAl", root, function(weaponid, price)
local mySerial = exports.vrp_global:createWeaponSerial( 1, getElementData(source, "dbid"), getElementData(source, "dbid"))
	if  exports.vrp_global:giveItem(source, 115, weaponid..":"..mySerial..":"..getWeaponNameFromID(weaponid).."::") then
		setElementData(source, "bakiye", getElementData(source, "bakiye") - price)
		outputChatBox("[!]#ffffff Başarıyla "..getWeaponNameFromID(weaponid).." İsimli silahı satın aldınız.",source,0,255,0,true)
	else
		outputChatBox("[!]#ffffff Maalesefki üzerinizde yeterli miktarda yer yok.",source,255,0,0,true)
	end
end)

function vehTintPrivate(vehID, price)
	local vehicle = exports.vrp_pool:getElement("vehicle", vehID)
	if vehicle and isElement(vehicle) then
		if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
			local bakiyeCek = tonumber(getElementData(source, "bakiye"))
			local vid = tonumber(getElementData(vehicle, "dbid"))
			if bakiyeCek < price then
				outputChatBox("[!] #ffffffYeterli bakiyeniz yok.", source, 255, 0, 0, true)
				return
			end
			dbExec(mysql:getConnection(), "UPDATE vehicles SET tintedwindows = '1' WHERE id='" .. (vid) .. "'")
			for i = 0, getVehicleMaxPassengers(vehicle) do
				local player = getVehicleOccupant(vehicle, i)
				if (player) then
					triggerEvent("setTintName", vehicle, player)
				end
			end

			exports.vrp_anticheat:changeProtectedElementDataEx(vehicle, "tinted", true, true)
			triggerClientEvent("tintWindows", vehicle)
			outputChatBox("[!] #ffffffAraca cam filmi başarıyla eklendi.", source, 0, 255, 0, true)
			setElementData(source, "bakiye", bakiyeCek-price)
		else
			outputChatBox("[!] #ffffffAracın sahibi siz değilsiniz.", source, 255, 0, 0, true)
		end
	else
		outputChatBox("[!] #ffffffAraç bulunamadı.", source, 255, 0, 0, true)
	end
end
addEvent("market->camFilm", true)
addEventHandler("market->camFilm", root, vehTintPrivate)

function vehDoorPrivate(vehID, price)
	local vehicle = exports.vrp_pool:getElement("vehicle", vehID)
	if vehicle and isElement(vehicle) then
		if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
			local bakiyeCek = tonumber(getElementData(source, "bakiye"))
			local vid = tonumber(getElementData(vehicle, "dbid"))
			if bakiyeCek < price then
				outputChatBox("[!] #ffffffYeterli bakiyeniz yok.", source, 255, 0, 0, true)
				return
			end
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						dbExec(mysql:getConnection(), "UPDATE vehicles_custom SET doortype = '2' WHERE id='" .. (vid) .. "'")
						setTimer(function() exports["vrp_vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
						
					else
						dbQuery(
							function(qh)
								local res, rows, err = dbPoll(qh, 0)
								if rows > 0 then
									row = res[1]
									dbExec(mysql:getConnection(), "INSERT INTO vehicles_custom SET id='"..vid.."', doortype='2', brand='"..row.vehbrand.."', model='"..row.vehmodel.."', year='"..row.vehyear.."' ")
									setTimer(function() exports["vrp_vehicle_manager"]:loadCustomVehProperties(tonumber(vehID), vehicle) end, 5000, 1)
								end
							end,
						mysql:getConnection(), "SELECT * FROM vehicles_shop WHERE id='"..vehicle:getData("vehicle_shop_id").."'")
					end
				end,
			mysql:getConnection(), "SELECT id FROM vehicles_custom WHERE id='"..vid.."'")
			outputChatBox("[!] #ffffffAraca kelebek kapı başarıyla eklendi. (10 saniye içerisinde aktif olur.)", source, 0, 255, 0, true)
			setElementData(source, "bakiye", bakiyeCek-price)
		else
			outputChatBox("[!] #ffffffAracın sahibi siz değilsiniz.", source, 255, 0, 0, true)
		end
	else
		outputChatBox("[!] #ffffffAraç bulunamadı.", source, 255, 0, 0, true)
	end
end
addEvent("market->kelebekKapi", true)
addEventHandler("market->kelebekKapi", root, vehDoorPrivate)

function plakaDegistirSERVER(oyuncu, plateText, aracID, fiyat)
	local bakiyeCek = tonumber(getElementData(oyuncu, "bakiye"))
	if bakiyeCek < math.ceil(fiyat) then
		outputChatBox("[!] #ffffffBakiye yetersiz.", oyuncu, 255, 0, 0, true)
	return
	end
	
	
	local theVehicle = exports.vrp_pool:getElement("vehicle", aracID)
	if theVehicle then
		if getElementData(oyuncu, "dbid") ~= getElementData(theVehicle, "owner") then
			outputChatBox("[!] #ffffffAraç size ait değil.", oyuncu, 255, 0, 0, true)
		return
		end
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					if res[1].no == 0 then
						if (exports.vrp_vehicle_plate:checkPlate(plateText)) and getVehiclePlateText(theVehicle) ~= plateText then
							local insertnplate = dbExec(mysql:getConnection(), "UPDATE vehicles SET plate='" .. (plateText) .. "' WHERE id = '" .. (aracID) .. "'")
							local x, y, z = getElementPosition(theVehicle)
							local int = getElementInterior(theVehicle)
							local dim = getElementDimension(theVehicle)
							exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "plate", plateText)
							setVehiclePlateText(theVehicle, plateText)
							local newVehicleElement = theVehicle
							setElementPosition(newVehicleElement, x, y, z)
							setElementInterior(newVehicleElement, int)
							setElementDimension(newVehicleElement, dim)
							setElementData(oyuncu, "bakiye", getElementData(oyuncu, "bakiye") - fiyat)
							outputChatBox("[!] #ffffffBaşarıyla [ID#"..aracID.."]'li aracın plakası ["..plateText.."] olarak değiştirildi.", oyuncu, 0, 255, 0, true)
						else
							outputChatBox("[!] #ffffffGeçersiz karakter içermekte.", oyuncu, 255, 0, 0, true)
						end
					else
						outputChatBox("[!] #ffffffSeçtiğiniz plaka kullanılıyor.", oyuncu, 255, 0, 0, true)
					end
				end
			end,
		mysql:getConnection(), "SELECT COUNT(*) as no FROM `vehicles` WHERE `plate`='".. (plateText).."'")
		
	end
end
addEvent("market->setVehiclePlate", true)
addEventHandler("market->setVehiclePlate", root, plakaDegistirSERVER)



-- @class Özel Animasyon Sistemi
addCommandHandler("customanimsave",
	function(player, cmd)
		if (getElementData(player, "loggedin") == 1) then
			local customtable = getElementData(player, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
			local success = dbExec(mysql:getConnection(), "UPDATE `accounts` SET custom_animations='".. toJSON(customtable) .."' WHERE id="..getElementData(player, "account:id").." LIMIT 1")
		end
	end
)

addEvent('market->addCustomAnimation', true)
addEventHandler('market->addCustomAnimation', root,
	function(player, anim_index, price)
		local bakiyeCek = tonumber(getElementData(player, "bakiye"))
		if bakiyeCek < math.ceil(price) then
			outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
		return
		end
		local customtable = getElementData(player, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
		
		if (customtable[tostring(anim_index)]) then -- Zaten animasyon oyuncuda var.
			outputChatBox("[!] #ffffffZaten bu animasyona sahipsin.", player, 255, 0, 0, true)
			outputChatBox("[!] #ffffffÖzel animasyon arayüzünü açmak için /animpanel.", player, 0, 255, 0, true)
			return false
		end
		customtable[tostring(anim_index)] = true
		setElementData(player, "bakiye", getElementData(player, "bakiye") - price)
		outputChatBox("[!] #ffffffYeni özel animasyon başarıyla satın alındı.", player, 0, 255, 0, true)
		outputChatBox("[!] #ffffffÖzel animasyon arayüzünü açmak için /animpanel.", player, 0, 255, 0, true)
		local success = dbExec(mysql:getConnection(), "UPDATE `accounts` SET custom_animations='".. toJSON(customtable) .."' WHERE id="..getElementData(player, "account:id").." LIMIT 1")
		setElementData(player, "custom_animations", customtable)
	end
)

-- @@ Neon Sistemi:
addEvent("market->addVehicleNeon", true)
addEventHandler("market->addVehicleNeon", root,
	function(player, vehicleID, neonIndex)
		local vehicleID = tonumber(vehicleID)
		local vehicle = exports.vrp_pool:getElement("vehicle", vehicleID)
		if vehicle and isElement(vehicle) then
			if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
				local vehicleNeon = getElementData(vehicle, "tuning.neon") or false
				if not vehicleNeon then
					local bakiyeCek = tonumber(getElementData(player, "bakiye"))
					if bakiyeCek < 15 then
						outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
						return
					end
					setElementData(player, "bakiye", getElementData(player, "bakiye") - 15)
				else
					if not exports.vrp_global:hasMoney(player, 1000) then
						outputChatBox("[!] #ffffffDaha önce zaten bu araca neon satın alınmış fakat değiştirmek için 1000$ gerekiyor..", player, 255, 0, 0, true)
						return
					end
					exports.vrp_global:takeMoney(player, 1000)
				end
				outputChatBox("[!] #ffffffAracınıza neon başarıyla eklendi, N tuşu ile açıp/kapatabilirsiniz.", player, 255, 0, 0, true)
				dbExec(mysql:getConnection(), "UPDATE vehicles SET neon='"..neonIndex.."' WHERE id='"..vehicleID.."'")
				setElementData(vehicle, "tuning.neon", neonIndex)
				-------------- LOG SISTEMI --------------
				if not vehicleNeon then
					local hours = getRealTime().hour
					local minutes = getRealTime().minute
					local seconds = getRealTime().second
					local day = getRealTime().monthday
					local month = getRealTime().month+1
					local year = getRealTime().year+1900
					local alinanUrun = "[Arac Neon - Arac ID: "..vehicleID.." - Neon Renk: "..tostring(neonIndex).."]"
					local ucret = 10
				end
				-----------------------------------------
			else
				outputChatBox("[!] #ffffffAracın sahibi siz değilsiniz.", player, 255, 0, 0, true)
			end
		else
			outputChatBox("[!] #ffffffAraç ID bulunamadı.", player, 255, 0, 0, true)
		end
	end
)

-- @@ Texture Sistemi:
addEvent("market->setVehicleTexture", true)
addEventHandler("market->setVehicleTexture", root,
	function(player, vehicle, link, texture_name, price)
		local vehicle = exports.vrp_pool:getElement("vehicle", vehicle)
		
		if vehicle and isElement(vehicle) then
			local vehicleID = getElementData(vehicle, "dbid")
			if getElementData(vehicle, "owner") == getElementData(source, "dbid") then
				local customTextures = getElementData(vehicle, "textures")--fromJSON(row.textures) or {}
				setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255)
				if #customTextures >= 1 then
					local bakiyeCek = tonumber(getElementData(player, "bakiye"))
					if bakiyeCek < 5 then
						outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
						return
					end
					setElementData(player, "bakiye", getElementData(player, "bakiye") - 5)
					triggerEvent("vehtex:removeTexture", player, vehicle, texture_name, link)
					outputChatBox("[!] #ffffffAracınızdaki kaplama başarıyla değiştirildi.", player, 0, 255, 0, true)
				else
					local bakiyeCek = tonumber(getElementData(player, "bakiye"))
					if bakiyeCek < price then
						outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
						return
					end
					setElementData(player, "bakiye", getElementData(player, "bakiye") - price)
					outputChatBox("[!] #ffffffAracınıza kaplama başarıyla eklendi.", player, 0, 255, 0, true)
				end
				
				triggerEvent("vehtex:addTexture", player, vehicle, texture_name, link)
				
				
			else
				outputChatBox("[!] #ffffffAracın sahibi siz değilsiniz.", player, 255, 0, 0, true)
			end
		else
			outputChatBox("[!] #ffffffAraç ID bulunamadı.", player, 255, 0, 0, true)
		end
	end
)

addEvent("market->changeFactionSettings", true)
addEventHandler("market->changeFactionSettings", root,
	function(player, factionName, factionType)
		local bakiyeCek = tonumber(getElementData(player, "bakiye"))
		if bakiyeCek < 10 then
			outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
			return
		end
		local factionID = getElementData(player, "faction")
		local factionElement = exports.vrp_pool:getElement("team", factionID)
		if factionElement then
			exports.vrp_global:sendMessageToAdmins("[MARKET] '" .. getPlayerName(player) .. "' isimli oyuncu '" .. getElementData(factionElement, "name") .. "' adlı birliğin adını "..factionName.." olarak değiştirdi.")
			setElementData(player, "bakiye", getElementData(player, "bakiye") - 10)
			outputChatBox("[!] #ffffffBirlik bilgileri başarıyla güncellendi.", player, 0, 255, 0, true)
			dbExec(mysql:getConnection(), "UPDATE factions SET name='"..factionName.."', type='"..factionType.."' WHERE id='"..factionID.."'")
			setElementData(factionElement, "name", factionName)
			setTeamName(factionElement, factionName)
			setElementData(factionElement, "type", factionType)
		end
	end
)

addEvent("market->receiveInactiveCharacters", true)
addEventHandler("market->receiveInactiveCharacters", root,
	function()
		dbQuery(
			function(qh, plr)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					triggerClientEvent(plr, "market->sendInactiveCharacters", plr, res)
				end
			end,
		{source}, mysql:getConnection(), "SELECT id, charactername, active, activeDescription FROM characters WHERE account='"..getElementData(source, "account:id").."' AND active='0'")
	end
)


local allowActions = {
	[0] = true,
	[1] = true,
	[2] = true,
}

addEvent("market->clearHistory", true)
addEventHandler("market->clearHistory", root,
	function(player, fiyat)
		local balance = tonumber(fiyat)
		if balance < 0 then return end
		local bakiyeCek = tonumber(getElementData(player, "bakiye"))
		if bakiyeCek < balance then
			outputChatBox("[!] #ffffffBakiyeniz yetersiz.", player, 255, 0, 0, true)
			return
		end
		
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
			
				if rows > 0 then
					setElementData(player, "bakiye", getElementData(player, "bakiye") - balance)
					outputChatBox("[!] #ffffffHistory başarıyla silindi, "..balance.. " adet.", player, 0, 255, 0, true)
					for index, value in ipairs(res) do
						dbExec(mysql:getConnection(), "DELETE FROM adminhistory WHERE id='"..value.id.."'")
					end
					else
					outputChatBox("[!]#ffffff Herhangi bir Histroy unuz yok.",player,255,0,0,true)
				end
			end,
		mysql:getConnection(), "SELECT id, action FROM adminhistory WHERE user='"..getElementData(player, "account:id").."' ORDER BY date DESC LIMIT "..balance)
	end
)