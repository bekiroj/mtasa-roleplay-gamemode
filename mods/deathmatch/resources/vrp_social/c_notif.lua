-- [[ events: showNotificationForStatusOnline, showNotificationForStatusOffline]]

local descriptionJoin = "Çevrimiçi oldu"
local descriptionQuit = "Çevrimdışı oldu"
local messageFont = "default-bold"

local messageJoin = ""
local messageQuit = ""

local screenW, screenH = guiGetScreenSize()

-- [[ measurements (from top screen) ]]
dxRectangleH = 30 -- 10 w/out header bar prep
dxTextH = 50 -- 22 w/out header bar prep
dxImageH = 32 -- 15.5 w/out header bar prep

-- [[ avatar handler ]]
addEvent( "onClientGotImage", true )
addEventHandler("onClientGotImage", resourceRoot, function(pixels)
    if myAvatar then
        destroyElement(myAvatar)
    end
    myAvatar = dxCreateTexture(pixels)
end)

-- [[ renders ]]
function renderPlayerJoined ( source )
    local alpha = 255
    local alphaFaded = 160
    if myAvatar then
        local w, h = dxGetMaterialSize (myAvatar)
        dxDrawRectangle((screenW - 280) / 2, dxRectangleH, 280, 54, tocolor(0, 0, 0, alphaFaded), true)
        dxDrawImage((screenW / 2) - 138, dxImageH, 50, 50, myAvatar, 0, 0, 0, tocolor(255, 255, 255, alpha), true)
        dxDrawText(messageJoin, (screenW / 2) - 80, dxTextH, ((screenW / 2) - 95) + 22, (64) + 0, tocolor(255, 255, 255, alpha), 1.00, "default-bold", "left", "center", false, false, true, true, false)
    end
end

function renderPlayerLeft ( )
    local alpha = 255
    local alphaFaded = 160
    if myAvatar then
        local w, h = dxGetMaterialSize (myAvatar)
        dxDrawRectangle((screenW - 280) / 2, dxRectangleH, 280, 54, tocolor(0, 0, 0, alphaFaded), true)
        dxDrawImage((screenW / 2) - 138, dxImageH, 50, 50, myAvatar, 0, 0, 0, tocolor(255, 255, 255, alpha), true)
        dxDrawText(messageQuit, (screenW / 2) - 80, dxTextH, ((screenW / 2) - 95) + 22, (64) + 0, tocolor(255, 255, 255, 255), 1.00, "default-bold", "left", "center", false, false, true, true, false)
    end
end

-- [[ handlers ]]
addEvent("showNotificationForStatusOnline", true)
addEventHandler('showNotificationForStatusOnline', root,
    function(id)
        if not id then id = nil end -- select account id
        triggerServerEvent("getImage", resourceRoot , getLocalPlayer(), id)
        -- hold avatar before sending
        messageJoin = getElementData(source, "account:username") .. " #dadada" .. descriptionJoin
        ---- [todo: make admin color and support color be detected]
        removeEventHandler ( "onClientRender", root, renderPlayerLeft )
        -- remove active display
        removeEventHandler ( "onClientRender", root, renderPlayerJoined )
        -- remove active display
        addEventHandler ( "onClientRender", root, renderPlayerJoined )
        -- create notification
        outputConsole( "[Notification] " .. getElementData(source, "account:username") .. " " .. descriptionJoin, root)
        setTimer (
            function ( )
                removeEventHandler ( "onClientRender", root, renderPlayerJoined )
            end
            ,6000,1
        )
        end
)     

addEvent("showNotificationForStatusOffline", true)
addEventHandler('showNotificationForStatusOffline', root,
    function(id)
        if not id then id = nil end -- select account id end
        triggerServerEvent("getImage", resourceRoot , source, id)
        -- hold avatar before sending
        messageQuit  = getElementData(source, "account:username") .. " #dadada" .. descriptionQuit
        ---- [todo: make admin color and support color be detected]
        removeEventHandler ( "onClientRender", root, renderPlayerJoined )
        -- remove active display
        removeEventHandler ( "onClientRender", root, renderPlayerLeft )
        -- remove active display
        addEventHandler ( "onClientRender", root, renderPlayerLeft )
        -- display notification
        outputConsole( "[Notification] " .. getElementData(source, "account:username") .. " " .. descriptionQuit, root)
        setTimer (
            function ( )
                removeEventHandler ( "onClientRender", root, renderPlayerLeft )
            end
            ,6000,1
        )
    end
)


