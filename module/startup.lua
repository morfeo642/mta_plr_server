

--[[!
	\file
	\brief Este es un script que contendrá el código que será devuelto por la función getStartupCode que será
	exportada por este recurso. 
]]


-- Guarda información que indica si un módulo ha sido cargado o no por el usuario.
local loaded = {};

-- Almacena información indicando si un módulo concreto ha sido cargado como dependencia de otro módulo.
local loaded_as_dependency = {};

--[[ Cada módulo en ejecución tiene una cuenta compartida que se incrementa cada vez que el usuario u otro
modúlo lo cargan, y se decrementa cuando, bien el usuario o el módulo que dependia de este, se liberan. 
Si llega a 0, el módulo en ejecución ya no es necesario y debe ser recolectado. ]] 
local shared_count = {};

--[[ Guarda por cada módulo, las posibles dependencias con otros módulos ]]
local dependencies = {};

--[[ Guarda los ambientes donde se declararán las variables globales de los módulos ]]
local environments = {};

--[[ Guarda unos manejadores que serán invocados cuando los módulos son liberados (se usa para deshacer posibles
cambios realizados por los módulos en el ambiente global de la tabla _G) ]]
local release_callbacks = {};

local module_caller = false;


function loadModule(modulePath)
	local function getChunk() 
		local code = call(getResourceFromName("module"), "getModule", modulePath);
		local chunk, msg = loadstring(code);
		if not chunk then error("Failed to load script \"" .. ".lua\"; " .. msg, 3); end;
		return chunk;
	end;	
	
	local function getEnvironment()
		return setmetatable({_G=_G},
			{
				__newindex = 
					function(t, index, value) 
						if index ~= "__release_callback" then 
							rawset(t, index, value);
						else
							assert(type(value) ~= "function");
							release_callbacks[modulePath] = value;
						end;
					end
			});
	end;
	
	-- Un módulo no puede cargarse a si mismo.
	assert(module_caller ~= modulePath);

	-- No hacemos nada si el usuario es el que carga el módulo, y ya lo ha cargado
	-- con anterioridad.
	if (not module_caller) and loaded[modulePath] then 
		return; 
	end;
	
	-- El código del módulo ha sido cargado ? 
	local code_loaded = loaded[modulePath] or loaded_as_dependency[modulePath];
	
	-- Es cargado por el usuario o por otro módulo ? 
	if module_caller then 
		--[[ Añadir a la lista de dependencias del módulo invocante,
		este módulo ]]
		local caller_dependencies = dependencies[module_caller];
		caller_dependencies[#caller_dependencies+1] = modulePath;
		
		loaded_as_dependency[modulePath] = true;
	else
		-- Fue cargado por el usuario.
		loaded[modulePath] = true;
	end;
	
	if not code_loaded then 
		-- Inicializar la cuenta compartida y las dependencias
		shared_count[modulePath] = 1;
		dependencies[modulePath] = {};
		
		-- Obtener el ambiente y el código del módulo
		local env, chunk = getEnvironment(), getChunk();
		
		-- Establecer el ambiente del módulo
		setfenv(chunk, env);
		
		-- Ejecutar el código del módulo.
		local prev_module_caller = module_caller;
		module_caller = modulePath;
		chunk();
		module_caller = prev_module_caller;
		
		environments[modulePath] = env;
	else
		-- Incrementar la cuente compartida.
		shared_count[modulePath] = shared_count[modulePath] + 1;
	end;
end;

function unloadModule(modulePath)
	--[[ No hacemos nada si el módulo es liberado por el usuario y ya lo ha 
	liberado con anterioridad o bién, el usuario nunca lo cargó ]]
	if (not module_caller) and (not loaded[modulePath]) then 
		return;
	end;
	
	-- Decrementar la cuenta compartida, y liberar el módulo si llega a cero.
	shared_count[modulePath] = shared_count[modulePath] - 1;
	
	if module_caller then 
		if ((not loaded[modulePath]) and (shared_count[modulePath] == 0)) or
		(loaded[modulePath] and (shared_count[modulePath] == 1)) then
			loaded_as_dependency[modulePath] = false;
		end;
	else
		loaded[modulePath] = false;
	end;
	
	if shared_count[modulePath] == 0 then 
		-- Liberar el módulo.
		
		-- Invocar el manejador asociado al módulo.
		if release_callback[modulePath] ~= nil then 
			local callback = release_callback[modulePath];
			setfenv(callback, {_G=_G});
			pcall(callback);
		end;
		environments[modulePath] = nil
		
		-- Reducir la cuenta compartida de los modulos de los que depende.
		local prev_module_caller = module_caller;
		module_caller = modulePath;
		for _, dependency in ipairs(dependencies[modulePath]) do 
			unloadModule(dependency);
		end;
		module_caller = prev_module_caller;
		
		-- Eliminamos la información del módulo liberado.
		loaded[modulePath] = nil;
		loaded_as_dependency[modulePath] = nil;
		shared_count[modulePath] = nil;
		dependencies[modulePath] = nil;
		release_callback[modulePath] = nil;
	end;
end;

--[[ Establecer una metatabla a la tabla global _G para que el resto de scripts 
pueda acceder a las funciones de los módulos importados ]]
setmetatable(_G,
	{
		__index = 
			function(_, index) 
				-- Buscar en los ambientes de los módulos.
				if next(environments) ~= nil then 
					local index, env = next(environments);
					while (next(environments,index) ~= nil) and (env[index] ~= nil) do 
						index,env = next(environments, index);
					end;
					return env[index];
				end;
			end,
		__metatable = false
	});

importModule = loadModule;
freeModule = unloadModule;
releaseModule = unloadModule;

