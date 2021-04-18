local updateTimer = 1200
	
setTimer(function()
	local specList = {}
	for k,v in ipairs(getElementsByType("player")) do
		local target = getCameraTarget(v)
		if target and (target ~= v) then
			if not specList[target] then
				specList[target] = {}
			end
			specList[target][#specList[target]+1] = getPlayerName(v)
		end
	end
	for k,v in ipairs(getElementsByType("player")) do
		local target = getCameraTarget(v)
		if target and specList[target] then
			triggerClientEvent(v,"sendClientSpecList",root,specList[target])
		else
			triggerClientEvent(v,"sendClientSpecList",root,{})
		end
	end
end,updateTimer,0)