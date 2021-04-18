local rot = 0
local alpha = 200
local alphaState = "down"
local imgrot = 0
local img = 3
local destroyTimer
local loadingText = ""
local bgb_alpha = 255
local bgb_state = "-"
local sx, sy = guiGetScreenSize()
local playerCharacters = {};
local browser = guiCreateBrowser(0, 60, sx, sy, true, true, false)
guiSetVisible(browser, false)
local theBrowser = guiGetBrowser(browser)
local x1, y1, z1, x1t, y1t, z1t = 1546.3354492188, -1351.4052734375, 230, -1546.3354492188, 1351.4052734375, 230
local x2, y2, z2, x2t, y2t, z2t = -1546.3354492188, 1351.4052734375, 230, 1546.3354492188, -1351.4052734375, 230
local animation = {}
animation.alpha = {}
animation.step = 5
for i=1, 5 do
	animation.alpha[i] = 0
end
camera = {
	[1] = { 1240.27661, -936.21216, 150.21532, 1642.1964111328, -1619.4523925781, 76.21875, 1281.33984375, -1184.2369384766, 94.2265625},
	[2] = { 2953.32007, -2079.47217, 80.95277, 2902.98071, -2083.04590, 2.02448, 2899.27417, -2082.65625, 2.50801}
}
local iCamera = 1
local dx = 0.0
local RobotoFont = dxCreateFont("html/fonts/Roboto.ttf", 10)
function renderGTAVLoading()
	if alphaState == "down" then
		alpha = alpha - 2
		if alpha <= 100 then
			alphaState = "up"
			if changeTextTo then
				loadingText = changeTextTo
			end
		end
	else
		alpha = alpha + 2
		if alpha >= 200 then
			alphaState = "down"
		end
	end
	dxDrawText(loadingText,0,0,sx,sy,tocolor(255,255,255,alpha),1,RobotoFont,"center","center")
	if rot > 360 then rot = 0 end
	rot = rot + 5
	local minusX = dxGetTextWidth(loadingText)
	dxDrawImage(sx/2-minusX/2-49,sy/2-16,32,32,"img/loading.png",rot)
end
addEventHandler("accounts:login:request", getRootElement(),
	function ()
		setElementDimension ( localPlayer, 0 )
		setElementInterior( localPlayer, 0 )
		setElementPosition( localPlayer, unpack( defaultCharacterSelectionSpawnPosition ) )
		guiSetInputEnabled(true)
		clearChat()
		triggerServerEvent("onJoin", localPlayer)
	end
);

local wLogin, lUsername, tUsername, lPassword, tPassword, chkRememberLogin, bLogin, bRegister--[[, updateTimer]] = nil
local Exclusive = {}
function LoginScreen_openLoginScreen(title)
	--open_log_reg_pannel()
	Exclusive.loginStart()
end
addEvent("beginLogin", true)
addEventHandler("beginLogin", getRootElement(), LoginScreen_openLoginScreen)

local warningBox, warningMessage, warningOk = nil
local errorMain = {
    button = {},
    window = {},
    label = {}
}
function LoginScreen_showWarningMessage( message )
end
addEventHandler("accounts:error:window", getRootElement(), LoginScreen_showWarningMessage)

addEventHandler("accounts:login:attempt", getRootElement(),
	function (statusCode, additionalData, pChars)
		if (statusCode == 0) then
			if (isElement(warningBox)) then
				destroyElement(warningBox)
			end
			local newAccountHash = localPlayer:getData("account:newAccountHash")
			characterList = localPlayer:getData("account:characters") or playerCharacters
			if #characterList == 0 then
				Exclusive.newCharacter()
			end

			Exclusive.drawnCharacters(characterList)
		

		elseif (statusCode > 0) and (statusCode < 5) then
			LoginScreen_showWarningMessage( additionalData )
		elseif (statusCode == 5) then
			LoginScreen_showWarningMessage( additionalData )
		end
	end
)

local function onResourceStart()
	setPlayerHudComponentVisible("weapon", false)
	setPlayerHudComponentVisible("ammo", false)
	setPlayerHudComponentVisible("vehicle_name", false)
	setPlayerHudComponentVisible("money", false)
	setPlayerHudComponentVisible("clock", false)
	setPlayerHudComponentVisible("health", false)
	setPlayerHudComponentVisible("armour", false)
	setPlayerHudComponentVisible("breath", true)
	setPlayerHudComponentVisible("area_name", false)
	setPlayerHudComponentVisible("radar", false)
	setPlayerHudComponentVisible("crosshair", true)
	setPlayerNametagShowing(localPlayer, false)
	engineSetAsynchronousLoading(true, true)
	setWorldSpecialPropertyEnabled("extraairresistance", false)
	setAmbientSoundEnabled( "gunfire", false )
	setDevelopmentMode(false)
	setPedTargetingMarkerEnabled(false) -- Adams
	guiSetInputMode("no_binds_when_editing")
	triggerServerEvent( "accounts:login:request", getLocalPlayer() )
	toggleControl("radar", false) 
end
addEventHandler( "onClientResourceStart", getResourceRootElement( ), onResourceStart )

--[[ XML STORAGE ]]--
local oldXmlFileName = "settings.xml"
local migratedSettingsFile = "@migratedsettings.empty"
local xmlFileName = "@settings.xml"
function loadSavedData(parameter, default)
	-- migrate existing settings
	if not fileExists(migratedSettingsFile) then
		if not fileExists(xmlFileName) and fileExists(oldXmlFileName) then
			fileRename(oldXmlFileName, xmlFileName)
		end
		fileClose(fileCreate(migratedSettingsFile))
	end
	local xmlRoot = xmlLoadFile( xmlFileName )
	if (xmlRoot) then
		local xmlNode = xmlFindChild(xmlRoot, parameter, 0)
		if xmlNode then
			return xmlNodeGetValue(xmlNode)
		end
	end
	return default or false
end

function appendSavedData(parameter, value)
	localPlayer:setData(parameter, value, false)
	local xmlFile = xmlLoadFile ( xmlFileName )
	if not (xmlFile) then
		xmlFile = xmlCreateFile( xmlFileName, "login" )
	end

	local xmlNode = xmlFindChild (xmlFile, parameter, 0)
	if not (xmlNode) then
		xmlNode = xmlCreateChild(xmlFile, parameter)
	end
	xmlNodeSetValue ( xmlNode, value )
	xmlSaveFile(xmlFile)
	xmlUnloadFile(xmlFile)
end

local BizNoteFont18 = dxCreateFont ( ":vrp_resources/BizNote.ttf" , 18 )

fontType = {-- (1)font (2)scale offset
	["default"] = {"default", 1},
	["default-bold"] = {"default-bold",1},
	["clear"] = {"clear",1.1},
	["arial"] = {"arial",1},
	["sans"] = {"sans",1.2},
	["pricedown"] = {"pricedown",3},
	["bankgothic"] = {"bankgothic",4},
	["diploma"] = {"diploma",2},
	["beckett"] = {"beckett",2},
	["BizNoteFont18"] = {"BizNoteFont18",1.1},
}

function loadSavedData2(parameter)

	for key, font in pairs(fontType) do
		local value = loadSavedData(parameter, font[1])
		if value then
			return value
		end
	end

	return false
end

--[[ END XML STORAGE ]]--

--[[ START ANIMATION STUFF ]]--
local happyAnims = {
	{ "ON_LOOKERS", "wave_loop"}
}

local idleAnims = {
	{ "PLAYIDLES", "shift"},
	{ "PLAYIDLES", "shldr"},
	{ "PLAYIDLES", "stretch"},
	{ "PLAYIDLES", "strleg"},
	{ "PLAYIDLES", "time"}
}

local danceAnims = {
	{ "DANCING", "dance_loop" },
	{ "STRIP", "strip_D" },
	{ "CASINO", "manwinb" },
	{ "OTB", "wtchrace_win" }
}

local deathAnims = {
	{ "GRAVEYARD", "mrnF_loop" },
	{ "GRAVEYARD", "mrnM_loop" }
}

function getRandomAnim( animType )
	if (animType == 1) then -- happy animations
		return happyAnims[ math.random(1, #happyAnims) ]
	elseif (animType == 2) then -- idle animations
		return idleAnims[ math.random(1, #idleAnims) ]
	elseif (animType == 3) then -- idle animations
		return danceAnims[ math.random(1, #danceAnims) ]
	elseif (animType == 4) then -- death animations
		return deathAnims[ math.random(1, #deathAnims) ]
	end
end

function clearChat()
	local lines = getChatboxLayout()["chat_lines"]
	for i=1,lines do
		outputChatBox("")
	end
end
addCommandHandler("clearchat", clearChat)

function applyClientConfigSettings()

	local borderVeh = tonumber( loadSavedData("borderVeh", "1") )
	localPlayer:setData("borderVeh", borderVeh, false)

	local bgVeh = tonumber( loadSavedData("bgVeh", "1") )
	localPlayer:setData("bgVeh", bgVeh, false)

	local bgPro = tonumber( loadSavedData("bgPro", "1") )
	localPlayer:setData("bgPro", bgPro, false)

	local borderPro = tonumber( loadSavedData("borderPro", "1") )
	localPlayer:setData("borderPro", borderPro, false)

	local enableOverlayDescription = tonumber( loadSavedData("enableOverlayDescription", "1") )
	localPlayer:setData("enableOverlayDescription", enableOverlayDescription or 1, false)

	local enableOverlayDescriptionVeh = tonumber( loadSavedData("enableOverlayDescriptionVeh", "1") )
	localPlayer:setData("enableOverlayDescriptionVeh", enableOverlayDescriptionVeh or 1, false)

	local enableOverlayDescriptionVehPin = tonumber( loadSavedData("enableOverlayDescriptionVehPin", "1") )
	localPlayer:setData("enableOverlayDescriptionVehPin", enableOverlayDescriptionVehPin, false)

	local enableOverlayDescriptionPro = tonumber( loadSavedData("enableOverlayDescriptionPro", "1") )
	localPlayer:setData("enableOverlayDescriptionPro", enableOverlayDescriptionPro or 1, false)

	local enableOverlayDescriptionProPin = tonumber( loadSavedData("enableOverlayDescriptionProPin", "1") )
	localPlayer:setData("enableOverlayDescriptionProPin", enableOverlayDescriptionProPin or 1, false)

	local cFontPro = loadSavedData2("cFontPro")
	localPlayer:setData("cFontPro", cFontPro or "BizNoteFont18", false)

	local cFontVeh = loadSavedData2("cFontVeh")
	localPlayer:setData("cFontVeh", cFontVeh or "default", false)

	local blurEnabled = tonumber( loadSavedData("motionblur", "1") )
	if (blurEnabled == 1) then
		setBlurLevel(38)
	else
		setBlurLevel(0)
	end

	local skyCloudsEnabled = tonumber( loadSavedData("skyclouds", "1") )
	if (skyCloudsEnabled == 1) then
		setCloudsEnabled ( true )
	else
		setCloudsEnabled ( false )
	end

	local streamingMediaEnabled = tonumber(loadSavedData("streamingmedia", "1"))
	if streamingMediaEnabled == 1 then
		localPlayer:setData("streams", 1, true)
	else
		localPlayer:setData("streams", 0, true)
	end

	local phone_anim = tonumber(loadSavedData("phone_anim", "1"))
	if phone_anim == 1 then
		localPlayer:setData("phone_anim", 1, true)
	else
		localPlayer:setData("phone_anim", 0, true)
	end
end

blackMales = {7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 50, 51, 66, 67, 78, 79, 80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 230, 262 }
whiteMales = {23, 26, 27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110, 111, 112, 113, 114, 115, 116, 120, 121, 122, 124, 125, 126, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177, 179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = {9, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 91, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256, 304 }
whiteFemales = {12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 86, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194, 196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}

function stopNameChange(oldNick, newNick)
	if (source==getLocalPlayer()) then
		local legitNameChange = getElementData(getLocalPlayer(), "legitnamechange")

		if (oldNick~=newNick) and (legitNameChange==0) then
			triggerServerEvent("resetName", getLocalPlayer(), oldNick, newNick)
			outputChatBox("Karakterinizi değiştirmek isterseniz, karakteri değiştir seçeneğine tıklayın.", 255, 0, 0)
		end
	end
end
addEventHandler("onClientPlayerChangeNick", getRootElement(), stopNameChange)

function update_updateElementData(theElement, theParameter, theValue)
	if (theElement) and (theParameter) then
		if (theValue == nil) then
			theValue = false
		end
		theElement:setData(theParameter, theValue, false)
	end
end
addEventHandler("edu", getRootElement(), update_updateElementData)

local guiRules = {}
local state = 0
function showServerRules(state1)
	if state1 and tonumber(state1) then
		state = tonumber(state1)
	end
	triggerServerEvent("apps:startStep11", localPlayer)
end
addEvent("account:showRules", true)
addEventHandler("account:showRules", root, showServerRules)

function hideServerRules()
	for i, gui in pairs (guiRules) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
end
addEvent("account:hideRules", true)
addEventHandler("account:hideRules", root, hideServerRules)

function Exclusive.loginStart()
	font = DxFont(":vrp_hud/Bebas.ttf", 18)
	guiSetVisible(browser, true)
	time = 200000/1.5
	lastClick = 0
	state, object1, object2 = smoothMoveCamera(x1, y1, z1t, x1t, y1t, z1t, x2, y2, z2t, x2t, y2t, z2t, time)
	vehicle = createVehicle(519, x1, y1, z1)
	bgMusic = playSound("sounds/music.mp3", true)
	localPlayer:setData("bgMusic", bgMusic , false)
	fadeCamera ( true, 1, 0,0,0 );	

	setVehicleLandingGearDown(vehicle, false)
	attachElements(vehicle, object1, -20, 50, 0)
	
	airRotation, oldAirRotation, airYRotation = 90, 0, 0
	setCloudsEnabled(false)
	cameraMatrix, cameraMatrix2 = 0, 0;
	addEventHandler("onClientRender", root, drawnLogin)
end

addEvent("hideLoginWindow", true)
addEventHandler("hideLoginWindow", root,
	function()
		stopSmoothMoveCamera()
		guiSetVisible(browser, false)
		removeEventHandler("onClientRender", root, drawnLogin)
	end
)

addEventHandler("onClientBrowserCreated", theBrowser, 
	function()
		loadBrowserURL(source, "http://mta/local/html/index.html")
	end
)
-- sendJS(fonksiyonadı, fonksiyon argları)
function sendJS(functionName, ...)
	if (not theBrowser) then
		outputDebugString("Browser is not loaded yet, can't send JS.")
		return false
	end

	local js = functionName.."("
	local argCount = #arg
	for i, v in ipairs(arg) do
		local argType = type(v)
		if (argType == "string") then
			js = js.."'"..addslashes(v).."'"
		elseif (argType == "boolean") then
			if (v) then js = js.."true" else js = js.."false" end
		elseif (argType == "nil") then
			js = js.."undefined"
		elseif (argType == "table") then
			--
		elseif (argType == "number") then
			js = js..v
		elseif (argType == "function") then
			js = js.."'"..addslashes(tostring(v)).."'"
		elseif (argType == "userdata") then
			js = js.."'"..addslashes(tostring(v)).."'"
		else
			outputDebugString("Unknown type: "..type(v))
		end

		argCount = argCount - 1
		if (argCount ~= 0) then
			js = js..","
		end
	end
	js = js .. ");"

	executeBrowserJavascript(theBrowser, js)
end

-- Backslash-escape special characters:
function addslashes(s)
	local s = string.gsub(s, "(['\"\\])", "\\%1")
	s = string.gsub(s, "\n", "")
	return (string.gsub(s, "%z", "\\0"))
end

function drawnLogin()
	
	animation.alpha[animation.step] = animation.alpha[animation.step] + 4
	if animation.alpha[animation.step] > 255 then
		animation.alpha[animation.step] = 255
	end
	--dxDrawImage(sx/2-256/2, sy/2-300/2-100, 256, 256, "img/logo_2.png", 0, 0, 0, tocolor(255, 255, 255, math.min(255, animation.alpha[animation.step])))
	
	if animation.text then
		--dxDrawText(animation.text, 0, 0, sx, sy+450, tocolor(255, 255, 255), 1, font, 'center', 'center')
	end
end

addEvent("sign-in", true)
addEventHandler("sign-in", root,
	function(username, password)
		access, code = checkVariables(1, username, password)
		if access then
			triggerServerEvent("accounts:login:attempt", getLocalPlayer(), username, password, false)
		else
			Error_msg("Everyone", code);
		end
	end
);

addEvent("register", true)
addEventHandler("register", root,
	function(username, password)
		access, code = checkVariables(2, username, password)
		if access then

			triggerServerEvent("accounts:register:attempt",getLocalPlayer(),username,password,password, "@")
		else
			Error_msg("Everyone", code);
		end
	end
);

function Error_msg(Page, message_text)
	--animation.text = message_text;
	-- alert_text kısmı. 
	sendJS("error", message_text); -- dene
end
addEvent("set_warning_text", true)
addEventHandler("set_warning_text", root, Error_msg)
addEvent("set_authen_text", true)
addEventHandler("set_authen_text", root, Error_msg)

function checkVariables(page, username, password)
	if page == 1 then
		if username == "" then
			return false,"Kullanıcı adı boş kalmamalıdır.","blue"
		end

		if password == "" then
			return false,"Şifre boş kalmamalıdır.","blue"
		end

		return true
	elseif page == 2 then
		if username == "" then
			return false,"Kullanıcı adı boş kalmamalıdır!","blue"
		end
		if password == "" then
			return false,"Şifre boş kalmamalıdır!","blue"
		end
		
		if string.find(password, "'") or string.find(password, '"') then
			return false,"Şifrenizde istenmeyen karakter saptandı!","red"
		end
		if string.match(username,"%W") then
			return false,"Kullanıcı adınızda istenmeyen karakter saptandı!","red"
		end
		
		if string.len(password) < 8 then
			return false,"Girdiğiniz şifre en az 8 karakter olmalıdır!","red"
		end
		if string.len(password) > 16 then
			return false,"Girdiğiniz şifre en fazla 16 karakter olmalıdır!","red"
		end
		if string.len(password) < 3 then
			return false,"Girdiğiniz kullanıcı adı en az 3 karakter olmalıdır!","red"
		end
		
		return true
	end
end

function passwordHash(password)
    local length = utfLen(password)

    if length > 23 then
        length = 23
    end
    return string.rep("", length)
end

local sm = {}
sm.moov = 0
sm.object1, sm.object2 = nil, nil

local function camRender()
	local x1, y1, z1 = getElementPosition(vehicle)
	
	local rz = getCameraRotation()
	local _, _, oldAirRotation = getElementRotation(vehicle)
	
	
	if rz >= 0 and rz <= 90 then
		airYRotation = airYRotation + 0.05
		if airYRotation >= 3 then
			airYRotation = 3
		end
	elseif rz >= 91 and rz <= 180 then
		airYRotation = airYRotation - 0.05
		if airYRotation >= 3 then
			airYRotation = 3
		end
	elseif rz >= 181 and rz <= 270 then
		airYRotation = airYRotation + 0.05
		if airYRotation >= 3 then
			airYRotation = 3
		end
	elseif rz >= 271 and rz <= 360 then
		airYRotation = airYRotation - 0.05
		if airYRotation >= 3 then
			airYRotation = 3
		end
	end
	if rz == oldAirRotation then
		if airYRotation > 0 then
			airYRotation = airYRotation - 6
			if airYRotation < 0 then
				airYRotation = 0
			end
		else
			airYRotation = airYRotation + 6
			if airYRotation > 0 then
				airYRotation = 0
			end
		end
	end


	setElementRotation(vehicle, 0, airYRotation, vehicle:getRotation():getZ()+30)
	
	cameraMatrix = cameraMatrix - 0.1
	if cameraMatrix < -40 then
		cameraMatrix = -40
	end
	cameraMatrix2 = cameraMatrix2 - 2
	if cameraMatrix2 < -20 then
		cameraMatrix2 = -20
	end

	if iCamera == 1 then
		dx = dx + 0.0001
		local ix, iy, iz = interpolateBetween(camera[iCamera][1], camera[iCamera][2], camera[iCamera][3], camera[iCamera][4], camera[iCamera][5], camera[iCamera][6], dx, "Linear")
		setCameraMatrix(ix, iy, iz, camera[iCamera][7], camera[iCamera][8], camera[iCamera][9] )
	elseif iCamera == 2 then
		dx = dx + 0.0080
		local ix, iy, iz = interpolateBetween(camera[iCamera][1], camera[iCamera][2], camera[iCamera][3], camera[iCamera][4], camera[iCamera][5], camera[iCamera][6], dx, "Linear")
		setCameraMatrix(ix, iy, iz, camera[iCamera][7], camera[iCamera][8], camera[iCamera][9] )
	end
end

local function removeCamHandler()
	if (sm.moov == 1) then
		sm.moov = 0
		if isElement(vehicle) then
			destroyElement(vehicle)
		end
		removeEventHandler("onClientPreRender", root, camRender)
	end
end

function stopSmoothMoveCamera()
	if (sm.moov == 1) then
		if (isTimer(sm.timer1)) then killTimer(sm.timer1) end
		if (isTimer(sm.timer2)) then killTimer(sm.timer2) end
		if (isTimer(sm.timer3)) then killTimer(sm.timer3) end
		if (isTimer(sm.timer4)) then killTimer(sm.timer4) end
		if (isElement(sm.object1)) then destroyElement(sm.object1) end
		if (isElement(sm.object2)) then destroyElement(sm.object2) end
		if (isElement(vehicle)) then destroyElement(vehicle) end
		removeCamHandler()
		sm.moov = 0
	end
end

function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time, easing)
	if (sm.moov == 1) then return false end
	sm.object1 = createObject(1337, x1, y1, z1)
	sm.object2 = createObject(1337, x1t, y1t, z1t)
	setElementAlpha(sm.object1, 0)
	setElementAlpha(sm.object2, 0)
    setElementCollisionsEnabled(sm.object1, false)
    setElementCollisionsEnabled(sm.object2, false)
	setObjectScale(sm.object1, 0.01)
	setObjectScale(sm.object2, 0.01)
	moveObject(sm.object1, time, x2, y2, z2, 0, 0, 0, "Linear")
	moveObject(sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "Linear")
	
	addEventHandler("onClientPreRender", root, camRender, true, "low")
	sm.moov = 1
	sm.timer1 = setTimer(removeCamHandler, time, 1)
	sm.timer2 = setTimer(destroyElement, time, 1, sm.object1)
	sm.timer3 = setTimer(destroyElement, time, 1, sm.object2)
	
	return true, sm.object1, sm.object2
end

function getCameraRotation()
	cam = Camera.matrix:getRotation():getZ()
	--cam = tonumber(string.format("%.0f",cam/90))*90
	return cam
end
function Characters_showSelection()
	Exclusive.drawnCharacters(getElementData(localPlayer, "account:characters"))
end

function Exclusive.drawnCharacters(table)
	if not table then
		table = getElementData(localPlayer, "account:characters")
	end
	bgb_state, bgb_alpha = "-", 255
	if isTimer(destroyTimer) then
		killTimer(destroyTimer)
	end
	img = 1
	changeTextTo = "Sunucu Verileri Yüklenirken Bekleyin.."
	fadeCamera(false, 0.1)
	addEventHandler("onClientRender", root, renderGTAVLoading)
	destroyTimer = setTimer(
		function()
			removeEventHandler("onClientRender", root, renderGTAVLoading)
			for i=0, 1+#table do
				animation.alpha[i] = 0
			end
			triggerEvent("account:changingchar", localPlayer)
			showCursor(true);
			lastArrayClick = 0
			font2 = DxFont(":vrp_interface/fonts/FontAwesome.ttf")
			fadeCamera ( true, 1, 0,0,0 );
			accountCharacters = table;
			addEventHandler("onClientRender", root, drawnCharacters);
		end
	, 5500, 1)
end
addEvent("show-characters", true)
addEventHandler("show-characters", root, Exclusive.drawnCharacters)

function Exclusive.destroyCharacters()
	removeEventHandler("onClientRender", root, drawnCharacters);
	--triggerEvent( 'hud:blur', resourceRoot, 'off' )
end

function drawnCharacters()
	dxDrawImage(0, 0, sx, sy, "img/background.jpg")


	animation.alpha[1] = 255
	
	newCharacter_array = 28
	i = 1
	local color = "#212121AA"
	if type(color) == "string" then color = stringToColor(color); end
	r, g, b, a = toRGBA(color);

	for index, value in ipairs(accountCharacters) do
		i = i + 1
		x, y, w, h = sx/2-250/2, sy/2-25/2+(index*33), 250, 30
		local border = 2;
		if h > 120 then
	        border = 5;
	    elseif h > 80 then
	        border = 4;
	    elseif h > 40 then
	        border = 3;
	    end
		if isInBox(x, y, w, h) then
	        color = colorDarker(color, 1.2);
	        r, g, b, a = toRGBA(color);
	        if getKeyState("mouse1") and lastArrayClick+200 <= getTickCount() then
				lastArrayClick = getTickCount()
				triggerServerEvent("accounts:characters:spawn", localPlayer, value[1])
				Exclusive.destroyCharacters()
			end
	    end
		
		dxDrawRectangle(x, y, w, h, tocolor(200,200,200,200));
		dxDrawRectangle(x+border, y+border, w-border*2, h-border*2, tocolor(150,150,150,200));

		if fileExists("img/"..value[9]..".png") then
			dxDrawImage(x+border, y+border, 30-border*2, 30-border*2, "img/"..value[9]..".png");
		end
		dxDrawText(value[2]:gsub("_", " ").." olarak oyna!", x, y, w+x, y+h, tocolor(25, 25, 25), 1, font2, 'center', 'center')
		newCharacter_array = newCharacter_array + 28
		
	end
	y = y +newCharacter_array
	local border = 2;
		if h > 120 then
	        border = 5;
	    elseif h > 80 then
	        border = 4;
	    elseif h > 40 then
	        border = 3;
	    end
	if isInBox(x, y, w, h) then
		color = colorDarker(color, 1.2);
		r, g, b, a = toRGBA(color);
		if getKeyState("mouse1") and lastArrayClick+200 <= getTickCount() then
			lastArrayClick = getTickCount()
		--	triggerServerEvent("accounts:characters:spawn", localPlayer, value[1])
			Exclusive.destroyCharacters()
			Exclusive.newCharacter()
		end
	end
	
	dxDrawRectangle(x, y, w, h, tocolor(200,200,200,200));
	dxDrawRectangle(x+border, y+border, w-border*2, h-border*2, tocolor(150,150,150,200));

	dxDrawText("Karakter Oluştur", x, y, w+x, y+h, tocolor(25, 25, 25), 1, font2, 'center', 'center')

	dxDrawImage(sx/2-256/2, sy/2-456/2-100, 256, 256, "html/images/logo-white.png", 0, 0, 0, tocolor(255, 255, 255))
end

function characters_onSpawn(fixedName, adminLevel, gmLevel, location)
	clearChat()
	showChat(true)
	guiSetInputEnabled(false)
	showCursor(false)
	img = 1
	changeTextTo = fixedName.." olarak giriş yapıyorsunuz, bekleyin.."
	fadeCamera(false, 0.1)
	addEventHandler("onClientRender", root, renderGTAVLoading)
	setTimer(
		function()
		removeEventHandler("onClientRender", root, renderGTAVLoading)
		fadeCamera ( true, 1, 0,0,0 );
		for i=1, 15 do
			outputChatBox(" ")
		end
		local syntax = exports.vrp_pool:getServerSyntax(false, "e")
		outputChatBox(syntax.."Sunucuya hoş geldin "..fixedName..".", 85, 155, 255, true)

		outputChatBox(" ")

		bgMusic = getElementData(localPlayer, "bgMusic")
		if isElement(bgMusic) then
			destroyElement(bgMusic)
		end
		localPlayer:setData("admin_level", adminLevel, false)
		localPlayer:setData("account:gmlevel", gmLevel, false)

		options_enable()
	end,
	8500,1)
end
addEvent("account:character:spawned", true)
addEventHandler("accounts:characters:spawn", getRootElement(), characters_onSpawn)
local creationSteps = {};

function Exclusive.destroyCreateCharacter()
	creationSteps = {};
	localPlayer.dimension = 0;
	if isElement(ped) then
		destroyElement(ped);
	end
	removeEventHandler("onClientRender", root, Exclusive.drawnNewCharacter)
	removeEventHandler("onClientCharacter", root, Exclusive.characterEdit)
	removeEventHandler("onClientKey", root, Exclusive.characterKey)
end

function Exclusive.newCharacter()
	creationSteps.currentStep = 1;
	localPlayer.dimension = 65535;
	pname, pheight, pweight, page = 0, 0, 0, 0
	editingText = "";
	creationSteps.stepTexts = {
		['top'] = {
			[1] = "Karakter adınızı girerek devam edin..\nDevam etmek için [ENTER] - Çıkış için [LCTRL]",
			[2] = "Karakterinizin boyunu girin ve devam edin.. ( Örnek: 175 )\nDevam etmek için [ENTER] basın.",
			[3] = "Karakterinizin kilosunu girin ve devam edin.. ( Örnek: 80 )\nDevam etmek için [ENTER] basın.",
			[4] = "Karakterinizin yaşını girin ve devam edin.. ( Örnek: 35 )\nDevam etmek için [ENTER] basın.",
			[5] = "",
			[6] = "Karakterinin dilini, ırkını ve kıyafetini ayarla..",
		},
		["bottom"] = {
			[1] = "Ad: ",
			[2] = "Boy: ",
			[3] = "Kilo: ",
			[4] = "Yaş: ",
			[5] = "",
			[6] = "",
		},
		["bottom-end"] = {
			[1] = "",
			[2] = " cm",
			[3] = " kg",
			[4] = "",
			[5] = "",
			[6] = "",
		},
	}
	creationSteps.maxLength = {
		[1] = 15,
		[2] = 2,
		[3] = 1,
		[4] = 1,
		[5] = 0,
		[6] = 0,
	}

	creationSteps.startSteps(creationSteps.currentStep);
	addEventHandler("onClientRender", root, Exclusive.drawnNewCharacter)
	addEventHandler("onClientCharacter", root, Exclusive.characterEdit)
	addEventHandler("onClientKey", root, Exclusive.characterKey)
end

function Exclusive.characterEdit(character)
	if (string.len(editingText) <= creationSteps.maxLength[creationSteps.currentStep]) then
		if creationSteps.currentStep == 1 and tonumber(character) then
			return
		end
		if creationSteps.currentStep ~= 1 and not tonumber(character) then
			return
		end
		editingText = editingText .. character
	end
end

addEvent('response:nameCheck', true)
addEventHandler('response:nameCheck', root,
	function(playerName, reason)
		if reason == "ok" then
			pname = playerName;
			editingText = "";
			creationSteps.currentStep = 2;
		else
			editingText = "";
			LoginScreen_showWarningMessage("Belirlediğiniz karakter ismi zaten kullanılıyor!")
		end
	end
)

function Exclusive.characterKey(button, state)
	if state and button == "lctrl" and creationSteps.currentStep == 1 then
		Exclusive.destroyCreateCharacter();
		Exclusive.drawnCharacters();
	elseif state and button == "backspace" then
		if string.len(editingText) >= 1 then
			editingText = string.sub(editingText, 1, string.len(editingText)-1)
		end
	elseif state and button == "enter" then
		if creationSteps.currentStep == 1 then-- name to height
			pname = editingText;
			local nameCheckPassed, nameCheckError = checkValidCharacterName(pname)
			if not nameCheckPassed then
				LoginScreen_showWarningMessage( "Karakter isminizde hata bulundu:\n".. nameCheckError )
				return
			end
			triggerServerEvent("checkAlreadyUsingName", localPlayer, localPlayer, pname)
			editingText = "Bekleyin..";
			--editingText = "";
			--creationSteps.currentStep = 2;
		elseif creationSteps.currentStep == 2 then-- height to weight
			if not (tonumber(editingText) < 201 and tonumber(editingText) > 149) then
				LoginScreen_showWarningMessage("Geçersiz boy girdiniz.")
				return
			end
			pheight = editingText;
			editingText = "";
			creationSteps.currentStep = 3;
		elseif creationSteps.currentStep == 3 then-- height to weight
			if not (tonumber(editingText) < 200 and tonumber(editingText) > 49) then
				LoginScreen_showWarningMessage("Geçersiz kilo girdiniz.")
				return
			end
			pweight = editingText;
			editingText = "";
			creationSteps.currentStep = 4;
		elseif creationSteps.currentStep == 4 then-- weight to age
			if not (tonumber(editingText) > 15 and tonumber(editingText) < 101) then
				LoginScreen_showWarningMessage("Geçersiz yaş girdiniz.")
				return
			end
			page = editingText;
			editingText = "";
			creationSteps.currentStep = 5;
			fadeCamera(false)
			setTimer(
				function()
					fadeCamera( true, 1, 0,0,0 );
					creationSteps.startSteps(creationSteps.currentStep)
				end,
			2500, 1)
		end
	end
end

function Exclusive.drawnNewCharacter()
	x, y, w, h = 0, 0, sx, 140
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0));
	dxDrawText(creationSteps.stepTexts['bottom'][creationSteps.currentStep]..editingText..creationSteps.stepTexts['bottom-end'][creationSteps.currentStep], x, y, w+x, y+h, tocolor(220, 220, 220), 2, "sans-bold", "center", "center")

	x, y, w, h = 0, sy-140, sx, 140
	dxDrawRectangle(x, y, w, h, tocolor(0, 0, 0));
	if creationSteps.currentStep == 5 then
		creationSteps.stepTexts['top'][creationSteps.currentStep] = pname.." olarak Los Santos'a iniyorsun.."
	end
	dxDrawText(creationSteps.stepTexts['top'][creationSteps.currentStep], x, y, w+x, y+h, tocolor(220, 220, 220), 2, "sans-bold", "center", "center")
end

function creationSteps.startSteps(currStep)
	if currStep == 1 then
		setCameraMatrix(1426.0230712891,1452.0122070313,11.712900161743,1426.2102050781,1451.0609130859,11.467829704285)
		ped = createPed(0, 1427.2587890625, 1448.7236328125, 10.8816614151)
		ped.dimension = 65535;
		setPedAnimation( ped, "ped", "SEAT_idle", -1, true, false, false)
	elseif currStep == 5 then
		plane = Vehicle(592, 2019.2830810547,-2493.96729,65.113327026367);
		plane:setFrozen(true);
		setVehicleLandingGearDown(plane, false)
		setTimer(
			function()
				setVehicleLandingGearDown(plane, true)
			end,
		7500, 1)
		plane.dimension = 65535;
		object = Object(1239, 2019.2830810547,-2493.96729,65.113327026367);
		object.dimension = 65535;
		attachElements(plane, object, 0, 0, 0, 2, 0, 90)
		object:move(15000, 1723.6625976563, -2493.96729, 14.5546875, 0, 0, 0, "InOutQuad")
		setCameraMatrix(1784.5635986328,-2424.369140625,23.109199523926,1785.1137695313,-2425.2016601563,23.172679901123)
		setTimer(
			function()
				object:destroy();
				plane:destroy();
				creationSteps.currentStep = currStep + 1
				creationSteps.startSteps(creationSteps.currentStep)
			end,
		15000, 1)
	elseif currStep == 6 then
		setPedAnimation(ped, "", "")
		setCameraMatrix(1731.9586181641,-2237.671875,42.600898742676,1731.3488769531,-2236.9809570313,42.212341308594)
		setElementPosition(ped,1726.49707, -2230.96899, 39.3802)
		setPedAnimation(ped, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
		setElementFrozen(ped, true)
		gui = {}
		Exclusive.createGUI()
	end
end

function Exclusive.createGUI()
	gui['langWindow'] = guiCreateWindow(sx-342, sy/2-466/2, 339, 466, "Karakterini Yapılandır", false)
	guiWindowSetSizable(gui['langWindow'], false)

	gui['langWindowGrid'] = guiCreateGridList(9, 28, 320, 329, false, gui['langWindow'])
	guiGridListAddColumn(gui['langWindowGrid'], "Diller", 0.9)

	for _, value in ipairs(exports['vrp_languages']:getLanguageList()) do 
		guiGridListAddRow(gui['langWindowGrid'], value)
	end

	gui["rbMale"] = guiCreateRadioButton(9, 360, 51, 13, "Erkek", false, gui["langWindow"])
	gui["rbFemale"] = guiCreateRadioButton(240, 360, 82, 13, "Kadın", false, gui["langWindow"])
	guiRadioButtonSetSelected ( gui["rbMale"], true)
	addEventHandler("onClientGUIClick", gui["rbMale"], newCharacter_updateGender, false)
	addEventHandler("onClientGUIClick", gui["rbFemale"], newCharacter_updateGender, false)

	gui["btnPrevSkin"] = guiCreateButton(9, 405, 16, 16, "<", false, gui["langWindow"])
	gui["btnNextSkin"] = guiCreateButton(315, 405, 16, 16, ">", false, gui["langWindow"])
	addEventHandler("onClientGUIClick", gui["btnPrevSkin"] , newCharacter_updateGender, false)
	addEventHandler("onClientGUIClick", gui["btnNextSkin"] , newCharacter_updateGender, false)
	
	gui["chkBlack"] =  guiCreateCheckBox ( 9, 384, 55, 16, "Siyahi", true, false, gui["langWindow"] )
	addEventHandler("onClientGUIClick", gui["chkBlack"] , newCharacter_raceFix, false)
	gui["chkWhite"] =  guiCreateCheckBox ( 120, 384, 55, 16, "Beyaz", false, false, gui["langWindow"] )
	addEventHandler("onClientGUIClick", gui["chkWhite"] , newCharacter_raceFix, false)
	gui["chkAsian"] =  guiCreateCheckBox ( 240, 384, 55, 16, "Asyalı", false, false, gui["langWindow"] )
	addEventHandler("onClientGUIClick", gui["chkAsian"] , newCharacter_raceFix, false)

	gui['langWindowCloseBtn'] = guiCreateButton(9, 431, 320, 25, "İleri", false, gui['langWindow'])
	
	newCharacter_updateGender()
	newCharacter_changeSkin()
	languageselected = -1

	addEventHandler("onClientGUIClick", gui['langWindowGrid'], function(button)
	if (button == "left") then 
		local row = guiGridListGetSelectedItem(gui['langWindowGrid'])
		local selectedLang = guiGridListGetItemText(gui['langWindowGrid'], row, 1)
		creationSteps['language'] = exports['vrp_languages']:getLanguageName(row + 1)
		languageselected = row + 1
		end
	end)
	addEventHandler("onClientGUIClick", gui['langWindowCloseBtn'], function(button)
		if (source == gui['langWindowCloseBtn'] and button == "left") then
			local race = 0
			if (guiCheckBoxGetSelected(gui["chkBlack"])) then
				race = 0
			elseif (guiCheckBoxGetSelected(gui["chkWhite"])) then
				race = 1
			elseif (guiCheckBoxGetSelected(gui["chkAsian"])) then
				race = 2
			else
				LoginScreen_showWarningMessage( "Karakter ırkınızı seçiniz." )
				return
			end
			if tonumber(languageselected) == -1 then
				LoginScreen_showWarningMessage( "Karakterin dilini/ülkesini seçiniz." )
				return
			end

			local gender = 0
			if (guiRadioButtonGetSelected( gui["rbMale"] )) then
				gender = 0
			elseif (guiRadioButtonGetSelected( gui["rbFemale"] )) then
				gender = 1
			else
				LoginScreen_showWarningMessage( "Karakter cinsiyetini seçiniz." )
				return
			end

			local skin = getElementModel( ped )
			if not skin then
				LoginScreen_showWarningMessage( "Karakterinizin kıyafetini seçiniz." )
				return
			end
		
			destroyElement(ped)
			Exclusive.destroyCreateCharacter()
			
			triggerServerEvent("accounts:characters:new", localPlayer, pname, 'Valhalla', race, gender, skin, pheight, pweight, page, languageselected, 1, 1, { 1922.9072265625, -1760.6982421875, 13.546875, 0, 0, 0, ""})

			destroyElement(gui['langWindow'])
			gui['langWindow'] = nil
					
		end
	end)
end

function newCharacter_response(statusID, statusSubID)
	if (statusID == 1) then
		LoginScreen_showWarningMessage( "Oops, Birşeyler ters gitmiş olmalı.\nBir yöneticiye başvurun.\nHata KODU"..tostring(statusSubID) )
	elseif (statusID == 2) then
		if (statusSubID == 1) then
			LoginScreen_showWarningMessage( "Bu karakter ismi kullanılıyor\nbaşka bir isim kullanın." )
		else
			LoginScreen_showWarningMessage( "Oops, Birşeyler ters gitmiş olmalı.\nBir yöneticiye başvurun.\nHata KODU"..tostring(statusSubID) )
		end
	elseif (statusID == 3) then
		triggerServerEvent("accounts:characters:spawn", getLocalPlayer(), statusSubID, nil, nil, nil, nil, true)
	
		return
	end
end
addEventHandler("accounts:characters:new", getRootElement(), newCharacter_response)


function newCharacter_raceFix()
	guiCheckBoxSetSelected ( gui["chkAsian"], false )
	guiCheckBoxSetSelected ( gui["chkWhite"], false )
	guiCheckBoxSetSelected ( gui["chkBlack"], false )
	if (source == gui["chkBlack"]) then
		guiCheckBoxSetSelected ( gui["chkBlack"], true )
	elseif (source == gui["chkWhite"]) then
		guiCheckBoxSetSelected ( gui["chkWhite"], true )
	elseif (source == gui["chkAsian"]) then
		guiCheckBoxSetSelected ( gui["chkAsian"], true )
	end

	curskin = 1
	newCharacter_changeSkin(0)
end

function newCharacter_updateGender()
	local diff = 0
	if (source == gui["btnPrevSkin"]) then
		diff = -1
	elseif (source == gui["btnNextSkin"]) then
		diff = 1
	else
		curskin = 1
	end
	newCharacter_changeSkin(diff)
end


function newCharacter_changeSkin(diff)
	local array = newCharacters_getSkinArray()
	local skin = 0
	if (diff ~= nil) then
		curskin = curskin + diff
	end

	if (curskin > #array or curskin < 1) then
		curskin = 1
		skin = array[1]
	else
		curskin = curskin
		skin = array[curskin]
	end

	if skin ~= nil then
		setElementModel(ped, tonumber(skin))
	end
end

function newCharacters_getSkinArray()
	local array = { }
	if (guiCheckBoxGetSelected( gui["chkBlack"] )) then -- BLACK
		if (guiRadioButtonGetSelected( gui["rbMale"] )) then -- BLACK MALE
			array = blackMales
		elseif (guiRadioButtonGetSelected( gui["rbFemale"] )) then -- BLACK FEMALE
			array = blackFemales
		else
			outputChatBox("İlk önce bir cinsiyet seç!", 0, 255, 0)
		end
	elseif ( guiCheckBoxGetSelected( gui["chkWhite"] ) ) then -- WHITE
		if ( guiRadioButtonGetSelected( gui["rbMale"] ) ) then -- WHITE MALE
			array = whiteMales
		elseif ( guiRadioButtonGetSelected( gui["rbFemale"] ) ) then -- WHITE FEMALE
			array = whiteFemales
		else
			outputChatBox("İlk önce bir cinsiyet seç!", 0, 255, 0)
		end
	elseif ( guiCheckBoxGetSelected( gui["chkAsian"] ) ) then -- ASIAN
		if ( guiRadioButtonGetSelected( gui["rbMale"] ) ) then -- ASIAN MALE
			array = asianMales
		elseif ( guiRadioButtonGetSelected( gui["rbFemale"] ) ) then -- ASIAN FEMALE
			array = asianFemales
		else
			outputChatBox("İlk önce bir cinsiyet seç!", 0, 255, 0)
		end
	end
	return array
end

function isInBox(startX, startY, sizeX, sizeY)
    if isCursorShowing() then
        local cursorPosition = {getCursorPosition()};
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

function toRGBA(color)
    local r = bitExtract(color, 16, 8 ) 
    local g = bitExtract(color, 8, 8 ) 
    local b = bitExtract(color, 0, 8 ) 
    local a = bitExtract(color, 24, 8 ) 
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