function setServerCurrentTimeSec(serverTimeSec)
	serverCurrentTimeSec = serverTimeSec
end
addEvent("setServerCurrentTimeSec", true)
addEventHandler("setServerCurrentTimeSec", root, setServerCurrentTimeSec)