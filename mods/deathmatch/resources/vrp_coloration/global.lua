colors = {
    --['colorname'] = {r, g, b, hex},
    ['red'] = {210,49,49, "#d23131"},
	['green'] = {124,197,118, "#7cc576"},
    ['blue'] = {61,122,188,"#3d7abc"},
	['yellow'] = {255,168,0, "#ffa800"},
	['blue2'] = {36, 109, 208, "#246dd0"},
	['darkblue'] = {47, 77, 115, "#2c4d73"},
    ["orangeOld"] = {255, 153, 51, "#ff9933"},
    ["orangeNew"] = {244, 137, 66, "#f48942"},
    ['lightyellow'] = {255, 209, 26, "#ffd11a"},
    ['gray'] = {156, 156, 156, "#9c9c9c"},
}

devMode = false -- Ha true akkor a getPlayerDeveloper funkció nem checkeli a loggedIn-t
serverColor = 'blue'
serverName = 'Valhalla'
hexCode = colors[serverColor][4]
low = hexCode .. '[' .. serverName .. '] #FFFFFF'
local serverSide = false
addEventHandler("onResourceStart", resourceRoot,
    function()
        serverSide = true
    end
)

serverData = {
    ['color'] = serverColor,
}


function getServerColor(color, hexCode)
    if color == "orange" then
        color = "blue"
    end
    if not hexCode then
	    local r,g,b = colors[serverColor][1], colors[serverColor][2], colors[serverColor][3]
		if color and colors[color] then
		    r,g,b = colors[color][1], colors[color][2], colors[color][3]
		end
		return r,g,b
	else
	    local hex = colors[serverColor][4]
		if color and colors[color] then
		    hex = colors[color][4]
		end
		return hex
	end
end
