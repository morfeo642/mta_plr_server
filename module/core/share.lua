
--[[!
	\file 
	\brief Este script permite establecer un protocolo entre diferentes recursos 
	para compartir variables.
]]	


--[[! En esta tabla se añaden funciones y variables que se quieren compartir (lectura y escritura), pero no pueden
crearse nuevas variables ]]
__share = {};

--[[ Para exportar y compartir variables, hay que exportar explicitamente (indicandolo en el archivo meta.xml), las
funciones __set y __get ]]

function __set(index, value)
	assert(index and (__share[index] ~= nil));
	__share[index] = value;
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
											return function(...) return call(resource, index, ...); end;
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
	
