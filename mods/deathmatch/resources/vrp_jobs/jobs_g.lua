Jobs = {
    [8] = {"Sigara Kaçakçısı", {2459.3017578125, -2634.5146484375, 16.640625}, false},
    [9] = {"Alkol Kaçakçısı", {2571.09375, -2411.8134765625, 13.640625}, false},
    [10] = {"Tır Şoförü", {2281.43359375, -2364.8525390625, 13.546875}},
    [11] = {"Kamyon Şoförü", {2219.9560546875, -2665.5927734375, 13.535820960999}},
    [17] = {"Balıkçılık", {362.5322265625, -2052.841796875, 30.546875}, false},
}
function getJobs()
	return Jobs
end

function getJobTitleFromID(jobID)
	if (tonumber(jobID)==5) then
		return "Tamirci"
	elseif (tonumber(jobID)==6) then
		return "Çilingir"
	elseif (tonumber(jobID)==8) then
		return "Sigara Kaçakçısı"
	elseif (tonumber(jobID)==9) then
		return "Alkol Kaçakçısı"
	elseif (tonumber(jobID)==10) then
		return "Tır Şoförü"
	elseif (tonumber(jobID)==11) then
		return "Kamyon Şoförü"
	else
		return "İşsiz"
	end
end