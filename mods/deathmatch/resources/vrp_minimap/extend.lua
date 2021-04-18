
Extend = {
	screen = Vector2(guiGetScreenSize()),
	show = false,
	size = {},
	scale = {},

	_define = function(self)
	self = Extend; 

		self.size.wh = Vector2(self.screen.x - 50,self.screen.y - 50)
		self.size.blip = 20

		self.scale.map = 1
		self.scale.arrow = 0.8
		self.scale.distance = Vector2(2.05,0.5)

		self.pos = Vector2(25,25)
		self.key = 'F11'
		
		self.x = 0
		self.y = 0

		self.texture = DxTexture("components/radar.jpg", "dxt5", true, "clamp", "3d")
		
		self.size.texture = Vector2(self.texture:getSize())

	return true
	end,

	_key = function(key,press)
	self = Extend; 

		if key == self.key and press and localPlayer:getData('loggedin') == 1 then 
			self.show = not self.show

			if not self.show then 
				removeEventHandler('onClientRender',root,self._render)
			else 
				addEventHandler('onClientRender',root,self._render)
			end
		end

		if key == 'mouse_wheel_up' and self.show then 
			if press then 

				if tonumber(self.scale.map) < 1.50 then 
					self.scale.map = self.scale.map + 0.025

					if self.scale.arrow ~= 0.8 then 
						self.scale.arrow = self.scale.arrow - 0.025
					end
				end
			end
		end
		
		if key == 'mouse_wheel_down' and self.show then 
			if press then 

				if tonumber(self.scale.map) > 0.50 then 
					self.scale.map = self.scale.map - 0.025

					if self.scale.arrow < 1 then
						self.scale.arrow = self.scale.arrow + 0.025
					end
				end
			end
		end

	end,

	_render = function()
	self = Extend;
	
		if localPlayer.dimension == 0 then 
			
			local sectionx = localPlayer.position.x / ( 6000 / self.size.texture.x ) + ( self.size.texture.y / 2 ) - ( self.size.wh.x / self.scale.map / 2 ) + 5
			local sectiony = localPlayer.position.y / (-6000 / self.size.texture.y ) + (self.size.texture.y / 2) - (self.size.wh.y / self.scale.map / 2 ) + 5
			local iunit = 3072 / 6000 * self.scale.map

			dxDrawRectangle(self.pos.x, self.pos.y, self.size.wh.x, self.size.wh.y, tocolor(0, 0, 0, 255*0.7))
			dxDrawImageSection(self.pos.x + 13 / 2 + 1, self.pos.y + 13 / 2, (self.size.wh.x - 13), (self.size.wh.y - 13), sectionx + self.x, sectiony + self.y, (self.size.wh.x - 13) / self.scale.map, (self.size.wh.y - 13) / self.scale.map, self.texture, 0, 0, 0, tocolor( 255, 255, 255, 255 ), false)						

			for i, v in ipairs(getElementsByType("blip")) do
				if v:getData("blip:maxVisible") then
					north = {}

						if (self.pos.y + 13 / 2 + (self.size.wh.y - 13)/2 + (localPlayer.position.y - v.position.y) * iunit) <= self.pos.y + 13/2 then
							north.y = self.pos.y + 13/2
						elseif (self.pos.y + 13/2 + (self.size.wh.y - 13)/2 + (localPlayer.position.y - v.position.y) * iunit) >= self.pos.y + 13/2 + (self.size.wh.y - 13 - 20) then
							north.y = self.pos.y + 13/2 + (self.size.wh.y - 13 - 20)
						else
							north.y = self.pos.y + 13/2 + (self.size.wh.y - 13)/2 + (localPlayer.position.y - v.position.y) * iunit  - self.size.blip / 2
						end

						if ((self.pos.x + 13/2 + (self.size.wh.x - 13)/2 + (v.position.x - localPlayer.position.x) * iunit) <= self.pos.x + 13 / 2) then
							north.x = self.pos.x + 13/2
						elseif ((self.pos.x + 13/2 + (self.size.wh.x - 13)/2 + (v.position.x - localPlayer.position.x) * iunit) >= self.pos.x + 13 / 2 + (self.size.wh.x - 13 - 20)) then
							north.x = self.pos.x + 13/2 + (self.size.wh.x - 13 - 20)
						else
							north.x = (self.pos.x + 13/2 + (self.size.wh.x - 13)/2 + (v.position.x - localPlayer.position.x) * iunit) - self.size.blip / 2
						end

					dxDrawImage(north.x, north.y, 16, 16, "components/blips/" .. v.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)
				
				else 
					distance = {
						min = {},
						max = {},
					}

					distance.min.h = (self.pos.y + 13 / 2 + (self.size.wh.y - 13) / 2 + (localPlayer.position.y - v.position.y) * iunit) > self.pos.y + 13 / 2
					distance.min.w = (self.pos.x + 13 / 2 + (self.size.wh.x - 13) / 2 + (v.position.x - localPlayer.position.x) * iunit) > self.pos.x + 13 / 2

					distance.max.h = (self.pos.y + 13 / 2 + (self.size.wh.y - 13) / 2 + (localPlayer.position.y - v.position.y) * iunit) < self.pos.y + 13 / 2 + (self.size.wh.y - 13 - 20)
					distance.max.w = (self.pos.x + 13 / 2 + (self.size.wh.x - 13) / 2 + (v.position.x - localPlayer.position.x) * iunit) < self.pos.x + 13 / 2 + (self.size.wh.x - 13 - 20)

					if distance.min.h and distance.min.w and distance.max.h and distance.max.w then 
						dxDrawImage(self.pos.x + 13/2 + (self.size.wh.x - 13)/2 + (v.position.x - localPlayer.position.x) * iunit - v.size / 2, self.pos.y + 13/2 + (self.size.wh.y - 13)/2 + (localPlayer.position.y - v.position.y) * iunit - v.size/2, 20, 20, "components/blips/" .. v.icon .. ".png", 0, 0, 0, tocolor(255, 255, 255, 255), false)				
					end
				end
			end

			dxDrawImage(self.pos.x + self.size.wh.x / 2 + 2 * iunit - (10 / self.scale.arrow) + self.scale.arrow, self.pos.y + self.size.wh.y / 2 + 0 * iunit - (10.5 / self.scale.arrow) + self.scale.arrow, 20, 20, "components/arrow.png", 360 - localPlayer.rotation.z, 0, 0, tocolor(255 ,255 ,255 ,255), false)
		end
	end,

	index = function(self)

		toggleControl("radar", false)
		
		if self:_define() then 

			addEventHandler('onClientKey',root,function(key,press) self._key(key,press) end)

			north = Blip(733.1318359375, 3700.951171875, -200, 4, 2, 255, 255, 255, 255)
			north:setOrdering(-2000)
			north:setData("blip:maxVisible", true)

			--Blip(1369.87927, -1365.45728, 13.56133, 44)
		end
	end,
}
addEventHandler ("onClientResourceStart", resourceRoot,function() Extend:index() end) 