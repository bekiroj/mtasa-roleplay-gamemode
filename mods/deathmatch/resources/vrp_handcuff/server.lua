addCommandHandler("kelepce",function(plr,cmd,target)
	if  plr:getTeam():getName() == "Los Santos Police Department" or plr:getTeam():getName() == "Los Santos County Sheriff's Department" then

		if not target then
			outputChatBox("Kullanım : /"..cmd.." <Oyuncu İD> Yazarak kelepçeleyebilirsiniz.",plr,255,194,14,true)
		return end

		local target, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(plr, target)
		
		if target then

			if getElementData(target, "kelepce") then
				kelepcele(target, "al")
				exports.vrp_global:sendLocalMeAction(plr, "Sağ ve sol eli ile şahsın bileğindeki kelepçeyi çözer.")
			return end

			exports.vrp_global:sendLocalMeAction(plr, "Sağ elini teçhizat kemerine atar ve bir kelepçe çıkarıp şahsın bileklerine geçirir.")
			kelepcele(target, "ver")
			plr:setAnimation("BD_FIRE", "wash_up", 1000, false, true, false, false)
		end
	end
end)

function engelle(source)
	if getElementData(source, "kelepce") then
		for i, v in ipairs(controls) do
			toggleControl(source, v, false)
		end	
		source:setAnimation("sword", "sword_block", 1000, false, true, false)
	end
end

addEventHandler ( 'onPlayerWeaponSwitch', getRootElement ( ),
	function ( previousWeaponID, currentWeaponID )
		if getElementData(source, "kelepce") then
			setPedWeaponSlot(source, 0)
		return end
	end
)