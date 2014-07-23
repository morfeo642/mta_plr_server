--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxLabel.lua
*  PURPOSE:     All label functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea una nueva etiqueta de texto.
	@param x Es la coordenada x (absoluta o relativa)
	@param y Es la coordenada y (absoluta o relativa)
	@param width Es la anchura de la etiqueta
	@param height Es la altura de la etiqueta
	@param text Es el texto que contendrá la etiqueta
	@param relative Infica si la posición y el tamaño de la etiqueta es relativa al pariente o no.
	@param parent Es el padre de la etiqueta, por defecto, dxGetRootPane()
	@param color Es el color de la etiqueta, por defecto, white
	@param font Es la fuente usada para dibujar el texto, por defecto, "default"
	@param scale Es la escala del texto. 
	@param alignX Indica el tipo de alineación sobre el eje X del texto (left, right o center), por defecto left
	@param alignY Indica el tipo de alineación sobre el eje Y del text (top, center, bottom), por defecto top
	@param colorCoded Indica si bién se usa códigos de colores dentro del texto de la etiqueta.
]]
function dxCreateLabel(x,y,width,height,text, relative, parent,color,font,scale,alignX,alignY,colorCoded)
	-- check arguments.
	checkargs("dxCreateLabel", 1, "number", x, "number", y, "number", width, "number", height, "string", text, "boolean", relative);
	checkoptionalargs("dxCreateLabel", 8, "number", color, "string", font, "number", scale, "string", alignX, "string", alignY, "boolean", colorCoded);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not color then
		color = tocolor(255,255,255,255)
	end
	
	if not font then
		font = "default"
	end
	
	if not colorCoded then
		colorCoded = false
	end
	
	if not scale then
		scale = 1
	end
	
	if not alignX then
		alignX = "left"
	else
		checkvalue("horizontal alignment", alignX, "left", "center", "right");
	end;
	
	if not alignY then
		alignY = "top"
	else 
		checkValue("vertical alignment", alignY, "top", "center", "bottom");
	end;
	
	local label = createElement("dxLabel")
	setElementParent(label,parent)
	setElementData(label,"resource",sourceResource)
	setElementData(label,"x",x)
	setElementData(label,"y",y)
	setElementData(label,"width",width)
	setElementData(label,"height",height)
	setElementData(label,"text",text)
	setElementData(label,"visible",true)
	setElementData(label,"colorcoded",colorCoded)
	setElementData(label,"hover",false)
	setElementData(label,"scale",scale)
	setElementData(label,"font",font)
	setElementData(label,"alignX",alignX)
	setElementData(label,"alignY",alignY)
	setElementData(label,"parent",parent)
	setElementData(label,"container",false)
	setElementData(label,"postGUI",false)
	setElementData(label,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	return label
end
-- // Functions
--[[!
@return Devuelve la escala del texto de la etiqueta.
]]
function dxLabelGetScale(dxElement) 
	checkargs("dxLabelGetScale", 1, "dxLabel", dxElement);

	return getElementData(dxElement,"scale")
end


--[[!
@return Devuelve la alineación horizontal (sobre el eje X) del texto de la etiqueta.
]]
function dxLabelGetHorizontalAlign(dxElement) 
	checkargs("dxLabelGetHorizontalAlign", 1, "dxLabel", dxElement);

	return getElementData(dxElement,"alignX")
end

--[[!
@return Devuelve la alineación vertical (sobre el eje Y) del texto de la etiqueta.
]]
function dxLabelGetVerticalAlign(dxElement) 
	checkargs("dxLabelGetVerticalAlign", 1, "dxLabel", dxElement);

	return getElementData(dxElement,"alignY")
end

--[[!
Establece la escala del texto de la etiqueta
@param dxElement Es la etiqueta de texto
@param scale Es la nueva escala.
]]
function dxLabelSetScale(dxElement,scale) 
	checkargs("dxLabelSetScale", 1, "dxLabel", dxElement, "number", scale);

	setElementData(dxElement,"scale",scale)
	triggerEvent("onClientDXPropertyChanged",dxElement,"scale",scale)
end


--[[!
Establece la alineación horizontal
@param dxElement la etiqueta de text
@param La alineación horizontal (left, right, center)
]]
function dxLabelSetHorizontalAlign(dxElement,alignX) 
	checkargs("dxLabelSetHorizontalAlign", 1, "dxLabel", dxElement, "number", alignX);
	checkvalue("horizontal alignment", alignX, "left", "center", "right");
	
	setElementData(dxElement,"alignX",alignX)
	triggerEvent("onClientDXPropertyChanged",dxElement,"alignX",alignX)
end

--[[!
	Establece la alineación vertical del texto de una etiqueta
	@param dxElement Es la etiqueta
	@param alignY Es la nueva alineación vertical del texto de la misma (top, center o bottom)
]]
function dxLabelSetVerticalAlign(dxElement,alignY) 
	checkargs("dxLabelSetVerticalAlign", 1, "dxLabel", dxElement, "number", alignY);
	checkvalue("vertical alignment", alignY, "top", "center", "bottom");
	
	setElementData(dxElement,"alignY",alignY)
	triggerEvent("onClientDXPropertyChanged",dxElement,"alignY",alignY)
end

-- // Render
function dxLabelRender(component,cpx,cpy,cpg)
	if not cpx then cpx = 0 end
	if not cpy then cpy = 0 end
	-- // Initializing
	local cTheme = dxGetElementTheme(component)
			or dxGetElementTheme(getElementParent(component))
	
	local cx,cy = dxGetPosition(component)
	local cw,ch = dxGetSize(component)
	
	local color = getElementData(component,"color")
	local font = dxGetFont(component)
	
	if not font then
		font = "default"
	end
	
	if not color then
		color = tocolor(255,255,255,255)
	end
	local title,font = dxGetText(component),dxGetFont(component)
	local tx = cx
	local th = ch					
	local textX = cpx+cx
	local textY = cpy+cy
	local tw = getElementData(getElementParent(component),"width")-(textX-getElementData(getElementParent(component),"x"))
	local scale = dxLabelGetScale(component)
	local textWidth = dxGetTextWidth(title,scale,font)
	if (dxGetColorCoded(component)) then
		textWidth = dxGetTextWidth(title:gsub("#%x%x%x%x%x%x",""),scale,font)
	else
		textWidth = dxGetTextWidth(title,scale,font)
	end
	if textWidth > tw then
		while textWidth>tw do
			title = title:sub(1,title:len()-1)
			if (dxGetColorCoded(component)) then
				textWidth = dxGetTextWidth(title:gsub("#%x%x%x%x%x%x",""),scale,font)
			else
				textWidth = dxGetTextWidth(title,scale,font)
			end
		end
	end
	local alignX,alignY = dxLabelGetHorizontalAlign(component),
		dxLabelGetVerticalAlign(component)
	
	if (dxGetColorCoded(component)) then
		dxDrawColorText(title,textX,textY,textX+textWidth,textY+ch,color,scale,font,alignX,alignY,true,true,cpg)
	else
		dxDrawText(title,textX,textY,textX+textWidth,textY+ch,color,scale,font,alignX,alignY,true,true,cpg)
	end
end
