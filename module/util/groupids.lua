--[[!
	\file
	\brief Es un módulo que permite crear grupos de ids y comprobar si una id 
	está en alguno de estos grupos. Los grupos pueden agruparse paara formar grupos
	más complejos, con operadores de negación y or.
]]

loadModule("util/class");
loadModule("util/math/range");
loadModule("util/checkutils");
loadModule("util/stringutils");


--[[!
	Esta clase representa un conjunto de IDs arbitrarias.
]]
groupIds = class();

--[[!
	Inicializador. 
	@param ... Es un conjunto de rangos de ids e ids que compondrán al grupo 
	inicialmente. 
	@note Si se indican tablas como argumentos deberán ser instancias de la clase
	range. Por el contrario, deben ser números.
]]
function groupIds:init(...)
	self.ranges = {};
	for _, ids in ipairs({...}) do 
		if type(ids) == "table" then 
			self:addRangeIds(ids);
		else
			self:addId(ids);
		end;
	end;
end;

--[[!
	Convierte una cadena de caracteres en un grupo de IDs.
	@param str Es la cadena de caracteres donde se especifican las IDs o bien rangos de IDs 
	separados por comas o por punto y coma
	@param symbols Por defecto es una tabla vacía. Es una tabla con grupos de IDs. Los índices son símbolos representativos
	de estos grupos (pueden especificarse en la cadena de caracteres a analizar y serán interpretados como el grupo de IDs que representan) y los 
	valores son los grupos de IDs.
	\code
	local group = groupIds.fromString("3, 4, 5,3,10,20,30,  70-80, -1);
	\endcode
]]	
function groupIds.fromString(str, symbols) 
	-- tokenizar la cadena de caracteres.
	local tokens = {};
	for token in wpairs(str, ",; ") do tokens[#tokens+1] = token; end;
	local group = groupIds();
	-- analizar cada token
	for _, token in ipairs(tokens) do 
		if token:match("%d+-%d+") then 
			local lowerBound, upperBound = token:match("(%d+)-(%d+)");
			lowerBound, upperBound = tonumber(lowerBound), tonumber(upperBound);
			group:addRangeIds(range(lowerBound, upperBound));
		elseif token:match("%d+") then 
			local id = tonumber(token:match("(%d+)"));
			group:addId(id);
		else 
			localizedAssert(symbols and symbols[token], "Failed to parse group IDs; " .. token .. " is not a valid ID our group of IDs", 2);
			group = group + symbols[token];
		end;
	end;
	
	return group;
end;

--[[!
	Añade un rango de IDs al conjunto.
]]
function groupIds:addRangeIds(rangeIds)
	if #self.ranges > 0 then 
		-- buscar el primer rango que interseccione con el nuevo rango.
		local i = 1; 
		while (i < #self.ranges) and (not rangeIds:intersectsWith(self.ranges[i]:translate(1, 1))) do 
			i = i + 1;
		end;
		if rangeIds:intersectsWith(self.ranges[i]:translate(1, 1)) then 
			if i < #self.ranges then 
				-- buscar el primer rango después del rango i que no intersecciona
				-- con el nuevo rango.
				local j = i;
				while ((j+1) < #self.ranges) and rangeIds:intersectsWith(self.ranges[j+1]:translate(1, 1)) do 
					j = j + 1;
				end;
				if not rangeIds:intersectsWith(self.ranges[j+1]:translate(1, 1)) then 
					-- Reemplazamos rangos desde el i+1ésimo hasta el jésimo por un 
					-- nuevo rango.
					local aux = rangeIds:getWrapper(self.ranges[i]):getWrapper(self.ranges[j]);
					for k=j,i+1,-1 do 
						table.remove(self.ranges, k);
					end;
					self.ranges[i] = aux;
				else 
					-- no hay ningún rango después del rango iésimo que no
					-- interseccione con el nuevo rango.
					local aux = rangeIds:getWrapper(self.ranges[i]):getWrapper(self.ranges[j+1]); 
					-- eliminamos todos los rangos a partir del iesimo.
					for k=j+1,i+1,-1 do 
						table.remove(self.ranges, k);
					end;
					-- insertamos el nuevo rango..
					self.ranges[i] = aux; 
				end;
			else
				local aux = self.ranges[i];
				self.ranges[i] = rangeIds:getWrapper(aux);
			end;
		else
			-- no intersecciona con ningún rango, insertar el nuevo rango
			-- después del rango cuyo límite superior es inferior al límite
			-- inferior del nuevo rango...
			-- buscar ese rango...
			if #self.ranges > 1 then 
				i = 1;
				while ((i+1) < #self.ranges) and (rangeIds:getUpperBound() >  self.ranges[i+1]:getLowerBound()) do 
					i = i + 1;
				end;
				if rangeIds:getUpperBound() < self.ranges[i+1]:getLowerBound() then 
					table.insert(self.ranges, i, rangeIds);
				else
					table.insert(self.ranges, rangeIds);
				end;
			else
				if rangeIds:getUpperBound() < self.ranges[1]:getLowerBound() then 
					table.insert(self.ranges, 1, rangeIds);
				else
					table.insert(self.ranges, rangeIds);
				end;
			end;
		end;
	else
		table.insert(self.ranges, rangeIds); 
	end;
end;

--[[!
	Añade una id al conjunto.
]]
function groupIds:addId(id)
	self:addRangeIds(range(id, id));
end;


--[[!
	@return Devuelve todas las IDs que pertenecen a este grupo en una tabla.
	@note Las IDs están situadas en la tabla de forma creciente.
]]
function groupIds:getAllIds()
	local aux = {};
	for _,r in ipairs(self.ranges) do 
		for i=r:getLowerBound(),r:getUpperBound(),1 do 
			aux[#aux+1] = i;
		end;
	end;
	return aux;
end;

--[[!
	@return Devuelve un valor booleano indicando si una ID está en este conjunto
	o no.
]]
function groupIds:isInside(x) 
	if #self.ranges > 0 then 
		if #self.ranges > 1 then 
			-- buscar el rango previo al rango cuyo límite inferior es 
			-- superior al valor.
			if self.ranges[1]:getLowerBound() > x then 
				return false; 
			end;
			local i = 1;
			while ((i+1) < #self.ranges) and (x >= self.ranges[i+1]:getLowerBound()) do 
				i = i + 1;
			end; 
			if x < self.ranges[i+1]:getLowerBound() then 
				return x <= self.ranges[i]:getUpperBound();
			else	 
				return x <= self.ranges[i+1]:getUpperBound();
			end;
		end;
		return self.ranges[1]:isInside(x);
	end;
	return false;
end;

--[[!
	@return Devuelve not self:isInside(x) 
]]
function groupIds:isOutside(x) 
	return not self:isInside(x);
end;

--[[!
	Es un alias de groupIds.isInside
]]
groupIds.has = groupIds.isInside;


--[[!
	@return Devuelve un conjunto de IDs que contiene las IDs de dos conjuntos.
	(Operación or)
]]
function groupIds.__add(a, b) 
	local aux = a:clone();
	for _, range in ipairs(b.ranges) do 
		aux:addRangeIds(range);
	end;
	return aux;
end;


--[[!
	@return Devuelve una representación en forma de cadena de caracteres
	de este grupo. 
]]
function groupIds.__tostring(g) 
	return "[" .. table.concat(g:getAllIds(), ",") .. "]";
end;

-- Es un grupo que no contiene ninguna ID
groupIds.empty = groupIds();


