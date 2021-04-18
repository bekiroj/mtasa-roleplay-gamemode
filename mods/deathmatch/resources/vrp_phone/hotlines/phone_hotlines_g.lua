--MAXIME

hotlines = {
	[911] = "Polis Departmanı",
	[8294] = "Taksi Durağı",
	[411] = "LSFMD Acil Servis",
	[611] = "SASD Acil Servis",
}

function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return hotlines[challengeNumber]
end