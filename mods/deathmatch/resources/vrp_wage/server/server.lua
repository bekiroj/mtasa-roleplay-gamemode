Async:setPriority("low")
local chars = "1,2,3,4,5,6,7,8,9,0,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,R,S,Q,T,U,V,X,W,Z"
local codes = split(chars, ",")
local controlSystem = {}

outputChatBox = outputChatBox
getElementData = getElementData
setElementData = setElementData

function timer()
 for index, player in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
  if getElementData(player, "loggedin") == 1 then
  setElementData(player, "minutesPlayed", tonumber(getElementData(player, "minutesPlayed")) + 1)
   if tonumber(getElementData(player, "minutesPlayed")) >= 60 then
   	controlSystem[player] = {}
    controlSystem[player].code = codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]..codes[math.random(#codes)]
    triggerClientEvent(player, "wage.sound", player)
    setElementData(player, "boxexp", tonumber(getElementData(player, "boxexp") or 0) + 1)
	setElementData(player, "minutesPlayed", 0)
	setElementData(player, "hoursplayed", tonumber(getElementData(player, "hoursplayed")) + 1)
	if tonumber(getElementData(player, "boxexp")) >= 4 then
	 outputChatBox("[!] #FFFFFFDört saat oynadınız ve bir kutu kazandınız.", player, 0, 255, 0, true)
     setElementData(player, "boxexp", 0)
     setElementData(player, "box", tonumber(getElementData(player, "box")) + 1)
	end
	outputChatBox("[!] #ffffffSaatlik bonus ve maaşınızı 2 dakika içinde [/onayla "..controlSystem[player].code.."] yazarak onaylayıp alabilirsiniz.", player, 0, 55, 255, true)
    if player and isElement(player) and controlSystem[player] then
	 controlSystem[player].endTimer = setTimer(
	  function(plr)
	   if isElement(plr) then
		if controlSystem[plr] then
		 outputChatBox("[!] #ffffffDoğrulama kodunu girmediğiniz için saatlik bonus alamadınız.", plr, 232, 65, 24, true)
		 controlSystem[plr] = nil
	   end
	  end
	 end, 60*2000, 1, player)
	end
   end
  end
 end
end
setTimer(timer, 60000, 0)

function checkCode(player, cmd, code)
 if code then 
  if controlSystem[player] then
   if tostring(controlSystem[player].code) == tostring(code) then
     controlSystem[player] = nil
     local factionID = getElementData(player, "faction")
	 if factionID == 1 or factionID == 2 or factionID == 3 or factionID == 20 or factionID == 78 then
	  local factionName = "(Hiçbir Birlik)"
	  local vfaction = tonumber(getElementData(player, "faction"))
	  for key, player in ipairs(exports.vrp_pool:getPoolElementsByType("team")) do
	  local id = tonumber(getElementData(player, "id"))
	  if (id==vfaction) then
	   factionName = getTeamName(player)
	   break
	  end
	  end		
      local theTeam = getPlayerTeam(player)	
      local wages = getElementData(theTeam, "wages")
      local factionRank = getElementData(player, "factionrank")
      local rankWage = tonumber( wages[factionRank] )
      setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + rankWage)
      outputChatBox("[!] #ffffff "..factionName.." maaşınız: "..rankWage.."$", player, 0, 55, 255, true)
	 end
	  setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + 200)
	  outputChatBox("[!] #ffffffTebrikler, saatlik maaşınız 200$ yatırıldı.", player, 0, 255, 0, true)
      if (getElementData(player, "vip") == 1) then
       setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + 200)
       outputChatBox("[!] #ffffffVIP [1] olduğunuz için saatlik ekstra 200$ kazandınız.", player, 0, 255, 0, true)
      elseif (getElementData(player, "vip") == 2) then
       setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + 300)
       outputChatBox("[!] #ffffffVIP [2] olduğunuz için saatlik ekstra 300$ kazandınız.", player, 0, 255, 0, true)
      elseif (getElementData(player, "vip") == 3) then
       setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + 400)
       outputChatBox("[!] #ffffffVIP [3] olduğunuz için saatlik ekstra 400$ kazandınız.", player, 0, 255, 0, true)
      elseif (getElementData(player, "vip") == 4) then
       setElementData(player, "bankmoney", tonumber(getElementData(player, "bankmoney")) + 600)
       outputChatBox("[!] #ffffffVIP [4] olduğunuz için saatlik ekstra 600$ kazandınız.", player, 0, 255, 0, true)
      end
   else
    outputChatBox("[!] #ffffffEksik ya da yanlış bir kod girdiniz.", player, 255, 0, 0, true)
   end
  end
 end
end
addCommandHandler("onayla", checkCode)

local moneys = {
	[1] = 300,
	[2] = 500,
	[3] = 1000,
	[4] = 1250,
	[5] = 1500,
	[6] = 1750,
	[7] = 2250,
	[8] = 3500,
	[9] = 5000,
	[10] = 6500,
}

local region = createColSphere(1295.3359375, -2351.6982421875, 13.189653396606, 3)
local pickup = createPickup(1295.3359375, -2351.6982421875, 13.189653396606, 3, 1274)
setElementData(pickup, "informationicon:information", "#A33CBD/hediyeal#ffffff\nHediye Ağacı")

function quantity(source, cmd)
 if getElementData(source, 'loggedin') == 1 then
  outputChatBox("[!]#ffffff Kalan kutu sayısı: "..getElementData(source, 'box').."",source,100,100,255,true)
 end
end
addCommandHandler('kalankutu',quantity)

function open(source, cmd)
 if getElementData(source, 'loggedin') == 1 then
  if isElementWithinColShape(source, region) then
   if getElementData(source, 'box') > 0 then
    setElementData(source, 'box', tonumber(getElementData(source, 'box') - 1))
	local pay = moneys[math.random(1,10)]
	exports.vrp_global:giveMoney(source, pay)
	outputChatBox("[!]#ffffff Hediye ağacından "..pay.."$ kazandınız!",source,100,100,255,true)
	outputChatBox("[!]#ffffff Kalan kutu sayısı: "..getElementData(source, 'box').."",source,100,100,255,true)
   else
    outputChatBox("[!]#ffffff Herhangi bir kutunuz bulunmuyor. Kutu miktarınızı öğrenmek için '/kalankutu'",source,100,100,255,true)
   end
  end
 end
end
addCommandHandler('hediyeal',open)