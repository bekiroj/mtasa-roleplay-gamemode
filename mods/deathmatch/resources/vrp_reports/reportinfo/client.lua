local bekiroj = "Bu adama bayiliyorum."


function reportInfoOpen()
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "3")
end
addEvent( "raporac:tetikle", true )
addEventHandler( "raporac:tetikle", localPlayer, reportInfoOpen )



function reportInfoClose()
	triggerEvent("accounts:settings:updateAccountSettings", localPlayer, "report_panel_mod", "0")
end
addEvent( "raporkapat:tetikle", true )
addEventHandler( "raporkapat:tetikle", localPlayer, reportInfoClose )