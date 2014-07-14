
--[[!
	\file
	\brief Script para facilitar la compartición de variables entre servidor y cliente.
]]

--[[! La tabla __client se usa para almacenar variables que pueden ser accedidas por parte 
del servidor ]]

__client = {};

setmetatable(__client,
	{
		__metatable = false	
	});
	

--[[! La tabla __server en la parte del cliente, es usada por parte del cliente, para acceder
a las variables almacenadas por el servidor ]]

__server = {};
setmetatable(__server,
	{
		__metatable = false
	});
	
	
--[[! La tabla __remote accede a las variables de clientes remotos.El índice es el cliente.
__remote[thisClient] = __client
]]

__remote = {};
setmetatable(__remote,
	{
		__metatable = false
	});
	
	

	