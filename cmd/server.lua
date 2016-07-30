



-- Ambientes para cada superusuario en modo servidor (donde se almacenarán las variables)
local envs = {};

-- Comandos de terminal para ejecutar código LUA 
local function luaInterpreter(playerSource, _, ...) 

	local accountname = getAccountName(getPlayerAccount(playerSource));
    if not isObjectInACLGroup( "user." .. accountname, aclGetGroup ( "Admin" ) ) then
		return;
    end
	local function chatPrint(...)
		local args = {...};
		if #args == 0 then 
			outputChatBox("nil", playerSource, 10, 200, 10);
			return;
		end; 
		
		local strs = {};
		for _, arg in ipairs(args) do 
			table.insert(strs, tostring(arg));
		end;
		outputChatBox(table.concat(strs, "  "), playerSource, 10, 200, 10);
	end;
	
	local chunk, msg = loadstring(table.concat({...}, " "));
	if not chunk then outputChatBox("Error parsing: " .. msg, playerSource, 255, 0, 0); return; end;
	if not envs[playerSource] then 
		envs[playerSource] = setmetatable({print=chatPrint}, {__index=_G});
	end;
	setfenv(chunk, envs[playerSource]);
	
	outputChatBox(">> " .. table.concat({...}, " "), playerSource, 200, 200, 10);
	local success;
	success, msg = pcall(chunk);
	if not success then outputChatBox("Error: " .. msg, playerSource, 255, 0, 0); return; end;
end

addCommandHandler('lua-server',  luaInterpreter, false, false);
addCommandHandler('lua-sv', luaInterpreter, false, false);
addCommandHandler('luas', luaInterpreter, false, false);

	
-- Si un superusuario se desconecta, eliminar variables de su entorno almacenadas para este.
addEventHandler("onPlayerQuit", root, 
	function() 
		envs[source] = nil;
	end);