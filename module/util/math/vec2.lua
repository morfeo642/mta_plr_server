

--[[!
	\file
	\brief Script que ofrece utilidades para trabajar con vectores bidimensionales.
]]

loadModule("util/class");
loadModule("util/assertutils");


--[[! Esta clase representa un vector bidimensional ]]
vec2 = class();

--[[! Inicializador.
@param x Es la coordenada x del vector
@param y Es la coordenada y del vector 
]]
function vec2:init(x, y)
	self.x = x;
	self.y = y;
end;

--[[! 
@return Devuelve una copia de este vector.
]]
function vec2:clone()
	return vec2(self.x, self.y);
end;

--[[! Obtiene una representación en formato de cadena
de carácteres leíble del vector.
@param v Un vector bidimensional. 
]]
function vec2.__tostring(v)
	return "(" .. v.x .. " , " .. v.y .. ")";
end;

-- Operadores aritméticos.
--[[! 
@return Devuelve la suma de dos vectores bidimensionales. 
]]
function vec2.__add(u, v)
	return vec2(u.x + v.x, u.y + v.y);	
end;

--[[!
@return Devuelve la diferencia de dos vectores bidimensionales
]]
function vec2.__sub(u, v)
	return vec2(u.x - v.x, u.y - v.y); 
end;

--[[!
@return Devuelve la negación de un vector bidimensional. (Niega sus
coordenadas)
]]
function vec2.__unm(v)
	return vec2(-v.x, -v.y);
end;

--[[!
@return Devuelve el producto entre un vector bidimensional y un escalar.
]]
function vec2.__mul(v, k)
	return vec2(v.x * k, v.y * k);
end;

--[[!
@return Devuelve el producto entre un vector bidimensional y el valor de la inversa
de un escalar
]]
function vec2.__div(v, k)
	localizedAssert(k ~= 0, "Division by zero", 2);
	return vec2(v.x / k, v.y / k);
end;

-- Operadores lógicos.

--[[!
@return Devuelve true si las componentes de ambos vectores coinciden.
]]
function vec2.__eq(u, v)
	return (u.x == v.x) and (u.y == v.y);
end;

--[[!
@return Devuelve true si todas las componentes del primer vector u son menores 
o iguales que las componentes del vector v.
]]
function vec2.__lt(u, v)
	return (u.x < v.x) and (u.y < v.y);
end;


-- Otras operaciones.

--[[!
@return Devuelve el módulo del vector
]]
function vec2:module()
	return math.sqrt(self:squareModule());
end;

--[[!
Es un alias de module()
@return Devuelve el módulo del vector.
]]
vec2.length = vec2.module;


--[[!
@return Devuelve el módulo del vector elevado al cuadrado
]]
function vec2:squareModule()
	return self.x^2 + self.y^2;
end;

--[[!
Normaliza este vector, diviendo sus componentes por el módulo
del vector.
@return Devuelve el propio vector.
]]
function vec2:normalize()
	local m = self:module();
	localizedAssert(m ~= 0, "Division by zero", 2); 
	m = 1 / m;
	self.x = self.x * m;
	self.y = self.y * m;
	return self;
end;

--[[!
@return Devuelve un vector que es este vector pero normalizado.
]]
function vec2:normalized()
	return self:clone():normalize();
end;

--[[!
@return Devuelve el producto escalar de este vector con otro.
]]
function vec2:dot(v)
	return self.x * v.x + self.y * v.y;
end;

--[[!
@return Devuelve una interpoliación lineal de este vector con otro vector.
@param v Otro vector 
@param k El parámetro de interpolación lineal. [0, 1]
@note Lanza una excepción si el parámetro de interpolación lineal no está en
el rango [0, 1]
]]
function vec2:lerp(v, k)
	localizedAssert((k >= 0) and (k <= 1), "Lineal interpolation parameter should be in the range [0,1]", 2);
	return (self * (1 - k)) + (v * k);
end;

--[[!
@return Devuelve la proyección de este vector sobre otro vector.
]]
function vec2:projection(v)
	local m = v:squareModule();
	localizedAssert(m ~= 0, "Division by zero", 2);
	return v * (v:dot(self) / m);
end;


--[[! Vector bidimensional cuyas componentes son 0s ]]
vec2.zero = vec2(0, 0);

--[[ Vector bidimensional que es el eje de las abscisas ]]
vec2.x_axis = vec2(1, 0);

--[[ Vector bidimensional que es el eje de las ordenadas ]]
vec2.y_axis = vec2(0, 1);


