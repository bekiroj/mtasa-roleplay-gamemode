local anims_list = {
	--index = src, replacable
	['watchdogs'] = {'custom/watchdogs.ifp', true, price = 10, name = "Watch Dogs Animasyon Fiziği", engine = 1, disabled = 0},
	['gta4'] = {'custom/gta4.ifp', true, price = 5, name = "GTA IV Animasyon Fiziği", engine = 1, disabled = 0},
	['gta5'] = {'custom/gta5.ifp', true, price = 5, name = "GTA V Animasyon Fiziği", engine = 1, disabled = 0},
	['swat'] = {'custom/swat.ifp', true, price = 3, name = "SWAT Animasyon Fiziği", engine = 1, disabled = 0},
	
	['custom_1'] = {'custom/custom_1.ifp', true, price = 10, name = "James_Bond Animasyon Fiziği", engine = 1, disabled = 0}, -- Gang 1
	['custom_2'] = {'custom/custom_2.ifp', true, price = 10, name = "Çete Animasyon Fiziği I", engine = 1, disabled = 0}, -- Gang 2
	['custom_3'] = {'custom/custom_3.ifp', true, price = 15, name = "Parkurcu Animasyon Fiziği", engine = 1, disabled = 0}, -- Parkour
	['custom_4'] = {'custom/custom_4.ifp', true, price = 0, name = "Silah Tutuş Fiziği I", engine = 1, disabled = 0}, -- Gang 3
	['custom_5'] = {'custom/custom_5.ifp', false, {"sitcross", "death", "LOU_Loop", "salute", "handsup", "blocdance", "throwhandsup", "BckHndSpingBTuck", "BckHndSping", "FrntHndSpring", "injuredknees", "headbutt", "faint", "collapseback", "standup_fromlay", "slav_squat", "handsbehindheadkneel", "stumbleback_collapse", "kneel_inspect", "HandsBehindBack"}, price = 0, name = "Özel Animasyonlar I", engine = 0, disabled = 0},
	['custom_6'] = {'custom/custom_6.ifp', true, price = 7, name = "Valhalla Animasyon Fiziği I", engine = 1, disabled = 0}, -- Project Awesome
	['custom_7'] = {'custom/custom_7.ifp', true, price = 7, name = "Valhalla Kadın Yürüme Fiziği", engine = 1, disabled = 0}, -- Female Remaked
	['custom_8'] = {'custom/custom_8.ifp', true, price = 7, name = "Çete Animasyon Fiziği II", engine = 1, disabled = 0}, -- Gang 4
	['custom_9'] = {'custom/custom_9.ifp', true, price = 6, name = "Valhalla Animasyon Fiziği II", engine = 1, disabled = 0}, -- New Animations for GTA:SA
	--['custom_10'] = {'custom/custom_10.ifp', true, price = 3, name = "Trevor GTA V Animasyon Fiziği", engine = 1, disabled = 1}, -- GTA V Trevor for GTA:SA
	['custom_11'] = {'custom/custom_11.ifp', true, price = 5, name = "Silah Tutuş Fiziği II", engine = 1, disabled = 0}, -- Gang 5
	['custom_12'] = {'custom/custom_12.ifp', true, price = 7, name = "Çete Animasyon Fiziği III", engine = 1, disabled = 0}, -- Gang 4
	['horse'] = {'custom/horse_animation.ifp', true, price = 0, name = "At Animasyonları", engine = 0, disabled = 1}, -- Horse (3rd exports)

	['fortnite_1'] = {'custom/fortnite_1.ifp', false, {"BD_Fire1", "BD_Fire2", "BD_Fire3", "BD_GF_Wave", "BD_Panic_01", "BD_Panic_02", "BD_Panic_03", "BD_Panic_04", "BD_Panic_Loop", "Grlfrd_Kiss_03", "M_smklean_loop", "Playa_Kiss_03", "wash_up"}, price = 0, name = "Fortnite I", engine = 0, disabled = 1},
	['fortnite_2'] = {'custom/fortnite_2.ifp', false, {"dnce_M_a", "dnce_M_b", "dnce_M_c", "dnce_M_d", "dnce_M_e"}, price = 5, name = "Fortnite Animasyonları", engine = 0, disabled = 0},
	['oturn'] = {'custom/seat-idle.ifp', false, {"SEAT_idle"}, price = 0, name = "Oturma Animasyonu", engine = 0, disabled = 0},
	['egil'] = {'custom/tired.ifp', false, {"IDLE_tired"}, price = 0, name = "Eğilme Animasyonu", engine = 0, disabled = 0},

	['aim'] = {'custom/aim.ifp', false, {'gang_gunstand'}, price = 0, name= "Aim", engine = 0, disabled = 0},
	['rapping'] = {'custom/rapping.ifp', false, {'Laugh_01', 'RAP_A_IN', 'RAP_A_Loop', 'RAP_A_OUT', 'RAP_B_IN', 'RAP_B_Loop', 'RAP_B_OUT', 'RAP_C_Loop'}, price = 0, name= "Sokak Rap Animasyonları", engine = 0, disabled = 0},
	['gang'] = {'custom/gang.ifp', false, {'gsign1', 'gsign1LH', 'gsign2', 'gsign2LH', 'gsign3', 'gsign3LH', 'gsign3', 'gsign4LH', 'gsign5', 'gsign5LH'}, price = 0, name= "Sokak Çete Animasyonları", engine = 0, disabled = 0},
	['dance'] = {'custom/dance_1.ifp', false, {"Bbalbat_Idle_01", "Bbalbat_Idle_02", "crckdeth1", "crckdeth2", "crckdeth3", "crckdeth4", "crckidle1", "crckidle2", "crckidle3", "crckidle4"}, price = 10, name = "Özel Dans Animasyonları", engine = 0, disabled = 0},
	['kissing'] = {'custom/kissing.ifp', false, {"BD_GF_Wave", "gfwave2", "GF_CarArgue_01", "GF_CarArgue_02", "GF_CarSpot", "GF_StreetArgue_01"}, price=0, name="Özel Animasyonlar II", engine=0, disabled=0},
	['sex'] = {'custom/sex.ifp', false, {"SEX_1to2_P", "SEX_1to2_W", "SEX_1_Cum_P", "SEX_1_Cum_W", "SEX_1_Fail_P", "SEX_1_P", "SEX_1_W", "SEX_2to3_P", "SEX_2to3_W", "SEX_2_Fail_P", "SEX_2_Fail_W", "SEX_2_P", "SEX_2_W", "SEX_3to1_P", "SEX_3to1_W", "SEX_3_Fail_P", "SEX_3_Fail_W", "SEX_3_P", "SEX_3_W"}, price=0, name="Özel Animasyonlar III (+18)", engine=0, disabled=0},
	['blowjob'] = {'custom/blowjob.ifp', false, {"BJ_Car_End_P", "BJ_Car_End_W", "BJ_Car_Loop_P", "BJ_Car_Loop_W", "BJ_Car_Start_P", "BJ_Car_Start_W", "BJ_Couch_End_P", "BJ_Couch_End_W", "BJ_Couch_Loop_P", "BJ_Couch_Loop_W", "BJ_Couch_Start_P", "BJ_Couch_Start_W", "BJ_Stand_Loop_P", "BJ_Stand_Loop_W", "BJ_Stand_Start_P", "BJ_Stand_Start_W"}, price=0, name="Özel Animasyonlar IV (+18)", engine=0, disabled=0},
}
local using_animation = nil

globalPedAnimationBlock = {
    -- Complete list of all animations in ped block, it is the default block
    -- in gta sa 
    animations = {
        "abseil","arrestgun","atm","bike_elbowl","bike_elbowr","bike_fallr","bike_fall_off","bike_pickupl","bike_pickupr",
        "bike_pullupl","bike_pullupr","bomber","car_alignhi_lhs","car_alignhi_rhs","car_align_lhs","car_align_rhs","car_closedoorl_lhs",
        "car_closedoorl_rhs","car_closedoor_lhs","car_closedoor_rhs","car_close_lhs","car_close_rhs","car_crawloutrhs","car_dead_lhs","car_dead_rhs",
        "car_doorlocked_lhs","car_doorlocked_rhs","car_fallout_lhs","car_fallout_rhs","car_getinl_lhs","car_getinl_rhs","car_getin_lhs","car_getin_rhs",
        "car_getoutl_lhs","car_getoutl_rhs","car_getout_lhs","car_getout_rhs","car_hookertalk","car_jackedlhs","car_jackedrhs","car_jumpin_lhs",
        "car_lb","car_lb_pro","car_lb_weak","car_ljackedlhs","car_ljackedrhs","car_lshuffle_rhs","car_lsit","car_open_lhs","car_open_rhs",
        "car_pulloutl_lhs","car_pulloutl_rhs","car_pullout_lhs","car_pullout_rhs","car_qjacked","car_rolldoor","car_rolldoorlo","car_rollout_lhs",
        "car_rollout_rhs","car_shuffle_rhs","car_sit","car_sitp","car_sitplo","car_sit_pro","car_sit_weak","car_tune_radio","climb_idle","climb_jump",
        "climb_jump2fall","climb_jump_b","climb_pull","climb_stand","climb_stand_finish","cower","crouch_roll_l","crouch_roll_r","dam_arml_frmbk",
        "dam_arml_frmft","dam_arml_frmlt","dam_armr_frmbk","dam_armr_frmft","dam_armr_frmrt","dam_legl_frmbk","dam_legl_frmft","dam_legl_frmlt","dam_legr_frmbk",
        "dam_legr_frmft","dam_legr_frmrt","dam_stomach_frmbk","dam_stomach_frmft","dam_stomach_frmlt","dam_stomach_frmrt","door_lhinge_o","door_rhinge_o",
        "drivebyl_l","drivebyl_r","driveby_l","driveby_r","drive_boat","drive_boat_back","drive_boat_l","drive_boat_r","drive_l","drive_lo_l","drive_lo_r",
        "drive_l_pro","drive_l_pro_slow","drive_l_slow","drive_l_weak","drive_l_weak_slow","drive_r","drive_r_pro","drive_r_pro_slow","drive_r_slow","drive_r_weak",
        "drive_r_weak_slow","drive_truck","drive_truck_back","drive_truck_l","drive_truck_r","drown","duck_cower","endchat_01","endchat_02","endchat_03",
        "ev_dive","ev_step","facanger","facgum","facsurp","facsurpm","factalk","facurios","fall_back","fall_collapse","fall_fall","fall_front","fall_glide",
        "fall_land","fall_skydive","fight2idle","fighta_1","fighta_2","fighta_3","fighta_block","fighta_g","fighta_m","fightidle","fightshb","fightshf",
        "fightsh_bwd","fightsh_fwd","fightsh_left","fightsh_right","flee_lkaround_01","floor_hit","floor_hit_f","fucku","gang_gunstand","gas_cwr","getup",
        "getup_front","gum_eat","guncrouchbwd","guncrouchfwd","gunmove_bwd","gunmove_fwd","gunmove_l","gunmove_r","gun_2_idle","gun_butt","gun_butt_crouch",
        "gun_stand","handscower","handsup","hita_1","hita_2","hita_3","hit_back","hit_behind","hit_front","hit_gun_butt","hit_l","hit_r","hit_walk","hit_wall",
        "idlestance_fat","idlestance_old","idle_armed","idle_chat","idle_csaw","idle_gang1","idle_hbhb","idle_rocket","idle_stance","idle_taxi","idle_tired",
        "jetpack_idle","jog_femalea","jog_malea","jump_glide","jump_land","jump_launch","jump_launch_r","kart_drive","kart_l","kart_lb","kart_r","kd_left",
        "kd_right","ko_shot_face","ko_shot_front","ko_shot_stom","ko_skid_back","ko_skid_front","ko_spin_l","ko_spin_r","pass_smoke_in_car","phone_in","phone_out",
        "phone_talk","player_sneak","player_sneak_walkstart","roadcross","roadcross_female","roadcross_gang","roadcross_old","run_1armed","run_armed",
        "run_civi","run_csaw","run_fat","run_fatold","run_gang1","run_left","run_old","run_player","run_right","run_rocket","run_stop","run_stopr",
        "run_wuzi","seat_down","seat_idle","seat_up","shot_leftp","shot_partial","shot_partial_b","shot_rightp","shove_partial","smoke_in_car",
        "sprint_civi","sprint_panic","sprint_wuzi","swat_run","swim_tread","tap_hand","tap_handp","turn_180","turn_l","turn_r","walk_armed","walk_civi",
        "walk_csaw","walk_doorpartial","walk_drunk","walk_fat","walk_fatold","walk_gang1","walk_gang2","walk_old","walk_player","walk_rocket","walk_shuffle",
        "walk_start","walk_start_armed","walk_start_csaw","walk_start_rocket","walk_wuzi","weapon_crouch","woman_idlestance","woman_run","woman_runbusy",
        "woman_runfatold","woman_runpanic","woman_runsexy","woman_walkbusy","woman_walkfatold","woman_walknorm","woman_walkold","woman_walkpro","woman_walksexy",
        "woman_walkshop","xpressscratch"
    },

    -- We will use this for checking whether animation is partial or not for ped block
    -- if it is, we won't replace it. Partial animations can be played using setPedAnimation.
    partialAnimations = {
        ["CAR_alignHI_LHS"] = true,
        ["CAR_alignHI_RHS"] = true,
        ["DAM_armL_frmFT"] = true,
        ["endchat_01"] = true,
        ["endchat_02"] = true,
        ["endchat_03"] = true,
        ["facanger"] = true,
        ["facgum"] = true,
        ["facsurp"] = true,
        ["facsurpm"] = true,
        ["factalk"] = true,
        ["facurios"] = true,
        ["FightA_M"] = true,
        ["FightA_block"] = true,
        ["flee_lkaround_01"] = true,
        ["handscower"] = true,
        ["HIT_walk"] = true,
        ["IDLE_chat"] = true,
        ["pass_Smoke_in_car"] = true,
        ["phone_in"] = true,
        ["phone_out"] = true,
        ["phone_talk"] = true,
        ["SHOT_leftP"] = true,
        ["SHOT_partial"] = true,
        ["SHOT_partial_B"] = true,
        ["SHOT_rightP"] = true,
        ["Shove_Partial"] = true,
        ["Smoke_in_car"] = true,
        ["Walk_DoorPartial"] = true,
    }
}

function ReplacePedBlockAnimations(player, customIfpBlockName)
    for _, animationName in pairs ( globalPedAnimationBlock.animations ) do 
		if customIfpBlockName then
        engineReplaceAnimation ( player, "ped", animationName, customIfpBlockName, animationName )
		end
    end
end

function getCustomAnimations()
	return anims_list
end

addEventHandler("onClientResourceStart", resourceRoot,
    function()
    	using_animation = getElementData(localPlayer, "custom_using") or nil
    	for index, value in pairs(anims_list) do
			if using_animation == index then
				resetPlayerCustomAnimation(localPlayer,index)
				setPlayerCustomAnimation(localPlayer,index)
			end
    		engineLoadIFP(value[1], index)
    		if value[2] == false then
	    		-- @addCommandHandler class
	    		for id, commandName in ipairs(value[3]) do

					cmdName = ((index:gsub("_2", "")):gsub("_5", ""))..(tostring(id))
	    			addCommandHandler(cmdName,
	    				function(cmd)
							local customtable = getElementData(localPlayer, "custom_animations") or {}
							if customtable[index] or (tonumber(anims_list[index].price) == 0) then
								setPedAnimation(localPlayer, tostring(index), commandName, -1, true, false, false)
								serverToAnim(index, commandName)
							end
	    				end
	    			)
	    		end
	    	end
    	end
    end
)

addCommandHandler("fortnite",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /fortnite (1-5)", 255, 0, 0, true) return end
		local index = "fortnite_2"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("fortnite"..id)
		end
	end
)

addCommandHandler("rapping",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /fortnite (1-8)", 255, 0, 0, true) return end
		local index = "rapping"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("rapping"..id)
		end
	end
)

addCommandHandler("gang",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /gang (1-10)", 255, 0, 0, true) return end
		local index = "gang"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("gang"..id)
		end
	end
)

addCommandHandler("aim",
	function(cmd)
		local index = "aim"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("aim1")
		end
	end
)

addCommandHandler("custom",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /custom (1-20)", 255, 0, 0, true) return end
		local index = "custom_5"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("custom"..id)
		end
	end
)

addCommandHandler("kissing",
	function(cmd, id, target)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /kissing (1-15)", 255, 0, 0, true) return end
		local index = "kissing"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			if (tonumber(id) == 11) then
				local targetPlayer = exports.vrp_global:findPlayerByPartialNick(localPlayer, target)
				if targetPlayer then
					triggerServerEvent("sync:target", targetPlayer, "kissing"..id)
				end
			end
			executeCommandHandler("kissing"..id)
		end
	end
)

addCommandHandler("sex",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /sex (1-15)", 255, 0, 0, true) return end
		local index = "sex"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("sex"..id)
		end
	end
)

addCommandHandler("blowjob",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /blowjob (1-15)", 255, 0, 0, true) return end
		local index = "blowjob"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("blowjob"..id)
		end
	end
)

addCommandHandler("dance",
	function(cmd, id)
		if not id then outputChatBox("[!]#ffffff Komut Kullanımı: /dance (1-10)", 255, 0, 0, true) return end
		local index = "dance"
		local customtable = getElementData(localPlayer, "custom_animations") or {}
		if customtable[index] or (tonumber(anims_list[index].price) == 0) then
			executeCommandHandler("dance"..id)
		end
	end
)

addEvent ("onClientCustomAnimationReplace", true )
addEventHandler ("onClientCustomAnimationReplace", root,
    function(animblock)
        if source == localPlayer then return end
		setPedWalkingStyle(source, 0)
        ReplacePedBlockAnimations(source, animblock)
    end 
)

addEvent ("onClientCustomAnimationRestore", true )
addEventHandler ("onClientCustomAnimationRestore", root,
    function ( blockName )
        if source == localPlayer then return end
        engineRestoreAnimation ( source, blockName )
    end 
)

addEvent("sync:anim", true)
addEventHandler("sync:anim", root,
	function(aName)
		executeCommandHandler(aName)
	end
)

addEventHandler("onClientElementDataChange", localPlayer,
	function(dataName)
		if (source == localPlayer) and dataName == 'custom_using' then
			local newValue = getElementData(source, dataName)
			if anims_list[newValue] then
				triggerServerEvent('onClientCustomAnimationUpdate', source, source, newValue)
				resetPlayerCustomAnimation(source)
				setPlayerCustomAnimation(source, newValue)
			end
		end
	end
)

addEventHandler("onClientPlayerQuit", localPlayer,
	function()
		if (source == localPlayer) then
			local newValue = getElementData(source, "custom_using")
			if anims_list[newValue] then
				triggerServerEvent('onClientCustomAnimationUpdate', source, source, newValue)
			end
		end
	end
)

function resetPlayerCustomAnimation(player)
	setElementData(localPlayer, 'custom_using', false)
    engineRestoreAnimation(player, "ped" )
	triggerServerEvent("onCustomAnimationRestore", root, player, blockname)
end

function setPlayerCustomAnimation(player, blockname)
	ReplacePedBlockAnimations(player, blockname)
	setPedWalkingStyle(player, 0)
	--setElementData(localPlayer, "custom_using", blockname)
	using_animation = blockname
	triggerServerEvent("onCustomAnimationReplace", root, player, blockname)
	triggerServerEvent ("onCustomAnimationSyncRequest", root, player)
end
addEvent("setPlayerCustomAnimation",true)
addEventHandler("setPlayerCustomAnimation",root, setPlayerCustomAnimation)

local maintance = false

addCommandHandler("animpanel",
	function()
		if maintance and not exports.vrp_integration:isPlayerDeveloper(localPlayer) then
			outputChatBox("[!]#ffffff Yeni animasyonlar ekleniyor, sistem güncelleniyor. Çok yakında aktif!", 255, 0, 0, true)
			return 
		end
		if getElementData(localPlayer, "loggedin") == 1 then
			if isElement(window) then destroyElement(window) end
			window = guiCreateWindow(0, 0, 549, 335, "Valhalla - Özel Animasyon Arayüzü", false)
			guiWindowSetSizable(window, false)
			exports.vrp_global:centerWindow(window)
	
			tab = guiCreateTabPanel(10,20,539,275,false,window)
			tab1 = guiCreateTab("Animasyon Fizikleri", tab)
			tab2 = guiCreateTab("Kodlu Animasyonlar", tab)
			
			grid = guiCreateGridList(3, 18, 525, 215, false, tab1)
			guiGridListAddColumn(grid, "Animasyon Adı", 0.5)
			guiGridListAddColumn(grid, "Durum", 0.3)
			guiGridListAddColumn(grid, "Özellik", 0.3)
			
			grid2 = guiCreateGridList(3, 18, 525, 215, false, tab2)
			guiGridListAddColumn(grid2, "Animasyon Adı", 0.5)
	
			use = guiCreateButton(9, 300, 267, 31, "Animasyonu Kullan", false, window)
			close = guiCreateButton(286, 300, 254, 31, "Arayüzü Kapat", false, window)
			local customtable = getElementData(localPlayer, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
			updateGridlist(grid, true)
			updateGridlist(grid2, false)
			
			addEventHandler('onClientGUIClick', root,
				function(b)
					if (b == 'left') then
						if source == use then
							local row = guiGridListGetSelectedItem(grid)
							if row ~= -1 then
								local index = guiGridListGetItemData(grid, row, 1)
								if customtable[index] or anims_list[index] then
									if (anims_list[index][2] == true) then
										if using_animation == index then triggerServerEvent('onClientCustomAnimationUpdate', localPlayer, localPlayer, "") resetPlayerCustomAnimation(localPlayer, index) destroyElement(window) using_animation = nil return end
										resetPlayerCustomAnimation(localPlayer,index)
										setPlayerCustomAnimation(localPlayer,index)
										--updateGridlist(grid, true)
										using_animation = index
										print(using_animation)
										destroyElement(window)
										triggerServerEvent('onClientCustomAnimationUpdate', localPlayer, localPlayer, index)
										outputChatBox("[!]#ffffff Animasyon başarıyla aktif edildi.", 0, 255, 0, true)
									else outputChatBox("[!]#ffffff Animasyon fiziği olmayan paketleri komut ile kullanabilirsiniz, komutları görebilmek için listeden çift tıklayın.", 255, 0, 0, true) end
								else outputChatBox("[!]#ffffff Animasyon verisi bulunamadı.", 255, 0, 0, true) end
							else outputChatBox("[!]#ffffff Henüz bir animasyon seçmediniz.", 255, 0, 0, true) end
						elseif source == close then
							destroyElement(window)
						end
					end
				end
			)
			addEventHandler('onClientGUIDoubleClick', root,
				function(b)
					if (b == 'left') then
					if not isElement(grid2) then return end
						local row = guiGridListGetSelectedItem(grid2)
						if row ~= -1 then
							local index = guiGridListGetItemData(grid2, row, 1)
							if customtable[index] or anims_list[index] then
								if (anims_list[index][2] == false) then
									outputChatBox("[!]#ffffff "..anims_list[index].name.." animasyonunun komutları:", 0, 0, 255, true)
									local commands_text, i = "", 0
										
									for id, commandName in ipairs(anims_list[index][3]) do
										cmdName = ((index:gsub("_2", "")):gsub("_5", "")).." "..(tostring(id))
										if i == 0 then
											commands_text = "/"..cmdName
										else
											commands_text = commands_text..", ".."/"..cmdName
										end
										i = i + 1
									end
									outputChatBox("[!]#ffffff "..commands_text, 0, 0, 255, true)
								end
							end
						end
					end
				end
			)
		end
	end
)

function updateGridlist(grid, state)
	guiGridListClear(grid)
	local customtable = getElementData(localPlayer, "custom_animations") or {} -- tablo yapısı: {['fortnite_1'] = true}
	if state then
		for index in pairs(customtable) do
			if anims_list[index] and anims_list[index][2] == true and anims_list[index].disabled == 0 then
				local row = guiGridListAddRow(grid)
				guiGridListSetItemText(grid, row, 1, anims_list[index].name, false, false)
				guiGridListSetItemData(grid, row, 1, index, false, false)
				
				if (using_animation or false) == index then
					guiGridListSetItemText(grid, row, 2, "Açık", false, false)
					guiGridListSetItemColor(grid, row, 1, 0, 255, 0)
					guiGridListSetItemColor(grid, row, 2, 0, 255, 0)
				else
					guiGridListSetItemText(grid, row, 2, "Kapalı", false, false)
				end
				if tonumber(anims_list[index].price) == 0 then
					guiGridListSetItemText(grid, row, 3, "Ücretsiz", false, false)
					if (using_animation or false) ~= index then
						for i=1, 3 do
							guiGridListSetItemColor(grid, row, i, 170, 170, 170)
						end
					end
				else
					guiGridListSetItemText(grid, row, 3, "Özel", false, false)
					if (using_animation or false) ~= index then
						for i=1, 3 do
							guiGridListSetItemColor(grid, row, i, 200, 255, 200)
						end
					end
				end
			end
		end
		for index, value in pairs(anims_list) do
			if anims_list[index] and anims_list[index][2] == true and anims_list[index].disabled == 0  then
				if tonumber(value.price) == 0 then
					local row = guiGridListAddRow(grid)
					guiGridListSetItemText(grid, row, 1, anims_list[index].name, false, false)
					guiGridListSetItemData(grid, row, 1, index, false, false)
					
					if (using_animation or false) == index then
						guiGridListSetItemText(grid, row, 2, "Açık", false, false)
						guiGridListSetItemColor(grid, row, 1, 0, 255, 0)
						guiGridListSetItemColor(grid, row, 2, 0, 255, 0)
					else
						guiGridListSetItemText(grid, row, 2, "Kapalı", false, false)
					end
					if tonumber(anims_list[index].price) == 0 then
						guiGridListSetItemText(grid, row, 3, "Ücretsiz", false, false)
						if (using_animation or false) ~= index then
							for i=1, 3 do
								guiGridListSetItemColor(grid, row, i, 170, 170, 170)
							end
						end
					else
						guiGridListSetItemText(grid, row, 3, "Özel", false, false)
						if (using_animation or false) ~= index then
							for i=1, 3 do
								guiGridListSetItemColor(grid, row, i, 255, 255, 255)
							end
						end
					end
				end
			end
		end
	else
		for index in pairs(customtable) do
			if anims_list[index] and anims_list[index][2] == false and anims_list[index].disabled == 0  then
				local row = guiGridListAddRow(grid)
				guiGridListSetItemText(grid, row, 1, anims_list[index].name, false, false)
				guiGridListSetItemData(grid, row, 1, index, false, false)
				
				
			end
		end
		for index, value in pairs(anims_list) do
			if value[2] == false and anims_list[index].disabled == 0 then
				if tonumber(value.price) == 0 then
					local row = guiGridListAddRow(grid)
					guiGridListSetItemText(grid, row, 1, anims_list[index].name, false, false)
					guiGridListSetItemData(grid, row, 1, index, false, false)
					
					
				end
			end
		end
	end
end