-- Global Events
addEvent("accounts:login:request", true)
addEvent("accounts:login:attempt", true)
addEvent("accounts:characters:list", true)
addEvent("accounts:characters:spawn", true)
addEvent("accounts:characters:change", true)
addEvent("accounts:characters:logout", true)
addEvent("accounts:options", true)
addEvent("accounts:options:settings", true)	-- 
addEvent("accounts:options:settings", true)
addEvent("accounts:characters:new", true)
addEvent("edu", true)
addEvent("onChatacterLogin", true)
addEvent("accounts:logout", true)
addEvent("accounts:error:window", true)

-- Local events
addEvent("accounts:settings:loadGraphicSettings", true)
addEvent("onCharacterLogin", true)
addEvent("onClientChangeChar", false)
addEvent("account:changingchar", true)

-- Shared variables
scriptVersion = exports.vrp_global:getScriptVersion()
newsURL = "http://owlgaming.net/server/news.php"
rulesURL = "http://owlgaming.net/server/rules.php"

-- Password hashes
passwordPrivateHash = "dsasdf98328dn80qmd09RoleplayGhMTAgfhneofinasd0892"
passwordPublicHash = "sadf9weriuc90k3r90asdu3j90rudjwe90rjxwpefvssdoFmdsf"

-- default spawn position while no character is selected.
defaultCharacterSelectionSpawnPosition = { -1480, -1688, 13 }

-- Global functions
function checkValidCharacterName(theText)
	local foundSpace, valid = false, true
	local lastChar, current = ' ', ''
	for i = 1, #theText do
		local char = theText:sub( i, i )
		if char == ' ' then -- it's a space
			if i == #theText then -- space at the end of name is not allowed
				valid = false
				return false, "İsminizin sonunda boşluk olamaz"
			else
				foundSpace = true -- we have at least two name parts
			end
			
			if #current < 2 then -- check if name's part is at least 2 chars
				valid = false
				return false, "İsminiz çok kısa olamaz"
			end
			current = ''
		elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
			if char < 'A' or char > 'Z' then
				valid = false
				return false, "İsminizin baş harfi büyük olmalı."
			end
			current = current .. char
		elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) or (char == "'") then -- can have letters anywhere in the name
			current = current .. char
		else -- unrecognized char (numbers, special chars)
			valid = false
			return false, "İsminizde bilinmeyen karakterler bulunuyor sadece A-Z'ye kadar karakter kullanabilirsiniz"
		end
		lastChar = char
	end
	
	if valid and foundSpace and #theText <= 22 and #theText >= 2 then
		return true, "İyi gözüküyor!" -- passed
	else
		return false, "İsim çok uzun yada çok kısa \n(Minimum 2, Maximum 22)" -- failed for the checks
	end
end