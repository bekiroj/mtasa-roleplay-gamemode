function addBox(sourceElement, type, msg)    
    triggerClientEvent(sourceElement, "addBox", sourceElement, type, msg)
end
addEvent("addBox", true)
addEventHandler("addBox", root, addBox)