
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
instance = new(DX)

function shadow(x,y,w,h,r,g,b,a,radius,fill)
    return instance:shadow(x,y,w,h,r,g,b,a,radius,fill)
end

function gradient(x,y,w,h,r,g,b,a,vertical,inverce)
   return instance:gradient(x,y,w,h,r,g,b,a,vertical,inverce)
end




