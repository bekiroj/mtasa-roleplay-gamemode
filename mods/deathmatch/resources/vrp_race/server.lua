function chatBox(plr , text , mod)
	local r, g, b = 0,0,0
	if mod == "error" then
		r = 255
	elseif mod == "succes" then
		g = 255
	elseif mod == "alert" then
		g , b = 153 , 255
	end

	outputChatBox("[!]#ffffff"..text , plr , r , g , b , true)
end

addCommandHandler("yaris" , function(plr , cmd , arg1 , arg2)

	if not arg1 then outputChatBox("KULLANIM : /"..cmd.." [olustur/davet/cpekle/baslat/kabul/red]",plr,254,194,14) return end

	if arg1 == "olustur" then 

		if (Race.RacePlayers[plr]) then 
			chatBox(plr , "Şuanda bir yarıştasınız zaten!" , "error")
		return end

		if tonumber(plr:getData("money")) < Race.Create.price then
			chatBox(plr , "Yarış oluşturmak için yeteri kadar paranız yok!" , "error")
		return end 

		if tonumber(plr:getData("level")) < Race.Create.playerlevel then
			chatBox(plr , "Yarış kurabilmek için en az "..Race.Create.playerlevel.." seviye olmalısınız!" , "error")
		return end

		if not arg2 then outputChatBox("KULLANIM : /"..cmd.." olustur [BAHIS]",plr,254,194,14) return end

		if arg2 then

			if tonumber(arg2) < Race.Create.minbet or tonumber(arg2) > Race.Create.maxbet then
				chatBox(plr , "Bahis miktarı "..Race.Create.minbet.." ile "..Race.Create.maxbet.." arasında olmalıdır!" , "error")
			return end

			if tonumber(plr:getData("money")) < (tonumber(arg2)+Race.Create.price) then
				chatBox(plr , "Bahis miktarı ve yarışı oluşturacak kadar paran yok! (Bahis Miktarı + Yarış Oluşturma Ücreti)" , "error")
			return end

			local ID = #Race.RaceArena+1
			
			Race.RaceArena[ID]           = {}
			Race.RaceArena[ID]['Marker'] = {}
			Race.RaceArena[ID]['Owner']  = plr
			Race.RaceArena[ID]['Bet']    = tonumber(arg2)		

			Race.RacePlayers[plr]                = {} 
			Race.RacePlayers[plr]['ID']          = ID
			Race.RacePlayers[plr]['Bet']         = tonumber(arg2)
			Race.RacePlayers[plr]['Owner']       = true

			chatBox(plr , ID.." nolu yarışı oluşturdun!" , "succes")

			exports.vrp_global:takeMoney(plr , (tonumber(arg2)+Race.Create.price))

		end

	elseif arg1 == "cpekle" then 

		if not Race.RacePlayers[plr] then 
			chatBox(plr , "Herhangi bir yarışta değilsiniz!" , "error")
		return end

		if not Race.RacePlayers[plr]['Owner'] then 
			chatBox(plr , "İçerisinde bulunduğunuz yarışın sahibi değilsiniz!" , "error")
		return end

		local ID = Race.RacePlayers[plr]['ID']

		if not ID then
			chatBox(plr , "Hata Kodu 001" , "error")
		return end

		if tonumber(#Race.RaceArena[ID]['Marker']) >= Race.Global.maxmarker then
			chatBox(plr , "Yeterince marker eklemişsin zaten!" , "error")
		return end

		local pos = plr.position

		local MarkerID = #Race.RaceArena[ID]['Marker'] + 1
		Race.RaceArena[ID]['Marker'][MarkerID] = Vector3(pos)

		chatBox(plr , "Bulunduğun koordinatına bir checkpoint ekledin!" , "alert")
	
	elseif arg1 == "davet" then 

		if not Race.RacePlayers[plr] then 
			chatBox(plr , "Herhangi bir yarışta değilsiniz!" , "error")
		return end

		if not Race.RacePlayers[plr]['Owner'] then 
			chatBox(plr , "İçerisinde bulunduğunuz yarışın sahibi değilsiniz!" , "error")
		return end

		local ID = Race.RacePlayers[plr]['ID']

		if not ID then
			chatBox(plr , "Hata Kodu 002" , "error")
		return end

		local playercount = 0

		for key , value in pairs(Race.RacePlayers) do
			if value.ID == ID then
				playercount = playercount+1
			end
		end

		if playercount+1 > Race.Create.maxplayers then
			chatBox(plr , "Yarışa daha fazla kişi ekleyemezsin!" , "error")
		return end

		if not arg2 then outputChatBox("KULLANIM : /"..cmd.." davet [ID]",plr,254,194,14) return end
		if arg2 then

			local target , targetName = exports.vrp_global:findPlayerByPartialNick(plr, tonumber(arg2))

			if target then

				if target == plr then
					chatBox(plr , "Kendine bir yarış daveti gönderemezsin!" , "error")
				return end

				if Race.RacePlayers[target] then
					chatBox(plr , "Davet etmek istediğiniz kişi bir yarışta!" , "error")
				return end

				if Race.RaceInvitedPlayers[target] then
					chatBox(plr , "Davet ettiğiniz kişi başka bir yerden davet almış durumda!" , "error")
				return end

				local Bet = Race.RacePlayers[plr]['Bet']

				if not Bet then
					chatBox(plr , "Hata Kodu 003" , "error")
				return end

				if tonumber(target:getData("money")) < Bet then
					chatBox(plr , "Karşı tarafın bahis miktarı kadar parası yok!" , "error")
				return end

				if tonumber(target:getData("level")) < Race.Create.playerlevel then
					chatBox(plr , "Yarışa davet edeceğiniz kişinin seviyesi en az "..Race.Create.playerlevel.." olmalıdır!" , "error")
				return end
				
				Race.RaceInvitedPlayers[target]         = {}
				Race.RaceInvitedPlayers[target]['ID']   = ID	
				Race.RaceInvitedPlayers[target]['Bet']  = Bet
				Race.RaceInvitedPlayers[target]['Send'] = plr	
				
				chatBox(plr , target.name.." adlı kişiye yarış davet gönderdiniz!" , "succes")
				chatBox(target , plr.name.." adlı kişi tarafından "..Bet.."TL'lik bir yarış daveti aldınız! (/yaris yardim)" , "succes")

			end
		end

	elseif arg1 == "kabul" then

		if not Race.RaceInvitedPlayers[plr] then
			chatBox(plr , "Herhangi bir yarış davetin yok!" , "error")
		return end

		if Race.RacePlayers[plr] then 
			chatBox(plr , "Şuanda bir yarıştasın zaten!" , "error")
		return end

		local Bet = Race.RaceInvitedPlayers[plr]['Bet']

		if not Bet then
			chatBox(plr , "Hata Kodu 004" , "error")
		return end

		if tonumber(plr:getData("money")) < Bet then
			chatBox(plr , "Bahis miktarı kadar paran yok!" , "error")
		return end

		local ID = Race.RaceInvitedPlayers[plr]['ID']

		local playercount = 0

		for key , value in pairs(Race.RacePlayers) do
			if value.ID == ID then
				playercount = playercount+1
			end
		end

		if playercount+1 > Race.Create.maxplayers then
			chatBox(plr , "Yarışa daha fazla kişi giremez! Davet isteğin otomatik olarak red edildi!" , "error")

			local target = Race.RaceInvitedPlayers[plr]['Send']
			chatBox(target , "Yarışa daha fazla kişi giremediği için sistem tarafından "..(plr.name).."'ye yapılan davetin otomatik olarak red edildi!" , "error")

			Race.RaceInvitedPlayers[plr] = nil
		return end

		Race.RacePlayers[plr]                = {} 
		Race.RacePlayers[plr]['ID']          = ID
		Race.RacePlayers[plr]['Bet']         = Bet
		Race.RacePlayers[plr]['Owner']       = false

		chatBox(plr , "Yarış davetini kabul ederek yarışa dahil oldun!" , "succes")

		local target = Race.RaceInvitedPlayers[plr]['Send']
		chatBox(target , plr.name.." adlı kişi yarış davetinizi kabul etti ve yarışa dahil oldu!" , "succes")

		exports.vrp_global:takeMoney(plr , Bet)

		Race.RaceInvitedPlayers[plr] = nil

	elseif arg1 == "red" then 
		
		if not Race.RaceInvitedPlayers[plr] then
			chatBox(plr , "Herhangi bir yarış davetin yok!" , "error")
		return end

		if Race.RacePlayers[plr] then 
			chatBox(plr , "Şuanda bir yarıştasın zaten!" , "error")
		return end

		local target = Race.RaceInvitedPlayers[plr]['Send']
		chatBox(target , plr.name.." adlı kişi yarış davetini red etti!" , "error")


		Race.RaceInvitedPlayers[plr] = nil

		chatBox(plr , "Yarış isteğini red ettin!" , "alert")
	
	elseif arg1 == "liste" then 

		if not Race.RacePlayers[plr] then 
			chatBox(plr , "Şuanda bir yarışta değilsin!" , "error")
		return end

		local ID = Race.RacePlayers[plr]['ID']

		if not ID then
			chatBox(plr , "Hata Kodu 007" , "error")
		return end

		local playerrs = {}
		
		outputChatBox("#ffffff[#fd3030 Yarışa katılanlar#ffffff]" , plr , 0,0,0,true)
		for key , value in pairs(Race.RacePlayers) do
			if value.ID == ID then
				outputChatBox("#fd3030 "..key.name , plr , 0,0,0,true)
			end
		end


	elseif arg1 == "baslat" then

		if not Race.RacePlayers[plr] then 
			chatBox(plr , "Herhangi bir yarışta değilsiniz!" , "error")
		return end

		if Race.RacePlayers[plr]['Timer'] then
			chatBox(plr , "Yarış şuanda başlama aşamasında zaten!" , "error")
		return end

		if not Race.RacePlayers[plr]['Owner'] then 
			chatBox(plr , "İçerisinde bulunduğunuz yarışın sahibi değilsiniz!" , "error")
		return end

		local ID = Race.RacePlayers[plr]['ID']

		if not ID then
			chatBox(plr , "Hata Kodu 005" , "error")
		return end

		if #Race.RaceArena[ID]['Marker'] < Race.Global.minmarker then
			chatBox(plr , "Marker sayısı en az "..Race.Global.minmarker.." olmalıdır!" , "error")
		return end

		Race.RacePlayers[plr]['Timer'] = Timer(
		function()
			local _,backerTimer,__ = getTimerDetails(Race.RacePlayers[plr]['Timer'])
			if backerTimer then

				for k , v in pairs(Race.RacePlayers) do 

					if v.ID == ID then 

						triggerClientEvent(k , "race:TimerUpdate" , k , backerTimer-1)
							
						if backerTimer <= Race.Create.frozentime then

							k.frozen = true

						end

						if backerTimer <= 1 then

							triggerClientEvent(k , "race:TimerUpdate" , k , false)

							k.frozen = false

							Race.RacePlayers[k]['Marker']  = Marker((Race.RaceArena[ID]['Marker'][1]) , "checkpoint" , 5 , 255 , 0 , 0 , 255 , k)
							Race.RacePlayers[k]['MarkerC'] = 1

							addEventHandler("onMarkerHit" , Race.RacePlayers[k]['Marker'] , onMarkerHit)

						end
					end
				end
			end
		end , 1000 , Race.Create.starttime+1)
	end
end)

function onMarkerHit(plr)
	if plr and getElementType(plr) == "player" and Race.RacePlayers[plr] and Race.RacePlayers[plr]['Marker'] then

		if Race.RacePlayers[plr]['Marker'] == source then 

			local ID    = Race.RacePlayers[plr]['ID']
			local Bet   = Race.RacePlayers[plr]['Bet']
			local Count = Race.RacePlayers[plr]['MarkerC'] + 1

			destroyElement(source)

			if Count > #Race.RaceArena[ID]['Marker'] then 

				if not Race.RaceArena[ID]['Ranked'] then 
					Race.RaceArena[ID]['Ranked'] = {}
				end

				local ranked = #Race.RaceArena[ID]['Ranked'] + 1

				chatBox(plr , "Yarışı "..ranked.." sırada bitirdin!" , "alert" )

				if ranked == 1 then

					local playercount = 0

					for k , v in pairs(Race.RacePlayers) do 

						if v.ID == ID then

							playercount = playercount + 1
							chatBox(k , plr.name.." adlı kişi yarışı birinci bitirdi!" , "alert")
							
							if Race.RacePlayers[k]['Marker'] and isElement(Race.RacePlayers[k]['Marker']) and getElementType(Race.RacePlayers[k]['Marker']) == "marker" then 
								destroyElement(Race.RacePlayers[k]['Marker'])
							end
							
							Race.RacePlayers[k] = nil
							
							
						end

					end

					exports.vrp_global:giveMoney(plr , Bet*playercount)

				end

				Race.RacePlayers[plr] = nil
				Race.RaceArena[ID] = nil

			return end

			Race.RacePlayers[plr]['MarkerC'] = Count

			local markpos = Race.RaceArena[ID]['Marker'][Count] 

			Race.RacePlayers[plr]['Marker'] = Marker(markpos , "checkpoint" , 5 , 255 , 0 , 0 , 255 , plr)

			addEventHandler("onMarkerHit" , Race.RacePlayers[plr]['Marker'] , onMarkerHit)

		end	
	end
end

addEventHandler("onPlayerQuit" , root , function()
	if source then

		if Race.RacePlayers[source] then 

			if Race.Global.quitcancel then

				local bet = Race.RacePlayers[source]["Bet"]
				exports.vrp_global:giveMoney(source , tonumber(bet))

				Race.RacePlayers[source] = false

			end
		end

		if Race.RaceInvitedPlayers[source] then

			local target = Race.RaceInvitedPlayers[source]['Send']
			chatBox(target , plr.name.." adlı kişi oyundan çıktığı için yarış davetin sistem tarafından red edildi!" , "error")

			Race.RaceInvitedPlayers[source] = nil

		end
	end
end)