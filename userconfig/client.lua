
-- Funciones auxiliares.


-- Esta función auxiliar carga la configuración local del cliente, desde un fichero XML de un recurso especifico "userconfig.xml".
local function loadLocalConfigDataFromXMLFile(resource)
	local function loadLocalConfigDataFromXMLNode(parent) 
		local configData = {};
		for _, node in ipairs(xmlNodeGetChildren(parent)) do 
			local configDataType = xmlNodeGetName(node);
			local configDataName, configDataValue = xmlNodeGetAttribute(node, "name"), xmlNodeGetAttribute(node, "value");
			if ((configDataType == "boolean") or (configDataType == "number") or (configDataType == "string") or (configDataType == "table")) then 
				if configDataType == "number" then
					configDataValue = tonumber(configDataValue);
				elseif configDataType == "boolean" then 
					if configDataValue == "true" then 
						configDataValue = true;
					elseif configDataValue == "false" then 
						configDataValue = false;
					else
						configDataValue = nil;
					end;
				elseif configDataType == "table" then 
					configDataValue = table.fromJSONX(configDataValue);
					if not configDataValue then 
						configDataValue = nil;
					end;
				end;
				
				if configDataValue ~= nil then 
					configData[configDataName] = configDataValue;
				end;	
			end;	
		end;
		return configData;
	end;

	local file = xmlLoadFile(":" .. getResourceName(resource) .. "/userconfig.xml"); 
	if not file then 
		return {}; 
	end;
	local configData = loadLocalConfigDataFromXMLNode(file);
	xmlUnloadFile(file);
	return configData;
end; 

-- Esta función guarda la configuración local del usuario en un fichero XML.
local function saveLocalConfigDataToXMLFile(resource, configData)
	local function saveLocalConfigDataToXMLNode(parent, configData)
		for configDataName, configDataValue in pairs(configData) do 
			local configDataType = type(configDataValue);
			if (configDataType == "number") or (configDataType == "boolean") then 
				configDataValue = tostring(configDataValue);
			elseif configDataType == "table" then 
				configDataValue = table.toJSONX(configDataValue);
			end;
			local node = xmlCreateChild(parent, configDataType);
			xmlNodeSetAttribute(node, "name", configDataName);
			xmlNodeSetAttribute(node, "value", configDataValue);
		end;
	end;
	local file = xmlCreateFile(":" .. getResourceName(resource) .. "/userconfig.xml", "userconfig");
	saveLocalConfigDataToXMLNode(file, configData);
	xmlSaveFile(file);
end;	


-- Tablas auxiliares
local configData = {};
local configDataChanged = {};

-- Funciones exportadas.

--[[!
	Establece el valor de una variable de configuración local del cliente. 
	@param configDataName Es el nombre del dato.
	@param configDataValue Es el nuevo valor del dato. Nil para borrarlo. Puede ser un valor booleano, numero, string o tabla (siempre 
	que sea convertible a string mediante table.toJSONX)
]]
function setClientLocalConfigData(configDataName, configDataValue)
	checkArgumentType("setClientLocalConfigData", 2, configDataName, 1, "string");
	checkOptionalArgumentType("setClientLocalConfigData", 2, configDataValue, 2, "string", "number", "boolean", "table");
	localizedAssert((type(configDataValue) ~= "table") or table.toJSONX(configDataValue));
	
	-- si la configuración local no se ha cargado todavía, leer del fichero XML del recurso.
	if not configData[sourceResource] then 
		configData[sourceResource] = loadLocalConfigDataFromXMLFile(sourceResource);
	end;	
	if configData[sourceResource][configDataName] ~= configDataValue then 
		configData[sourceResource][configDataName] = configDataValue; 
		configDataChanged[sourceResource] = true;
	end;
end; 


--[[!
	@return Devuelve una variable de configuración local del cliente. (Se guarda localmente, y no en el 
	servidor). Devuelve nil si esa variable no existe.
	@param configDataName Es el nombre de la variable de configuración. 
	@note Las variables de configuración de un recurso son independientes de las variables de configuración de otro
	recurso, por lo que no hay colisiones entre nombres.
]]
function getClientLocalConfigData(configDataName)
	checkArgumentType("getClientLocalConfigData", 2, configDataName, 1, "string");

	-- si la configuración local no se ha cargado todavía, leer del fichero XML del recurso.
	if not configData[sourceResource] then 
		configData[sourceResource] = loadLocalConfigDataFromXMLFile(sourceResource);
	end;
	return configData[sourceResource][configDataName]; 
end;



-- Eventos.

addEventHandler("onClientResourceStart", resourceRoot,	
	function() 
		-- cargamos los módulos necesarios.
		loadModule("util/checkutils");
		loadModule("util/tableutils");
	end);
	
addEventHandler("onClientResourceStop", root,
	function(resource) 
		-- guardar la configuración si ha sido modificada.
		if configDataChanged[resource] then 
			configDataChanged[resource] = nil;
			saveLocalConfigDataToXMLFile(resource, configData[resource]);
			configData[resource] = nil;
		end;
	end);	