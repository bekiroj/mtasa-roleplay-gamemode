local streamedOut = {}
local voicePlayers = {}

function _render()
	local players = getElementsByType("player")
    local playerCallingTarget = localPlayer:getData("callTarget") or false
    for k, v in ipairs(players) do
        local fPlayerChannel = tonumber(v:getData("radio:channel")) or false
        if voicePlayers[v] then
            local vecSoundPos = v.position
            local vecCamPos = Camera.position
            local fMaxVol = v:getData("maxVol") or 1
            local fVoiceMode = v:getData("currentVoice") or 1
            local fMinDistance = v:getData("minDist") or 5
            local fMaxDistance = v:getData("maxDist") or 25
            local skipSight = false

            if playerCallingTarget == v then
                fMaxDistance = 5000
                fMaxDistance = 5000
                vecSoundPos = localPlayer.position
                skipSight = true
            end

            local fDistance = (vecSoundPos - vecCamPos).length
                
            local fPanSharpness = 1.0
            if (fMinDistance ~= fMinDistance * 2) then
                fPanSharpness = math.max(0, math.min(1, (fDistance - fMinDistance) / ((fMinDistance * 2) - fMinDistance)))
            end

            local fPanLimit = (0.65 * fPanSharpness + 0.35)

                -- Pan
            local vecLook = Camera.matrix.forward.normalized
            local vecSound = (vecSoundPos - vecCamPos).normalized
            local cross = vecLook:cross(vecSound)
            local fPan = math.max(-fPanLimit, math.min(-cross.z, fPanLimit))

            local fDistDiff = fMaxDistance - fMinDistance;

                -- Transform e^-x to suit our sound
            local fVolume
            if (fDistance <= fMinDistance) then
                fVolume = fMaxVol
            elseif (fDistance >= fMaxDistance) then
                fVolume = 0.0
            else
                fVolume = math.exp(-(fDistance - fMinDistance) * (5.0 / fDistDiff)) * fMaxVol
            end
            setSoundPan(v, fPan)

                
            if (isLineOfSightClear(localPlayer.position, vecSoundPos, true, true, false, true, false, true, true, localPlayer) or skipSight) then
                setSoundVolume(v, fVolume)
                setSoundEffectEnabled(v, "compressor", false)
            else
                local fVolume = fVolume * 5.5
                local fVolume = fVolume < 0.01 and 0 or fVolume
                setSoundVolume(v, fVolume)
                setSoundEffectEnabled(v, "compressor", true)
            end
        else
            if getSoundVolume(v) ~= 0 then
               setSoundVolume(v, 0)
            end
        end
    end
end
setTimer(_render, 35, 0)

addEventHandler("onClientResourceStart", resourceRoot,
    function ()
        triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer, getElementsByType("player"))
        for i, player in ipairs(getElementsByType("player")) do
            setSoundVolume(player, 0)
        end
    end
)

addEventHandler("onClientPlayerJoin", root,
    function()
        triggerServerEvent("proximity-voice::broadcastUpdate", localPlayer, getElementsByType("player"))
        setSoundVolume(source, 0)
    end
)

addEventHandler("onClientPlayerVoiceStart", root,
    function()
        if source:getData("loggedin") ~= 1 then cancelEvent() return end
        local distance = getDistanceBetweenPoints3D(localPlayer.position, source.position)
        local callTarget = localPlayer:getData("callTarget")
        local playerChannel = tonumber(localPlayer:getData("radio:channel"))
        local targetChannel = tonumber(source:getData("radio:channel"))
        if distance < 10 or callTarget == source or playerChannel == targetChannel then
            voicePlayers[source] = true
        end
	end
)

addEventHandler("onClientPlayerVoiceStop", root,
	function()
		voicePlayers[source] = nil
	end
)

function getPlayerTalking(plr)
	return voicePlayers[plr]
end

addEventHandler("onClientPlayerQuit", root,
	function()
		voicePlayers[source] = nil
	end
)