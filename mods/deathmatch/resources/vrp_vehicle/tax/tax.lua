local mysql = exports.vrp_mysql

function vehicle_tax()
	for _, vehicle in ipairs(exports.vrp_pool:getPoolElementsByType("vehicle")) do
		local vehicleID = getElementData(vehicle, "dbid")
		local vehOwner = getElementData(vehicle, "owner")
		local vehFact = getElementData(vehicle, "faction")
		local model = getElementModel ( vehicle )
		if vehicleID > 0 and  vehFact ~= 1 and vehFact ~= 47 and vehFact ~= 2 and vehFact ~= 4 and model ~= 604 and model ~= 540 and model ~= 503 and model ~= 466 and model ~= 504 then
			local toplamVergi = getElementData(vehicle, "toplamvergi") or 0
			local faizKilidi = getElementData(vehicle, "faizkilidi")
			local vehShopID = getElementData(vehicle, "vehicle_shop_id")
			local carShopDetails = exports["vrp_vehicle_manager"]:getInfoFromVehShopID(vehShopID)
			if carShopDetails then
				local vergiMiktari = carShopDetails.vehtax
				local vergiSiniri = math.ceil((carShopDetails.vehprice / 100) * 50)
				setElementData(vehicle, "toplamvergi", toplamVergi + vergiMiktari)
				local yeniVergi = getElementData(vehicle, "toplamvergi")
				if yeniVergi >= vergiSiniri then
					setElementData(vehicle, "faizkilidi", true)
					setVehicleEngineState(vehicle, false)
					setVehicleLocked(vehicle, true)
					setElementData(vehicle, "enginebroke", 1)
				end
			end
		end
	end
end
setTimer(vehicle_tax, 3600000, 0)