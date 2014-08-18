

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
	-- Devolver un iterador tonto si no hay elementos.
	if #t == 0 then 
		return function() end, nil, nil;
	end;
	
	local function tdpairs_it(trace, index_trace) 
		-- Obtener el anterior elemento de la tabla que se estaba
		-- analizando.
		local t = trace[#trace];
		local index = index_trace[#index_trace];
		local value = t[index];
		
		-- El anterior elemento era una tabla no vacía ? 
		if (type(value) == "table") and next(value, nil) then 
			-- Descender de nivel.
			trace[#trace+1] = value;
			local index, value = next(value, nil);
			index_trace[#index_trace+1] = index;
			return index_trace, value;
		end;
		
		-- Tabla acabada ? 
		if not next(t, index) then 
			if #trace > 1 then 
				-- Subir de nivel.
				
				local level = trace[#trace];
				trace[#trace] = nil;
				index_trace[#index_trace] = nil;
				while (#trace > 1) and (not next(trace[#trace], index_trace[#index_trace])) do
					level = trace[#trace];
					trace[#trace] = nil;
					index_trace[#index_trace] = nil;
				end;
				--return nil;
				local index, value = next(trace[#trace], index_trace[#index_trace]);
				if index then 
					index_trace[#index_trace] = index;
					return index_trace, value;
				end;
				return nil;
			end;
			return nil;
		end; 
		
		index, value = next(t, index);
		if index then
			if #index_trace == 0 then 
				index_trace[1] = index;
			else
				index_trace[#index_trace] = index;
			end;
			return index_trace, value;
		end; 
		return nil;
	end; 
	return tdpairs_it, {t}, {};
end;


--[[!
	Igual que tdpairs, solo que las tablas que poseen elementos se iteran pero no se muestran en el resultado.
	(Al iterar, solo aparecerán las hojas del árbol (Elementos que no son tablas o tablas vacías)). Las tablas no vacías
	no saldrán, pero si se iterará sobre los elementos contenidos por dichas tablas.
	@note tdlpairs = "tree deep leaf pairs"
]]
function tdlpairs(t)
	-- Devolver un iterador tonto si no hay elementos.
	if #t == 0 then 
		return function() end, nil, nil;
	end;
	
	local function tdlpairs_it(trace, index_trace) 
		-- Obtener el anterior elemento de la tabla que se estaba
		-- analizando.
		local t = trace[#trace];
		local index = index_trace[#index_trace];
		local value = t[index];
		
		-- Tabla acabada ? 
		if not next(t, index) then 
			if #trace > 1 then 
				-- Subir de nivel.
				
				local level = trace[#trace];
				trace[#trace] = nil;
				index_trace[#index_trace] = nil;
				while (#trace > 1) and (not next(trace[#trace], index_trace[#index_trace])) do
					level = trace[#trace];
					trace[#trace] = nil;
					index_trace[#index_trace] = nil;
				end;
				--return nil;
				local index, value = next(trace[#trace], index_trace[#index_trace]);
				if index then 
					index_trace[#index_trace] = index;
					return index_trace, value;
				end;
				return nil;
			end;
			return nil;
		end; 
		
		index, value = next(t, index);
		if index then
			if #index_trace == 0 then 
				index_trace[1] = index;
			else
				index_trace[#index_trace] = index;
			end;
			-- El anterior elemento era una tabla no vacía ? 
			if (type(value) == "table") and next(value, nil) then 
				-- Descender de nivel.
				trace[#trace+1] = value;
				local index, value = next(value, nil);
				index_trace[#index_trace+1] = index;
				return index_trace, value;
			end;
			return index_trace, value;
		end; 
		return nil;
	end; 
	return tdlpairs_it, {t}, {};
end;


--[[!
	Igual que table.find solo que devuelve el primer elemento "v" tal que predicate(v) == true.
]]
function table.match(t, predicate)
	local index, value = next(t, nil);
	while next(t, index) and (not predicate(value)) do 
		index, value = next(t, index);
	end;
	if (not predicate(value)) then 
		return nil;
	end;
	return index;
end;

--[[! Busca en una tabla uno o varios valores indicados como argumentos. 
Devuelve la primera coincidencia del valor en la tabla (La clave mediante la cual 
se obtiene el valor) o nil, si la busqueda no fue exitosa.
@note Se usa el iterador next para buscar el elemento. (El orden en el que se itera sobre
los elementos no está definido, y por consiguiente, si existieran varias coincidencias, no está 
definido cual sería la primera)
]]
function table.find(t, ...)
	local values = {...};
	if #values > 1 then 
		return table.match(t, function(value) return table.find(values, value); end);
	end;
	return table.match(t, function(value) return value == values[1]; end);
end;


--[[! Igual que table.match, solo que la busqueda es recursiva; Si se encuentra una tabla, se buscará también
en esta tabla los valores (si la tabla no es en sí una ocurrencia) 
Si se encuentra algún valor, es decir, si predicate(value) == true, la función devuelve la traza de índices que es necesaria
para acceder al elemento desde la raíz o nil si no ha habido coincidencias.
@note Se usa el iterador tdpairs, luego no se garantiza el orden en el que aparecen las ocurrencias de los valores
buscados en la tabla.
]]
function table.deep_match(t, predicate)
	local it, s, index_trace = tdpairs(t);
	local value;
	index_trace, value = it(s, index_trace);
	while index_trace and (not predicate(value)) do 
		index_trace, value = it(s, index_trace);
	end;
	if (not predicate(value)) then 
		return nil;
	end;
	return index_trace;
end;

--[[!
	table.recursive_match es un alias de table.deep_match
]]
table.recursive_match = table.deep_match;

--[[!
	Igual que table.find solo que la búsqueda es recursiva (para la búsqueda, se usa la funcion table.deep_match)
]]
function table.deep_find(t, ...)
	local values = {...};
	if #values > 1 then 
		return table.deep_match(t, function(value) return table.find(values, value); end);
	end;
	return table.deep_match(t, function(value) return value == values[1]; end);
end;

--[[!
	table.recursive_find es un alias de table.deep_find
]]
table.recursive_find = table.deep_find;



--[[!
	Igual que table.deep_match solo que no se consideran las ocurrencias de los valores que son tablas no vacías.
	Se busca dentro de las tablas no vacías pero estas no se consideran como solución para la búsqueda. 
	@note Se usa, en vez del iterador tdpairs, el iterador tdlpairs.
]]
function table.deep_tail_match(t, predicate)
	local it, s, index_trace = tdlpairs(t);
	local value;
	index_trace, value = it(s, index_trace);
	while index_trace and (not predicate(value)) do 
		index_trace, value = it(s, index_trace);
	end;
	if (not predicate(value)) then 
		return nil;
	end;
	return index_trace;
end;

function table.deep_tail_find(t, ...)
	local values = {...};
	if #values > 1 then 
		return table.deep_tail_match(t, function(value) return table.find(values, value); end);
	end;
	return table.deep_tail_match(t, function(value) return value == values[1]; end);
end;

--[[!
	table.recursive_tail_match es un alias de table.deep_tail_match
]]
table.recursive_tail_match = table.deep_tail_match;

--[[
	table.recursive_tail_find es un alias de tail.deep_tail_find
]]
table.recursive_tail_find = table.deep_tail_find;


table.toJSON = function(t) 
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

table.fromJSON = function(str) 
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
		se debe iterar antes sobre a que sobre b. El comparador por defecto es: function(a,b) return a<b; end;
]]
function opairs(t, keyComparator)
	localizedAssert((type(t) == "table") and ((type(keyComparator) == "function") or (not keyComparator)), "Bad arguments to opairs", 2);
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