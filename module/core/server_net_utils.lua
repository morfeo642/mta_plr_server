
--[[!
	\file
	\brief Es un módulo con utilidades para el paso de mensajes cliente/servidor.
	
	\code
	-- LLamar a la función foo() del cliente llamado "pepito"
	__client[getPlayerFromName("pepito")].foo();
	
	-- LLamar a la función foo() del cliente llamado "juan" y pasarle como parámetros "Hola", "Que", "Tal".
	__client[getPlayerFromName("juan")].foo(nil, "Hola", "Que", "Tal");
	
	-- Lo mismo de antes pero queremos recibir los valores retornados por la función, luego usamos un callback...
	-- imprimimos los valores de retorno en la consola, cuando los recibamos...
	__client[getPlayerFromName("juan")].foo(function(...) print(...); end, "Hola", "Que", "Tal");
	
	-- Como podemos comprobar si en el cuerpo de la función hubo un aserto o algún error?
	__client[gePlayerFromName("juan")].foo(
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
		
	-- Invocar el método bar en todos los clientes conectados...
	__all_clients.bar(nil, ...);
	
	-- Invocar el método bar en todos los clientes, y recibir los valores de retorno...
	__all_clients.bar(function(...) print(...); end, ...); -- El callback será invocado cuando se reciba 
	-- los valores de retorno de un cliente... Se ejecutará tantas veces como clientes haya.
	
	\endcode
	
	\code
	-- Registrar una función para que pueda ser invocada remotamente por los clientes.
	function __server.sayHello()
		print("Hello!");
	end;
	
	-- Permitir que los clientes puedan ejecutar cualquier función del servidor (es poco seguro)
	__server = _G;
	\endcode
]]

--[[! Esta es una tabla que contendrá las funciones que los clientes
podrán invocar remotamente. Se puede realizar lo siguiente para que los clientes
puedan acceder a cualquier función del servidor: __server = _G ]]
__server = {};


--[[ Tabla auxiliar para los callbacks del servidor
 ]]
local __server_callbacks = {__callback = {}, __count = {}};
setmetatable(__server_callbacks, 
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


--[[! Esta es una tabla que usará el servidor para invocar remotamente funciones de los clientes.
__client[cliente].nombre_de_la_funcion(callback, ...) Donde ... son los argumentos a pasar a la función del 
cliente. cliente, es el cliente y callback es una función que será invocada en respuesta a la ejecución de la
función del cliente (se le pasará como argumentos los valores de retorno de la función)
 ]]
__client = {};
setmetatable(__client,
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index)
				assert(isElement(index) and (getElementType(index) == "player"));
				local client = index;
				-- Devuelve una tabla auxiliar para acceder a las funciones del cliente.
				return 
					setmetatable({},
						{
							__metatable = false,
							__newindex = function() end,
							__index = 
								function(t, index)
									return 
										function(funcCallback, ...)
											assert((type(funcCallback) == "function") or (funcCallback == nil));
											-- Registramos el callback.
											if not funcCallback then 
												triggerClientEvent(client, "onServerCallClientFunction", root, index, nil, ...);
											else 
												__server_callbacks[tostring(funcCallback)] = funcCallback;
												triggerClientEvent(client, "onServerCallClientFunction", root, index, tostring(funcCallback), ...);
											end;
										end;
								end
						});
			end
	});
	
--[[! Tabla que permite invocar un método especifíco en todos los clientes simultaneamente. ]]
__all_clients = {};
setmetatable(__all_clients, 
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index) 
				return
					function(funcCallback, ...)
						assert((type(funcCallback) == "function") or (funcCallback == nil));
						if not funcCallback then 
							triggerClientEvent(root, "onServerCallClientFunction", root, index, nil, ...);
						else 
							-- Necesitamos registrar el callback tantas veces como jugadores haya.
							for i=1,#getElementsByType("player", root),1 do __server_callbacks[tostring(funcCallback)] = funcCallback; end;
							triggerClientEvent(root, "onServerCallClientFunction", root, index, tostring(funcCallback), ...);
						end;
					end;
			end
	});


--[[ Esta tabla nos permite acceder únicamente a las funciones incluidas en la tabla
__server ]]
local __server_funcs = {};
setmetatable(__server_funcs,
	{
		__metatable = false,
		__newindex = function() end,
		__index =
			function(t, index)
				local value = __server[index];
				if (type(value) == "function") or 
				((type(value) == "table") and (getmetatable(value) ~= nil) and (type(getmetatable(value).__call) == "function")) then
					return value;
				end;
			end
	});
	
local function call_func(funcName, ...)
	local func = assert(__server_funcs[funcName], "Function \"" .. funcName .. "\" not exists");
	return func(...);
end;


--[[ Que hacemos cuando el cliente quiere invocar una de los métodos del servidor ? ]]
addEvent("onClientCallServerFunction", true);
addEventHandler("onClientCallServerFunction", root,
	function(func, funcCallback, ...)
		-- El evento fue invocado por un cliente ? ...
		if client then 
			if not funcCallback then 
				-- invocar el método.
				pcall(call_func, func, ...);
			else 
				-- invocar el método y devolver una respuesta.
				triggerClientEvent(client, "onClientCallServerFunctionResponse", root, funcCallback, pcall(call_func, func, ...));
			end;
		end;
	end);

--[[ Que hacemos cuando el cliente nos envía la respuesta después de haber invocado alguno de sus 
métodos? ]]
addEvent("onServerCallClientFunctionResponse", true);
addEventHandler("onServerCallClientFunctionResponse", root,
	function(funcCallback, ...) 
		if client then 
			__server_callbacks[funcCallback](client, ...);
		end;
	end);

--[[ Que hacemos cuando el cliente quiere invocar una función de otro cliente... ]]
addEvent("onClientCallRemoteClientFunction", true);
addEventHandler("onClientCallRemoteClientFunction", root,
	function(remoteClient, func, funcCallback, ...)
		if not client then return; end;
		local sourceClient = client;
		
		if not funcCallback then
			__client[remoteClient][func](nil, ...);
		else 
			__client[remoteClient][func](
				function(remoteClient, ...)
					triggerClientEvent(sourceClient, "onClientCallRemoteClientFunctionResponse", root, remoteClient, funcCallback, ...);
				end, ...);
		end;
	end);
