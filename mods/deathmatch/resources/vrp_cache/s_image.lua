addEventHandler("onResourceStart", resourceRoot, function()
	accountAvatar = { }
	fh = fileOpen( "default.png", true )
	pixels = fileRead(fh,fileGetSize ( fh ))
	accountAvatar[-1] = pixels
	fileClose(fh)
end )

function addImage(id, image)
	local id = tonumber(id)
	if not id then return end

	accountAvatar[id] = image
end

function removeImage(eventName, id)
	if eventName then
		sid = tonumber(getElementData(source, "account:id"))
	else
		sid = tonumber(id)
	end

	if not sid then return end

	accountAvatar[sid] = nil
end
addEventHandler("onPlayerQuit", getRootElement(), removeImage)

function getImage(id)
	if tonumber(id) then
		if type(accountAvatar[tonumber(id)]) == "string" then
			return accountAvatar[tonumber(id)]
		else
			return accountAvatar[-1]
		end
	else
		return accountAvatar[-1]
	end
end