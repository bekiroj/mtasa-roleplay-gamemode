function doRealBigEars ( message )
	if not exports.vrp_integration:isPlayerSeniorAdmin(client) then
		for key, value in pairs( getElementsByType( "player" ) ) do
			if isElement( value ) then
				local listening = getElementData( value, "realbigears" )
				if listening == client and value ~= client then
					outputChatBox("(" .. getPlayerName(client) .. ") " .. message, value, 255, 255, 0)
				end
			end
		end
	end
end
addEvent( "adm:rbe", true )
addEventHandler( "adm:rbe", getRootElement(), doRealBigEars )