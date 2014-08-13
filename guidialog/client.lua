

local screenWidth, screenHeight = guiGetScreenSize();

-- Funciones auxiliares.
local function parseDialogOptions(str) 
	dialogOptions = {};
	for token in str:gmatch("[^,]+") do 
		if token:match("\"[^\"]+\"") then 
			dialogOptions[#dialogOptions+1] = token:match("\"([^\"]+)\"");
		elseif token:match("%S+") then 
			dialogOptions[#dialogOptions+1] = token:match("(%S+)");
		end;
	end;
	if #dialogOptions == 0 then 
		dialogOptions[1] = "ok"; 
	end;
	return dialogOptions;
end;

local function createDialogButtons(dialogWindow, dialogOptions, buttonMaxWidth, buttonHeight, buttonInset)
	local buttonWidth = math.min((1 - ((#dialogOptions - 1) * buttonInset) - 2 * buttonInset) / #dialogOptions, buttonMaxWidth);
	local buttonX, buttonY = 1 - buttonWidth * #dialogOptions - (#dialogOptions - 1) * buttonInset - buttonInset, 1 - buttonHeight;
	buttonX = buttonX - (buttonX - buttonInset) / 2;
	local dialogButtons = {};
	for i, option in ipairs(dialogOptions) do 
		local button = guiCreateButton(buttonX + (i - 1) * (buttonWidth + buttonInset), buttonY, buttonWidth, buttonHeight, option, true, dialogWindow);
		dialogButtons[option] = button;
	end;	
	return dialogButtons;
end;

--[[!
	Crea un diálogo que contiene información.
	@param x Es la componente x de la posición de la ventana del diálogo.
	@param y Es la componente y
	@param title Es el título de la ventana del diálogo
	@param text Es información adicional que se mostrará en la ventana del diálogo.
	@param relative Indica si bien las posicion es relativa a la pantalla o no.
	@param dialogType Es el tipo de diálogo. Los posibles valores son: "info", "warning", "error", por defecto "info"
	@param dialogOptions Son una lista de opciones del diálogo separadas por comas. Por defecto: "ok" (ej. "ok, cancel", "ok, cancel, retry", ...)
		Si se quiere especificar alguna opción que contenga espacios, debe cerrarse con dobles comillas: "ok, cancel, \"try again\"" 
		Si no se indica ninguna opcion por defecto es "ok"
	@param color Es el color del texto que se muestra en la ventana del diálogo
	@param font Es la fuente de texto usada por el texto mostrado en la ventana
	@param theme Será el estilo de la ventana
	@return Devuelve la ventana del diálogo.
	
	@note Cuando el usuario escoga alguna de las opciones del diálogo, se producirá el evento "onClientMessageDialogClose", donde source será la ventana del diálogo y 
	se pasará como argumento la opción escogida. ej. Si las opciones eran "ok, cancel, retry", los posibles argumentos serán "ok", o "retry", o "cancel"
	Una vez que este evento se produzca, si el evento no se cancela mediante cancelEvent(), el diálogo se elimina automaticamente.
]]
function createMessageDialog(x, y, title, text, relative, dialogType, dialogOptions, color, font, theme) 
	checkArgumentsTypes("createMessageDialog", 2, 1, x, "number", y, "number", title, "string", text, "string", relative, "boolean");
	checkOptionalArgumentsTypes("createMessageDialog", 2, 6, dialogType, "string", dialogOptions, "string", color, "number", theme, {"dxTheme", "string"});
	checkOptionalArgumentValue("createMessageDialog", 2, dialogType, 6, "info", "warning", "error");
	
	dialogType, dialogOptions = parseOptionalArguments(dialogType, "info", dialogOptions, "ok");
	
	local screenWidth, screenHeight = guiGetScreenSize();
	if not relative then 
		x = x / screenWidth;
		y = y / screenHeight;
	end;
	
	-- Establecemos unas dimensiones fijas para la ventana del diálogo.
	local width, height = 0.37, 0.23;
	local aspectRatio = width / height;
	
	-- Que opciones hay para el diálogo ?
	dialogOptions = parseDialogOptions(dialogOptions);
	
	-- Creamos la ventana del diálogo.
	local dialogWindow = guiCreateWindow(x, y, width, height, title, false);
	
	-- Truco para que la ventana este asociada al recurso llamante.
	setElementData(dialogWindow, "resource", sourceResource);
	
	-- Creamos el icono de la ventana de diálogo.
	guiCreateStaticImage(0.1, 0.15 + 0.05 * aspectRatio, 0.20, 0.20 * aspectRatio, "images/" .. dialogType .. ".png", true, dialogWindow); 
	
	-- Creamos el label que contendrá el texto
	local textLabel = guiCreateLabel(0.4, 0.15 + 0.05 * aspectRatio + 0.04, 0.5, 0.46, text, true, dialogWindow, color, font);
	guiLabelSetHorizontalAlign(textLabel, "center");
	guiLabelSetVerticalAlign(textLabel, "top");
	
	-- Creamos los botones para las opciones
	local buttonInset = 0.05;
	local buttonMaxWidth = 0.4;
	local buttonHeight = 0.2;
	local dialogButtons = createDialogButtons(dialogWindow, dialogOptions, buttonMaxWidth, buttonHeight, buttonInset);
	
	for option, button in pairs(dialogButtons) do 
		addEventHandler("onClientDXClick", button,
			function(mouseButton, pressed) 
				if (mouseButton ~= "left") or (not pressed) then return; end;
				triggerEvent("onClientMessageDialogClose", dialogWindow, guiGetText(source));
				if not wasEventCancelled() then 
					-- eliminamos el diálogo.
					guiDestroyElement(dialogWindow);
				end;
			end, false);
	end;	
	
	-- Establecemos el estilo de los componentes
	if theme then  
		guiSetElementTheme(dialogWindow, theme, true);
	end;
	return dialogWindow;
end;

--[[!
	Crea un diálogo especial con un editbox y unos botonoes como opciones.
	El usuario introducirá algún texto y pulsará alguno de los botones que se le ofrecen. Cuando una de estas opciones es escogida,
	se produce el evento "onClientInputDialogClose" con source la ventana del diálogo, y como parámetros, el texto introducido por el usuario, y la 
	opción escogida.
	@param x Es la coordenada x de la posición del diálogo
	@param y Es la coordenada y de la posición del diálogo
	@param title Es el título de la ventana del diálogo.
	@param text Es el texto que el usuario ve encima del campo editable (donde tiene que introducir el texto)
	@param relative Indica si la posición es relativa al tamaño de la pantalla.
	@param dialogOptions Son una lista de opciones del diálogo separadas por comas. Por defecto: "ok" (ej. "ok, cancel", "ok, cancel, retry", ...)
		Si se quiere especificar alguna opción que contenga espacios, debe cerrarse con dobles comillas: "ok, cancel, \"try again\"" 
		Si no se indica ninguna opcion por defecto es "ok"
	@param masked Un valor booleano que indica si el texto debe se enmascarado, por defecto no.
	@param maxLength Si se indica, será el número máximo de caracteres que el usuario puede introducir en el campo.
	@param color Es el color del texto informativo, por defecto white
	@param font Es la fuente del texto informativo, por defecto "default"
	@param theme Es el estilo del diálogo, por defecto dxGetDefaultTheme()
	
	@return Devuelve la ventana asociada al diálogo.
]]
function createInputDialog(x, y, title, text, relative, dialogOptions, masked, maxLength, color, font, theme) 
	checkArgumentsTypes("createInputDialog", 2, 1, x, "number", y, "number", title, "string", text, "string", relative, "boolean");
	checkOptionalArgumentsTypes("createInputDialog", 2, 6, dialogOptions, "string", masked, "boolean", maxLength, "number", color, "number", theme, {"dxTheme", "string"});
	checkOptionalArgumentValue("createInputDialog", 2, dialogType, 6, "info", "warning", "error");
	
	dialogOptions = parseOptionalArguments(dialogOptions, "ok");
	
	-- Establecemos unas dimensiones fijas para la ventana del diálogo.
	local width, height = 0.38, 0.23;
	local aspectRatio = width / height;
	
	-- Que opciones hay para el diálogo ? 
	dialogOptions = parseDialogOptions(dialogOptions);
	
	-- Creamos la ventana
	local dialogWindow = guiCreateWindow(x, y, width, height, title, relative);
	
	-- Truco para que la ventana este asociada al recurso llamante.
	setElementData(dialogWindow, "resource", sourceResource);
	
	-- Creamos el label que contendrá el texto informativo
	local textLabel = guiCreateLabel(0.1, 0.2, 0.8, 0.3, text, true, dialogWindow, color, font);
	guiLabelSetHorizontalAlign(textLabel, "center");
	guiLabelSetVerticalAlign(textLabel, "top");
	
	-- Creamos el campo editable.
	local editField = guiCreateEdit(0.1, 0.55, 0.8, 0.2, "", true, dialogWindow);
	
	-- Establecer el número máximo de caracteres y el texto enmascarado..
	if masked ~= nil then 
		guiEditSetMasked(editField, masked);
	end;
	if maxLength then 
		guiEditSetMaxLength(editField, maxLength);
	end;
	
	-- Creamos los botones para las opciones..
	local buttonInset = 0.05;
	local buttonMaxWidth = 0.4;
	local buttonHeight = 0.2;
	local dialogButtons = createDialogButtons(dialogWindow, dialogOptions, buttonMaxWidth, buttonHeight, buttonInset);
	
	for option, button in pairs(dialogButtons) do 
		addEventHandler("onClientDXClick", button,
			function(mouseButton, pressed) 
				if (mouseButton ~= "left") or (not pressed) then return; end;
				triggerEvent("onClientInputDialogClose", dialogWindow, guiGetText(editField), guiGetText(source));
				if not wasEventCancelled() then 
					-- eliminamos el diálogo.
					guiDestroyElement(dialogWindow);
				end;
			end, false);
	end;		
	
	if theme then 
		guiSetElementTheme(dialogWindow, theme, true);
	end;	
	return dialogWindow;
end;

-- Eventos
addEvent("onClientMessageDialogClose", true);
addEvent("onClientInputDialogClose", true);

addEventHandler("onClientResourceStart", resourceRoot,
	function()
		loadModule("util/checkutils", _G);
	end);
