local friends = {}


function now()
	return getRealTime().timestamp
end

function loadAccountData( accountID )
	if accountID then
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					for index, data in ipairs(res) do
						friends[ accountID ].name = data.username
						friends[ accountID ].lastOnline = tonumber(data.time)
						friends[ accountID ].message = data.friendsmessage
					end
				end
			end,
		mysql:getConnection(), "SELECT username, UNIX_TIMESTAMP(lastlogin) AS time, friendsmessage FROM accounts WHERE id = ?", accountID)
		return true
	end
	return false
end

--
-- loads all friends from the database
--
function loadFriends( accountID )
	if not friends[ accountID ] then
		return false, "Invalid data structure"
	end
	
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				while #friends[ accountID ] > 0 do
					table.remove(friends[ accountID ], 1)
				end
				for index, row in ipairs(res) do
					table.insert(friends[accountID], tonumber(row.friend))
				end
				friends[accountID].loadedFriends = true
			end
		end,
	mysql:getConnection(), "SELECT friend FROM friends WHERE id = ?", accountID)
	return true
end

--
-- sends all his friends to the player himself.
--
local maxTime = 14 * 24 * 60 * 60
function sendFriends( player, accountID )
	if not accountID or not friends[ accountID ]then -- that happens.
		outputDebugString( "social:sendFriends - tried to call on non-existent ID " .. tostring( getPlayerName( player )) .. " " .. tostring( accountID ) .. " " .. tostring( friends[ accountID ]))
		return
	end
	
	local t = { }
	
	-- hacky workaround to get the lowest time, ideally making time calculations client-side workey.
	for _, otherAccount in ipairs( friends[ accountID ] ) do
		if not friends[ otherAccount ] then
			friends[ otherAccount ] = { }
		end
		
		if not friends[ otherAccount ].name then
			loadAccountData( otherAccount )
		end
		
		local friend = friends[ otherAccount ]
		if friend.name then
			-- this is a hack for horrible mta precision.
			local timestr = nil
			local la = friend.lastOnline
			if now( ) - la > maxTime then
				timestr = formatTimeInterval( la )
			else
				la = maxTime - now( ) + la
			end
			
			table.insert( t, { otherAccount, friend.name, friend.message, friend.player or timestr or la } )
		else
			outputDebugString( "social:sendFriends: Account " .. otherAccount .. " does not exist?" )
			friends[ otherAccount ] = nil
		end
	end
	
	triggerClientEvent( player, "social:friends", player, t, friends[ accountID ].message, maxTime )
end

--
-- notifies all friends of his.
--
function notifyFriendsOf( player, accountID, event, ... )
	for _, friend in ipairs( getElementsByType( "player" ) ) do
		local friendID = getElementData( friend, "account:id" )
		if friendID and friends[ friendID ] then
			for k, v in ipairs( friends[ friendID ] ) do
				if v == accountID then
					triggerClientEvent( friend, event, player, accountID, ... )
					triggerClientEvent( friend, "showNotificationForStatusOnline", player, accountID)
					break
				end
			end
		end
	end
end

--
-- Logs into an account
--
addEvent("social:vrp_account")
addEventHandler("social:vrp_account", root,
	function( accountID )
		if not friends[ accountID ] then
			friends[ accountID ] = { }
		end
		
		-- load needed data name/message/lastonline, while maybe weird to load it -here- the same formula applies for all not-loggedin-yet accounts.
		if not friends[ accountID ].name then
			loadAccountData( accountID )
		end
		
		-- make sure a palyer's friends are loaded
		if not friends[ accountID ].loadedFriends then
			loadFriends( accountID )
		end
		
		friends[ accountID ].lastOnline = now( )
		friends[ accountID ].player = source
		
		sendFriends( source, accountID )
		notifyFriendsOf( source, accountID, "social:vrp_account" )
	end
)

addEvent("social:character") -- unused, maybe as friends messages? iunno.
--
-- Log everyone who's ingame when starting this in
--
addEventHandler( "onResourceStart", resourceRoot,
	function( )
		for _, player in ipairs( getElementsByType( "player" ) ) do
			local accountID = getElementData( player, "account:id" )
			if accountID then
				friends[ accountID ] = { player = player, lastOnline = now( ) }
				loadAccountData( accountID )
				loadFriends( accountID )
			end
		end
	end
)

addEvent( "social:ready", true )
addEventHandler( "social:ready", root,
	function( )
		local accountID = getElementData( client, "account:id" )
		if accountID then
			sendFriends( client, accountID )
			notifyFriendsOf( client, accountID, "social:vrp_account" )
		end
	end
)

--
-- Delete old player references
--
addEventHandler( "onPlayerQuit", root,
	function( )
		local accountID = getElementData( source, "account:id" )
		if accountID and friends[ accountID ] then
			friends[ accountID ].player = nil
			friends[ accountID ].lastOnline = now( )
		end
	end
)

--
-- Updating your own friends message
--
addEvent( "social:message", true )
addEventHandler( "social:message", root,
	function( message )
		local accountID = getElementData( client, "account:id" )
		if accountID and friends[ accountID ] then
			if dbExec(mysql:getConnection(), "UPDATE accounts SET friendsmessage = '" .. (message) .. "' WHERE id = " .. (accountID) ) then
				friends[ accountID ].message = message
				notifyFriendsOf( client, accountID, "social:message", message )
				
				triggerClientEvent( client, "social:message", client, accountID, message )
			end
		end
	end
)

--
-- Removing one of your friends
--
addEvent( "social:remove", true )
addEventHandler( "social:remove", root,
	function( otherAccount )
		local accountID = getElementData( client, "account:id" )
		if accountID and friends[ accountID ] and friends[ otherAccount ] then
			local found = false
			for k, v in ipairs( friends[ accountID ] ) do
				if v == otherAccount then
					found = k
				end
			end
			
			if not found then
				outputChatBox( "Not your friend.", client, 255, 0, 0 )
			else
				-- update the database accordingly
				dbExec(mysql:getConnection(), "DELETE FROM friends WHERE id = " .. (accountID) .. " AND friend = " .. (otherAccount) )
				dbExec(mysql:getConnection(), "DELETE FROM friends WHERE id = " .. (otherAccount) .. " AND friend = " .. (accountID) )
				
				-- remove the entries
				table.remove( friends[ accountID ], found )
				for k, v in ipairs( friends[ otherAccount ] or { } ) do
					if v == accountID then
						table.remove( friends[ otherAccount ], k )
						break
					end
				end
				
				-- let the people know
				triggerClientEvent( client, "social:remove", client, otherAccount )
				outputChatBox( "You removed " .. friends[ otherAccount ].name .. " from your friends list.", client, 0, 255, 0 )
				local other = friends[ otherAccount ].player
				if other then
					triggerClientEvent( other, "social:remove", other, accountID )
				end
			end
		end
	end
)


local pendingFriends = { }
function new_addFriend( from, to )
	local fromID = getElementData( from, "account:id" )
	local toID = getElementData( to, "account:id" )
	if not fromID or not toID then
		outputChatBox( "Flying Unicorn Dipshit error. Did you try to login?", from, 255, 0, 0 )
		return
	end
	
	for k, v in ipairs({fromID, toID}) do
		if not friends[ v ] then
			friends[ v ] = { }
			outputDebugString( "Fixed friends list at the point A" .. tostring( v ))
		end
		
		if not friends[ v ].name then
			loadAccountData( v )
			outputDebugString( "Fixed friends list at the point B" .. tostring( v ))
		end
		
		-- make sure a palyer's friends are loaded
		if not friends[ v ].loadedFriends then
			loadFriends( v )
			outputDebugString( "Fixed friends list at the point C" .. tostring( v ))
		end
	end
	
	if fromID and friends[ fromID ] and toID and friends[ toID ] then
		local onFromList = false
		for k, v in ipairs( friends[ fromID ] ) do
			if v == toID then
				onFromList = true
			end
		end
		
		if onFromList then
			outputChatBox( getPlayerName( to ):gsub("_", " ") .. " is on your friends list as " .. friends[ toID ].name .. ".", from, 255, 194, 14 )
		else
			local onToList = false
			for k, v in ipairs( friends[ toID ] ) do
				if v == fromID then
					onToList = true
				end
			end
			
			if onToList then -- the OTHER player has him on his friends list. shouldn't happen, but oh well.
				dbExec(mysql:getConnection(), "INSERT INTO friends VALUES(" .. (fromID) .. ", " .. (toID) .. ")" )
				outputChatBox( getPlayerName( to ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ toID ].name .. ".", from, 0, 255, 0 )
				table.insert( friends[ fromID ], toID )
				sendFriends( from, fromID )
			else
				-- need permissiosn first
				triggerClientEvent( to, "askAcceptFriend", from )
				pendingFriends[ to ] = from
			end
		end
	else
		outputChatBox( "Theoretically Impossible Error.", from, 255, 0, 0 )
	end
end

function addFriendCmd( thePlayer, commandName, targetPlayer )
   local targetPlayer, targetPlayerName = exports.vrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
   local fromID = getElementData( thePlayer, "account:id" )
   local toID = getElementData( targetPlayer, "account:id" )
   if not (targetPlayer) then
      outputChatBox( "SYNTAX: /" .. commandName .. " [ID]", thePlayer, 255, 194, 14)
      return
   end
   for k, v in ipairs({fromID, toID}) do
      if not friends[ v ] then
         friends[ v ] = { }
         outputDebugString( "Fixed friends list at the point A" .. tostring( v ))
      end
      
      if not friends[ v ].name then
         loadAccountData( v )
         outputDebugString( "Fixed friends list at the point B" .. tostring( v ))
      end
      
      -- make sure a palyer's friends are loaded
      if not friends[ v ].loadedFriends then
         loadFriends( v )
         outputDebugString( "Fixed friends list at the point C" .. tostring( v ))
      end
   end
   
   if fromID and friends[ fromID ] and toID and friends[ toID ] then
      local onFromList = false
      for k, v in ipairs( friends[ fromID ] ) do
         if v == toID then
            onFromList = true
         end
      end
      
      if onFromList then
         outputChatBox( getPlayerName( targetPlayer ):gsub("_", " ") .. " is on your friends list as " .. friends[ toID ].name .. ".", thePlayer, 255, 194, 14 )
      else
         local onToList = false
         for k, v in ipairs( friends[ toID ] ) do
            if v == fromID then
               onToList = true
            end
         end
         
         if onToList then
            dbExec(mysql:getConnection(), "INSERT INTO friends VALUES(" .. (fromID) .. ", " .. (toID) .. ")" )
            outputChatBox( getPlayerName( to ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ toID ].name .. ".", thePlayer, 0, 255, 0 )
            outputChatBox( getPlayerName( from ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ fromID ].name .. ".", targetPlayer, 0, 255, 0 )
            table.insert( friends[ fromID ], toID )
            sendFriends( thePlayer, fromID )
         else
            outputChatBox("Asking for permission...", thePlayer, 0, 255, 0 )
            triggerClientEvent( targetPlayer, "askAcceptFriend", thePlayer )
            pendingFriends[ targetPlayer ] = thePlayer
         end
      end
   else
      outputChatBox( "Theoretically Impossible Error.", thePlayer, 255, 0, 0 )
   end
end
addCommandHandler("addfriend", addFriendCmd)
addEvent( "social:acceptFriend", true )
addEventHandler( "social:acceptFriend", root,
	function( )
		local to = client
		local from = pendingFriends[ client ]
		if not from or not to then
			outputChatBox( "You screwed this one up.", client, 255, 0, 0 )
		else
			local fromID = getElementData( from, "account:id" )
			local toID = getElementData( to, "account:id" )
			dbExec(mysql:getConnection(), "INSERT INTO friends VALUES(" .. (toID) .. ", " .. (fromID) .. ")" )
			dbExec(mysql:getConnection(), "INSERT INTO friends VALUES(" .. (fromID) .. ", " .. (toID) .. ")" )
			table.insert( friends[ fromID ], toID )
			table.insert( friends[ toID ], fromID )
			sendFriends( from, fromID )
			sendFriends( to, toID )
			outputChatBox( getPlayerName( to ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ toID ].name .. ".", from, 0, 255, 0 )
			outputChatBox( getPlayerName( from ):gsub("_", " ") .. " has been added to your friends list as " .. friends[ fromID ].name .. ".", to, 0, 255, 0 )
		end
	end
)


function isFriendOf( fromID, toID )
	for k, v in ipairs( friends[ toID ] or {} ) do
		if v == fromID then
			return true
		end
	end
	return false
end