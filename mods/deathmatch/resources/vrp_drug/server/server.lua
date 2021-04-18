local mysql = exports.vrp_mysql
local pots = {}

Async:setPriority("low")

local SmallestID = function()
	local result = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM drugs AS e1 LEFT JOIN drugs AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result2 = dbPoll(result, -1)
	if result2 then
		local id = tonumber(result2[1]["nextID"]) or 1
		return id
	end
	return false
end

function stateTimer()
	for key, value in ipairs (pots) do
		local dbid = pots[key].object:getData("id") or nil
		if dbid then
			if pots[key].object:getData("state") < 100 then
				if dbExec(mysql:getConnection(), "UPDATE `drugs` SET `state`='"..pots[key].object:getData("state").."' WHERE `id`='"..dbid.."' ") then
					pots[key].object:setData("state", tonumber(pots[key].object:getData("state") + 1))
				end
			end
		end
	end
end
setTimer(stateTimer, 55500, 0)

function loadAllPots()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do

					local id = tonumber(row["id"])
					local owner = tonumber(row["owner"])
					local x = tonumber(row["x"])
					local y = tonumber(row["y"])
					local z = tonumber(row["z"])
					local interior = tonumber(row["interior"])
					local dimension = tonumber(row["dimension"])
					local state = tonumber(row["state"])
					object = Object(2203, x, y, z-0.8, 0, 0, 140)
					plant = Object(857, x, y, z-0.5, 0, 0, 140)
					pots[id] = {object = object, plant = plant}

					setElementInterior(pots[id].object, dimension)
					setElementDimension(pots[id].object, interior)
					pots[id].object:setData("id", id)
					pots[id].object:setData("owner", owner)
					pots[id].object:setData("state", tonumber(state))

					setElementInterior(pots[id].plant, dimension)
					setElementDimension(pots[id].plant, interior)
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `drugs`")
end
addEventHandler("onResourceStart", getResourceRootElement(), loadAllPots)

function create(thePlayer, cmd)
	if thePlayer:getData("loggedin") == 1 then
		if exports["vrp_items"]:hasItem(thePlayer, seedItemID) and exports["vrp_items"]:hasItem(thePlayer, potItemID) then
			local x, y, z = getElementPosition(thePlayer)
			local interior = getElementInterior(thePlayer)
			local dimension = getElementDimension(thePlayer)
			local dbid = thePlayer:getData("dbid")
			local id = SmallestID()
			local state = 0
			local query = dbExec(mysql:getConnection(),"INSERT INTO drugs SET id="..(id)..",owner='"..(dbid).."',x='"..(x).."',y='"..(y).."',z='"..(z).."',interior='"..(interior).."',dimension='"..(dimension).."',state='"..tonumber(state).."'")
			if query then
				exports.vrp_global:sendLocalMeAction(thePlayer, "yavaşça eğilerek sağ/sol elindeki saksıyı yere koyar.", false, true)
				exports.vrp_global:sendLocalMeAction(thePlayer, "sağ/sol elindeki tohumu saksıya eker.", false, true)
				exports["vrp_items"]:takeItem(thePlayer, seedItemID)
				exports["vrp_items"]:takeItem(thePlayer, potItemID)
				thePlayer:outputChat("[!]#EBEBEB Saksıyı başayırla kurdunuz!",  97, 205, 85, true)
				object = Object(2203, x, y, z-0.8, 0, 0, 140)
				plant = Object(857, x, y, z-0.5, 0, 0, 140)
				pots[id] = {object = object, plant = plant}
				setElementInterior(pots[id].object, dimension)
				setElementDimension(pots[id].object, interior)
				pots[id].object:setData("id", id)
				pots[id].object:setData("owner", dbid)
				pots[id].object:setData("state", tonumber(state))

				setElementInterior(pots[id].plant, dimension)
				setElementDimension(pots[id].plant, interior)
			else
				thePlayer:outputChat("[!]#EBEBEB mysQl hata kodu: 001",  97, 205, 85, true)
				print("Drug System - mysQl error code 001")
			end
		else
			thePlayer:outputChat("[!]#EBEBEB Saksı kurmak için bir adet tohum ve saksıya ihtiyacınız var!",  97, 205, 85, true)
		end
	end
end
addCommandHandler('saksıkur',create)

function remove(thePlayer, commandName, ID)
	if tonumber(ID) then
		local ID = tonumber(ID)
		local x, y, z = getElementPosition(thePlayer)
		if pots[ID] then
			local tx, ty, tz = getElementPosition(pots[ID].object)
			local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
			if distance <= 5 and getElementDimension(pots[ID].object) == getElementDimension(thePlayer) and getElementInterior(pots[ID].object) == getElementInterior(thePlayer) then
				local pdbid = thePlayer:getData("dbid")
				local owner = pots[ID].object:getData("owner")
				if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or thePlayer:getData("faction") == 1 or owner == pdbid then
					local query = dbExec(mysql:getConnection(),"DELETE FROM drugs WHERE id='"..(ID).."'")
					if query then

						for k,v in pairs(pots[ID].object:getAllData()) do
							pots[ID].object:removeData(k)
						end

						pots[ID].object:destroy()
						pots[ID].plant:destroy()
						pots[ID] = nil
						thePlayer:outputChat("[!]#EBEBEB "..ID.." ID'li saksıyı kaldırdınız!",  97, 205, 85, true)
					else
						thePlayer:outputChat("[!]#EBEBEB mysQl hata kodu: 002",  97, 205, 85, true)
						print("Drug System - mysQl error code 002")
					end
				else
					thePlayer:outputChat("[!]#EBEBEB Saksıyı kaldırmak için sahibi veya İEM üyesi olmanız gerekli.", 97, 205, 85, true)
				end
			else
				thePlayer:outputChat("[!]#EBEBEB Kaldırmak istediğiniz saksıdan uzaksınız!", 97, 205, 85, true)
			end
		else
			thePlayer:outputChat("[!]#EBEBEB Geçersiz ID!", 97, 205, 85, true)
		end
	else
		thePlayer:outputChat("SYNTAX: /saksıkaldır [ID]", 255, 194, 14, true)
	end
end
addCommandHandler("saksıkaldır", remove, false, false)

function pick(thePlayer, commandName, ID)
	if tonumber(ID) then
		local ID = tonumber(ID)
		local x, y, z = getElementPosition(thePlayer)
		if pots[ID] then
			local tx, ty, tz = getElementPosition(pots[ID].object)
			local distance = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)
			if distance <= 5 and getElementDimension(pots[ID].object) == getElementDimension(thePlayer) and getElementInterior(pots[ID].object) == getElementInterior(thePlayer) then
				local pdbid = thePlayer:getData("dbid")
				local owner = pots[ID].object:getData("owner")
				if owner == pdbid then
					if pots[ID].object:getData("state") >= 100 then
						local query = dbExec(mysql:getConnection(),"DELETE FROM drugs WHERE id='"..(ID).."'")
						if query then

							for k,v in pairs(pots[ID].object:getAllData()) do
								pots[ID].object:removeData(k)
							end

							pots[ID].object:destroy()
							pots[ID].plant:destroy()
							pots[ID] = nil
							exports.vrp_global:sendLocalMeAction(thePlayer, "yavaşça eğilerek yerdeki saksıdaki marijuanayı toplar ve saksıyı kaldırır.", false, true)
							thePlayer:outputChat("[!]#EBEBEB "..ID.." ID'li saksıyı topladınız!",  97, 205, 85, true)
							exports["vrp_global"]:giveItem(thePlayer, marijuanaID, 3)
						else
							thePlayer:outputChat("[!]#EBEBEB mysQl hata kodu: 003",  97, 205, 85, true)
							print("Drug System - mysQl error code 003")
						end
					else
						thePlayer:outputChat("[!]#EBEBEB Toplamak istediğiniz saksı henüz hazır değil.", 97, 205, 85, true)
						thePlayer:outputChat("[!]#EBEBEB Şu anki büyüme oranı %"..pots[ID].object:getData("state").."", 97, 205, 85, true)
					end
				else
					thePlayer:outputChat("[!]#EBEBEB Saksıyı toplamak için sahibi olmanız gerekli.", 97, 205, 85, true)
				end
			else
				thePlayer:outputChat("[!]#EBEBEB Toplamak istediğiniz saksıdan uzaksınız!", 97, 205, 85, true)
			end
		else
			thePlayer:outputChat("[!]#EBEBEB Geçersiz ID!", 97, 205, 85, true)
		end
	else
		thePlayer:outputChat("SYNTAX: /saksıtopla [ID]", 255, 194, 14, true)
	end
end
addCommandHandler("saksıtopla", pick)

function near(thePlayer, cmd)
	local posX, posY, posZ = getElementPosition(thePlayer)
	outputChatBox("Yakınınızdaki saksılar:", thePlayer, 255, 126, 0)
	local count = 0
	for key, value in ipairs (pots) do
		local dbid = getElementData(pots[key].object, "id")
		if dbid then
			count = count + 1
			local owner = getElementData(pots[key].object, "owner")
			local x, y, z = getElementPosition(pots[key].object)
			local distance = getDistanceBetweenPoints3D(posX, posY, posZ, x, y, z)
			local ownName = exports.vrp_cache:getCharacterNameFromID(owner)
			if distance <= 5 and getElementDimension(pots[key].object) == getElementDimension(thePlayer) and getElementInterior(pots[key].object) == getElementInterior(thePlayer) then
				outputChatBox("Saksı ID: "..dbid.." Sahibi: "..ownName.." Büyüme Oranı: %"..pots[key].object:getData("state").."", thePlayer, 255, 126, 0)
			end
		end
	end
	if (count==0) then
		outputChatBox("   Yok.", thePlayer, 255, 126, 0)
	end
end
addCommandHandler("yakındakisaksılar",near)
addCommandHandler("nearbypots",near)