
--[[!
	\file
	\brief Este script debe ser incluido en todos los recursos que requieran usar alguno de los
	módulos que proporciona el recurso module. 
]]

function loadStartupCode() 
	local code = call(getResourceFromName("module"), "getStartupCode");
	
	local chunk, msg = loadstring(code);
	if not chunk then error("Failed to load startup script: " .. msg); end;
	setfenv(chunk, _G);
	
	local success;
	success, msg = pcall(chunk);
	if not success then error("Failed to execute startup script: " .. msg); end;
end;

loadStartupCode();