	local sX,sY = guiGetScreenSize()
	
local visible = true
	
local specList = {}
	
local gS = sY*0.25
local gY = sY*0.7
local gF = math.floor((gY-gS)/18)
	
local function drawSpectatorsList()
	if specList and (#specList >= 1) then
		if exports.vrp_integration:isPlayerTrialAdmin( localPlayer ) or exports.vrp_integration:isPlayerScripter(localPlayer) then
			dxDrawText("İzleyenler; ("..#specList.."):",1,gS+1,sX-14,1,tocolor(0,0,0,200),1,"default-bold","right")	
			dxDrawText("#13adadİzleyenler (#FFFFFF"..#specList.."#13ADAD):",0,gS,sX-15,0,tocolor(255,255,255,255),1,"default-bold","right","top",false,false,false,true)
			for k,v in ipairs(specList) do
				dxDrawText(specList[k]:gsub("#%x%x%x%x%x%x",""),1,gS+18*k+1,sX-14,1,tocolor(0,0,0,200),1,"default-bold","right")	
				dxDrawText(specList[k],0,gS+18*k,sX-15,0,tocolor(255,255,255,255),1,"default-bold","right","top",false,false,false,true)
				if (k == gF) then
					break;
				end
			end
		end
	end
end
addEventHandler("onClientRender",root,drawSpectatorsList)
	
bindKey("F2","down",
function()
	if visible then
		removeEventHandler("onClientRender",root,drawSpectatorsList)
		visible = false
	else
		addEventHandler("onClientRender",root,drawSpectatorsList)
		visible = true
	end
end)
	
addEvent("sendClientSpecList",true)
addEventHandler("sendClientSpecList",root,
function(arg1)
	specList = arg1
end)
