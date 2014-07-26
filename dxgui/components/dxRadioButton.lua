--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxButton.lua
*  PURPOSE:     All radiobutton functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea un radio button.
	@param x La coordenada x (relativa o absoluta)
	@param y La coordenada y (relativa o absoluta)
	@param width La anchura del radio button
	@param height La altura del radio button
	@param text El texto que contendrá el radio button
	@param relative Indica si la posición y el tamaño del radio button es relativo al pariente o no.
	@param parent Es el pariente, por defecto dxGetRootPane()
	@param selected Indica si por defecto el radio button esta seleccionado, por defecto false
	@param groupName Es el nombre del grupo al que pertence este radio button, por defecto, "default"
	@param color Es el color del radio button, por defecto white
	@param font Es la fuente usada para dibujar el texto, por defecto "default"
	@param theme Es el estilo, que por defecto es dxGetDefaultTheme()
	
	@note Solo puede haber unicamente un radio button seleccionado entre todos los radio buttons que tengan un padre
	común (que pertenezcan a la misma ventana), y que pertenezcan al mismo grupo. La selección de uno implica que el 
	radio button que estaba previamente seleccionado, se desactive.
]]
function dxCreateRadioButton(x,y,width,height,text, relative, parent,selected,groupName,color,font,theme)
	-- check arguments
	checkargs("dxCreateRadioButton", 1, "number", x, "number", y, "number", width, "number", height, "string", text, "boolean", relative);
	-- check optional arguments.
	checkoptionalcontainer("dxCreateRadioButton", 7, parent);
	checkoptionalargs("dxCreateRadioButton", 8, "boolean", selected, "string", groupName, "number", color, "string", font, {"string", "dxTheme"}, theme);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);
	
	if not groupName then
		groupName="default"
	end
	
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
	
	if not theme then
		outputDebugString("dxCreateCheckBox didn't find the main theme.")
		return false
	end
	
	local radioButton = createElement("dxRadioButton")
	setElementParent(radioButton,parent)
	setElementData(radioButton,"resource",sourceResource)
	setElementData(radioButton,"x",x)
	setElementData(radioButton,"y",y)
	setElementData(radioButton,"width",width)
	setElementData(radioButton,"height",height)
	setElementData(radioButton,"text",text)
	setElementData(radioButton,"visible",true)
	setElementData(radioButton,"colorcoded",false)
	setElementData(radioButton,"hover",false)
	setElementData(radioButton,"group",groupName)
	setElementData(radioButton,"font",font)
	setElementData(radioButton,"theme",theme)	
	setElementData(radioButton,"parent",parent)
	setElementData(radioButton,"container",false)
	setElementData(radioButton,"postGUI",false)
	setElementData(radioButton,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	dxRadioButtonSetSelected(radioButton,selected)
	return radioButton
end

-- // Functions
--[[!
	@return Devuelve el grupo al que pertenece un radio button.
]]
function dxRadioButtonGetGroup(dxElement)
	checkargs("dxRadioButtonGetGroup", 1, "dxRadioButton", dxElement);
	
	return getElementData(dxElement,"group")
end


--[[!
	Establece el grupo al que pertenece un radio button.
	@param dxElement Es el radio button
	@param groupName Es el grupo.
]]
function dxRadioButtonSetGroup(dxElement,groupName)
	checkargs("dxRadioButtonSetGroup", 1, "dxRadioButton", dxElement, "string", groupName);
	
	setElementData(dxElement,"group",groupName)
	triggerEvent("onClientDXPropertyChanged",dxElement,"group",group)
end

--[[!
	@return Devuelve un valor booleano indicando si el radio
	button está seleccionado o no.
]]	
function dxRadioButtonGetSelected(dxElement)
	checkargs("dxRadioButtonGetSelected", 1, "dxRadioButton", dxElement);
	
	return getElementData(dxElement,"selected")
end

--[[!
	Selecciona un radio button.
	@note El radio button que previamente estaba seleccionado y que pertencía al mismo
	grupo que al que pertenece este radio button, es deseleccionado (si es que selected es true)
]]
function dxRadioButtonSetSelected(dxElement,selected)
	checkargs("dxRadioButtonSetSelected", 1, "dxRadioButton", dxElement, "boolean", selected);

	if selected then
		for _,element in ipairs(getElementChildren(getElementParent(dxElement))) do
			if (getElementType(element)=="dxRadioButton" and dxRadioButtonGetGroup(element) == dxRadioButtonGetGroup(dxElement)) then
				setElementData(element,"selected",false)
			end
		end
	end
	setElementData(dxElement,"selected",selected)
	triggerEvent("onClientDXPropertyChanged",dxElement,"selected",selected)
end

-- // Events
addEventHandler("onClientDXClick",getRootElement(),
	function(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
		if (button=="left" and state=="up") and (source and getElementType(source) == "dxRadioButton") then
			triggerEvent("onClientDXChanged",source,getElementData(source,"group"))
			if not wasEventCancelled() then
				dxRadioButtonSetSelected(source,true)
			end
		end
	end)

-- // Render
function dxRadioButtonRender(component,cpx,cpy,cpg, alphaFactor)
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
	
	local checked = dxRadioButtonGetSelected(component)
	local imageset  = "RadioButtonNormal"
	if not checked then
		if (getElementData(component,"hover")) then
			imageset = "RadioButtonHover"
		else
			imageset = "RadioButtonNormal"
		end
	else
		if (getElementData(component,"hover")) then
			imageset = "RadioButtonMarkHover"
		else
			imageset = "RadioButtonMark"
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