mysql = exports.vrp_mysql

function leader_check (accountName, password)
	local leader = tonumber( getElementData(client, "factionleader") )
		
	if not (tonumber(leader)==1) then -- If the player is not the leader
		triggerClientEvent("notLeader",client)
	else
		register_email(accountName, password)
	end
end
addEvent("leaderCheck",true)
addEventHandler("leaderCheck",getRootElement(),leader_check)

function register_email(accountName, password)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				triggerClientEvent("closeEmailLogin",client)
				local dbid = getElementData(client, "dbid")
				dbExec(mysql:getConnection(),"INSERT INTO emailaccounts SET username='" .. (accountName) .. "', password=MD5('" .. (password) .. "'), creator='"..(dbid).."'") -- Create the account.

				
				get_inbox(accountName)
				get_outbox(accountName)
			else
				triggerClientEvent("name_in_use", client) 
			end
		end,
	{client}, mysql:getConnection(), "SELECT username FROM emailaccounts WHERE username='" .. (accountName) .."'")
end
addEvent("registerEmail", true)
addEventHandler("registerEmail", getRootElement(),register_email)

function login_email(accountName, password)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				triggerClientEvent("closeEmailLogin",client)
				get_inbox(accountName)
				get_outbox(accountName)
			else
				triggerClientEvent("loginError", client)
			end
		end,
	{client}, mysql:getConnection(), "SELECT * FROM emailaccounts WHERE username='" .. (accountName) .."' AND password=MD5('" .. (password) .. "')")
end
addEvent("loginEmail", true)
addEventHandler("loginEmail", getRootElement(),login_email)

function get_inbox(accountName)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				inbox_table = {}
				key = 1
				for index, row in ipairs(res) do
					inbox_table[key] = { }
					inbox_table[key][1] = row["id"]
					inbox_table[key][2] = row["newdate"]
					inbox_table[key][3] = row["sender"]
					inbox_table[key][4] = row["subject"]
					inbox_table[key][5] = row["message"]
					key = key + 1
				end
				if(key==1)then
					inbox_table = {
						{ "","","","","Inbox is empty" },
					}
				end
				triggerClientEvent("showInbox",client,inbox_table, accountName)
			end
		end,
	{client}, mysql:getConnection(), "SELECT id, `date` - INTERVAL 1 hour as 'newdate', sender, subject, message FROM emails WHERE receiver='".. (accountName) .."' AND inbox='1' ORDER BY date DESC")
end
addEvent("s_getInbox",true)
addEventHandler("s_getInbox",getRootElement(),get_inbox)

function get_outbox(accountName)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				local key, outbox_table = 1, {}
				for index, row in ipairs(res) do
					outbox_table[key] = { }
					outbox_table[key][1] = row["id"]
					outbox_table[key][2] = row["newdate"]
					outbox_table[key][3] = row["receiver"]
					outbox_table[key][4] = row["subject"]
					outbox_table[key][5] = row["message"]
					key = key + 1
				end
				if(key==1)then
					outbox_table = {
						{ "","","","","Outbox is empty" },
					}
				end
				triggerClientEvent("showOutbox",source,outbox_table, accountName)
			end
		end,
	{client}, mysql:getConnection(), "SELECT id, `date` - INTERVAL 1 hour as 'newdate', receiver, subject, message FROM emails WHERE sender='".. (accountName) .."' AND outbox='1' ORDER BY date DESC")
end
addEvent("s_getOutbox",true)
addEventHandler("s_getOutbox",getRootElement(),get_outbox)

function send_message(accountName,to,subject,message)
	dbQuery(
		function(qh, client)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				dbExec(mysql:getConnection(),"INSERT INTO emails SET date= NOW(), sender='".. (accountName) .."', receiver='" .. (to) .. "', subject='" .. (subject) .. "', message='" .. (message) .. "', inbox='1', outbox='1'")
				get_outbox(accountName)
				triggerClientEvent("c_sendMessage",client)
			else
				triggerClientEvent("invalidAddress", client)
			end
		end,
	{client}, mysql:getConnection(), "SELECT username FROM emailaccounts WHERE username='" .. (to) .."'")
end
addEvent("sendMessage",true)
addEventHandler("sendMessage", getRootElement(),send_message)

function delete_inbox_message(id,accountName)
	dbExec(mysql:getConnection(),"UPDATE emails SET inbox=0 WHERE id='" .. (id) .."'")
	dbExec(mysql:getConnection(),"DELETE FROM emails WHERE inbox='0' AND outbox='0'")
	get_inbox(accountName)
end
addEvent("deleteInboxMessage",true)
addEventHandler("deleteInboxMessage", getRootElement(),delete_inbox_message)

function delete_outbox_message(id, accountName)
	dbExec(mysql:getConnection(),"UPDATE emails SET outbox=0 WHERE id='" .. (id) .."'")
	dbExec(mysql:getConnection(),"DELETE FROM emails WHERE inbox='0' AND outbox='0'")
	get_outbox(accountName)
end
addEvent("deleteOutboxMessage",true)
addEventHandler("deleteOutboxMessage", getRootElement(),delete_outbox_message)