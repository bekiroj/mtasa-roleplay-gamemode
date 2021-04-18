local Cache = {}
local Months = {
    [0] = "ocak",
    [1] = "şubat",
    [2] = "mart",
    [3] = "nisan",
    [4] = "mayıs",
    [5] = "haziran",
    [6] = "temmuz",
    [7] = "ağustos",
    [8] = "eylül",
    [9] = "ekim",
    [10] = "kasım",
    [11] = "aralık"
}

local emojyList = {
    [":D"] = "",
    [":P"] = "",
    [";P"] = "",
    ["<3"] = "",
    [";D"] = "",
    [":]"] = "",
    [";]"] = "",
    [":O"] = "",
    [":|"] = "",
    --[";["] = "",
    --[":["] = "",
}

function randomString(length)
	local res = ""
	for i = 1, length do
		res = res .. string.char(math.random(97, 122))
	end
	return res
end

function addListener(event, func)
    addEvent(event, true)
    addEventHandler(event, root, func)
end

function hasAccess(player, hashKey)
    for i, v in ipairs(Cache) do
        if tonumber(v.hashKey) == tonumber(hashKey) then
            if tonumber(v.creator) == tonumber(getElementData(player, "dbid")) then
                return true
            end
        end
    end
    if exports.vrp_integration:isPlayerStaff(player) then
        return true
    end
    return false
end


local sortId = 0
local advertisementMessages = { "metal", "samp", "arıyorum", "aranır", "istiyom", "istiyorum", "SA-MP", "roleplay", "ananı", "sikeyim", "sikerim", "orospu", "evladı", "Kye", "arena", "Arina", "rina", "vendetta", "vandetta", "shodown", "Vedic", "vedic","ventro","Ventro", "server", "sincityrp", "ls-rp", "sincity", "tri0n3", "mta", "mta-sa", "query", "Query", "inception", "p2win", "pay to win" }
local spamTimers = {}
addListener("twitter:add",
    function(player, name, location, text)
        local import = getRealTime()
        local date = Months[tonumber(import.month)].." "..import.monthday
        for i, v in pairs(emojyList) do
            text = text:gsub(i, "#fbc531"..v.."#ffffff")
        end
        if not date then date = "N/A" end
        for k,v in ipairs(advertisementMessages) do
            local found = string.find(string.lower(text), "%s" .. tostring(v))
            local found2 = string.find(string.lower(text), tostring(v) .. "%s")
            if (found) or (found2) or (string.lower(text)==tostring(v)) then
                exports.vrp_global:sendMessageToAdmins("AdmWrn: "..getPlayerName(player).." adlı oyuncu yasaklı tweet attı, mesajı:" .. tostring(text))
                outputChatBox("#575757Valhalla:#ffffff Tweet yazısında yasaklı kelimeler bulundu.", player, 255, 0, 0, true)
                return
            end
        end
        if not exports.vrp_integration:isPlayerDeveloper(player) then
        if isTimer(spamTimers[getElementData(player, "dbid")]) then return end
        end
        spamTimers[getElementData(player, "dbid")] = setTimer(function() end, 1000*60*60*3, 1)

        
        local charname = getPlayerName(player):gsub("_"," ")

        sortId = sortId + 1
        local hash = randomString(12)
        Cache[hash] =
            {   
                ["hashKey"] = hash,
                ["charname"] = charname,
                ["name"] = name,
                ["location"] = location,
                ["date"] = date,
                ["text"] = text,
                ["data"] = {like={},save={},retweet={}},
                ["time"] = {getRealTime()},
                ["creator"] = getElementData(player, "dbid"),
                ["sortIndex"] = sortId,
            }
        sync()
    end
)

function alreadyLiked(tbl,id)
    for i, v in pairs(tbl) do
        if (tonumber(i) == tonumber(id)) then
            return true
        end
    end
    return false
end

addListener("twitter:like",
    function(player, hashKey)
        for i, v in ipairs(Cache[hashKey]["data"]["like"]) do
            if (tonumber(v) == tonumber(getElementData(player, "dbid"))) then
                table.remove(Cache[hashKey]["data"]["like"], i)
                return
            end
        end
        table.insert(Cache[hashKey]["data"]["like"], getElementData(player, "dbid"))
        sync()
    end
)

addListener("twitter:save",
    function(player, hashKey)
        for i, v in ipairs(Cache[hashKey]["data"]["save"]) do
            if (tonumber(v) == tonumber(getElementData(player, "dbid"))) then
                table.remove(Cache[hashKey]["data"]["save"], i)
                return
            end
        end
        table.insert(Cache[hashKey]["data"]["save"], getElementData(player, "dbid"))
        sync()
    end
)

addListener("twitter:remove",
    function(player, hashKey)
        if not hasAccess(player, hashKey) then return end
        Cache[hashKey] = nil
        sync()
    end
)

addListener("twitter:retweet",
    function(player, hashKey)
        for i, v in pairs(Cache[hashKey]["data"]["retweet"]) do
            if (tonumber(v) == tonumber(getElementData(player, "dbid"))) then

                return
            end
        end
        if not exports.vrp_integration:isPlayerDeveloper(player) then
            if isTimer(spamTimers[getElementData(player, "dbid")]) then return end
        end
        if Cache[hashKey]["creator"] == getElementData(player, "dbid") then return end

        table.insert(Cache[hashKey]["data"]["retweet"], getElementData(player, "dbid"))

  
        local charname = getPlayerName(player):gsub("_"," ")
        local playerName = getPlayerName(player):gsub("_", "")
        local playerName = playerName:lower()
        local playerName = "@"..playerName
        sortId = sortId + 1
        local hash = randomString(12)
        Cache[hash] =
            {   
                ["hashKey"] = hash,
                ["charname"] = charname,--Cache[hashKey].charname,
                ["name"] = playerName,--Cache[hashKey].name,
                ["location"] = Cache[hashKey].location,
                ["date"] = Cache[hashKey].date,
                ["text"] = Cache[hashKey].text,
                ["data"] = {like={},save={},retweet={}},
                ["creator"] = getElementData(player, "dbid"),
                ["sortIndex"] = sortId,
                ["time"] = {getRealTime()},
                ["retweeter"] = {owner=getElementData(player, "dbid"), charname=charname, data=Cache[hashKey]},
            }
        sync()
    end
)

function sync()
    --setElementData(resourceRoot, "twitterFlow", toJSON(Cache))
   -- if plr then root = plr end
    triggerClientEvent(root, "SyncTwitterCache", root, Cache)
end
addListener("twitter:cache", sync)

setTimer(
    function()
        Cache = {}
       
        sync()
    end,
1000*60*60*6, 0
)