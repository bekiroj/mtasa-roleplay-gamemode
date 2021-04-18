function loadFonts()
    fonts = {
        [1] = DxFont("fonts/rbold.ttf", 11),
        [2] = DxFont("fonts/rregular.ttf", 9),
        [3] = DxFont(":vrp_fonts/files/RobotoL.ttf", 12),
        [4] = DxFont(":vrp_fonts/files/RobotoL.ttf", 10),
        [5] = DxFont(":vrp_fonts/files/RobotoL.ttf", 9),
        [6] = DxFont(":vrp_fonts/files/RobotoL.ttf", 6),
        [7] = GuiFont(":vrp_fonts/files/RobotoL.ttf", 10),
        [8] = DxFont(":vrp_fonts/files/RobotoL.ttf", 8.4),
        [9] = DxFont(":vrp_fonts/files/FontAwesome5.ttf", 10),
        [10] = DxFont(":vrp_fonts/files/FontAwesome.ttf", 7),
        [11] = DxFont(":vrp_fonts/files/Roboto-Regular.ttf", 10),
        [12] = DxFont(":vrp_fonts/files/RobotoB.ttf", 10),
        [13] = DxFont(":vrp_fonts/files/FontAwesome.ttf", 10),
    }
end

addEventHandler("onClientResourceStart", root,
    function(startedRes)
        if getResourceName(startedRes) == "fonts" then
            loadFonts()
        end
    end
)

addEventHandler("onAssetsLoaded", root,
    function()
        loadFonts()
    end
)

loadFonts()

appColors = {
    ['instagram'] = {63, 114, 155},
    ['twitter'] = {0, 168, 255},
	['police'] = {52, 152, 219}
}

sx, sy = guiGetScreenSize()
contactList = {}
phone = nil
stopTimer = {}
w,h = 265,552
margin = 10
xoffset = w + margin
posX, posY = sx-w-margin+xoffset, sy/2-h/2
curX, curY = posX, posY
slidingSpeed = 20
contactListLimit = {}
curEditPhoneNumber = ""
renderedDX = false
phoneSetupState = false
alpha = {}
custom_apps = {}

function isInSlot(xS, yS, wS, hS)
	if(isCursorShowing()) then
		local cursorX, cursorY = getCursorPosition()
		cursorX, cursorY = cursorX*sx, cursorY*sy
		if(cursorX >= xS and cursorX <= xS+wS and cursorY >= yS and cursorY <= yS+hS) then
			return true
		else
			return false
		end
	end	
end


DX = {
    gradient = function(self,x,y,w,h,r,g,b,a,vertical,inverce)
        if(vertical == true)then
            for i=0,h do
                if inverce == false then
                    dxDrawRectangle(x, y+i, w, 1,tocolor(r,g,b,i/h*a or 255));
                else
                    dxDrawRectangle(x, y+h-i, w, 1,tocolor(r,g,b,i/h*a or 255)); 
                end
            end
        else
            for i=0,w do
                if inverce == false then
                    dxDrawRectangle(x+i, y, 1, h,tocolor(r,g,b,i/w*a or 255));
                else
                    dxDrawRectangle(x+w-i, y, 1, h,tocolor(r,g,b,i/w*a or 255)); 
                end
            end
        end
    end,

    shadow = function(self,x,y,w,h,r,g,b,a,radius,fill)
        self:gradient(x, y-radius, w,radius,r,g,b,a,true,false)
        self:gradient(x-radius, y, radius,h,r,g,b,a,false,false)
        self:gradient(x+w, y, radius,h,r,g,b,a,false,true)
        self:gradient(x, y+h, w,radius,r,g,b,a,true,true)
    
        dxDrawCircle(x, y, radius, 180, 270, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)
        dxDrawCircle(x+w, y+h, radius, 0, 90, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)
        dxDrawCircle(x+w, y, radius, 270, 360, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)
        dxDrawCircle(x, y+h, radius, 90, 180, tocolor(r,g,b,0),tocolor(r,g,b,a), radius)

        if(fill and fill == true)then
            dxDrawRectangle(x+1,y+1,w-1,h-1, tocolor(0,0,0,200))
        end
    end,
}
function shadow(x,y,w,h,r,g,b,a,radius,fill)
    return DX:shadow(x,y,w,h,r,g,b,a,radius,fill)
end

function gradient(x,y,w,h,r,g,b,a,vertical,inverce)
   return DX:gradient(x,y,w,h,r,g,b,a,vertical,inverce)
end