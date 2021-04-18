local playerAnimations = {}
local synchronizationPlayers = {}

addEventHandler("onPlayerJoin", root,
    function()
        playerAnimations [ source ] = {}
    end
)

for _, player in pairs(getElementsByType ("player")) do 
    playerAnimations[player] = {}
    setPedGravity(player, 0.008)
end

addEvent ("onCustomAnimationStop", true )
addEventHandler ("onCustomAnimationStop", root,
    function(player)
        SetAnimation(player, false)
    end 
)

addEvent("sync:target", true)
addEventHandler("sync:target", root,
	function(aName)
		triggerClientEvent(source, "sync:anim", source, aName)
	end
)
addEvent("onCustomAnimationSyncRequest", true )
addEventHandler("onCustomAnimationSyncRequest", root,
    function(player)
        table.insert(synchronizationPlayers, player)
        triggerLatentClientEvent(player, "onClientCustomAnimationSyncRequest", 50000, false, player, playerAnimations )
    end 
)

addEvent("onClientCustomAnimationUpdate", true)
addEventHandler("onClientCustomAnimationUpdate", root,
	function(player, index)
		dbExec(exports.vrp_mysql:getConnection(), "UPDATE characters SET customanim = '"..index.."' WHERE id = '".. getElementData(player, "dbid") .."'")
	end
)
function setPlayerCustomAnimations (p, index)
	triggerClientEvent(p,"setPlayerCustomAnimation", p, p, index)
end


addEventHandler ( "onPlayerQuit", root,
    function()
 for i, player in pairs ( synchronizationPlayers ) do
            if source == player then 
                table.remove(synchronizationPlayers, i)
                break
            end 
        end 
        playerAnimations [ source ] = nil
    end
)

addEvent ("onCustomAnimationSet", true )
addEventHandler ("onCustomAnimationSet", root,
    function(player, blockName, animationName)
        SetAnimation(player, blockName, animationName)
        triggerClientEvent(root, "onClientCustomAnimationSet", player, blockName, animationName) 
    end 
)

addEvent ("onCustomAnimationReplace", true )
addEventHandler ("onCustomAnimationReplace", root,
    function(player, ifpIndex)
        playerAnimations[ player ].replacedPedBlock = ifpIndex
 

        triggerClientEvent(root, "onClientCustomAnimationReplace", player, ifpIndex)
    end 
)

addEvent ("onCustomAnimationRestore", true )
addEventHandler ("onCustomAnimationRestore", root,
    function(player, blockName)
        playerAnimations[ player ].replacedPedBlock = nil
        triggerClientEvent ( root, "onClientCustomAnimationRestore", player, blockName)
    end 
)

function SetAnimation ( player, blockName, animationName )
    if not playerAnimations[ player ] then playerAnimations[ player ] = {} end 
    if blockName == false then
        playerAnimations[ player ].current = nil
    else
        playerAnimations[ player ].current = {blockName, animationName}
    end 
end