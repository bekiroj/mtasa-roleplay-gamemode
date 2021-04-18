local fonts = {}
local fontsSource = {
    --["fontName"] = "source"
	["Rubik-Black"] = "files/Rubik-Bold.ttf",
    ["Rubik-Regular"] = "files/Rubik-Regular.ttf",
    ["Rubik"] = "files/Rubik-Regular.ttf",
    ["Rubik-Light"] = "files/Rubik-Light.ttf",
	["gotham_light"] = "files/gotham_light.ttf",
    ["Roboto"] = "files/Roboto.ttf",
    ["RobotoB"] = "files/RobotoB.ttf", 
    ["RobotoL"] = "files/RobotoL.ttf",
    ["OpenSans"] = "files/OpenSans.ttf",
    ["AwesomeFont"] = "files/FontAwesome.ttf",
    ["AwesomeFont2"] = "files/FontAwesome.ttf",
    ["BoldFont"] = "files/BoldFont.ttf",
    ["gtaFont"] = "files/gtaFont.ttf",
    ["SARP"] = "files/SARP.ttf",
    ["Raleway"] = "files/Raleway.ttf",
    ["LoginFont"] = "files/loginfont.ttf",
	["Yantramanav-Black"] = "files/Yantramanav-Black.ttf",
	["Yantramanav-Regular"] = "files/Yantramanav-Regular.ttf",
    ["Azzardo-Regular"] = "files/Azzardo-Regular.ttf",
    ["ArtegraSans-Black"] = "files/ArtegraSans-Black.otf",
    ["ArtegraSans-Bold"] = "files/ArtegraSans-Bold.otf",
    ["ArtegraSans-Thin"] = "files/ArtegraSans-Thin.otf",
    ["ArtegraSans-ExtraBold"] = "files/ArtegraSans-ExtraBold.otf",
    ["DeansGateB"] = "files/DeansGateB.ttf",
    ["FontAwesomeBrand"] = "files/FontAwesomeBrand.otf",
    ["FontAwesomeRegular"] = "files/FontAwesomeRegular.otf",
    ["FontAwesomeSolid"] = "files/FontAwesomeSolid.otf",
    ["Modern"] = "files/Modern.ttf",
}

function getFont(font, size, bold, quality)
    if not font then return end
    if not size then return end
    if string.lower(font) == "fontawesome" then font = "AwesomeFont2" end
    if string.lower(font) == "fontawesome2" then font = "AwesomeFont2" end
    if string.lower(font) == "awesomefont" then font = "AwesomeFont2" end
    --local size = math.floor(size)
    local fontE = false
    local _font = font
    
    if bold then
        font = font .. "-bold"
    end
    
    if quality then
        font = font .. "-" .. quality 
    end
    
    if font and size then
	    local subText = font .. size
	    local value = fonts[subText]
	    if value then
		    fontE = value
		end
	end
    
    if not fontE then
        local v = fontsSource[_font]
        fontE = DxFont(v, size, bold, quality)
        local subText = font .. size
        fonts[subText] = fontE
    end
    
	return fontE
end