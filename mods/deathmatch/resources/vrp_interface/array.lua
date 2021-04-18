Interface = {
	not_converts = {'gui-label'},
	display = {},

	check = function(self)
		for index, window in ipairs(getElementsByType('gui-window')) do
			if isElement(window) and window.visible == true then
				if not self.display[window] then
					local x, y = window:getPosition(false)
					local w, h = window:getSize(false)

					window:setAlpha(0)
					for _, children in ipairs(getElementChildren(window)) do
						for _, data in ipairs(self.not_converts) do
							children:setProperty('InheritsAlpha', 'FF000000')
						end
					end
					self.display[window] = {x, y, w, h};
				end
			end
		end
	end,

	draw = function(self)
		for index, data in pairs(self.display) do
			if not isElement(index) or (index.visible == false) then
				self.display[index] = nil
				return
			end
			local x, y = index:getPosition(false)
			local w, h = index:getSize(false)
			local data = {x, y, w, h}
			exports.vrp_draw:shadow(data[1],data[2],data[3],data[4],0,0,0,150,10,true);
		end
	end,
};

instance = new(Interface);
addEventHandler('onClientRender',root,function() instance:check() instance:draw() end);