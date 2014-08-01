--[[!
	\file
	\brief Representa un rango de números arbitrarios. Todos los números
	entre el límite inferior y superior del rango, INCLUSIVE, formarán parte
	de ste.
]]

package.path = package.path .. ";../?.lua";
require 'class';

-- loadModule("util/class");


range = class();

--[[!
	Inicializa el rango.
	@param lowerBound Es el límite inferior del rango.
	@param upperBound Es el límite superior del rango
	@note Si upperBound < lowerBound, los valores de los límites se
	intercambian.
]]
function range:init(lowerBound, upperBound)
	if lowerBound > upperBound then 
		lowerBound, upperBound = upperBound, lowerBound;
	end;
	self.lower = lowerBound;
	self.upper = upperBound;
end;


--[[!
	@return Devuelve el límite inferior del rango.
]]
function range:getLowerBound()
	return self.lower;
end;	

--[[!
	@return Devuelve el límite superior del rango
]]
function range:getUpperBound()
	return self.upper;
end;

--[[!
	@return Devuelve una representación en forma de cadena de caracteres del
	rango
]]
function range.__tostring(r) 
	return "[" .. r:getLowerBound() .. " , " .. r:getUpperBound() .. "]";
end;

--[[!
	@return Devuelve un valor booleano indicando si un número está en este
	rango.
]]	
function range:isInside(x) 
	return (x >= self.lower) and (x <= self.upper);
end;

--[[!
	@return Devuelve not self:isOutside()
]]
function range:isOutside(x) 
	return not self:isOutside(x);
end;

--[[!
	@return Devuelve un valor booleano indicando si dos rangos tienen un
	subrango en común.
]]
function range:intersectsWith(other) 
	return (self.upper >= other.lower) and (other.upper >= self.lower);
end;

--[[!
	@return Devuelve la intersección de dos rangos. False si no interseccionan.
]]
function range:getIntersection(other)
	if self:intersectsWith(other) then 
		if self.upper >= other.upper then
			return range(math.max(self.lower, other.lower), other.upper);
		else
			return range(math.max(other.lower, self.lower), self.upper);
		end;
	end;
	return false;
end;

--[[!
	@return Devuelve un rango lo más pequeño posible y además, que tenga como subrangos,
	este rango y otro rango.
]]
function range:getWrapper(other) 
	return range(math.min(self.lower, other.lower), math.max(self.upper, other.upper));
end;

--[[!
	@return Devuelve un nuevo rango pero transladando sus límites.
	@param deltaLower Es el número de unidades que restamos al límite inferior del rango.
	@param deltaUpper Es el número de unidades que sumamos al límite superior del rango.
	@note Si al final el límite inferior es mayor que el límite superior, los valores de 
	los límites se intercambian.
]]
function range:translate(deltaLower, deltaUpper) 
	return range(self.lower - deltaLower, self.upper + deltaUpper);
end;