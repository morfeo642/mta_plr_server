
--[[!
	\file
	\brief Este script exporta la función getModule
]]


--[[!
@param moduleName Es el nombre del módulo a cargar. 
@return Devuelve el código del móudulo en formato de cadena de caracteres (string) y no
en formato binario. 
@note Lanza una excepción si el nombre del módulo no es válido (no es un string o contiene
caracteres no válidos, o bien si el módulo no existe)

@note Todos los recursos podrán cargar módulos via loadModule que invocarán a esta función para 
obtener el código binario. Notese que sin el recurso module, los demás recursos no podrán cargar el código.
El recurso debe añadir a su archivo meta.xml la etiqueta <include resource="module" />, pero aun así, si el recurso
"module" no está en ejecución. No pueden importarse módulos al ejecutarse el script del servidor en primera instancia, 
pero se garantiza que después de que se produzca el evento "onResourceStart" de dicho recurso, los módulos podrán comenzarse
a cargar.
]]
function getModule(moduleName)
	-- comprobar que se intenta acceder realmente al código de un módulo.
	assert(type(moduleName) == "string");

	local file = assert(fileOpen(moduleName .. ".lua"), "Module \"" .. moduleName .. "\" not exists");
	-- leer el código.
	local code = fileRead(file, fileGetSize(file));
	
	fileClose(file);
	
	return code;
end;



--[[!
@return Devuelve el código que debe ser ejecutado tanto en la parte del cliente como en la parte del servidor antes de ejecutar
cualquier otro script, para todos los recursos (De esta forma, el resto de scripts podrán usar los módulos facilitados por este recurso)
]]
function getStartupCode()
	local file = assert(fileOpen("startup.lua"), "Couldn`t load startup code");
	local startupCode = fileRead(file, fileGetSize(file));
	fileClose(file);
	return startupCode;
end;