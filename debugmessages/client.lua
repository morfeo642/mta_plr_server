--[[!
	\file
	\brief Este script se encarga de mostrar los mensajes de depuración mediante diálogos (ventanas)
]]

local debugLevel = 0;
local dialogType = {"error", "warning", "info", "info"};
local messageDialogs = {};
local maxMessageDialogs = 4;
	
-- si se produce un mensaje de depuración, creamos un diálogo... 
addEventHandler("onClientDebugMessage", root,
	function(message, level, file, line)
		if level == 0 then level = 4; end;
		if (level > debugLevel) then return; end;
		message = ": \"" .. message .. "\"";
		if line then 
			message = "at line " .. line .. ", " .. message;
		end;
		if file then 
			message = "in file \"" .. file .. "\", " .. message;
		end;
		
		if #messageDialogs == maxMessageDialogs then 
			guiDestroyElement(messageDialogs[1]);
			table.remove(messageDialogs, 1);
		end;
		local dialogs = exports.guidialog;
		local dialog = dialogs:createMessageDialog(0.35+math.random(0, 100) / 850, 0.35+math.random(0, 100)/850, "Debug message", message, true, dialogType[level], "ok");
		messageDialogs[#messageDialogs+1] = dialog;
		
		addEventHandler("onClientMessageDialogClose", dialog,	
			function()
				local i = 1;
				while (source ~= messageDialogs[i]) do 
					i = i + 1;
				end;
				table.remove(messageDialogs, i);
			end, false);
	end);

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		__client.setDebugLevel = 
			function(level) 
				debugLevel = level; 
			end;
	end);