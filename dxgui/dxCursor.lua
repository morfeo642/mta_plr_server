
--[[!
	\author Victor Ruiz Gómez, victorruizgomez642@gmail.com, Spain 

	\file
	\brief Este script permite cambiar la apariencia del cursor del MTA en base a los themes de dxgui.
]]


local function dxCreateCursor()
	local cursor = createElement("dxCursor");
	setElementData(cursor, "color", tocolor(255,255,255,getCursorAlpha()));
	setElementData(cursor, "theme", dxGetDefaultTheme());
	
	addEventHandler("onClientElementDestroy", cursor,
		function()
			setCursorAlpha(extractalpha(getElementData(source, "color")));
		end);
	return cursor;
end;

--// Eventos
addEventHandler("onClientResourceStart", resourceRoot, 
	function()
		local cursor = dxCreateCursor();
		setElementData(dxGetRootPane(), "cursor", cursor);
	end, false, "normal-1");


addEventHandler("onClientRender", root,
	function() 
		if isCursorShowing() then 
			local cursor = getElementData(dxGetRootPane(), "cursor");

			local r, g, b, a = fromcolor(getElementData(cursor, "color")); 
			if getCursorAlpha() ~= 0 then 
				a = getCursorAlpha();
				setCursorAlpha(0);
				setElementData(cursor, "color", tocolor(r, g, b, a));
			end;
			-- get cursor position.
			local color = tocolor(r, g, b, a);
			local x, y = getCursorAbsolute();
			local theme = getElementData(cursor, "theme");
			local image;
			local sizeFactor = 1.25;
			
			-- is any window being moved ? 
			--
			if isAnyWindowBeingMoved() then 
				image = "MouseMoveCursor:";
				-- move the cursor a bit to adjust move cursor. (cursor offset in the image must be in the center)
				x = x - getElementData(theme, image .. "Width") / 2;
				y = y - getElementData(theme, image .. "Height") / 2;
			else 
				image = "MouseArrow:";
			end;

			dxDrawImageSection(x, y, getElementData(theme, image .. "Width") * sizeFactor, getElementData(theme, image .. "Height") * sizeFactor, getElementData(theme, image .. "X"), getElementData(theme, image .. "Y"),
				getElementData(theme, image .. "Width"), getElementData(theme, image .. "Height"), getElementData(theme, image .. "images"),
				0, 0, 0, color, true);
			
		end;
	end);
	

--// Functions
--[[!
	Establece el color del cursor. Por defecto es white. (Notese que el color del cursor se mezcla con la imagen del mismo)
]]
function dxSetCursorColor(color)
	checkargs("cursorSetColor", 1, "number", color);
	setElementData(getElementData(dxGetRootPane(), "cursor"), "color", color);
end;

--[[!
	@return Devuelve el color del cursor.
]]
function dxGetCursorColor()
	return getElementData(getElementData(dxGetRootPane(), "cursor"), "color");
end;

--[[!
	@return Devuelve la componente alpha del color del cursor en el rango [0, 255]
]]
function dxGetCursorAlpha()
	return extractalpha(getCursorColor());
end;


--[[!
	Establece el valor de la componente alpha del color del cursor.
	@param alpha El nuevo valor de la componente alpha en el rango [0, 255]
]]
function dxSetCursorAlpha(alpha) 
	local r, g, b = fromcolor(getCursorColor());
	setCursorColor(tocolor(r, g, b, alpha));
end;	

--[[!
	Establece el estilo de cursor.
	@param theme Es el nuevo estilo.
]]
function dxSetCursorTheme(theme)
	checkargs("dxSetCursorTheme", 1, {"dxTheme", "string"}, theme);
	if type(theme) == "string" then 
		theme = assert(dxGetTheme(theme), "dxCursor couldn´t find the main theme");
	end;
	setElementData(getElementData(dxGetRootPane(), "cursor"), "theme", theme);
end;

--[[!
	@return Devuelve el estilo actual del cursor.
]]
function dxGetCursorTheme(theme)
	return getElementData(getElementData(dxGetRootPane(), "cursor"), "theme");
end;