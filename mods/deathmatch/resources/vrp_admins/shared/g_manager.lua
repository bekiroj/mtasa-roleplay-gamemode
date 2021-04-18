function canPlayerAccessStaffManager(player)
	return exports.vrp_integration:isPlayerTrialAdmin(player) or exports.vrp_integration:isPlayerSupporter(player) or exports.vrp_integration:isPlayerVCTMember(player) or exports.vrp_integration:isPlayerLeadScripter(player) or exports.vrp_integration:isPlayerMappingTeamLeader(player)
end	