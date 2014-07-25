--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxProgressBar.lua
*  PURPOSE:     All progressbar functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initalizing
--[[!
	Crea una barra de progreso.
	@param x Es la coordenada x (absoluta o relativa)
	@param y Es la coordenada y (absoluta o relativa)
	@param width Es la anchura de la barra de progreso
	@param height Es la altura de la barra de progreso.
	@param relative Es un valor booleano indicando si bien la posición y el tamaño del mismo serán relativas al pariente
	@param parent Es el padre de esta barra de progreso, por defecto dxGetRootPane()
	@param progress Es el porcentaje de progresso de la barra. Este valor deberá ser un valor no negativo.
	@param color Es el color de la barra, por defeto, "white"
	@param max_ Es el máximo valor de progreso.
]]
function dxCreateProgressBar(x,y,width,height, relative, parent,progress,color,max_,theme)
	-- check arguments.
	checkargs("dxCreateProgressBar", 1, "number", x, "number", y, "number", width, "number", height, "boolean", relative);
	-- check optional arguments.
	checkoptionalargs("dxCreateProgressBar", 7, "number", progress, "number", color, "number", max_, {"string", "dxTheme"}, theme);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not progress then
		progress = 0
	end
	
	if not max_ then
		max_ = 100
	end
	
	assert(max_ >= 0, "Maximum progress bar value must be non negative");
	assert(progress >= 0, "Progress bar value must be non negative");
	
	if progress > max_ then
		progress = max_;
	end
	
	if not color then
		color = "segment"
	end
	
	if not theme then
		theme = dxGetDefaultTheme()
	end
	
	if type(theme) == "string" then
		theme = dxGetTheme(theme)
	end
	
	assert(theme, "dxCreateCheckBox didn't find the main theme");

	
	local progressBar = createElement("dxProgressBar")
	setElementParent(progressBar,parent)
	setElementData(progressBar,"resource",sourceResource)
	setElementData(progressBar,"x",x)
	setElementData(progressBar,"y",y)
	setElementData(progressBar,"width",width)
	setElementData(progressBar,"height",height)
	setElementData(progressBar,"progress",progress)
	setElementData(progressBar,"max",max_)
	setElementData(progressBar,"theme",theme)
	setElementData(progressBar,"visible",true)
	setElementData(progressBar,"progressColor",color)
	setElementData(progressBar,"hover",false)
	setElementData(progressBar,"parent",parent)
	setElementData(progressBar,"container",false)
	setElementData(progressBar,"postGUI",false)
	setElementData(progressBar,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	return progressBar
end
-- // Functions
--[[!
	@return Devuelve el valor del progreso de la barra actualmente.
]]
function dxProgressBarGetProgress(dxElement)
	checkargs("dxProgressBarGetProgress", 1, "dxProgressBar", dxElement);	

	return getElementData(dxElement,"progress")
end

--[[!
	Establece el progreso actual de la barra de progreso.
	@param dxElement es la barra de progreso
	@param progress Es el nuevo valor de progreso.
]]
function dxProgressBarSetProgress(dxElement,progress)
	checkargs("dxProgressBarSetProgress", 1, "dxProgressBar", dxElement, "number", progress);

	local max = getElementData(dxElement,"max")
	if type(progress)~="number" or progress < 0 or progress > max then
		outputDebugString("dxProgressBarSetProgress gets wrong parameters.(progress must be between 0-"..tostring(max))
		return
	end
	setElementData(dxElement,"progress",progress)
	triggerEvent("onClientDXPropertyChanged",dxElement,"progress",progress)
end

--[[!
	@return Devuelve el porcentaje de progreso de esta barra de progreso.
]]
function dxProgressBarGetProgressPercent(dxElement)
	checkargs("dxProgressBarGetProgressPercent", 1, "dxProgressBar", dxElement);	

	-- max progress
	-- 100 x
	return (100*getElementData(dxElement,"progress")) / getElementData(dxElement,"max")
end

--[[!
	Establece el porcentaje de progreso de esta barra de progreso.
	@param dxEelement Es la barra de progreso
	@param progress Es el porcentaje de progreso (debe ser un valor no negativo) e inferior o igua a 100.
]]
function dxProgressBarSetProgressPercent(dxElement,progress)
	checkargs("dxProgressBarSetProgressPercent", 1, "dxProgressBar", dxElement, "number", progress);
	assert((progress >= 0) and (progress <= 100), "progress percentage must be a non negative value and lower or equal than 100");
	
	-- 100 percent
	-- max x
	setElementData(dxElement,"progress",(getElementData(dxElement,"max")*progress)/100)
	triggerEvent("onClientDXPropertyChanged",dxElement,"progressPercent",progress,(getElementData(dxElement,"max")*progress)/100)
end

--[[!
	@return Devuelve el valor máximo de progreso de una barra de progreso.
]]
function dxProgressBarGetMaxProgress(dxElement)
	checkargs("dxProgressBarGetMaxProgress", 1, "dxProgressBar", dxElement);

	return getElementData(dxElement,"max")
end

--[[!
	Establece la valor máximo de progreso en una barra de progreso.
	@param dxElement Es la barra de progreso.
	@param progress Es el nuevo valor máximo de progreso de la barra de progreso.
]]
function dxProgressBarSetMaxProgress(dxElement,progress)
	checkargs("dxProgressBarSetMaxProgress", 1, "dxProgressBar", dxElement, "number", progress);

	setElementData(dxElement,"max",progress)
	triggerEvent("onClientDXPropertyChanged",dxElement,"maxProgress",progress)
	if (getElementData(dxElement,"progress") > progress ) then
		dxProgressBarSetProgress(dxElement,progress)
	end
end

-- // Render
function dxProgressBarRender(component,cpx,cpy,cpg, alphaFactor)
	if not cpx then cpx = 0 end
	if not cpy then cpy = 0 end
	-- // Initializing
	local cTheme = dxGetElementTheme(component)
			or dxGetElementTheme(getElementParent(component))
	
	local cx,cy = getElementData(component, "x"), getElementData(component, "y");
	local cw,ch = getElementData(component, "width"), getElementData(component, "height");
	
	local color = getElementData(component,"color")
	local font = getElementData(component, "font");
	
	-- Changes alpha component based on paent´s alpha factor
	color = multiplyalpha(color, alphaFactor);
	
	local cpxx = cpx+cx
	local cpyy = cpy+cy
	
	local leftw,rightw = getElementData(cTheme,"ProgressLeft:Width"),getElementData(cTheme,"ProgressRight:Width")
	local toplefth,botlefth = getElementData(cTheme,"ProgressTopLeft:Height"),getElementData(cTheme,"ProgressBottomLeft:Height")
	local toprigth,botrigth = getElementData(cTheme,"ProgressTopRight:Height"),getElementData(cTheme,"ProgressBottomRight:Height")
	local toph,both = getElementData(cTheme,"ProgressTop:Height"),getElementData(cTheme,"ProgressBottom:Height")
	
	dxDrawImageSection(cpxx,cpyy,getElementData(cTheme,"ProgressTopLeft:Width"),toplefth,
		getElementData(cTheme,"ProgressTopLeft:X"),getElementData(cTheme,"ProgressTopLeft:Y"),
		getElementData(cTheme,"ProgressTopLeft:Width"),getElementData(cTheme,"ProgressTopLeft:Height"),
		getElementData(cTheme,"ProgressTopLeft:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx,cpyy+toplefth,getElementData(cTheme,"ProgressLeft:Width"),ch-toplefth-botlefth,
		getElementData(cTheme,"ProgressLeft:X"),getElementData(cTheme,"ProgressLeft:Y"),
		getElementData(cTheme,"ProgressLeft:Width"),getElementData(cTheme,"ProgressLeft:Height"),
		getElementData(cTheme,"ProgressLeft:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx,cpyy+toplefth+(ch-toplefth-botlefth),getElementData(cTheme,"ProgressBottomLeft:Width"),botlefth,
		getElementData(cTheme,"ProgressBottomLeft:X"),getElementData(cTheme,"ProgressBottomLeft:Y"),
		getElementData(cTheme,"ProgressBottomLeft:Width"),getElementData(cTheme,"ProgressBottomLeft:Height"),
		getElementData(cTheme,"ProgressBottomLeft:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+getElementData(cTheme,"ProgressTopLeft:Width"),cpyy,cw-leftw-rightw,toph,
		getElementData(cTheme,"ProgressTop:X"),getElementData(cTheme,"ProgressTop:Y"),
		getElementData(cTheme,"ProgressTop:Width"),getElementData(cTheme,"ProgressTop:Height"),
		getElementData(cTheme,"ProgressTop:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+getElementData(cTheme,"ProgressTopLeft:Width"),cpyy+toplefth+(ch-toplefth-botlefth),cw-leftw-rightw,both,
		getElementData(cTheme,"ProgressBottom:X"),getElementData(cTheme,"ProgressBottom:Y"),
		getElementData(cTheme,"ProgressBottom:Width"),getElementData(cTheme,"ProgressBottom:Height"),
		getElementData(cTheme,"ProgressBottom:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+leftw+(cw-leftw-rightw),cpyy+toplefth+(ch-toplefth-botlefth),getElementData(cTheme,"ProgressBottomRight:Width"),botrigth,
		getElementData(cTheme,"ProgressBottomRight:X"),getElementData(cTheme,"ProgressBottomRight:Y"),
		getElementData(cTheme,"ProgressBottomRight:Width"),getElementData(cTheme,"ProgressBottomRight:Height"),
		getElementData(cTheme,"ProgressBottomRight:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+leftw+(cw-leftw-rightw),cpyy+toprigth,getElementData(cTheme,"ProgressRight:Width"),ch-toplefth-botlefth,
		getElementData(cTheme,"ProgressRight:X"),getElementData(cTheme,"ProgressRight:Y"),
		getElementData(cTheme,"ProgressRight:Width"),getElementData(cTheme,"ProgressRight:Height"),
		getElementData(cTheme,"ProgressRight:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+leftw+(cw-leftw-rightw),cpyy,getElementData(cTheme,"ProgressTopRight:Width"),toprigth,
		getElementData(cTheme,"ProgressTopRight:X"),getElementData(cTheme,"ProgressTopRight:Y"),
		getElementData(cTheme,"ProgressTopRight:Width"),getElementData(cTheme,"ProgressTopRight:Height"),
		getElementData(cTheme,"ProgressTopRight:images"),0,0,0,color,cpg)
	dxDrawImageSection(cpxx+leftw,cpyy+toplefth,cw-leftw-rightw,ch-toplefth-botlefth,
		getElementData(cTheme,"ProgressBackground:X"),getElementData(cTheme,"ProgressBackground:Y"),
		getElementData(cTheme,"ProgressBackground:Width"),getElementData(cTheme,"ProgressBackground:Height"),
		getElementData(cTheme,"ProgressBackground:images"),0,0,0,color,cpg)
	local prog = dxProgressBarGetProgress(component)
	local max = dxProgressBarGetMaxProgress(component)
	local width__ = cw-leftw-rightw
	-- max width__
	-- prog x
	local width_ = (prog*width__) / max
	local progressColor = getElementData(component,"progressColor")
	if type(progressColor) ~= "string" then
		dxDrawRectangle(cpxx+leftw,cpyy,width_,ch,progressColor,cpg)
	else
		dxDrawImageSection(cpxx+leftw,cpyy,width_,ch,
			getElementData(cTheme,"ProgressBarLitSegment:X"),getElementData(cTheme,"ProgressBarLitSegment:Y"),
			getElementData(cTheme,"ProgressBarLitSegment:Width"),getElementData(cTheme,"ProgressBarLitSegment:Height"),
			getElementData(cTheme,"ProgressBarLitSegment:images"),0,0,0,tocolor(255,255,255),cpg)
	end
end