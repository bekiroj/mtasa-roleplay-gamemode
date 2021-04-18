function playerDeath()
	if exports.vrp_global:hasItem(getLocalPlayer(), 115) or exports.vrp_global:hasItem(getLocalPlayer(), 116) then
		deathTimer = 200 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 200)
	else
		deathTimer = 50 -- Bekleme süresi // Sweetheart
		lowerTime = setTimer(lowerTimer, 1000, 50)
	end
	
addEventHandler("onClientRender", root, bilgipanel)

end
addEvent("playerdeath", true)
addEventHandler("playerdeath", getLocalPlayer(), playerDeath)




setElementData(localPlayer, "bayilma:deger", nil)
setElementData(localPlayer, "aracyasak", nil)


function bilgipanel (oyuncu) 
	sX,sY = guiGetScreenSize()
	x,y,w,h = sX/2-100,sY/2-125,300,210
	w, h = w-4, h-4
	x, y = x+2, y+2
	--dxDrawText("BAYGIN : #ffffff"..deathTimer,x+999,y-55,w+x,h+y+4,tocolor(235,0,0),1.8,"default-bold","center","top", true, true ,true, true)	

		setElementData(localPlayer,  "bayilma:deger", deathTimer)
		
		
	if deathTimer < 0 then
		playerRespawn()
	end
end

function hasarAlindi(saldirgan, silah, yer, kayip)
if isElement(saldirgan) and getElementType ( saldirgan ) == "player" then

 if yer == 3 then
 yer = "Gövde"
 elseif yer == 4 then
 yer = "Sirt"
 elseif yer == 5 then
 yer = "Sol Kol"
 elseif yer == 6 then
 yer = "Sag Kol"
 elseif yer == 7 then
 yer = "Sol Bacak"
 elseif yer == 8 then
 yer = "Sag Bacak"
 elseif yer == 9 then
  yer = "Kafa"
 end
	setElementData(localPlayer,  "bayilma:hasar", yer)
end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), hasarAlindi )

function lowerTimer()
	deathTimer = deathTimer - 1
	
	if (deathTimer>1) then
		
	else
			if deathTimer <= 0 then
				
				triggerServerEvent("es-system:acceptDeath", getLocalPlayer(), getLocalPlayer(), victimDropItem)
				playerRespawn()

				eren = nil
			else
				
			end
	end
end

deathTimer = 10
deathLabel = nil

function playerRespawn()
	removeEventHandler("onClientRender", root, bilgipanel)
	setElementData(localPlayer, "bayilma:deger", nil)
	setElementData(localPlayer, "bayilma:hasar", nil)
	setElementData(localPlayer, "aracyasak",nil)
	setElementData(localPlayer, "cam:basladi",nil)
	killTimer(lowerTime)
	setCameraTarget(getLocalPlayer())
end

addEvent("bayilmaRevive", true)
addEventHandler("bayilmaRevive", root, playerRespawn)

addEvent("fadeCameraOnSpawn", true)
addEventHandler("fadeCameraOnSpawn", getLocalPlayer(),
	function()
		start = getTickCount()
	end
)

function closeRespawnButton()
	if bRespawn then
		destroyElement(bRespawn)
		bRespawn = nil
		showCursor(false)
		guiSetInputEnabled(false)
	end
end
addEvent("es-system:closeRespawnButton", true)
addEventHandler("es-system:closeRespawnButton", getLocalPlayer(),closeRespawnButton)

function noDamageOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", getLocalPlayer(), noDamageOnDeath )

function noKillOnDeath ( attacker, weapon, bodypart )
	if ( getElementData(source, "dead") == 1 ) then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), noKillOnDeath )