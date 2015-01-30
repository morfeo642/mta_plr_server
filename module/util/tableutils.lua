

--[[!
	\file
	\brief Este script define utilidades para trabajar con tablas.
]]

loadModule("util/checkutils");

--[[!
	Es un iterador para iterar sobre los elementos de una tabla de derecha a
	izquierda. Es igual que ipairs solo que iteramos comenzando desde el final
	y vamos en dirección opuesta.
]]
function ripairs(t) 
	checkArgumentType("ripairs", 2, t, 1, "table");
	if #t == 0 then
		return function() end, nil, nil;
	end;
	
	local function ripairs_it(t, index)
		index = index - 1;
		if (index > 0) then 
			return index, t[index];
		end;
	end;
	return ripairs_it, t, #t + 1;
end;




--[[!
	Iterador para iterar en una tabla recursivamente. Si un elemento es una tabla,
	si itera también sobre los elementos de dicha tabla. En cada iteración se devolverá
	un par de valores: Una tabla con las claves que hemos necesitado para llegar hasta dicho elemento, y el valor del elemento.
	Es igual que si iterasemos sobre los elementos de un árbol (en profundidad). Por cada nodo (tabla),
	se analizan primero los hijos (elementos de la tabla), antes de analizar el siguiente elemento que antecede 
	a esta tabla.
	@note Como pairs, el orden en que se analizan los elementos en el mismo nivel, no está definido.
	@note tdpairs = "tree deep pairs"
]] 

function tdpairs(t)
	checkArgumentType("tdpairs", 2, t, 1, "table");
	
	local function tdpairs_it(trace, _index_trace)
		--[[ Copiamos la traza, debido a que después esta va a ser modificada y
		retornada como el siguiente indice; Simulamos que la traza es un valor,
		cuando en verdad, es una tabla. Esto es debido a que las tablas se pasan
		como referencia y no como valor ]]
		index_trace = table.shallow_copy(_index_trace);
	
		--[[ Obtenemos el índice del anterior elemento iterado, y el nivel 
		actual. ]]
		local level = trace[#trace];
		local prev_index;
		
		if #index_trace == #trace then 
			prev_index = index_trace[#index_trace];
			
			--[[ Si el anterior elemento era una tabla, descender un
			nivel]]
			if type(level[prev_index]) == "table" then
				trace[#trace+1] = level[prev_index];
				return tdpairs_it(trace, index_trace);
			end;
		else
			prev_index = nil;
		end;
		
		if next(level, prev_index) ~= nil then 
			local index, value = next(level, prev_index);
			if #index_trace < #trace then 
				index_trace[#index_trace+1] = index;
			else
				index_trace[#index_trace] = index;
			end;
			
			return index_trace, value;
			
		else
			--[[Si no hay ningún elemento más en el nivel actual, subimos
			un nivel, y terminamos la iteración en el caso de que el nivel actual
			sea el primer nivel]]
			
			if #trace > 1 then 		
				if #index_trace == #trace then 
					index_trace[#index_trace] = nil;
				end;
				trace[#trace] = nil;
				
				while (#trace > 1) and (next(trace[#trace], index_trace[#index_trace]) == nil) do 
					trace[#trace] = nil;
					index_trace[#index_trace] = nil;
				end;
				local index, value = next(trace[#trace], index_trace[#index_trace]);
				if index ~= nil then 
					index_trace[#index_trace] = index;
					return index_trace, value;
				end;
			end;
		end;
	end;
	return tdpairs_it, {t}, {};
end;

--[[!
	Igual que tdpairs, solo que las tablas que poseen elementos se iteran pero no se muestran en el resultado.
	(Al iterar, solo aparecerán las hojas del árbol (Elementos que no son tablas o tablas vacíass)). Las tablas no vacías
	no saldrán, pero si se iterará sobre los elementos contenidos por dichas tablas.
	@note tdlpairs = "tree deep leaf pairs"
]]
function tdlpairs(t)
	checkArgumentType("tdlpairs", 2, t, 1, "table");

	local function tdlpairs_it(trace, _index_trace)
		index_trace = table.shallow_copy(_index_trace);
	
		--[[ Obtenemos el índice del anterior elemento iterado, y el nivel 
		actual. ]]
		local level = trace[#trace];
		local prev_index;
		
		if #index_trace == #trace then 
			prev_index = index_trace[#index_trace];
			
			--[[ Si el anterior elemento era una tabla, descender un
			nivel]]
			if type(level[prev_index]) == "table" then
				trace[#trace+1] = level[prev_index];
				return tdlpairs_it(trace, index_trace);
			end;
		else
			prev_index = nil;
		end;
		
		if next(level, prev_index) ~= nil then 
			local index, value = next(level, prev_index);
			if #index_trace < #trace then 
				index_trace[#index_trace+1] = index;
			else
				index_trace[#index_trace] = index;
			end;
			
			--[[
			Si el elemento nuevo es una tabla, está no saldrá en el resultado,
			e iremos al "siguiente resultado"
			]]
			if (type(value) == "table") and (next(value,nil) ~= nil) then 
				return tdlpairs_it(trace, index_trace);
			end;
			
			return index_trace, value;
			
		else
			--[[Si no hay ningún elemento más en el nivel actual, subimos
			un nivel, y terminamos la iteración en el caso de que el nivel actual
			sea el primer nivel]]
			
			if #trace > 1 then 		
				if #index_trace == #trace then 
					index_trace[#index_trace] = nil;
				end;
				trace[#trace] = nil;
				
				while (#trace > 1) and (next(trace[#trace], index_trace[#index_trace]) == nil) do 
					trace[#trace] = nil;
					index_trace[#index_trace] = nil;
				end;
				local index, value = next(trace[#trace], index_trace[#index_trace]);
				if index ~= nil then 
					index_trace[#index_trace] = index;
					--[[ Vamos al siguiente resultado, "saltandonos" la tabla ]]
					if type(value) == "table" then 
						return tdlpairs_it(trace, index_trace);
					end;
					return index_trace, value;
				end;
			end;
		end;
	end;
	return tdlpairs_it, {t}, {};
end;


--[[!
	Esta función comprueba si hay algún elemento que pueda ser extraído iterando sobre la tabla
	indicada mediante el iterador devuelto por la función f, que satisfaga el predicado, es decir,
	un elemento v, tal que predicate(v) se evalue a true.
	@param t Es la tabla donde se desea realizar la busqueda.
	@param predicate Es el predicado que debe satisfacer algún elemento de la secuencia para que
	pueda ser solución de la busqueda.
	@param f Es la función que devuelve el iterador que permite acceder a la secuencia de elementos.
	
	@return Devuelve un índice, el cual puede usarse para acceder a uno de los elementos encontrados,
	que satisface el predicado
]]
function table.match_with(t, predicate, f)
	checkArgumentsTypes("table.match_with", 2, 1, t, "table", predicate, "function", f, "function");
	
	local it, s, var = f(t);
	
	local index, value = it(s, var);
	if index ~= nil then 
		local next_index, next_value = it(s, index);
		while (next_index ~= nil) and (not predicate(value)) do 
			index = next_index;
			value = next_value;
			next_index, next_value = it(s, index);
		end;
		if predicate(value) then 
			return index;
		end;
	end;
end;

--[[!
	Es table.match_with, pero el predicate será una función tal que devuelva cierto, en
	caso de que el valor sea alguno de los elementos en la lista de parámetros (...)
]]
function table.find_with(t, f, ...) 
	checkArgumentsTypes("table.find_with", 2, 1, t, "table", predicate, "function");
	
	local values = {...};
	if #values > 1 then 
		return table.match_with(t, function(value) return table.find(values, value) ~= nil; end, f);
	end;
	return table.match_with(t, function(value) return value == values[1]; end, f);
end;


--[[!
	Es table.match_with, con f = pairs
]]
function table.match(t, predicate)
	checkArgumentsTypes("table.match", 2, 1, t, "table", predicate, "function");
	
	return table.match_with(t, predicate, pairs);
end;

--[[! Es table.find_with con f = pairs
]]
function table.find(t, ...)
	checkArgumentType("table.find", 2, t, 1, "table");
	
	return table.find_with(t, pairs, ...);
end;


--[[! 
	Es table.match_with con f = tdpairs 
]]
function table.deep_match(t, predicate)
	checkArgumentsTypes("table.deep_match", 2, 1, t, "table", predicate, "function");

	return table.match_with(t, predicate, tdpairs);
end;

--[[!
	table.recursive_match es un alias de table.deep_match
]]
table.recursive_match = table.deep_match;

--[[!
	Es table.find_with con f = tdpairs
]]
function table.deep_find(t, ...)
	checkArgumentType("table.deep_find", 2, t, 1, "table");
	
	return table.find_with(t, tdpairs, ...);
end;

--[[!
	table.recursive_find es un alias de table.deep_find
]]
table.recursive_find = table.deep_find;



--[[!
	Es table.match_with con f = tdlpairs
]]
function table.deep_tail_match(t, predicate)
	checkArgumentsTypes("table.deep_tail_match", 2, 1, t, "table", predicate, "function");

	return table.match_with(t, predicate, tdlpairs);
end;

--[[!
	Es table.find_with con f = tdlpairs
]]
function table.deep_tail_find(t, ...)
	checkArgumentType("table.deep_tail_find", 2, t, 1, "table");

	return table.find_with(t, tdlpairs, ...);
end;

--[[!
	table.recursive_tail_match es un alias de table.deep_tail_match
]]
table.recursive_tail_match = table.deep_tail_match;

--[[
	table.recursive_tail_find es un alias de tail.deep_tail_find
]]
table.recursive_tail_find = table.deep_tail_find;



table.toJSONX = function(t) 
	local function _toJSON(t, level) 
		local function parsePair(index, value, level)
			local indexType = type(index);
			local valueType = type(value);
			localizedAssert((indexType == "number") or (indexType == "string") or (indexType == "boolean"), "Bad table passed to table.toJSON, indexes must be numbers, booleans or strings", level+1);
			localizedAssert((valueType == "number") or (valueType == "string") or (valueType == "boolean") or (valueType == "table"),
				"Bad table passed to table.toJSON, values must be numbers, booleans, strings or tables", level+1);
			if valueType == "table" then 
				value = _toJSON(value, level+1);
			else
				value = valueType:sub(1,1) .. tostring(value);
			end;
			index = indexType:sub(1,1) .. tostring(index);
			return "\"" .. index .. "\"=\"" .. value .. "\"";  
		end;
	
		localizedAssert(type(t) == "table",  "Bad argument to table.toJSON", level+1);
		local json = "{";

		if next(t) then 
			local index, value = next(t);
			while next(t, index) do 
				json = json .. parsePair(index, value, level+1) .. " ";
				index, value = next(t, index);
			end;
			json = json .. parsePair(index, value, level+1);
		end; 
		
		return json .. "}";
	end;
	
	return _toJSON(t, 2);
end;

table.fromJSONX = function(str) 
	local function _fromJSON(str)
		local function stringToValue(value)
			local valueType, value = value:match("(%a)(.+)");
			if valueType == "n" then 
				return tonumber(value);
			elseif valueType == "b" then 
				return (value == "true");
			elseif valueType ~= "s" then 
				return false;
			end;
			return value;
		end;
	
		local t = {};	
		-- analizar subtablas...
		
		for token in str:gmatch("\"[^\"]+\"=\"{[^}]*}\"") do 
			local index, value = token:match("\"(.+)\"=\"{([^}]*)}\"");	
			index = stringToValue(index);
			value = _fromJSON(value);
			if (index == nil) or (not value) then return false; end;
			t[index] = value;
		end;		
		str = str:gsub("\"[^\"]+\"=\"{[^}]*}\"", "");
		
		for token in string.gmatch(str, "\"[^\"]+\"=\"[^\"]+\"") do 
			local index, value = token:match("\"(.+)\"=\"(.+)\"");
			index, value = stringToValue(index), stringToValue(value);
			if (index == nil) or (value == nil) then return false; end;
			t[index] = value;
		end;
		
		return t;
	end;
	localizedAssert(type(str) == "string", "Bad argument passed to table.fromJSON", 2);
	if not str:match("{.*}") then 
		return false;
	end;
	return _fromJSON(str:match("{(.*)}"));
end;

--[[!
	@return Devuelve una copia superficial de la tabla pasada como argumento.
	@note No se copian las subtablas, solo las referencias a estas.
]]
function table.shallow_copy(t) 
	checkArgumentType("table.shallow_copy", 2, t, 1, "table");

	local copy = {};
	for index, value in pairs(t) do 
		copy[index] = value;
	end;
	return copy;
end;

--[[!
	@return Devuelve una copia profunda de la tabla pasada como argumento.
	@note No se copian referencias de las subtablas, si no que se copian estas.
]]
function table.deep_copy(t) 
	checkArgumentType("table.deep_copy", 2, t, 1, "table");

	local function deep_copy(dst, src) 
		for index, value in pairs(src) do 
			if type(value) ~= "table" then 
				dst[index] = value;
			else
				dst[index] = deep_copy({}, value); 
			end;
		end;
		return dst;
	end;
	return deep_copy({}, t); 
end;

--[[!
	Es un iterador que itera a través de una tabla pero que a diferencia del iterador pairs/next, se 
	sigue un orden especifico para iterar sobre esta.
	@param t Es la tabla.
	@param keyComparator Es el comparador. Permite indicar el orden para iterar sobre la tabla. Es una 
		función que acepta dos parámetros (dos indices a, b) y devuelve un valor booleano indicando si
		se debe iterar antes sobre a que sobre b. El comparador por defecto es: 
		\code
		function(a,b) 
			if(type(a)~=type(b)) then
				return type(a) < type(b);
			end;
			return a<b;
		end;
		\endcode
	@note Notese que los indices pueden tener un tipo distinto y no siempre podrán comparase mediante
	los operadores aritméticos
]]
function opairs(t, keyComparator)
	local function defaultKeyComparator(a,b)
		if (type(a)~=type(b)) then 
			return type(a)<type(b);
		end;
		return a<b;
	end

	checkArgumentType("opairs", 2, t, 1, "table");
	checkOptionalArgumentType("opairs", 2, keyComparator, 2, "function");
	keyComparator = parseOptionalArguments(keyComparator, defaultKeyComparator);
	
	local aux = {};
	for index, _ in pairs(t) do 
		aux[#aux+1] = index;
	end;
	table.sort(aux, keyComparator);
	local j = 0; 
	local function opairs_it() 
		j = j + 1;
		if aux[j] ~= nil then 
			return aux[j], t[aux[j]];
		end;
	end;
	return opairs_it;
end;