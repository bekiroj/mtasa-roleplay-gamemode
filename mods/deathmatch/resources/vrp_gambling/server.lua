--- ZAR SİSTEMİ

local invites = {}
local pairedPlayers = {}

function invite(player, cmd, arg, betAmount)
	if not (arg == "kabul" or arg == "ret") then
        if not (arg and betAmount) then
            outputChatBox("[!] #FFFFFFKullanım: /davet <oyuncu id> <Bahis Miktarı>", player, 0, 55, 255, true)
            outputChatBox("[!] #FFFFFFKullanım: /davet kabul/ret", player, 0, 55, 255, true)
            return
        end
    end
    if getElementData(player, "hoursplayed") < 12 then
        outputChatBox("[!] #FFFFFFBu sistemi kullanabilmek için en az 12 saat oynamanızın olması gerekiyor.", player, 255, 0, 0, true)
        return
    end
    if tonumber(arg) then
        local invitedPlayer = exports.vrp_global:findPlayerByPartialNick(player, arg)

        if not type(invitedPlayer) == "player" then
            outputChatBox("[!] #FFFFFFEşleşmek istediğiniz oyuncu bulunamadı", player, 255, 0, 0, true)
            return
        end
        

        if pairedPlayers[player] then
            outputChatBox("[!] #FFFFFFZaten bir rakip ile eşleştiniz.", player, 255, 0, 0, true)
            return
        end
        if pairedPlayers[invitedPlayer] then
            outputChatBox("[!] #FFFFFFDavet etmeye çalıştığınız oyuncu zaten başka birisi ile eşleşmiş", player, 255, 0, 0, true)
            return
        end
        if invites[invitedPlayer] then
            local text = invites[invitedPlayer] == player and "zaten davet gönderdin" or "başka birisi davet göndermiş"
            outputChatBox("[!] #FFFFFF"..getPlayerName(invitedPlayer).." adlı kişiye "..text, player, 255, 0, 0, true)
            return
        end
        local interior, targetInterior = getElementInterior(player), getElementInterior(invitedPlayer)
        local rx, ry, rz = getElementPosition(player)
        local lx, ly, lz = getElementPosition(invitedPlayer)
        local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
        if distance >= 5 then
            outputChatBox("[!] #FFFFFFDavet ettiğiniz oyuncu sizden oldukça uzak.", player, 255, 0, 0, true)
            return false
        end
        if interior ~= targetInterior then
            return false
        end
        if not exports.vrp_global:hasMoney(player, betAmount) then
             outputChatBox("[!] #FFFFFFBahis yaptığınız kadar para üzerinizde yok.", player, 255, 0, 0, true)
            return
        end
		
		if not exports.vrp_global:hasMoney(invitedPlayer, betAmount) then
             outputChatBox("[!] #FFFFFFBahis oynayabilmek için üzerinizde yeterli para yok.", invitedPlayer, 255, 0, 0, true)
			 outputChatBox("[!] #FFFFFFKarşı tarafın üzerinde yeterli para yok.", player, 255, 0, 0, true)
            return
        end
        invites[invitedPlayer] = player
        
        outputChatBox("[!] #FFFFFF"..getPlayerName(invitedPlayer).." adlı kişiye davet gönderildi.", player, 0, 255, 0, true)
        outputChatBox("[!] #FFFFFF"..getPlayerName(player).." adlı kişi size $"..betAmount.." dolarlık bahise davet etti.", invitedPlayer, 0, 255, 0, true)
        triggerClientEvent(invitedPlayer, "bekiroj:pairs:inviteGUI", invitedPlayer, getPlayerName(player), betAmount)
        setElementData(player, "betAmount", betAmount)
        setElementData(invitedPlayer, "betAmount", betAmount)
        
    elseif arg == "kabul" then
        if not exports.vrp_global:hasMoney(player, betAmount) then
            outputChatBox("[!] #FFFFFFBahis alacağınız kadar para üzerinizde yok.", player, 255, 0, 0, true)
            return
        end

        local inviterPlayer = invites[player]
        if (isElement(inviterPlayer)) then
            betAmount = getElementData(player, "betAmount")
            pairedPlayers[player] = {opponent = inviterPlayer, bet = betAmount, spinned = false}
            pairedPlayers[inviterPlayer] = {opponent = player, bet = betAmount, spinned = false}

            outputChatBox("[!] #FFFFFF"..getPlayerName(inviterPlayer).." adlı kişinin davetini kabul ettin.", player, 0, 255, 0, true)
            outputChatBox("[!] #FFFFFF"..getPlayerName(player).." adlı kişi davetinizi kabul etti.", inviterPlayer, 0, 255, 0, true)
            triggerClientEvent(inviterPlayer, 'bekiroj:pairs:showGUI', inviterPlayer, getPlayerName(player), betAmount)
            triggerClientEvent(player, 'bekiroj:pairs:showGUI', player, getPlayerName(inviterPlayer), betAmount)
        else 
            outputChatBox("[!] #FFFFFFKimse sana zar bahisi daveti göndermemiş.", player, 0, 55, 255, true)
        end
        
    elseif arg == "ret" then
        local inviterPlayer = invites[player]
        if (isElement(inviterPlayer)) then
            invites[player] = nil
            
            outputChatBox("[!] #FFFFFF"..getPlayerName(inviterPlayer).." adlı kişinin bahis davetini red ettin.", player, 255, 0, 0, true)
            outputChatBox("[!] #FFFFFF"..getPlayerName(inviterPlayer).." bahis davetinizi reddetti.", inviterPlayer, 255, 0, 0, true)
        end
    end
end
addCommandHandler('davet', invite)
addEvent("diceBet:invite", true)
addEventHandler("diceBet:invite", root, invite)

function spin(player)
    local clientData = pairedPlayers[player]
    if not clientData then
        outputChatBox("[!] #FFFFFFÖnce birisiyle eşleşmelisin.", player, 255, 0, 0, true)
        return
    end
    
    local opponent = clientData.opponent
    if not isElement(opponent) then
        outputChatBox("[!] #FFFFFFRakip oyuncu oyunda değil, başka birisiyle eşleşebilirsin.", player, 0, 55, 255, true)
        pairedPlayers[player] = nil
        return
    end
    if not exports.vrp_global:hasMoney(player, getElementData(player, "betAmount")) then
		pairedPlayers[pairedPlayers[player].opponent] = nil
		outputChatBox("[!] #FFFFFFRakibinizde yeterli para bulunmadığı için kumar iptal edildi.", pairedPlayers[player].opponent, 255, 0, 0, true)
		invites[pairedPlayers[player].opponent] = nil
		pairedPlayers[player] = nil
		invites[player] = nil
		outputChatBox("[!] #FFFFFFÜzerinizde yeterli para bulunmamaktır.", player, 255, 0, 0, true)
		return
	end
    local opponentData = pairedPlayers[opponent]
    if not opponentData then
        outputChatBox("[!] #FFFFFFRakip verisi bulunamadı.", player, 255, 0, 0, true)
        return
    end
 
    local opponentSpinned = opponentData.spinned
    local spinned = clientData.spinned
    if not spinned then
		math.randomseed(getTickCount())
		pairedPlayers[player].spinned = {math.random(1,6),  math.random(1,6)}
		outputChatBox("[!] #FFFFFFDöndürdünüz rakibin döndürmesi bekleniyor [Rakip: "..(opponentSpinned and "Döndürdü" or "Döndürmedi").."]", player, 0, 55, 255, true)
    elseif spinned and not opponentSpinned then
		outputChatBox("[!] #FFFFFFSıra rakip oyuncuda.", player, 0, 55, 255, true)
        return
    end


	if not opponentSpinned then
		 outputChatBox("[!] #FFFFFFSonuçların açıklanması için karşı tarafın döndürmesini bekliyoruz.", player, 0, 55, 255, true)
		 return
	end

    local number1, number2 = pairedPlayers[player].spinned[1], pairedPlayers [player].spinned[2]
    local myScore = number1+number2
    local number3, number4 = opponentSpinned[1], opponentSpinned[2]
    local opponentScore = number3+number4
    
    local winner = false
    if myScore > opponentScore then
        winner = player
    elseif myScore < opponentScore then
        winner = opponent
    end
   
    -- send info to players
    for i, player in ipairs({player, opponent}) do
        local playerData = pairedPlayers[player]
        if exports.vrp_global:hasMoney(player, getElementData(player,"betAmount")) then
            exports.vrp_global:takeMoney(player,getElementData(player,"betAmount"))
        else
			outputChatBox("[!] #FFFFFFKarşı tarafın oynayacak parası kalmadığı için oyun iptal edildi.", pairedPlayers[pairedPlayers[player].opponent], 0, 55, 255, true)
			pairedPlayers[pairedPlayers[player].opponent] = nil
			invites[pairedPlayers[player].opponent] = nil
            invites[player] = nil
            invites[opponet] = nil
            pairedPlayers[opponent] = nil
            pairedPlayers[player] = nil
            outputChatBox("[!] #FFFFFFOynayacak paran kalmadığın için oyun iptal edildi.", player, 0, 55, 255, true)
            return
        end

        outputChatBox("--------------------------------", player, 0, 55, 255, true)

        outputChatBox("[!] #FFFFFF"..getPlayerName(player)..", (1. Zar: "..number1.."), (2. Zar: "..number2..") (Toplam: "..myScore..")", player, 0, 55, 255, true)
        outputChatBox("[!] #FFFFFF"..getPlayerName(opponent)..", (1. Zar: "..number3.."), (2. Zar: "..number4..") (Toplam: "..opponentScore..")", player, 0, 55, 255, true)
        if winner then
            outputChatBox("[!] #FFFFFFBu raundu "..getPlayerName(winner).."  kazandı.", player, 0, 255, 0, true)
            if winner == player then
                exports.vrp_global:giveMoney(winner,getElementData(player,"betAmount")*2)
            end
        else
            outputChatBox("[!] #FFFFFFBu raundu kimse kazanamadı (berabere)", player, 0, 55, 255, true)
            exports.vrp_global:giveMoney(player, getElementData(player, "betAmount"))
        end
        --setElementData(player, "betAmount", 0)
        outputChatBox("--------------------------------", player, 0, 55, 255, true)
        pairedPlayers[player].spinned = false

        --pairedPlayers[player] = nil
        --invites[player] = nil
        if exports.vrp_global:hasMoney(player, getElementData(player, "betAmount")) then
            --exports.vrp_global:takeMoney(player, getElementData(player, "betAmount"))
            triggerClientEvent(player, 'bekiroj:pairs:showGUI', player, getPlayerName(opponent), getElementData(player,"betAmount"))
        else
            outputChatBox("[!] #FFFFFFBahis oynayacak paran kalmadı.", player, 0, 55, 255, true)
		
            invites[pairedPlayers[player].opponent] = nil
            pairedPlayers[pairedPlayers[player].opponent] = nil
			pairedPlayers[player] = nil
			
			invites[player] = nil
        end
    end
end
addEvent("diceBet:spin", true)
addEventHandler("diceBet:spin", root, spin)

function updateBet(player)
    outputChatBox("[!] #FFFFFFBahisten başarıyla ayrıldınız.", player, 0, 255, 0, true)
    outputChatBox("[!] #FFFFFF"..getPlayerName(player).." bahisten ayrıldı.", pairedPlayers[player].opponent, 0, 255, 0, true)
    triggerClientEvent(pairedPlayers[player].opponent, "diceBet:closeGUI", pairedPlayers[player].opponent)
    pairedPlayers[pairedPlayers[player].opponent] = nil
    invites[pairedPlayers[player].opponent] = nil
    pairedPlayers[player] = nil
    invites[player] = nil
    --exports.vrp_global:giveMoney(player, getElementData(player, "betAmount"))
    setElementData(player, "betAmount", 0)
end
addEvent("diceBet:remove", true)
addEventHandler("diceBet:remove", root, updateBet)