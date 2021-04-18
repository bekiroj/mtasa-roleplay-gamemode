addEvent("wage.sound", true)
addEventHandler("wage.sound", getRootElement(),
	function()
		local random = math.random(1,3)
		local sound = playSound("components/"..random..".mp3")   
		setSoundVolume(sound, 1)
	end
)