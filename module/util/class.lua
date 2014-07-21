
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
	-- Por último, si especificamos un inicializador de clase, tenemos que preocuparnos de inicializar la
	-- superclase.
	bar = class(foo);
	function bar:init()
		self:super(1, 2, 3, 4); -- output: inicializando instancia de foo con los valores 1  2 3 4 
		print("inicializando instancia de bar");
	end;
	\endcode
]]

function class(BaseClass)
	assert((type(BaseClass) == "table") or (BaseClass == nil));
	local newClass = {};
	local newClassMetatable = {};
	
	newClass.__index = newClass;
	
	if BaseClass then  
		newClassMetatable.__index = BaseClass;
		newClass.__base = BaseClass;
	end;
	
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
	newClass.init = 
		function(this, ...)
			--Inicializar la superclase (si hereda de alguna)
			pcall(newClass.super);	
		end;
	
	-- Inicializador de superclase.
	newClass.super = 
		function(this, ...)
			local baseClass = assert(newClass.__base);
			baseClass.init(this, ...);
		end;
	
	-- Comprobar si un objeto hereda de una clase.
	newClass.isinstanceof =
		function(this, otherClass)
			assert(type(otherClass) == "table");
			local theClass = newClass;
			while (theClass ~= otherClass) and theClass.__base do 
				theClass = theClass.__base;
			end;
			return theClass == otherClass;
		end;
		
	setmetatable(newClass, newClassMetatable);
	return newClass;
end;

