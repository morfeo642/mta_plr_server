
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
