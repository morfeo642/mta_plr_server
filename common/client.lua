

--[[!
	\file
	\brief Este es un script que debe ser incluido en todos los recursos a excepción
	del recurso module
]]

-- Añadimos una tabla de módulos cargados para evitar errores en dependencias circulares.
local __modules = {};

function loadModule(modulePath, environment)
	if not __modules[modulePath] then  
		if not environment then 
			environment = _G;
		end;
		local code = call(getResourceFromName("module"), "getModule", modulePath);
		local chunk = loadstring(code, nil, "t", environment);
		
		__modules[modulePath] = true; 
		local success, msg = pcall(chunk);
		if not success then error("Error loading module \"" .. modulePath .. "\":" .. msg); end;
	end;
end;

importModule = loadModule;

-- Ejecutamos los scripts esenciales.
loadModule("core/client_loader");
