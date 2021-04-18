local Superman = {}
local rootElement = getRootElement()
local thisResource = getThisResource()

addEvent("superman:start", true)
addEvent("superman:stop", true)

function Superman.Start()
  local self = Superman

  addEventHandler("superman:start", rootElement, self.clientStart)
  addEventHandler("superman:stop", rootElement, self.clientStop)
end
addEventHandler("onResourceStart", getResourceRootElement(thisResource), Superman.Start, false)

function Superman.clientStart()
  setElementData(client, "superman:flying", true)
  setElementData(client, "forcedanimation", true)
end

function Superman.clientStop()
  removeElementData(client, "superman:flying")
  removeElementData(client, "forcedanimation")
end