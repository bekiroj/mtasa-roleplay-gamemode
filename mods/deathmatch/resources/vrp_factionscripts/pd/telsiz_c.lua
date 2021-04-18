function playtelsiz()
local telsiz = playSound("pd/telsizsesi.mp3",false)
setSoundVolume(telsiz, 0.9)
end
addEvent("telsiz",true)
addEventHandler("telsiz",getRootElement(),playtelsiz)

function playRadioSound()
	playSoundFrontEnd(47)
	setTimer(playSoundFrontEnd, 700, 1, 48)
	setTimer(playSoundFrontEnd, 800, 1, 48)
end
addEvent( "telsiz2", true )
addEventHandler( "telsiz2", getRootElement(), playRadioSound )

function playPanic()
local panic = playSound("pd/panic.mp3",false)
setSoundVolume(panic, 0.9)
end
addEvent("panic",true)
addEventHandler("panic",getRootElement(),playPanic)