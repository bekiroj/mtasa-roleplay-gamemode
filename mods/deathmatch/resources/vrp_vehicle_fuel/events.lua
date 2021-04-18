local mysql = exports.vrp_mysql
fuellessVehicle = { [594]=true, [537]=true, [538]=true, [569]=true, [590]=true, [606]=true, [607]=true, [610]=true, [590]=true, [569]=true, [611]=true, [584]=true, [608]=true, [435]=true, [450]=true, [591]=true, [472]=true, [473]=true, [493]=true, [595]=true, [484]=true, [430]=true, [453]=true, [452]=true, [446]=true, [454]=true, [497]=true, [509]=true, [510]=true, [481]=true }
bikes = { [448]=true, [461]=true, [462]=true, [463]=true, [468]=true, [471]=true, [521]=true, [522]=true, [581]=true, [586]=true }
sportscar = { [402]=true, [411]=true, [415]=true, [429]=true, [451]=true, [477]=true, [494]=true, [502]=true, [503]=true, [506]=true, [541]=true, [559]=true, [560]=true, [587]=true, [603]=true, [602]=true }
lowclasscar = { [400]=true, [401]=true, [404]=true }
mediumclasscar = { }
highclasscar = { }

function syncFuelOnEnter(thePlayer)
	triggerClientEvent(thePlayer, "syncFuel", source, getElementData(source, "fuel"))
end
addEventHandler("onVehicleEnter", getRootElement(), syncFuelOnEnter)

function fuelDepleting()
	local players = getElementsByType("player")
	for k, v in ipairs(players) do
		if isPedInVehicle(v) then
			local veh = getPedOccupiedVehicle(v)
			if (veh) then
				local seat = getPedOccupiedVehicleSeat(v)	
				if (seat==0) then
					local model = getElementModel(veh)
					if not (fuellessVehicle[model]) then -- Don't display it if it doesnt have fuel...
						local engine = getElementData(veh, "engine")
						if engine == 1 then
							local fuel = getElementData(veh, "fuel")
							if fuel >= 1 then
								local oldx = getElementData(veh, "oldx")
								local oldy = getElementData(veh, "oldy")
								local oldz = getElementData(veh, "oldz")
								
								local x, y, z = getElementPosition(veh)
								
								local ignore = math.abs(oldz - z) > 50 or math.abs(oldy - y) > 1000 or math.abs(oldx - x) > 1000
								
								if not ignore then
									local distance = getDistanceBetweenPoints2D(x, y, oldx, oldy)
									if (distance < 10) then
										distance = 10  -- fuel leaking away when not moving
									end
									local handlingTable = getModelHandling(model)
									local mass = handlingTable["mass"]

									newFuel = (distance/400) + (mass/20000)
									newFuel = fuel - ((newFuel/100)*getMaxFuel(model))

									exports.vrp_anticheat:changeProtectedElementDataEx(veh, "fuel", newFuel, false)
									triggerClientEvent(v, "syncFuel", veh, newFuel)
									
									if newFuel <= 0 then
										setVehicleEngineState(veh, false)
										exports.vrp_anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
										toggleControl(v, 'brake_reverse', false)
									end
								end
								exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
								exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
								exports.vrp_anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)	
							end
						end
					end
				end
			end
		end
	end
end
setTimer(fuelDepleting, 90000, 0)

function FuelDepetingEmptyVehicles()
	local vehicles = exports.vrp_pool:getPoolElementsByType("vehicle")
	for ka, theVehicle in ipairs(vehicles) do
		local enginestatus = getElementData(theVehicle, "engine")
		if (enginestatus == 1) then
			local driver = getVehicleOccupant(theVehicle)
			if (driver == false) then
				local fuel = getElementData(theVehicle, "fuel")
				if fuel >= 1 then
					local newFuel = fuel - ((0.9/100)*getMaxFuel(theVehicle))
					exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "fuel", newFuel, false)
					if (newFuel<=1) then
						setVehicleEngineState(theVehicle, false)
						exports.vrp_anticheat:changeProtectedElementDataEx(theVehicle, "engine", 0, false)
					end
				end
			end
		end
	end
end
setTimer(FuelDepetingEmptyVehicles, 240000,0)