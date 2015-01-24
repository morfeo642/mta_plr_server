

--[[!
	\file
	\brief Modulo con utilidades para trabajar con eventos y manejadores
	de eventos (event handlers)
]]


loadModule("util/checkutils");

--[[!
Crea un manejador de evento que solo se lanza cuando el evento en cuestión se genera
(sobre el elemento al que está vinculado), una única vez, y luego se elimina así mismo.
Los parámetros de está función son los mismos que para la función addEventHandler
]]
function addAutoremovableEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
	checkArgumentType("addAutoremovableEventHandler", 2, eventName, 1, "string");
	checkIsElement("addAutoremovableEventHandler", 2, attachedTo, 2);
	checkArgumentType("addAutoremovableEventHandler", 2, handlerFunction, 3, "function");
	checkOptionalArgumentsTypes("addAutoremovableEventHandler", 2, 4, getPropagated, "boolean", priority, "string");
	local function autoRemovableEventHandler(...)
		-- eliminar el manejador.
		removeEventHandler(eventName, attachedTo, autoRemovableEventHandler);
		handlerFunction(...);
	end;
	return addEventHandler(eventName, attachedTo, autoRemovableEventHandler, getPropagated, priority);
end;	


--[[!
Crea un manejador que siempre cancela el evento que está manejando mediante el método cancelEvent()
@param eventName Es el nombre del evento
@param attachedTo Es el elemento asociado
@param getPropagated Indica si el evento debe propagarse hacía arriba y abajo del árbol de elementos
@param priority Es la pioridad de este manejador para se invocado
@param autoRemovable Si es true, el manejador solo cancelará el evento una vez y luego se eliminará. Si es false,
el evento se cancela continuamente. Por defecto, false.
@param reason Es la razón de porque el evento es cancelado, por defecto ninguna
]]
function addCancellerEventHandler(eventName, attachedTo, getPropagated, priority, autoRemovable, reason)
	checkArgumentType("addCancellerEventHandler", 2, eventName, 1, "string");
	checkIsElement("addCancellerEventHandler", 2, attachedTo, 2);
	checkOptionalArgumentsTypes("addCancellerEventHandler", 2, 3, getPropagated, "boolean", priority, "string",
			autoRemovable, "boolean", reason, "string");
	autoRemovable, reason = parseOptionalArguments(autoRemovable, false, reason, "");
	
	local function cancellerEventHandler() 
		cancelEvent(true, reason);
	end;
	if autoRemovable then 
		addAutoremovableEventHandler(eventName, attachedTo, cancellerEventHandler, getPropagated, priority);
	else 
		addEventHandler(eventName, attachedTo, cancellerEventHandler, getPropagated, priority);	
	end;
end;

