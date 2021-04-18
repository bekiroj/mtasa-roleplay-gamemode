renderTimers = {}

local notificationFont = dxCreateFont("components/Roboto.ttf", 12)
local notificationFontBold = dxCreateFont("components/RobotoB.ttf", 12)


function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 5, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end

local cache = {}
local sx, sy = guiGetScreenSize()
local renderState = false
local types = {}
local details = {
    ["warning"] = {"Uyarı", "warning", "w.mp3"},
    ["error"] = {"Hata", "error", "error.wav"},
    ["info"] = {"Bilgi", "information", "i.mp3"},
    ["mod"] = {"Duyuru", "information", "i.mp3"},
    ["models"] = {"Modeller yükleniyor..", "information", "i.mp3"},
    ["success"] = {"Başarılı", "success", "s.mp3"},
    ["aduty"] = {"Yetkili Duyurusu", "adminduty", "adminduty.mp3"},
    ["buy"] = {"Finansal Güncelleme", "buy", "s.wav"},
    ["twitter"] = {"Twitter", "twitter", "twitter.mp3"},
    ["pet"] = {"Hayvan Kontrolü", "pet", "w.mp3"},
}

function searchBox(key)
    local val
    for k,v in pairs(cache) do
        if v["key"] == key then
            val = k
            break
        end
    end
    
    return val
end

function updateBoxDetails(key, detailID, nValue)
    if detailID == "msg" then
        local k = searchBox(key)
        if k then
            local type = cache[k]["type"]
            local msg = nValue
            local textLength
            if #details[type][1] >= #msg then
                textLength = dxGetTextWidth(details[type][1], 0.75, notificationFontBold, true) + 10
            else
                textLength = dxGetTextWidth(msg, 0.75, notificationFont, true) + 10
            end
            
            cache[k]["msg"] = msg
            cache[k]["length"] = textLength
        end
    elseif detailID == "custom2.details" then
        local k = searchBox(key)
        if k then
            cache[k]["customProg"] = nValue
        end
    end
end

function getColors(render)
    local enabled = true
    if render then
        if lastClickTick + 250 > getTickCount() then
            enabled = false
        end
        lastUpdateTick = getTickCount()
    end
    
    if enabled then
        engine = exports['vrp_coloration']
        types = {
            --[type] = {"awesomeIcon", r,g,b}
            ["warning"] = {"", {engine:getServerColor('lightyellow', false)}},
            ["error"] = {"", {engine:getServerColor('red', false)}},
            ["info"] = {"", {engine:getServerColor('blue', false)}},
            ["mod"] = {"", {engine:getServerColor('blue', false)}},
            ["models"] = {"", {engine:getServerColor('blue', false)}},
            ["success"] = {"", {engine:getServerColor('green', false)}},
            ["buy"] = {"", {engine:getServerColor('green', false)}},
            ["aduty"] = {engine:getIcon("fa-users"), {255, 200, 0}},
            ["twitter"] = {"", {engine:getServerColor('blue', false)}},
            ["pet"] = {"", {engine:getServerColor('yellow', false)}},
        }
    end
end
function addBox(type, msg, key, customDetails)

    getColors()
    
    if types[type] then
        local customData = {}
        local showtime = #msg * 200
        local customProg
        local typ, data = unpack(customDetails or {0, 0})
        if typ == 1 then
            showtime = tonumber(data)
        elseif typ == 2 then
            customProg = data
        end
        
        local textLength
        if #details[type][1] >= #msg then
            textLength = dxGetTextWidth(details[type][1], 0.75, notificationFontBold, true) + 10
        else
            textLength = dxGetTextWidth(msg, 0.75, notificationFont, true) + 10
        end
        
        ses = playSound("files/sounds/"..details[type][3])
		setSoundVolume(ses, 0.5)
        table.insert(cache, 
            {
                ["key"] = key or #cache + 1,
                ["msg"] = msg, 
                ["length"] = textLength, 
                ["now"] = getTickCount(), 
                ["end"] = getTickCount() + 1600, 
                ["state"] = "fadeIn", 
                ["type"] = type, 
                ["tick"] = 0,
                ["showtime"] = showtime,
                ["customProg"] = customProg,
            }
        )
        outputConsole("["..type.."] "..string.gsub(msg, "#%x%x%x%x%x%x", ""))
        
        if #cache >= 1 then
            if not renderState then
                renderState = true
                --addEventHandler("onClientRender", root, drawnBoxes, true, "low-5")
                createRender("drawnBoxes", drawnBoxes)
            end
        end
    end
end

addEvent("addBox", true)
addEventHandler("addBox", root, addBox)
    
local between = 32
function drawnBoxes()
    _sx, _sy = sx, sy
    local enabled, sx, nowY, w,h,sizable,turnable, sizeDetails, t, columns = true, 15, 360, 320, 45, 1, 1
    _nowY = nowY
    local now = getTickCount()
    for k,v in ipairs(cache) do
        local msg = v["msg"]
        local length = v["length"]
        local startTime = v["now"]
        local endTime = v["end"]
        local state = v["state"]
        local type = v["type"]
        local tick = v["tick"]
        local showtime = v["showtime"] or 8000
        local customProg = v["customProg"]
        local boxSize = 25 
        local pos, alpha -- = v["pos"], v["alpha"]
        
        local r,g,b = unpack(types[type][2])
        if not r or not g or not b then
            getColors(true)
        end
        
        local icon = types[type][1]
        local timeLine = false
        local timeLineProg
        
        if state == "fadeIn" then
            local elapsedTime = now - startTime
            local duration = endTime - startTime
            local progress = elapsedTime / duration
            
            if progress < 1 then
                pos = {interpolateBetween(sx - 80, nowY, 0, sx, nowY, 0, progress, 'OutQuad')}
                alpha = {interpolateBetween(0,0,0, 220,255,0, progress, 'OutQuad')}
            else
                alpha = {220, 255, 0}
                pos = {sx, nowY, 0}
                cache[k]["now"] = getTickCount()
                cache[k]["end"] = getTickCount() + showtime
                cache[k]["state"] = "timeLineStart"
            end
        elseif state == "timeLineStart" then
            alpha = {220, 255, 0}
            pos = {sx, nowY, 0}
            local elapsedTime = now - startTime
            local duration = endTime - startTime
            local progress = elapsedTime / duration
            
            if customProg and customProg[1] and customProg[2] then
                progress = customProg[2] / customProg[1] -- now / max
            end
            
            timeLine = true
            
            timeLineProg = progress
            if progress >= 1 then
                cache[k]["now"] = getTickCount()
                cache[k]["end"] = getTickCount() + 1600
                cache[k]["state"] = "fadeOut"
            end
        elseif state == "fadeOut" then
            timeLine = true
            local now = getTickCount()
            local elapsedTime = now - startTime
            local duration = endTime - startTime
            local progress = elapsedTime / duration
            
            pos = {interpolateBetween(sx, nowY, 0, sx, nowY, 0, progress, 'OutQuad')}
            alpha = {interpolateBetween(220, 255,0, 0,0,0, progress, 'OutQuad')}

            if progress >= 0.95 then
                table.remove(cache, k)
                if #cache <= 0 then
                    if renderState then
                        renderState = false
                        --removeEventHandler("onClientRender", root, drawnBoxes)
                        destroyRender("drawnBoxes")
                    end
                end
            end
        end
        
        local boxWidth = length + 70
        dxDrawRectangle(pos[1], pos[2], boxWidth, 50, tocolor(22, 22, 22, alpha[1]),true)
        dxDrawText(msg, pos[1] + 55 + 10, pos[2] + 26, 0, 0, tocolor(156, 156, 156, alpha[2]), 0.75, notificationFont, 'left', 'top',false,false,true,true,false)
        nowY = nowY + between
        dxDrawText(details[type][1], pos[1] + 55 + 10, pos[2] + 10, 0, 0, tocolor(255, 255, 255, alpha[2]), 0.75, notificationFontBold, 'left', 'top',false,false,true,false,false)
        dxDrawImage(pos[1] + 10, pos[2] + 10, 30, 30, 'files/notificationIcons/'..details[type][2]..'.png', 0,0,0, tocolor(r, g, b, alpha[2]),true)
        
        if timeLine then
            timeLineSize = interpolateBetween(boxWidth, 0,0, 0, 0,0, timeLineProg or 1, customProg and "Linear" or 'OutQuad')
        else
            timeLineSize = boxWidth
        end
        dxDrawRectangle(pos[1], pos[2] + 48, timeLineSize, 2, tocolor(r, g, b, alpha[2]),true)
        
        nowY = nowY + 35
    end
end