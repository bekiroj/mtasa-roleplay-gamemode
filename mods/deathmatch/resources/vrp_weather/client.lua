
local currentWeather = 10
local timeSavedHour, timeSavedMinute
local x, y, z = nil

function ChangePlayerWeather(weather, forced)
	if forced or getElementData(localPlayer, 'loggedin') == 1 and getElementInterior( localPlayer ) == 0 and getElementDimension(localPlayer) == 0  then
		currentWeather = weather
		setWeather( currentWeather )
		setWeatherBlended( currentWeather )
	end
end
addEvent( "weather:update", true )
addEventHandler( "weather:update", root, ChangePlayerWeather )

function updateInterior()
	if getElementInterior( getLocalPlayer( ) ) > 0 then
		if getWeather( ) ~= 3 then
			setWeather( 3 )
			setSkyGradient( 0, 0, 0, 0, 0, 0 )
		end
	else
		local currentWeatherID, blended = getWeather( )
		if currentWeatherID ~= currentWeather and not blended then
			setWeather( currentWeather )
			resetSkyGradient( )
		end
	end
end
setTimer( updateInterior, 2000, 0)

function forceWeather(  )
	setWeather( currentWeather )
	resetSkyGradient()
	setTime(timeSavedHour, timeSavedMinute+1)
end

function resetWeather( )
	setWeather(1)
	setWeatherBlended(1)
	outputDebugString('Reset client weather.')
end

addEventHandler( "onClientResourceStart", resourceRoot, function()
	resetWeather()
	addEventHandler( 'account:character:select', root, resetWeather )
end )

addEventHandler( 'onClientResourceStop', resourceRoot, function()
	resetWeather()
	removeEventHandler( 'account:character:select', root, resetWeather )
end)

addCommandHandler("fw", function()
	if exports.vrp_integration:isPlayerAdmin(localPlayer) then
	outputChatBox("Fireworks created!", getRootElement())
	fxAddSparks(x, y, z+1, 0, 0, 0, 5, 1000, 0, 0, 1, false, 2, 2)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTankFire(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddGunshot(x, y+0.5, z+1, 1, 3, 2, true)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	--fxAddTyreBurst(x, y+0.5, z+1, 1, 3, 2)
	outputChatBox("Fireworks created!", getRootElement())
	else
	end
end)

addCommandHandler("setfw", function()
	if exports.vrp_integration:isPlayerAdmin(localPlayer) then
	x, y, z = getElementPosition(localPlayer)
	outputChatBox("Fireworks position set!", getRootElement())
	else
	end
end)

addCommandHandler("resetfw", function()
	if exports.vrp_integration:isPlayerAdmin(localPlayer) then
	x, y, z = nil, nil, nil
	outputChatBox("Fireworks position reset!", getRootElement())
	else
	end
end)