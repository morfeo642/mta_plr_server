
--[[!
	\file
	\brief Script para facilitar la compartición de variables entre servidor y cliente.
]]




--[[! La tabla __client es usada por el servidor para acceder a las variables de
los clientes. Cada entrada es una tabla para acceder a las variables especificamente
de un cliente. EL índice es el cliente. ]]
__client = {};
setmetatable(__client,
	{
		__metatable = false
	});
	
	
--[[! La tabla __server es usada por el servidor para que los clientes conectados puedan
acceder a las variables que haya declarado dentro
]]
__server = {};
setmetatable(__server,
	{
		__metatable = false
	});
