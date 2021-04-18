local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Sound = {};
Sound.__index = Sound;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Sound:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end


-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Sound:Constructor(sFilepath)
	-- Klassenvariablen --
	
	-- Wow, very Usefull this class is
	self.sound	= playSound(sFilepath, false)
	
	-- Methoden --
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] Sound: Constructor");
end

-- EVENT HANDLER --
