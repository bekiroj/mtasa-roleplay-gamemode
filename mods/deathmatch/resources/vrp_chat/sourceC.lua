function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "playRadioSound", true )
addEventHandler( "playRadioSound", root, playRadioSound )

function playCustomChatSound(sound)
	playSound("components/"..tostring(sound), false)
end
addEvent( "playCustomChatSound", true )
addEventHandler( "playCustomChatSound", root, playCustomChatSound )

function playHQSound()
	playSoundFrontEnd(1)
	setTimer(playSoundFrontEnd, 300, 1, 1)
end
addEvent("playHQSound", true)
addEventHandler("playHQSound", root, playHQSound)

--PM SOUND FX / MAXIME
function playPmSound(message)
	local pmsound = playSound("components/pmSoundFX.mp3",false)
	setSoundVolume(pmsound, 0.9)
	if message then
		createTrayNotification(message)
	end
end
addEvent("pmClient",true)
addEventHandler("pmClient", root, playPmSound)

addEventHandler("onClientResourceStart", root,
	function()
		if getElementData(localPlayer, "loggedin") == 1 then
			createBindKeys()
		end
	end
)
addEventHandler("onClientResourceStop", root,
	function()
		destroyBindKeys()
	end
)

addEventHandler("onClientElementDataChange", root,
	function(dataName)
		if source ~= localPlayer then return end
		if dataName == "loggedin" then
			local logged = getElementData(localPlayer, dataName)
			if logged == 1 then
				createBindKeys()
			else
				destroyBindKeys()
			end
		end
	end
)

addEventHandler("onClientKey", root,
	function(b, s)
		if s and b == "y" then
			cancelEvent()
		end
	end
)

function createBindKeys()
	bindKey("b", "down", "chatbox", "LocalOOC")
	bindKey ("u" , "down" , "chatbox", "quickreply")
end

function destroyBindKeys()
	unbindKey("b", "down")
	unbindKey("u", "down")
end

addCommandHandler("clearchat",
	function()
		for i=1, 15 do
			outputChatBox(" ")
		end
		clearChatBox()
	end
)