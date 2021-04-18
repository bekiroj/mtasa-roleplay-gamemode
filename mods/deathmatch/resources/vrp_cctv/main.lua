-- // bekiroj
sx, sy = guiGetScreenSize()
posX,posY = sx-370,30
font = dxCreateFont("components/fonts/Roboto.ttf", 10)
nextbt = guiCreateStaticImage(posX+260,posY+355, 30, 30, "components/img/next.png", false)
backbt = guiCreateStaticImage(posX+180,posY+355, 30, 30, "components/img/back.png", false)
camcount = 0
cctvlocation = "Unknown"

function nextCam(cam)
	nextLocation(cam)
	if cam == 0 then
		setCameraMatrix(1929.7922363281, -1738.6701660156, 23.292699813843, 1930.1812744141, -1739.5089111328, 22.911764144897) -- igs
	elseif cam == 1 then
		setCameraMatrix(2104.4860839844, -1819.6783447266, 17.845899581909, 2104, -1818.8521728516, 17.560821533203) -- pizza stack
	elseif cam == 2 then
		setCameraMatrix(1503.8500976563, -1620.4155273438, 34.390701293945, 1504.2943115234, -1621.2131347656, 33.98250579834) -- PD
	elseif cam == 3 then
		setCameraMatrix(1332.1098632813, -1367.7768554688, 20.461099624634, 1331.3596191406, -1368.3088378906, 20.068439483643) -- bank
	elseif cam == 4 then
		setCameraMatrix(1181.0299072266, -1341.9682617188, 17.987600326538, 1181.1824951172, -1341.0618896484, 17.593641281128) -- MD
	elseif cam == 5 then
		setCameraMatrix(1836.3731689453, -1318.5660400391, 20.100700378418, 1836.8768310547, -1319.3624267578, 19.765930175781) -- skate
	elseif cam == 6 then
		setCameraMatrix(2234.0607910156, -1635.8319091797, 20.857799530029, 2234.1801757813, -1636.7800292969, 20.563255310059) -- idlewood
	end
end

function nextLocation(id)
	if id == 0 then
		cctvlocation = "Petrol Ofisi"
	elseif id == 1 then
		cctvlocation = "Pizzacı"
	elseif id == 2 then
		cctvlocation = "Polis Departmanı"
	elseif id == 3 then
		cctvlocation = "Merkez Bankası"
	elseif id == 4 then
		cctvlocation = "Hastane"
	elseif id == 5 then
		cctvlocation = "Kaykay Parkı"
	elseif id == 6 then
		cctvlocation = "Kıyafetçi"
	end
end

function ShowBtns()
	guiSetVisible(nextbt, true)
	guiSetVisible(backbt, true)
end

function HideBtns()
	guiSetVisible(nextbt, false)
	guiSetVisible(backbt, false)
end

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 200);
		end
		if (not bgColor) then
			bgColor = borderColor;
		end
		dxDrawRectangle(x, y, w, h, bgColor, postGUI);
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI);
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI);
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI);
	end
end