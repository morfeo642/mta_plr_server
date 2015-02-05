
--[[!
	\file
	\brief Este módulo proporciona utilidades para comprobar los valores
	que se pasan como argumentos a un método específico. (Para garantizar
	las precondiciones de dicho método)
]]

importModule("util/tableutils");
importModule("util/assertutils");


--[[!
	Comprueba si un argumento tiene alguno de los valores especificados.
	En el caso de que esto no ocurra, se lanza un aserto
	@param funcname Es la función de la que se comprueba alguno de sus argumentos
	@param level Especifica la posición del error en la pila de llamadas.
	@param value Es el valor del argumento
	@param argnum Es el cardinal del argumento (si es el primer argumento que debería ser pasado a la función, tendría valor 1.
	@param ... Una lista con todos los posibles valores que están permitidos
]]
function checkArgumentValue(funcname, level, value, argnum, ...) 
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0), "Bad arguments to \"checkArgumentValue\"", level);
	local args = {...};
	if #args == 1 then 
		if args[1] == value then 
			return; 
		end;
	elseif table.find(args, value) then 
			return;
	end;

	for i=1,#args,1 do args[i] = tostring(args[i]); end;
	error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; value " .. table.concat(args, " or ") .. " expected, but got " .. tostring(value), level+1);
end;

--[[!
	Comprueba si un argumento es de algún tipo especifico.
	En el caso de que esto no ocurra, se lanza un aserto.
	@param funcname Es el nombre del método.
	@param level Especifica la posición del error en la pila de llamadas.
	@param value Es el valor del argumento.
	@param argnum Es el cardinal del argumento en la lista de parámetros del método.
	@param ... Una lista con todos los posibles tipos permitidos para el argumento.
	@note Si value es un elemento, es decir, si isElement(value) es cierto, no se lanzará un aserto si alguno de los valores
	de la lista de tipos es el tipo de elemento, es decir, getElementType(value)
]]
function checkArgumentType(funcname, level, value, argnum, ...)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0), "Bar arguments to \"checkArgumentType\"", level);
	local valueType;
	if isElement(value) then 
		valueType = getElementType(value);
	else
		valueType = type(value);
	end;

	local args = {...};
	if #args == 1 then 
		if args[1] == valueType then 
			return; 
		end;
	elseif table.find(args, valueType) then 
		return;
	end;

	for i,j in pairs(args) do args[i] = tostring(j); end;
	error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; type " .. table.concat(args, " or ") .. " expected, but got " .. valueType , level+1);

end;

--[[!
	Comprueba que una lista de argumentos tengan los tipos adecuados.
	@param funcname Es el nombre del método.
	@param level Sirve para localizar el error.
	@param firstarg Es el cardinal del primer parámetro a comprobar del método.
	@param ... Es una lista de pares de elementos: Cada par consta de:  el propio argumento y 
	un string que indica el tipo permitido para el argumento, o una tabla de tipos permitidos
]]
function checkArgumentsTypes(funcname, level, firstarg, ...)
	local args = {...};
	localizedAssert((type(level) == "number") and ((#args % 2) == 0) and (type(firstarg) == "number") and (firstarg > 0), "Bad arguments to \"checkArgumentsType\"", level);
	for i=1,#args,2 do 
		assert((type(args[i+1]) == "string") or (type(args[i+1]) == "table"));
		if type(args[i+1]) == "string" then 
			checkArgumentType(funcname, level+1, args[i], firstarg + math.floor(i/2), args[i+1]);
		else 
			checkArgumentType(funcname, level+1, args[i], firstarg + math.floor(i/2), unpack(args[i+1]));		
		end;
	end;
end;


--[[!
	Comprueba que una lista de argumentos tengan los valores adecuados.
	@param funcname Es el nombre del método.
	@param level Sirve para localizar el error (Es la posición del error)
	@param firstarg Es el cardinal del primer parámetro a comprobar del método
	@param ... Es una lista de pares de elementos: Cada par consta de: El argumento y una tabla con todos los
	posibles valores que puede tomar.
]]
function checkArgumentsValues(funcname, level, firstarg, ...)
	local args = {...};
	localizedAssert((type(level) == "number") and ((#args % 2) == 0) and (type(firstarg) == "number") and (firstarg > 0), "Bad arguments to \"checkArgumentsValues\"", level);
	for i=1,#args,2 do 
		assert(type(args[i+1]) == "table");
		checkArgumentValue(funcname, level+1, args[i], firstarg + math.floor(i/2), unpack(args[i+1]));
	end;
end;


--[[!
	Igual que checkArgumentType solo que el valor nil está permitido en el argumento puesto
	que es opcional
]]
function checkOptionalArgumentType(funcname, level, value, argnum, ...)
	localizedAssert(type(level) == "number", "Bad arguments to \"checkOptionalArgumentType\"", level);
	if value ~= nil then 
		checkArgumentType(funcname, level+1, value, argnum, ...);
	end;
end;

--[[!
	Igual que checkArgumentValue solo que el valor nil está permitido
]]
function checkOptionalArgumentValue(funcname, level, value, argnum, ...)
	localizedAssert(type(level) == "number", "Bad arguments to \"checkOptionalArgumentValue\"", level);
	if value ~= nil then 
		checkArgumentValue(funcname, level+1, value, argnum, ...);
	end;
end;
	
--[[!
	Igual que checkArgumentsTypes solo que el valor nil está permitido en los argumentos ya que
	son opcionales.
]]
function checkOptionalArgumentsTypes(funcname, level, firstarg, ...)
	local args = {...};
	localizedAssert((type(level) == "number") and ((#args % 2) == 0) and (type(firstarg) == "number") and (firstarg > 0), "Bad arguments to \"checkOptionalArgumentsTypes\"", level);
	for i=1,#args,2 do 
		assert((type(args[i+1]) == "string") or (type(args[i+1]) == "table"));
		if type(args[i+1]) == "string" then 
			checkOptionalArgumentType(funcname, level+1, args[i], firstarg + math.floor(i/2), args[i+1]);
		else 
			checkOptionalArgumentType(funcname, level+1, args[i], firstarg + math.floor(i/2), unpack(args[i+1]));		
		end;
	end;
end;

--[[!
	Igual que checkArgumentsValues solo que el valor nil está permitido en los argumentos.
]]
function checkOptionalArgumentsValues(funcname, level, firstarg, ...)
	local args = {...};
	localizedAssert((type(level) == "number") and ((#args % 2) == 0) and (type(firstarg) == "number") and (firstarg > 0), "Bad arguments to \"checkOptionalArgumentsValues\"", level);
	for i=1,#args,2 do 
		assert(type(args[i+1]) == "table");
		checkOptionalArgumentValue(funcname, level+1, args[i], firstarg + math.floor(i/2), unpack(args[i+1]));
	end;
end;

--[[!
	Está función recibe una serie de argumentos agrupados en pares(un argumento y su valor por defecto) y 
	devuelve una lista con todos los argumentos pasados, pero reemplazando aquellos que tienen valor nil, 
	por su valor por defecto.
	@param ... Una lista de valores tomados por pares(argumentos y valores por defecto)
	@param Devuelve una lista de valores que resultan de reemplazar los argumentos que tienen valor nil por 
	sus valores por defecto.
	\code
	print(parseOptionalArguments(4, 20, nil, 50));
	-- output: 4, 50
	\endcode
]]
function parseOptionalArguments(...)
	local args = {...};
	local aux = {};
	localizedAssert((#args % 2) == 0, "Bad arguments to \"parseOptionalArguments\"", level);
	for i=1,#args,2 do 
		local j = math.floor(i/2)+1;
		if args[i] ~= nil then 
			aux[j] = args[i]; 
		else 
			aux[j] = args[i+1];
		end;
	end;
	return unpack(aux);
end;

--[[!
	Comprueba si un número está en el rango especificado.
	@param funcname Es el nombre del método del que queremos comprobar el rango de alguno de sus argumentos.
	@param level Especifica la posición del error en la pila de llamadas.
	@param value Es el número que se quiere comprobar
	@param argnum Es el cardinal del argumento.
	@param lowerBound Es el límite inferior que debe ser menor o igual que upperBound
	@param upperBound Es el límite superior.
]]
function checkArgumentRange(funcname, level, value, argnum, lowerBound, upperBound)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0) and (type(value) == "number") and (type(lowerBound) == "number") and (type(upperBound) == "number"),
			"Bad arguments to \"checkArgumentRange\"", level);
	if (value < lowerBound) or (value > upperBound) then 
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; an argument in the range [" .. lowerBound .. " , " .. upperBound .. "] expected, but got " .. tostring(value), level+1);
	end;
end;

--[[!
	Comprueba si una string encaja en una expresión regular.
	@param funcname Es el nombre de la función.
	@param level Especifíca la posición del error en la pila de llamadas
	@param value Es la cadena de caracteres
	@param argnum Es el cardinal del argumento
	@param expr Es la expresión regular.
]]
function checkArgumentRegularExpression(funcname, level, value, argnum, expr)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(value) == "string") and (type(argnum) == "number") and (argnum > 0) and (type(expr) == "string"),
		"Bad arguments to \"checkArgumentRegularExpression\"", level);
	if not  value:match(expr) then
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; string \"" .. value .. "\" doesn't match with \"" .. expr .. "\" regular expression", level+1);
	end;
end;


--[[!
	Comprueba si un valor hace referencia a una entidad (elemento), vehiculo, jugador, ...
	@param funcname Es el nombre de la función.
	@param level Especifíca la posición del error en la pila de llamadas
	@param value Es la cadena de caracteres
	@param argnum Es el cardinal del argumento
	@param expr Es la expresión regular.
]]
function checkIsElement(funcname, level, value, argnum)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0),
		"Bad arguments to \"checkIsElement\"", level);
	if not isElement(value) then
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; element expected, but got " .. tostring(value), level+1);
	end;
end;