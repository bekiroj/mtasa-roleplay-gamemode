--MAXIME

local actualSeconds = 0
local actualCountedTime = "00:00"
local calledHotline = nil
local startPressingDialSoundIndex = 0
p_Sound = {}
function drawPhoneDial()
	if isPhoneGUICreated() then
		curEditPhoneNumber = ""
		ePhoneText = guiCreateLabel(30,100,204,25, "Arama/Rehber", false, wPhoneMenu)

		ePhoneNumber = guiCreateEdit(30,125,204,25,"",false,wPhoneMenu)
		guiEditSetMaxLength(ePhoneNumber, 24)
		--guiSetFont ( ePhoneNumber, font1 )
		addEventHandler("onClientGUIChanged", ePhoneNumber, function(element) 
		   	if guiGetText(element) == "" or tonumber(guiGetText(element)) then
		   		curEditPhoneNumber = guiGetText(element)
		   	else
		   		guiSetText(element, curEditPhoneNumber)
		   	end
		end)

		local function onClientGUIFocus_editbox()
			if source == ePhoneNumber then
				guiSetInputEnabled(true)
			end
		end
		 
		local function onClientGUIBlur_editbox()
			if source == ePhoneNumber then
				guiSetInputEnabled(false)
			end
		end

		addEventHandler("onClientGUIFocus", ePhoneNumber, onClientGUIFocus_editbox, true)
		addEventHandler("onClientGUIBlur", ePhoneNumber, onClientGUIBlur_editbox, true)

		bCall = guiCreateButton(30,155,204/4,30,"Ara",false,wPhoneMenu)
		--guiSetFont ( bCall, font1 )
		bSMSDial = guiCreateButton(30+(204/4),155,204/4,30,"SMS",false,wPhoneMenu)
		--guiSetFont ( bSMSDial, font1 )
		bKonumAt = guiCreateButton(30+(204/2),155,204/4,30,"Konum",false,wPhoneMenu)
		--guiSetFont ( bKonumAt, font1 )
		bWhatsapp = guiCreateButton(30+204/2+(204/4),155,204/4,30,"WhatsApp",false,wPhoneMenu)
		--guiSetFont ( bWhatsapp, font1 )

		addEventHandler( "onClientGUIAccepted", ePhoneNumber,
		    function( theElement ) 
		        startDialing(phone, guiGetText(theElement))
		    end
		)
	end
end

function togglePhoneDial(state)
	if isPhoneGUICreated() then
		if ePhoneNumber and isElement(ePhoneNumber) then
			if state then
				guiSetVisible(ePhoneNumber, true)
				guiSetVisible(bCall, true)
				guiSetVisible(bSMSDial, true)
				guiSetVisible(ePhoneText,true)
				guiSetVisible(bKonumAt, true)
				guiSetVisible(bWhatsapp, true)
			else
				guiSetVisible(ePhoneNumber, false)
				guiSetVisible(bCall, false)
				guiSetVisible(ePhoneText,false)
				guiSetVisible(bSMSDial, false)
				guiSetVisible(bKonumAt, false)
				guiSetVisible(bWhatsapp, false)
			end
		end
	end
end

local dialingTimers = {}
local dialingSounds = {}
function startDialing(from, to, popOutOnPhoneCall)
	if from and to and string.len(to) > 0 then
		resetHistory(from)
		local yoffset = 140
		if not yoffset then yoffset = 0 end
		local callingTo = nil
		if contactList[phone] then
			for i, contact in pairs(contactList[phone]) do
				if tostring(contact.entryName) == tostring(to) or tostring(contact.entryNumber) == tostring(to) then
					callingTo = {contact.entryNumber, contact.entryName}
					break
				end
			end
		end
		if not callingTo then
			if not tonumber(to) and to ~= "Private" then
				return false
			end
			callingTo = {to, nil}
		end
		if not popOutOnPhoneCall then
			killDialingSounds()
			killDialingTimers()
			--local sound = playSound("sounds/touch_tone.mp3")
			--setSoundVolume(sound, 0.3)
			--table.insert(dialingSounds, sound)
			startPressingDialSoundIndex = 0
			local startPressing = setTimer(startPressingDialSound, 200, string.len(to), to)
			table.insert(dialingTimers, startPressing)

			local timer = setTimer(triggerServerEvent, 3000, 1, "phone:startDialing", localPlayer, to, from)
			table.insert(dialingTimers, timer)
		end
		toggleOffEverything()

		local posY = 100+yoffset
		local margin = 30
		local lineH, lineW = margin, 200
		local lineW2 = 150

		if not font2 then
			font2 = guiCreateFont ( ":vrp_hud/fonts/Roboto.ttf", 17 )
		end

		lCallingTo = guiCreateLabel(margin,posY-10,lineW,40, callingTo[1], false, wPhoneMenu)
		--guiSetFont(lCallingTo, font2)
		guiLabelSetHorizontalAlign(lCallingTo, "center")
		posY = posY + lineH

		lCallingText = guiCreateLabel(margin,posY-10,lineW,100, "Aranıyor..." , false, wPhoneMenu)
		guiLabelSetHorizontalAlign(lCallingText, "center")
		posY = posY + lineH*4+10
		
		local bW,bH = 200, 30

		bSpeaker = guiCreateButton(margin+2,posY,bW,bH, "Hoporlör", false, wPhoneMenu)
		posY = posY + bH + 2

		bEndCall = guiCreateButton(margin+2,posY,bW,bH, "Kapat", false, wPhoneMenu)
		
		posY = posY + bH + 2
		
		addEventHandler("onClientGUIClick", bEndCall, function()
			if source == bEndCall then
				endPhoneCall()
			end
		end)

		
		if not popOutOnPhoneCall then
			--killDialingTimers() --already killed above, shouldn't kill again
			local subscriberOutOfService = setTimer(finishPhoneCall, 20000, 1, "out_of_service")
			table.insert(dialingTimers, subscriberOutOfService)
		end

		actualCountedTime = 0
		actualCountedTime = "00:00"

		if popOutOnPhoneCall then
			guiSetText(lCallingTo, callingTo[2] or callingTo[1])
			guiSetText(lCallingText, "Bağlandı!")
			startCounting()
			calledHotline = true
			guiSetEnabled(bEndCall, true)
			guiSetEnabled(bSpeaker, true)
			if dialingTone and isElement(dialingTone) then
				destroyElement(dialingTone)
				dialingTone = nil
			end
			playSound("sounds/ringtones/viberate.mp3")
			guiSetEnabled(wPhoneMenu, true)
		else
			guiSetEnabled(wPhoneMenu, false)
		end
	end
end

function endPhoneCall()
	triggerServerEvent("phone:cancelPhoneCall", localPlayer, getPhoneCallCost())
	if isPhoneGUICreated() then
		guiSetEnabled(wPhoneMenu, true)
	end
end

function finishPhoneCall(reason)
	killDialingSounds()
	killDialingTimers()
	playSound("sounds/hangup.mp3")
	local reasonText = "End"
	if reason == "out_of_service" then
		reasonText = "Aradığınız numaraya şu anda\n ulaşılamamaktadır."
	elseif reason == "cant_afford" then
		reasonText = "You can not afford this phone call.\nPlease charge money"
	elseif reason == "declined" then
		reasonText = "Aradığınız kişi şu anda meşgul."
	elseif reason == "not_existed" then
		reasonText = "Eksik veya hatalı\ntuşlama yaptınız."
	elseif isQuitType(reason) then
		reasonText = "Sinyal kayıp, çağrı düştü! \n(("..reason.."))"
	else
		reasonText = "Kapandı"
	end
	local callingCost = getPhoneCallCost()
	if lCallingText and isElement(lCallingText) then
		guiSetText(lCallingText, reasonText..".\n\nSüre: "..actualCountedTime.."\nÜcret: $"..exports.vrp_global:formatMoney(callingCost))
		if isPhoneGUICreated() then
			guiSetEnabled(wPhoneMenu, true)
		end
	end
	
	if isPhoneGUICreated() and bEndCall and isElement(bEndCall) then
		guiSetEnabled(bEndCall, false)
		guiSetEnabled(bSpeaker, false)
		guiSetEnabled(bHome, true)
	end

	if not calledHotline and callingCost > 0 then
		outputDebugString("[Phone] takeCallCost / "..getPlayerName(localPlayer).." / "..actualCountedTime.." / $"..callingCost)
		triggerServerEvent("phone:takeCallCost", localPlayer, callingCost, phone, actualCountedTime)
		actualSeconds = 0
	end
end

function getPhoneCallCost()
	if calledHotline then
		return 0
	else
		local cost = math.ceil(actualSeconds*0.305)
		return cost < 5000 and cost or 5000 --Max 5k.
	end
end

function closeDialing()
	if isPhoneGUICreated() and lCallingTo and isElement(lCallingTo) then
		destroyElement(lCallingTo)
		lCallingTo = nil
		destroyElement(lCallingText)
		lCallingText = nil
		destroyElement(bSpeaker)
		bSpeaker = nil
		destroyElement(bEndCall)
		bEndCall = nil
		killDialingSounds()
		killDialingTimers()
	end
end

function updateDialingScreen(action, data, calledHotline1)
	outputDebugString("[Phone] updateDialingScreen / Client/ "..(action and action))
	if isPhoneGUICreated() and lCallingTo and isElement(lCallingTo) then
		if action then
			if action == "caller, started dialing but canceled" then
				finishPhoneCall()
			elseif action == "caller, started dialing and target is ringing. but canceled" then
				finishPhoneCall()
			elseif action == "called, started ringing .but they canceled" then
				finishPhoneCall("declined")
			elseif action == "start_dialing_tone" then
				if data then
					calledHotline = calledHotline1
					killDialingTimers()
					killDialingSounds()
					guiSetText(lCallingTo, data.entryName or data.entryNumber)
					local dialingTone = playSound("sounds/dialing_tone.mp3", true)
					local timer1 = setTimer(destroyElement, 20000, 1, dialingTone)
					table.insert(dialingSounds, dialingTone)
					table.insert(dialingTimers, timer1)
					guiSetEnabled(bEndCall, true)
					guiSetEnabled(bSpeaker, true)
					guiSetEnabled(bHome, false)
				end
			elseif action == "called, started ringing but timed out" then
				finishPhoneCall()
			elseif action == "start_invalid_or_busy_tone" then
				finishPhoneCall(data)
				if data == "not_existed" then 
					local sound1 = playSound("sounds/invalid_tone.mp3")
					setSoundVolume(sound1, 0.2)
					table.insert(dialingSounds, sound1)
				elseif data == "out_of_service" then
					local sound1 = playSound("sounds/busy_tone.mp3", true)
					setSoundVolume(sound1, 0.7)
					table.insert(dialingSounds, sound1)
					local timer1 = setTimer(destroyElement, 5000, 1, sound1)
					table.insert(dialingTimers, timer1)
				end
			elseif action == "connected" then
				if data then
					killDialingTimers()
					killDialingSounds()
					local sound1 = playSound("sounds/ringtones/viberate.mp3")
					table.insert(dialingSounds, sound1)

					guiSetText(lCallingTo, data.entryName or data.entryNumber)
					guiSetText(lCallingText, "Bağlandı!")
					startCounting()
					guiSetEnabled(bEndCall, true)
					guiSetEnabled(bSpeaker, true)
				end
			elseif isQuitType(action) then
				finishPhoneCall(action)
			elseif action == "called, answered but they canceled" then
				finishPhoneCall()
			elseif action == "caller, connected, canceled" then
				finishPhoneCall()
			else
				finishPhoneCall()
			end
		end
		guiSetEnabled(wPhoneMenu, true)
	end
end
addEvent("phone:updateDialingScreen", true)
addEventHandler("phone:updateDialingScreen", root, updateDialingScreen)

function startCounting()
	actualSeconds = 0
	local seconds = 0
	local minutes = 0
	killDialingTimers()
	dialingTimers.countingClock = setTimer(function() 
		--outputDebugString(getElementData(localPlayer, "bankmoney"))
		--outputDebugString(getPhoneCallCost())
		if not exports.vrp_bank:hasBankMoney(localPlayer, getPhoneCallCost()) then
			finishPhoneCall("cant_afford")
			return false
		end

		actualCountedTime = string.format("%02d:%02d", minutes, seconds)
		guiSetText(lCallingText, actualCountedTime)
		actualSeconds = actualSeconds + 1
		seconds = seconds + 1
		if seconds >= 60 then
			minutes = minutes + 1
			seconds = 0
		end
	end, 1000, 0)
end

function killDialingTimers()
	for i, timer in pairs(dialingTimers) do
		if timer then
			if isTimer(timer) then
				if killTimer(timer) then
					outputDebugString("[Phone] Client / killDialingTimers")
				end
			end
			timer = nil
		end
	end
end

function killDialingSounds()
	for i, sound in pairs(dialingSounds) do
		if sound then
			if isElement(sound) then
				destroyElement(sound)
				timer = nil
			end
		end
	end
end

local ringOffSetOut = sx
local ringOffSetIn = nil
local ringOffSetY = nil
function drawRinging(phoneRinging)
	--outputChatBox(phoneRinging)
	local margin = 18
	local w, h = 257, 73
	local x, y = sx-w-margin+20, sy-h-margin*1.5
	ringOffSetIn = x
	ringOffSetY = y
	setElementData(localPlayer, "phoneRingingShowing", true)
	if wRing and isElement(wRing) then
		guiSetEnabled(bRingingAnswer, true)
    	guiSetEnabled(bRingingDecline, true)
    	guiSetText(wRing, "Your phone #"..phoneRinging.." is ringing!")
		return true
	end
	wRing = guiCreateWindow(ringOffSetOut,y,w,h, "Your phone #"..phoneRinging.." is ringing!", false)
    guiWindowSetMovable(wRing, false)
    guiWindowSetSizable(wRing, false)

    bRingingAnswer = guiCreateButton(10, 28, 117, 35, "Answer", false, wRing)
    bRingingDecline = guiCreateButton(129, 28, 118, 35, "Decline", false, wRing) 
    addEventHandler("onClientGUIClick", bRingingDecline, function()
    	if source == bRingingDecline then
	    	declinePhoneCall()
    	end
    end)

    addEventHandler("onClientGUIClick", bRingingAnswer, function()
    	if source == bRingingAnswer then
    		answerToPhoneCall()
    	end
    end)
    return true
end

function answerToPhoneCall()
	if canPlayerAnswerCall(localPlayer) then
		guiSetEnabled(bRingingAnswer, false)
		guiSetEnabled(bRingingDecline, false)
		triggerServerEvent("phone:acceptPhoneCall", localPlayer)
	else
		outputDebugString("You can not use cellphone at the moment.", 255,0,0)
	end
end
addCommandHandler("pickup", answerToPhoneCall)

function declinePhoneCall()
	if canPlayerAnswerCall(localPlayer) and bRingingAnswer and isElement(bRingingAnswer) then
		guiSetEnabled(bRingingAnswer, false)
		guiSetEnabled(bRingingDecline, false)
		triggerServerEvent("phone:cancelPhoneCall", localPlayer)
	elseif bEndCall and isElement(bEndCall) then
		endPhoneCall()
	else
		outputDebugString("You can not use cellphone at the moment.", 255,0,0)
	end
end
addCommandHandler("hangup", declinePhoneCall)

function closeRinging()
	if wRing and isElement(wRing) then
		destroyElement(wRing)
		wRing = nil
		setElementData(localPlayer, "phoneRingingShowing", nil)
	end
end

function slideRingingOut()
	if wRing and isElement(wRing) then
		if guiSetPosition(wRing, ringOffSetOut, ringOffSetY, false) and ringOffSetOut < sx then
			ringOffSetOut = ringOffSetOut + slidingSpeed
		else
			removeEventHandler("onClientRender", getRootElement(), slideRingingOut)
		end
	else
		closeRinging()
		removeEventHandler("onClientRender", getRootElement(), slideRingingOut)
	end
end
dialingContactFrom = nil
function startRingingOwner(phoneRinging, canPickUp, dialingContactFrom1)
	--outputChatBox(phoneRinging)
	resetHistory(phoneRinging)
	dialingContactFrom = dialingContactFrom1
	if drawRinging(phoneRinging) then
		--triggerSlidingPhoneOut()
		guiSetEnabled(bRingingAnswer,canPickUp)
		guiSetEnabled(bRingingDecline,canPickUp)
		
		removeEventHandler("onClientRender", getRootElement(), slideRingingOut)
		addEventHandler("onClientRender", getRootElement(), slideRingingIn)
		setElementData(localPlayer, "exclusiveGUI", true, false)
	end
end
addEvent("phone:startRingingOwner", true)
addEventHandler("phone:startRingingOwner", root, startRingingOwner)

function slideRingingIn()
	if wRing and isElement(wRing) then
		if guiSetPosition(wRing, ringOffSetOut, ringOffSetY, false) and ringOffSetOut > ringOffSetIn then
			ringOffSetOut = ringOffSetOut - slidingSpeed
		else
			removeEventHandler("onClientRender", getRootElement(), slideRingingIn)
		end
	else
		removeEventHandler("onClientRender", getRootElement(), slideRingingIn)
	end
end

local ringingTimer = nil
function startPhoneRinging(ringType, ringtone, volume)
	if ringtone > 1 then
		volume = volume/10
		local x, y, z = getElementPosition(source)
		if ringType == 1 then -- phone call
			if not ringtone or ringtone < 0 then ringtone = 4 end
			p_Sound[source] = playSound3D(ringtones[ringtone], x, y, z , true)
			setSoundVolume(p_Sound[source], 0.4*volume)
			setSoundMaxDistance(p_Sound[source], 20)
			setElementDimension(p_Sound[source], getElementDimension(source))
			setElementInterior(p_Sound[source], getElementInterior(source))
			if isTimer(ringingTimer) then
				killTimer(ringingTimer)
			end
			ringingTimer = setTimer(triggerEvent, 15000, 1, "stopRinging", source) --Timer to make sure ringing will be killed at all the exceptional cases client sided
		elseif ringType == 2 then -- sms
			if not ringtone or ringtone < 0 then ringtone = 8 end
			p_Sound[source] = playSound3D(ringtones[ringtone], x, y, z)
			setSoundVolume(p_Sound[source], 0.4*volume)
			setSoundMaxDistance(p_Sound[source], 20)
			setElementDimension(p_Sound[source], getElementDimension(source))
			setElementInterior(p_Sound[source], getElementInterior(source))
			if isTimer(ringingTimer) then
				killTimer(ringingTimer)
			end
			ringingTimer = setTimer(triggerEvent, 15000, 1, "stopRinging", source)
		else
			outputDebugString("Ring type "..tostring(ringType).. " doesn't exist!", 2)
		end
		attachElements(p_Sound[source], source)
	end
end
addEvent("startRinging", true)
addEventHandler("startRinging", getRootElement(), startPhoneRinging)

function stopPhoneRinging()
	if p_Sound[source] and isElement(p_Sound[source]) then
		destroyElement(p_Sound[source])
		p_Sound[source] = nil
	end
	if stopTimer[source] and isTimer(stopTimer[source]) then
		killTimer(stopTimer[source])
		stopTimer[source] = nil
	end
	if source == localPlayer then
		removeEventHandler("onClientRender", getRootElement(), slideRingingIn)
		addEventHandler("onClientRender", getRootElement(), slideRingingOut)
		setElementData(localPlayer, "exclusiveGUI", false, false)
	end
end
addEvent("stopRinging", true)
addEventHandler("stopRinging", getRootElement(), stopPhoneRinging)

function startPressingDialSound(numbers)
	if numbers and tonumber(numbers) then
		startPressingDialSoundIndex = startPressingDialSoundIndex + 1
		local soundToPlay = string.sub(numbers, startPressingDialSoundIndex, startPressingDialSoundIndex) 
		if soundToPlay then
			local sound = playSound("sounds/beeps/"..soundToPlay..".mp3")
			table.insert(dialingSounds, sound)
		else
			startPressingDialSoundIndex = 0
		end
	end
end