function isButtonHover(button, force)
    if button and #button > 0 then
        local type, left, top, width, height, data = unpack(button);
        if type == "button" then
            local inbox = isInBox(left, top, width, height);
            if force then
               return inbox;
            else
                return not isAlertShowed() and inbox;
            end
        end
    end
    return false;
end

function getButtonCustomData(button)
    if button and #button > 0 then
        local type, _, _, _, _, data = unpack(button);
        if type == "button" then
            return data;
        end
    end
    return false;
end
function toRGBA ( color )
    local r = bitExtract ( color, 16, 8 ) 
    local g = bitExtract ( color, 8, 8 ) 
    local b = bitExtract ( color, 0, 8 ) 
    local a = bitExtract ( color, 24, 8 ) 
    return r, g, b, a;
end

function stringToRGBA(string)
    local r = tonumber(string:sub(2, 3), 16);
    local g = tonumber(string:sub(4, 5), 16);
    local b = tonumber(string:sub(6, 7), 16);
    local a = 0;
    if string:len() == 7 then
        a = 255;
    else
        a = tonumber(string:sub(8, 9), 16);
    end
    return r, g, b, a;
end

function stringToColor(string)
    local r, g, b, a = stringToRGBA(string);
    return tocolor(r, g, b, a);
end

function colorDarker(color, factor)
    local r, g, b, a = toRGBA(color);
    r = r * factor;
    if r > 255 then r = 255; end
    g = g * factor;
    if g > 255 then g = 255; end
    b = b * factor;
    if b > 255 then b = 255; end
    return tocolor(r, g, b, a);
end

local sx,sy = guiGetScreenSize()
function isInBox(startX, startY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorPosition = {getCursorPosition()}
        cursorPosition.x, cursorPosition.y = cursorPosition[1] * sx, cursorPosition[2] * sy

        if cursorPosition.x >= startX and cursorPosition.x <= startX + sizeX and cursorPosition.y >= startY and cursorPosition.y <= startY + sizeY then
            return true
        else
            return false
        end
    else
        return false
    end
end