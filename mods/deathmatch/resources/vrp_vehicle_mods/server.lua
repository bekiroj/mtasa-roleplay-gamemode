local mods = {};

addEventHandler ("onResourceStart", resourceRoot, 
	function ()
		local meta = xmlLoadFile ("meta.xml");
		parseMeta(mods, meta);
	end
);

addEvent ("loader.onload", true);
addEventHandler ("loader.onload", root, 
	function ()
		triggerLatentClientEvent (client, "loader.request", client, mods);
	end
);	

function parseMeta(tbl, meta)
	for i, v in ipairs (xmlNodeGetChildren(meta)) do 
		if xmlNodeGetName(v) == "file" then 
			local model = tonumber (xmlNodeGetAttribute(v, "model"));
			local file = xmlNodeGetAttribute (v, "src");
			if file ~= "icon.png" then 
				table.insert (tbl, {file = file, model = model});
			end	
		end
	end	
end	