function startObjectSystem()
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, row in ipairs(res) do
					for key, value in pairs( row ) do
						row[key] = tonumber(value)
					end
					
					local temporaryObject = createObject(row.model,row.posX,row.posY,row.posZ,row.rotX,row.rotY,row.rotZ)
					setElementDimension(temporaryObject, row.dimension)
					setElementInterior(temporaryObject, row.interior)
					exports.vrp_anticheat:changeProtectedElementDataEx( temporaryObject, "computer:clickable", true, true )
				end
			end
		end,
	mysql:getConnection(), "SELECT * FROM `computers` ORDER BY `id` ASC")
end
addEventHandler("onResourceStart", getResourceRootElement(), startObjectSystem)

addEvent("computers:on", true)
addEventHandler("computers:on", root,
	function()
		exports.vrp_global:sendLocalMeAction(client, "bilgisayarı açar.")
	end
)