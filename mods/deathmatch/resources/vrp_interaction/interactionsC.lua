Interaction.Interactions = {}

function addInteraction(type, model, name, image, executeFunction)
	if not Interaction.Interactions[type][model] then
		Interaction.Interactions[type][model] = {} 
	end
 
	table.insert(Interaction.Interactions[type][model], {name, image, executeFunction})
end

addEventHandler("onClientResourceStart", resourceRoot, function()

end)

addCommandHandler("iptal",
function()
	if getElementData(localPlayer, "degisdurum") then
		setElementData(localPlayer, "degisdurum", nil)
		outputChatBox("#575757Valhalla:#f9f9f9 Başarıyla işlemin iptal edildi.", 0, 255, 0, true)
	else
		outputChatBox("#575757Valhalla:#f9f9f9 Şu anda her hangi bir istekte bulunmamışsın.", 255, 0, 0, true)	
	end
end)

function getInteractions(element, durum)
	local interactions = {}
	local type = getElementType(element)
	local model = getElementModel(element)
		table.insert(interactions, {"Kapat", "icons/cross_x.png",
		function ()
			Interaction.Close()
		end
	})
	if durum == "home" then
		if getElementData(localPlayer, "loggedin") ~= 1 then return end					
		table.insert(interactions, {"Karakter Değiştir", "icons/tagok.png",
			function (player, target)
				if getElementData(localPlayer, "loggedin") ~= 1 then outputChatBox("#575757Valhalla:#f9f9f9 Giriş yapmadan karakterini değiştiremezsin.", 255, 0, 0, true) return end
				if getElementData(localPlayer, "dead") == 1 or getElementData(localPlayer, "isleme:durum") or getElementData(localPlayer, "kazma:durum") or getElementData(localPlayer, "tutun:durum") then 
					outputChatBox("#575757Valhalla:#f9f9f9 Bu durumdayken F10 Karakter Değiştir butonunu kullanamazsın.", 255, 14, 14 ,true) 
				return end
				if getElementData(localPlayer,"degisdurum") then 
					outputChatBox("[-]#f9f9f9 Şu anda zaten karakter değiştirme işlemini gerçekleştiriyorsun.", 255,0,0,true) 
				return end 
				triggerServerEvent("karakterDegistirmeStart", localPlayer)
				exports["vrp_infobox"]:addBox("info", "20 saniye sonra karakter değiştirme ekranına gideceksin. İptal etmek için: /iptal")
				setElementData(localPlayer, "degisdurum", true)
				setTimer(function()
					if getElementData(localPlayer, "degisdurum") then
						triggerServerEvent("karakterDegistirme", localPlayer)
						setElementData(localPlayer, "degisdurum", nil)
						exports["vrp_account"]:options_logOut(localPlayer)
					else
						outputChatBox("#575757Valhalla:#f9f9f9 Karakter değiştirme işlemini iptal ettiğinden dolayı işlemin gerçekleştirilmedi.", 255, 0, 0, true)
					end
				end, 20000, 1)
			end })
			

		table.insert(interactions, {"OOC Market", "icons/tl.png", function (player, target)
			executeCommandHandler("market")
		end })	

		if exports.vrp_integration:isPlayerTrialAdmin(localPlayer) then 
			table.insert(interactions, {"Yetkili Arayüzü", "icons/tagok.png", function (player, target)
				executeCommandHandler("staffs")
			end})		

			table.insert(interactions, {"Araç Kütüphanesi", "icons/lock.png", function (player, target)
				triggerServerEvent("vehlib:sendLibraryToClient", localPlayer)
			end})
		end	
	return interactions end
	if type == "ped" then

			table.insert(interactions, {"Konuş", "icons/detector.png",
				function (player, target)
					triggerEvent("npc:konus",localPlayer,element)
				end
			})

	elseif type == "player" then
		
		table.insert(interactions, {"Karakter Bilgileri", "icons/eyemask.png",
			function (player, target)
				exports["vrp_social"]:showPlayerInfo(target)
			end
		})

		if isFriendOf(getElementData(element, "account:id")) then
			table.insert(interactions, {"Arkadaş Ekle", "icons/friend.png",
				function (player, target)
					triggerServerEvent("addFriend", localPlayer, target)
				end
			})
		end
		
		table.insert(interactions, {"Üst Ara", "icons/glass.png",
			function (player, target)
				exports["vrp_social"]:cfriskPlayer(target)
			end
		})

		if not getElementData(element, "gözbandajı") then
			table.insert(interactions, {"Gözlerini Bağla", "icons/eyemask.png",
				function (player, target)
					local hedef = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("gozbagla",localPlayer,localPlayer,hedef)	
				end
			})
		else
			table.insert(interactions, {"Gözlerini Çöz", "icons/eyemask.png",
				function (player, target)
					local hedef = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("gozcoz",localPlayer,localPlayer,element)
				end
			})
		end	

		if not getElementData(element, "ipbagli") then
			table.insert(interactions, {"Ellerini Bağla", "icons/eyemask.png",
				function (player, target)
					local hedef = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("ipbagla",localPlayer,localPlayer,hedef)
				end
			})
				else
				table.insert(interactions, {"Ellerini Çöz", "icons/eyemask.png",
				function (player, target)
					local hedef = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("ipcoz",localPlayer,localPlayer,element)
				end
			})
		end

		if exports["vrp_items"]:hasItem(localPlayer, 45) then
			if not getElementData(element, "kelepce") then
				table.insert(interactions, {"Kelepçele", "icons/cuff.png",
					function (player, target)
						local hedef = getPlayerFromName(getPlayerName(element))
						triggerServerEvent("kelepcele",localPlayer,element,"ver")
					end
				})
			else
				table.insert(interactions, {"Kelepçeyi Çöz", "icons/uncuff.png",
					function (player, target)
						local hedef = getPlayerFromName(getPlayerName(element))
						triggerServerEvent("kelepcele",localPlayer,element,"al")
					end
				})
			end
		end
			
	elseif type == "vehicle" then

		if getElementData(element, "carshop") then
			table.insert(interactions, {"Satın Al ($"..exports.vrp_global:formatMoney(getElementData(element,"carshop:cost"))..")","icons/trunk.png",
				function (player, target)
					triggerServerEvent("carshop:buyCar", element, "cash")
				end
			})
		else
			table.insert(interactions, {"Araç Envanteri", "icons/wheelclamp.png",
				function (player, target)
					if not exports.vrp_global:hasItem(player, 3, getElementData(target, "dbid")) then
	           			 outputChatBox("Bu aracı aramak için anahtarlara ihtiyacınız var..", 255, 0, 0)
	           		else
						 triggerServerEvent( "openFreakinInventory", player, element, 500, 500 )
					end
					
				end
			})

			table.insert(interactions, {"Kapı Kontrolü", "icons/trunk.png",
				function (player, target)
					exports["vrp_vehicle"]:openVehicleDoorGUI(element)
				end
			})

		    if exports['vrp_items']:hasItem(element, 117) then
				table.insert(interactions, {"Rampa", "icons/ramp.png",
					function (player, target)
						exports["vrp_vehicle"]:toggleRamp(target)
					end
				})
		    end

		    if exports['vrp_items']:hasItem(localPlayer, 57) then
				table.insert(interactions, {"Benzin Doldur", "icons/fuel.png",
					function (player, target)
						exports["vrp_vehicle"]:fillFuelTank(target)
					end
				})
		    end

			if ( getPedSimplestTask(localPlayer) == "TASK_SIMPLE_CAR_DRIVE" and getPedOccupiedVehicle(localPlayer) == element ) then
				table.insert(interactions, {"Açıklama", "icons/info.png",
					function (player, target)
						if (getElementData(target, "dbid") > 0 ) then
							exports["vrp_vehicle"]:fLook(target)
						end
					end
				})
		    end

	     	if (exports.vrp_global:isStaffOnDuty(localPlayer) and exports.vrp_integration:isPlayerSeniorAdmin(localPlayer)) then
				table.insert(interactions, {"ADM: Texture", "icons/adm.png",
					function (player, target)

	     	if exports.vrp_integration:isPlayerSeniorAdmin(localPlayer) then
							exports["vrp_vehicle"]:fTextures(target)
						end
					end
				})
		    end	 

		   if getElementData(localPlayer, "duty_admin") == 1 then
			table.insert(interactions, {"ADM: Yenile", "icons/icon.png",
					function (player, target)
							triggerServerEvent("vehicle_manager:respawn", player, element)
					end
				})
			end  

		    if (getElementModel(element) == 416) and getElementData(localPlayer, "faction") == 2 then
				table.insert(interactions, {"Sedye", "icons/stretcher.png",
					function (player, target)
						exports["vrp_vehicle"]:fStretcher(target)
					end
				})
		    end
		end
	elseif type == "object" then
				if getElementData(element, "isInteractable") then
			local aksiyon = exports["vrp_glass"]:getCurrentInteractionList(model)
			
			for k,v in pairs(aksiyon) do
				table.insert(interactions, v)
			end

			aksiyon = nil
					end
	end

	return interactions
end


function isFriendOf( accountID )
	for _, data in ipairs( {online, offline} ) do
		for k, v in ipairs( data ) do
			if v.accountID == accountID then
				return true
			end
		end
	end
	return false
end