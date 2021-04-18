--created with Jesse

local guiTable = {}
local guiRadiotable = {}
local tabTable = {}
local subtabs = {}
local mTable = {}
local labels = {}
local hoverColor = {77, 46, 139}
local sx, sy = guiGetScreenSize()
function openLibrary(typee,window)
    if typee == "convert" then
    	if window then		
            childWindow = window
            guiSetAlpha(childWindow,0)
    	    addEventHandler("onClientRender", root, guiRender)    

        end
    end
end
local font = dxCreateFont("files/1.ttf",10)
local fontbold = dxCreateFont("files/2.ttf",10)

local awesome = dxCreateFont("files/1.ttf",10)
function guiRender()
	if isElement(childWindow) then

        wname = guiGetText(childWindow)
        wx,wy = guiGetPosition(childWindow,false)
        ww,wh = guiGetSize(childWindow,false)


		dxDrawRectangle(wx,wy-5,ww,wh,tocolor(0,0,0,120))
        dxDrawRectangle(wx,wy-5,ww,20,tocolor(0,0,0,140))
        dxDrawRectangle(wx,wy+15,ww,1,tocolor(unpack(hoverColor)))
        dxDrawText(wname,wx,wy+1.2-5,ww+wx,wh+wy+1.2-5,tocolor(0,0,0),1,"default-bold","center","top")
        dxDrawText(wname,wx,wy+1.2-5,ww+wx,wh+wy+1.2-5,tocolor(255,255,255),1,"default-bold","center","top",false,false,false,true)

        tabpanel = getElementsByType("gui-tabpanel",childWindow)
        tab = getElementsByType("gui-tab",childWindow)
        _tabcount = 0
        for k,v in pairs(tab) do
        
        		_tabcount = _tabcount + 1 
        	
        end
        for k,v in pairs(getElementsByType("gui-button")) do
            if getElementData(v,"child") then
                guiSetAlpha(v,0)
                cx,cy = guiGetPosition(v,false)

                cw,ch = guiGetSize(v,false)
                ctext = guiGetText(v)
                
                if getElementData(v,"red") then
                    r,g,b = 231, 76, 60
                elseif getElementData(v,"green") then
                    r,g,b = 46, 204, 113
                else
                    r,g,b = unpack(hoverColor)
                end
                
                vData = {cx,cy,cw,ch,ctext,r,g,b}
                if guiGetEnabled(v) == true then
                    dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(vData[6],vData[7],vData[8],210))
                    if ishover(vData[1],vData[2],vData[3],vData[4]) then
                         dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(0,0,0,120)) 
                         dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                    else
                         dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                    end
                else
                     dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(90,90,90,130))
                    
                     dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                end
            end
        end
        
        if _tabcount ~= 0 then
        	data = 0
        	for ka,ve in pairs(tabpanel) do
    			cx,cy = guiGetPosition(ve,false)
        		cw,ch = guiGetSize(ve,false)
        		w1,w2 = guiGetPosition(childWindow,false)
        		cx,cy = cx+w1, cy+w2
        		ctext = guiGetText(ve)
        		
        		dxDrawRectangle(cx,cy+20,cw,ch-20,tocolor(10,10,10,120))
        		for k,v in pairs(tab) do
	        		texta = guiGetText(v)
	        		textWidth = dxGetTextWidth(texta,1,"default")
	        		
	        		if guiGetEnabled(v) == true then
		        		if guiGetSelectedTab(ve) == v then
		        			dxDrawRectangle(cx+data,cy,textWidth,20,tocolor(0,0,0,120))
		        			dxDrawRectangle(cx+data,cy+20,textWidth,1,tocolor(unpack(hoverColor)))
		        		else
		        			dxDrawRectangle(cx+data,cy,textWidth,20,tocolor(0,0,0,120))
		        		end
		        	else
		        		dxDrawRectangle(cx+data,cy,textWidth,20,tocolor(90,90,90,130))
		        	end
	        		dxDrawText(texta,cx+data,cy,textWidth+cx+data,20+cy,tocolor(255,255,255),0.9,"default","center","center")
	        		
	        		
	        		data = data + textWidth
	       	 	end
        	end

                
        	for k,v in pairs(getElementsByType("gui-button",childWindow)) do
                    cx,cy = guiGetPosition(v,false)

                    cw,ch = guiGetSize(v,false)
                    ctext = guiGetText(v)
                    
                    if getElementData(v,"red") then
                        r,g,b = 231, 76, 60
                    elseif getElementData(v,"green") then
                        r,g,b = 46, 204, 113
                    else
                        r,g,b = unpack(hoverColor)
                    end
                    
                    vData = {cx+wx,cy+wy,cw,ch,ctext,r,g,b}
                    if guiGetEnabled(v) == true then
                        dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(vData[6],vData[7],vData[8],210))
                        if ishover(vData[1],vData[2],vData[3],vData[4]) then
                             dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(0,0,0,120)) 
                             dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                        else
                             dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                        end
                    else
                         dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(90,90,90,130))
                        
                         dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                    end
                end


                for k,v in ipairs(getElementsByType("gui-edit",childWindow)) do
                         
                    ex,ey = guiGetPosition(v,false)
                    
                    ew,eh = guiGetSize(v,false)
                    etext = guiGetText(v)
                    

                    roundedRectangle(ex+wx,ey+wy,ew,eh,tocolor(0,0,0,140),tocolor(215,215,215))
                    dxDrawText(etext,ex+wx+3,ey+wy,ew,eh+ey+wy,tocolor(0,0,0),1,fontbold,"left","center")
                end

                
                for k,v in pairs(getElementsByType("gui-label",childWindow)) do    
                        lx,ly = guiGetPosition(v,false)
                        lw,lh = guiGetSize(v,false)
                        ltext = guiGetText(v)
                     dxDrawText(ltext,lx+wx,ly+wy,lw,lh,tocolor(255,255,255),1,"default","left","top")
                end
                

                for k,v in pairs(getElementsByType("gui-radiobutton",childWindow)) do
                    if guiRadioButtonGetSelected(v) then
                      icon = ""
                    else
                        icon = ""
                    end
                     rx,ry = guiGetPosition(v,false)

                    rw,rh = guiGetSize(v,false)
                    rtext = guiGetText(v)
                    dxDrawText(icon.." "..rtext,rx+wx+1,ry+wy,rw,rh,tocolor(255,255,255),1,awesome,"left","top")
                end
                for k,v in pairs(getElementsByType("gui-checkbox",childWindow)) do
                    if guiCheckBoxGetSelected(v) then
                        icon = ""
                    else
                        icon = ""
                    end
                     rx,ry = guiGetPosition(v,false)

                    rw,rh = guiGetSize(v,false)
                    rtext = guiGetText(v)
                    dxDrawText(icon.." "..rtext,rx+wx+1,ry+wy,rw,rh,tocolor(255,255,255),1,awesome,"left","top")
                end
                for k,v in pairs(getElementsByType("gui-scrollbar",childWindow)) do
                    rx,ry = guiGetPosition(v,false)
                    rw,rh = guiGetSize(v,false)
                    rvalue = guiScrollBarGetScrollPosition(v)
                    roundedRectangle(rx+wx,ry+wy,rw,rh,tocolor(0,0,0,140),tocolor(0,0,0,140))

                    roundedRectangle(rx+wx,ry+wy,rw*rvalue/100,rh,tocolor(228,113,255),tocolor(228,113,255))
                end


                 for k,v in ipairs(getElementsByType("gui-memo",childWindow)) do
                         
                    ex,ey = guiGetPosition(v,false)
                    
                    ew,eh = guiGetSize(v,false)
                    etext = guiGetText(v)
                    
                    roundedRectangle(ex+wx,ey+wy,ew,eh,tocolor(0,0,0,140),tocolor(0,0,0,140))
                    dxDrawText(etext,ex+wx+2,ey+wy+2,ew,eh,tocolor(255,255,255),1,"default","left","top")
			end
        else
                for k,v in pairs(getElementsByType("gui-button",childWindow)) do
                        cx,cy = guiGetPosition(v,false)

                        cw,ch = guiGetSize(v,false)
                        ctext = guiGetText(v)
                        
                        if getElementData(v,"red") then
                            r,g,b = 231, 76, 60
                        elseif getElementData(v,"green") then
                            r,g,b = 46, 204, 113
                        else
                            r,g,b = unpack(hoverColor)
                        end
                        
                        vData = {cx+wx,cy+wy,cw,ch,ctext,r,g,b}
                        if guiGetEnabled(v) == true then
                            dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(vData[6],vData[7],vData[8],210))
                            if ishover(vData[1],vData[2],vData[3],vData[4]) then
                                 dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(0,0,0,120)) 
                                 dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                            else
                                 dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                            end
                        else
                             dxDrawRectangle(vData[1],vData[2],vData[3],vData[4],tocolor(90,90,90,130))
                            
                             dxDrawText(vData[5],vData[1],vData[2],vData[3]+vData[1],vData[4]+vData[2],tocolor(255,255,255),1,awesome,"center","center")
                        end
                end

                
                for k,v in ipairs(getElementsByType("gui-edit",childWindow)) do
                         
                    ex,ey = guiGetPosition(v,false)
                    
                    ew,eh = guiGetSize(v,false)
                    etext = guiGetText(v)
                    

                    roundedRectangle(ex+wx,ey+wy,ew,eh,tocolor(0,0,0,140),tocolor(215,215,215))
                    dxDrawText(etext,ex+wx+3,ey+wy,ew,eh+ey+wy,tocolor(0,0,0),1,fontbold,"left","center")
                end

                
                for k,v in pairs(getElementsByType("gui-label",childWindow)) do    
                        lx,ly = guiGetPosition(v,false)
                        lw,lh = guiGetSize(v,false)
                        ltext = guiGetText(v)
                     dxDrawText(ltext,lx+wx,ly+wy,lw,lh,tocolor(255,255,255),1,"default","left","top")
                end
                

                for k,v in pairs(getElementsByType("gui-radiobutton",childWindow)) do
                    if guiRadioButtonGetSelected(v) then
                      icon = ""
                    else
                        icon = ""
                    end
                     rx,ry = guiGetPosition(v,false)

                    rw,rh = guiGetSize(v,false)
                    rtext = guiGetText(v)
                    dxDrawText(icon.." "..rtext,rx+wx+1,ry+wy,rw,rh,tocolor(255,255,255),1,awesome,"left","top")
                end
                for k,v in pairs(getElementsByType("gui-checkbox",childWindow)) do
                    if guiCheckBoxGetSelected(v) then
                        icon = ""
                    else
                        icon = ""
                    end
                     rx,ry = guiGetPosition(v,false)

                    rw,rh = guiGetSize(v,false)
                    rtext = guiGetText(v)
                    dxDrawText(icon.." "..rtext,rx+wx+1,ry+wy,rw,rh,tocolor(255,255,255),1,awesome,"left","top")
                end
                for k,v in pairs(getElementsByType("gui-scrollbar",childWindow)) do
                    rx,ry = guiGetPosition(v,false)
                    rw,rh = guiGetSize(v,false)
                    rvalue = guiScrollBarGetScrollPosition(v)
                    roundedRectangle(rx+wx,ry+wy,rw,rh,tocolor(0,0,0,140),tocolor(0,0,0,140))

                    roundedRectangle(rx+wx,ry+wy,rw*rvalue/100,rh,tocolor(228,113,255),tocolor(228,113,255))
                end


                 for k,v in ipairs(getElementsByType("gui-memo",childWindow)) do
                         
                    ex,ey = guiGetPosition(v,false)
                    
                    ew,eh = guiGetSize(v,false)
                    etext = guiGetText(v)
                    
                    roundedRectangle(ex+wx,ey+wy,ew,eh,tocolor(0,0,0,140),tocolor(0,0,0,140))
                    dxDrawText(etext,ex+wx+2,ey+wy+2,ew,eh,tocolor(255,255,255),1,"default","left","top")
			end
       	end
	else
		removeEventHandler("onClientRender", root, guiRender)
	end
end


function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		
		if (not bgColor) then
			bgColor = borderColor;
		end
		
		--> Background
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		
		--> Border
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI); -- top
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI); -- bottom
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI); -- left
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI); -- right
	end
end

function ishover(startX, startY, sizeX, sizeY)
	if isCursorShowing() then
		local cursorPosition = {getCursorPosition()}
		cursorPosition.x, cursorPosition.y = cursorPosition[1] * sx, cursorPosition[2] * sy

		if cursorPosition.x >= startX and cursorPosition.x <= startX + sizeX and cursorPosition.y >= startY and cursorPosition.y <= startY + sizeY then
			return true
		else
			return false
		end
	else
		return false
	end
end