
--[[!
	\file 
	\brief Este script permite establecer un protocolo entre diferentes recursos 
	para compartir variables e invocar funciones exportadas con mayor facilidad.
	
	\code
	-- Invocar la función foo() del recurso "bar".
	bar.foo(...);
	\endcode
	
	\code
	-- Establecer la variable global compartida "x" de "bar" a 50.
	bar.x = 50; -- solo funciona si la variable x está marcada como pública.
	\endcode
	
	\code
	-- Como compartir una variable para que los demás recursos puedan tanto escribirla como leerla ? 
	__share.x = ...;
	-- O también
	__share.public.x = ...; -- por defecto, si se indica como __share.x, la variable es pública.
	\endcode
	
	\code
	-- Para crear variables compartidas protegidas...
	__share.protected.x = ...;
	\endcode
]]	


--[[! En esta tabla se añaden funciones y variables que se quieren compartir, pero no pueden
crearse nuevas variables. En la tabla __share.public se almacenan las variables que son de lectura y escritura, y 
la tabla __share.protected, las variables de solo lectura]]
__share = {};
__share.public = {}; 
__share.protected = {};
setmetatable(__share,
	{
		__metatable = false,
		__index = 
			function(t, index) 
				if t.public[index] ~= nil then 
					return t.public[index];
				end;
				return t.protected[index];
			end,
		__newindex = 	
			function(t, index, value)
				if value == nil then 
					rawset(t.public, index, nil);
					rawset(t.protected, index, nil);
				else 
					t.public[index] = value;
				end;
			end
	});
setmetatable(__share.public, 
	{
		__metatable = false,
		__newindex = 
			function(t, index, value)
				if (value ~= nil) and (__share.protected[index] ~= nil) then
					__share.protected[index] = nil;
				end;
				rawset(t, index, value);
			end
	});
setmetatable(__share.protected, 
	{
		__metatable = false,
		__newindex = 
			function(t, index, value)
				if (value ~= nil) and (__share.public[index] ~= nil) then
					__share.public[index] = nil;
				end;
				rawset(t, index, value);
			end
	});

	

--[[ Para exportar y compartir variables, hay que exportar explicitamente (indicandolo en el archivo meta.xml), las
funciones __set y __get ]]

function __set(index, value)
	assert(index and (__share.public[index] ~= nil) and (__share.protected[index] == nil));
	__share.public[index] = value;
end;

function __get(index)
	assert(index);
	return __share[index];
end;

--[[ Como accedemos a las variables globales de otros recursos ? ]]
setmetatable(_G,
	{
		__metatable = false,
		__index = 
			function(t, index) 
				local resource = getResourceFromName(index);
				if resource then 
					local resourceLookupTable = {};
					setmetatable(resourceLookupTable,
						{
							__metatable = false,
							__index = 
								function(t, index)
									-- obtener la variable.
									-- es una función exportada por el recurso ? 
									local exports = getResourceExportedFunctions(resource);
									if #exports > 0 then 
										local i, value = next(exports);
										while next(exports, i) and (value ~= index) do 
											i, value = next(exports, i);
										end;
										if value == index then 
											-- es una función exportada.
											return function(...) call(resource, index, ...); end;
										end;
									end;
									
									-- no es una función. comprobamos si bién es un valor.
									return call(resource, "__get", index);
								end,
							__newindex = 
								function(t, ...)
									-- indicamos el nuevo valor de la variable, en el recurso.
									call(resource, "__set", ...);
								end
						});
					rawset(t, index, resourceLookupTable);
					return resourceLookupTable;
				end;
			end
	});
	
