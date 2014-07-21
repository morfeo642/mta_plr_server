

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








