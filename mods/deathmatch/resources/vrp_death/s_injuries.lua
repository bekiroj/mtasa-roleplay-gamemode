local playerInjuries = {} -- create a table to save the injuries

function copy( t )
	local r = {}
	if type(t) == 'table' then
		for k, v in pairs( t ) do
			r[k] = v
		end
	end
	return r
end

function isMelee( weapon )
	return weapon and weapon <= 15
end

function killknockedout(source)
	setElementHealth(source, 0)
end

function knockout()
	if playerInjuries[source] and not isTimer( playerInjuries[source]['knockout'] ) then
		outputChatBox("You've been knocked out!", source, 255, 0, 0)
		toggleAllControls(source, false, true, false)
		triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
		fadeCamera(source, false, 120)
		playerInjuries[source]['knockout'] = setTimer(killknockedout, 120000, 1, source)
		
		exports.vrp_global:applyAnimation( source, "CRACK", "crckidle2", -1, true, false, true)
		exports.vrp_anticheat:changeProtectedElementDataEx(source, "injuriedanimation", true, false)
		exports.vrp_global:sendLocalMeAction(source, "has been knocked out.")
	end
end

function injuries(attacker, weapon, bodypart, loss)
	if not loss or loss < 0.5 then
		return
	end
	
	-- drowning
	if weapon == 53 then
		return
	end
	
	-- source = player who was hit
	if not bodypart and getPedOccupiedVehicle(source) then
		bodypart = 3
	end
	
	-- BODY ARMOR
	if bodypart == 3 and getPedArmor(source) > 0 then -- GOT (torso) PROTECTION?
		cancelEvent()
		return
	end

	-- katana kill
	if weapon == 8 then
		setPedHeadless(source, true)
		killPed(source, attacker, weapon, bodypart)
		return
	end

	-- 2% chance of melee knockout
	if isMelee( weapon ) then
		if math.random( 1, 50 ) == 1 then
			knockout()
		end
		return
	end
	if ( getElementHealth(source) < 20 or ( isElement( attacker ) and getElementType( attacker ) == "vehicle" and getElementHealth(source) < 40 ) ) and math.random( 1, 3 ) <= 2 then
		knockout()
	end
end
addEventHandler( "onPlayerDamage", getRootElement(), injuries )

function doHeadHit(headHitPlayer)
end
addEvent( "doHeadHit", true )
addEventHandler( "doHeadHit", getRootElement(), doHeadHit )

function stabilize()
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			exports.vrp_anticheat:changeProtectedElementDataEx(source, "injuriedanimation", false, false)
			if isTimer(playerInjuries[source]['knockout']) then
				killTimer(playerInjuries[source]['knockout'])
				playerInjuries[source]['knockout'] = nil
				
				fadeCamera(source, true, 2)
				setPedAnimation(source)
				exports.vrp_global:removeAnimation(source)

				toggleControl(source, 'forwards', true)
				toggleControl(source, 'left', true)
				toggleControl(source, 'right', true)
				toggleControl(source, 'backwards', true)
				toggleControl(source, 'enter_passenger', true)
				setElementHealth(source, math.max( 20, getElementHealth(source) ) )
			end
		end
		
		if playerInjuries[source][7] and playerInjuries[source][8] then
			toggleControl(source, 'forwards', true)
			toggleControl(source, 'left', true)
			toggleControl(source, 'right', true)
			toggleControl(source, 'backwards', true)
			toggleControl(source, 'enter_passenger', true)
		end
	end
end

addEvent( "onPlayerStabilize", false )
addEventHandler( "onPlayerStabilize", getRootElement(), stabilize )

function examine(to)
	local name = getPlayerName(source):gsub("_", " ")
	if isPedDead(source) then
		outputChatBox(name .. " is dead.", to, 255, 0, 0)
	elseif playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			outputChatBox(name.. " is knocked out.", to, 255, 255, 0)
		end

		if playerInjuries[source][7] and playerInjuries[source][8] then
			outputChatBox("Both of " .. name .. "s legs are broken.", to, 255, 255, 0)
		elseif playerInjuries[source][7] then
			outputChatBox(name .. "s left leg is broken.", to, 255, 255, 0)
		elseif playerInjuries[source][8] then
			outputChatBox(name .. "s right leg is broken.", to, 255, 255, 0)
		end

		if playerInjuries[source][5] and playerInjuries[source][6] then
			outputChatBox("Both of " .. name .. "s arms are broken.", to, 255, 255, 0)
		elseif playerInjuries[source][5] then
			outputChatBox(name .. "s left arm is broken.", to, 255, 255, 0)
		elseif playerInjuries[source][6] then
			outputChatBox(name .. "s right arm is broken.", to, 255, 255, 0)
		end
	else
		outputChatBox(name .. " is not injured.", to, 255, 255, 0)
	end
end

addEvent( "onPlayerExamine", false )
addEventHandler( "onPlayerExamine", getRootElement(), examine )

function healInjuries(healed)
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source]['knockout'] then
			exports.vrp_anticheat:changeProtectedElementDataEx(source, "injuriedanimation", false, false)
			if isTimer(playerInjuries[source]['knockout']) then
				killTimer(playerInjuries[source]['knockout'])
				playerInjuries[source]['knockout'] = nil
				
				if healed then
					fadeCamera(source, true, 2)
					setPedAnimation(source)
					exports.vrp_global:removeAnimation(source)
				end
			end
			toggleAllControls(source, true, true, false)
			triggerClientEvent(source, "onClientPlayerWeaponCheck", source)
		else
			if playerInjuries[source][7] and playerInjuries[source][8] then
				toggleControl(source, 'forwards', true) -- disable walking forwards for the player who was hit
				toggleControl(source, 'left', true)
				toggleControl(source, 'right', true)
				toggleControl(source, 'backwards', true)
				toggleControl(source, 'enter_passenger', true)
				toggleControl(source, 'enter_exit', true)
			end
			if playerInjuries[source][7] or playerInjuries[source][8] then
				toggleControl(source, 'sprint', true)
				toggleControl(source, 'jump', true)
			end
			
			if playerInjuries[source][5] and playerInjuries[source][6] then
				toggleControl(source, 'fire', true)
			end
			if playerInjuries[source][5] or playerInjuries[source][6] then
				toggleControl(source, 'aim_weapon', true)
				toggleControl(source, 'jump', true)
			end
		end
		playerInjuries[source] = nil
	end
end

addEvent( "onPlayerHeal", false ) -- add a new event for it (called from /heal)
addEventHandler( "onPlayerHeal", getRootElement(), healInjuries)

function restoreInjuries( )
	if playerInjuries[source] and not isPedHeadless(source) then
		if playerInjuries[source][7] and playerInjuries[source][8] then
			toggleControl(source, 'forwards', false)
			toggleControl(source, 'left', false)
			toggleControl(source, 'right', false)
			toggleControl(source, 'backwards', false)
			toggleControl(source, 'enter_passenger', false)
			toggleControl(source, 'enter_exit', false)
		end
		if playerInjuries[source][7] or playerInjuries[source][8] then
			toggleControl(source, 'sprint', false)
			toggleControl(source, 'jump', false)
		end
		
		if playerInjuries[source][5] and playerInjuries[source][6] then
			toggleControl(source, 'fire', false)
		end
		if playerInjuries[source][5] or playerInjuries[source][6] then
			toggleControl(source, 'aim_weapon', false)
			toggleControl(source, 'jump', false)
		end
	end
end
addEventHandler( "onPlayerStopAnimation", getRootElement(), restoreInjuries )

function resetInjuries() -- it actually has some parameters, but we only need source right now - the wiki explains them though
	setPedHeadless(source, false)

	if playerInjuries[source] then
		-- reset injuries
		healInjuries()
	end
end

addEventHandler( "onPlayerSpawn", getRootElement(), resetInjuries) -- make sure old injuries don't carry over
addEventHandler( "onPlayerQuit", getRootElement(), resetInjuries) -- cleanup when the player quits

function lvesHeal(thePlayer, commandName, targetPartialNick, price)
	if not (targetPartialNick) or not (price) then -- if missing target player arg.
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Price of Heal]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPartialNick)
		if targetPlayer then -- is the player online?
			local logged = getElementData(thePlayer, "loggedin")
	
			if (logged==1) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if not (factionType==4) then
					outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				elseif (targetPlayer == thePlayer) then
					outputChatBox("You cannot heal yourself.", thePlayer, 255, 0, 0)
				elseif (isPedDead(targetPlayer)) then
					outputChatBox("This person is dead!", thePlayer, 255, 0, 0)
				else
					price = tonumber(price)
					if price > 500 then
						outputChatBox("This is too much to ask for.", thePlayer, 255, 0, 0)
					else
						local x, y, z = getElementPosition(thePlayer)
						local tx, ty, tz = getElementPosition(targetPlayer)
						
						if (getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)>3) then -- Are they standing next to each other?
							outputChatBox("You are too far away to heal '".. targetPlayerName .."'.", thePlayer, 255, 0, 0)
						else
							local foundkit, slot, itemValue = exports.vrp_global:hasItem(thePlayer, 70)
							if (foundkit) then
								local money = exports.vrp_global:getMoney(targetPlayer)
								local bankmoney = getElementData(targetPlayer, "bankmoney")
								
								if money + bankmoney < price then
									outputChatBox("The player cannot afford the heal.", thePlayer, 255, 0, 0)
								else
									local takeFromCash = math.min( money, price )
									local takeFromBank = price - takeFromCash
									exports.vrp_global:takeMoney(targetPlayer, takeFromCash)
									if takeFromBank > 0 then
										exports.vrp_anticheat:changeProtectedElementDataEx(targetPlayer, "bankmoney", bankmoney - takeFromBank, false)
									end
									
									local tax = exports.vrp_global:getTaxAmount()
									
									exports.vrp_global:giveMoney( getTeamFromName("Los Santos Medical Department"), math.ceil((1-tax)*price) )
									exports.vrp_global:giveMoney( getTeamFromName("Government of Los Santos"), math.ceil(tax*price) )
									
									setElementHealth(targetPlayer, 100)
									triggerEvent("onPlayerHeal", targetPlayer, true)
									outputChatBox("You healed '" ..targetPlayerName.. "'.", thePlayer, 0, 255, 0)
									outputChatBox("You have been healed by '" ..getPlayerName(thePlayer).. "' for $" .. price .. ".", targetPlayer, 0, 255, 0)
									exports.vrp_logs:dbLog(thePlayer, 35, targetPlayer, "HEAL FOR $" .. price)
									
									if itemValue > 1 then
										exports['item-system']:updateItemValue(thePlayer, slot, itemValue - 1)
									else
										exports.vrp_global:takeItem(thePlayer, 70, itemValue)
										if not exports.vrp_global:hasItem(thePlayer, 70) then
											outputChatBox("Warning, you're out of first aid kits. re /duty to get new ones.", thePlayer, 255, 0, 0)
										end
									end
								end
							else
								outputChatBox("You need a first aid kit to heal people.", thePlayer, 255, 0, 0)
							end
						end
					end
				end
			end
		end
	end
end
addCommandHandler("heal", lvesHeal, false, false)