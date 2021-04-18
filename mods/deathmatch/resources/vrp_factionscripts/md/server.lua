local tedaviyeri = createColSphere ( 1590.9909667969, 1796.5489501953, 2083.376953125, 3)
setElementInterior(tedaviyeri, 10)
setElementDimension(tedaviyeri, 180)
local pickup = createPickup(1590.9909667969, 1796.5489501953, 2083.376953125, 3, 1239)
setElementData(pickup, "informationicon:information", "#CC3333/tedaviol\n#CC3333/doktorcagir#ffffff\nMedical Department")
setElementInterior(pickup, 10)
setElementDimension(pickup, 180)

function tedavi(thePlayer, cmd)
	local viprank2 = getElementData(thePlayer, "vip")==2
	local viprank3 = getElementData(thePlayer, "vip")==3
	if not exports.vrp_global:takeMoney(thePlayer, 200) and not (viprank2) and not (viprank3) then
		outputChatBox("Sunucu: #ffffffTedavi olmak için $200 ödemeniz gerekli.", thePlayer, 255,0,0,true)
		return
	end
	if not isElementWithinColShape(thePlayer, tedaviyeri) then
	return
	end
	local health = 100
	setElementHealth(thePlayer , tonumber(health))
	outputChatBox("Sunucu: #ffffff$200 karşılığında tedavi oldunuz.", thePlayer, 255,0,0,true)
end
addCommandHandler("tedaviol", tedavi)

local destekalani = createColSphere ( 1590.9909667969, 1796.5489501953, 2083.376953125, 3, 1779)
setElementDimension(destekalani , 180 )
setElementInterior(destekalani , 10 )

local oyuncu = {}

function poliscagir(thePlayer, commandName, ...)
local serial = getPlayerSerial(thePlayer)
	
	if oyuncu[serial] and oyuncu[serial] + 60*60*1000 > getTickCount() then
		outputChatBox("[!]#fdfdfd Bir daha doktor çağırabilmek için "..(math.ceil(2 - (getTickCount() - oyuncu[serial])/(60*1000))).." dakika beklemelisiniz.", thePlayer, 194, 0, 0, true)
		return
	end
	if (isElementWithinColShape(thePlayer, destekalani)) then
        local logged = getElementData(thePlayer, "loggedin")
		outputChatBox("[!]#fdfdfd Doktor çağırma talebiniz departmana iletilmiştir, lütfen beklemede kalın.",thePlayer, 12, 243, 0, true)
		for k, v in ipairs(getPlayersInTeam(getTeamFromName ("Los Santos Medical Department"))) do
		outputChatBox("[LSMD]#ffffff Bir vatandaş sizi departman'da bekliyor.", v, 50, 125, 200, true)
		oyuncu[serial] = getTickCount()
      end
   end
end
addCommandHandler("doktorcagir", poliscagir, false, false)