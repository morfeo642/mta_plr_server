--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        dxSetter.lua
*  PURPOSE:     All shared setter functions
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
--[[!
	Establece la posición de un componente de interfaz
	@param dxElement Es un componente de interfaz
	@param x Es la componente x de la nueva posición del componente
	@param y Es la componente y de la nueva posición del componente
	@param relative Es un valor booleano que indica si la nueva posición es relativa al elemento padre del componente
	@param setTitle Es un valor booleano que indica si el título también cambiara de posición.
]]
function dxSetPosition(dxElement,x,y,relative,setTitle)
	checkDXElement("dxSetPosition", 1, dxElement);
	checkargs("dxSetPosition", 2, "number", x, "number", y);
	checkoptionalargs("dxSetPosition", 4, "boolean", relative, "boolean", setTitle);
	
	if relative == nil then
		relative = false
	end
	if setTitle == nil then
		setTitle = true
	end
	local dxType = getElementType(dxElement)
	local px,py = getElementData(getElementParent(dxElement),"width"),getElementData(getElementParent(dxElement),"height")
	if (dxType == "dxWindow") and (setTitle) then
		if relative then
			setElementData(dxElement,"x",x*px)
			setElementData(dxElement,"y",y*py)
			setElementData(dxElement,"Title:x",x*px)
			setElementData(dxElement,"Title:y",y*py)
		else
			setElementData(dxElement,"x",x)
			setElementData(dxElement,"y",y)
			setElementData(dxElement,"Title:x",x)
			setElementData(dxElement,"Title:y",y)
		end
		triggerEvent("onClientDXPropertyChanged",dxElement,"position",x,y,relative,px,py)
	else
		if relative then
			setElementData(dxElement,"x",x*px)
			setElementData(dxElement,"y",y*py)
		else
			setElementData(dxElement,"x",x)
			setElementData(dxElement,"y",y)
		end
		triggerEvent("onClientDXPropertyChanged",dxElement,"position",x,y,relative)
	end
end

--[[!
	Establece las dimensiones de un componente de interfaz
	@param dxElement Es el componente
	@param width Es la nueva anchura del componente
	@param height Es la nueva altura del componente
	@param relative Es un valor booleano indicando si las nuevas dimensiones son relativas al elemento
	padre del componente.
]]
function dxSetSize(dxElement,w,h,relative)
	checkDXElement("dxGetSize", 1, dxElement);
	checkargs("dxGetSize", 2, "number", w, "number", h);
	checkoptionalargs("dxGetSize", 4, "boolean", relative);
	
	local px,py = getElementData(getElementParent(dxElement),"width"),getElementData(getElementParent(dxElement),"height")
	if relative then
		setElementData(dxElement,"width",w*px)
		setElementData(dxElement,"height",h*py)
	else
		setElementData(dxElement,"width",w)
		setElementData(dxElement,"height",h)
	end
	triggerEvent("onClientDXPropertyChanged",dxElement,"size",w,h,relative)
end

--[[!
	Establece la visibilidad de un componente de interfaz
	@param dxElement Es el componente
	@param visible Es un valor booleano indicando si el componente es visible o no.
]]
function dxSetVisible(dxElement,visible)
	checkDXElement("dxSetVisible", 1, dxElement);
	checkargs("dxSetVisible", 2, "boolean", visible);

	setElementData(dxElement,"visible",visible)
	triggerEvent("onClientDXPropertyChanged",dxElement,"visible",visible)
end

--[[!
	Establece el estilo de un componente de interfaz.
	@param dxElement Es el componente
	@param theme Es el nuevo estilo.
	@param propagate Es un valor booleano que indica si también los elementos que son hijos también deben cambiar a este estilo. (Por defecto false)
]]
function dxSetElementTheme(dxElement, theme, propagate)
	checkDXElement("dxSetElementTheme", 1, dxElement);
	checkargs("dxSetElementTheme", 2, {"dxTheme", "string"}, theme);
	checkoptionalargs("dxSetElementTheme", 3, "boolean", propagate);
	
	if type(theme) == "string" then 
		theme = assert(dxGetTheme(theme), "dxSetElementTheme couldn´t find the main theme");
	end;
	
	setElementData(dxElement,"theme",theme)
	triggerEvent("onClientDXPropertyChanged",dxElement,"theme",theme)
	
	if propagate then
		for _, child in ipairs(getElementChildren(dxElement)) do 
			dxSetElementTheme(child, theme, true);
		end;
	end; 
end

--[[!
	Establece la fuente de un componente de interfaz
	@param dxElement Es el componente
	@param font Es la nueva fuente que usará el componente.
]]
function dxSetFont(dxElement,font)
	checkDXElement("dxSetFont", 1, dxElement);
	checkargs("dxSetFont", 2, "string", font);

	setElementData(dxElement,"font",font)
	triggerEvent("onClientDXPropertyChanged",dxElement,"font",font)
end

--[[!
	Establece el color de un componente de interfaz
	@param dxElement Es el componente
	@param color Es el nuevo color del componente
]]
function dxSetColor(dxElement,color)
	checkDXElement("dxSetColor", 1, dxElement);
	checkargs("dxSetColor", 2, "number", color);
	
	setElementData(dxElement,"color",color)
	triggerEvent("onClientDXPropertyChanged",dxElement,"color",color)
end

--[[!
	Indica si un componente de interfaz usará códigos de colores
	@param dxElement Es el componente
	@param colorcoded Es un valor booleano indicando si el componente usará códigos
	de colores.
]]
function dxSetColorCoded(dxElement,colorcoded)
	checkDXElement("dxSetColorCoded", 1, dxElement);
	checkargs("dxSetColorCoded", 2, "boolean", colorcoded);

	setElementData(dxElement,"colorcoded",colorcoded)
	triggerEvent("onClientDXPropertyChanged",dxElement,"colorcoded",colorcoded)
end

--[[!
	Establece el texto de un componente.
	@param dxElement Es el componente
	@param text Es el nuevo texto que tendrá el componente.
]]	
function dxSetText(dxElement,text)
	checkDXElement("dxSetText", 1, dxElement);
	checkargs("dxSetText", 2, "string", text);

	setElementData(dxElement,"text",text)
	triggerEvent("onClientDXPropertyChanged",dxElement,"text",text)
end

--[[!
	Establece la compnente alpha del color de un componente de interfaz
	@param dxElement El componente
	@param alpha El nuevo valor del componente alpha de su color.
]]
function dxSetAlpha(dxElement,alpha)
	checkDXElement("dxSetAlpha", 1, dxElement);
	checkargs("dxSetAlpha", 2, "number", alpha);

	local hex = tostring(toHex(getElementData(dxElement,"color")))
	hex = hex:gsub("(..)(......)","%2%1")
	local r,g,b,a = getColorFromString("#"..hex)
	setElementData(dxElement,"color",tocolor(r,g,b,alpha))
	triggerEvent("onClientDXPropertyChanged",dxElement,"alpha",alpha)
end

--[[!
	Indica si un componente debe dibujarse después de que se dibuje la interfaz de usuario
	MTA o antes.
]]
function dxSetAlwaysOnTop(dxElement,postGUI)
	checkDXElement("dxSetAlwaysOnTop", 1, dxElement);
	checkargs("dxSetAlwaysOnTop", 2, "boolean", postGUI);

	setElementData(dxElement,"postGUI",postGUI)
end

function dxSetZOrder(dxElement,ZOrder)
	checkDXElement("dxSetZOrder", 1, dxElement);
	checkargs("dxSetZOrder", 2, "number", ZOrder);

	setElementData(dxElement,"ZOrder",ZOrder)
end

function dxBringToFront(dxElement)
	checkDXElement("dxBringToFront", 1, dxElement);

	local parentChilds = getElementChildren(getElementParent(dxElement))
	local bringOne = dxGetZOrder(dxElement)
	for _,w in ipairs(parentChilds) do
		if (bringOne < dxGetZOrder(w)) and (dxElement ~= w) then
			bringOne = dxGetZOrder(w)
		end
	end
	dxSetZOrder(dxElement,bringOne+1)
end

function dxMoveToBack(dxElement)
	checkDXElement("dxMoveToBack", 1, dxElement);

	local parentChilds = getElementChildren(getElementParent(dxElement))
	local bringOne = dxGetZOrder(dxElement)
	local willMove = {}
	for _,w in ipairs(parentChilds) do
		if (bringOne >= dxGetZOrder(w)) and (dxElement~=w) then
			table.insert(willMove,w)
		end
	end
	for _,w in ipairs(willMove) do
		dxSetZOrder(w,dxGetZOrder(w)+1)
	end
	dxSetZOrder(dxElement,0)
end