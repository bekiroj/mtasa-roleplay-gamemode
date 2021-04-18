-- exploding
function explode(div,str) -- credit: http://richard.warburton.it
  if (div=='') then return false end
  local pos,arr = 0,{}
  -- for each divider found
  for st,sp in function() return string.find(str,div,pos,true) end do
    table.insert(arr,string.sub(str,pos,st-1)) -- Attach chars left of current divider
    pos = sp + 1 -- Jump past current divider
  end
  table.insert(arr,string.sub(str,pos)) -- Attach chars right of last divider
  return arr
end

-- bekiroj
function getUrlFromString(message)
	if not message or string.len(message) < 1 then
		return false
	end

	for _, v in ipairs(split(message, ' ')) do
		if v:sub(1, 7) == 'http://' or v:sub(1, 8) == 'https://' or v:sub(1, 4) == 'www.' then
			return v
		end
	end
	
	return false
end

function getRandomSkin()
	while true do 
		local ran = math.random(1,288)
		local ped = createPed(ran, 0, 0, 3)
		if ped then
			destroyElement(ped)
			return ran
		end
	end
end

function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

local alphanumberics = {
	['1'] = true,
	['2'] = true,
	['3'] = true,
	['4'] = true,
	['5'] = true,
	['6'] = true,
	['7'] = true,
	['8'] = true,
	['9'] = true,
	['0'] = true,
	['q'] = true,
	['w'] = true,
	['e'] = true,
	['r'] = true,
	['t'] = true,
	['y'] = true,
	['u'] = true,
	['i'] = true,
	['o'] = true,
	['p'] = true,
	['a'] = true,
	['s'] = true,
	['d'] = true,
	['f'] = true,
	['g'] = true,
	['h'] = true,
	['j'] = true,
	['k'] = true,
	['l'] = true,
	['z'] = true,
	['x'] = true,
	['c'] = true,
	['v'] = true,
	['b'] = true,
	['n'] = true,
	['m'] = true,
	['-'] = true,
	['_'] = true,
	['.'] = true,
}

function hasSpecialChars(str)
	for i = 1, string.len(str) do
		local char = string.lower(string.sub(str, i, i))
		if not alphanumberics[char] then
			return true
		end
	end
	return false
end

function isEmail(str)
	if not str or str == "" or string.len(str) < 1 then
		return false, "Email must not be empty."
	end

	local _,nAt = str:gsub('@','@') -- Counts the number of '@' symbol
	
	if nAt ~=1 then 
		return false, "Email must contain one and only one '@'."
	end

	if str:len() > 100 then
		return false, "Email must not be longer than 100 characters."
	end

	local text = exports.vrp_global:explode('@', str) 
	local localPart = text[1]
	local domainPart = text[2]
	if not localPart or not domainPart then 
		return false, "Email local or domain part is missing." 
	end

	if hasSpecialChars(localPart) then
		return false, "Email local part is invalid." 
	end

	if hasSpecialChars(domainPart) then
		return false, "Email domain part is invalid." 
	end

	return true, "Email address is valid!"
end
