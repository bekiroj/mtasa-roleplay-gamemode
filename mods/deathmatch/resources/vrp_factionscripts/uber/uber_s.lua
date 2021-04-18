local UberCache = {}
local UberWaiters = {}

addEventHandler("onResourceStart", resourceRoot,
	function()
		updateRootElements(UberCache, UberWaiters);
	end
)

addEvent("uber-system:requestNewUberVehicle", true)
addEventHandler("uber-system:requestNewUberVehicle", root,
	function(player, x, y, z)
		if UberWaiters[player] then
			--already've
			return
		end
		UberWaiters[player] = {getPlayerName(player), x, y, z}
		updateRootElements(UberCache, UberWaiters);

		outputChatBox("Sisteme kaydın başarıyla düştü, sana bir araç bağlandığında bildireceğiz!", player, 0, 255, 0, true)
		outputChatBox("Sisteme kaydını iptal etmek için /uberiptal komutunu kullanın.", player, 0, 255, 0, true)
		--notify all uber's
		for index, value in pairs(UberCache) do
			outputChatBox("[!]#ffffff Yeni bir uber talebi var, detaylar için /uberpanel",index, 255, 0, 0, true)
		end
	end
)

addCommandHandler("uberpanel",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if UberCache[player] or exports["vrp_integration"]:isPlayerHeadAdmin(player) then
				triggerClientEvent(player, "uber-system:showUberPanel", player, UberCache, UberWaiters)
			else
				outputChatBox("Uber şoförü olmadığın için bu arayüze erişemezsin!", player, 255, 0, 0, true)
			end
		end
	end
)

addCommandHandler("uberiptal",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			if UberWaiters[player] then
				UberWaiters[player] = nil
				outputChatBox("Sistem kaydın başarıyla silindi.", player, 0, 255, 0, true)
				updateRootElements(UberCache, UberWaiters);
				for index, value in pairs(UberCache) do--update uber personels for table
					triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
				end
			else
				outputChatBox("Herhangi bir uber kaydın bulunamadı.", player, 255, 0, 0, true)
			end
		end
 	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if UberWaiters[source] then
			UberWaiters[source] = nil
			updateRootElements(UberCache, UberWaiters);
			for index, value in pairs(UberCache) do--update uber personels for table
				triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
			end
		end
	end
)

addEventHandler("accounts:characters:change", root,
	function()
		if UberWaiters[client] then
			UberWaiters[client] = nil
			updateRootElements(UberCache, UberWaiters);
			for index, value in pairs(UberCache) do--update uber personels for table
				triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
			end
		end
	end
)

addEventHandler("onPlayerQuit", root,
	function()
		if UberCache[source] then
			UberCache[source] = nil
			updateRootElements(UberCache, UberWaiters);
			for index, value in pairs(UberCache) do--update uber personels for table
				triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
			end
		end
	end
)

addEventHandler("accounts:characters:change", root,
	function()
		if UberCache[client] then
			UberCache[client] = nil
			updateRootElements(UberCache, UberWaiters);
			for index, value in pairs(UberCache) do--update uber personels for table
				triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
			end
		end
	end
)

addEvent("uber-system:receiveWaiterPersonel", true)
addEventHandler("uber-system:receiveWaiterPersonel", root,
	function(personal, waiter, x, y, z)
		if UberWaiters[waiter] then
			outputChatBox(getPlayerName(personal):gsub("_", " ").. " adlı Uber şoförü isteğine yanıt verdi, bulunduğun konuma geliyor!", waiter, 0, 255, 0, true)
			outputChatBox(getPlayerName(waiter):gsub("_", " ").. " adlı kişinin Uber navigasyonunu aldın, navigasyon oluşturuluyor..", personal, 0, 255, 0, true)
			UberWaiters[waiter] = nil
			updateRootElements(UberCache, UberWaiters)
			for index, value in pairs(UberCache) do--update uber personels for table
				triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
			end

			triggerClientEvent(personal, "uber-system:createNavigation", personal, x, y, z)
		end
	end
)

addEvent("uber-system:addNewPerson", true)
addEventHandler("uber-system:addNewPerson", root,
	function(personal)
		UberCache[personal] = true
		for index, value in pairs(UberCache) do--update uber personels for table
			triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
		end
		updateRootElements(UberCache, UberWaiters)
	end
)

addEvent("uber-system:removePerson", true)
addEventHandler("uber-system:removePerson", root,
	function(personal)
		UberCache[personal] = nil
		for index, value in pairs(UberCache) do--update uber personels for table
			triggerClientEvent(index, "uber-system:updateTable", index, UberCache, UberWaiters)
		end
		updateRootElements(UberCache, UberWaiters)
	end
)


function updateRootElements(table1, table2)
	setElementData(root, "uberPersonels", table1)
	setElementData(root, "uberWaiters", table2)
end
