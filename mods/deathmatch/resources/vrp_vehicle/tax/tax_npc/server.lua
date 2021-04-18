local mysql = exports.vrp_mysql
local vergiyeri = createColSphere (11.19140625, -5.19921875, 40.4296875, 3)
setElementInterior(vergiyeri, 24)
setElementDimension(vergiyeri, 32)
local pickup = createPickup(11.19140625, -5.19921875, 40.4296875, 3, 1239)
setElementData(pickup, "informationicon:information", "#999999/vergi#ffffff\nGovernment of Los Santos")
setElementInterior(pickup, 24)
setElementDimension(pickup, 32)

function sVergiGUI(thePlayer)
	if not isElementWithinColShape(thePlayer, vergiyeri) then return end
	if thePlayer then
		source = thePlayer
	end
	local playerID = getElementData(source, "dbid")
	local factID = getElementData(source, "faction")
	dbQuery(
		function(qh, thePlayer)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local playerVehs = {}
				for index, row in ipairs(res) do
					local vehicle = exports.vrp_pool:getElement("vehicle", row.id)
					local brand = getElementData(vehicle, "brand")
					local model = getElementData(vehicle, "maximemodel")
					local year = getElementData(vehicle, "year")
					local vergi = getElementData(vehicle, "toplamvergi") or 0
					table.insert(playerVehs, { row.id, "", tonumber(vergi) })
				end
				triggerClientEvent(source, 'vergi:VergiGUI', source, playerVehs)
			end
		end,
	{thePlayer}, mysql:getConnection(), "SELECT * FROM vehicles WHERE owner = '"..playerID.."' AND deleted=0")
end
addCommandHandler("vergi", sVergiGUI)

function VergiOde(aracID, miktar)
	if aracID and miktar then
		local arac = exports.vrp_pool:getElement("vehicle", aracID)
		if arac then
			local vergi = getElementData(arac, "toplamvergi")
			if miktar > vergi then
				outputChatBox("[!] #f0f0f0Ödemeye çalıştığınız miktar aracın vergi borcundan fazladır.", source, 255, 0, 0, true)
				return false
			end
			local playerMoney = getElementData(source, "money")
			if not exports.vrp_global:hasMoney(source, miktar) then
				outputChatBox("[!] #f0f0f0Yeterli paranız olmadığından vergi borcunu ödeyemezsiniz.", source, 255, 0, 0, true)
				return false			
			end
			local kalanvergi = vergi - miktar
			if getElementData(arac, "faizkilidi") then -- eğer faizkilidi varsa
				if kalanvergi <= 0 then -- eğer kalan vergi 0 isElement
					setElementData(arac, "faizkilidi", false) -- faiz kaldır
				end
			end	
			setElementData(arac, "toplamvergi", kalanvergi)
			exports.vrp_global:takeMoney(source, miktar)
			outputChatBox("[!] #f0f0f0Toplam $" .. exports.vrp_global:formatMoney(miktar) .. " ödediniz. Aracınızın kalan vergi borcu: $" .. exports.vrp_global:formatMoney(kalanvergi), source, 0, 255, 0, true)
			triggerEvent("saveVehicle", arac, arac)
		end
	end
end
addEvent("vergi:VergiOde", true)
addEventHandler("vergi:VergiOde", root, VergiOde)