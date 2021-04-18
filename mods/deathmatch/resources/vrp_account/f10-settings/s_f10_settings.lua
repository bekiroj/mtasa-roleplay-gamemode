local mysql = exports.vrp_mysql
local connection = mysql:getConnection()
addEventHandler("onResourceStart", root,
	function(startedRes)
		if getResourceName(startedRes) == "vrp_mysql" then
			connection = mysql:getConnection()
			restartResource(getThisResource())
		end
	end
)


function updateSetting(name, value)
	if source then
		client = source
	end
	if client and name and value then
		local id = getElementData(client, "account:id") or false
		if id then
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						dbExec(mysql:getConnection(),  "UPDATE `account_settings` SET `value` = '"..value.."' WHERE `id` = '"..id.."' AND `name` = '"..name.."' ")
					else
						dbExec(mysql:getConnection(),  "INSERT INTO `account_settings` SET `name` = '"..name.."', `value` = '"..value.."', `id` = '"..id.."'")
					end
				end,
			mysql:getConnection(), "SELECT * FROM `account_settings` WHERE `name` = '"..name.."' AND `id` = '"..id.."' LIMIT 1")
		end
	end
end
addEvent("accounts:settings:update", true)
addEventHandler("accounts:settings:update", root, updateSetting)

function updateCharacterSetting(name, value)
	if source then
		client = source
	end
	if client and name and value then
		local id = getElementData(client, "dbid") or false
		if id then
			dbQuery(
				function(qh)
					local res, rows, err = dbPoll(qh, 0)
					if rows > 0 then
						dbExec(mysql:getConnection(),  "UPDATE `character_settings` SET `value` = '"..value.."' WHERE `id` = '"..id.."' AND `name` = '"..name.."' ")
					else
						dbExec(mysql:getConnection(),  "INSERT INTO `character_settings` SET `name` = '"..name.."', `value` = '"..value.."', `id` = '"..id.."'")
					end
				end,
			mysql:getConnection(), "SELECT * FROM `character_settings` WHERE `name` = '"..name.."' AND `id` = '"..id.."' LIMIT 1")
		end
	end
end
addEvent("accounts:settings:updateCharacterSetting", true)
addEventHandler("accounts:settings:updateCharacterSetting", root, updateCharacterSetting)

function loadASettingsCallback(queryHandler, player, id)
	local result, rows, err = dbPoll(queryHandler, 0)
	local settings = {}
	if rows > 0 then
		for index, row in pairs(result) do
			if (row["name"] == 'duty_admin' and not exports.vrp_integration:isPlayerTrialAdmin(player)) or (row["name"] == 'duty_supporter' and not exports.vrp_integration:isPlayerSupporter(player)) then
				row["value"] = 0
			end

			table.insert(settings, {row["name"], row["value"]})
		end
		triggerClientEvent("accounts:settings:loadAccountSettings", player, settings)
	end
end

function loadAccountSettings(player,id)
	if player and id then
		dbQuery(loadASettingsCallback, {player, id}, connection, "SELECT * FROM `account_settings` WHERE `id` = '"..id.."'")
	end
end
addEvent("accounts:settings:loadAccountSettings", true)
addEventHandler("accounts:settings:loadAccountSettings", root, loadAccountSettings)


function loadCSettingsCallback(queryHandler, player, id)
	local result, rows, err = dbPoll(queryHandler, 0)
	local settings = {}
	if rows > 0 then
		for index, row in pairs(result) do
			if (row["name"] == 'duty_admin' and not exports.vrp_integration:isPlayerTrialAdmin(player)) or (row["name"] == 'duty_supporter' and not exports.vrp_integration:isPlayerSupporter(player)) then
				row["value"] = 0
			end

			table.insert(settings, {row["name"], row["value"]})
		end
		triggerClientEvent("accounts:settings:loadCharacterSettings", player, settings)
	end
end

function loadCharacterSettings(player,id)
	if player and id then
		dbQuery(loadCSettingsCallback, {player, id}, connection, "SELECT * FROM `character_settings` WHERE `id` = '"..id.."'")
	end
end
addEvent("accounts:settings:loadCharacterSettings", true)
addEventHandler("accounts:settings:loadCharacterSettings", root, loadCharacterSettings)

function reconnectPlayer()
	redirectPlayer ( client, "" , 0 )
end
addEvent("accounts:settings:reconnectPlayer", true)
addEventHandler("accounts:settings:reconnectPlayer", root, reconnectPlayer)

local clientAccountSettings = {}
local clientCharacterSettings = {}
function whenPlayerQuit ( quitType )
	if clientAccountSettings[source] and type(clientAccountSettings[source]) == "table" and #clientAccountSettings[source]>0 then
		for i, setting in pairs(clientAccountSettings[source]) do
			triggerEvent("accounts:settings:update", source, setting[1], setting[2])
			--outputDebugString("whenPlayerQuit")
		end
		clientAccountSettings[source] = {}
	end
	
	if clientCharacterSettings[source] and type(clientCharacterSettings[source]) == "table" and #clientCharacterSettings[source]>0 then
		for i, setting in pairs(clientCharacterSettings[source]) do
			triggerEvent("accounts:settings:updateCharacterSetting", source, setting[1], setting[2])
			--outputDebugString("whenPlayerQuit")
		end
		clientCharacterSettings[source] = {}
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), whenPlayerQuit )

function whenPlayerChangeChar ()
	if clientCharacterSettings[source] and type(clientCharacterSettings[source]) == "table" and #clientCharacterSettings[source]>0 then
		for i, setting in pairs(clientCharacterSettings[source]) do
			triggerEvent("accounts:settings:updateCharacterSetting", source, setting[1], setting[2])
			--outputDebugString("whenPlayerQuit")
		end
		clientCharacterSettings[source] = {}
	end
end
addEventHandler("accounts:characters:change", getRootElement(), whenPlayerChangeChar)

function saveClientAccountSettingsOnServer(name, value)
	--outputDebugString("saveClientAccountSettingsOnServer")
	if not clientAccountSettings[source] then
		clientAccountSettings[source] = {}
	end
	
	local existed = false
	for i = 1, #clientAccountSettings[source] do
		if clientAccountSettings[source][i][1] == name then
			clientAccountSettings[source][i][2] = value
			existed = true
			break
		end
		--outputDebugString(clientAccountSettings[i][1].." - "..clientAccountSettings[i][2])
	end
	if not existed then
		table.insert(clientAccountSettings[source], {name, value})
	end
	
	setElementData(source, name, value)
	if name == "duty_admin" or name == "duty_supporter" then
		exports.vrp_global:updateNametagColor(source)
	end
end
addEvent("saveClientAccountSettingsOnServer", true)
addEventHandler("saveClientAccountSettingsOnServer", root, saveClientAccountSettingsOnServer)

function saveClientCharacterSettingsOnServer(name, value)
	--outputDebugString("saveClientCharacterSettingsOnServer: "..name.." - "..value)
	if not clientCharacterSettings[source] then
		clientCharacterSettings[source] = {}
	end
	
	local existed = false
	for i = 1, #clientCharacterSettings[source] do
		if clientCharacterSettings[source][i][1] == name then
			clientCharacterSettings[source][i][2] = value
			existed = true
			break
		end
		--outputDebugString(clientCharacterSettings[source][i][1].." - "..clientCharacterSettings[source][i][2])
	end
	if not existed then
		table.insert(clientCharacterSettings[source], {name, value})
	end
	setElementData(source, name, value)
end
addEvent("saveClientCharacterSettingsOnServer", true)
addEventHandler("saveClientCharacterSettingsOnServer", root, saveClientCharacterSettingsOnServer)