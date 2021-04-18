addEventHandler("onClientRender", root,
    function()
    	if getElementData(localPlayer, "cctv") then
        	roundedRectangle(posX+111,posY+200, 248, 50, tocolor(20,20,20), false)
        	dxDrawRectangle(posX+110,posY+245, 250, 150, tocolor(10,10,10), false)
        	dxDrawText("CCTV Arayüzü", posX+192,posY+215, 1062, 129, tocolor(200,200,200),1, font, "left", "top", false, false, false, false, false)
        	dxDrawText("CCTV Bölge : "..cctvlocation.."", posX+140,posY+260, 1062, 129, tocolor(150,150,150,200),1, font, "left", "top", false, false, false, false, false)
        	dxDrawText("CCTV ID : "..camcount.."", posX+140,posY+285, 1062, 129, tocolor(150,150,150,200),1, font, "left", "top", false, false, false, false, false)
        	dxDrawText("Ok Tuşları İle Geçiş Yapabilirsiniz.", posX+140,posY+310, 1062, 129, tocolor(132,226,50,200),1, font, "left", "top", false, false, false, false, false)
        end
    end
)

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		HideBtns()
	end
)

addEvent("ShowBtns", true)
addEventHandler("ShowBtns",root,
	function()
		camcount = 0
		ShowBtns()
		local cam = camcount
		nextCam(cam)
	end
)

addEvent("HideBtns", true)
addEventHandler("HideBtns",root,
	function()
		HideBtns()
	end
)

addEventHandler("onClientGUIClick",root,function()
	if source == nextbt then
		camcount = camcount + 1
		if camcount == 7 then
			camcount = 0
		end
		nextCam(camcount)
	elseif source == backbt then
		camcount = camcount - 1
		if camcount == -1 then
			camcount = 6
		end
		nextCam(camcount)
	end
end)

addEventHandler( "onClientMouseEnter", resourceRoot, 
	function()
		if source == nextbt then
			guiStaticImageLoadImage ( source, "components/img/nexthover.png" )
		elseif source == backbt then
			guiStaticImageLoadImage ( source, "components/img/backhover.png" )
		end
	end
)

addEventHandler( "onClientMouseLeave", resourceRoot, 
	function()
		if source == nextbt then
			guiStaticImageLoadImage ( source, "components/img/next.png" )
		elseif source == backbt then
			guiStaticImageLoadImage ( source, "components/img/back.png" )
		end
	end
)
