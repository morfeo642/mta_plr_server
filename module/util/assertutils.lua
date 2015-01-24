--[[!
	\file
	\brief Contiene un método para invocar asertos como alternativa a la función estandar de 
	LUA assert.
]]


--[[!
	Está función es igual que assert solo que admite un nuevo parámetro (level)
	@param condition La condición que debe cumplirse
	@param msg Es el mensaje de error en caso de que no se cumpla la condición
	@param level Especifica la posición del error en  la pila de llamadas.
	@return Devuelve el argumento especificado como condición de aserto
]]
function localizedAssert(condition, msg, level) 
	if not condition then
		if ((msg ~= nil) and (type(msg) ~= "string")) or ((level ~= nil) and ((type(level) ~= "number") or (level < 1))) then
			error("Bad arguments to localizedAssert", 2);
		end;
		if msg == nil then 
			msg = "Assertion failed";
		end;
		if level == nil then 
			level = 1;
		end;
		error(msg, level+1);
	end;	
	return condition;
end;
