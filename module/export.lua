
--[[!
	\file
	\brief Este script exporta la función getModule
]]


--[[!
@param moduleName Es el nombre del módulo a cargar.
@param 
]]
function getModule(moduleName)
	-- comprobar que se intenta acceder realmente al código de un módulo.
	assert((type(moduleName) == "string") and (moduleName:len() > 0) and (not moduleName:match("[^0-9,a-z,A-Z,/,_]+")));
	local file = assert(fileOpen(moduleName .. ".lua"));
	-- leer el código.
	local code = fileRead(file, fileGetSize(file));
	
	fileClose(file);
	
	return code;
end;

local __modules = {};

function loadModule(moduleName, environment)
	if not __modules[moduleName] then 
		if not environment then 
			environment = _G;
		end;
		local code = getModule(moduleName);
		local chunk = assert(loadstring(code, nil, "t", environment));
		chunk();
		__modules[moduleName] = true;
	end;
end;