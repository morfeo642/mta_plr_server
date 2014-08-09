
--[[!
	\file
	\brief Módulo que define una función que permite realizar la operación
	inversa a unpack: toma una serie de parámetros y los empaqueta en una tabla.
]]

--[[!
	Empaqueta varios valores en una tabla. 
	@param ... Los valores a empaquetar.
	@return Devuelve una tabla con los valores pasados como argumento tomados
	en orden en el que se especificaron.
]]
function pack(...)
	return {...};
end;

--[[!
	Igual que pack pero solo empaqueta los n primeros valores tomados como argumentos.
	@param n El número de elementos a empaquetar. Debe ser mayor o igual 1 y menor o 
	igual al número de argumentos (en ese caso sería igual que pack)
	@param ... Los argumentos a empaquetar.
	
	@return Devuelve como primer valor, una tabla con los n primeros valores empaquetados, y
	una lista con los valores restantes no empaquetados.
]]
function halfpack(n, ...)
	local args = pack(...);
	assert((type(n) == "number") and (n >= 1) and (n <= #args));
	if n < #args then 
		local packedArgs = {};
		local unpackedArgs = {};
		for i = 1,n,1 do packedArgs[i] = args[i]; end;
		for i = n+1,#args,1 do unpackedArgs[i-n] = args[i]; end;
		return packedArgs, unpack(unpackedArgs);
	end;
	return args;
end;


--[[! Es igual que pack solo que los argumentos se empaquetan en una tabla en orden
inverso al especificado ]]
function reversepack(...)
	local args = pack(...);
	local reversedArgs = {};
	for i = 1, #args, 1 do reversedArgs[#args-i+1] = args[i]; end;
	return reversedArgs;
end;

--[[! 
Esta función invierte el orden de los argumentos en una lista.
Es igual que unpack(reversepack(...))
@param ... Son los argumentos
@return Devuelve una lista de valores que serán los argumentos con el orden invertido
]]
function invertargs(...)
	return unpack(reversepack(...));
end;

 
--[[!
	Igual que pack pero solo empaqueta los últimos valores que anteceden a los
	n primeros argumentos tomados como argumentos.
	@param n El número de elementos a empaquetar. Debe ser mayor o igual 1 y menor o 
	igual al número de argumentos (en ese caso sería igual que pack)
	@param ... Los argumentos a empaquetar.
	
	@return Devuelve primero, una lista de valores sin empaquetar, y como último valor,
	una tabla con los argumentos empaquetados. 
]]
function reversehalfpack(n, ...)
	local args = {...};
	return invertargs(halfpack(#args-n, invertargs(...)));
end;

--[[!
	Empaqueta los argumentos en diferentes grupos(tablas) de tamaño n. 
	@param n Es el tamaño del grupo, mayor o igual que 1.
	@param ... Es una lista con los argumentos a empaquetar
	@return Devuelve una lista de tablas donde cada una de estas contiene n elementos.
	La primera tabla contiene el 1º argumento, el 2º, 3º, hasta el nº argumento. La segunda,
	el n+1º, n+2º, 2nº, ... 
	Si la lista de argumentos es vacía, se develve nil. Si la lista de argumentos tiene un 
	número de elementos que no es múltiplo de n, el último grupo devuelto no tendrá n elementos;
	Tendrá los elementos restantes que faltan por empaquetar (que no se han tomado en los otros grupos)
	Si el número de argumentos pasados como argumento es menor o igual que n, el valor de retorno es igual que
	pack(...)
]]
function makegroups(n, ...)
	assert(n > 0, "Bad argument to makegroups");
	local args = pack(...);
	
	local groups = {};
	for i=1,#args / n,1 do 
		groups[#groups+1] = {};
	end;
	if (#args % n) ~= 0 then 
		groups[#groups+1] = {};
	end;
	
	for i=1,#args,1 do 
		local j = math.floor((i-1)/n)+1;
		local group = groups[j];
		group[#group+1] = args[i];
	end;	
	
	return unpack(groups);
end;

--[[!
	Empaqueta los argumentos por pares de elementos.
	Es igual que makegroups con el argumento n igual a 2.
	@param ... Es una lista de argumentos a empaquetar por pares.
	@return Devuelve una lista de tablas con los argumentos empaquetados.
	@see makegroups
]]
function makepairs(...)
	return makegroups(2, ...);
end;
