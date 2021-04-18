function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
local callprogress = getElementData(callingElement, "callprogress")	
	if callingPhoneNumber == 911 then
		if startingCall then
			outputChatBox("[!] #90a3b6PD Operator [Telefon]: PD Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6PD Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6PD Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Police Department" ) ) ) do
					for _, itemRow in ipairs(exports['vrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Police Department"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 611 then
		if startingCall then
			outputChatBox("[!] #90a3b6SASD Operator [Telefon]: SASD Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6SASD Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6SASD Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos County Sheriff's Department" ) ) ) do
					for _, itemRow in ipairs(exports['vrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos County Sheriff's Department"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 411 then
		if startingCall then
			outputChatBox("[!] #E67B9DAcil Servis Operator [Telefon]: Acil Servis Hattı, konumunuzu belirtin.", callingElement, 137, 0, 44, true)
			exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #E67B9DAcil Servis Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 137, 0, 44, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #E67B9Acil Servis Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 137, 0, 44, true)
				local location = getElementData(callingElement, "call.location")

				local affectedElements = { }

				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "Los Santos Medical Department" ) ) ) do
					for _, itemRow in ipairs(exports['vrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("Los Santos Medical Department"))) do
				
					outputChatBox("[TELSIZ] Arayan kişinin numarası #" .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 230, 123, 157)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 230, 123, 157)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 8294 then
		if startingCall then
			outputChatBox("Taksi Operator [Telefon]: Çiçek Taksi buyrun, nerede taksiye ihtiyacınız var?", callingElement)
			exports.vrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			local founddriver = false
			for key, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
				local job = getElementData(value, "job")
				if (job == 2) then
					local car = getPedOccupiedVehicle(value)
					if car and (getElementModel(car)==438 or getElementModel(car)==420) then
						outputChatBox("[RADIO] Taksi Operator diyor ki: Tüm birimlerin dikkatine, " .. outboundPhoneNumber .. " numarasından taksi isteniyor. Verilen adres: " .. message .."." , value, 0, 183, 239)
						founddriver = true
					end
				end
			end

			if founddriver == true then
				outputChatBox("Taksi Operator [Telefon]: Pekala, hemen bir taksi gönderiyoruz.", callingElement)
			else
				outputChatBox("Taksi Operator [Telefon]: Malesef şu an uygun taksicimiz yok. Daha sonra tekrar arayabilirsiniz.", callingElement)
			end
			triggerEvent("phone:cancelPhoneCall", callingElement)
		end
	end
end

function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factiontype = getElementData(theTeam, "type")
	if exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(callingElement)
	t = { "both",
		  "pd",
		  "police",
		  "lspd",
		  "sahp",
		  "sasd", -- PD ends here
		  "es",
		  "medic",
		  "ems",
		  "lsfd",
	}
	local found = false
	for row, names in ipairs(t) do
		if names == string.lower(getElementData(callingElement, "call.service")) then
			if row == 1 then
				local found = true
				return 1 -- Both!
			elseif row >= 2 and row <= 6 then
				local found = true
				return 2 -- Just the PD please
			elseif row >= 7 and row <= 10 then
				local found = true
				return 3 -- ES
			end
		end
	end
	if not found then
		return 4 -- Not found!
	end
end
