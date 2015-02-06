
--[[!
	\file
	\brief Es un módulo con utilidades para el paso de mensaje cliente/servidor.
	
	\code
	-- Registrar un método para que pueda ser invocado por el servidor remotamente.
	function __client.sayHello()
		outputChatBox("Hallo!");
	end;
	-- Permitir que el servidor pueda ejecutar todas las funciones del cliente.
	__client = _G;
	\endcode
	
	\code
	-- Invoca una función del servidor llamada foo() con los argumentos ...
	__server.foo(nil, ...);
	
	-- Invoca la misma función pero queriendo recibir los valores de retorno de
	la función.
	__server.foo(function(...) outputDebugString(...); end,  ...);

	-- Como podemos comprobar si en el cuerpo de la función hubo un aserto o algún error?
	__server.foo(
		function(success, ...)
			local args = {...};
			if success then -- La ejecución es satisfactoria.
				-- La tabla {...} contedrá los valores de retorno de la función.
				print(args);
			else -- Error.  
				-- El siguiente parámetro es un mensaje indicado la descripción del error.
				print("Error: " .. args[1]);
			end;
		end,  ...);
	\endcode
]]

loadModule("util/assertutils");

--[[! Esta tabla guarda todas las funciones que puede ser llamadas por el servidor ]]
__client = {};


--[[ Guardaremos los callbacks en una tabla auxiliar ]]
local __client_callbacks = {};
local __callback = {};
local __count = {};
setmetatable(__client_callbacks, 
	{
		__newindex = 
			function(t, index, value) 
				if not __count[index] then 
					__count[index] = 1;
					__callback[index] = value;
				else 
					__count[index] = __count[index] + 1;
				end;
				
			end,
		__index =
			function(t, index)
				-- "usamos" el callback una vez.
				__count[index] = __count[index] - 1; 
				local callback = __callback[index];
				if __count[index] == 0 then __count[index] = nil; __callback[index] = nil; end;
				return callback;
			end
	});

--[[! Esta tabla sirve para invocar un método del servidor. 
__server.func_name. Para invocar la función, la sintaxis es: __server.func_name(callback, ...)
Donde ... son los argumentos que se pasarán a la función del servidor.
Callback, en caso de error (si la función no existe o bién se lanzó una asercción en el cuerpo de la función en la
parte del servidor), obtendrá los siguientes argumentos: false, msg (mensaje sobre el error producido).
En el caso de que se haya invocado correctamente el método, se recibirá lo siguiente: true, ...   Donde ... son los valores
de retorno de la función.
 ]] 
__server = {};
setmetatable(__server,
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index)
				local serverFunc = index;
				return 
					function(funcCallback, ...)
						localizedAssert((type(funcCallback) == "function") or (funcCallback == nil), 2, "Invalid arguments");
						if not funcCallback then 
							-- invocar método del servidor.
							triggerServerEvent("onClientCallServerFunction", resourceRoot, serverFunc, nil, ...);
						else 
							-- Registrar el callback para la respuesta del servidor.
							__client_callbacks[tostring(funcCallback)] = funcCallback;
							-- invocar método del servidor.
							triggerServerEvent("onClientCallServerFunction", resourceRoot, serverFunc, tostring(funcCallback), ...);
						end;
					end;
			end
	});
	

--[[!Es una tabla que permite invocar un método de un cliente remoto. ]] 
__remote_client = {};
setmetatable(__remote_client, 
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index)
				localizedAssert(isElement(index) and (getElementType(index) == "player") and (index ~= localPlayer), 2, "Invalid remote client");
				--localizedAssert(isElement(index) and (getElementType(index) == "player"), 2, "Invalid remote client");
				local remoteClient = index;
				return 
					setmetatable({},
						{
							__metatable = false,
							__newindex = function() end,
							__index = 
								function(t, index)
									local remoteClientFunc = index;
									return 
										function(funcCallback, ...)
											localizedAssert((type(funcCallback) == "function") or (funcCallback == nil),2, "Invalid arguments");
											if not funcCallback then 
												triggerServerEvent("onClientCallRemoteClientFunction", resourceRoot, remoteClient, remoteClientFunc, nil, ...);
											else 
												-- Registrar callback
												__client_callbacks[tostring(funcCallback)] = funcCallback;
												triggerServerEvent("onClientCallRemoteClientFunction", resourceRoot, remoteClient, remoteClientFunc, tostring(funcCallback), ...);
											end;
										end;
								end
						});
			end
	});
	
	
	
--[[ Esta es una tabla auxiliar que accede solamente a las funciones y elementos invocables de la tabla
__client ]]

local __client_funcs = {};
setmetatable(__client_funcs, 
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index)
				local value = __client[index];
				if (type(value) == "function") or 
				((type(value) == "table") and (getmetatable(value) ~= nil) and (type(getmetatable(value).__call) == "function")) then
					return value;
				end
			end
	});

local function call_func(funcName, ...)
	local func = assert(__client_funcs[funcName], "Function \"" .. funcName .. "\" not exists");
	return func(...);
end;


--[[ Que hacemos cuando el servidor invoca una de las funciones del cliente ? ]]
addEvent("onServerCallClientFunction", true);
addEventHandler("onServerCallClientFunction", resourceRoot,
	function(func, funcCallback, ...) 
		if not funcCallback then 
			pcall(call_func, func, ...);
		else 
			triggerServerEvent("onServerCallClientFunctionResponse", resourceRoot, funcCallback, pcall(call_func, func, ...));
		end;
	end);

--[[ Que hacemos cuando recibimos la respuesta del servidor ? ]]
addEvent("onClientCallServerFunctionResponse", true);
addEventHandler("onClientCallServerFunctionResponse", resourceRoot,
	function(funcCallback, ...) 
		__client_callbacks[funcCallback](...);
	end);
	

--[[ Que hacemos cuando recibimos la respuesta del servidor de la ejecución de una función de un cliente remoto ? ]]
addEvent("onClientCallRemoteClientFunctionResponse", true);
addEventHandler("onClientCallRemoteClientFunctionResponse", resourceRoot,
	function(remoteClient, funcCallback, ...)
		__client_callbacks[funcCallback](...);
	end);
