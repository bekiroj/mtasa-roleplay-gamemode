local bannedAnimations = { ["FIN_Cop1_ClimbOut2"]=true, ["FIN_Jump_on"]=true }

addEvent("AnimationSet",true)
addEventHandler("AnimationSet",getRootElement(), 
	function (block, ani, loop)
		if bannedAnimations[ani] then
			outputChatBox("Bu animasyon şu anda yasaklı.", source, 255, 0, 0)
			return 
		end

		if(source)then
			if(block)then
				if loop then
					setPedAnimation(source,block,ani,-1,loop)
				else
					setPedAnimation(source,block,ani,1,false)
				end
			else
				setPedAnimation(source)
			end
		end
	end
)

addEvent("onCustomAnimationSet",true)
addEventHandler("onCustomAnimationSet",getRootElement(), 
	function(player, block, ani, loop)
		if(player)then
			if(block)then
				if loop then
					--setPedAnimation(source,block,ani,-1,loop)
				--	triggerClientEvent(root, "onClientCustomAnimationSet", root, player, block, ani, loop)
				end
			end
		end
	end
)

addEvent("onCustomAnimationStop",true)
addEventHandler("onCustomAnimationStop",getRootElement(), 
	function(player, block, ani, loop)
		if(player)then
			if(block)then
				if loop then
					--setPedAnimation(source,block,ani,-1,loop)
				--	triggerClientEvent(root, "onClientCustomAnimationSet", root, player, false)
				end
			end
		end
	end
)

addEvent("onCustomAnimationSyncRequest", true)
addEventHandler("onCustomAnimationSyncRequest",getRootElement(),
	function(player)

	end
)	
--[[
addCommandHandler("anim",
	function (player, command, block, anim, loop)
		veh = getPedOccupiedVehicle(player)
		if veh then return end
	 	if(block and anim and loop) then
			if loop == 1 then loop = true else loop = false end
	 			triggerEvent("AnimationSet",player, tostring(block),tostring(anim), loop)
	 	else
	 		triggerEvent("AnimationSet",player)
		end
	end
)
]]--
addEvent("give-->anim", true)
addEventHandler("give-->anim", root, 
    function(sElement, e, block,number)
    	veh = getPedOccupiedVehicle(sElement)
    	if veh then return end
        --setPedAnimation(sElement,block,number,-1, false)
        triggerClientEvent(e, "anim -- receive", e, e, block,number,sElement)
    end
)