local x, y		= guiGetScreenSize();
local h 		= 30;
local rot		= 80;
local exists 	= {};

local mods;

local function downloadMods()
	for i, v in ipairs (mods) do 
		local file = v.file;
		downloadFile (file);
	end
end	

function table.find (tbl, index, value)
	for i, v in pairs (tbl) do 
		if v[index] == value then 
			return i;
		end
	end
	return false;
end	

addEvent ("loader.request", true);
addEventHandler ("loader.request", root,
	function (tbl)
		if tbl then 
			mods = tbl;
			downloadMods();
		end
	end
);

addEventHandler ("onClientResourceStart", resourceRoot, 
	function ()
		triggerServerEvent ("loader.onload", localPlayer);
	end
);

addEventHandler ("onClientFileDownloadComplete", root,
	function (name, success)
		if ( source == resourceRoot ) then
			if success then
				local index = table.find (mods, "file", name);
				if index then 
					exists[name] = true;
					-- downloadFile (name);
					local model = mods[index].model;
					if name:find (".dff") then
						local dff = engineLoadDFF (name)
						engineReplaceModel (dff, model);
					elseif name:find (".txd") then 
						local txd = engineLoadTXD (name);
						engineImportTXD(txd, model);
					end	
					tick = getTickCount()+2000;
				end	
			end
		end
	end
);	