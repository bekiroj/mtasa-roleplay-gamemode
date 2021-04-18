--[[
* ***********************************************************************************************************************
* Copyright (c) 2019 Lucy Project - Enes Akıllıok
* All rights reserved. This program and the accompanying materials are private property belongs to Lucy Project
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* https://www.github.com/yourpalenes
* ***********************************************************************************************************************
]]

self = {}

self.factions = {
	[1] = true,--LSPD
	[2] = true,--LSMD
	[78] = true,--LSGOV
}

addEventHandler("onClientVehicleStartEnter", root,
	function(thePlayer, seat, jacked)
		local playerFaction = tonumber(getElementData(thePlayer, "faction"))
		local vehicleFaction = tonumber(getElementData(source, "faction"))
	
		if (thePlayer == localPlayer) and (seat == 0) then
			if (self.factions[vehicleFaction] and playerFaction ~= vehicleFaction) then
				cancelEvent()
				outputChatBox(exports.vrp_pool:getServerSyntax(false, "s").."Bu aracı yalnızca birliğe ait şahıslar kullanabilir.", 255, 0, 0, true)
			end
		end
	end
)