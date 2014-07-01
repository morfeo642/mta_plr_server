

--[[!
	\file
	\brief Este es un script que debe ser incluido en todos los recursos a excepción
	del recurso module
]]

function loadModule(modulePath, environment)
	if not environment then 
		environment = _G;
	end;
	local code = call(getResourceFromName("module"), "getModule", modulePath);
	local chunk = load(code, nil, "t", environment);
	chunk();
end;

-- Ejecutamos los scripts esenciales.
loadModule("core/client_loader");
