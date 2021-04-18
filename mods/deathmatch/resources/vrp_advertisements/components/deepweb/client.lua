local advertPed = createPed(57, 2581.068359375, -1286.12890625, 1044.125, 180)
setElementInterior(advertPed, 2)
setElementDimension(advertPed, 2274)
setElementFrozen(advertPed, true)
addEventHandler("onClientClick", root, function(b, s, _, _, _, _, _, elem) if (b == "right" and s == "down" and elem and getElementType(elem) == "ped" and elem == advertPed) then deepAdverts(1)  end end)

function deepAdverts(step)
	if isElement(advertsStep1) or isElement(advertsStep2) then removeEventHandler("onClientGUIClick", root, clickHandlers) end
	if getElementData(localPlayer, "adminjailed") then
		outputChatBox("[-] #ffffffOOC Cezadayken bu özelliğe erişemezsin.", 255, 0, 0, true)
		return false
	end
	if (step == 1) then
		advertsStep1 = guiCreateWindow(0, 0, 437, 183, "Deep Web Paylaşım Arayüzü Kuralları", false)
		guiWindowSetSizable(advertsStep1, false)
		exports.vrp_global:centerWindow(advertsStep1)

		s1go = guiCreateButton(157, 135, 270, 34, ">> İlerle", false, advertsStep1)
		s1no = guiCreateButton(9, 135, 138, 34, "<< Kapat", false, advertsStep1)
		s1rules = guiCreateLabel(8, 29, 419, 20, "Kurallar:", false, advertsStep1)
		guiSetFont(s1rules, "clear-normal")
		guiLabelSetHorizontalAlign(s1rules, "center", false)
		s1rulestext = guiCreateLabel(8, 49, 419, 69, "- OOC paylaşım yapmak yasaktır.\n- İstediğiniz gibi il-legal satışı gerçekleştirebilirsiniz.\n- İlan arama paylaşımları yasaktır.\n- İçinde küfür, argo bulunan paylaşımlar yasaktır.", false, advertsStep1)
		guiLabelSetHorizontalAlign(s1rulestext, "center", false)
		guiSetInputEnabled(false)
	else
		advertsStep2 = guiCreateWindow(0, 0, 437, 183, "İl-Legal Paylaşım Arayüzü", false)
		guiWindowSetSizable(advertsStep2, false)
		exports.vrp_global:centerWindow(advertsStep2)

		s2go = guiCreateButton(157, 135, 270, 34, ">> İleri", false, advertsStep2)
		s2no = guiCreateButton(9, 135, 138, 34, "<< Geri", false, advertsStep2)
		s2edit = guiCreateEdit(9, 55, 418, 26, "", false, advertsStep2)
		s2label1 = guiCreateLabel(9, 19, 418, 36, "Paylaşım metnini girin:", false, advertsStep2)
		guiLabelSetHorizontalAlign(s2label1, "center", false)
		guiLabelSetVerticalAlign(s2label1, "center")
		s2label2 = guiCreateLabel(12, 87, 415, 29, "Kural ihlali sonucu yapılan reklamlarda otomatik olarak sistem tarafından\ncezalandırılacağımı onaylıyorum.", false, advertsStep2)
		guiLabelSetHorizontalAlign(s2label2, "center", false)
		guiSetInputEnabled(true)
	end
	addEventHandler("onClientGUIClick", root, clickHandlers)
end

function clickHandlers(b)
	if (b == "left") then
		if (source == s1go) then
			destroyElement(advertsStep1)
			deepAdverts(2)
		elseif (source == s2no) then
			destroyElement(advertsStep2)
			guiSetInputEnabled(false)
			deepAdverts(1)
		elseif (source == s1no) then
			destroyElement(advertsStep1)
			guiSetInputEnabled(false)
		elseif (source == s2go) then
			if (guiGetText(s2edit) ~= "") then
				triggerServerEvent("deepweb:receive", localPlayer, localPlayer, guiGetText(s2edit))
				destroyElement(advertsStep2)
				guiSetInputEnabled(false)
			end
		end
	end
end

addCommandHandler("deepweb",
	function(cmd)
		if (getElementData(localPlayer, "vip") >= 1) then
			deepAdverts(1)
		end
	end
)
