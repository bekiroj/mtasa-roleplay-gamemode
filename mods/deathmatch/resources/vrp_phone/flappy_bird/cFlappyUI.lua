local cFunc = {};		-- Local Functions
local cSetting = {};	-- Local Settings

FlappyUI = {};
FlappyUI.__index = FlappyUI;

bestScore			= 0;

--[[

]]

-- ///////////////////////////////
-- ///// New 				//////
-- ///// Returns: Object	//////
-- ///////////////////////////////

function FlappyUI:New(...)
	local obj = setmetatable({}, {__index = self});
	if obj.Constructor then
		obj:Constructor(...);
	end
	return obj;
end

-- ///////////////////////////////
-- ///// RenderStartMenu	//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FlappyUI:RenderStartMenu()
	if(self.startmenuEnabled ~= false) then
		local u, v, w, h = 587, 115, 191, 55;

		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-170, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.startmenuAlpha))

		u, v, w, h = 583, 179, 114, 104;

		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-120, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.startmenuAlpha))

		if(self.startmenuAEnabled == false) then
			if(self.startmenuAlpha > 10) then
				self.startmenuAlpha = self.startmenuAlpha-10
			else
				self.startmenuEnabled = false;
			end
		end
	end
end

-- ///////////////////////////////
-- ///// RenderDeadMenu		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FlappyUI:RenderDeadMenu()
	if(self.deadmenuEnabled == true) then
		local u, v, w, h = 788, 116, 196, 53

		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-180, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.deadmenuAlpha))

		u, v, w, h = 6, 518, 226, 114

		dxDrawImageSection((self.iSX/2)-w/2, ((self.iSY/2)+h/2)-130, w, h, u, v, w, h, self.imageTexture, 0, 0, 0, tocolor(255, 255, 255, self.deadmenuAlpha))


		dxDrawText(self.score, (self.iSX/2)+115, ((self.iSY/2)+50/2)+115, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 1, "pricedown", "center", "center")

		dxDrawText(bestScore, (self.iSX/2)+135, ((self.iSY/2)+50/2)+210, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 1, "pricedown", "center", "center")


		if(self.deadmenuAlpha < 240) then
			self.deadmenuAlpha = self.deadmenuAlpha+10;
		end
	end
end

-- ///////////////////////////////
-- ///// RenderScore		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FlappyUI:RenderScore()
	if(self.renderScore == true) then
		local u, v, w, h = 788, 116, 196, 53

		dxDrawText(self.score, (self.iSX/2)+5, ((self.iSY/2)+50/2)-175, 150, 50, tocolor(0, 0, 0, self.renderScoreAlpha), 2, "pricedown", "center", "center")
		dxDrawText(self.score, (self.iSX/2), ((self.iSY/2)+50/2)-180, 150, 50, tocolor(255, 255, 255, self.renderScoreAlpha), 2, "pricedown", "center", "center")


		if(self.renderScoreAlpha < 240) then
			self.renderScoreAlpha = self.renderScoreAlpha+10;

		end
	end
end

-- ///////////////////////////////
-- ///// Reset	 			//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FlappyUI:Reset()
	self.startmenuEnabled	= true;
	self.startmenuAEnabled	= true;
	self.startmenuAlpha		= 255;

	self.deadmenuEnabled 	= false;
	self.deadmenuAlpha		= 0;

	self.renderScore		= true;
	self.renderScoreAlpha	= 0;

	self.score				= 0;
end

-- ///////////////////////////////
-- ///// Constructor 		//////
-- ///// Returns: void		//////
-- ///////////////////////////////

function FlappyUI:Constructor(iSX, iSY, imageTexture)
	-- Klassenvariablen --

	self.iSX		= iSX;
	self.iSY		= iSY;

	-- Methoden --

	self.imageTexture		= imageTexture;
	self.startmenuAlpha		= 255;
	self.startmenuEnabled	= true;
	self.startmenuAEnabled	= true;

	self.deadmenuEnabled	= false;
	self.deadmenuAlpha		= 0;

	self.renderScore		= true;
	self.renderScoreAlpha	= 0;

	self.score				= 0;

-- Events --


--logger:OutputInfo("[CALLING] FlappyUI: Constructor");
end

-- EVENT HANDLER --
