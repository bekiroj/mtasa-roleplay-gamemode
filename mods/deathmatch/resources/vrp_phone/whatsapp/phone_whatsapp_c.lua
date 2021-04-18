--Number, content, secdiff, isIncoming, viewed
local wpMessages = {}
--Number, thread
local wpThreads = {}
--threadID, thread
local wpSortedwpThreads = {}
local wpwpThreads = {}
local smsComposerCache = {}
local totalUnreadWPs = {}
local wpViewingMode = {}
local wpTargetNumber = {}
local wpComposerGUIs = {}

function processwpMessagesIntowpThreads(fromPhone, exclude)
	wpThreads[fromPhone] = {}
	local totalUnread = 0
	if wpMessages[fromPhone] then
		for i, message in ipairs(wpMessages[fromPhone]) do
			if not wpThreads[fromPhone][message[1]] then
				wpThreads[fromPhone][message[1]] = {}
			end

			if exclude and message[1] == exclude then
				message = nil
			else
				table.insert(wpThreads[fromPhone][message[1]], message)
				if message[4] and not message[5] then
					totalUnread = totalUnread + 1
				end
			end
		end
	end
	totalUnreadWPs[fromPhone] = totalUnread
end

function sortwpThreadsBySecdiff(fromPhone)
	--rearrange wpThreads into sortable wpThreads
	wpSortedwpThreads[fromPhone] = {}
	local index = 1
	for number, thread in pairs(wpThreads[fromPhone]) do
		if thread and type(thread) == "table" then
			wpSortedwpThreads[fromPhone][index] = thread
			index = index + 1
		end
	end
	--start sorting
	if #wpSortedwpThreads > 0 then
		table.sort(wpSortedwpThreads[fromPhone], function(a, b)
			if a[1][3] and b[1][3] then
				return a[1][3] > b[1][3]
			end
		end)
	end
end

function receiveSMSFromServer(fromPhone, SMSs, forceUpdate)
	fromPhone = tonumber(fromPhone)
	forceUpdate = tonumber(forceUpdate) or forceUpdate

	if fromPhone and SMSs and type(SMSs) == "table" then
		wpMessages[fromPhone] = {}
		for i, SMS in ipairs(SMSs) do
			local from = tonumber(SMS['from'])
			local to = tonumber(SMS['to'])
			local isIncoming = false
			if to == fromPhone then
				to = from
				isIncoming = true
			end
			local content = SMS['content']
			local datesec = tonumber(SMS['datesec'])
			local viewed = tonumber(SMS['viewed']) == 1
			local private = 0
			if isIncoming and tonumber(SMS['private']) == 1 then
				private = 1
			end
			table.insert(wpMessages[fromPhone], {to, content, datesec, isIncoming, viewed, private})

		end
		processwpMessagesIntowpThreads(fromPhone)
		sortwpThreadsBySecdiff(fromPhone)
	end
	if forceUpdate then
		if wpViewingMode[fromPhone] == "One" then --if update on sending new message then refresh the curent thread if still on screen
			drawOneWhatsappContent(wpTargetNumber[fromPhone])
			if forceUpdate == wpTargetNumber[fromPhone] then
				if forceUpdate == fromPhone then
					playSound("sounds/ringtones/viberate.mp3")
				else
					smsSending = false
					if wWhatsappComposer and isElement(wWhatsappComposer) then
						smsComposerCache[phone][forceUpdate] = nil
						guiSetText(wpComposerGUIs.memo, "")
						guiSetEnabled(wWhatsappComposer, true)
						guiSetAlpha(wWhatsappComposer, 1)
						guiSetEnabled(wpComposerGUIs.send, false)
					end
				end
			end
		elseif wpViewingMode[fromPhone] == "All" then
			drawWhatsappMenu()
			if forceUpdate == fromPhone then
				playSound("sounds/ringtones/viberate.mp3")
			end
		end
	end
end
addEvent("whatsapp:receiveSMSFromServer", true)
addEventHandler("whatsapp:receiveSMSFromServer", root, receiveSMSFromServer)

function receiveOneSMSThreadFromServer(fetchForPhone, wpMessagesentTo, SMSs, outGoing)
	fetchForPhone = tonumber(fetchForPhone)
	wpMessagesentTo = tonumber(wpMessagesentTo)
	
	local unreads = 0
	if fetchForPhone and wpMessagesentTo and SMSs and type(SMSs) == "table" then
		local msgs = {}
		for i, SMS in ipairs(SMSs) do
			local from = tonumber(SMS['from'])
			local to = tonumber(SMS['to'])
			local isIncoming = false
			if to == fetchForPhone then
				to = from
				isIncoming = true
			end
			local content = SMS['content']
			local datesec = tonumber(SMS['datesec'])
			local viewed = tonumber(SMS['viewed']) == 1
			table.insert(msgs, {to, content, datesec, isIncoming, viewed})
			if isIncoming and not viewed then
				unreads = unreads + 1
			end
		end
		if not wpThreads[fetchForPhone] then wpThreads[fetchForPhone] = {} end
		wpThreads[fetchForPhone][wpMessagesentTo] = {}
		for i, message in ipairs(msgs) do
			table.insert(wpThreads[fetchForPhone][wpMessagesentTo], message)
		end
		sortwpThreadsBySecdiff(fetchForPhone)
	end

	if wpViewingMode[fetchForPhone] == "One" then --if update on sending new message then refresh the curent thread if still on screen
		--outputChatBox("One")
		drawOneWhatsappContent(wpTargetNumber[fetchForPhone])
		if not outGoing then
			playSound("sounds/ringtones/viberate.mp3")
		else
			smsSending = false
			if wWhatsappComposer and isElement(wWhatsappComposer) then
				smsComposerCache[fetchForPhone][wpTargetNumber[fetchForPhone]] = nil
				guiSetText(wpComposerGUIs.memo, "")
				guiSetEnabled(wWhatsappComposer, true)
				guiSetAlpha(wWhatsappComposer, 1)
			end
		end
	elseif wpViewingMode[fetchForPhone] == "All" then
		--outputChatBox("All")
		drawWhatsappMenu()
		if not outGoing then
			playSound("sounds/ringtones/viberate.mp3")
		end
	else
		--outputChatBox("Update")
		if unreads > 0 then
			addToUnreadWP(fetchForPhone, unreads)
		end
	end

end
addEvent("whatsapp:receiveOneSMSThreadFromServer", true)
addEventHandler("whatsapp:receiveOneSMSThreadFromServer", root, receiveOneSMSThreadFromServer)

local smsGUI = {}
function drawWhatsappMenu(xoffset, yoffset)
	if not isPhoneGUICreated() then
		return false
	end

	if not xoffset then xoffset = 0 end
	yoffset = 30
	local originXoffset = xoffset
	local originYoffset = yoffset
	removeWhatsapp()
	whatsappPage = true
	inMessage = false
	wWhatsapp = guiCreateScrollPane(30+xoffset, 100+yoffset, 221, 370, false, wPhoneMenu)
	wpViewingMode[phone] = "All"
	wpTargetNumber[phone] = nil

	if wpSortedwpThreads[phone] and wpwpThreads[phone] then
		sortwpThreadsBySecdiff(phone)
		if #wpSortedwpThreads[phone] > 0 then
			local isEmpty = nil
			for i = 1, #wpSortedwpThreads[phone] do
				local thread = wpSortedwpThreads[phone][i][1] --Assign first message of each thread to thread's headers.
				if thread then
					

					smsGUI[thread[1]] = {}
				    smsGUI[thread[1]].numberField = guiCreateLabel(10+xoffset, 10+yoffset, 153, 19, getContactNameFromContactNumber(thread[1], phone) or thread[1], false, wWhatsapp)
				    guiSetFont(smsGUI[thread[1]].numberField, "default-bold-small")
				    guiLabelSetVerticalAlign(smsGUI[thread[1]].numberField, "center")
				    guiLabelSetColor(smsGUI[thread[1]].numberField, 0,0,0)
				
				    smsGUI[thread[1]].latestContent = guiCreateLabel(10+xoffset, 29+yoffset, 150, 16, thread[2], false, wWhatsapp)
				    guiSetFont(smsGUI[thread[1]].latestContent, "default-small")
				    guiLabelSetColor(smsGUI[thread[1]].latestContent, 0,0,0)
				    if thread[4] and not thread[5] then --if incoming and not read yet
				    	guiLabelSetColor(smsGUI[thread[1]].latestContent, 0, 255, 0)
				    end

				 
				 --   smsGUI[thread[1]].call = guiCreateButton(163+xoffset, 14+yoffset, 48, 16, "", false, wWhatsapp)
				 --   guiCreateStaticImage(163+xoffset, 15+yoffset, 48, 14, "images/call.png", false, wWhatsapp)
			

				    yoffset = yoffset + 31 - 14
				   
				 --   smsGUI[thread[1]].sms = guiCreateButton(163+xoffset, 14+yoffset, 48, 16, "", false, wWhatsapp)
				 --    guiCreateStaticImage(179+xoffset, 16+yoffset, 17, 12, "images/sms.png", false, wWhatsapp)
			

				    yoffset = yoffset - (31 - 14)
					
				    yoffset = yoffset + 60 
				else
					guiCreateLabel(0.5, 0.5, 1, 0.5, "Hiç mesaj almamışsın.", true, wWhatsapp)
					isEmpty = true
					break
				end
			end
			if not isEmpty then
				addEventHandler("onClientGUIClick", wWhatsapp, function()
					for i = 1, #wpSortedwpThreads[phone] do
						local thread = wpSortedwpThreads[phone][i][1]
						if source == smsGUI[thread[1]].numberField or source == smsGUI[thread[1]].latestContent then -- Open SMS thread
							--outputChatBox(number)
							drawOneWhatsappContent(thread[1] ,  originXoffset, 0)

							break
						
						end
					end
				end)
			end
		else 
			guiCreateLabel(0.5, 0.5, 1, 0.5, "Hiç mesaj almamışsın.", true, wWhatsapp)
		end
	else
		wpwpThreads[phone] = triggerServerEvent("whatsapp:fetchSMS", localPlayer, phone, "All", not contactList[phone])
		guiCreateLabel(0.5, 0.5, 1, 0.5, "Mesajlarınız yükleniyor..", true, wWhatsapp)
	end
end

function drawOneBubble(content, date, incoming, viewed, drawOnto, xoffset, yoffset)
	date2 = date
	--if not content or string.len(content) < 1 or not date or string.len(date) < 1 or not drawOnto or not isElement(drawOnto) then
	--	return false
--	end
	if not xoffset then xoffset = 0 end
	if not yoffset then yoffset = 0 end
	local margin = 5
	local boxW, boxH = 200, 50
	local headTailSize = 8
	if incoming then-- o gönderdiyse
		yoffset = yoffset+headTailSize
		bubble_direction = "sms_bubble_body_to"
		boxW = boxW - 20

	else
		bubble_direction = "sms_bubble_body_from"
		boxW = boxW - 20
		xoffset = xoffset+20
	end
	

	local body = guiCreateStaticImage(xoffset, yoffset, boxW, boxH, "images/"..bubble_direction..".png", false, drawOnto)
	--xoffset = xoffset-20
	if not incoming then
		xoffset = xoffset - 20
	end
	local text = guiCreateLabel(xoffset+margin, xoffset+margin, boxW-margin*2, boxH-margin*2, removeNewLine(content), false, body)
	guiLabelSetColor(text,0,0,0)
	if incoming and not viewed then
		return false, true
	end
	guiSetFont(text, "default")
	guiLabelSetHorizontalAlign(text, "left", true)
	guiLabelSetVerticalAlign(text, "top", true)
	local contentW, contentH = guiLabelGetTextExtent ( text ), guiLabelGetFontHeight ( text )
	if contentW < 100 then
		contentW = 100
	end
	local newContentH = contentH
	if contentW > boxW-margin*2 then
		--outputChatBox(newContentH)
		newContentH = math.ceil(contentW/(boxW-margin*2))*contentH
		contentW = boxW-margin*2
	end
	guiSetSize ( text, contentW, newContentH, false )
	if date2 then
		local date = guiCreateLabel(xoffset+margin, xoffset+margin*2+newContentH, boxW-margin*2, boxH-margin*2, exports.vrp_datetime:formatTimeInterval( date ), false, body)
		guiSetFont(date, "default-small")
		guiLabelSetColor(date, 100,100,100)
		guiSetSize ( body, contentW+margin*2, newContentH+margin*2+contentH, false )
	end
	---Draw the head or tail of the bubble
	--[[
	if incoming then-- o gönderdiyse
		guiCreateStaticImage(xoffset+headTailSize, yoffset-headTailSize, headTailSize, headTailSize, "images/sms_bubble_head.png", false, drawOnto)
	else--ben gönderdiysem
		local shiftX = 0
		if contentW < boxW-margin*2 then
			local bodyX, bodyY = guiGetPosition(body, false)
			shiftX = (boxW-margin*2)-contentW
			bodyX = bodyX + shiftX
			guiSetPosition(body, bodyX, bodyY, false)
		end
		guiCreateStaticImage(xoffset+contentW+margin*2-headTailSize*2+shiftX, yoffset+newContentH+margin*2+contentH, headTailSize, headTailSize, "images/sms_bubble_tail.png", false, drawOnto)
	end
]]--
	return yoffset+newContentH+margin*2+contentH, somethingUnread
end

function drawOneWhatsappContent(contact, xoffset, yoffset)
	if not isPhoneGUICreated() then
		return false
	end

	removeWhatsapp()


	wpTargetNumber[phone] = tonumber(contact)
	wpViewingMode[phone] = "One"

	if not xoffset then xoffset = 0 end
	if not yoffset then yoffset = 0 end

	local originXoffset = xoffset
	local originYoffset = yoffset
	
	local w,h = 225, 320
	wWhatsapp = guiCreateScrollPane(24+xoffset, 116+yoffset, w, h , false, wPhoneMenu)

	if not wpThreads[phone] then
		triggerServerEvent("whatsapp:fetchOneSMSThread", localPlayer, phone, contact, true, not contactList[phone]) 
		guiCreateLabel(0.5, 0.5, 1, 0.5, "Yükleniyor..", true, wWhatsapp)
		return false
	end

	if not wpThreads[phone][contact] then
		wpThreads[phone][contact] = {}
	end

	
	local backBtnSize = 12
	local spacing = 10
	backTowpThreads1 = guiCreateStaticImage(20, 93, backBtnSize, backBtnSize, "images/arrow_left_white.png", false, wPhoneMenu)
    backTowpThreads = guiCreateButton(20, 93, backBtnSize, backBtnSize, "", false, wPhoneMenu)
    guiSetAlpha(backTowpThreads, 0)

	contactName = guiCreateLabel(40, 90, 170, 19, getContactNameFromContactNumber(contact, phone) or contact, false, wPhoneMenu)
    addEventHandler("onClientGUIClick", backTowpThreads, function () 
    	if source == backTowpThreads then
    		if isElement(contactName) then
				destroyElement(contactName)
			end
			if isElement(backTowpThreads) then
				destroyElement(backTowpThreads)
			end
			if isElement(backTowpThreads1) then
				destroyElement(backTowpThreads1)
			end
    		drawWhatsappMenu(originXoffset, originYoffset)
    	end
    end)
    guiSetFont(contactName, "default-bold-small")
    guiLabelSetVerticalAlign(contactName, "top")
    yoffset = yoffset + 30

    for i, message in ipairs(wpThreads[phone][contact]) do
		local new_yoffset, somethingUnread = drawOneBubble(message[2], message[3], message[4], message[5], wWhatsapp,xoffset, yoffset)

		if somethingUnread then
			triggerServerEvent("whatsapp:updateSMSViewedState", localPlayer, phone, contact)
		 	return false 
		end
		
		
			yoffset = new_yoffset + spacing
		
		if not message[5] then
			somethingUnread = true
		end
	end
	drawWhatsappComposer(originXoffset, originYoffset+h+spacing )
	
	guiScrollPaneSetVerticalScrollPosition(wWhatsapp,100)
	guiScrollPaneSetHorizontalScrollPosition(wWhatsapp,100)
end


function drawWhatsappComposer(xoffset, yoffset)
	if isPhoneGUICreated() then
		if not xoffset then xoffset = 0 end
		if not yoffset then yoffset = 0 end
		if wWhatsappComposer and isElement(wWhatsappComposer) then
			closeWPComp()
		end

		local function onClientGUIFocus_editbox()
			if source == wpComposerGUIs.memo then
				guiSetInputEnabled(true)
			end
		end
		 
		local function onClientGUIBlur_editbox()
			if source == wpComposerGUIs.memo then
				guiSetInputEnabled(false)
			end
		end

		if not smsComposerCache[phone] then
			smsComposerCache[phone] = {}
		end

		limit = 120
		wWhatsappComposer = guiCreateScrollPane(30+xoffset, 120+yoffset, 190, 65, false, wPhoneMenu)
		guiSetAlpha(wWhatsappComposer, 0)
		wpComposerGUIs.memo = guiCreateEdit(0, 0.4, 0.9, 0.4, smsComposerCache[phone][wpTargetNumber[phone]] or "", true, wWhatsappComposer)
		setElementData(wpComposerGUIs.memo, "inMessageGUI", true)
		guiSetProperty(wpComposerGUIs.memo, "InheritsAlpha", "FF000000")
		--guiSetFont(wpComposerGUIs.memo, "default-small")

		addEventHandler("onClientGUIFocus", wpComposerGUIs.memo, onClientGUIFocus_editbox)
		addEventHandler("onClientGUIBlur", wpComposerGUIs.memo, onClientGUIBlur_editbox)

		addEventHandler("onClientGUIAccepted", wpComposerGUIs.memo, function(source)
			if source == wpComposerGUIs.memo and wpTargetNumber[phone] then
				guiSetEnabled(wWhatsappComposer, false)
				guiSetAlpha(wWhatsappComposer, 0.5)
				sendSMS(phone, wpTargetNumber[phone], guiGetText(wpComposerGUIs.memo):gsub("\n", " "))
			end
		end)	
		guiSetEnabled(wWhatsappComposer, not smsSending)
		
	end
end

function sendSMS(fromPhone, toPhone, content)
	smsSending = triggerServerEvent("whatsapp:sendSMS", localPlayer, fromPhone, toPhone, content, getPhoneSettings(fromPhone, "isSecret") or 0)
end

function closeWPComp()
	if wWhatsappComposer and isElement(wWhatsappComposer) then
		destroyElement(wWhatsappComposer)
		wWhatsappComposer = nil
	end
end


function addToUnreadWP(fromPhone, newValue)
	totalUnreadWPs[fromPhone] = (totalUnreadWPs[fromPhone]) or 0 + newValue
	if not wpViewingMode[fromPhone] then
		triggerServerEvent("whatsapp:startRingingSMS", localPlayer, fromPhone, getPhoneSettings(fromPhone, "sms_tone"), getPhoneSettings(fromPhone, "tone_volume"))
		if not (getElementData(localPlayer, "cellphoneGUIStateSynced") == 1) then

		end
	end
end

function removeWhatsapp()
	if wWhatsapp and isElement(wWhatsapp) then
		destroyElement(wWhatsapp)
		if isElement(contactName) then
			destroyElement(contactName)
		end
		if isElement(backTowpThreads) then
			destroyElement(backTowpThreads)
		end
		if isElement(backTowpThreads1) then
			destroyElement(backTowpThreads1)
		end

		wWhatsapp = nil
		whatsappPage = false

		closeWPComp()
		inMessage = false
		wpViewingMode[phone] = nil
		wpTargetNumber[phone] = nil
	end
end

function resetSMSwpThreads(fromPhone)
	fromPhone = tonumber(fromPhone)
	if wpThreads[fromPhone] then
		wpThreads[fromPhone] = nil
	end
	if wpMessages[fromPhone] then
		wpMessages[fromPhone] = nil
	end
	wpwpThreads[fromPhone] = nil
end



