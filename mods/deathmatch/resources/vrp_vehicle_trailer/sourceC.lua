local screenX, screenY = guiGetScreenSize()

function respc(num)
	return math.ceil(num * responsiveMultipler)
end

local havePermission = {}
local activeButton = false

local RAMP_DEFAULT_POSITION = {0.78211838006973, -2.5830059051514, -0.085817605257034}
local RAMP_DEFAULT_ROTATION = {0, 0, 0}

local rampState = {}
local rampAnimation = {}
local rampInAnim = {}

local myTowTruck = false
local cableHolder = {}
local ratchet = {}
local cableAttachment = {}

local detectorColShape = false

local carAnimation = {}
local carInAnim = {}

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		havePermission.impoundTow = true
		havePermission.impoundTowFinal = true

		for k, v in pairs(getElementsByType("vehicle", true, getRootElement())) do
			if getElementModel(v) == TRUCK_MODEL then
				cableHolder[v] = getElementData(v, "cableHolder")

				rampState[v] = getElementData(v, "packerState") or "up"
				rampInAnim[v] = false

				if rampState[v] == "down" then
					setVehicleComponentPosition(v, "ramp", RAMP_DEFAULT_POSITION[1], RAMP_DEFAULT_POSITION[2] - 3.7, RAMP_DEFAULT_POSITION[3] - 0.135)
					setVehicleComponentRotation(v, "ramp", 20, 0, 0)
				else
					setVehicleComponentPosition(v, "ramp", unpack(RAMP_DEFAULT_POSITION))
					setVehicleComponentRotation(v, "ramp", unpack(RAMP_DEFAULT_ROTATION))
				end
			end
		end
	end
)

addEventHandler("onClientElementStreamIn", getRootElement(),
	function ()
		if getElementModel(source) == TRUCK_MODEL then
			rampState[source] = getElementData(source, "packerState") or "up"
			rampInAnim[source] = false

			if rampState[source] == "down" then
				setVehicleComponentPosition(source, "ramp", RAMP_DEFAULT_POSITION[1], RAMP_DEFAULT_POSITION[2] - 3.7, RAMP_DEFAULT_POSITION[3] - 0.135)
				setVehicleComponentRotation(source, "ramp", 20, 0, 0)
			elseif rampState[source] == "up" then
				setVehicleComponentPosition(source, "ramp", unpack(RAMP_DEFAULT_POSITION))
				setVehicleComponentRotation(source, "ramp", unpack(RAMP_DEFAULT_ROTATION))
			end

			for k, v in pairs(rampAnimation) do
				if v.vehicle == source then
					for i = 1, #rampAnimation[k].parts do
						if isElement(rampAnimation[k].parts[i].sound) then
							destroyElement(rampAnimation[k].parts[i].sound)
						end
					end

					rampAnimation[k] = nil
				end
			end
		end
	end
)

addEventHandler("onClientPlayerVehicleEnter", localPlayer,
	function (vehicle)
		if havePermission.impoundTow then
			if getElementModel(vehicle) == TRUCK_MODEL then
				if isElement(detectorColShape) then
					destroyElement(detectorColShape)
				end

				detectorColShape = createColSphere(0, 0, 0, 10)
				attachElements(detectorColShape, vehicle, 0, -10, 0)
			end
		end
	end
)

addEventHandler("onClientPlayerVehicleExit", localPlayer,
	function (vehicle)
		if isElement(detectorColShape) then
			destroyElement(detectorColShape)
		end

		detectorColShape = nil
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldVal)
		if dataName == "cableAttachment" then
			cableAttachment[source] = getElementData(source, "cableAttachment")
		end

		if dataName == "cableHolder" then
			cableHolder[source] = getElementData(source, "cableHolder")

			if oldVal == localPlayer then
				myTowTruck = false

				if isElement(detectorColShape) then
					destroyElement(detectorColShape)
				end

				detectorColShape = nil
			end

			if cableHolder[source] == localPlayer then
				myTowTruck = source

				detectorColShape = createColSphere(0, 0, 0, 10)
				attachElements(detectorColShape, source, 0, -10, 0)

				playSound("files/ratchet.mp3")
			end

			if isElement(cableHolder[source]) then
				if getElementType(cableHolder[source]) == "vehicle" then
					local x, y, z = getElementPosition(cableHolder[source])
					local sound = playSound3D("files/couple.mp3", x, y, z)

					if isElement(sound) then
						setElementDimension(sound, getElementDimension(cableHolder[source]))
					end
				end
			end
		end

		if dataName == "packerState" then
			local vx, vy, vz = getElementPosition(source)
			local cx, cy, cz = getVehicleComponentPosition(source, "ramp")

			setElementPosition(source, vx, vy, vz + 0.001)
			setElementPosition(source, vx, vy, vz - 0.001)

			rampState[source] = getElementData(source, "packerState")
			rampInAnim[source] = true

			local effect = {
				startTime = getTickCount(),
				easing = "InOutQuad",
				vehicle = source,
				parts = {},
				current = 1
			}

			if rampState[source] == "down" then
				table.insert(effect.parts, {
					duration = SLIDE_ANIMATION_TIME,
					startPos = {cx, cy, cz},
					startRot = {0, 0, 0},
					endPos = {cx, cy - 3.7, cz},
					endRot = {0, 0, 0},
					sound = "slide"
				})

				table.insert(effect.parts, {
					duration = ROTATE_ANIMATION_TIME,
					startPos = effect.parts[1].endPos,
					startRot = effect.parts[1].endRot,
					endPos = {cx, cy - 3.7, cz - 0.135},
					endRot = {20, 0, 0},
					sound = "rotdown"
				})
			end

			if rampState[source] == "up" then
				table.insert(effect.parts, {
					duration = ROTATE_ANIMATION_TIME,
					startPos = {cx, cy, cz},
					startRot = {20, 0, 0},
					endPos = {cx, cy, cz + 0.135},
					endRot = {0, 0, 0},
					sound = "rotup"
				})

				table.insert(effect.parts, {
					duration = SLIDE_ANIMATION_TIME,
					startPos = effect.parts[1].endPos,
					startRot = effect.parts[1].endRot,
					endPos = {cx, cy + 3.7, cz + 0.135},
					endRot = {0, 0, 0},
					sound = "slide"
				})
			end

			table.insert(rampAnimation, effect)
		end

		if dataName == "carAnimation" then
			local dataVal = getElementData(source, "carAnimation")

			carInAnim[source] = nil

			if dataVal then
				carAnimation[source] = dataVal
				carInAnim[source] = true

				local vehPosX, vehPosY, vehPosZ = getElementPosition(source)
				local vehRotX, vehRotY, vehRotZ = getElementRotation(source)

				local towPosX, towPosY, towPosZ = getElementPosition(carAnimation[source][1])
				local towRotX, towRotY, towRotZ = getElementRotation(carAnimation[source][1])

				local rampX, rampY, rampZ = getVehicleComponentPosition(carAnimation[source][1], "ramp")
				local targetPosX, targetPosY, targetPosZ = getPositionFromElementOffset(carAnimation[source][1], 0, rampY - 1.75, rampZ)
				local dist = getElementDistanceFromCentreOfMassToBaseOfModel(source)

				targetPosZ = targetPosZ + dist / 2 + 0.135

				local targetRotX, targetRotY, targetRotZ = towRotX, towRotY, towRotZ

				if cableAttachment[source] == "rear" then
					targetRotX = targetRotX - 20
					targetRotZ = (targetRotZ + 180) % 360
				else
					targetRotX = targetRotX + 20
				end

				local effect = {
					startTime = getTickCount(),
					easing = "InOutQuad",
					vehicle = source,
					towedBy = carAnimation[source][1],
					parts = {},
					current = 1,
					managedBy = carAnimation[source][3]
				}

				if carAnimation[source][2] == "up" then
					table.insert(effect.parts, {
						duration = CAR_ANIMATION_TIME,
						startPos = {vehPosX, vehPosY, vehPosZ},
						startRot = {vehRotX, vehRotY, vehRotZ},
						endPos = {targetPosX, targetPosY, targetPosZ},
						endRot = {targetRotX, targetRotY, targetRotZ},
						sound = "winch"
					})

					local flatbedX, flatbedY, flatbedZ = getPositionFromElementOffset(effect.towedBy, 0, -2.425, 0.3)

					table.insert(effect.parts, {
						duration = CAR_ANIMATION_TIME,
						startPos = effect.parts[1].endPos,
						startRot = effect.parts[1].endRot,
						endPos = {flatbedX, flatbedY, flatbedZ + dist},
						endRot = {towRotX, towRotY, effect.parts[1].endRot[3]},
						sound = "winch",
						type = "attach",
					})
				end

				if carAnimation[source][2] == "down" then
					table.insert(effect.parts, {
						duration = CAR_ANIMATION_TIME,
						startPos = {vehPosX, vehPosY, vehPosZ},
						startRot = {vehRotX, vehRotY, vehRotZ},
						endPos = {targetPosX, targetPosY, targetPosZ},
						endRot = {targetRotX, targetRotY, targetRotZ},
						sound = "winch",
						type = "pre-detach"
					})

					local _, _, minZ = getElementBoundingBox(effect.towedBy)
					local groundX, groundY, groundPreZ = getPositionFromElementOffset(effect.towedBy, 0, -13, minZ)
					local groundZ = getGroundPosition(groundX, groundY, groundPreZ)
					local waterZ = getWaterLevel(groundX, groundY, groundZ)
					--local _, _, minZ = getElementBoundingBox(source)

					table.insert(effect.parts, {
						duration = CAR_ANIMATION_TIME,
						startPos = effect.parts[1].endPos,
						startRot = effect.parts[1].endRot,
						endPos = {groundX, groundY, groundZ + dist},
						endRot = {towRotX, towRotY, effect.parts[1].endRot[3]},
						sound = "winch",
						type = "detach",
					})
				end

				table.insert(carAnimation, effect)
			end
		end
	end
)

function getVehicleSpeed(vehicle)
	if isElement(vehicle) then
		local vx, vy, vz = getElementVelocity(vehicle)
		return (vx*vx + vy*vy + vz*vz) ^ 0.5 * 187.5
	end
	return 9999
end

function getShortestAngle(start, stop, amount)
	local shortest_angle = ((((stop - start) % 360) + 540) % 360) - 180
	return start + (shortest_angle * amount) % 360
end

function interpolateRotation(x1, y1, z1, x2, y2, z2, progress, easingType, ...)
	local x3, y3, z3 = 0, 0, 0

	if progress < 0 then
		progress = 0
	elseif progress > 1 then
		progress = 1
	end

	progress = getEasingValue(progress, easingType or "Linear", ...)

	if x1 ~= 0 and x2 ~= 0 then
		x3 = getShortestAngle(x1, x2, progress)
	end

	if y1 ~= 0 and y2 ~= 0 then
		y3 = getShortestAngle(y1, y2, progress)
	end

	if z1 ~= 0 and z2 ~= 0 then
		z3 = getShortestAngle(z1, z2, progress)
	end

	return x3, y3, z3
end

function findAttachOffsets(vehicle, towedBy)
	local frRotX, frRotY, frRotZ = getElementRotation(vehicle)
	local toRotX, toRotY, toRotZ = getElementRotation(towedBy)
	local dist = getElementDistanceFromCentreOfMassToBaseOfModel(vehicle)
	return 0, -2.425, 0.3 + dist, 0, 0, frRotZ - toRotZ
end

addEventHandler("onClientPreRender", getRootElement(),
	function ()
		local currentTime = getTickCount()

		for k, v in pairs(carAnimation) do
			if v.parts and v.current then
				local dat = v.parts[v.current]

				if isElement(v.vehicle) and isElement(v.towedBy) then
					local elapsedTime = currentTime - v.startTime
					local progress = elapsedTime / dat.duration

					local x, y, z = unpack(dat.startPos)
					local rx, ry, rz = unpack(dat.startRot)

					if dat.type == "attach" then
						x, y = interpolateBetween(
							dat.startPos[1], dat.startPos[2], 0,
							dat.endPos[1], dat.endPos[2], 0,
							progress, v.easing
						)

						z = interpolateBetween(
							dat.startPos[3], 0, 0,
							dat.endPos[3], 0, 0,
							elapsedTime / (dat.duration - 1500), v.easing
						)

						rx = interpolateRotation(
							dat.startRot[1], 0, 0,
							dat.endRot[1], 0, 0,
							elapsedTime / (dat.duration - 1000), v.easing
						)

						ry, rz = interpolateRotation(
							dat.startRot[2], dat.startRot[3], 0,
							dat.endRot[2], dat.endRot[3], 0,
							progress, v.easing
						)
					elseif dat.type == "pre-detach" then
						x, y = interpolateBetween(
							dat.startPos[1], dat.startPos[2], 0,
							dat.endPos[1], dat.endPos[2], 0,
							progress, v.easing
						)

						ry, rz = interpolateRotation(
							dat.startRot[2], dat.startRot[3], 0,
							dat.endRot[2], dat.endRot[3], 0,
							progress, v.easing
						)

						elapsedTime = elapsedTime - 1000

						if elapsedTime > 0 then
							rx = interpolateRotation(
								dat.startRot[1], 0, 0,
								dat.endRot[1], 0, 0,
								elapsedTime / (dat.duration - 1000), v.easing
							)
						end

						elapsedTime = elapsedTime - 500

						if elapsedTime > 0 then
							z = interpolateBetween(
								dat.startPos[3], 0, 0,
								dat.endPos[3], 0, 0,
								elapsedTime / (dat.duration - 1500),
								v.easing
							)
						end
					else
						x, y, z = interpolateBetween(
							dat.startPos[1], dat.startPos[2], dat.startPos[3],
							dat.endPos[1], dat.endPos[2], dat.endPos[3],
							progress, v.easing
						)

						rx, ry, rz = interpolateRotation(
							dat.startRot[1], dat.startRot[2], dat.startRot[3],
							dat.endRot[1], dat.endRot[2], dat.endRot[3],
							progress, v.easing
						)
					end

					if dat.sound then
						if type(dat.sound) == "string" then
							dat.sound = playSound3D("files/" .. dat.sound .. ".mp3", getElementPosition(v.towedBy))
						end
					end

					setElementPosition(v.vehicle, x, y, z)
					setElementRotation(v.vehicle, rx, ry, rz)
					setElementVelocity(v.vehicle, 0, 0, 0)

					if isElement(dat.sound) then
						setElementPosition(dat.sound, getPositionFromElementOffset(v.towedBy, 0, 0.75, 0.5))
					end

					if progress > 1 then
						if isElement(dat.sound) then
							destroyElement(dat.sound)
						end

						if v.parts[v.current + 1] then
							v.startTime = getTickCount()
							v.current = v.current + 1
						else
							if dat.type == "attach" then
								if isElementSyncer(v.vehicle) then -- ha a localPlayer a jármű syncere, syncelje a többi kliens felé
									setElementData(v.vehicle, "carPlacedOnTruck", {v.towedBy, findAttachOffsets(v.vehicle, v.towedBy)})
								end
							elseif dat.type == "detach" then
								setElementCollisionsEnabled(v.vehicle, true)
								setElementFrozen(v.vehicle, false)

								local x, y, z = getElementPosition(v.vehicle)

								setElementPosition(v.vehicle, x, y, z + 0.001)
								setElementPosition(v.vehicle, x, y, z)
								setElementVelocity(v.vehicle, 0, 0, 0.05)
							end

							carAnimation[k] = nil
							carInAnim[v.vehicle] = false
						end
					end
				else
					carAnimation[k] = nil
				end
			end
		end

		for k, v in pairs(rampAnimation) do
			if v.parts and v.current then
				local dat = v.parts[v.current]

				if isElement(v.vehicle) then
					local elapsedTime = currentTime - v.startTime
					local progress = elapsedTime / dat.duration

					local x, y, z = interpolateBetween(
						dat.startPos[1], dat.startPos[2], dat.startPos[3],
						dat.endPos[1], dat.endPos[2], dat.endPos[3],
						progress, v.easing
					)

					local rx, ry, rz = interpolateBetween(
						dat.startRot[1], dat.startRot[2], dat.startRot[3],
						dat.endRot[1], dat.endRot[2], dat.endRot[3],
						progress, v.easing
					)

					if dat.sound then
						if type(dat.sound) == "string" then
							dat.sound = playSound3D("files/" .. dat.sound .. ".mp3", getElementPosition(v.vehicle))
						end
					end

					if progress > 1 then
						if isElement(dat.sound) then
							destroyElement(dat.sound)
						end

						if v.parts[v.current + 1] then
							v.startTime = getTickCount()
							v.current = v.current + 1
						else
							rampAnimation[k] = nil
							rampInAnim[v.vehicle] = false
						end
					end

					setVehicleComponentPosition(v.vehicle, "ramp", x, y, z)
					setVehicleComponentRotation(v.vehicle, "ramp", rx, ry, rz)

					if isElement(dat.sound) then
						setElementPosition(dat.sound, getVehicleComponentPosition(v.vehicle, "ramp", "world"))
					end
				else
					rampAnimation[k] = nil
				end
			end
		end

		local px, py, pz = getElementPosition(localPlayer)

		for veh, holder in pairs(cableHolder) do
			if isElement(veh) then
				if isElement(holder) then
					if isElementStreamedIn(holder) then
						if isElementOnScreen(veh) or isElementOnScreen(holder) then
							local vx, vy, vz = getElementPosition(veh)
							local dist = getDistanceBetweenPoints3D(px, py, pz, vx, vy, vz)

							if dist <= 100 then
								local holdertype = getElementType(holder)

								if holdertype == "vehicle" then
									local side = cableAttachment[holder]

									if side then
										local wx, wy, wz = getPositionFromElementOffset(veh, 0.25, 0.75, 0.5)
										local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(holder)
										local cx, cy, cz = false, false, false

										if side == "front" then
											cx, cy, cz = getPositionFromElementOffset(holder, 0, maxY - 0.15, minZ + maxZ / 2)
										else
											cx, cy, cz = getPositionFromElementOffset(holder, 0, -maxY, minZ + maxZ / 2)
										end

										if cx and cy and cz then
											if cz < wz then
												local x1, y1, z1 = getPositionFromElementOffset(veh, 0, -1.15, 0.5)
												local x2, y2, z2 = getPositionFromElementOffset(veh, 0, -3.7, 0.5)

												dxDrawLine3D(wx, wy, wz, x1, y1, z1, tocolor(25, 25, 25), 3)
												dxDrawLine3D(x1, y1, z1, x2, y2, z2, tocolor(25, 25, 25), 3)

												wx, wy, wz = x2, y2, z2
											end

											if cz < wz then
												local sx, sy = getPositionFromElementOffset(veh, FLATBED_OFFSETS[3][1], FLATBED_OFFSETS[3][2], 0)
												local ex, ey = getPositionFromElementOffset(veh, FLATBED_OFFSETS[3][3], FLATBED_OFFSETS[3][4], 0)
												local tx, ty = linesIntersect(wx, wy, cx, cy, sx, sy, ex, ey)

												if tx then
													dxDrawLine3D(wx, wy, wz, tx, ty, wz, tocolor(25, 25, 25), 3)
													wx, wy = tx, ty
												end
											end

											dxDrawLine3D(wx, wy, wz, cx, cy, cz, tocolor(25, 25, 25), 3)
										end
									end
								elseif holdertype == "player" then
									-- Racsni
									local x, y, z = getPositionFromElementOffset(veh, 0, 0.75, 0.5)
									local speedx, speedy, speedz = getElementVelocity(holder)
									local actualspeed = (speedx*speedx + speedy*speedy + speedz*speedz) ^ 0.5

									if dist <= 20 and actualspeed > 0 then
										if currentTime >= (ratchet[veh] or 0) then
											local sound = playSound3D("files/ratchet.mp3", x, y, z)

											if isElement(sound) then
												setElementDimension(sound, getElementDimension(veh))
											end

											ratchet[veh] = currentTime + 175 - actualspeed * 750
										end
									end

									-- Vontató kábel
									local x, y, z = getPositionFromElementOffset(veh, 0.25, 0.75, 0.5)
									local bx, by, bz = getPedBonePosition(holder, 25)

									if bx then
										local x1, y1, z1 = getPositionFromElementOffset(veh, 0, -1.15, 0.5)
										local x2, y2, z2 = getPositionFromElementOffset(veh, 0, -3.7, 0.5)

										local dist1 = getDistanceBetweenPoints2D(bx, by, x1, y1)
										local dist2 = getDistanceBetweenPoints2D(bx, by, x2, y2)
										local diff = dist2 - dist1

										if diff <= 0.75 then
											dxDrawLine3D(x, y, z, x1, y1, z1, tocolor(25, 25, 25), 3)
											x, y, z = x1, y1, z1
										end

										if diff <= -1.75 then
											dxDrawLine3D(x, y, z, x2, y2, z2, tocolor(25, 25, 25), 3)
											x, y, z = x2, y2, z2
										end

										for i = 1, 4 do
											local sx, sy = getPositionFromElementOffset(veh, FLATBED_OFFSETS[i][1], FLATBED_OFFSETS[i][2], 0)
											local ex, ey = getPositionFromElementOffset(veh, FLATBED_OFFSETS[i][3], FLATBED_OFFSETS[i][4], 0)
											local tx, ty = linesIntersect(x, y, bx, by, sx, sy, ex, ey)

											if tx then
												if i == 4 then
													if holder == localPlayer then
														outputChatBox("Kablo buradan geçemez!", 255, 255, 255, true)
													end

													myTowTruck = false
													cableHolder[veh] = nil
													setElementData(veh, "cableHolder", false)

													return
												end

												dxDrawLine3D(x, y, z, tx, ty, z, tocolor(25, 25, 25), 3)
												x, y = tx, ty

												break
											end
										end

										dxDrawLine3D(x, y, z, bx, by, bz, tocolor(25, 25, 25), 3)
									end
								end
							end
						end
					end
				end
			end
		end

		if isElement(myTowTruck) then
			local tx, ty, tz = getElementPosition(myTowTruck)

			if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) > 20 then
				outputChatBox("Kablo bu kadar uzağa ulaşmıyor!", 255, 0, 0, true)
				setElementData(myTowTruck, "cableHolder", false)
				cableHolder[myTowTruck] = nil
				myTowTruck = false
				return
			end
		end
	end
)

addEventHandler("onClientKey", getRootElement(),
	function (key, press)
		if isPedInVehicle(localPlayer) and getPedOccupiedVehicleSeat(localPlayer) == 0 then
			local theVeh = getPedOccupiedVehicle(localPlayer)

			if getElementModel(theVeh) == TRUCK_MODEL then
				local state = getElementData(theVeh, "packerState") or "up"

				if state ~= "up" then
					local task = getPedSimplestTask(localPlayer)

					if task == "TASK_SIMPLE_CAR_GET_OUT" or task == "TASK_SIMPLE_CAR_CLOSE_DOOR_FROM_OUTSIDE" then
						return
					end

					local keys = {}

					for k, v in pairs(getBoundKeys("accelerate")) do
						table.insert(keys, k)
					end

					for k, v in pairs(getBoundKeys("brake_reverse")) do
						table.insert(keys, k)
					end

					for k, v in pairs(keys) do
						if v == key then
							cancelEvent()

							if press then
								outputChatBox("Önce rampayı çekin!", 255, 255, 255, true)
							end
						end
					end
				end
			end
		end

		if panelState then
			if impoundedVehicles then
				if key == "mouse_wheel_up" then
					if offsetVeh > 0 then
						offsetVeh = offsetVeh - 1
					end
				elseif key == "mouse_wheel_down" then
					if offsetVeh < #impoundedVehicles - 12 then
						offsetVeh = offsetVeh + 1
					end
				end
			end
		end
	end
)

addEventHandler("onClientClick", getRootElement(),
	function (button, state, absX, absY, worldX, worldY, worldZ, clickedElement)
		if button == "left" then
			if state == "down" then
				if havePermission.impoundTow then
					if activeButton then
						local veh = activeButton[1]
						local key = activeButton[2]

						if not rampInAnim[veh] then
							if key == "cardown" then
								if getElementData(veh, "packerState") == "down" then
									local currentHolder = getElementData(veh, "cableHolder")

									if currentHolder then
										setElementData(currentHolder, "carAnimation", {veh, "down", localPlayer})
										setElementData(currentHolder, "carPlacedOnTruck", false)
									end
								else
									outputChatBox("Önce rampayı bırakın!", 255, 255, 255, true)
								end
							elseif key == "carup" then
								if getElementData(veh, "packerState") == "down" then
									local currentHolder = getElementData(veh, "cableHolder")

									if currentHolder then
										setElementData(currentHolder, "carAnimation", {veh, "up", localPlayer})
									end
								else
									outputChatBox("Önce rampayı bırakın!", 255, 255, 255, true)
								end
							elseif key == "cardisc" then
								if getElementData(veh, "packerState") == "down" then
									local currentHolder = getElementData(veh, "cableHolder")

									if currentHolder then
										setElementData(currentHolder, "cableAttachment", false)
										setElementData(veh, "cableHolder", localPlayer)
										setElementData(veh, "carAnimation", false)
									end
								else
									outputChatBox("Önce rampayı bırakın!", 255, 255, 255, true)
								end
							elseif key == "winch" then
								if getElementData(veh, "packerState") == "down" then
									local currentHolder = getElementData(veh, "cableHolder")

									if isElement(currentHolder) then
										if currentHolder == localPlayer then
											setElementData(veh, "cableHolder", false)
										end
									else
										setElementData(veh, "cableHolder", localPlayer)
									end
								else
									outputChatBox("Önce rampayı bırakın!", 255, 255, 255, true)
								end
							else
								setElementData(veh, "packerState", key)
								triggerServerEvent("playPackerRampAnim", localPlayer, veh)
							end
						end
					elseif myTowTruck then
						if isElement(clickedElement) then
							if clickedElement ~= myTowTruck then
								if getElementType(clickedElement) == "vehicle" then
									if getVehicleType(clickedElement) == "Automobile" then
										local px, py, pz = getElementPosition(localPlayer)
										local tx, ty, tz = getElementPosition(clickedElement)

										if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) <= 5 then
											local x, y, z = getPositionFromElementOffset(myTowTruck, 0, -13, 0)
											local dist = getDistanceBetweenPoints3D(x, y, z, tx, ty, tz)

											if isInsideColShape(detectorColShape, x, y, z) and dist <= 2.5 then
												if not getElementData(clickedElement, "cableAttachment") then
													local x, y, z = getElementPosition(myTowTruck)
													local rx, ry, rz = getElementRotation(clickedElement)
													local angle = math.deg(math.atan2(y - ty, x - tx)) + 180 - rz

													if angle < 0 then
														angle = angle + 360
													end

													setElementData(myTowTruck, "cableHolder", clickedElement)

													if angle >= 0 and angle <= 180 then
														setElementData(clickedElement, "cableAttachment", "rear")
													else
														setElementData(clickedElement, "cableAttachment", "front")
													end

													myTowTruck = false
												end
											else
												outputChatBox("Araba, araba taşıyıcısının arkasında değil!", 255, 255, 255, true)
											end
										else
											outputChatBox("Araçtan çok uzaktasınız!", 255, 255, 255, true)
										end
									else
										outputChatBox("Sadece araba rezervasyonu yapabilirsiniz.", 255, 255, 255, true)
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

addEvent("openUnImpoundPanel", true)
addEventHandler("openUnImpoundPanel", getRootElement(),
	function (vehs)
		if vehs and type(vehs) == "table" then
			impoundedVehicles = vehs

			for k, v in pairs(vehs) do
				impoundedVehicles[k].gtaModelName = getVehicleNameFromModel(v.modelId)
				impoundedVehicles[k].realModelName = getVehicleNameFromModel(v.modelId)
			end

			togglePanel(true)
		end
	end
)

function togglePanel(state)
	if state ~= panelState then
		if state then
			panelState = true
			panelFont = dxCreateFont("files/Roboto.ttf", respc(12), false, "antialiased")
		else
			impoundedVehicles = {}
			panelState = false

			if isElement(panelFont) then
				destroyElement(panelFont)
			end

			panelFont = nil
		end
	end
end

addEventHandler("onClientRender", getRootElement(),
	function ()
		if activeButton and not panelState then
			activeButton = false
		end

		if havePermission.impoundTow then
			local relX, relY = getCursorPosition()
			local absX, absY = -1, -1

			if relX then
				absX = relX * screenX
				absY = relY * screenY
			end

			local px, py, pz = getElementPosition(localPlayer)
			local camx, camy, camz = getCameraMatrix()

			if isElement(detectorColShape) then
				local theTruck = myTowTruck

				if not theTruck then
					theTruck = getPedOccupiedVehicle(localPlayer)
				end

				if isElement(theTruck) and getVehicleSpeed(theTruck) < 40 then
					local tx, ty, tz = getPositionFromElementOffset(theTruck, 0, -13, 0)
					local holder = cableHolder[theTruck]

					local vehicles = getElementsWithinColShape(detectorColShape, "vehicle")
					local detected = 0
					local nearbyCar = false

					for i = 1, #vehicles do
						local veh = vehicles[i]

						if isElement(veh) then
							if getVehicleType(veh) == "Automobile" then
								if getElementModel(veh) ~= TRUCK_MODEL then
									if not cableAttachment[veh] then
										local vx, vy, vz = getElementPosition(veh)
										local dist = getDistanceBetweenPoints3D(tx, ty, tz, vx, vy, vz)

										if dist <= 2.5 then
											if not nearbyCar then
												nearbyCar = veh
											end
										end

										detected = detected + 1
									end
								end
							end
						end
					end

					if detected > 0 then
						local sx, sy = getScreenFromWorldPosition(tx, ty, tz)

						if sx and sy then
							local dist = getDistanceBetweenPoints3D(camx, camy, camz, tx, ty, tz)
							local oneSize = 128 * (1 - dist / 64)

							if isElement(nearbyCar) then
								dxDrawImage(math.floor(sx - oneSize / 2), math.floor(sy - oneSize / 2), oneSize, oneSize, "files/tow.png", 0, 0, 0, tocolor(124, 197, 118))
							else
								dxDrawImage(math.floor(sx - oneSize / 2), math.floor(sy - oneSize / 2), oneSize, oneSize, "files/tow.png", 0, 0, 0, tocolor(215, 89, 89))
							end
						end
					end					
				end
			end

			if not isPedInVehicle(localPlayer) then
				if havePermission.impoundTow then
					for veh, holder in pairs(cableHolder) do
						if isElement(veh) then
							if isElement(holder) then
								if isElementStreamedIn(holder) then
									if isElementOnScreen(veh) or isElementOnScreen(holder) then
										local holdertype = getElementType(holder)

										if holdertype == "vehicle" then
											local side = cableAttachment[holder]

											if side then
												if not carInAnim[holder] then
													local theCarStatus = getElementData(holder, "carAnimation") or {}

													if theCarStatus[2] ~= "up" then
														local minX, minY, minZ, maxX, maxY, maxZ = getElementBoundingBox(holder)
														local cx, cy, cz = 0, 0, 0

														if side == "front" then
															cx, cy, cz = getPositionFromElementOffset(holder, 0, maxY - 0.15, minZ + maxZ / 2)
														else
															cx, cy, cz = getPositionFromElementOffset(holder, 0, -maxY, minZ + maxZ / 2)
														end

														local dist = getDistanceBetweenPoints3D(px, py, pz, cx, cy, cz)

														if dist < 2 then
															local x, y = getScreenFromWorldPosition(cx, cy, cz)

															if x and y then
																local oneSize = 48

																x = x - oneSize / 2
																y = y - oneSize / 2

																local pictureColor = tocolor(255, 255, 255)

																if absX >= x and absX <= x + oneSize and absY >= y and absY <= y + oneSize then
																	pictureColor = tocolor(124, 197, 118)
																	activeButton = {veh, "cardisc"}
																end

																dxDrawRectangle(x, y, oneSize, oneSize, tocolor(0, 0, 0, 150))
																dxDrawImage(x, y, oneSize, oneSize, "files/cardisc.png", 0, 0, 0, pictureColor)
															end
														end
													end
												end
											end
										end
									end
								end
							end
						end
					end
				end

				for veh, state in pairs(rampState) do
					if isElement(veh) then
						if isElementOnScreen(veh) then
							-- Rámpa
							local x, y, z = getPositionFromElementOffset(veh, -1.25, -5.5, 0.25)
							local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

							if dist <= 1 then
								x, y = getScreenFromWorldPosition(x, y, z)

								if x and y then
									local holder = cableHolder[veh]
									local oneSize = 48

									x = x - oneSize / 2
									y = y - oneSize / 2

									if state == "up" then
										local pictureColor = tocolor(255, 255, 255)

										if rampInAnim[veh] then
											pictureColor = tocolor(215, 89, 89, 150)
										else
											if absX >= x and absX <= x + oneSize and absY >= y and absY <= y + oneSize then
												pictureColor = tocolor(124, 197, 118)
												activeButton = {veh, "down"}
											end
										end

										dxDrawRectangle(x, y, oneSize, oneSize, tocolor(0, 0, 0, 150))
										dxDrawImage(x, y, oneSize, oneSize, "files/arrow.png", 0, 0, 0, pictureColor)
									elseif state == "down" then
										local pictureColor = tocolor(255, 255, 255)
										local theCarStatus = {}

										if isElement(holder) then
											theCarStatus = getElementData(holder, "carAnimation") or {}
										end

										if rampInAnim[veh] or isElement(myTowTruck) then
											pictureColor = tocolor(215, 89, 89, 150)
										elseif holder and carInAnim[holder] then
											pictureColor = tocolor(215, 89, 89, 150)
										elseif isElement(holder) and theCarStatus[2] ~= "up" then
											pictureColor = tocolor(215, 89, 89, 150)
										else
											if absX >= x and absX <= x + oneSize and absY >= y and absY <= y + oneSize then
												pictureColor = tocolor(124, 197, 118)
												activeButton = {veh, "up"}
											end
										end

										dxDrawRectangle(x, y, oneSize, oneSize, tocolor(0, 0, 0, 150))
										dxDrawImage(x, y, oneSize, oneSize, "files/arrow.png", 180, 0, 0, pictureColor)
									end
								end
							end

							-- Forgattyú
							local x, y, z = getPositionFromElementOffset(veh, 0, 0.75, 0.5)
							local dist = getDistanceBetweenPoints3D(px, py, pz, x, y, z)

							if dist <= 2.35 then
								x, y = getScreenFromWorldPosition(x, y, z)

								if x and y then
									local holder = cableHolder[veh]
									local oneSize = 48

									x = x - oneSize / 2
									y = y - oneSize / 2

									if isElement(holder) and getElementType(holder) == "vehicle" then
										local pictureColor = tocolor(255, 255, 255)
										local theCarStatus = getElementData(holder, "carAnimation") or {}

										if rampInAnim[veh] or carInAnim[holder] then
											pictureColor = tocolor(215, 89, 89, 150)
										else
											if absX >= x and absY >= y and absX <= x + oneSize and absY <= y + oneSize then
												pictureColor = tocolor(124, 197, 118)

												if theCarStatus[2] ~= "up" then
													activeButton = {veh, "carup"}
												else
													activeButton = {veh, "cardown"}
												end
											end
										end

										dxDrawRectangle(x, y, oneSize, oneSize, tocolor(0, 0, 0, 150))

										if theCarStatus[2] ~= "up" then
											if carAnimation[holder] then
												if carAnimation[holder][2] == "up" then
													dxDrawImage(x, y, oneSize, oneSize, "files/cardown.png", 0, 0, 0, pictureColor)
												else
													dxDrawImage(x, y, oneSize, oneSize, "files/carup.png", 0, 0, 0, pictureColor)
												end
											else
												dxDrawImage(x, y, oneSize, oneSize, "files/carup.png", 0, 0, 0, pictureColor)
											end
										else
											if carAnimation[holder] then
												if carAnimation[holder][2] == "up" then
													dxDrawImage(x, y, oneSize, oneSize, "files/cardown.png", 0, 0, 0, pictureColor)
												else
													dxDrawImage(x, y, oneSize, oneSize, "files/carup.png", 0, 0, 0, pictureColor)
												end
											else
												dxDrawImage(x, y, oneSize, oneSize, "files/cardown.png", 0, 0, 0, pictureColor)
											end
										end
									else
										local pictureColor = tocolor(255, 255, 255)

										if rampInAnim[veh] then
											pictureColor = tocolor(215, 89, 89, 150)
										else
											if absX >= x and absX <= x + oneSize and absY >= y and absY <= y + oneSize then
												pictureColor = tocolor(124, 197, 118)
												activeButton = {veh, "winch"}
											end
										end

										dxDrawRectangle(x, y, oneSize, oneSize, tocolor(0, 0, 0, 150))
										dxDrawImage(x, y, oneSize, oneSize, "files/winch.png", 0, 0, 0, pictureColor)
									end
								end
							end
						end
					else
						rampState[veh] = nil
					end
				end
			end
		end
	end
)

function linesIntersect(x1, y1, x2, y2, x3, y3, x4, y4)
	local d = (y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1)

	if d == 0 then
		return false
	end

	local n_a = (x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)
	local n_b = (x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)

	local ua = n_a / d
	local ub = n_b / d

	if ua >= 0 and ua <= 1 and ub >= 0 and ub <= 1 then
		return x1 + ua * (x2 - x1), y1 + ua * (y2 - y1)
	end

	return false
end

function getPositionFromElementOffset(element, x, y, z)
	local m = false

	if not isElementStreamedIn(element) then
		local rx, ry, rz = getElementRotation(element, "ZXY")

		rx, ry, rz = math.rad(rx), math.rad(ry), math.rad(rz)
		m = {}

		m[1] = {}
		m[1][1] = math.cos(rz) * math.cos(ry) - math.sin(rz) * math.sin(rx) * math.sin(ry)
		m[1][2] = math.cos(ry) * math.sin(rz) + math.cos(rz) * math.sin(rx) * math.sin(ry)
		m[1][3] = -math.cos(rx) * math.sin(ry)
		m[1][4] = 1

		m[2] = {}
		m[2][1] = -math.cos(rx) * math.sin(rz)
		m[2][2] = math.cos(rz) * math.cos(rx)
		m[2][3] = math.sin(rx)
		m[2][4] = 1

		m[3] = {}
		m[3][1] = math.cos(rz) * math.sin(ry) + math.cos(ry) * math.sin(rz) * math.sin(rx)
		m[3][2] = math.sin(rz) * math.sin(ry) - math.cos(rz) * math.cos(ry) * math.sin(rx)
		m[3][3] = math.cos(rx) * math.cos(ry)
		m[3][4] = 1

		m[4] = {}
		m[4][1], m[4][2], m[4][3] = getElementPosition(element)
		m[4][4] = 1
	else
		m = getElementMatrix(element)
	end

	return x * m[1][1] + y * m[2][1] + z * m[3][1] + m[4][1],
		   x * m[1][2] + y * m[2][2] + z * m[3][2] + m[4][2],
		   x * m[1][3] + y * m[2][3] + z * m[3][3] + m[4][3]
end
