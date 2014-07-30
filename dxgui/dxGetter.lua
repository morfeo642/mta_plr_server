--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        dxGetter.lua
*  PURPOSE:     All shared getter functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]


--[[!
	@param dxElement Es el componente
	@param relative Un valor booleano indicando si la posición que se devuelve es relativa al elemento padre.
	@return Devuelve la posición de un componente de interfaz 
]]
function dxGetPosition(dxElement,relative)
	checkDXElement("dxGetPosition", 1, dxElement);
	checkoptionalargs("dxGetPosition", 2, "boolean", relative);
	
	local x,y = getElementData(dxElement,"x"),getElementData(dxElement,"y")
	local tx,ty = getElementData(dxElement,"Title:x"),getElementData(dxElement,"Title:y")
	local px,py = getElementData(getElementParent(dxElement),"width"),getElementData(getElementParent(dxElement),"height")
	if tx and ty then
		if relative then
			return x/px,y/py,tx/px,ty/py
		else
			return x,y,tx,ty
		end
	else
		if relative then
			return x/px,y/py
		else
			return x,y
		end
	end
end


--[[!
	@param dxElement Es el componente
	@param relative Un valor booleano indicando si las dimensiones que se devuelven son relativas al elemento padre.
	@return Devuelve las dimensiones de un componente de interfaz
]]
function dxGetSize(dxElement,relative)
	checkDXElement("dxGetSize", 1, dxElement);
	checkoptionalargs("dxGetSize", 2, "boolean", relative);
	
	local w,h = getElementData(dxElement,"width"),getElementData(dxElement,"height")
	local px,py = getElementData(getElementParent(dxElement),"width"),getElementData(getElementParent(dxElement),"height")
	if relative then
		return w/px,h/py
	else
		return w,h
	end
end

--[[!
	@return Devuelve un valor booleano indicando la visibilidad de un componente de interfaz
]]
function dxGetVisible(dxElement)
	checkDXElement("dxGetVisible", 1, dxElement);
	
	return getElementData(dxElement,"visible")
end

--[[!
	@return Devuelve el estilo de un componente de interfaz
]]
function dxGetElementTheme(dxElement)
	checkDXElement("dxGetElementTheme", 1, dxElement);
	
	return getElementData(dxElement,"theme")
end

--[[!
	@return Devuelve la fuente usada por un componente de interfaz
]]
function dxGetFont(dxElement)
	checkDXElement("dxGetFont", 1, dxElement);
	
	return getElementData(dxElement,"font")
end

--[[!
	@return Devuelve el color usado por un componente de interfaz
]]
function dxGetColor(dxElement)
	checkDXElement("dxGetColor", 1, dxElement);
	
	local hex = tostring(toHex(getElementData(dxElement,"color")))
	hex = hex:gsub("(..)(......)","%2%1")
	local r,g,b,a = getColorFromString("#"..hex)
	return r,g,b,a
end

--[[!
	@return Devuelve un valor booleano indicando si bién un componente de interfaz
	usa códigos de colores.
]]
function dxGetColorCoded(dxElement)
	checkDXElement("dxGetColorCoded", 1, dxElement);
	
	return getElementData(dxElement,"colorcoded")
end

--[[!
	@return Devuelve el texto de un componente de interfaz
]]
function dxGetText(dxElement)
	checkDXElement("dxGetText", 1, dxElement);
	
	return getElementData(dxElement,"text")
end

--[[!
	@return Devuelve la componente alpha del color de un componente de interfaz
]]
function dxGetAlpha(dxElement)
	checkDXElement("dxGetAlpha", 1, dxElement);
	
	local hex = tostring(toHex(getElementData(dxElement,"color")))
	hex = hex:gsub("(..)(......)","%2%1")
	local r,g,b,a = getColorFromString("#"..hex)
	return a*255;
end

--[[!
	 @return Devuelve un valor booleano que indica si el componente de interfaz dx se 
	 dibuja después de haber dibujado la interfaz estandar de MTA.
]]
function dxGetAlwaysOnTop(dxElement)
	checkDXElement("dxGetAlwaysOnTop", 1, dxElement);
	
	local postgui = getElementData(dxElement,"postGUI")
	if (postgui == nil) then return false end
	return postgui
end


function dxGetZOrder(dxElement)
	checkDXElement("dxGetZOrder", 1, dxElement);
	
	local zOrder = getElementData(dxElement,"ZOrder")
	return zOrder
end

--[[!
	@return Devuelve un valor booleano indicando si la variable hace referencia a un
	componente de interfaz DX.
]]
function dxIsElement(var)
	if not isElement(var) then 
		return false;
	end;
	while getElementParent(var) and (getElementType(var) ~= "dxRootPane") do 
		var = getElementParent(var);
	end;
	return getElementType(var) == "dxRootPane";
end; 
