local sx, sy = guiGetScreenSize()
local localPlayer = getLocalPlayer()

local openReports = 0
local handledReports = 0
local ckAmount = 0
local unansweredReports = {}
local ownReports = {}

-- dx stuff
local admstr = ""
local show = true

-- Admin Titles
function getAdminTitle(thePlayer)
	return exports.vrp_global:getPlayerAdminTitle(thePlayer)
end


-- update the labels
local function updateGUI()
	if show then
		local reporttext = unansweredReports
		if type(reporttext) == "table" and #unansweredReports > 0 then
			reporttext = ": #" .. table.concat(unansweredReports, " #")
		end
		
		local ownreporttext = ownReports
		if #ownReports > 0 then
			ownreporttext = ": #" .. table.concat(ownReports, " #")
		end
		
		local onduty = getElementData( localPlayer, "admin_level" ) <= 7 and "Görev Dışında" or ""
		if getElementData( localPlayer, "duty_admin" ) == 1 or getElementData( localPlayer, "duty_supporter" ) == 1 then
			onduty = "Görevde" .. " - "
		else
			onduty = ""
		end

		local adminLevel = exports.vrp_global:getPlayerAdminLevel(localPlayer) or 0
		if exports.vrp_integration:isPlayerSupporter(localPlayer) or exports.vrp_integration:isPlayerTrialAdmin(localPlayer) then
			textString = getAdminTitle( localPlayer ) .. " - Mevcut Raporlar: "..(unansweredReports or "")
			--dxDrawImage ( 3, sy-21, 19, 19, 'components/aduty/'..adminLevel..'.png', 0, -120 )
		else
			textString = getAdminTitle( localPlayer ) .. " - " .. ( openReports - handledReports ) .. " cevaplanmamış raporlar" .. reporttext .. " - " .. handledReports .. " alınmış raporlar" .. ownreporttext .. " - "
		end
	end
end



-- create the gui
local function createGUI()
	show = false

	if exports.vrp_integration:isPlayerStaff(localPlayer) then
		show = true
		updateGUI()
	end
end

addEventHandler( "onClientResourceStart", getResourceRootElement(), createGUI, false )
addEventHandler( "onClientElementDataChange", localPlayer, 
	function(n)
		if n == "admin_level" or n == "hiddenadmin" or n=="account:gmlevel" or n=="duty_supporter" or n=="duty_admin" or n == "forum_perms" then
			createGUI()
		end
	end, false
)

addEvent( "updateReportsCount", true )
addEventHandler( "updateReportsCount", localPlayer,
	function( open, handled, unanswered, own, admst )
		openReports = open
		handledReports = handled
		unansweredReports = unanswered
		admstr = admst
		ownReports = own or {}
		updateGUI()
	end, false
)


addEvent( "addOneToCKCount", true )
addEventHandler("addOneToCKCount", localPlayer,
	function( )
		ckAmount = ckAmount + 1
		updateGUI()
	end, false
)

addEvent( "addOneToCKCountFromSpawn", true )
addEventHandler("addOneToCKCountFromSpawn", localPlayer,
	function( )
		if (ckAmount>=1) then
			return
		else
		ckAmount = ckAmount + 1
		updateGUI()
		end
	end, false
)



addEvent( "subtractOneFromCKCount", true )
addEventHandler("subtractOneFromCKCount", localPlayer,
	function( )
	if (ckAmount~=0) then
		ckAmount = ckAmount - 1
		updateGUI()
	else
		ckAmount = 0
	end
	end, false
)

addCommandHandler("staffoverlay", function()
 if exports.vrp_integration:isPlayerSupporter(localPlayer) or exports.vrp_integration:isPlayerTrialAdmin(localPlayer) then
	if (show == true) then
		show = false
		exports["vrp_infobox"]:addBox("info", "Yetkili arayüzünü in-aktif hale getirdin. Raporları farklı bir şekilde okumak istiyorsan /rapordurum ac yazabilirsin.")
	else
		show = true
		exports["vrp_infobox"]:addBox("info", "Yetkili arayüzünü aktif hale getirdin.")
	end
 end
end)

addEventHandler( "onClientPlayerQuit", getRootElement(), updateGUI )
local font = exports.vrp_fonts:getFont("Roboto", 10)
function drawText ( )
	if show and exports.vrp_global:isStaffOnDuty(localPlayer) then
	if getElementData(localPlayer, "loggedin") ~= 1 then return end
    local h = 64
    local font = exports['vrp_fonts']:getFont("RobotoB", 11)
	local adminLevel = exports.vrp_global:getPlayerAdminLevel(localPlayer) or 0
    local between = 5
	dxDrawImage ( 3, sy-21, 19, 19, 'components/aduty/'..adminLevel..'.png', 0, -120 )
   --dxDrawText("Redamancy Admin Interface", sx/2, sy-10, sx/2, sy - h, tocolor(156, 156, 156, 255), 1, font, "center", "center")
	dxDrawText(textString,  30, sy + sy - 42, 19, 19, tocolor(255, 255, 255, 255), 0.9, font, "left", "center")
	dxDrawImage ( 3, sy-21, 19, 19, 'components/aduty/'..adminLevel..'.png', 0, -120 )

--			
	end
end