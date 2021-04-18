local mysql = exports.vrp_mysql

function arabarenk1 (hitElement, renkler1,renkler2,renkler3,renkler4,renkler5,renkler6)
local orjRenkler1, orjRenkler2, orjRenkler3, orjRenkler4, orjRenkler5, orjRenkler6, orjRenkler7, orjRenkler8, orjRenkler9, orjRenkler10, orjRenkler11, orjRenkler12 = getVehicleColor(hitElement, true)
local dbid = getElementData(hitElement, "dbid")	
	count = 0
	if count < 100 then
		count = count + 1
	    local yenirenk1		= (1 - (count/100)) * orjRenkler1 + (count/100) * renkler1
		local yenirenk2		= (1 - (count/100)) * orjRenkler2 + (count/100) * renkler2
		local yenirenk3		= (1 - (count/100)) * orjRenkler3 + (count/100) * renkler3
		setVehicleColor( hitElement, yenirenk1, yenirenk2, yenirenk3, orjRenkler4, orjRenkler5, orjRenkler6, newColor7, newColor8, newColor9, newColor10, newColor11, newColor12)
		dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `color1`='[ [ "..yenirenk1..", "..yenirenk2..", "..yenirenk3.." ] ]' WHERE `id`='" .. dbid .."'")  
  end
end
addEvent("arabarenk1", true)
addEventHandler("arabarenk1", root, arabarenk1)

function arabarenk2 (hitElement,renkler4, renkler5, renkler6 )
local orjRenkler1, orjRenkler2, orjRenkler3, orjRenkler4, orjRenkler5, orjRenkler6, orjRenkler7, orjRenkler8, orjRenkler9, orjRenkler10, orjRenkler11, orjRenkler12 = getVehicleColor(hitElement, true)
local dbid = getElementData(hitElement, "dbid")		
	count = 0
	if count < 100 then
		count = count + 1
		local yenirenk4		= (1 - (count/100)) * orjRenkler4 + (count/100) * renkler4
		local yenirenk5		= (1 - (count/100)) * orjRenkler5 + (count/100) * renkler5
		local yenirenk6		= (1 - (count/100)) * orjRenkler6 + (count/100) * renkler6
		setVehicleColor( hitElement, orjRenkler1, orjRenkler2, orjRenkler3, yenirenk4, yenirenk5, yenirenk6, newColor7, newColor8, newColor9, newColor10, newColor11, newColor12)
        dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `color1`='[ [ "..yenirenk4..", "..yenirenk5..", "..yenirenk6.." ] ]' WHERE `id`='" .. dbid .."'") 
	end
end
addEvent("arabarenk2", true)
addEventHandler("arabarenk2", root, arabarenk2)


function farrenk (hitElement ,renkler7,renkler8,renkler9)
local dbid = getElementData(hitElement, "dbid")		
	setVehicleHeadLightColor(hitElement, renkler7, renkler8, renkler9)
		dbExec(mysql:getConnection(), "UPDATE `vehicles` SET `headlights`='[ [ "..renkler7..", "..renkler8..", "..renkler9.." ] ]' WHERE `id`='" .. dbid .."'")  
end
addEvent("farrenk", true)
addEventHandler("farrenk", root, farrenk)


