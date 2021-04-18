dxDrawText = dxDrawText
dxDrawRectangle = dxDrawRectangle
dxDrawImage = dxDrawImage

function bindSomeHotKey()
	bindKey("z", "down", function()
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('realism:seatbelt:toggle', localPlayer, localPlayer)
	end) 

	bindKey("x", "down", function() 
		if getElementData(localPlayer, "vehicle_hotkey") == "0" then 
			return false
		end
		triggerServerEvent('vehicle:togWindow', localPlayer)
	end)
end
addEventHandler("onClientResourceStart", resourceRoot, bindSomeHotKey)

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "area_name", "vehicle_name", "radio", "wanted", "radar" }
addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
end)

SAMP = {
    screen = Vector2(guiGetScreenSize()),
    extraY = -1,
    moneyY = 0,
    opened_1 = false,
	opened_2 = false,
    opened_3 = false,
    font = exports.vrp_fonts:getFont("RobotoB", 10),
    show = true,

    dxDrawShadowText = function(self,text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
        dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 - 2, y1, x2 - 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 - 2, x2, y2 - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
        dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
    end,

    drawhealth = function(instance)
    SAMP = instance

        local health = localPlayer:getHealth()
        local max_health = localPlayer:getStat(24)
        local max_health = (((max_health-569)/(1000-569))*100)+100
        local health_stat = health/max_health
        
        
        local dX,dY,dW,dH = instance.screen.x - 150,0 + 55,150,15
        local dX,dY,dW,dH = instance.screen.x - 150 - instance.zone.x, dY + instance.zone.y + 65, dW, dH
        dxDrawRectangle( dX + 100 - 110,dY + instance.extraY,dW - 10,dH, tocolor(0,0,0,255) )

        local dX,dY,dW,dH = instance.screen.x - 147,3 + 55,144,9
        local dX,dY,dW,dH = instance.screen.x - 147 - instance.zone.x, dY + instance.zone.y + 65, dW, dH
        dxDrawRectangle( dX + 100 - 110, dY + instance.extraY,dW - 10, dH, tocolor(200,20,20,150) )
        dxDrawRectangle( dX + 100 - 110 + dW - (health_stat * dW),dY + instance.extraY, health_stat * dW - 10, dH, tocolor(200,20,20,200) )

    end,

    drawarmor = function(instance)
    SAMP = instance
        local armor = localPlayer:getArmor()
        if armor > 7 then
	        local max_armor = localPlayer:getStat(24)
	        local max_armor = (((max_armor-569)/(1000-569))*100)+100
	        local armor_stat = armor/max_armor
	        
	        
	        local dX,dY,dW,dH = instance.screen.x - 150,0 + 55,150,15
	        local dX,dY,dW,dH = instance.screen.x - 150 - instance.zone.x, dY + instance.zone.y + 48, dW, dH
	        dxDrawRectangle( dX + 100 - 110,dY + instance.extraY,dW - 10,dH, tocolor(0,0,0,255) )

	        local dX,dY,dW,dH = instance.screen.x - 147,3 + 55,144,9
	        local dX,dY,dW,dH = instance.screen.x - 147 - instance.zone.x, dY + instance.zone.y + 48, dW, dH
	        dxDrawRectangle( dX + 100 - 110, dY + instance.extraY,dW - 10, dH, tocolor(150,150,150,150) )
	        dxDrawRectangle( dX + 100 - 110 + dW - (armor_stat * dW),dY + instance.extraY, armor_stat * dW - 10, dH, tocolor(150,150,150,200) )
	    end
    end,

    drawmoney = function(instance)
        local cash = '$'..string.format("%013d", localPlayer:getData('money'))..''
        local dX,dY,dW,dH = instance.screen.x - 6, 105 + instance.moneyY,instance.screen.x - 6, 30
        local dX,dY,dW,dH = dX - instance.zone.x, dY + instance.zone.y, dW - instance.zone.x, dH + instance.zone.y
        
        instance:dxDrawShadowText(cash, dX - 245,dY,dW + 6 - 111,dH, tocolor(57,85,50,255), 1.30, "pricedown")
    end,

    drawhunger = function(self)
        local thirst = localPlayer:getData('hunger')
        
            
        local dX,dY,dW,dH = self.screen.x - 38, self.screen.y - 115,self.screen.x - 38, self.screen.y - 115
        local dX,dY,dW,dH = dX - self.zone.x, dY + self.zone.y, dW - self.zone.x, dH + self.zone.y
        
        self:dxDrawShadowText(math.floor(thirst)..'%', dX ,dY,dW ,dH, tocolor(240,204,90,255), 1, "pricedown", "right")
    end,

    drawthirst = function(self)
        local thirst = localPlayer:getData('thirst')
        
            
        local dX,dY,dW,dH = self.screen.x - 38, self.screen.y - 72,self.screen.x - 38, self.screen.y - 72
        local dX,dY,dW,dH = dX - self.zone.x, dY + self.zone.y, dW - self.zone.x, dH + self.zone.y
        
        instance:dxDrawShadowText(math.floor(thirst)..'%', dX ,dY,dW ,dH, tocolor(248,88,125,255), 1, "pricedown", "right")

        local img = "components/images/hud.png"
        local dX,dY,dW,dH = self.screen.x - 30, self.screen.y - 83 - 45,45,90
        local dX,dY,dW,dH = dX-self.zone.x, dY+self.zone.y, dW, dH
        dxDrawImage(dX, dY, dW, dH, img,0,0,0,tocolor(245,245,245,240))
    end,

    _render = function()
    SAMP = instance 
	    if localPlayer:getData('loggedin') == 1 then
	    	if instance.show then
		        local weapon = localPlayer:getWeapon()
		        local clip = localPlayer:getAmmoInClip()
		        local ammo = localPlayer:getTotalAmmo()
		        instance.moneyY = 13
		        instance.extraY = -15
		            
		        local len = #tostring(clip)
		        if string.find(tostring(clip), 1) then len = len - 0.5 end
		        local xoff = (len*17)
		        
		        local len2 = #tostring(ammo-clip)
		        if string.find(tostring(ammo-clip), 1) then len2 = len2 - 0.5 end
		    
		        local img = "components/weapon/"..weapon..".png"
		        local logo = "components/images/logo.png"
		        local dX,dY,dW,dH = instance.screen.x - 260,35,95,95
		        local dX,dY,dW,dH = dX-instance.zone.x, dY+instance.zone.y, dW, dH
		        dxDrawImage(dX, dY, dW, dH, img)	
		        dxDrawImage(dX- 50, dY + 60, dW-50, dH-50, logo)	
		        
		        if (weapon >= 15 and weapon ~= 40 and weapon <= 44 or weapon >= 46) then
		            local dX,dY,dW,dH = instance.screen.x-6-xoff,35,instance.screen.x-6-xoff,30
		            local dX,dY,dW,dH = dX-instance.zone.x, dY+instance.zone.y, dW-instance.zone.x, dH+instance.zone.y
		            instance:dxDrawShadowText(''..ammo-clip..'/'..clip..'', dX - 185,dY + 70,dW - 105,dH + 10, tocolor(220,220,220,255), 1, instance.font)
		        end	

		        instance:drawmoney()
		        instance:drawhealth()
		        instance:drawarmor()
		        instance:drawthirst()
		        instance:drawhunger()
		    end
		end
    end,

    _close = function()
    	if localPlayer:getData('loggedin') == 1 then
    		if instance.show then
    			instance.show = false
    		else
    			instance.show = true
    		end
    	end
   	end,

    index = function(self)
        self.zone = Vector2(self.screen.x * 0.03, self.screen.y * 0.01)
        setTimer(self._render,7,0)
        addCommandHandler('hud',self._close)
    end,

}
instance = SAMP
instance:index()