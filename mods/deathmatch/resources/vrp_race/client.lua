local sx , sy = guiGetScreenSize()

local timerText   = false
local markerTable = {}

addEvent("race:TimerUpdate" , true)
addEventHandler("race:TimerUpdate" , root , function(arg1)
    timerText = arg1
end)

addEventHandler("onClientRender" , root , function()
    if timerText then 
        dxSetBlendMode('add')
        dxDrawText(timerText , (sx) / 2, (sy-(sy-(sy/10))) / 2, 100, 100 , tocolor(255,48,48) , 3 , "pricedown")
        dxSetBlendMode('blend')
    end
end , true , "low-10")