Async:setPriority('low')

squitLog = {

	reasons = {
		['Unknown'] = 'Bilinmiyor',
  		['Quit'] = 'kendi isteğiyle',
  		['Kicked'] = 'Atıldı',
  		['Banned'] = 'Uzaklaştırıldı',
  		['Bad Connection'] = 'Kötü İnternet',
  		['Timed out'] = 'İnternet Kesintisi',
	},

	getDistance = function(element, other)
		local x, y, z = getElementPosition(element)
		if isElement(element) and isElement(other) then
			return getDistanceBetweenPoints3D(x, y, z, getElementPosition(other))
		end
	end,

	_quit = function(type)
	squitLog = instance;
		for index, value in ipairs(getElementsByType('player')) do
			if instance.getDistance(source, v) <= 25 then
				local x,y,z = getElementPosition(source)
		        local time = getRealTime()
		        local hours = time.hour
		        local minutes = time.minute
		        local seconds = time.second
		        local monthday = time.monthday
		        local month = time.month
		        local year = time.year
				triggerClientEvent(v,'quitlog:add',v,getPlayerName(source),'',instance.reasons[type],math.ceil(getDistance(source, v)),getZoneName(x,y,z),string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds))
			end
		end
	end,

	index = function(self)
		addEventHandler("onPlayerQuit",root,self._quit)
	end,
}

instance = new(squitLog)
instance:index()