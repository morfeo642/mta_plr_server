

--[[!
	\file
	\brief Modulo con utilidades para trabajar con eventos y manejadores
	de eventos (event handlers)
]]


--[[!
Crea un manejador de evento que solo se lanza cuando el evento en cuestión se genera
(sobre el elemento al que está vinculado), una única vez, y luego se elimina así mismo.
Los parámetros de está función son los mismos que para la función addEventHandler
]]
function addAutoremovableEventHandler(eventName, attachedTo, handlerFunction, getPropagated, priority)
	assert(type(handlerFunction) == "function");
	local function autoRemovableEventHandler(...)
		local success, msg = pcall(handlerFunction, ...);
		-- eliminar el manejador.
		removeEventHandler(eventName, attachedTo, handlerFunction);
		-- propagar el error si es que hubo alguno en el manejador.
		if not success then error(msg); end; 
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
el evento se cancela continuamente.
@param reason Es la razón de porque el evento es cancelado, por defecto ninguna
]]
function addCancellerEventHandler(eventName, attachedTo, getPropagated, priority, autoRemovable, reason)
	local function cancellerEventHandler() 
		cancelEvent(true, reason);
	end;
	if autoRemovable then 
		addAutoremovableEventHandler(eventName, attachedTo, cancellerEventHandler, getPropagated, priority);
	else 
		addEventHandler(eventName, attachedTo, cancellerEventHandler, getPropagated, priority);	
	end;
end;

