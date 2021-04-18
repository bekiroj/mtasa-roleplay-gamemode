addEvent("playTTS", true) -- Add the event
 
local function playTTS(text, lang)
    local URL = "http://translate.google.com/translate_tts?tl=" .. lang .. "&q=" .. text
    -- Play the TTS. BASS returns the sound element even if it can not be played.
    return true, playSound(URL), URL
end
addEventHandler("playTTS", root, playTTS)