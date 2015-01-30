
--[[!
	Establece el valor de una variable de configuración en una cuenta
	Esta configuración se guardará en la cuenta de un usuario, y por tanto, no será
	accesible directamente por el cliente. 
	@param account Es una cuenta donde se guardará la variable de configuración.
	@param configDataName Es el nombre de la variable de configuración
	@param configDataValue Es el nuevo valor de la variable, nil para borrar la variable de la cuenta.
	El valor puede ser un número, booleano, string o una tabla que sea convertible a string mediante table.toJSONX
	
	@note La configuración será privada para cada recurso para evitar conflictos de nombres.
]]
function setAccountConfigData(account, configDataName, configDataValue)
	checkArgumentsTypes("setAccountConfigData", 2, 2, configDataName, "string");
	checkOptionalArgumentType("setAccountConfigData", 2, configDataValue, 3, "boolean", "string", "number", "table");
	local preffix;
	if configDataValue ~= nil then preffix = type(configDataValue):sub(1,1); end;

	if type(configDataValue) == "table" then 	
		local validTable;
		validTable, configDataValue = pcall(table.toJSONX, configDataValue);
		localizedAssert(validTable, "Bad table passed to setPlayerConfigData", 2);
	elseif (type(configDataValue) == "number") or (type(configDataValue) == "boolean") then 
		configDataValue = tostring(configDataValue);
	elseif type(configDataValue) ~= "string" then 
		configDataValue = false;
	end;
	configDataName = getResourceName(sourceResource) .. ":" .. configDataName;
		
	if configDataValue then 
		setAccountData(account, configDataName, preffix .. configDataValue);
	else
		setAccountData(account, configDataName, false);
	end;	
end;

--[[!
	@return Devuelve el valor de una variable de configuración de una cuenta (nil si no existe)
	@param account Es la cuenta.
	@param configDataName Es el nombre de la variable de configuración.
]]
function getAccountConfigData(account, configDataName)
	checkArgumentsTypes("getAccountConfigData", 2, 2, configDataName, "string");
	
	local configDataValue = getAccountData(account, getResourceName(sourceResource) .. ":" .. configDataName);
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
		configDataValue = table.fromJSONX(configDataValue);
	end;
	return configDataValue;
end;

--[[!
	Es igual que setAccountConfigData pero la variable de configuración se guardará en la cuenta actual
	del jugador tomado como argumento.
	@see setAccountConfigData
]]
function setPlayerConfigData(player, ...)
	checkArgumentsTypes("setPlayerConfigData", 2, 1, player, "player");
	setAccountConfigData(getPlayerAccount(player), ...);
end;

--[[!
	Es igual que getAccountConfigData pero la variable de configuración se consulta en la cuenta actual
	del jugador pasado como argumento
	@see getAccountConfigData
]]	
function getPlayerConfigData(player, ...)
	checkArgumentsTypes("setPlayerConfigData", 2, 1, player, "player");
	return getAccountConfigData(getPlayerAccount(player), ...);
end;


addEventHandler("onResourceStart", resourceRoot,
	function() 
		-- cargamos los módulos necesarios
		loadModule("util/checkutils");
		loadModule("util/tableutils");
	end);
	