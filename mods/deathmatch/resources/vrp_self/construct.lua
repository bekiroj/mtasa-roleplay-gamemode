idsystem = {
	servername = 'Belirsiz',
	debug = false,
	ids = {},

	_join = function(self)
		for i = 1, 5000 do
			if (self.ids[i] == nil) then
				slot = i
				break
			end
		end

			--[[
				@define
				defines player slotnumber.
			]]--
			self.ids[slot] = source 
			source:setData('playerid',slot)
			exports.vrp_anticheat:changeProtectedElementDataEx(source, "playerid", slot)
			exports.vrp_pool:allocateElement(source, slot)
	
			--[[
				@change
				changes player name on join
			]]--
			source:setName(self.servername..'-'..tostring(slot))

				if self.debug then 
					outputDebugString('[IDENTITY-INFO]: Yeni giren oyuncu ID: '..slot,0,210,210,210)
				end
	end,

	_quit = function(self)
		if source:getData('playerid') then 

				if self.debug then 
					outputDebugString('[IDENTITY-INFO]: Çıkan oyuncu ID: '..source:getData('identity'),0,210,210,210)
				end	

			self.ids[tonumber(source:getData('playerid'))] = nil
		end
	end,

	_define = function(self) self.players = getElementsByType("player")

		for key, value in ipairs(self.players) do
			self.ids[key] = value
			value:setData('playerid',key)
			exports.vrp_anticheat:changeProtectedElementDataEx(value, "playerid", key)
			exports.vrp_pool:allocateElement(value, key)

			if self.debug then 
				outputDebugString('[IDENTITY-INFO]: Tanımlanan oyuncu ID: '..key,0,210,210,210)
			end
		end

	end,

}
idsystem:_define()

addEventHandler("onPlayerJoin",root,function(player) idsystem:_join(player) end)
addEventHandler("onPlayerQuit",root,function(player) idsystem:_quit(player) end)

addEvent('checker:failed',true)
addEventHandler('checker:failed',root,function(player)
	kickPlayer(player,'Ekran çözünürlüğünüz yeterli değil.')
end)