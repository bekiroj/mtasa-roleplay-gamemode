local lastLogType = -1
local lastData = ""
local lastLogsource = getRootElement()

-- Log prefixes
-- ac	AccountID
-- ch	CharacterID
-- ve	Vehicle
-- fa	Faction
-- in	Interior
-- ph	Phone
-- ob 	Object

-- Action ID's
-- 1 Admin chat /h			x
-- 2 Admin chat /l			x
-- 3 Admin chat /a			x
-- 4 Admin command
-- 5 Anticheat
-- 6 Vehicle related things
-- 7 Player /say			x
-- 8 Player /b				x
-- 9 Player /r				x
-- 10 Player /d				x
-- 11 Player /f				x
-- 12 Player /me's			x
-- 13 Player /destrict's		x
-- 14 Player /do's			x
-- 15 Player /pm's			x
-- 16 Player /gov			x
-- 17 Player /don			x 
-- 18 Player /o				x
-- 19 Player /s				x
-- 20 Player /m				x
-- 21 Player /w				x
-- 22 Player /c				x
-- 23 Player /n				x
-- 24 Gamemaster chat /g	x
-- 25 Cash transfer			x
-- 26 GameCoins				x
-- 27 Connection			x			
-- 28 Roadblocks			x		
-- 29 Phone logs			x	
-- 30 SMS logs				x
-- 31 Int/Vehicle actions (locking/unlocking/start/enter/exit)x			
-- 32 UCP logs
-- 33 Stattransfers			x
-- 34 Kill logs/Lost items	x
-- 35 Faction actions		x
-- 36 Ammunation			x
-- 37 Interior related things		x
-- 38 Admin Reports
-- 39 Item Movement			x
-- 40 Player /ame
-- 41 Business Chat

function dbLog(logSource, actionID, affected, data)
	return true
end

function dbLogDetectTypeSource( theElement )
	return true
end

function getElementLogID( theElement )
	return true
end

function logMessage(message, type)
	return true
end