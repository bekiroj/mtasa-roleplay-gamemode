
-- @class Label Stats Instance
-- @author: foreigner26

Labels = {
    debug = false,
	adm = "",
	sup = "",
	reports = "",
    screen = Vector2(guiGetScreenSize()),

    date = function()
        x = getRealTime();
        x.year = x.year + 1900;
        x.month = x.month + 1;
        
            if (x.monthday < 10) then 
                monthday = '0'..x.monthday;
            else 
                monthday = x.monthday;
            end

            if (x.month < 10) then 
                month = '0'..x.month;
            else 
                month = x.month;
            end 

	return tostring(monthday..'/'..month..'/'..x.year)
    end,

    index = function(self)

        framesPerSecond = 0
        framesDeltaTime = 0
        lastRenderTick = false 

        label = GuiLabel(0,0,self.screen.x,15,'',false) 
        label:setAlpha(0.6)
        
        servers_label = GuiLabel(0,0,self.screen.x,15,'',false) 
        servers_label:setAlpha(0.6)
		
    end,
}

instance = new(Labels)
instance:index()



function bottomhufd () 
        local currentTick = getTickCount() 
            lastRenderTick = lastRenderTick or currentTick 
            framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick) 
            lastRenderTick = currentTick 
            framesPerSecond = framesPerSecond + 1
			framesPerSecond1 = framesPerSecond - 13
			framesPerSecond2 = framesPerSecond + 15
			
			if framesPerSecond2 >= 100 then
			framesPerSecond2 = framesPerSecond2 -10
			end
			
			if framesPerSecond1 >= 100 then
			framesPerSecond2 = framesPerSecond2 -20
			end
			
			if framesPerSecond < 10 then
			 framesPerSecond = framesPerSecond + 10
			 end
         
            if framesDeltaTime >= 1000 then 
                ping = localPlayer:getPing() 
                ping = ping - 45
                servers_label:setSize(instance.screen.x - guiLabelGetTextExtent(label) + 5,14,false)
                servers_label:setPosition(5, instance.screen.y - 15, false)
				
				
                if getResourceState(getResourceFromName("vrp_global")) == "running" and exports.integration:isPlayerStaff(localPlayer) and exports.global:isStaffOnDuty(localPlayer) then
				
					servers_label:setAlpha(0.6)
				else
					servers_label:setAlpha(0)
                end
                
				label:setText(framesPerSecond1..' Minimum FPS |'..framesPerSecond2..' Ortalama FPS | '..framesPerSecond..' FPS | '  ..ping.. 'ms | ')
                
                label:setSize(instance.screen.x - guiLabelGetTextExtent(label) + 5,14,false)
                label:setPosition(instance.screen.x - guiLabelGetTextExtent(label) - 90, instance.screen.y - 15, false)
                
                    framesDeltaTime = framesDeltaTime - 1000 
                    framesPerSecond = 0 
            end 
end
setTimer(bottomhufd, 0, 0)
