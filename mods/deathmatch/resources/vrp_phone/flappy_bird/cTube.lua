-- #######################################
-- ## Project: MTA FlappyBird			##
-- ## Name: Tube.lua					##
-- ## Author: Noneatme					##
-- ## Version: 1.0						##
-- ## License: See top Folder			##
-- #######################################

-- FUNCTIONS / METHODS --

local cFunc = {};		-- Local Functions 
local cSetting = {};	-- Local Settings

Tube = {};
Tube.__index = Tube;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Tube:New(...)
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

function Tube:Constructor(bDirection, iSX, iLength)
	-- Klassenvariablen --
	
	self.direction		= bDirection;	-- True: Oben , False: unten
	
	self.iSX			= iSX;
	
	self.iLength		= iLength;
	
	self.u				= 0;
	self.v				= 0;
	self.w				= 0;
	self.h				= 0;
	
	self.sizeX			= 52;
	self.sizeY			= 320;
	
	if(bDirection == true) then
		self.u				= 168; -- 112
		self.v				= 646;
		self.w				= 52;
		self.h				= 320;
	else
		self.u				= 112;
		self.v				= 646;
		self.w				= 52;
		self.h				= 320;
	end
	
	-- Methoden --
	
	
	
	-- Events --
	
	--logger:OutputInfo("[CALLING] Tube: Constructor");
end

-- EVENT HANDLER --
