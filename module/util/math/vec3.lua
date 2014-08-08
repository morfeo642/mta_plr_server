

--[[!
	\file
	\brief Script que ofrece utilidades para trabajar con vectores tridimensionales.
]]

loadModule("util/class");


--[[! Esta clase representa un vector tridimensional ]]
vec3 = class();

--[[! Inicializador.
@param x Es la coordenada x del vector
@param y Es la coordenada y del vector 
@param z Es la coordenada z del vector
]]
function vec3:init(x, y, z)
	self.x = x;
	self.y = y;
	self.z = z;
end;

--[[! 
@return Devuelve una copia de este vector.
]]
function vec3:clone()
	return vec3(self.x, self.y, self.z);
end;

--[[! Obtiene una representación en formato de cadena
de carácteres leíble del vector.
@param v Un vector tridimensional. 
]]
function vec3.__tostring(v)
	return "(" .. v.x .. " , " .. v.y .. " , " .. v.z .. ")";
end;

-- Operadores aritméticos.
--[[! 
@return Devuelve la suma de dos vectores tridimensionales. 
]]
function vec3.__add(u, v)
	return vec3(u.x + v.x, u.y + v.y, u.z + v.z);	
end;

--[[!
@return Devuelve la diferencia de dos vectores tridimensionales
]]
function vec3.__sub(u, v)
	return vec3(u.x - v.x, u.y - v.y, u.z - v.z); 
end;

--[[!
@return Devuelve la negación de un vector tridimensional. (Niega sus
coordenadas)
]]
function vec3.__unm(v)
	return vec3(-v.x, -v.y, -v.z);
end;

--[[!
@return Devuelve el producto entre un vector tridimensional y un escalar.
]]
function vec3.__mul(v, k)
	return vec3(v.x * k, v.y * k, v.z * k);
end;

--[[!
@return Devuelve el producto entre un vector tridimensional y el valor de la inversa
de un escalar
]]
function vec3.__div(v, k)
	assert(k ~= 0);
	return vec3(v.x / k, v.y / k, v.z / k);
end;

-- Operadores lógicos.

--[[!
@return Devuelve true si las componentes de ambos vectores coinciden.
]]
function vec3.__eq(u, v)
	return (u.x == v.x) and (u.y == v.y) and (u.z == v.z);
end;

--[[!
@return Devuelve true si todas las componentes del primer vector u son menores 
o iguales que las componentes del vector v.
]]
function vec3.__lt(u, v)
	return (u.x < v.x) and (u.y < v.y) and (u.z < v.z);
end;


-- Otras operaciones.

--[[!
@return Devuelve el módulo del vector
]]
function vec3:module()
	return math.sqrt(self:squareModule());
end;

--[[!
Es un alias de module()
@return Devuelve el módulo del vector.
]]
vec3.length = vec3.module;


--[[!
@return Devuelve el módulo del vector elevado al cuadrado
]]
function vec3:squareModule()
	return self.x^2 + self.y^2 + self.z^2;
end;

--[[!
Normaliza este vector, diviendo sus componentes por el módulo
del vector.
@return Devuelve el propio vector.
]]
function vec3:normalize()
	local m = self:module();
	assert(m ~= 0); 
	m = 1 / m;
	self.x = self.x * m;
	self.y = self.y * m;
	self.z = self.z * m;
	return self;
end;

--[[!
@return Devuelve un vector que es este vector pero normalizado.
]]
function vec3:normalized()
	return self:clone():normalize();
end;

--[[!
@return Devuelve el producto escalar de este vector con otro.
]]
function vec3:dot(v)
	return self.x * v.x + self.y * v.y + self.z * v.z;
end;

--[[!
@return Devuelve una interpoliación lineal de este vector con otro vector.
@param v Otro vector 
@param k El parámetro de interpolación lineal. [0, 1]
@note Lanza una excepción si el parámetro de interpolación lineal no está en
el rango [0, 1]
]]
function vec3:lerp(v, k)
	assert((k >= 0) and (k <= 1));
	return (self * (1 - k)) + (v * k);
end;

--[[!
@return Devuelve la proyección de este vector sobre otro vector.
]]
function vec3:projection(v)
	local m = v:squareModule();
	assert(m ~= 0);
	return v * (v:dot(self) / m);
end;


--[[! Vector tridimensional cuyas componentes son 0s ]]
vec3.zero = vec3(0, 0, 0);

--[[ Vector tridimensional que es el eje X ]]
vec3.x_axis = vec3(1, 0, 0);

--[[ Vector tridimensional que es el eje Y ]]
vec3.y_axis = vec3(0, 1, 0);

--[[ Vector tridimensional que es el eje Z ]]
vec3.z_axis = vec3(0, 0, 1);


