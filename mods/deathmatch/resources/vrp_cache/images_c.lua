--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

local images = {}
local searched = {}
local cooldown = 10 --seconds.
local refresh_rate = 0 -- hours, 0 = never recache.

local function getPath(url)
	return '@images_cache/' .. md5(tostring(url)) .. '.tex'
end

-- Use do not use triggerClientEvent or triggerEvent on this function. 
-- If you intend to cache a new image from URL from client, call the function directly or use triggerServerEvent instead.
function addImage(url, data)
	if source then -- Triggered from server.
		if not data or not url then
			outputDebugString("[CACHE] Images / Client / addImage / Url and data are required parameters.")
			return
		end
		
		--Check and clear this image data if it is already been cached in client's file system.
		local filename = removeImage(url)

		--Now create a file in client's file system too, so next time they can load it quickly.
		local file = fileCreate(filename) 
		local size = fileWrite(file, data)
		fileClose(file)

		if size and size>0 then
			outputDebugString("[CACHE] Images / Client / addImage / Received "..exports.vrp_global:formatMoney(math.floor(size/1000)).."KB of data from server. Cached image in client's file system as '"..filename.."' - "..url)
			images[url] = getImage(url)
			searched[url] = getTickCount()
		else
			outputDebugString("[CACHE] Images / Client / addImage / Couln't cache image - "..url.." in client's file system.")
		end
		
	else -- Caching new image from client. 
		if url then
			triggerServerEvent("cache:addImage", localPlayer, url)
		else
			outputDebugString("[CACHE] Images / Client / addImage / Url is required parameters.")
			return 
		end
	end
end
addEvent("cache:addImage", true)
addEventHandler("cache:addImage", root, addImage)

function getImage(url)
	if not images[url] then
		-- Check file system
		local filename = getPath(url)
		if fileExists ( filename ) then -- if yes cache to client RAM
			local file = fileOpen(filename, true)
			if file then
				local size = fileGetSize(file)
				if tonumber(size) > 0 then
					local content = fileRead(file, size)
					images[url] = { data = content, tex = dxCreateTexture(filename)}
					-- Check if the image from client is up to date with server's.
					triggerServerEvent("cache:verifyClientImageFile", localPlayer, url, size)
					outputDebugString("[CACHE] images / client / getImage / Verify image : "..url)
				end
				fileClose(file)
			end
		end
	end

	if images[url] then -- if image is found somewhere client side.
		if not searched[url] then searched[url] = getTickCount() end
		if refresh_rate > 0 and getTickCount() - searched[url] > 1000*60*60*refresh_rate then
			searched[url] = getTickCount()
			outputDebugString("[CACHE] images / client / getImage / cache refreshing and requested new image from server: "..url)
			triggerServerEvent("cache:addImage", localPlayer, url)
		end
	else -- if image is NOT found anywhere client side.
		if not searched[url] or getTickCount() - searched[url] > 1000*cooldown then
			searched[url] = getTickCount()
			outputDebugString("[CACHE] images / client / getImage / requesting image from server: "..url)
			triggerServerEvent("cache:getImage", localPlayer, url)
		end
	end
	return images[url]
end

function removeImage(url, remove_from_server_too)
	images[url] = nil
	--Check if this image data is already been cached in client's file system.
	local filename = getPath(url)
	if fileExists ( filename ) then -- if yes, clear it.
		fileDelete(filename) 
	end
	if remove_from_server_too then
		triggerServerEvent("cache:removeImage", localPlayer, url)
	end
	outputDebugString("[CACHE] / Images / Client / removeImage / Done for "..url)
	return filename
end
addEvent("cache:removeImage", true)
addEventHandler("cache:removeImage", root, removeImage)

