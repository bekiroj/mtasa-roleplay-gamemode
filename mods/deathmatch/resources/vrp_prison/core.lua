Async:setPriority('low');
mysql = exports.mysql;

sPrison = {

	region = ColShape.Sphere(439.5439453125, -1549.572265625, 28.059703826904, 3),

	pickup = Pickup(439.5439453125, -1549.572265625, 28.059703826904, 3, 1239),

	jail = function(player, cmd, targetPlayerName, time, ...)
	sPrison = instance;
		if player:getData('faction') == 1 or player:getData('faction') == 78 then
			if targetPlayerName and tonumber(time) and ... then
				if player:isWithinColShape(instance.region) and targetPlayer:isWithinColShape(instance.region) then
					if tonumber(time) <= 30 then
						player:outputChat('[!]#ffffff En az 30 dakika hapise atabilirsiniz.',100,100,255,true)
					else
						local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(player, targetPlayerName)
						local reason = table.concat({...}, " ")
						player:outputChat('[!]#ffffff '..getPlayerName(targetPlayer)..' isimli kişiyi '..time..' dakika hapise attınız. Gerekçe: '..reason..'',100,100,255,true)
						targetPlayer:outputChat('[!]#ffffff '..getPlayerName(player)..' isimli polis memuru tarafından '..time..' dakika hapise atıldınız. Gerekçe: '..reason..'',100,100,255,true)
						targetPlayer:setPosition(227.236328125, 111.2353515625, 999.015625)
						targetPlayer:setInterior(10)
						targetPlayer:setDimension(math.random(1,9999))
						targetPlayer:setData('hapis_sure', time)
						targetPlayer:setData('hapis_sebep', reason)
						dbExec(mysql:getConnection(), "UPDATE characters SET hapis_sure = '"..time.."', hapis_sebep = '"..reason.."'  WHERE id = " ..(targetPlayer:getData('dbid')))
					end
				else
					player:outputChat('[!]#ffffff Hapise atmak istediğiniz kişi veya siz gerekli alanda değilsiniz.',100,100,255,true)
				end
			else
				player:outputChat('[!]#ffffff /hapseat [ID] [Dakika] [Sebep]',100,100,255,true)
			end
		end
	end,

	unjail = function(player, cmd, targetPlayerName)
		if player:getData('faction') == 1 or player:getData('faction') == 78 then
			if targetPlayerName then
				local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(player, targetPlayerName)
				if targetPlayer:getData('hapis_sure') == 0 then
					player:outputChat('[!]#ffffff Çıkarmak istediğiniz kişi zaten hapiste değil.',100,100,255,true)
				else
					player:outputChat('[!]#ffffff '..getPlayerName(targetPlayer)..' isimli kişiyi hapisten çıkardınız.',100,100,255,true)
					targetPlayer:outputChat('[!]#ffffff '..getPlayerName(player)..' isimli polis memuru tarafından hapisden çıkartıldınız.',100,100,255,true)
					targetPlayer:setData('hapis_sure', tonumber(0))
					targetPlayer:setPosition(1803.0341796875, -1576.34375, 13.409018516541)
					targetPlayer:setInterior(0)
					targetPlayer:setDimension(0)
					dbExec(mysql:getConnection(), "UPDATE characters SET hapis_sure = '-1', hapis_sebep = '0'  WHERE id = " .. (targetPlayer:getData('dbid')))
				end
			else
				player:outputChat('[!]#ffffff /hapiscikar [ID]',100,100,255,true)
			end
		end
	end,

	timeInfo = function(player, cmd)
		if player:getData('loggedin') == 1 then
			if player:getData('hapis_sure') >= 1 then
				local time = player:getData('hapis_sure') or 0
				player:outputChat('[!]#ffffff Kalan Hapis Süreniz: '..time..' Dakika',100,100,255,true)
			end
		end
	end,

	_timer = function()
		for index, value in ipairs(exports.vrp_pool:getPoolElementsByType("player")) do
			if value:getData('loggedin') == 1 then
				local time = value:getData('hapis_sure') or 0
				if tonumber(time) >= 1 then
					if tonumber(time) == 1 then
						value:setData('hapis_sure', tonumber(0))
						value:setPosition(1803.0341796875, -1576.34375, 13.409018516541)
						value:setDimension(0)
						value:setInterior(0)
						value:outputChat('[!]#ffffff Hapis süreniz bitti.',100,100,255,true)
						dbExec(mysql:getConnection(), "UPDATE characters SET hapis_sure = '-1', hapis_sebep = '0'  WHERE id = "..(value:getData('dbid')))
					else
						value:setData('hapis_sure', time - tonumber(1))
						local newtime = value:getData('hapis_sure') or 0
						value:outputChat('[!]#ffffff Kalan Hapis Süreniz: '..newtime..' Dakika',100,100,255,true)
					end
				end
			end
		end
	end,

	index = function(self)
		self.pickup:setData('informationicon:information', '#3568CD/hapseat#ffffff\nLos Santos Police Department')
		addCommandHandler('hapseat',self.jail)
		addCommandHandler('hapiscikar', self.unjail)
		addCommandHandler('jailtime',self.timeInfo)
		setTimer(self._timer, 60000, 0)
	end,
	
}

instance = new(sPrison)
instance:index()