sRent = {

	region = ColShape.Sphere(439.5439453125, -1549.572265625, 28.059703826904, 3),

	pickup = Pickup(439.5439453125, -1549.572265625, 28.059703826904, 3, 1239),

	_trigger = function(player, cmd)
	sRent = instance;
		if player:getData('loggedin') == 1 then
			if player:isWithinColShape(instance.region) then
				if player:getData('rent:window') then
					player:outputChat('[Valhalla]#D0D0D0 Oluşturulmuş bir araç kiralama paneli mevcut!',195,184,116,true)
				else 
					triggerClientEvent(player,'rent:window',player)
					player:setData('rent:window',true)
					player:outputChat('[Valhalla]#D0D0D0 Araç kiralama paneli oluşturuldu.',195,184,116,true)
					player:outputChat('[Valhalla]#D0D0D0 Dilediğiniz aracı kiralayıp tadını çıkartabilirsin!',195,184,116,true)
				end
			else
				player:outputChat('[Valhalla]#D0D0D0 Herhangi bir araç kiralama noktasında değilsin!',195,184,116,true)
			end
		end
	end,

	_create = function(brand, cash, model)
		if source:getData('loggedin') == 1 then
			if model then
				if exports.vrp_global:takeMoney(source, cash) then

					local car = Vehicle(model, 41.9677734375, -1549.5869140625, 28.001941680908, 0, 0, 178.36303710938, 'KIRALIK')
					car:setOverrideLights(1)
					car:setEngineState(false)
					car:setData('dbid', -source:getData('dbid'), true)
					car:setData('fuel', exports['vrp_vehicle_fuel']:getMaxFuel(veh), false)
					car:setData('plate', 'KIRALIK', true)
					car:setData('Impounded', 0)
					car:setData('engine', 0, false)
					car:setData('oldx', x, false)
					car:setData('oldy', y, false)
					car:setData('oldz', z, false)
					car:setData('faction', -1)
					car:setData('owner', source:getData('dbid'), false)
					car:setData('job', 0, false)
					car:setData('handbrake', 0, true)
					car:setData('brand', brand, true)
					exports.vrp_global:giveItem(source, 3, -source:getData('dbid'))
					source:outputChat('[Valhalla]#D0D0D0 Yeni aracını kiraladın, 1 saat içinde aracın silinecek zamanını iyi kullan!',195,184,116,true)

					setTimer(function()
						source:outputChat('[Valhalla]#D0D0D0 Kiraladığın aracın süresi sona erdi.',195,184,116,true)
						exports['vrp_items']:deleteAll(3, -source:getData('dbid'))
						car:destroy()
					end, 3600000, 1)

					addEventHandler('onPlayerQuit', function()
						exports['vrp_items']:deleteAll(3, -source:getData('dbid'))
						car:destroy()
					end)

				else
					source:outputChat('[Valhalla]#D0D0D0 Aracı kiralamak için yeterli paraya sahip değilsin.',195,184,116,true)
				end
			end
		end
	end,

	index = function(self)
		self.pickup:setData('informationicon:information', '#7f8fa6/kirala\n#ffffff Araç Kiralama Noktası')
		addCommandHandler('kirala',self._trigger)
		addEvent('rent:create', true)
		addEventHandler('rent:create', root, self._create)
	end,
}

Async:setPriority('low')
instance = new(sRent)
instance:index()