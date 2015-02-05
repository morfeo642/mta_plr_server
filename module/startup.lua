

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

--[[ Si el módulo esta bloqueado y otro módulo le tiene como dependencia, no incrementa su cuenta compartida ]]
local locked = {};

local module_caller = false;

--[[ Debemos incorporar un mecanismo de forma que el script de un módulo no puede liberar módulos (solo podrá cargarlos) ]] 
local unload_locked = false;

function loadModule(modulePath)
	local function getChunk() 
		local code = call(getResourceFromName("module"), "getModule", modulePath);
		if not code then error("Failed to get script \"" .. modulePath .. ".lua\"", 3); end;
		local chunk, msg = loadstring(code);
		if not chunk then error("Failed to load script \"" .. modulePath .. ".lua\"; " .. msg, 3); end;
		return chunk;
	end;	
	
	local function getEnvironment()
		return setmetatable({},
			{
				__index = _G
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
		local prev_unload_lock_state = unload_locked;
		module_caller = modulePath;
		unload_locked = true;
		locked[module_caller] = true; 
		chunk();
		locked[module_caller] = nil;
		unload_locked = prev_unload_lock_state;
		module_caller = prev_module_caller;
		
		environments[modulePath] = env;
	else
		-- Incrementar la cuente compartida si el módulo no está bloqueado.
		if not locked[modulePath] then 
			shared_count[modulePath] = shared_count[modulePath] + 1;
		end;
	end;
end;

function unloadModule(modulePath)
	--[[ Un módulo no puede liberar otros módulos, solo cargarlos ]]
	assert(not unload_locked);

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


function getUserLoadedModules()
	local modules = {};
	for module, module_loaded in pairs(loaded) do 
		if module_loaded then 
			table.insert(modules, module);
		end;
	end;
	return modules;
end;

function getAllLoadedModules() 
	local modules = {};
	for module, _ in pairs(shared_count) do 
		table.insert(modules, module);
	end;
	return modules;
end;


--[[ Esta tabla guarda el estado de las variables cargadas por cada módulo,
antes de la carga del mismo (su valor en la tabla _G anterior a la carga) ]]
local prev_vars = {};

--[[ Guardamos las variables cargadas por cada uno de los módulos ]]
local post_vars = {};

--[[ Guarda el historial de la carga de módulos, de esta manera, sabemos el orden en
el que estos se cargaron ]]
local load_history = {};

local __environments = {};

setmetatable(environments, 
	{
		__newindex = 
			function(t, modulePath, env) 
				if env ~= nil then -- El módulo se carga
					--[[Copiamos el estado de las variables cargadas por el
					módulo, desde la tabla _G y desde el ambiente del módulo ]]
					local prev = {};
					local post = {};
					for index, value in pairs(env) do prev[index] = _G[index]; post[index] = value; end;
	
					-- Copiamos los valores cargados a la tabla _G.
					for index, value in pairs(post) do _G[index] = value; end;
					
					prev_vars[modulePath] = prev;
					post_vars[modulePath] = post;
					load_history[#load_history+1] = modulePath;
				else -- El módulo se libera.
					local post = post_vars[modulePath];
					local prev = prev_vars[modulePath];
					
					local i = 1;
					while load_history[i] ~= modulePath do 
						i = i + 1;
					end;
					
					-- Por cada una de las variables cargadas por el módulo.
					for index, post_value in pairs(post) do 
						if post_value ~= _G[index] then  -- Fue modificada por el usuario o por algún otro módulo.
							-- La variable fue cargada por algún otro módulo que fue iniciado después de este módulo ?
							
							if i < #load_history then 
								local j = i + 1;
								while (j < #load_history) and (post_vars[load_history[j]][index] == nil) do 
									j = j + 1;
								end;
								local k = load_history[j];
								if post_vars[k][index] ~= nil then 
									--[[ No modificamos el valor actual de _G pero si el valor previo para el modulo k, para
									dicha variable. De esta forma, cuando este módulo se libere, tendrá el valor previo a la carga del
									módulo que se está liberando ahora ]] 
									prev_vars[k][index] = prev[index];
								end;
							end;
						else
							--[[ En caso negativo, restaurar el valor previo en la tabla _G. Normalmente prev[index]=nil; Esto hara que 
							las variables del módulo sean recolectadas por el recolector de basura ]]
							_G[index] = prev[index];
						end;
					end;
					
					post_vars[modulePath] = nil;
					prev_vars[modulePath] = nil;
					table.remove(load_history, i);
				end;
				
				__environments[modulePath] = env;
			end,
		
			__index = __environments
	});


importModule = loadModule;
freeModule = unloadModule;
releaseModule = unloadModule;

