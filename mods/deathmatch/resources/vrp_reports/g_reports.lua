
reportTypes = {
 	{"Başka bir oyuncuyla yaşanan problemler", {18, 17, 64, 15, 14}, "PLY", 214, 6, 6, "" },
	{"Interior Problemleri", {18, 17, 64, 15, 14}, "INT", 255, 126, 0, "" },
	{"Item Problemleri", {18, 17, 64, 15, 14}, "ITM", 255, 126, 0, "" },
	{"Genel Soru", {30, 18, 17, 64, 15, 14}, "SUP", 70, 200, 30, "" },
	{"Araçla Alakalı Problemler", {30, 18, 17, 64, 15, 14}, "VEH", 255, 126, 0, "" },
	--{"Vehicle Build/Import Requests", {39, 43}, "VCT", 176, 7, 237, "Use this type to contact the VCT." },
	--{"Mapping Issue", {44, 28}, "MAP", 0, 0, 0 }, bekiroj IF YOU EVER WANT TO BRING THIS BACK, UNCOMMENT
	--{"Scripting Question", {32}, "ScrT", 148, 126, 12, "Use this type if you with to contact the Scripting Team." },
}

adminTeams = exports.vrp_integration:getAdminStaffNumbers()
auxiliaryTeams = exports.vrp_integration:getAuxiliaryStaffNumbers()
SUPPORTER = exports.vrp_integration:getSupporterNumber()

function getReportInfo(row, element)
	if not isElement(element) then
		element = nil
	end

	local staff = reportTypes[row][2]
	local players = getElementsByType("player")
	local vcount = 0
	local scount = 0


	for k,v in ipairs(staff) do
		if v == 39 or v == 43 then

			for key, player in ipairs(players) do
				if exports.vrp_integration:isPlayerVCTMember(player) or exports.vrp_integration:isPlayerVehicleConsultant(player) then
					vcount = vcount + 1
					save = player
				end
			end

			if vcount==0 then
				return false, "Aktif araç yetkilisi mevcut değil. UCP'den şikayet açınız. https:/www.Lucyroleplay.com/ucp"
			elseif vcount==1 and save == element then
				return false, "Aktif araç yetkilisi mevcut değil. UCP'den şikayet açınız. https:/www.Lucyroleplay.com/ucp"
			end
		elseif v == 32 then

			for key, player in ipairs(players) do
				if exports.vrp_integration:isPlayerScripter(player) then
					scount = scount + 1
					save = player
				end
			end

			if scount==0 then
				return false, "Aktif yazılımcı mevcut değil. UCP'den şikayet açınız. https:/www.Lucyroleplay.com/ucp"
			elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "Aktif yazılımcı mevcut değil. UCP'den şikayet açınız. https:/www.Lucyroleplay.com/ucp"
			end
		end
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]

	return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == SUPPORTER then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(adminTeams, v) then
			return true
		end
	end
	return false
end

function isAuxiliaryReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(auxiliaryTeams, v) then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.vrp_integration:isPlayerTrialAdmin(thePlayer) or exports.vrp_integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end