addCommandHandler("tamir",
	function(player, cmd)
		if player:getData("tamirci") == 1 then
			if player:getData("mechanic:gui:state") then 
				exports["vrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "mechanic:gui", player, false, false, true)
		end
	end
)

local mysql = exports.vrp_mysql

function mekanik(thePlayer, cmd, komut, targetPlayerName)

    if not (exports.vrp_integration:isPlayerHeadAdmin(thePlayer)) then return end
    
    local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
    local targetName = exports.vrp_global:getPlayerFullIdentity(thePlayer, 1)

    if not komut then
        outputChatBox("[!]#ffffff /mekanik [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if not targetPlayerName then
        outputChatBox("[!]#ffffff /mekanik [Ver] [Al] [ID]", thePlayer, 0, 255, 0, true)
    return end

    if komut == "ver" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `tamirci`='1' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "tamirci", 1)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin tamirci yetkisi verdin.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından size tamirci yetkisi verildi.", targetPlayer, 0, 255, 0,true)
    end

    if komut == "al" then
        dbExec(mysql:getConnection(),"UPDATE `characters` SET `tamirci`='0' WHERE `id`='"..getElementData(targetPlayer, "dbid").."'")
		setElementData(targetPlayer, "tamirci", 0)
        outputChatBox("[!]#ffffff".. targetPlayerName .. " adlı kişinin tamirci yetkisini aldın.", thePlayer, 0, 255, 0, true)
	    outputChatBox("[!]#ffffff"..targetName.." tarafından tamirci yetkin alındı.", targetPlayer, 0, 255, 0,true)
    end
end
addCommandHandler("mekanik", mekanik)