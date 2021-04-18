local connection = exports.vrp_mysql:getConnection()


function dolapCmd(plr , cmd , arg1)
	if not arg1 then outputChatBox("KULLANIM : /"..cmd.." [kabul / red / istek / goruntule / elkoy]",plr,254,194,14) return end
	if arg1 == "kabul" then

		if not getElementData(plr , "dolapInvıte") then
			outputChatBox("[!]#ffffff Dolabını açmak isteyen birisi yok!",plr,255,0,0,true)
		return end

		local target = getElementData(plr , "dolapInvıte")

		outputChatBox("[!]#ffffff Dolap sahibi, dolap açma isteğini kabul etti!",target,0,255,0,true)
		outputChatBox("[!]#ffffff "..getPlayerName(target).." adlı kişinin dolap açma isteğini kabul ettin!",plr,0,255,0,true)

		setElementData(plr , "dolapInvıte" , nil)

		local dim = target.dimension

		if dim == 0 then return end

		dolapServerGUI(target , false , dim , false)

	elseif arg1 == "red" then

		if not getElementData(plr , "dolapInvıte") then
			outputChatBox("[!]#ffffff Dolabını açmak isteyen birisi yok!",plr,255,0,0,true)
		return end

		local target = getElementData(plr , "dolapInvıte")

		outputChatBox("[!]#ffffff Dolap sahibi, dolap açma isteğini red etti!",target,255,0,0,true)
		outputChatBox("[!]#ffffff "..getPlayerName(target).." adlı kişinin dolap açma isteğini red ettin!",plr,255,0,0,true)

		setElementData(plr , "dolapInvıte" , nil)

	elseif arg1 == "goruntule" then

		local dim = plr.dimension
		if dim == 0 then return end

		if ( dim < 19000 and ( exports["vrp_items"]:hasItem(plr, 5, dim) or exports["vrp_items"]:hasItem(plr, 4, dim) ) ) or ( dim >= 20000 and exports["vrp_items"]:hasItem(plr, 3, dim-20000) ) then

			dolapServerGUI(plr , true , dim , false)

		else

			outputChatBox("[!]#ffffff Sahibi olmadığın dolabı görüntüleyemezsin! /dolap istek",plr,255,0,0,true)
		end

	elseif arg1 == "elkoy" then

		local dim = plr.dimension
		if dim == 0 then return end

		if not getElementData(plr , "faction") == 1 or not getElementData(plr , "faction") == 78 or not getElementData(plr , "duty") then 
			outputChatBox("[!]#ffffff İşbaşında bir polis memuru değilsin!",plr,255,0,0,true)
		return end 

		dolapServerGUI(plr , true , dim , true)

	elseif arg1 == "istek" then 
		
		local dim = plr.dimension
		if dim == 0 then return end

		for k , v in ipairs(getElementsByType("player")) do 
			if ( dim < 19000 and ( exports["vrp_items"]:hasItem(v, 5, dim) or exports["vrp_items"]:hasItem(v, 4, dim) ) ) or ( dim >= 20000 and exports["vrp_items"]:hasItem(v, 3, dim-20000) ) then
				outputChatBox("[!]#ffffff Birisi dolabını açmak istiyor! /dolap kabul veya /dolap red ile bu teklifi yönlendirebilirsin!",v,0,153,255,true)
				outputChatBox("[!]#ffffff İstek gönderen kişi eğer polis ise dolabındaki malzemelere el koyabilir!",v,0,153,255,true)
				outputChatBox("[!]#ffffff Dolap açma isteği yolladın!",plr,0,153,255,true)
				setElementData(v , "dolapInvıte" , plr)
			end
		end

	else
		outputChatBox("KULLANIM : /"..cmd.." [kabul / red]",plr,254,194,14)
	end
end
addCommandHandler("dolap" , dolapCmd)

function dolapServerGUI(plr , boole , dim , state)

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)

			local dolapItems = {}

			if rows > 0 then
				
				for k , row in ipairs(res) do

					if tonumber(row.id) == dim then 

						table.insert(dolapItems , {
							id = row.id,
							item = row.item,
							text  = row.text,
							value = row.value,
							weapon = (row.weapon or 0),
						})

					end

				end

			end

			triggerLatentClientEvent(plr ,  "dolapGUI" , 5000 , false , plr , boole , dolapItems , exports["vrp_items"]:getItems(plr) , state)

	end , connection , "SELECT * FROM cabinets")

end

addEvent("dolapAktar" , true)
addEventHandler("dolapAktar" , root , function(itemID , itemValue , dim , text , wep , value)
	
	element = source

	local success, error = exports["vrp_items"]:loadItems( element )
	if success then


		local success, slot = exports["vrp_items"]:hasItem(element, itemID , itemValue)
		if success then

			exports["vrp_items"]:takeItemFromSlot(element, slot)

			if (tonumber(itemID) == 115 or tonumber(itemID) == 116) and (getElementType(element) == 'player')  then

				triggerEvent("updateLocalGuns", element)
				wep = getWeaponIDFromName(wep)

				dbExec(connection , "INSERT INTO cabinets SET id='"..(dim).."', item='"..(itemID).."', text='"..(text).."', weapon='"..(wep).."', value='"..value.."'")

			else

				dbExec(connection , "INSERT INTO cabinets SET id='"..(dim).."', item='"..(itemID).."', weapon='0', text='"..(text).."', value='"..value.."'")

			end

		else 

			outputChatBox("[!]#ffffff Bir hata oluştu! Paneli sizin yerinize kapatıyoruz ve tekrardan aktarmanızı rica ediyoruz!",source,255,0,0,true)
			triggerClientEvent(source , "dolapHide" , source)

		end
	end
end)

addEvent("dolapGetir" , true)
addEventHandler("dolapGetir" , root , function(itemID , text , dim , plr , state)

	local dolapTablo = {}
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)

			if rows > 0 then
				
				for k , row in ipairs(res) do

					if tonumber(row.id) == dim then 

						table.insert(dolapTablo , {
							id = row.id,
							item = row.item,
							text  = row.text,
							value  = row.value,
							weapon = (row.weapon or 0),
						})

					end

				end

				if #dolapTablo > 0 then

					for k , v in ipairs(dolapTablo) do 
			
						if v.id == dim then
			
							if v.text == text and v.item == itemID then

								--local gunDetails = explode(':', v.value)


								if not state then 

									if tonumber(v.item) == 115 then

										local cid = tonumber(getElementData(plr,"account:character:id"))
										local serial = exports.vrp_global:createWeaponSerial(1,cid)
										exports["vrp_items"]:giveItem(plr, 115, (v.weapon)..":"..serial..":"..(v.text).."::")
										
									else 

										exports["vrp_items"]:giveItem(plr , tonumber(v.item) , v.value)

									end

								end
				

								dbExec(connection , "DELETE FROM cabinets WHERE id = "..(v.id).." AND item = "..(v.item).." AND weapon = "..(v.weapon).."  LIMIT 1")

			
								return
							end
			
						end
			
					end
			
				end

			end

	end , connection , "SELECT * FROM cabinets")

end)

function dolapQuery(dim)

	

end