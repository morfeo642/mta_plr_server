--[[!
	\file
	\brief
	Este script crea un comando de consola que permite indicar que tipos de mensajes se mostrarán
	mediante una ventana de diálogo. La sintaxis del comando es:
	debugdialogs <level> 
	Donde level es el nivel. Si es igual a 1, solo se mostarán errores. Con el nivel 2, se mostarán errores
	y warnings, nivel 3 errores, warnings y info, y nivel 4, errores, warnings, info  y mensajes custom.
	Si es igual a 0, no se mostará nada.
	@note Este comando solo estará disponible para los administradores.
]]

-- Funciones auxiliares.

-- Comprueba si una cuenta tiene permisos de administrador.
local function isAdminAccount(account) 
	return isObjectInACLGroup("user." .. getAccountName(account), aclGetGroup("Admin")); 
end;

-- Comandos.
addCommandHandler("debugmessages",
	function(player, _, level)
		if type(level) == "string" then
			level = tonumber(level);
		end;
		if (type(level) ~= "number") or (level < 0) or (level > 4) then 
			outputChatBox("Syntax is \"debugmessages <level>\"");
			return;
		end;
		if isAdminAccount(getPlayerAccount(player)) then 
			__client[player].setDebugLevel(nil, level);
		else
			outputChatBox("You are not admin!, you cannot use this command");
		end;
	end, false, false);
	
 