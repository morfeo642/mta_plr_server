
--[[!
	\file
	\brief Este es un módulo que da soporta a la orientación a objetos en lua.
	(polimorfismo y herencia).
	
	Ejemplos.
	\code
	-- Crear una clase foo y una instancia de esta.
	foo = class();
	local newInstance = foo();
	\endcode
	
	\code
	-- Lo mismo que el anterior ejemplo pero indicando un inicializador de clase...
	foo = class();
	function foo:init(...) print("inicializando instancia de foo con los valores " .. table.concat(...,' '); end;
	local newInstance = foo(1, 2, 3, 4);
	\endcode
	
	\code
	-- Ahora creamos una clase bar que herede de foo.
	-- Si no creamos un inicializador para esta clase, habrá uno por defecto que inicializará la 
	superclase (llamará a foo.init)
	bar = class(foo);
	bar(); -- output: inicializando instancia de foo...
	\endcode
	
	\code                                                                                 
	-- Si especificamos un inicializador de clase, tenemos que preocuparnos de inicializar la
	-- superclase.
	bar = class(foo);
	function bar:init()
		self:super(1, 2, 3, 4); -- output: inicializando instancia de foo con los valores 1  2 3 4 
		print("inicializando instancia de bar");
	end;
	\endcode
	-- Para comprobar si una variable es una clase, se puede usar la función isvalidclass
	\code
	bar = class();
	print(isvalidclass(bar));
	\endcode
	
	-- Podemos comprobar si un objeto es una instanciación de una clase.
	\code 
	bar = class();
	instance = bar();
	print(instance:isinstanceof(bar));
	\endcode
]]

loadModule("util/assertutils");

function class(BaseClass)
	localizedAssert((BaseClass == nil) or isvalidclass(BaseClass), "Invalid base class", 2);
	local newClass = {};
	local newClassMetatable = {};
	
	newClass.__index = newClass;
	
	-- Esto es para proteger a las instancias de la nueva clase, que no se les pueda
	-- asignar nuevas metatablas
	newClass.__metatable = newClass;
	
	if BaseClass then  
		newClassMetatable.__index = BaseClass;
		newClass.__base = BaseClass;
	end;
	
	-- Proteger a la nueva clase para que no se pueda establecer una nueva 
	-- metatabla y al mismo tiempo, que getmetatable(newClass) == newClassMetatable
	newClassMetatable.__metatable = newClassMetatable;
	
	-- "Constructor" de clase.
	newClassMetatable.__call =
		function(t, ...) 
			local newInstance = {};
			setmetatable(newInstance, t);
			-- Inicializar la nueva instancia.
			newInstance:init(...);
			
			return newInstance;
		end;
		
	-- Inicializador de una instancia de la clase por defecto.
	if not newClass.__base then 
		newClass.init = 
			function(this, ...)
				
			end;
	else 
		newClass.init = 
			function(this, ...)
				--Inicializar la superclase (si hereda de alguna)
				newClass.super();
			end;
	end;
	
	-- Inicializador de superclase.
	newClass.super = 
		function(this, ...)
			local baseClass = localizedAssert(newClass.__base, "There is no superclass", 2);
			baseClass.init(this, ...);
		end;
	-- Clonador de instancias por defecto.
	newClass.clone = 
		function(this, ...)
			local other = {};
			-- hacer una copia de los valores de la instancia a la tabla
			for index, value in pairs(this) do other[index] = value; end;
			setmetatable(other, newClass);
			-- no hace falta invocar al constructor.
			return other;
		end;
	-- Comprobar si un objeto es una instancia de una clase heredada por esta.
	newClass.isinstanceof =
		function(this, otherClass)
			localizedAssert(type(otherClass) == "table", "Invalid class", 2);
			local theClass = newClass;
			while (theClass ~= otherClass) and theClass.__base do 
				theClass = theClass.__base;
			end;
			return theClass == otherClass;
		end;
		
	setmetatable(newClass, newClassMetatable);
	return newClass;
end;


--[[!
@return Devuelve un valor booleano indicando si la variable pasada como parámetro es 
una clase válida (instanciable, inicializable y clonable)
]]
function isvalidclass(class)
	return (type(class)=="table") and getmetatable(class) and 
		(type(getmetatable(class).__call)=="function") and (type(class.init)=="function") and
		(type(class.super)=="function") and (type(class.clone)=="function") and
		(type(class.isinstanceof)=="function");
end;

--[[!
@return Devuelve un valor booleano indicando si la variable pasada como parámetro es 
un objeto válido; Es una instancia de una clase válida.
]]
function isvalidobject(object)
	return getmetatable(object) and isvalidclass(getmetatable(object));
end;

--[[!
@return Devuelve un valor booleano indicando si este objeto es un objeto válido y es una 
instancia de la clase indicada o de un clase que hereda de esta.
]]
function isinstanceof(object, class)
	return isvalidobject(object) and object:isinstanceof(class);
end;


--[[!
Comprueba si un valor hace referencia a una clase. 
@param funcname Es el nombre de la función.
@param level Especifíca la posición del error en la pila de llamadas
@param value Es la variable que se quiere verificar si es una clase valida.
@param argnum Es el cardinal del argumento
]]
function checkIsClass(funcname, level, value, argnum)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0),
		"Bad arguments to \"checkIsClass\"", level);
	if not isvalidclass(value) then 
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; class expected, but got " .. tostring(value), level+1);
	end;
end;

--[[!
Comprueba si un valor hace referencia a una instancia de una clase.
@param funcname Es el nombre de la función.
@param level Especifíca la posición del error en la pila de llamadas
@param value Es la variable que se quiere verificar si es un objeto válido.
@param argnum Es el cardinal del argumento
]]
function checkIsObject(funcname, level, value, argnum)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0),
		"Bad arguments to \"checkIsObject\"", level);
	if not isvalidobject(value) then 
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; object expected, but got " .. tostring(value), level+1);
	end;
end;

--[[!
Comprueba si un valor hace referencia a una instancia de la clase indicada, o es una 
instancia de una clase que hereda de esta.
@param funcname Es el nombre de la función.
@param level Especifíca la posición del error en la pila de llamadas
@param value Es la variable que se quiere verificar si es un objeto válido y es una instancia de la
clase.
@param argnum Es el cardinal del argumento
@param class Es la clase.
@param classname Es el nombre de la clase (para añadir información adicional en caso de error)
]]
function checkIsInstanceOf(funcname, level, value, argnum, class, classname)
	localizedAssert((type(funcname) == "string") and (type(level) == "number") and (type(argnum) == "number") and (argnum > 0) and isvalidclass(class) and (type(classname)  == "string"),
		"Bad arguments to \"checkIsInstanceOf\"", level);
	if not isinstanceof(value, class) then 
		error("Argument mismatch in function \"" .. funcname .. "\" at argument " .. argnum .. "; an instance of " .. classname .. " class expected, but got " .. tostring(value), level+1);
	end;
end;
