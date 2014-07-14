

-- require 'tableutils';
getModule("utils/tableutils");

--[[!
	\file
	\brief Este script define funciones auxiliares e iteradores útiles para
	trabajar con cadenas e caracteres.
]]


--! Iterador de palabras separadas por uno o varios separadores (por defecto, espacios)
--! Los separadores pueden especificarse como una lista de carácteres (como argumentos separados),
--! o pueden ser indicados todos dentro de una sola cadena. ejemplo:
--! El iterador irá devolviendo las palabras de las que se compone la cadena de caracteres.
--[[!
	\code{lua}
	for word in wpairs("hello world", ' ') do 
		print(word);
	end;
	-- output: 
	-- hello
	-- world
	\endcode

]]
--! Otro ejemplo.
--[[! 
	\code{lua}
	for word in wpairs("hi - worl - d", '- ') do 
		print(word);
	end; 
	--output: 
	-- hi
	-- worl
	-- d
	\endcode
]]

function wpairs(text, delimiters, ...) 
	if not delimiters then 
		delimiters = ' ';
	else 
		delimiters = delimiters .. table.concat({...});
	end;

	return string.gmatch(text, "[^" .. delimiters .. "]+");		
end;

--[[!
	Igual que wpairs, solo que se itera de derecha a izquierda.
]]
function rwpairs(text, delimiters, ...)
	-- separar las palabras y meterlas en una tabla auxiliar.
	local words = {};
	local i = 0;
	for word in wpairs(text, delimiters, ...) do 
		i = i + 1;
		words[i] = word;
	end; 
	-- si no hay ninguna palabra, devolvemos un iterador tonto.
	if #words == 0 then 
		return function() end, nil, nil;
	end;
	
	-- damos la vuelta a la tabla.
	local reversed_words = {};
	i = 0;
	for _, word in ripairs(words) do 
		i = i + 1; 
		reversed_words[i] = word;
	end;
	
	-- devolvemos el iterador.
	return string.gmatch(table.concat(reversed_words, ' '), "[^ ]+");
end;
