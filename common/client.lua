

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
		local chunk, msg = loadstring(code, nil, "t", environment);
		if not chunk then error("Failed to load script \"" .. modulePath .. ".lua\"; " .. msg, 2); end;
		setfenv(chunk, environment); 
		__modules[modulePath] = environment;
		
		success, msg = pcall(chunk);
		if not success then error("Failed to load module \"" .. modulePath .. "\"; " .. msg, 2); end;
		
		return environment;
	end;
	return __modules[modulePath];
end;

importModule = loadModule;

