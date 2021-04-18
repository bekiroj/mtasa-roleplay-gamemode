local localPlayer = getLocalPlayer()

questions = { 
    {"Kırmızı renk körü olanlar trafik ışığında kırmızıyı hangi renk olarak görürler?", "Sarı", "Mavi", "Yeşil", 3},
    {"Bir kaza yaptınız, bu durumda ilk yapacağınız işlem ne olurdu?", "Oradan uzaklaşırdım.", "Trafik polisini çağırırdım.", "Hey adamım, senin sorunun ne derdim.", 2}, 
    {"Sizi sollamaya çalışan bir araba yanlışlıkla ön tamponunuza çarptı. Ne yaparsınız?", "Orospu çocuğu derim.", "Hayvan herif, ne yapıyorsun derim.", "Trafik polisini çağırırım.", 3},
    {"Trafik ışığı kırmızı yanınca ne yapmalısın?", "Aracı komple durdurmalısın.", "Devam etmelisin.", "Kimse gelmiyorsa devam etmelisin.", 1},
    {"Bir LPG'li aracın içine benzin konulur ise ne yapılır?", "Benzin boşaltılır.", "Yavaş gidilir.", "Viraj almayarak gitmelidir.", 1},
    {"Karanlık bir yolda ne yaparsınız?", "Aydınlık olmasını beklerim.", "Telefonumun flashını açarım.", "Aracın farlarını açarım." , 3},
    {"Arkadan bir acil durum aracı sirenleri yakık geliyor. Ne yapmalısın?", "Yavaşlayıp ilerlemelisin.", "Sağa çekip durmalısın.", "Hızını korumalısın.", 2},
    {"Sarı ışıkta geçmeninz cezası var mı", "Boş Şık.", "Evet vardır.", "Hayır, bir cezası yoktur.", 3},
    {"Havada fırtına ve yağmur var bu durumda neler yapman gerekir?", "Arabayı emniyet şeridine çekerim.", "Yoluma devam ederim.", "Drift atarım.", 1},
    {"Bir ambulans yolda sirenlerini yakmış geliyor ne yapmalısın?", "Ambulansın geçmesi için yol veririm.", "Orospu çocuğukluğu yapıp yol vermem.", "Dörtlülerimi yakar yoluma devam ederim", 1}
}


guiIntroLabel1 = nil
guiIntroProceedButton = nil
guiIntroWindow = nil
guiQuestionLabel = nil
guiQuestionAnswer1Radio = nil
guiQuestionAnswer2Radio = nil
guiQuestionAnswer3Radio = nil
guiQuestionWindow = nil
guiFinalPassTextLabel = nil
guiFinalFailTextLabel = nil
guiFinalRegisterButton = nil
guiFinalCloseButton = nil
guiFinishWindow = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseTestIntroWindow()
	
	showCursor(true)
	
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 190
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindow = guiCreateWindow ( X , Y , Width , Height , "Ehliyet Sınavı" , false )
		
	guiIntroLabel1 = guiCreateLabel(0, 0.3,1, 0.5, [[Ehliyet sınavına girmek üzeresin. Sana toplam
7 soru soracağız ve bunların en az 5 sorusunu doğru cevaplamak zorundasın. 
Minimum 80 puana ulaştığında araç testine geçebileceksin.

Bol şans.]], true, guiIntroWindow)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1, "center", true )
	guiSetFont ( guiIntroLabel1,"default-bold-small")
	
	guiIntroProceedButton = guiCreateButton ( 0.37 , 0.75 , 0.25, 0.1 , "HADİ BAŞLAYALIM" , true ,guiIntroWindow)

	addEventHandler ( "onClientGUIClick", guiIntroProceedButton,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceTest()
			guiSetVisible(guiIntroWindow, false)
		
		end
	end, false)
	
end


-- function create the question window
function createLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindow = guiCreateWindow ( X , Y , Width , Height , "Soru "..number.." / "..NoQuestionToAnswer , false )
	
	guiQuestionLabel = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindow)
	guiSetFont ( guiQuestionLabel,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabel, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1Radio = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindow)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2Radio = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindow)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3Radio = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindow)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButton = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Sıradaki Soru" , true ,guiQuestionWindow)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindow, false)
					createLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButton = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Cevapları Doğrula" , true ,guiQuestionWindow)
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButton,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1Radio)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2Radio)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3Radio)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4Radio)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindow, false)
					createTestFinishWindow()


				end
			end
		end, false)
	end
end


function createTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindow = guiCreateWindow ( X , Y , Width , Height , "Sınav Tamamlandı", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindow)
	
		guiFinalPassLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Tebrikler! Sınavın sorularını başarıyla tamamladınız.", true, guiFinishWindow)
		guiSetFont ( guiFinalPassLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabel, "center")
		guiLabelSetColor ( guiFinalPassLabel ,0, 255, 0 )
		
		guiFinalPassTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Sınavdan "..score.." aldınız, sınavı geçmek için gereken "..passPercent.." puandı. Tebrikler." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabel, "center", true)
		
		guiFinalRegisterButton = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Devam Et" , true ,guiFinishWindow)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButton,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				

				initiateDrivingTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				triggerEvent("onClientPlayerWeaponCheck", source)
				--cleanup
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalPassTextLabel)
				destroyElement(guiFinalRegisterButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalPassTextLabel = nil
				guiFinalRegisterButton = nil
				guiFinishWindow = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindow)
	
		guiFinalFailLabel = guiCreateLabel(0, 0.3, 1, 0.1, "Üzgünüz, sınavı geçemediniz.", true, guiFinishWindow)
		guiSetFont ( guiFinalFailLabel,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabel, "center")
		guiLabelSetColor ( guiFinalFailLabel ,255, 0, 0 )
		
		guiFinalFailTextLabel = guiCreateLabel(0, 0.4, 1, 0.4, "Sınavdan "..math.ceil(score).." aldınız, sınavı geçmek için "..passPercent.." almanız gerekiyordu." ,true, guiFinishWindow)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabel, "center", true)
		
		guiFinalCloseButton = guiCreateButton (  0.35 , 0.8 , 0.25, 0.1 , "Kapat" , true ,guiFinishWindow)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButton,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1)
				destroyElement(guiIntroProceedButton)
				destroyElement(guiIntroWindow)
				destroyElement(guiQuestionLabel)
				destroyElement(guiQuestionAnswer1Radio)
				destroyElement(guiQuestionAnswer2Radio)
				destroyElement(guiQuestionAnswer3Radio)
				destroyElement(guiQuestionWindow)
				destroyElement(guiFinalFailTextLabel)
				destroyElement(guiFinalCloseButton)
				destroyElement(guiFinishWindow)
				guiIntroLabel1 = nil
				guiIntroProceedButton = nil
				guiIntroWindow = nil
				guiQuestionLabel = nil
				guiQuestionAnswer1Radio = nil
				guiQuestionAnswer2Radio = nil
				guiQuestionAnswer3Radio = nil
				guiQuestionWindow = nil
				guiFinalFailTextLabel = nil
				guiFinalCloseButton = nil
				guiFinishWindow = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
end
 
 -- function starts the quiz
 function startLicenceTest()
 
	-- choose a random set of questions
	chooseTestQuestions()
	-- create the question window with question number 1
	createLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questions[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questions[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
 end

---------------------------------------
------ Practical Driving Test ---------
---------------------------------------
 
testRoute = {
	{ 1095.091796875, -1742.8212890625, 13.472915649414 },	-- Start, DoL Parking 
	{ 1165.75, -1741.1279296875, 13.3984375 },	-- San Andreas Boulevard DoL near Exit
	{ 1172.6337890625, -1716.642578125, 13.66108417511 }, -- San Andreas Boulevard DoL Exiting turning left
	{ 1150.7724609375, -1709.0517578125, 13.78125 }, 	-- Constituion Ave
	{ 1092.5673828125, -1710.150390625, 13.3828125 }, -- Constituion Ave, turn to St. Lawrence Blvd
	{ 1044.4560546875, -1708.908203125, 13.3828125 }, -- St. Lawrence Blvd
	{ 1035.404296875, -1733.03515625, 13.381277084351 }, 	-- St. Lawrence Blvd, going to Panopticon Ave
	{ 1033.5341796875, -1779.759765625, 13.486225128174 }, 	-- St. Lawrence Blvd, going to Panopticon Ave
	{ 1020.6123046875, -1793.7607421875, 13.766116142273 }, 	-- St. Lawrence Blvd, going to Panopticon Ave
	{ 983.279296875, -1783.95703125, 14.075706481934 },	-- St. Lawrence Blvd, turning on to Panopticon Ave
	{ 930.7041015625, -1773.3408203125, 13.468508720398 },	-- Panopticon Ave
	{ 885.595703125, -1769.0390625, 13.3828125 },	-- Panopticon Ave back on to the opposite side of St. Lawrence Blvd
	{ 828, -1768.1572265625, 13.398876190186 },		-- St. Lawrence Blvd
	{ 777.7900390625, -1764.658203125, 12.974268913269 },	-- Turning on to City Hall Road
	{ 742.763671875, -1759.966796875, 13.232018470764 },	-- City Hall Road
	{ 705.9150390625, -1747.8671875, 13.943346977234 },	-- City Hall Road
	{ 645.37890625, -1730.9072265625, 13.697257041931 },	-- City Hall Road
	{ 578.71875, -1719.8505859375, 13.429384231567 },	-- City Hall Road
	{ 516.9736328125, -1712.2275390625, 12.303507804871 },	-- City Hall Road
	{ 458.0224609375, -1703.8701171875, 10.81685256958 },	-- City Hall Road
	{ 396.935546875, -1700.453125, 8.4426231384277 }, 	-- City Hall Road turning towards IGS
	{ 327.880859375, -1696.2177734375, 6.4923944473267 }, 	-- 
	{ 252.8115234375, -1670.5966796875, 9.7769966125488 }, 	-- 
	{ 211.4580078125, -1626.2548828125, 14.109086990356 }, 	-- IGS
	{ 168.6279296875, -1574.7958984375, 12.609628677368 }, 	-- IGS
	{ 166.1552734375, -1549.142578125, 11.688596725464 }, -- IGS
	{ 193.30078125, -1506.529296875, 12.597169876099 }, 			-- Mulholland parking, Turn to East Vinewood Blvd
	{ 233.6396484375, -1454.3701171875, 13.234567642212 }, 	-- East Vinewood Blvd, turn to Sunset Blvd
	{ 273.1708984375, -1425.7802734375, 13.664143562317 }, 	-- Sunset Blvd
	{ 333.3779296875, -1394.6396484375, 14.160203933716 }, 	-- Sunset Blvd
	{ 418.8916015625, -1346.2451171875, 14.820918083191 }, 	-- Sunset Blvd
	{ 467.2666015625, -1313.8837890625, 15.251661300659 }, 	-- Sunset Blvd, Turn to St. Lawrence Blvd
	{ 532.580078125, -1262.8671875, 16.31901550293 }, 	-- St. Lawrence Blvd
	{ 577.76171875, -1237.7177734375, 17.490205764771 }, 	-- St. Lawrence Blvd, turn to West Broadway
	{ 618.6650390625, -1223.171875, 18.109375 }, 	-- West Broadway
	{ 626.814453125, -1259.5673828125, 17.247274398804 }, -- West Broadway
	{ 628.2080078125, -1327.1748046875, 13.441360473633 }, 	-- Interstate 25
	{ 628.5546875, -1382.927734375, 13.551568031311 }, 	-- Interstate 25
	{ 652.7197265625, -1405.134765625, 13.398855209351 }, 	-- Interstate 125
	{ 706.703125, -1405.3818359375, 13.375135421753 }, 	-- Interstate 125
	{ 766.7685546875, -1405.0380859375, 13.375555038452 }, -- Interstate 125
	{ 816.1396484375, -1405.3896484375, 13.302095413208 }, -- Interstate 125
	{ 872.0146484375, -1405.125, 12.882280349731 }, 	-- Interstate 125
	{ 919.5244140625, -1405.2783203125, 13.265099525452 }, 		-- Interstate 125, turn to Saints Blvd
	{ 1003.69921875, -1404.841796875, 13.015625 }, 	-- Saints Blvd, turn to St Anthony St.
	{ 1049.6494140625, -1405.7021484375, 13.343055725098 }, 		-- St Anthony St, turn to Saints Blvd
	{ 1059.2373046875, -1415.5185546875, 13.382997512817 }, 	-- Saints Blvd
	{ 1057.265625, -1456.5078125, 13.366886138916 }, 	-- Saints Blvd
	{ 1049.099609375, -1489.9130859375, 13.391229629517 }, -- Saints Blvd, turn to Caesar Rd
	{ 1036.8388671875, -1549.1865234375, 13.3515625 }, 		-- mid turn
	{ 1035.8828125, -1589.42578125, 13.3828125 }, 	-- Caesar Rd
	{ 1035.0771484375, -1634.78515625, 13.3828125 }, 	-- Caesar Rd
	{ 1034.484375, -1679.904296875, 13.3828125 }, 	-- Caesar Rd, turn to Freedom St
	{ 1040.0634765625, -1706.783203125, 13.390571594238 }, -- Freedom St
	{ 1076.7431640625, -1714.7763671875, 13.3828125 }, 	-- Freedom St, turn to Carson St
	{ 1129.38671875, -1714.0908203125, 13.443779945374 }, 	-- Carson St
	{ 1162.4072265625, -1714.4931640625, 13.775737762451 }, 		-- Carson St, turn to Atlantica Ave
	{ 1172.234375, -1727.6240234375, 13.579736709595 }, -- Atlantica Ave
	{ 1161.1171875, -1737.88671875, 13.516822814941 }, 	-- Atlantica Ave, turn to Pilon St
	{ 1134.45703125, -1738.8427734375, 13.479679107666 }, 	-- Pilon St
	{ 1102.65625, -1738.6181640625, 13.532820701599 }, -- Pilon St
        { 1087.712890625, -1741.208984375, 13.494572639465 },	-- DoL End road
}

testVehicle = { [410]=true } -- Mananas need to be spawned at the start point.

local blip = nil
local marker = nil

function initiateDrivingTest()
	local carlicense = getElementData(localPlayer, "license.car")
	if carlicense == 0 then 
	triggerServerEvent("theoryComplete", getLocalPlayer())
	local x, y, z = testRoute[1][1], testRoute[1][2], testRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startDrivingTest)
	
	outputChatBox("#575757Valhalla:#f9f9f9 Artık araç sürüş testine girmeye hazırsınız, dışarıdaki sürücü araçlarından birisini alın.", 255, 255, 0, true)
	else
				outputChatBox("#575757Valhalla:#f9f9f9 Zaten bir ehliyetin var.", 255, 0, 0, true)
	end
end

function startDrivingTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#575757Valhalla:#f9f9f9 Sadece ehliyet araçları ile bu bölgeden geçebilirsiniz.", 255, 0, 0, true ) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testRoute[2][1]
			y1 = testRoute[2][2]
			z1 = testRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
				
			outputChatBox("#575757Valhalla:#f9f9f9 Test aracına zarar vermeden sürüşü tamamlamanız gerekiyor, bol şans!", 255, 194, 14, true)
		end
	end
end

function UpdateCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#575757Valhalla:#f9f9f9 Sadece ehliyet araçları ile bu bölgeden geçebilirsiniz.", 255, 0, 0, true ) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
				
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#575757Valhalla:#f9f9f9 Testi tamamlamak için son varış noktasına park edin.", 255, 15, 255, true)
				
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
					
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
				
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				
				addEventHandler("onClientMarkerHit", marker, EndTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
						
				local x2, y2, z2 = nil
				x2 = testRoute[newnumber][1]
				y2 = testRoute[newnumber][2]
				z2 = testRoute[newnumber][3]
						
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				addEventHandler("onClientMarkerHit", marker, UpdateCheckpoints)
			end
		end
	end
end

function EndTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testVehicle[id]) then
			outputChatBox("#575757Valhalla:#f9f9f9 Sadece ehliyet araçları ile bu bölgeden geçebilirsiniz.", 255, 0, 0, true ) -- Wrong car type.
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if (vehicleHealth >= 800) then
				----------
				-- PASS --
				----------
				outputChatBox("#575757Valhalla:#f9f9f9 Aracı inceledik ve bir hasar göremedik.", 255, 194, 14, true)
				triggerServerEvent("acceptCarLicense", getLocalPlayer())
			else
				----------
				-- Fail --
				----------
				outputChatBox("#575757Valhalla:#f9f9f9 Araçta ufak tefek çizikler var, iyi bir şoför olman için iyi bir sürücü olman gerekiyor. Yeniden başvurabilirsin.", 255, 0, 0, true)
			end
			
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
		end
	end
end