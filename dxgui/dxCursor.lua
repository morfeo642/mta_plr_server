
--[[!
	\author Victor Ruiz Gómez, victorruizgomez642@gmail.com, Spain 

	\file
	\brief Este script permite cambiar la apariencia del cursor del MTA en base a los themes de dxgui.
]]


local function dxCreateCursor()
	local cursor = createElement("dxCursor");
	setElementData(cursor, "color", tocolor(255,255,255,getCursorAlpha()));
	setElementData(cursor, "backgroundComponent", dxGetRootPane());
	
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
			end;
			-- get cursor position.
			local color = tocolor(r, g, b, a);
			local x, y = getCursorAbsolute();
			local backgroundComponent = getElementData(cursor, "backgroundComponent")
			local theme = dxGetElementTheme(backgroundComponent);
			local image;
			local sizeFactor = 1.25;
			
			-- is background component a window and is being moved ? 
			if (getElementType(backgroundComponent) == "dxWindow") and (getElementData(backgroundComponent, "isMoving", false)) then 
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

addEventHandler("onClientDXMouseEnter", root, 
	function() 
		local cursor = getElementData(dxGetRootPane(), "cursor");
		setElementData(cursor, "backgroundComponent", source);
	end);
	
addEventHandler("onClientDXMouseLeave", root,
	function() 
		setElementData(getElementData(dxGetRootPane(), "cursor"), "backgroundComponent", getElementParent(source));		
	end);