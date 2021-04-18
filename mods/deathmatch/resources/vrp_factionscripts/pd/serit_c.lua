--[[
* ***********************************************************************************************************************
* Copyright (c) 2018 Arena Roleplay - All Rights Reserved
* Written by Enes Ep aka Dumper <dumper.scripter@gmail.com>, 23.01.2018
* ***********************************************************************************************************************
]]
SERIT_EDIT = {}
SERITLER = {}

EDIT = false
sX,sY,sZ = 0,0,0
p = localPlayer
local EID

local texture = dxCreateTexture( "pd/policeline.png", "argb", true,"clamp")

function seritDrawer()
	---
	if EDIT then
		local len = uzaklik(sX,sY,sZ,getElementPosition(p))
		if len >= 1.7 then
			local x,y,z = getElementPosition(p)
			table.insert(SERIT_EDIT,{x1=sX,y1=sY,z1=sZ,x2=x,y2=y,z2=z})
			sX,sY,sZ = getElementPosition(p)
		end
		for i,v in pairs(SERIT_EDIT) do
			dxDrawMaterialLine3D ( v.x1, v.y1, v.z1, v.x2, v.y2, v.z2, texture, 0.15, tocolor(255,255,255), 0,0,0 )
		end
	end
	for i,a in pairs(SERITLER) do
		for i1,b in pairs(a) do
			for i2,v in pairs(b) do
				dxDrawMaterialLine3D ( v.x1, v.y1, v.z1, v.x2, v.y2, v.z2, texture, 0.15, tocolor(255,255,255), 0,0,0 )
			end
		end
	end	
end
addEventHandler("onClientRender",getRootElement(  ),seritDrawer)

function uzaklik(x1,y1,z1,x2,y2,z2)
	return math.sqrt((x2-x1)^2 + (y2-y1)^2 + (z2-z1)^2)
end

function openSeritMode(enable,id)
	EDIT = enable
	if not enable and SERIT_EDIT then
		triggerServerEvent("serit.sendToServer",p,EID,SERIT_EDIT)
		SERIT_EDIT = {}
	end
	EID = id
	sX,sY,sZ = getElementPosition(p)
end
addEvent("serit.openSeritModeClient",true)
addEventHandler("serit.openSeritModeClient",root,openSeritMode)

function loadSerits(data)
	SERITLER = data
end

addEvent("serit.loadSerits",true)
addEventHandler("serit.loadSerits",root,loadSerits)