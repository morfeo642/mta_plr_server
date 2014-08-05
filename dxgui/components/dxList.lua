--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxList.lua
*  PURPOSE:     All listbox functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea una lista (componente de interfaz de usuario)
	@param x Es la componente x de la posición de la lista (absoluto o relativo)
	@param y Es la componente y de la posición de la lista (absoluto o relativo)
	@param width Es la anchura de la lista
	@param height Es la altura de la lista
	@param title Es el titulo de la lista.
	@param relative Valor booleano indicando si bien la posición y el tamaño de la lista son relativas al pariente.
	@param parent Es el padre de esta lista, por defecto dxGetRootPane() 
	@param color Es el color de la lista, por defecto white
	@param font Es la fuente usada para renderizar texto, por defecto "default"
	@param theme Es el estilo, por defecto, dxGetDefaultTheme()
]]
function dxCreateList(x,y,width,height,title,relative,parent,color,font,theme)
	-- check arguments.
	checkargs("dxCreateList", 1, "number", x, "number", y, "number", width, "number", height, "string", title, "boolean", relative);
	checkoptionalcontainer("dxCreateList", 7, parent);
	checkoptionalargs("dxCreateList", 8, "number", color, "string", font, {"string", "dxTheme"}, theme);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);
	
	if not title then
		title = ""
	end
	
	if not color then
		color = tocolor(0,0,0,255)
	end
	
	if not font then
		font = "default"
	end
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not theme then
		theme = dxGetDefaultTheme()
	end
	
	if type(theme) == "string" then
		theme = dxGetTheme(theme)
	end
	
	assert(theme, "dxCreateList didn't find the main theme");
	
	local list = createElement("dxList")
	setElementParent(list, parent)
	setElementData(list,"resource",sourceResource)
	setElementData(list,"x",x)
	setElementData(list,"y",y)
	setElementData(list,"width",width)
	setElementData(list,"height",height)
	setElementData(list,"text",title)
	setElementData(list,"Title:show",true)
	setElementData(list,"theme",theme)
	setElementData(list,"color",color)
	setElementData(list,"font",font)
	setElementData(list,"visible",true)
	setElementData(list,"hover",false)
	setElementData(list,"parent",parent)
	setElementData(list,"container",false)
	setElementData(list,"scrollbarVert",false)
	setElementData(list,"scrollbarHorz",false)
	setElementData(list,"clicked",false)
	setElementData(list,"postGUI",false)
	setElementData(list,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	addEventHandler("onClientDXClick",list,__list,false)
	addEventHandler("onClientDXDoubleClick",list,list__,false)
	return list
end
-- // Functions
--[[!
Elimina todos los elementos de la lista
]]
function dxListClear(dxElement)
	-- check arguments.
	checkargs("dxListClear", 1, "dxList", dxElement);
	
	for _,v in ipairs(getElementChildren(dxElement)) do
		destroyElement(v)
	end
end

--[[!
@return Devuelve el número de elementos contenidos en la lista
]]
function dxListGetItemCount(dxElement)
	-- check arguments.
	checkargs("dxListClear", 1, "dxList", dxElement);

	return #getElementChildren(dxElement)
end

--[[!
@return Devuelve el item seleccionado de la lista.
]]
function dxListGetSelectedItem(dxElement) 
	-- check arguments
	checkargs("dxListGetSelectedItem", 1, "dxList", dxElement);

	return getElementData(dxElement,"selectedItem")
end

--[[!
Establece el item seleccionado de la lista
@param dxElement Es la lista
@param item Es el item que se selecciona.
]]
function dxListSetSelectedItem(dxElement,item)
	-- check arguments.
	checkargs("dxListSetSelectedItem", 1, "dxList", dxElement, "dxListItem", item);

	setElementData(dxElement,"selectedItem",item)
	for _,w in ipairs(getElementChildren(dxElement)) do
		setElementData(w,"clicked",false)
	end
	setElementData(item,"clicked",true)
end

--[[!                                    
	Elimina una fila de la lista.
]]
function dxListRemoveRow(dxElement)
	-- check arguments.
	checkargs("dxListRemoveRow", 1, "dxListItem", dxElement);
	
	destroyElement(dxElement)
end

--[[!
	Añade una fila a la lista
]]
function dxListAddRow(dxElement,text,color,font,colorcoded)
	-- check arguments.
	checkargs("dxListAddRow", 1, "dxList", dxElement);
	checkoptionalargs("dxListAddRow", 2, "string", text, "number", color, "string", font, "boolean", colorcoded);

	if not text then
		text = ""
	end
	if not color then
		color = tocolor(0,0,0,255)
	end
	if not font then
		font = "default"
	end
	if colorcoded == nil then
		colorcoded = false
	end
	local item = createElement("dxListItem")
	setElementParent(item,dxElement)
	dxSetText(item,text)
	setElementData(item,"color",color)
	setElementData(item,"font",font)
	dxSetColorCoded(item,colorcoded)
	return item
end

--[[!
	@deprecated
]]
function dxListSetTitleShow(dxElement,titleShow)
	dxDeprecatedFunction("dxListSetTitleShow","dxListSetTitleVisible")
	if not dxElement or getElementType(dxElement) ~= "dxList" or titleShow==nil then
		outputDebugString("dxListSetTitleShow gets wrong parameters.(dxList,titleShow)")
		return
	end
	setElementData(dxElement,"Title:show",titleShow)
end

--[[!
	@deprecated
]]
function dxListGetTitleShow(dxElement)
	dxDeprecatedFunction("dxListGetTitleShow","dxListGetTitleVisible")
	if not dxElement or getElementType(dxElement) ~= "dxList" then
		outputDebugString("dxListGetTitleShow gets wrong parameters.(dxList)")
		return
	end
	return getElementData(dxElement,"Title:show")
end

--[[!
	Establece la visibilidad del título de la lista
	@param dxElement Es la lista
	@param titleShow Es un valor booleano indicando si bien el título es visible o no.
]]
function dxListSetTitleVisible(dxElement,titleShow)
	-- check arguments.
	checkargs("dxListSetTitleVisible", 1, "dxList", dxElement, "boolean", titleShow);

	setElementData(dxElement,"Title:show",titleShow)
end

--[[!
	@return Devuelve un valor booleano indicando la visibilidad de la lista.
]]
function dxListGetTitleVisible(dxElement)
	-- check arguments
	checkargs("dxListGetTitleVisible", 1, "dxList", dxElement);

	return getElementData(dxElement,"Title:show")
end

-- // Events
function __list(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
	local list = source
	local parentX = getElementData(getElementParent(list),"x")
	local parentY = getElementData(getElementParent(list),"y")
	local x,y = 
		parentX+getElementData(list,"x"),parentY+getElementData(list,"y")
	local width = getElementData(list,"width")
	local height = getElementData(list,"height")
	local cTheme = dxGetElementTheme(list)

	local tShow = getElementData(list,"Title:show")
	local titleHeight = getElementData(cTheme,"ListBoxTitle:Height")
	local coh = height
	local cpyyy = y
	local scrollbarVert = getElementData(list,"scrollbarVert") 
	if (scrollbarVert) then
		width = width-20
	end
	if (tShow) then			
		if (intersect(x,y,x+width,y+titleHeight,absoluteX,absoluteY)) then
			return;
		end
		coh = coh-titleHeight
		cpyyy = cpyyy+titleHeight
	end
	local itemHeight = 23
	local itemMultiplyHeight = 23
	local itemMultiply = 0.9
	local itemSorter = 0
	if ( scrollbarVert ) then
		itemSorter = (dxScrollBarGetScroll(scrollbarVert)/100)*dxListGetItemCount(list)*itemMultiply*itemMultiplyHeight
	end
	itemSorter = itemSorter/2
	local itemClicked = 0
	for id,item in ipairs(getElementChildren(list)) do
		setElementData(item,"clicked",false)
		if ( id*itemMultiply*itemMultiplyHeight - itemSorter <= coh+itemHeight ) and (id*itemMultiply*itemMultiplyHeight - itemSorter >=0) and itemClicked == 0 then
			local itemMax = math.max((id-1)*itemMultiply*itemMultiplyHeight-itemSorter,0)
			local itemShow = (cpyyy+coh)-(cpyyy+itemMax-23)
			itemShow = math.min(itemShow,itemHeight)-3
			if (intersect(x+1,cpyyy+itemMax,x+1+width-2,cpyyy+itemMax+itemShow,absoluteX,absoluteY)) then
				setElementData(item,"clicked",true)
				setElementData(list,"selectedItem",item)
				triggerEvent("onClientDXClick",item,button,state,absoluteX,absoluteY)
				itemClicked = 1
			end
		end
	end
end


function list__(button, absoluteX, absoluteY, worldX, worldY, worldZ, clickedWorld)
	local list = source
	local parentX = getElementData(getElementParent(list),"x")
	local parentY = getElementData(getElementParent(list),"y")
	local x,y = 
		parentX+getElementData(list,"x"),parentY+getElementData(list,"y")
	local width = getElementData(list,"width")
	local height = getElementData(list,"height")
	local cTheme = dxGetElementTheme(list)

	local tShow = getElementData(list,"Title:show")
	local titleHeight = getElementData(cTheme,"ListBoxTitle:Height")
	local coh = height
	local cpyyy = y
	local scrollbarVert = getElementData(list,"scrollbarVert") 
	if (scrollbarVert) then
		width = width-20
	end
	if (tShow) then			
		if (intersect(x,y,x+width,y+titleHeight,absoluteX,absoluteY)) then
			return;
		end
		coh = coh-titleHeight
		cpyyy = cpyyy+titleHeight
	end
	local itemHeight = 23
	local itemMultiplyHeight = 23
	local itemMultiply = 0.9
	local itemSorter = 0
	if ( scrollbarVert ) then
		itemSorter = (dxScrollBarGetScroll(scrollbarVert)/100)*dxListGetItemCount(list)*itemMultiply*itemMultiplyHeight
	end
	itemSorter = itemSorter/2
	local itemClicked = 0
	for id,item in ipairs(getElementChildren(list)) do
		setElementData(item,"clicked",false)
		if ( id*itemMultiply*itemMultiplyHeight - itemSorter <= coh+itemHeight ) and (id*itemMultiply*itemMultiplyHeight - itemSorter >=0) and itemClicked == 0 then
			local itemMax = math.max((id-1)*itemMultiply*itemMultiplyHeight-itemSorter,0)
			local itemShow = (cpyyy+coh)-(cpyyy+itemMax-23)
			itemShow = math.min(itemShow,itemHeight)-3
			if (intersect(x+1,cpyyy+itemMax,x+1+width-2,cpyyy+itemMax+itemShow,absoluteX,absoluteY)) then
				setElementData(item,"clicked",true)
				setElementData(list,"selectedItem",item)
				triggerEvent("onClientDXDoubleClick",item,button,absoluteX,absoluteY)
				itemClicked = 1
			end
		end
	end
end

-- // Render
function dxListRender(component,cpx,cpy,cpg, alphaFactor)
	if not cpx then cpx = 0 end
	if not cpy then cpy = 0 end
	-- // Initializing
	local cTheme = dxGetElementTheme(component)
			or dxGetElementTheme(getElementParent(component))
	
	local cx,cy = getElementData(component, "x"), getElementData(component, "y");
	local cw,ch = getElementData(component, "width"), getElementData(component, "height");
	
	local color = multiplyalpha(getElementData(component,"color"), alphaFactor);
	local alpha = extractalpha(color);
	local font = getElementData(component, "font");
	

	local cpxx = cpx+cx
	local cpyy = cpy+cy
	local tShow = getElementData(component,"Title:show")
	local titleHeight = getElementData(cTheme,"ListBoxTitle:Height")
	local coh = ch
	local cpyyy = cpyy
	local scrollbarVert = getElementData(component,"scrollbarVert") 
	if (scrollbarVert) then
		cw = cw-20
	end
	if (tShow) then							
		dxDrawImageSection(cpxx,cpyy,cw,titleHeight,
			getElementData(cTheme,"ListBoxTitle:X"),getElementData(cTheme,"ListBoxTitle:Y"),
			getElementData(cTheme,"ListBoxTitle:Width"),getElementData(cTheme,"ListBoxTitle:Height"),
			getElementData(cTheme,"ListBoxTitle:images"),0,0,0,tocolor(255,255,255, alpha), cpg)
		local funct = dxDrawText
		if (dxGetColorCoded(component)) then
			funct = dxDrawColorText
		end
		local color_ = color;
		local font_ = dxGetFont(component)
		funct(dxGetText(component),cpxx,cpyy,cpxx+cw,cpyy+titleHeight,color_,1,font_,"center","center",true,false,cpg)
		coh = coh-titleHeight
		cpyyy = cpyyy+titleHeight
	end
	
	dxDrawImageSection(cpxx,cpyyy,cw,coh,
		getElementData(cTheme,"ListBoxBackground:X"),getElementData(cTheme,"ListBoxBackground:Y"),
		getElementData(cTheme,"ListBoxBackground:Width"),getElementData(cTheme,"ListBoxBackground:Height"),
		getElementData(cTheme,"ListBoxBackground:images"),0,0,0,tocolor(255,255,255, alpha), cpg)
	
	
	local itemHeight = 23
	local itemMultiplyHeight = 23
	local itemMultiply = 0.9
	local itemSorter = 0
	
	if ( scrollbarVert ) then
		itemSorter = (dxScrollBarGetScroll(scrollbarVert)/100)*dxListGetItemCount(component)*itemMultiply*itemMultiplyHeight
	end
	itemSorter = itemSorter/2
	if (dxListGetItemCount(component)*itemMultiply*itemHeight > coh) then
		local choc = coh
		if ( tShow ) then
			choc = choc + getElementData(cTheme,"ScrollbarThumb:Height")/2
		else
			choc = choc - getElementData(cTheme,"ScrollbarThumb:Height")/2-4
		end
		if not (scrollbarVert) then
			
			scrollbarVert = dxCreateScrollBar(cx+cw-22,cy,20,choc,false,false,getElementParent(component),0,200,cTheme)
			setElementData(component,"scrollbarVert",scrollbarVert)
		else
			dxSetPosition(scrollbarVert,cx+cw-1,cy-2.2)
			dxSetSize(scrollbarVert,20,choc)
			setElementData(component,"scrollbarVert",scrollbarVert)
		end
	end

	for id,item in ipairs(getElementChildren(component)) do
		if ( id*itemMultiply*itemMultiplyHeight - itemSorter <= coh+itemHeight ) and (id*itemMultiply*itemMultiplyHeight - itemSorter >=0) then
			setElementData(item,"shown",true)
			local back = "ListBox1STColor"	
			if ( (id % 2) == 0) then back ="ListBox2NDColor" end
			if ( getElementData(item,"clicked") ) then back ="ListBoxClickedColor" end
			local itemMax = math.max((id-1)*itemMultiply*itemMultiplyHeight-itemSorter,0)
			local itemShow = (cpyyy+coh)-(cpyyy+itemMax)
			itemShow = math.min(itemShow,itemHeight)-3
			dxDrawImageSection(cpxx+1,cpyyy+itemMax,cw-2,itemShow,
				getElementData(cTheme,back..":X"),getElementData(cTheme,back..":Y"),
				getElementData(cTheme,back..":Width"),getElementData(cTheme,back..":Height"),
				getElementData(cTheme,back..":images"),0,0,0,tocolor(255,255,255, alpha),cpg)
			local funct = dxDrawText
			if ( dxGetColorCoded(item) ) then
				funct = dxDrawColorText
			end
			local font__ = getElementData(item,"font")
			local color__ = color;
			if not font__ then
				font__ = "default"
			end
			if not color__ then color__ = tocolor(0,0,0) end
			arrowWidth = 0
			--[[local arrowWidth = getElementData(cTheme,"ListBoxItemArrow:Width")
			local arrowHeight = getElementData(cTheme,"ListBoxItemArrow:Height")
			local arrowCenter = (itemHeight-arrowHeight)/2
			
			local itemMax_ = math.max((id-1)*itemMultiply*arrowHeight-itemSorter,0)
			local itemShow_ = (cpyyy+coh)-(cpyyy+arrowCenter+arrowHeight)
			itemShow_ = math.min(itemShow_,arrowHeight)
			dxDrawImageSection(cpxx+1,cpyyy+itemMax+arrowCenter,arrowWidth,itemShow_,
				getElementData(cTheme,"ListBoxItemArrow:X"),getElementData(cTheme,"ListBoxItemArrow:Y"),
				arrowWidth,arrowHeight,getElementData(cTheme,"ListBoxItemArrow:images"),0,0,0,tocolor(255,255,255),cpg)]]
			-- Now is good without arrows :)
			funct(dxGetText(item),cpxx+1+arrowWidth+5,cpyyy+itemMax,cpxx+1+(cw-2),cpyyy+itemMax+itemShow,color__,1,font__,"left","center",true,false,cpg)
		else
			setElementData(item,"shown",false)
		end
	end
end