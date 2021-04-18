local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

Flappy = {};
Flappy.__index = Flappy;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function Flappy:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// Calculate	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:Calculate()
	if(self.ready == true) then
		if(getTickCount()-self.startTick >= 1000) then
			self.startTick = getTickCount()
			self.FPS = self.tempFPS;
			self.tempFPS = 0;
		else
			self.tempFPS = self.tempFPS+1;
		end
	
		self.sy		= self.sy-self.velocityY

		self.velocityY	= self.velocityY-0.5/self.FPS*60
		
		if(self.velocityY < 1) then
			local rotAdd = (5/self.velocityY);

			if(rotAdd <= 0 or rotAdd > 1) then
				rotAdd = 2;
			end

			self.rotation = self.rotation+rotAdd;
		end

		if(self.rotation > 90) then
			self.rotation = 90;
		end

		if(self.sy >= (self.iSY-93)-self.sizeY) then
			self.sy = (self.iSY-93)-self.sizeY;

			self:Die("yes");
		end

		if(self.sy < -self.sizeY) then
			self.sy = -self.sizeY;
		end
	end
end

-- ///////////////////////////////
-- ///// Die		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:Die(uWat)
	if(self.dead == false) then

		self.dead = true;
		flappyBirdGame.moving = false;
		flappyBirdGame.flappyUI.deadmenuEnabled = true;

		Sound:New("flappy_bird/files/sounds/sfx_hit.ogg");
		if not(uWat) then
			setTimer(function() Sound:New("flappy_bird/files/sounds/sfx_die.ogg") end, 350, 1)
		end
	end
end

-- ///////////////////////////////
-- ///// Reset		 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:Reset()
	self.sx			= (self.iSX/2)-self.sizeX/2;
	self.sy			= (self.iSY/2)-self.sizeY/2;

	self.rotation	= 0;

	self.velocityY	= 0;

	self.dead		= false;
	self.ready 		= false;
end

function Flappy:IsBetweenX(gX)
	if((self.sx+self.sizeX) > gX) and (gX+self.sizeX > self.sx+self.sizeX-52) then
		return true
	end
	return false;
end

function Flappy:AddCoin()
	Sound:New("flappy_bird/files/sounds/sfx_point.ogg")
	
	flappyBirdGame.flappyUI.score = flappyBirdGame.flappyUI.score+1;
	
	if(flappyBirdGame.flappyUI.score > bestScore) then
		bestScore = flappyBirdGame.flappyUI.score;
	end
end

-- ///////////////////////////////
-- ///// GetCoinAdd	 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:CheckCoinAdd()
	if(getTickCount()-self.coinTick > 1000 and self.dead ~= true) then
		self.coinTick = getTickCount();
		self:AddCoin();
	end
end

-- ///////////////////////////////
-- ///// IsInRoehre 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:IsInRoehre(gX, iY1, iY2, checkPoint)
	if(checkPoint) then
		if(self:IsBetweenX(gX)) then
			self:CheckCoinAdd()
		end
	else
		if(self:IsBetweenX(gX)) and ((iY1-self.sizeY < self.sy) or ((iY2+320) > self.sy))then
			return true;
		end
	end
	return false;
end

-- ///////////////////////////////
-- ///// ClickFlappy 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:ClickFlappy()
	if(self.dead ~= true) then
		self.velocityY	= 7
		self.rotation 	= -30;

		if(self.ready == false) then
			self.ready = not(self.ready)
			flappyBirdGame.flappyUI.startmenuAEnabled = false;
		end

		Sound:New("flappy_bird/files/sounds/sfx_wing.ogg");
	else
		flappyBirdGame:Reset();
	end
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function Flappy:Constructor(iSX, iSY)
	-- Klassenvariablen --

	self.iSX		= iSX;
	self.iSY		= iSY;

	self.sizeX		= 34;
	self.sizeY		= 34;

	self.sx			= (iSX/2)-self.sizeX/2;
	self.sy			= (iSY/2)-self.sizeY/2;

	self.doCoinStart = false;

	self.lastY		= 0;
	self.rotation	= 0;

	self.velocityY	= 0;
	self.FPS		= 60;
	self.startTick = getTickCount();
	
	self.tempFPS	= 60;
	
		self.ready		= false;
	self.dead		= false;
	
	self.coinTick	= getTickCount();

	self.readyAlpha	= 255;

	-- Methoden --
	self.clickFlappyFunc	= function(...) self:ClickFlappy(...) end;


	bindKey("mouse1", "down", self.clickFlappyFunc)

	-- Events --

	--logger:OutputInfo("[CALLING] Flappy: Constructor");
end

-- EVENT HANDLER --
