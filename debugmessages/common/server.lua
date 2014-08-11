

--[[!
	\file
	\brief Este es un script que debe ser incluido en todos los recursos a excepción
	del recurso module
]]

-- Añadimos una tabla de módulos cargados para evitar errores en dependencias circulares.
local __modules = {};

--[[!
	Carga un módulo
	@param modulePath Es la ruta del módulo
	@param environment Es la tabla donde se guardarán las variables globales del módulo. 
	@return Devuelve environment si el módulo no fue previamente cargado. Si el módulo fue previamente
	cargado, devuelve la tabla de donde residen sus variables globales (el módulo no vuelve a cargarse)
]]
function loadModule(modulePath, environment)
	if not __modules[modulePath] then  
		if not environment then 
			environment = _G;
		end;
		local code = call(getResourceFromName("module"), "getModule", modulePath);
		local success, chunk = pcall(loadstring, code, nil, "t", environment);
		if not success then error("Failed to load script \"" .. modulePath .. ".lua\"; " .. chunk); end;
		setfenv(chunk, environment); 
		__modules[modulePath] = environment;
		
		local msg;
		success, msg = pcall(chunk);
		if not success then error("Failed to load module \"" .. modulePath .. "\"; " .. msg); end;
		
		return environment;
	end;
	return __modules[modulePath];
end;

importModule = loadModule;


-- Ejecutamos los scripts esenciales.

if getResourceState(getResourceFromName("module")) == "running" then 
	loadModule("core/server_loader");
else 
	addEventHandler("onResourceStart", root,
		function(theResource) 
			if theResource == getResourceFromName("module") then loadModule("core/server_loader", _G); end;
		end);
end;
