
addEvent("proximity-voice::broadcastUpdate", true)
addEventHandler("proximity-voice::broadcastUpdate", root,
    function(broadcastList)
        if client and source == client then else return end
        setPlayerVoiceIgnoreFrom(source, nil)
        setPlayerVoiceBroadcastTo(source, broadcastList)
    end
)

if isVoiceEnabled() then
	local playerChannels = {}
	local channels = {}
	
	addEventHandler("onPlayerJoin", root,
		function()
			setPlayerVoiceBroadcastTo(source, getElementsByType("player"))
			setPlayerInternalChannel(source, root)
		end
	)

	addEventHandler("onResourceStart", resourceRoot,
		function()
			refreshPlayers()
			setTimer(refreshPlayers, 1000*60, 0)
		end
	)

	function refreshPlayers()
		for i,player in ipairs(getElementsByType"player") do
			setPlayerInternalChannel(player, root)
		end
	end


	function setPlayerInternalChannel ( player, element )
		if playerChannels[player] == element then
			return false
		end
		playerChannels[player] = element
		channels[element] = player
		setPlayerVoiceBroadcastTo ( player, element )
		return true
	end
end