
--[[!
	\file
	\brief Es un módulo con utilidades para el paso de mensaje cliente/servidor.
]]

--[[! Esta tabla guarda todas las funciones que puede ser llamadas por el servidor ]]
__client = {};


--[[ Guardaremos los callbacks en una tabla auxiliar ]]
local __client_callbacks = {__callback={}, __count={}};
setmetatable(__client_callbacks, 
	{
		__newindex = 
			function(t, index, value) 
				if not t.__count[index] then 
					t.__count[index] = 1;
					t.__callback[index] = value;
				else 
					t.__count[index] = t.__count[index] + 1;
				end;
			end,
		__index =
			function(t, index)
				-- "usamos" el callback una vez.
				t.__count[index] = t.__count[index] - 1; 
				local callback = t.__callback[index];
				if t.__count[index] == 0 then t.__count[index] = nil; t.__callback[index] = nil; end;
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
						assert((type(funcCallback) == "function") or (funcCallback == nil));
						if not funcCallback then 
							-- invocar método del servidor.
							triggerServerEvent("onClientCallServerFunction", localPlayer, serverFunc, nil, ...);
						else 
							-- Registrar el callback para la respuesta del servidor.
							__client_callbacks[tostring(funcCallback)] = funcCallback;
							-- invocar método del servidor.
							triggerServerEvent("onClientCallServerFunction", localPlayer, serverFunc, tostring(funcCallback), ...);
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
				assert(isElement(index) and (getElementType(index) == "player") and (index ~= localPlayer));
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
											assert((type(funcCallback) == "function") or (funcCallback == nil));
											if not funcCallback then 
												triggerServerEvent("onClientCallRemoteClientFunction", localPlayer, remoteClient, remoteClientFunc, nil, ...);
											else 
												-- Registrar callback
												__client_callbacks[tostring(funcCallback)] = funcCallback;
												triggerServerEvent("onClientCallRemoteClientFunction", localPlayer, remoteClient, remoteClientFunc, tostring(funcCallback), ...);
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
addEventHandler("onServerCallClientFunction", root,
	function(func, funcCallback, ...) 
		if not funcCallback then 
			pcall(call_func, func, ...);
		else 
			triggerServerEvent("onServerCallClientFunctionResponse", localPlayer, funcCallback, pcall(call_func, func, ...));
		end;
	end);

--[[ Que hacemos cuando recibimos la respuesta del servidor ? ]]
addEvent("onClientCallServerFunctionResponse", true);
addEventHandler("onClientCallServerFunctionResponse", root,
	function(funcCallback, ...) 
		__client_callbacks[funcCallback](...);
	end);
	

--[[ Que hacemos cuando recibimos la respuesta del servidor de la ejecución de una función de un cliente remoto ? ]]
addEvent("onClientCallRemoteClientFunctionResponse", true);
addEventHandler("onClientCallRemoteClientFunctionResponse", root,
	function(remoteClient, funcCallback, ...)
		__client_callbacks[funcCallback](remoteClient, ...);
	end);

	