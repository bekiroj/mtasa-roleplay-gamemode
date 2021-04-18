addEvent ( "frames:fetchTexture", true )

mysql = exports.vrp_mysql

addEventHandler("onPlayerSpawn", root,
	function()
		triggerEvent("frames:loadInteriorTextures", source, getElementDimension(source))
	end )

--

function frames_fetchTexture ( itemSlot, url )
	fetchRemote ( url, 1, frames_callback, "", false, { player = client, url = url, slot = itemSlot } )
end

function frames_callback ( imgData, error, data )
	outputDebugString(error)
	if error == 0 then
		triggerClientEvent ( data.player, "frames:showTextureSelection", data.player, data.slot, data.url, imgData )
	end
end

addEventHandler ( "frames:fetchTexture", root, frames_fetchTexture )
