wPedRightClick = nil
bTalkToPed, bClosePedMenu = nil
ax, ay = nil
closing = nil
sent=false
localPlayer = getLocalPlayer()

function clickPed(button, state, absX, absY, wx, wy, wz, element)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if not element then
		local camX, camY, camZ = getCameraMatrix()
		local cursorX, cursorY, endX, endY, endZ = getCursorPosition()

		if not endX then return end -- Prevents a bug with inventory because the cursor is removed quickly.
		local x = {processLineOfSight(camX, camY, camZ, endX, endY, endZ, true, true, true, true, true, true, false, true, localPlayer, true)}
		local hit, _, _, _, _, _, _, _, mat, _, _, buildingId, bx, by, bz = unpack(x)
		if hit and isElement(buildingId) then
			element = buildingId
			outputDebugString("Used hack to get hidden element")
		end
	end
	if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") and (sent==false) and (element~=getLocalPlayer()) then
		rcMenu = false
		row = {}
		local interact = getElementData(element, "rpp.npc.type")
		local name = getElementData(element, "rpp.npc.name") or getElementData(element, "name") or "NPC"
		if (interact and interact ~= "false") then
			local x, y, z = getElementPosition(getLocalPlayer())

			if (getDistanceBetweenPoints3D(x, y, z, wx, wy, wz)<=3) then
				if (wPedRightClick) then
					hidePedMenu()
				end

				ax = absX
				ay = absY
				player = element
				closing = false

				--CITY HALL: RECEPTION (aka. Jessie Smith)
				if(interact == "ch.reception") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cityhall:jesped", getLocalPlayer())
					end, true)

				--CITY HALL: JOB PINBOARD
				elseif(interact == "ch.jobboard") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onEmployment", getLocalPlayer())
					end, true)

				--CITY HALL: LICENSE PLATES REGISTRATION
				elseif(interact == "ch.plates") then --City Hall: License plates registration
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cBeginPlate", getLocalPlayer(), element)
					end, true)

				--CITY HALL: BUSINESS REGISTRY
				elseif(interact == "ch.bizreg") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onRegistryPed", getLocalPlayer())
					end, true)

				--CITY HALL: POLITICAL PARTY REGISTRY
				elseif(interact == "ch.politics") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("onPoliticsPed", element)
					end, true)

				--BANK: Banking ped
				elseif(interact == "bank.banking") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("bank:showGeneralServiceGUI", getLocalPlayer(), getLocalPlayer(), element)
					end, true)

				--BANK: ATM cards ped
				elseif(interact == "bank.cards") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("bank-system:bankerInteraction", getLocalPlayer(), element)
					end, true)

				--FUEL STATION PED
				elseif(interact == "fuel") then --Fuel station ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("fuel:startConvo", element)
					end, true)

				--TOLL BOOTH PED
				elseif(interact == "toll") then --Toll booth ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("toll:startConvo", element)
					end, true)

				--SAN RECEPTION PED
				elseif(interact == "san.reception") then --SAN reception ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("toll:startConvo", element)
					end, true)


				--MISSION: STEVEN PULLMAN
				elseif(interact == "mission.pullman") then --Mission: Steven Pullman
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startStevieConvo", getLocalPlayer())
						if (getElementData(element, "activeConvo")~=1) then
							triggerEvent ( "stevieIntroEvent", getLocalPlayer()) -- Trigger Client side function to create GUI.
						end
					end, true)
				--MISSION: HUNTER
				elseif(interact == "mission.hunter") then --Mission: Hunter
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startHunterConvo", getLocalPlayer())
					end, true)
				--MISSION: ROOK
				elseif(interact == "mission.rook") then --Mission: Rook
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startRookConvo", getLocalPlayer())
					end, true)


				--DMV: GET DRIVERS LICENSE
				elseif(interact == "dmv.license") then --DMV: Get drivers license
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onLicense", getLocalPlayer(), element)
					end, true)

				--DMV: LICENSE PLATES REGISTRATION
				elseif(interact == "dmv.plates") then --City Hall: License plates registration
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cBeginPlate", getLocalPlayer(), element)
					end, true)

				--ELECTION PED
				elseif(interact == "election") then --Election ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Vote")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("electionWantVote", getLocalPlayer())
					end, true)

				--IMPOUND LOT PED
				elseif(interact == "impound") then --Impound lot ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("onTowMisterTalk", getLocalPlayer())
					end, true)

				--FAA: Theory Exams
				elseif(interact == "faa.theory") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onLicense", getLocalPlayer(), element)
					end, true)

				--CITY HALL: GUARD
				elseif(interact == "ch.guard") then --City Hall: guard
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("gateCityHall", getLocalPlayer())
					end, true)

				--GATEANGBASE (AIRMAN CONNOR)
				elseif(interact == "gateangbase") then --gateangbase (Airman Connor)
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent("gateAngBase", getLocalPlayer())
					end, true)

				--SFES RECEPTION PED
				elseif(interact == "sfes.reception") then --SFES: reception ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("lses:popupPedMenu", getLocalPlayer(), element)
					end, true)

				--Prison arrival
				elseif(interact == "prison.arrival") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("prison:prisonPedArrival", getLocalPlayer(), element)
					end, true)

				--Prison release
				elseif(interact == "prison.release") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("prison:prisonPedRelease", getLocalPlayer(), element)
					end, true)

				--MISSION: CLARICE
				elseif(interact == "mission.clarice") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerServerEvent( "startClariceConvo", getLocalPlayer())
					end, true)
					row.util = exports.vrp_rightclick:addrow("WooHoo_clarice")
					addEventHandler("onClientGUIClick", row.util,  function (button, state)
						local x,y,z = getElementPosition(element)
						local player = getLocalPlayer()
						setElementPosition(player, x, y, z)
						--setElementRotation(player, 266, 0, 0)
						setPedAnimation(element, "SEX", "SEX_1_Cum_W", -1, false, false)
						setPedAnimation(player, "SEX", "SEX_1_Cum_P", -1, false, false)
						setTimer(setPedAnimation, 7000, 1, player)
						setTimer(setPedAnimation, 7200, 1, element, "BEACH", "bather")
					end, true)

				--MISSION: CONSTRUCTION SITE JOB
				elseif(interact == "constructionwork") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("onConstructionJobPed", getLocalPlayer(), element)
					end, true)

				--CHRISTMAS: SANTA
				elseif(interact == "santa") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.get = exports.vrp_rightclick:addrow("Get Coke")
					addEventHandler("onClientGUIClick", row.get,  function (button, state)
						triggerServerEvent("item-system:santaGetCoke", getLocalPlayer(), element)
					end, true)
					if exports.vrp_global:hasItem(getLocalPlayer(), 211) then --has christmas lottery ticket
						row.claim = exports.vrp_rightclick:addrow("Claim Prize")
						addEventHandler("onClientGUIClick", row.claim,  function (button, state)
							triggerServerEvent("item-system:useChristmasLotteryTicket", getLocalPlayer(), element)
						end, true)
					end

				--ELECTIONS: Ped for vote GUI (anumaz)
				elseif(interact == "electionsped") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("elections:votegui", getLocalPlayer())
					end, true)

				--SFIA: Pilot mission (anumaz)
				elseif(interact == "pilotmission") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.getlisting = exports.vrp_rightclick:addrow("Get listing")
					addEventHandler("onClientGUIClick", row.getlisting, function ()
							triggerEvent("pilotmission:startGUI", getResourceRootElement( getResourceFromName("vrp_sfia") ))
						end, false)
					local temp_table = getElementData(getResourceRootElement( getResourceFromName("vrp_sfia") ), "sfia_pilots:table")
					local name = string.gsub(getPlayerName(getLocalPlayer()), "_", " ")
					for k, v in pairs(temp_table) do
						if v["charactername"] == name then
							row.gettask = exports.vrp_rightclick:addrow("Get task")
							addEventHandler("onClientGUIClick", row.gettask, function ()
									triggerEvent("pilotmission:domission", getResourceRootElement( getResourceFromName("vrp_sfia") ))
								end, false)
							break
						end
					end

				--K9 dog
				elseif(interact == "k9") then
					rcMenu = exports.vrp_rightclick:create(getElementData(element, "rpp.npc.name") or "Dog")
					if getElementData(element, "besitzer") == getPlayerName(getLocalPlayer()) then
						row.talk = exports.vrp_rightclick:addrow("Status")
						addEventHandler("onClientGUIClick", row.talk,  function (button, state)
							local currentStatus = getElementData(element, "k9:status")
							if currentStatus == 1 then
								setElementData(element, "k9:status", 0)
							elseif currentStatus == 0 then
								setElementData(element, "k9:status", 1)
							else
								setElementData(element, "k9:status", 1)
							end
						end, true)
					end

				--Locksmith
				elseif(interact == "locksmith") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("locksmithGUI", localPlayer, localPlayer)
					end, true)

				--FAA RECEPTION PED
				elseif(interact == "faa.reception") then --FAA: reception ped
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("airport:ped:receptionistFAA", getLocalPlayer(), element)
					end, true)

				--FAA: Gatekeeper LSA
				elseif(interact == "faa.gatekeeper.lsa") then --FAA: Gatekeeper LSA
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Konuş")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("airport:ped:LSAgatekeeper", getLocalPlayer(), element)
					end, true)

				--Cargo Group generic item spawn
				elseif(interact == "cargo.generics") then
					if getElementData(localPlayer, "loggedin") == 1 then
		                local allowedFactions = {56, 74, 104}
		                local factionID = false
		                for k,v in ipairs(allowedFactions) do
		                    local isIn, _, leader = exports.vrp_factions:isPlayerInFaction(localPlayer, v)
		                    if isIn and leader then
		                        factionID = v
		                        break
		                    end
		                end
						if factionID then
							rcMenu = exports.vrp_rightclick:create(name)
							row.talk = exports.vrp_rightclick:addrow("Konuş")
							addEventHandler("onClientGUIClick", row.talk,  function (button, state)
								triggerEvent("createCargoGUI", getLocalPlayer())
							end, true)
						end
					end

				--Shipping Order
				elseif(interact == "cargo.shippingorder") then
					rcMenu = exports.vrp_rightclick:create(name)
					row.talk = exports.vrp_rightclick:addrow("Shipping orders")
					addEventHandler("onClientGUIClick", row.talk,  function (button, state)
						triggerEvent("cargo:shippingOrderGUI", getLocalPlayer(), element)
					end, true)

				end --all elseif's for interact types goes overneath this line

				--STRETCHER SYSTEM
				local stretcherElement = getElementData(getLocalPlayer(), "realism:stretcher:hasStretcher")
				if stretcherElement then
					local stretcherPlayer =  getElementData( stretcherElement, "realism:stretcher:playerOnIt" )
					if stretcherPlayer and stretcherPlayer == player then
						if not rcMenu then
							rcMenu = exports.vrp_rightclick:create(name)
						end
						--bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Take from stretcher", true, wRightClick)
						row.stretcher = exports.vrp_rightclick:addrow("Take from stretcher")
						addEventHandler("onClientGUIClick", row.stretcher, function (button, state)
							triggerServerEvent("stretcher:takePedFromStretcher", getLocalPlayer(), element)
						end, false)
					end
					if not stretcherPlayer then
						if not rcMenu then
							rcMenu = exports.vrp_rightclick:create(name)
						end
						--bStabilize = guiCreateButton(0.05, y, 0.87, 0.1, "Lay on stretcher", true, wRightClick)
						row.stretcher = exports.vrp_rightclick:addrow("Lay on stretcher")
						addEventHandler("onClientGUIClick", row.stretcher, function (button, state)
							triggerServerEvent("stretcher:movePedOntoStretcher", getLocalPlayer(), element)
						end, false)
					end
				end


				--HEAL SYSTEM
				if(getElementHealth(element) < 50) then
					if exports.vrp_factions:isInFactionType(getLocalPlayer(), 4) then --if player is in ES faction and has a first aid kit
						if not rcMenu then
							rcMenu = exports.vrp_rightclick:create(name)
						end
						row.heal = exports.vrp_rightclick:addrow("Heal")
						addEventHandler("onClientGUIClick", row.heal, function (button, state)
							triggerServerEvent("peds:healPed", getLocalPlayer(), getLocalPlayer(), element)
						end, false)
					end
				end
			end
		else --if not interact

		end

		--ADMIN CMDS
		if (getElementData(element, "rpp.npc.dbid")) then
			if (exports.vrp_integration:isPlayerAdmin(localPlayer) and exports.vrp_global:isStaffOnDuty(localPlayer)) or exports.vrp_integration:isPlayerScripter(localPlayer) then
				--outputDebugString("spawnposdata: "..tostring(getElementData(element, "rpp.npc.spawnpos")))
				--if(getElementData(element, "rpp.npc.spawnpos")) then
					if not rcMenu then
						rcMenu = exports.vrp_rightclick:create(name)
					end
					--if getElementData(element, "dbid") then
						row.admEdit = exports.vrp_rightclick:addrow("ADM: Edit")
						addEventHandler("onClientGUIClick", row.admEdit, function (button, state)
							adminEditPedGui(element)
						end, false)
					--end

					row.respawn = exports.vrp_rightclick:addrow("ADM: Respawn")
					addEventHandler("onClientGUIClick", row.respawn, function (button, state)
						triggerServerEvent("peds:respawnPed", localPlayer, localPlayer, element)
					end, false)
				--end
			end
		else
			--[[if (exports.vrp_integration:isPlayerLeadAdmin(localPlayer) and exports.vrp_global:isStaffOnDuty(localPlayer)) or exports.vrp_integration:isPlayerScripter(localPlayer) then
				local name = getElementData(element, "rpp.npc.name")
				if not rcMenu then
					rcMenu = exports.vrp_rightclick:create(name or "NPC")
				end
				row.delete = exports.vrp_rightclick:addrow("ADM: Temporary delete ped")
				addEventHandler("onClientGUIClick", row.delete, function (button, state)
					triggerServerEvent("peds:deletePed", localPlayer, localPlayer, element)
				end, false)
			end
			--]]
		end

	end
end
addEventHandler("onClientClick", getRootElement(), clickPed, true)

function hidePedMenu()
	if (isElement(bTalkToPed)) then
		destroyElement(bTalkToPed)
	end
	bTalkToPed = nil

	if (isElement(bClosePedMenu)) then
		destroyElement(bClosePedMenu)
	end
	bClosePedMenu = nil

	if (isElement(wPedRightClick)) then
		destroyElement(wPedRightClick)
	end
	wPedRightClick = nil

	rcMenu = nil
	row = nil

	ax = nil
	ay = nil
	sent=false
	--showCursor(false)

end
