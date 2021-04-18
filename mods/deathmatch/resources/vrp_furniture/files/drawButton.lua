
local sx,sy = guiGetScreenSize()
local awesomeFont = dxCreateFont("files/5.ttf",10)

function drawButton(text, left, top, width, height, color, textColor, textSize, nohoverable, customData, forceHover)
    if not color then color = tocolor(0, 0, 0, 200); end
    if type(color) == "string" then color = stringToColor(color); end
    if type(textColor) == "string" then color = stringToColor(textColor); end
    local this = {"button", left, top, width, height, customData};
    
    local r, g, b, a = toRGBA(color);
    local border = 2;
    if height > 120 then
        border = 5;
    elseif height > 80 then
        border = 4;
    elseif height > 40 then
        border = 3;
    end
    
    local isHover = not nohoverable and isButtonHover(this, forceHover);
    if isHover then
        color = colorDarker(color, 1.2);
        r, g, b, a = toRGBA(color);
    end
    dxDrawRectangle(left, top, width, height, tocolor(r, g, b, a * 0.75));
    dxDrawRectangle(left + border, top + border, width - border * 2, height - border * 2, color);



    dxDrawText(text, left, top, left + width, top + height, textColor or tocolor(0,0,0), 1, awesomeFont, "center", "center");
 
    return this, isHover;
end
function isButtonHover(button, force)
        if button and #button > 0 then
        local type, left, top, width, height, data = unpack(button);
        if type == "button" then
            local inbox = isInBox(left, top, width, height);
            if force then
               return inbox;
            else
                return not isButtonsShowed() and inbox;
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