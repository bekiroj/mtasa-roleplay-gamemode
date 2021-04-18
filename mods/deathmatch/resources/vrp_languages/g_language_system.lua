languages = {
	"English",
}
	
flags = {
	"en",
}


function getLanguageName(language)
	return languages[language] or 'English'
end

function getLanguageCount()
	return #languages
end

function getLanguageList()
	return languages
end