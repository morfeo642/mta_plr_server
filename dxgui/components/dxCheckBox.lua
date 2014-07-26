--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxCheckBox.lua
*  PURPOSE:     All checkbox functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea un check box.
	@param x Es la componente x de la posición del check box
	@param y Es la componente y de la posición del check box
	@param width Es la anchura del checkbox
	@param height Es la altura del checkbox
	@param text Es el texto que contendrá el checkbox
	@param relative Indica si la posición y las dimensiones son relativas al elemento padre
	@param Es el elemento padre, por defecto, dxGetRootPane()
	@param selected Es un valor booleano indicando si el checkbox esta marcado inicialmente.
	@param color Es el color, por defecto, white
	@param font Es la fuente de texto, por defecto, "default"
	@param theme Es el estilo, por defecto, dxGetDefaultTheme()
]]
function dxCreateCheckBox(x,y,width,height,text,relative,parent,selected,color,font,theme)
	checkargs("dxCreateCheckBox", 1, "number", x, "number", y, "number", width, "number", height, "string", text, "boolean", relative);
	checkoptionalcontaienr("dxCreateCheckBox", 7, parent);
	checkoptionalargs("dxCreateCheckBox", 8, "boolean", selected, "number", color, "string", font, {"string", "dxTheme"}, theme);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);
	
	if not selected then
		selected = false
	end
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not color then
		color = tocolor(255,255,255,255)
	end
	
	if not font then
		font = "default"
	end
	
	if not theme then
		theme = dxGetDefaultTheme()
	end
	
	if type(theme) == "string" then
		theme = dxGetTheme(theme)
	end
	
	assert(theme, "dxCreateCheckBox didn't find the main theme");
	
	local checkbox = createElement("dxCheckBox")
	setElementParent(checkbox,parent)
	setElementData(checkbox,"resource",sourceResource)
	setElementData(checkbox,"x",x)
	setElementData(checkbox,"y",y)
	setElementData(checkbox,"width",width)
	setElementData(checkbox,"height",height)
	setElementData(checkbox,"text",text)
	setElementData(checkbox,"visible",true)
	setElementData(checkbox,"colorcoded",false)
	setElementData(checkbox,"hover",false)
	setElementData(checkbox,"selected",selected)
	setElementData(checkbox,"font",font)
	setElementData(checkbox,"theme",theme)	
	setElementData(checkbox,"parent",parent)
	setElementData(checkbox,"container",false)
	setElementData(checkbox,"postGUI",false)
	setElementData(checkbox,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	return checkbox
end

-- // Functions
--[[!
	@return Devuelve un valor booleano indicando si el checkbox está seleccionado.
]]
function dxCheckBoxGetSelected(dxElement)
	checkargs("dxCheckBoxGetSelected", 1, "dxCheckBox", dxElement);

	return getElementData(dxElement,"selected")
end

--[[!
	Selecciona o deselecciona el check box
	@param dxElement Es el checkbox
	@param selected Un valor booleano que indica si el checkbox debe ser seleccionado.
]]
function dxCheckBoxSetSelected(dxElement,selected)
	checkargs("dxCheckBoxSetSelected", 1, "dxCheckBox", dxElement, "boolean", selected);

	setElementData(dxElement,"selected",selected)
	triggerEvent("onClientDXPropertyChanged",dxElement,"selected",selected)
end

-- // Events
addEventHandler("onClientDXClick",getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
		if (button=="left" and state=="up") and (source and getElementType(source) == "dxCheckBox") then
			local checked = not dxCheckBoxGetSelected(source)					
			triggerEvent("onClientDXChanged",source,checked)
			if not wasEventCancelled() then
				dxCheckBoxSetSelected(source,checked)
			end
		end
	end)

-- // Render
function dxCheckBoxRender(component,cpx,cpy,cpg, alphaFactor)
	if not cpx then cpx = 0 end
	if not cpy then cpy = 0 end
	-- // Initializing
	local cTheme = dxGetElementTheme(component)
			or dxGetElementTheme(getElementParent(component))
	
	local cx,cy = getElementData(component, "x"), getElementData(component, "y");
	local cw,ch = getElementData(component, "width"), getElementData(component, "height");
	
	local color = getElementData(component,"color")
	local font = getElementData(component, "font");
	
	-- Change alpha component based on parent´s alpha factor
	color = multiplyalpha(color, alphaFactor);
	
	local checked = dxCheckBoxGetSelected(component)
	local imageset  = "CheckboxNormal"
	if not checked then
		if (getElementData(component,"hover")) then
			imageset = "CheckboxHover"--
		else
			imageset = "CheckboxMark"
		end
	else
		if (getElementData(component,"hover")) then
			imageset = "CheckboxMarkHover" -- 
		else
			imageset = "CheckboxNormal" -- 
		end
	end
	
	dxDrawImageSection(cpx+cx,cpy+cy,cw,ch,
			getElementData(cTheme,imageset..":X"),getElementData(cTheme,imageset..":Y"),
			getElementData(cTheme,imageset..":Width"),getElementData(cTheme,imageset..":Height"),
			getElementData(cTheme,imageset..":images"),0,0,0,color,cpg)
	
	local title,font = dxGetText(component),dxGetFont(component)
		
	local tx = cx
	local th = ch					
	local textHeight = dxGetFontHeight(1,font)
	local textX = cpx+cx+cw+5
	local textY = cpy+cy+((th-textHeight)/2)
	if (dxGetColorCoded(component)) then
		dxDrawColorText(title,textX,textY,textX,textY,color,1,font,"left","top",false,false,cpg)
	else
		dxDrawText(title,textX,textY,textX,textY,color,1,font,"left","top",false,false,cpg)
	end
end