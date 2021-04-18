function checkValidCharacterName(theText)
	local foundSpace, valid = false, true
	local lastChar, current = ' ', ''
	for i = 1, #theText do
		local char = theText:sub( i, i )
		if char == ' ' then -- it's a space
			if i == #theText then -- space at the end of name is not allowed
				valid = false
				return false, "Isminizde yanlislik bulundu."
			else
				foundSpace = true -- we have at least two name parts
			end
			
			if #current < 2 then -- check if name's part is at least 2 chars
				valid = false
				return false, "Sizin isminiz çok kısa."
			end
			current = ''
		elseif lastChar == ' ' then -- this char follows a space, we need a capital letter
			if char < 'A' or char > 'Z' then
				valid = false
				return false, "Isminizde sadece baş harfler büyük ormalıdır.."
			end
			current = current .. char
		elseif ( char >= 'a' and char <= 'z' ) or ( char >= 'A' and char <= 'Z' ) or (char == "'") then -- can have letters anywhere in the name
			current = current .. char
		else -- unrecognized char (numbers, special chars)
			valid = false
			return false, "Isminizde bilinmeyen karakterler kullanilmis olabilir, Sadece A'dan Z'ye kadar kullanabilirsiniz."
		end
		lastChar = char
	end
	
	if valid and foundSpace and #theText < 25 and #current >= 2 then
		return true, "Looking good!" -- passed
	else
		return false, "Isminiz çok uzun veya çok kısa \n(minimum 2, maximum 25) olmalı." -- failed for the checks
	end
end

function checkValidUsername(username)
	if string.len(username) < 3 then
		return false, "Kullanıcı adınız minimum 3 karakter olmalı."
	elseif string.len(username) >= 15 then
		return false, "Kullanıcı adınız max 15 karakter olmalı."
	elseif string.match(username,"%W") then
		return false, "Kullanıcı adınızda uygunsuz karakter olmamalıdır."
	else
		return true, "Başarılı."
	end
end