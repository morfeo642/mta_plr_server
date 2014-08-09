
--[[!
	Establece el valor de una variable en la configuración del usuario.
	Esta configuración se guardará en la cuenta del usuario, y por tanto, no será
	accesible directamente por el cliente. 
	@param player Es el jugador del que se quiere cambiar su configuración.
	@param configDataName Es el nombre de la variable de configuración
	@param configDataValue Es el nuevo valor de la variable, nil para borrar la variable de la cuenta.
	El valor puede ser un número, booleano, string o una tabla que sea convertible a string mediante table.toJSON
	
	@note La configuración será privada para cada recurso para evitar conflictos de nombres.
]]
function setPlayerConfigData(player, configDataName, configDataValue)
	checkArgumentsTypes("setPlayerConfigData", 2, 1, player, "player", configDataName, "string");
	checkOptionalArgumentType("setPlayerConfigData", 2, configDataValue, 3, "boolean", "string", "number", "table");
	local preffix;
	if configDataValue ~= nil then preffix = type(configDataValue):sub(1,1); end;

	if type(configDataValue) == "table" then 	
		local validTable;
		validTable, configDataValue = pcall(table.toJSON, configDataValue);
		localizedAssert(validTable, "Bad table passed to setPlayerConfigData", 2);
	elseif (type(configDataValue) == "number") or (type(configDataValue) == "boolean") then 
		configDataValue = tostring(configDataValue);
	elseif type(configDataValue) ~= "string" then 
		configDataValue = false;
	end;
	configDataName = getResourceName(sourceResource) .. ":" .. configDataName;
		
	if configDataValue then 
		setAccountData(getPlayerAccount(player), configDataName, preffix .. configDataValue);
	else
		setAccountData(getPlayerAccount(player), configDataName, false);
	end;	
end;

--[[!
	@return Devuelve el valor de una variable de configuración de un jugador (nil si no existe)
	@param player Es el jugador
	@param configDataName Es el nombre de la variable de configuración.
]]
function getPlayerConfigData(player, configDataName)
	checkArgumentsTypes("setPlayerConfigData", 2, 1, player, "player", configDataName, "string");
	
	local configDataValue = getAccountData(getPlayerAccount(player), getResourceName(sourceResource) .. ":" .. configDataName);
	if not configDataValue then 	
		return nil;
	end;
	local dataType;
	dataType, configDataValue = configDataValue:match("(%a)(.+)");
	
	-- que tipo de dato es ? 
	if dataType == "n" then 
		configDataValue = tonumber(configDataValue);
	elseif dataType == "b" then 
		configDataValue = (configDataValue == "true");
	elseif dataType == "t" then
		configDataValue = table.fromJSON(configDataValue);
	end;
	return configDataValue;
end;


addEventHandler("onResourceStart", resourceRoot,
	function() 
		-- cargamos los módulos necesarios
		loadModule("util/checkutils", _G);
		loadModule("util/tableutils", _G);
	end);
	