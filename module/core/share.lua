
--[[!
	\file 
	\brief Este script permite establecer un protocolo entre diferentes recursos 
	para compartir variables y exportar funciones.  
]]	


--[[! En esta tabla se pueden añadir funciones y variables que queremos exportar (solo lectura) ]]
__export = {};
setmetatable(__export, 
	{
		__metatable = false	
	});


--[[! En esta tabla se añaden funciones y variables que se quieren compartir (lectura y escritura), pero no pueden
crearse nuevas variables ]]
__share = {};
setmetatable(__share,
	{
		__metatable = false	
	});
	

--[[ Para exportar y compartir variables, hay que exportar explicitamente (indicandolo en el archivo meta.xml), las
funciones __set, __get, __call ]]

function __set(index, value)
	assert(index and (__share[index] ~= nil));
	__share[index] = value;
end;

function __get(index)
	assert(index);
	local value = __export[index];
	if value == nil then 
		value = __share[index]; 
	end;
	return type(value), value;
end;

function __call(funcName, theResource, ...)
	local _, func = __get(funcName);
	return func(theResource, ...);
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
									local valueType, value = call(resource, "__get", index);
									if valueType == "function" then 
										-- es una función, y devolvemos una función que 
										-- invoque a la función del recurso.
										return function(...) return call(resource, "__call", index, getThisResource(), ...); end; 
									end;
									return value;
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
	
