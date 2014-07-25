--[[
Author: Victor Ruiz Gomez (otoplatypus) victorruizgomez642@gmail.com
Description: A draw board is just another element which should be used to draw custom components outside dxgui resource and/or
complex shapes inside of a window or just in the root pane.
The draw board has a fixed size (width/height), so any pixels drawn on the board outside this bounds, should not be shown.
When a draw board requests to be redrawn, it triggers an event called "onClientDXDrawBoardRender".
The handler should draw to the a texture supplied by the board (is passed as a parameter to the handler which handler "onClientDXDrawBoardRender"),
via dxSetRenderTarget.
If "onClientDXDrawBoardRender" is cancelled, texture will not be rendered in that frame.
]]


--// Initializing.
--[[!
	Crea una nueva tabla de dibujar
	@param x Es la componente x de la posición de la tabla
	@param y Es la componente y de la posición de la tabla
	@param width Es la anchura de la tabla
	@param height Es la altura de la tabla.
	@param relative Es un valor booleano indicando si la posición y el tamaño son relativas al elemento padre.
	@param parent Es el elemento padre de esta tabla, por defecto dxGetRootPane()
	@param targetWidth Es la anchura de la textura objetivo (cualquier píxel dibujado que no entre dentro de la textura objetivo, no será dibujado en la pantalla) en píxeles
	@param targetHeight Es la altura de la textura objetivo en píxeles
	@param color Es el color que usará para mezclar la imágen final de la tabla. Por defecto, se usa el white
	@return Devuelve la tabla de dibujar, o bíen false, si hubo algún error (no hay memoria suficiente para crear la textura objetivo)
	
	@note Hay que tener en cuenta las dimensiones de la textura objetivo. Puede consumir mucha memoria.
]]
function dxCreateDrawBoard(x, y, width, height, relative, parent, targetWidth, targetHeight, color)
	-- check arguments.
	checkargs("dxCreateDrawBoard", 1, "number", x, "number", y, "number", width, "number", height, "boolean", relative);
	-- check optional args.
	checkoptionalargs("dxCreateDrawBoard", 7, "number", targetWidth, "number", targetHeight, "number", color);
	
	x, y, width, height = trimPosAndSize(x, y, width, height, relative, parent);

	if not targetWidth then targetWidth = width; end;
	if not targetHeight then targetHeight = height; end;
	
	if not parent then parent = dxGetRootPane(); end;
	if not color then color = tocolor(255, 255, 255, 255); end;
	-- crear la textura objetivo.
	local renderTarget = dxCreateRenderTarget(targetWidth, targetHeight, true);
	if not renderTarget then return false; end;
	
	local drawBoard = createElement("dxDrawBoard")
	setElementParent(drawBoard,parent)
	setElementData(drawBoard,"resource",sourceResource)
	setElementData(drawBoard,"x",x)
	setElementData(drawBoard,"y",y)
	setElementData(drawBoard,"width",width)
	setElementData(drawBoard,"height",height)
	setElementData(drawBoard,"target",renderTarget)
	setElementData(drawBoard,"color",color)
	setElementData(drawBoard,"visible",true)
	setElementData(drawBoard,"hover",false)
	setElementData(drawBoard,"parent",parent)
	setElementData(drawBoard,"container",false)
	setElementData(drawBoard,"postGUI",false)
	setElementData(drawBoard,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	
	addEventHandler("onClientDXDestroy", drawBoard,
		function() 
			local renderTarget = getElementData(source, "target");
			if isElement(renderTarget) then destroyElement(renderTarget); end;
		end);
	return drawBoard
end;

--[[!
@return Devuelve las dimensiones de la textura objetivo
]]
function dxDrawBoardGetTargetSize(drawBoard)
	checkargs("dxDrawBoardGetTargetSize", 1, "dxDrawBoard", drawBoard);
	local renderTarget = getElementData(drawBoard, "target");
	return dxGetMaterialSize(renderTarget);
end;

--[[!
Redimensiona la textura objetivo con las dimensiones indicadas.
@param drawBoard Es la tabla de dibujar
@param targetWidth Es la anchura de la textura objetivo (si no se especifica, se establecerá a la anchura natural de la tabla).
@param targetHeight Es la altura de la textura objetivo (si no se especifica, se establecerá a la altura natural de la tabla)
@return Devuelve false si no hay memoria suficiente para redimensionar la textura objetivo. En caso de éxito, devuelve true.
]]
function dxDrawBoardSetTargetSize(drawBoard, targetWidth, targetHeight)
	checkargs("dxDrawBoardSetTargetSize", 1, "dxDrawBoard", drawBoard);
	checkoptionalargs("dxDrawBoardSetTargetSize", 1, "number", targetWidth, "number", targetHeight);
	
	local width,height = getElementData(drawBoard, "width"), getElementData(drawBoard, "height");
	local prevTargetWidth, prevTargetHeight = dxGetMaterialSize(getElementData(drawBoard, "target"));
	if not targetWidth then targetWidth = width; end;
	if not targetHeight then targetHeight = height; end;
	targetWidth = math.floor(targetWidth); targetHeight = math.floor(targetHeight);
	
	if (targetWidth == prevTargetWidth) and (targetHeight == prevTargetHeight) then return true; end;

	local newTarget = dxCreateRenderTarget(targetWidth, targetHeight, true);
	if not newTarget then return false; end;
	destroyElement(getElementData(drawBoard, "target"));
	setElementData(drawBoard, "target", newTarget);
	return true;
end;


function dxDrawBoardRender(component, cpx, cpy, cpg, alphaFactor)
	local x, y = getElementData(component, "x")+cpx, getElementData(component, "y")+cpy;
	local w, h = getElementData(component, "width"), getElementData(component, "height");
	local color = multiplyalpha(getElementData(component, "color"), alphaFactor);
	local renderTarget = getElementData(component, "target");

	triggerEvent("onClientDXDrawBoardRender", component, renderTarget);
	if not wasEventCancelled() then 
		dxDrawImage(x, y, w, h, renderTarget, 0, 0, 0, color, cpg);
	end;
end;



