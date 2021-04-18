local chatting = false
local chatters = { }

function checkForChat()
	if not (getElementAlpha(getLocalPlayer()) == 0) then
		if (isChatBoxInputActive() and not chatting) then
			chatting = true
			setElementData(localPlayer, "writting", true)
		elseif (not isChatBoxInputActive() and chatting) then
			chatting = false
			setElementData(localPlayer, "writting", false)
		end
	end
end
setTimer(checkForChat, 200, 0)