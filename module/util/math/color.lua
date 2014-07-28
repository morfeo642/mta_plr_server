
--[[!
	\file
	\brief Este módulo ofrece utilidades para trabajar con colores.
]]

loadModule("util/class");


local function clamp(value, minValue, maxValue)
	return math.max(minValue, math.min(value, maxValue)); 
end;

local function clampComponent(value) 
	return clamp(value, 0, 1);
end;

local function clampRGBA(r, g, b, a) 
	return clampComponent(r), clampComponent(g), clampComponent(b), clampComponent(a); 
end;

--[[!
Representa un color en formato RGBA cuyas componentes están en el rango [0, 1]
]]
color = class();


function color:init(...) 
	local r, g, b, a = clampRGBA(...);
	self.r = r; self.g = g; self.b = b; self.a = a;
end;

--[[!
@param r Es la componente roja en el rango [0, 255]
@param g Es la componente verde en el rango [0, 255]
@param b Es la componente azul en el rango [0, 255]
@return Devuelve un color cuyas componentes RGB son las especificadas.
]]
function color.fromRGB(r, g, b) 
	return color(r / 255, g / 255, b / 255, 1); 
end;

--[[!
@param r Es la componente roja en el rango [0, 255]
@param g Es la componente verde en el rango [0, 255]
@param b Es la componente azul en el rango [0, 255]
@param a Es la componente alpha en el rango [0, 255]
@return Devuelve un color cuyas componentes RGBA son las especificadas. 
]]
function color.fromRGBA(r, g, b, a) 
	return color(r / 255, g / 255, b / 255, a / 255);
end;

--[[!
@param var Es un entero de 4 bytes. El tercer byte representa la componente roja, el segundo byte, la componente verde,
el primer byte, la componente azul, y el último byte, la componente alpha.
@return Devuelve el color extraido.
]]
function color.fromInt(int) 
	return color.fromRGBA(bitExtract(int, 16,8), bitExtract(int, 8, 8), bitExtract(int, 0, 8), bitExtract(int, 24,8)); 
end;

--[[!
@return Devuelve la componente roja del color en el rango [0, 255]
]]
function color:getRed()
	return 255 * self.r;
end;

--[[!
@return Devuelve la componente verde del color en el rango [0, 255]
]]
function color:getGreen()
	return 255 * self.g;
end;

--[[!
@return Devuelve la componente azul del color en el rango [0, 255]
]]
function color:getBlue()
	return 255 * self.b;
end;

--[[!
@return Devuelve la componente alpha del color en el rango [0, 255]
]]
function color:getAlpha()
	return 255 * self.a;
end;

--[[!
@return Establece la componente roja del color.
@param  r Es la nueva componente roja, en el rango [0, 255]
]]
function color:setRed(r)
	self.r = r / 255;
end;

--[[!
@return Establece la componente verde del color.
@param  g Es la nueva componente verde, en el rango [0, 255]
]]
function color:setGreen(g) 
	self.g = g / 255;
end;

--[[!
@return Establece la componente azul del color.
@param  b Es la nueva componente azul, en el rango [0, 255]
]]
function color:setBlue(b) 
	self.b = b / 255;
end;

--[[!
@return Establece la componente alpha del color.
@param  a Es la nueva componente alpha, en el rango [0, 255]
]]
function color:setAlpha(a) 
	self.a = a / 255;
end;

--[[!
@return Devuelve las componentes RGB del color
]]
function color:toRGB() 
	return self:getRed(), self:getGreen(), self:getBlue();
end;

--[[!
@return Devuelve las componentes RGBA del color
]]
function color:toRGBA() 
	local r, g, b = self:toRGB();
	return r, g, b, self:getAlpha();
end;

--[[!
@return Devuelve un entero de 32 bit donde:
El primer byte representa la componente azul,
el segundo byte representa la componente verde,
el tercer byte, la componente roja y 
el último byte, la componente alpha.
]]
function color:toInt() 
	local int = 0; 
	int=bitReplace(int, self:getBlue(), 0, 8); 
	int=bitReplace(int, self:getGreen(), 8, 8);
	int=bitReplace(int, self:getRed(), 16, 8);
	int=bitReplace(int, self:getAlpha(), 24, 8);
	return int;
end;

-- Operaciones aritméticas.
--[[!
Invierte todas las componentes del color 
]]
function color.__unm(c)
	return color(1 - c.r, 1 - c.g, 1 - c.b, 1 - c.a);
end;

--[[!
Multiplica las componentes del color por un escalar. Las componentes luego
se clampean al rango [0, 1]
]]
function color.__mul(c, k)
	return color(clampRGBA(c.r * k, c.g * k, c.b * k, c.a * k));
end;

--[[!
Divide las componentes del color por un escalar. Las componentes luego
se clampean al rango [0, 1]
]]
function color.__div(c, k)
	assert(k ~= 0);
	return c * (1 / k);
end;

-- Operaciones lógicas.
--[[!
@return Devuelve un valor booleano indicando si dos colores son iguales 
(tienen las mismas componentes)
]]
function color.__eq(x, y) 
	return (x.r == y.r) and (x.g == y.g) and (x.b == y.b) and (x.a == y.a);
end;

--[[!
@return Devuelve un valor booleano indicando si las todas lascomponentes de un color
son menores que las componentes de otro color.
]]
function color.__lt(x, y)
	return (x.r < y.r) and (x.g < y.g) and (x.b < y.b) and (x.a < y.a);
end;

--[[!
@return Devuelve una representación en forma de cadenas de caracteres del color 
especificado.
]]
function color.__tostring(c)
	return "(" .. c:getRed() .. " , " .. c:getGreen() .. " , " .. c:getBlue() .. " , " .. c:getAlpha() .. ")"; 
end;


local blend_equation = 
{
	multiply = 
		function(x, y) 
			return x * y;
		end,
	addition = 
		function(x, y) 
			return x + y;	
		end,
	substract = 
		function(x, y) 
			return x - y;
		end,
	linear_burn = 
		function(x, y) 
			return x + y - 1;
		end,
	color_burn = 
		function(x, y)
			return 1 - (1-x) / y;
		end,
	color_dodge =
		function(x, y)
			return 1 - (1-x) / (1-y);
		end,
	darken = 
		function(x, y)
			return math.min(x, y);
		end,
	lighten = 
		function(x, y) 
			return math.max(x, y);
		end,
	screen = 
		function(x, y) 
			return -(-x * -y);		
		end,
	overlay = 
		function(x, y) 
			if x > 0.5 then 
				return (1 - (1 - 2 *(x - 0.5)) * (1 - y)); 
			end;
			return ((2 * x) * y);
		end,
	hard_light = 
		function(x, y) 
			if x > 0.5 then 
				return (1 - (1 - x) * (1 - 2*(y - 0.5))); 
			end;
			return (x * (2 * y));	
		end,
	soft_light = 
		function(x, y) 
			if x > 0.5 then 
				return  (1 - (1 - x) * (1 - (y - 0.5)));
			end;
			return  (x * (y + 0.5));
		end,
	difference = 
		function(x, y) 
			return math.abs(x, y);
		end
};
blend_equation.linear_dodge =  blend_equation.addition;

--[[!
Mezcla dos colores
@param c Es el color con el que se quiere mezclar 
@param blendMode Es el modo de mezclado. Por defecto "multiply".
Posibles valores. "multiply", "addition", "substract", "linear_burn", "color_burn",
"color_dodge", "linear_dodge", "darken", "lighten", "overlay", "hard_light", "soft_light",
"difference.
@note ver http://www.deepskycolors.com/archive/2010/04/21/formulas-for-Photoshop-blending-modes.html
@note ver http://en.wikipedia.org/wiki/Blend_modes
@return Devuelve el color resultante de la mezcla.
]]
function color:blend(c, blendMode)
	local mix = blend_equation[blendMode] or blend_equation.multiply;
	return color(mix(self.r, c.r), mix(self.g, c.g), mix(self.b, c.b), mix(self.a, c.a)); 
end;

-- Colores comunes.

color.black = color.fromRGB(0, 0, 0);
color.white = color.fromRGB(255, 255, 255);
color.red = color.fromRGB(255, 0, 0);
color.green = color.fromRGB(0, 255, 0);
color.blue = color.fromRGB(0, 0, 255);
color.violeta = color.fromRGB(76, 40, 130);
color.orange = color.fromRGB(255, 127.5, 0);
color.yellow = color.fromRGB(255, 255, 0);
color.brown = color.fromRGB(150, 75, 0);
color.grey = color.fromRGB(127.5, 127.5, 127.5);
color.gray = color.grey;
color.magenta = color.fromRGB(255, 0, 255);
color.cyan = color.fromRGB(0, 255, 255);

-- Colores iguales que los comunes pero con la componente alpha es igual a 0.
color.transparent = {};
setmetatable(color.transparent,
	{
		__metatable = false,
		__newindex = function() end,
		__index = 
			function(t, index)
				local c = color[index];
				if (type(c) == "table") and (c:isinstanceof(color)) then 
					local r, g, b = c.r, c.g, c.b;
					return color(r, g, b, 0);
				end;
			end
	});
