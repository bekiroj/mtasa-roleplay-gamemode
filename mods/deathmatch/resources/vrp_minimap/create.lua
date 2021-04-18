Minimap = {
	screen = Vector2(guiGetScreenSize()),
	Camera = getCamera(),

	distance = {min = 180,max = 100},
	velocity = {max = 1,min = 0.3},

	image = 3072 / 6000 * 0.8, 
	position = {x = 35,	y = 40},

	shader = {
		mask = DxShader("hud_mask.fx"),
	},

	textures = {
		radar = DxTexture("components/radar.jpg","dxt5", true, "wrap"),
		mask = DxTexture("components/mask.png"),
    },
    
        streetname = function(self)
            if not self.label then 
               
            	self.label = GuiLabel(self.position.x, (self.screen.y - (self.position.y + self.size)) + self.size + 8, self.size + 10, 50, '', false, false)
        
            	self.label:setFont(GuiFont('components/font.ttf',9))
		    	self.label:setAlpha(0.67)
               	guiLabelSetHorizontalAlign(self.label,"center")
            
            return true 
            end
        end,

		_radius = function(self)
			if not localPlayer.vehicle then return self.distance.min end 
			
			if localPlayer.vehicle.vehicleType == "Plane" then
				return self.distance.max
			end

                local speed = localPlayer.vehicle.velocity.length;
                
					if tonumber(speed) <= self.velocity.min then
                    
					return self.distance.min
					elseif speed >= self.velocity.max then 

					return self.distance.max
					end
					
					local stream = speed - self.velocity.min;
						stream = stream * ((self.distance.max - self.distance.min) / (self.velocity.max - self.velocity.min));
						stream = stream + self.distance.min;
						
				return math.ceil(stream)
		end,

		_check = function(self)
			if (localPlayer.interior == 0 and Extend.show == false and localPlayer:getData('loggedin') == 1) then 

			return true
			else 

			self.label:setText('')	
			return false 
			end
		end,	

		_render = function()
		self = Minimap;

			if self:_check() then 
				
				--[[ Set Shader Values ]]--
				self.shader.mask:setValue("gUVPosition",((localPlayer.position.x) / 6000),((localPlayer.position.y) / -6000))
				self.shader.mask:setValue("sMaskTexture",self.textures.mask)

                --[[ Set Zoom ]]--
				local zoom = tonumber(self:_radius()) / 20
					self.shader.mask:setValue("gUVScale", 1 / zoom, 1 / zoom)
					self.shader.mask:setValue("gUVRotAngle",0)
					self.shader.mask:setValue("gUVRotCenter",0,0)

				--dxSetAspectRatioAdjustmentEnabled( true,(16/9))
				dxDrawImage(self.position.x - 8, self.screen.y - (self.position.y + self.size) - 8,self.size + 16, self.size + 16,"components/mask.png",Camera.rotation.z,0,0,tocolor(255,255,255,255))
                dxDrawImage(self.position.x + self.size / 2 + (localPlayer.rotation.x - localPlayer.rotation.x) * self.image - (7.5 + 1.25) - self.image  /2, self.screen.y - (self.position.y + self.size) + self.size / 2 + (localPlayer.rotation.y - localPlayer.rotation.y) * self.image - (7.5 + 1.25)  - self.image / 2, 17.5, 17.5, "components/arrow.png", Camera.rotation.z - localPlayer.rotation.z,0,0, tocolor(255, 255, 255, 210), true)
				dxDrawImage(self.position.x,self.screen.y - (self.position.y + self.size), self.size, self.size, self.shader.mask, Camera.rotation.z,0,0, tocolor(255,255,255,190))
				self.label:setText(getZoneName(localPlayer.position.x,localPlayer.position.y,localPlayer.position.z))
					
				for i, v in ipairs(getElementsByType("blip")) do

				end
            end
		end,


		index = function(self)
			self.size = self.screen.x * 0.120

			if not self.textures.radar and self.textures.mask and self.shader.mask then 
				outputDebugString('[MINIMAP-INFO] Minimap oluşturulamadı',0,240,240,240)
			
            else 
				toggleControl('radar',true)
				self.shader.mask:setValue('sPicTexture',self.textures.radar)
                self.shader.mask:setValue('sMaskTexture',self.textures.mask)
                
                self:streetname()
                addEventHandler('onClientRender',root,self._render,true,"low-10")
			end

		end,
}

Minimap:index()