
--[[!
	\file
	\brief Es un módulo con utilidades para el paso de mensajes cliente/servidor.
]]

--[[! Esta es una tabla que contendrá las funciones que los clientes
podrán invocar remotamente. Se puede realizar lo siguiente para que los clientes
puedan acceder a cualquier función del servidor: __server = _G ]]
__server = {};


--[[ Tabla auxiliar para los callbacks del servidor ]]
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


--[[! Esta es una tabla que usará el servidor para invocar remotamente funciones de los clientes ]]
__client = {};
setmetatable(__client,
	{
		__metatable = false,
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
											assert(type(funcCallback) == "function");
											-- Registramos el callback.
											__server_callbacks[tostring(funcCallback)] = funcCallback;
											triggerClientEvent(client, "onServerCallClientFunction", root, index, tostring(funcCallback), ...);
										end;
								end
						});
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
			-- invocar el método y devolver una respuesta.
			triggerClientEvent(client, "onClientCallServerFunctionResponse", root, funcCallback, pcall(call_func, func, ...));
		end;
	end);

--[[ Que hacemos cuando el cliente nos envía la respuesta después de haber invocado alguno de sus 
métodos? ]]
addEvent("onServerCallClientFunctionResponse", true);
addEventHandler("onServerCallClientFunctionResponse", root,
	function(funcCallback, ...) 
		if client then 
			__server_callbacks[funcCallback](...);
		end;
	end);


