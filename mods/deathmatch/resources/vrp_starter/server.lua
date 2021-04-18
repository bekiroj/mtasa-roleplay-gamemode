Instance = {
	primary_resources = {'vrp_mysql', 'vrp_global', 'vrp_pool', 'vrp_data', 'vrp_fonts'},

	start = function(self)
		for index, resource in ipairs(self.primary_resources) do
			getResourceFromName(resource):start()
		end
		--##
		for index, resource in ipairs(getResources()) do
			resource:start()
		end
	end,
}
addEventHandler('onResourceStart',resourceRoot,function() Instance:start() end)