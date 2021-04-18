--MAXIME

function updatePhoneSetting(fromPhone, index, value)
	fromPhone = tonumber(fromPhone)
	if fromPhone and index and value then
		outputDebugString("[Phone] updatePhoneSetting / "..fromPhone.." / "..index.." / "..value)
		return dbExec(mysql:getConnection(),"UPDATE `phones` SET `"..index.."`='"..exports.vrp_global:toSQL(value).."' WHERE `phonenumber`='"..fromPhone.."' ")
	end
end
addEvent("phone:updatePhoneSetting", true)
addEventHandler("phone:updatePhoneSetting", root, updatePhoneSetting)

function activatePrivateNumber(fromPhone, cost)
	fromPhone = tonumber(fromPhone)
	cost = tonumber(cost)
end
addEvent("phone:activatePrivateNumber", true)
addEventHandler("phone:activatePrivateNumber", root, activatePrivateNumber)

function requestPhoneSettingsFromServer(fromPhone)
	outputDebugString("[Phone] requestPhoneSettingsFromServer / "..getPlayerName(source).." / "..fromPhone)
	triggerClientEvent(source, "phone:updateClientPhoneSettingsFromServer", source, fromPhone, {fromPhone, getPhoneSettings(fromPhone, true)})
end
addEvent("phone:requestPhoneSettingsFromServer", true)
addEventHandler("phone:requestPhoneSettingsFromServer", root, requestPhoneSettingsFromServer)

