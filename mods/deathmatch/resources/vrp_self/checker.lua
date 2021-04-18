Checker = {
    screen = Vector2(guiGetScreenSize()),

    index = function(self)
        if self.screen.x < 800 then 
        
        triggerServerEvent('checker:failed',root,localPlayer)
        elseif self.screen.y < 600 then    
        
        triggerServerEvent('checker:failed',root,localPlayer)
        end
    end,
}
Checker:index()