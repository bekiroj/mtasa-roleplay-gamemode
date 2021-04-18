local localPlayer = getLocalPlayer()

questionsBike = { 
	{"Yolun hangi tarafından gitmelisiniz?", "Sol", "Sağ", "Yukardakilerden hepsi.", 2},
	{"Güvenlik ekipmanları(örneğin;Kask) kullanmanın amacı nedir?", "Havalı görünmek.", "Korunmak.", "Dikkat çekmek.", 2},
	{"Kamyonların kör noktası neresidir:", "Gövdenin hemen arkası.", "Kabinin hemen solu.", "Yukarıdakilerden hepsi." , 3},
	{"Trafik levhaları genellikle hangi renkte olur?", "Yeşil.", "Mavi.", "Kırmızı." , 3},
	{"Bir motorsikletin trafiğe çıkabilmesi için en az kaç CC motoru olması gerekmektedir?", "50cc", "125cc", "250cc" , 1},
	{"Duble yollarda sürücü hangi şeritte gitmelidir?", "Herhangi bir şeritte.", "Sol şeritte.", "Sağ şeritte sürüp, sollama yapmak için değiştirmelidir.", 3},
	{"Keskin viraja yavas girilmesinin sebebi nedir?", "Lastikleri korumak icin.", "Onunu gorebilmen icin.", "Eger yolda birisi varsa diye durmak icin.", 3},
	{"Kasklar ne için üretilmiştir?", "Havalı stickerlar yapıştırmak için.", "Yüzünüzü polisten saklamak için", "Başınızı korumak için." , 3},
	{"Bir yangin musluguna kac feet yakinda parkedemezsin?", "10 feet", "15 feet", "20 feet", 2},
	{"Aşağıdakilerden hangi motor büyüklüğündeki bir aracı kullanmak için ehliyet gerekmemektedir?", "50cc", "125cc", "250cc" , 1},
}

guiIntroLabel1B = nil
guiIntroProceedButtonB = nil
guiIntroWindowB = nil
guiQuestionLabelB = nil
guiQuestionAnswer1RadioB = nil
guiQuestionAnswer2RadioB = nil
guiQuestionAnswer3RadioB = nil
guiQuestionWindowB = nil
guiFinalPassTextLabelB = nil
guiFinalFailTextLabelB = nil
guiFinalRegisterButtonB = nil
guiFinalCloseButtonB = nil
guiFinishWindowB = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseBikeTestIntroWindow()
	showCursor(true)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindowB = guiCreateWindow ( X , Y , Width , Height , "Motor Yazılı Sınavı" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindowB)
	
	guiIntroLabel1B = guiCreateLabel(0, 0.3,1, 0.5, [[Motosiklet yazılı sınavına katılacaksınız.
Temel sürüş teorisi hakkında 7 soru sorulacaktır. Sınavı geçmek için
en az %80 puan almanız gerekmektedir.

Bol Şanslar.]], true, guiIntroWindowB)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1B, "center", true )
	guiSetFont ( guiIntroLabel1B,"default-bold-small")
	
	guiIntroProceedButtonB = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Start Test" , true ,guiIntroWindowB)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButtonB,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceBikeTest()
			guiSetVisible(guiIntroWindowB, false)
		
		end
	end, false)
	
end

-- done bike up to here

-- function create the question window
function createBikeLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindowB = guiCreateWindow ( X , Y , Width , Height , "Soru: "..number.." / "..NoQuestionToAnswer , false )
	
	guiQuestionLabelB = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindowB)
	guiSetFont ( guiQuestionLabelB,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabelB, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1RadioB = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindowB)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2RadioB = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindowB)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3RadioB = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindowB)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButtonB = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Sıradaki Soru" , true ,guiQuestionWindowB)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1RadioB)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2RadioB)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3RadioB)) then
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
					guiSetVisible(guiQuestionWindowB, false)
					createBikeLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButtonB = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Cevapları Gönder" , true ,guiQuestionWindowB)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1RadioB)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2RadioB)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3RadioB)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4RadioB)) then
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
					guiSetVisible(guiQuestionWindowB, false)
					createBikeTestFinishWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createBikeTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindowB = guiCreateWindow ( X , Y , Width , Height , "Sınav Sonu.", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindowB)
	
		guiFinalPassLabelB = guiCreateLabel(0, 0.3, 1, 0.1, "Tebrikler! Sınavın bu kısmını başarıyla geçtiniz.", true, guiFinishWindowB)
		guiSetFont ( guiFinalPassLabelB,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabelB, "center")
		guiLabelSetColor ( guiFinalPassLabelB ,0, 255, 0 )
		
		guiFinalPassTextLabelB = guiCreateLabel(0, 0.4, 1, 0.4, "Sınavdan %"..score.." aldınız, sınavı geçmek için gereken %"..passPercent..". Tebrikler!" ,true, guiFinishWindowB)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabelB, "center", true)
		
		guiFinalRegisterButtonB = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Devam Et" , true ,guiFinishWindowB)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				

				initiateBikeTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				triggerEvent("onClientPlayerWeaponCheck", source)
				--cleanup
				destroyElement(guiIntroLabel1B)
				destroyElement(guiIntroProceedButtonB)
				destroyElement(guiIntroWindowB)
				destroyElement(guiQuestionLabelB)
				destroyElement(guiQuestionAnswer1RadioB)
				destroyElement(guiQuestionAnswer2RadioB)
				destroyElement(guiQuestionAnswer3RadioB)
				destroyElement(guiQuestionWindowB)
				destroyElement(guiFinalPassTextLabelB)
				destroyElement(guiFinalRegisterButtonB)
				destroyElement(guiFinishWindowB)
				guiIntroLabel1B = nil
				guiIntroProceedButtonB = nil
				guiIntroWindowB = nil
				guiQuestionLabelB = nil
				guiQuestionAnswer1RadioB = nil
				guiQuestionAnswer2RadioB = nil
				guiQuestionAnswer3RadioB = nil
				guiQuestionWindowB = nil
				guiFinalPassTextLabelB = nil
				guiFinalRegisterButtonB = nil
				guiFinishWindowB = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindowB)
	
		guiFinalFailLabelB = guiCreateLabel(0, 0.3, 1, 0.1, "Üzgünüz, sınavı geçemediniz.", true, guiFinishWindowB)
		guiSetFont ( guiFinalFailLabelB,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabelB, "center")
		guiLabelSetColor ( guiFinalFailLabelB ,255, 0, 0 )
		
		guiFinalFailTextLabelB = guiCreateLabel(0, 0.4, 1, 0.4, "Sınavdan %"..math.ceil(score).." aldınız, sınav geçme puanı %"..passPercent.."." ,true, guiFinishWindowB)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabelB, "center", true)
		
		guiFinalCloseButtonB = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Kapat" , true ,guiFinishWindowB)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1B)
				destroyElement(guiIntroProceedButtonB)
				destroyElement(guiIntroWindowB)
				destroyElement(guiQuestionLabelB)
				destroyElement(guiQuestionAnswer1RadioB)
				destroyElement(guiQuestionAnswer2RadioB)
				destroyElement(guiQuestionAnswer3RadioB)
				destroyElement(guiQuestionWindowB)
				destroyElement(guiFinalPassTextLabelB)
				destroyElement(guiFinalRegisterButtonB)
				destroyElement(guiFinishWindowB)
				guiIntroLabel1B = nil
				guiIntroProceedButtonB = nil
				guiIntroWindowB = nil
				guiQuestionLabelB = nil
				guiQuestionAnswer1RadioB = nil
				guiQuestionAnswer2RadioB = nil
				guiQuestionAnswer3RadioB = nil
				guiQuestionWindowB = nil
				guiFinalPassTextLabelB = nil
				guiFinalRegisterButtonB = nil
				guiFinishWindowB = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
	
end
 
 -- function starts the quiz
 function startLicenceBikeTest()
 
	-- choose a random set of questions
	chooseBikeTestQuestions()
	-- create the question window with question number 1
	createBikeLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseBikeTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testBikeQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testBikeQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questionsBike[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testBikeQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questionsBike[number][1]) then
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
------ bekiroj reborn ---------
---------------------------------------
 
testBikeRoute = {
	{ 1092.20703125, -1759.1591796875, 13.023070335388 },	-- Start, DoL Parking 
	{ 1167.5771484375, -1743.3544921875, 13.066892623901 }, -- DoL exit, turning right
	{ 1172.787109375, -1847.158203125, 19.026597976685 }, -- Headed towards Governors office
	{ 1065.896484375, -1849.12890625, 16.367393493652 }, -- Riding towards Idlewood
	{ 925.26953125, -1771.0849609375, 15.35952663421 }, -- ^^
	{ 919.7431640625, -1649.41015625, 23.666763305664 }, -- Turning towards PD
	{ 919.6005859375, -1571.771484375, 20.558561325073 }, -- ^^ dasd
	{ 919.8583984375, -1418.666015625, 18.464895248413 }, -- Stop at PD, turn right
	{ 882.8935546875, -1393.04296875, 18.106065750122 }, -- Stop at SAN, turn left
	{ 799.5390625, -1392.513671875, 17.796844482422 }, -- ^^
	{ 799.8525390625, -1251.1513671875, 17.328392028809 }, -- End of SAN, behind PD turn left
	{ 799.4365234375, -1147.6943359375, 29.017375946045 }, -- Heading past PD
	{ 1003.322265625, -1149.1708984375, 28.562902450562 }, -- Next to PD
	{ 1218.322265625, -1149.8310546875, 28.231573104858 }, -- At intersection on commerce
	{ 1338.32421875, -1150.201171875, 28.032217025757 }, -- Stop @ St. Lawrence, turn right
	{ 1410.587890625, -1156.3662109375, 27.674402236938 }, -- Turn left towards ASH @ speed cam
	{ 1452.6005859375, -1163.404296875, 27.471717834473 }, -- ^^
	{ 1452.6328125, -1305.162109375, 18.106805801392 }, -- Next to ASH
	{ 1662.4921875, -1304.35546875, 21.173782348633 }, -- Heading down the road
	{ 1785.8447265625, -1280.896484375, 20.573799133301 }, -- ^^
	{ 1834.5029296875, -1263.3486328125, 19.142808914185 }, -- Turn right at Vinyl Countdown
	{ 1845.55859375, -1368.8193359375, 18.745582580566 }, -- ^^
	{ 1841.6455078125, -1507.3623046875, 17.187942504883 }, -- Heading towards Dillimore
	{ 1819.0869140625, -1608.9736328125, 16.795764923096 }, -- ^^
	{ 1817.732421875, -1728.9638671875, 15.280220031732 }, -- Turn left @ Dillimore road
	{ 1657.3154296875, -1730.2373046875, 20.963199615479 }, -- ^^
	{ 1457.63671875, -1729.130859375, 18.5263748168956 }, -- Going towards Bank
	{ 1316.884765625, -1729.916015625, 15.702321052551 }, -- ^^
	{ 1315.001953125, -1584.060546875, 15.466000556946 }, -- Turn left at bank
	{ 1324.498046875, -1527.017578125, 21.183603286743 }, -- ^^
	{ 627.8359375, -1308.2685546875, 13.577067375183 }, -- Going towards Beach
	{ 1360.2216796875, -1410.115234375, 21.428215026855 }, -- ^^
	{ 1331.8056640625, -1394.03515625, 18.576225280762 }, -- ^^
	{ 1064.9765625, -1393.59375, 15.905570983887 }, -- Turn left into road
	{ 1050.83984375, -1481.71484375, 26.314035415649 }, -- ^^
	{ 1034.75, -1591.044921875, 18.334888458252 }, -- End of road, turn left
	{ 1032.2470703125, -1715.0400390625, 17.945663452148 }, -- ^^
	{ 1168.1357421875, -1715.234375, 17.612911224365 }, -- Heading back towards DoL
	{ 1173.2822265625, -1737.0205078125, 17.446229934692 }, -- ^^
	{ 1092.1708984375, -1738.41015625, 16.998432159424 }, -- turn right towards DoL
}

testBike = { [468]=true } -- Mananas need to be spawned at the start point.

local blip = nil
local marker = nil

function initiateBikeTest()
	triggerServerEvent("theoryBikeComplete", getLocalPlayer())
	local x, y, z = testBikeRoute[1][1], testBikeRoute[1][2], testBikeRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startBikeTest)
	
	outputChatBox("#FF9933Artık pratik sürüş sınavınıza girmeye hazırsınız. Bir DoL test bisikleti alın ve rotaya başlayın.", 255, 194, 14, true)
	
end

function startBikeTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testBike[id]) then
			outputChatBox("#FF9933Kontrol noktalarından geçerken DoL test bisikleti kullanıyor olmalısınız.", 255, 0, 0, true ) -- Wrong  type.
		else
			destroyElement(blip)
			destroyElement(marker)
			
			local vehicle = getPedOccupiedVehicle ( getLocalPlayer() )
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testBikeRoute[2][1]
			y1 = testBikeRoute[2][2]
			z1 = testBikeRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testBikeRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateBikeCheckpoints)
				
			outputChatBox("#FF9933Test bisikletine zarar vermeden rotayı tamamlamanız gerekecek. İyi şanslar ve güvenli sür.", 255, 194, 14, true)
		end
	end
end

function UpdateBikeCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testBike[id]) then
			outputChatBox("Kontrol noktalarından geçerken DoL test bisikletinde olmalısınız.", 255, 0, 0) -- Wrong car type.
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
				
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#FF9933Testi tamamlamak için bisikletinizi park yerine #FF66CCpark yerine #FF9933park edin.", 255, 194, 14, true)
				
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
					
				local x2, y2, z2 = nil
				x2 = testBikeRoute[newnumber][1]
				y2 = testBikeRoute[newnumber][2]
				z2 = testBikeRoute[newnumber][3]
				
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				
				addEventHandler("onClientMarkerHit", marker, EndBikeTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
						
				local x2, y2, z2 = nil
				x2 = testBikeRoute[newnumber][1]
				y2 = testBikeRoute[newnumber][2]
				z2 = testBikeRoute[newnumber][3]
						
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				addEventHandler("onClientMarkerHit", marker, UpdateBikeCheckpoints)
			end
		end
	end
end

function EndBikeTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		local id = getElementModel(vehicle)
		if not (testBike[id]) then
			outputChatBox("Kontrol noktalarından geçerken DoL test bisikletinde olmalısınız.", 255, 0, 0)
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if (vehicleHealth >= 800) then
				----------
				-- PASS --
				----------
				outputChatBox("Aracı inceledikten sonra herhangi bir hasar göremiyoruz.", 255, 194, 14)
				triggerServerEvent("acceptBikeLicense", getLocalPlayer())
			
			else
				----------
				-- Fail --
				----------
				outputChatBox("Aracı inceledikten sonra hasar gördüğünü görebiliriz.", 255, 194, 14)
				outputChatBox("Pratik sürüş testinde başarısız oldunuz.", 255, 0, 0)
			end
			
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
		end
	end
end