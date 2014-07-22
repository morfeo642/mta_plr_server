--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxButton.lua
*  PURPOSE:     All spinner functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea un spinner (Una caja con un valor numérico que puede ser incrementado o reducido con dos botones hacia 
	arriba y hacia abajo)
	@param x Es la coordenada x (absoluta o relativa)
	@param y Es la coordenada y (absoluta o relativa)
	@param width Es la anchura del spinner.
	@param height Es la altura del spinner
	@param relative Indica si las posición del spinner y su tamaño, es relativa en función de su pariente o no.
	@param parent Indica el pariente, por defecto: dxGetRootPane()
	@param color El color del spinner, por defecto: white
	@param defaultPos Es el valor inicial del spinner, por defecto 0
	@param min Es el valor minimo del spinner, por defecto 0 
	@param max Es el valor máximo del spinner. por defecto 0
	@param theme Es el estilo del spinner, por defecto dxGetDefaultTheme()
]]
function dxCreateSpinner(x,y,width,height, relative, parent,color,defaultPos,min_,max_,theme)
	-- check arguments.
	checkargs("dxCreateSpinner", 1, "number",x, "number",y, "number", width, "number", height, "boolean", relative);
	-- check optional arguments.
	checkoptionalargs("dxCreateSpinner", 7, "number", defaultPos, "number", min_, "number", max_, {"string", "dxTheme"}, theme);
	
	if relative then 
		local px, py = relativeToAbsolute(x + width, y + height);
		x, y = relativeToAbsolute(x, y);
		width, height =  px - x, py - y;
	end;
	
	
	if not color then
		color = tocolor(0,0,0,255)
	end
	
	if not font then
		font = "default"
	end
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not defaultPos then
		defaultPos = 0
	end
	
	if not min_ then
		min_ = 0
	end
	
	if not max_ then
		max_ = 100
	end
	
	if not theme then
		theme = dxGetDefaultTheme()
	end
	
	if type(theme) == "string" then
		theme = dxGetTheme(theme)
	end
	
	assert(theme, "dxCreateSpinner didn'find the main theme");

	local spinner = createElement("dxSpinner")
	setElementParent(spinner,parent)
	setElementData(spinner,"resource",sourceResource)
	setElementData(spinner,"x",x)
	setElementData(spinner,"y",y)
	setElementData(spinner,"width",width)
	setElementData(spinner,"height",height)
	setElementData(spinner,"max",max_)
	setElementData(spinner,"position",defaultPos)
	setElementData(spinner,"min",min_)
	setElementData(spinner,"theme",theme)
	setElementData(spinner,"color",color)
	setElementData(spinner,"font",font)
	setElementData(spinner,"visible",true)
	setElementData(spinner,"hover",false)
	setElementData(spinner,"parent",parent)
	setElementData(spinner,"container",false)
	setElementData(spinner,"postGUI",false)
	setElementData(spinner,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	return spinner
end
-- // Functions
--[[!
	@return Devuelve el valor actual del spinner
]]
function dxSpinnerGetPosition(dxElement)
	-- check arguments
	 checkargs("dxSpinnerGetPosition", 1, "dxSpinner", dxElement);
	
	return getElementData(dxElement,"position")
end

--[[!
	 Establece el valor actual del spinner.
	 @param dxElement El spinner
	 @param pos El nuevo valor del spinner.
	 @return Devuelve un valor booleano indicando si el valor se estableció correctamente.
	 (si el valor está entre el valor mínimo y el valor máximo permitidos.)
]]
function dxSpinnerSetPosition(dxElement,pos)
	-- check args.
	checkargs("dxSpinnerSetPosition", 1, "dxSpinner", dxElement, "number", pos);
	
	if (pos <= getElementData(dxElement,"max") and pos >= getElementData(dxElement,"min")) then
		setElementData(dxElement,"position",pos)
		triggerEvent("onClientDXSpin",dxElement,pos)
		return true
	end
	return false
end

--[[!
	@return Devuelve el valor máximo de un spinner
]]
function dxSpinnerGetMax(dxElement)
	checkargs("dxSpinnerGetMax", 1, "dxSpinner", dxElement);
	return getElementData(dxElement,"max")
end

--[[!
	Establece el valor máximo de un spinner.
	@note Si el valor actual del spinner es mayor que el nuevo valor máximo,
	se establecerá el valor actual al nuevo máximo.
]]
function dxSpinnerSetMax(dxElement,max_)
	-- check arguments.
	checkargs("dxSpinnerSetMax", 1, "dxSpinner", dxElement, "number", max_);
	
	setElementData(dxElement,"max",max_)
	if ( dxSpinnerGetPosition(dxElement) > max_ ) then
		dxSpinnerSetPosition(dxElement,max_)
	end
	return true
end

--[[!
	@return Devuelve el valor mínimo permitido en un spinner.
]]
function dxSpinnerGetMin(dxElement)
	-- check arguments.
	checkargs("dxSpinnerGetMin", 1, "dxSpinner", dxElement);
	
	return getElementData(dxElement,"min")
end

--[[!
	Establece el valor mínimo permitido en un spinner.
	@note Si el nuevo valor mínimo es mayor que el valor actual, el valor
	se establecerá a este nuevo mínimo.
]]
function dxSpinnerSetMin(dxElement,min_)
	checkargs("dxSpinnerSetMin", 1, "dxSpinner", dxElement, "number", min_);	

	setElementData(dxElement,"min",min_)
	if ( dxSpinnerGetPosition(dxElement) < min_ ) then
		dxSpinnerSetPosition(dxElement,min_)
	end
	return true
end

function dxSpinnerRefresh(element)
	if (getElementData(element,"clicked")) then
		if (getElementData(element,"increasing")) then
			dxSpinnerSetPosition(element,dxSpinnerGetPosition(element)+1)
			setElementData(element,"increasing",false)
			setElementData(element,"increasing",false)
			setElementData(element,"increaseRender",true)
			incControl = function(elm)
				if (getElementData(elm,"increaseRender")) then
					setElementData(elm,"increasing",true)
				end
			end
			setTimer(incControl,100,1,element)
		end
		
		if (getElementData(element,"reducing")) then
			dxSpinnerSetPosition(element,dxSpinnerGetPosition(element)-1)
			setElementData(element,"reducing",false)
			setElementData(element,"reduceRender",true)
			reduceControl = function(elm)
				if (getElementData(elm,"reduceRender")) then
					setElementData(elm,"reducing",true)
				end
			end
			setTimer(reduceControl,100,1,element)
		end
	end
end

function dxSpinnersRefresh()
	for _,element in ipairs(getElementsByType("dxSpinner")) do
		dxSpinnerRefresh(element)
	end
end

-- // Events
addEventHandler("onClientDXClick",getRootElement(),function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedWorld)
	local spinner = source
	if (button == "left" and state=="down") then
		setElementData(spinner,"clicked",false)
		setElementData(spinner,"increasing",false)
		setElementData(spinner,"increaseRender",false)
		setElementData(spinner,"reducing",false)
		setElementData(spinner,"reduceRender",false)
			
		local x,y = dxGetPosition(spinner)
		local parent = getElementParent(spinner)
		local px,py = getElementData(parent,"x"),getElementData(parent,"y")
		local rx,ry = px+x,py+y
		local w,h = dxGetSize(spinner)
		local cTheme = dxGetElementTheme(spinner)
		local optWidth = getElementData(cTheme,"SpinnerIncBackground:Width")	
		if (intersect(rx,ry,rx+w,ry+h,absoluteX,absoluteY)) then
			setElementData(spinner,"clicked",true)
		end
		
		if (intersect(rx+w-optWidth,ry,rx+w,ry+(h/2),absoluteX,absoluteY)) then
			setElementData(spinner,"increasing",true)
		end
		
		if (intersect(rx+w-optWidth,ry+(h/2),rx+w,ry+h,absoluteX,absoluteY)) then
			setElementData(spinner,"reducing",true)
		end
	end
end)

addEventHandler("onClientClick",getRootElement(),function(button,state,absoluteX,absoluteY,worldX,worldY,worldZ,clickedWorld)
	if (button=="left" and state=="up") then
		for _,spinner in ipairs(getElementsByType("dxSpinner")) do
			setElementData(spinner,"increasing",false)
			setElementData(spinner,"increaseRender",false)
			setElementData(spinner,"reducing",false)
			setElementData(spinner,"reduceRender",false)
		end
	end
end)

-- // Render

function dxSpinnerRender(component,cpx,cpy,cpg)
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
	local cpxx = cpx+cx
	local cpyy = cpy+cy
	local optWidth = getElementData(cTheme,"SpinnerIncBackground:Width")	
	
	dxDrawImageSection(cpxx,cpyy,cw-optWidth,ch,
		getElementData(cTheme,"SpinnerBackground:X"),getElementData(cTheme,"SpinnerBackground:Y"),
		getElementData(cTheme,"SpinnerBackground:Width"),getElementData(cTheme,"SpinnerBackground:Height"),
		getElementData(cTheme,"SpinnerBackground:images"),0,0,0,tocolor(255,255,255), cpg)
		
	dxDrawImageSection(cpxx+cw-optWidth,cpyy,optWidth,ch,
		getElementData(cTheme,"SpinnerIncBackground:X"),getElementData(cTheme,"SpinnerIncBackground:Y"),
		getElementData(cTheme,"SpinnerIncBackground:Width"),getElementData(cTheme,"SpinnerIncBackground:Height"),
		getElementData(cTheme,"SpinnerIncBackground:images"),0,0,0,tocolor(255,255,255), cpg)
	local str = tostring(dxSpinnerGetPosition(component))
	if ( dxSpinnerGetPosition(component) == dxSpinnerGetMin(component) ) then
		str = "#FF0000"..str
	elseif ( dxSpinnerGetPosition(component) == dxSpinnerGetMax(component) ) then
		str = "#FF0000"..str
	end
	dxDrawColorText(tostring(str),cpxx,cpyy,cpxx+(cw-optWidth),cpyy+ch,color,1,font,"right","center",true,false,cpg)
end
