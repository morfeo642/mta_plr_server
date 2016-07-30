

-- Tabla donde se guardarán las variables de la sesión.
local function chatPrint(...)
	local args = {...};
	if #args == 0 then 
		outputChatBox("nil", 10, 200, 10);
		return;
	end; 
	
	local strs = {};
	for _, arg in ipairs(args) do 
		table.insert(strs, tostring(arg));
	end;
	outputChatBox(table.concat(strs, "  "), 10, 200, 10);
end;
local env = setmetatable({print=chatPrint}, {__index=_G});

-- Comandos de terminal para ejecutar código LUA
local function luaInterpreter( _, ...) 
	local chunk, msg = loadstring(table.concat({...}, " "));
	if not chunk then outputChatBox("Error parsing: " .. msg, 255, 0, 0); return; end;
	
	setfenv(chunk, env);
	
	outputChatBox(">> " .. table.concat({...}, " "), 200, 200, 10);
	local success;
	success, msg = pcall(chunk);
	if not success then outputChatBox("Error: " .. msg, 255, 0, 0); return; end;
end

addCommandHandler('lua-client',  luaInterpreter, false);
addCommandHandler('lua-cli', luaInterpreter, false);
addCommandHandler('luac', luaInterpreter, false);
