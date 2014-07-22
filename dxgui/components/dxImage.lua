--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        components/dxImage.lua
*  PURPOSE:     All static image functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- // Initializing
--[[!
	Crea una imágen (componente de interfaz de usuario)
	@param x Es la coordenada x de la posición de la imagen
	@param y Es la coordenada y de la posición de la imagen
	@param width Es la anchura de la imágen
	@param height Es la altura de la imagen
	@param path Es la ruta del archivo que contiene la imagen a mostrar
	@param relative Indica si la posición y las dimensiones son relativas al elemento que es padre de la imagen
	@param parent Es el padre de esta imagen, por defecto es dxGetRootPane()
	@param rotation Es la rotación de la imágen en grados sexagesimales, por defecto 0.
]]
function dxCreateStaticImage(x,y,width,height,path,relative,parent,rotation)
	-- check arguments
	checkargs("dxCreateStaticImage", 1, "number", x, "number", y, "number", width, "number", height, "string", path, "boolean", relative);
	checkoptionalargs("dxCreateStaticImage", 8, "number", rotation);
	
	if relative then 
		local px, py = relativeToAbsolute(x + width, y + height);
		x, y = relativeToAbsolute(x, y);
		width, height =  px - x, py - y;
	end
	
	if not parent then
		parent = dxGetRootPane()
	end
	
	if not rotation then
		rotation = 0
	end
	path = getImagePath(sourceResource,path);
	if not fileExists(path) then
		return false
	end
	
	local image = createElement("dxStaticImage")
	setElementParent(image,parent)
	setElementData(image,"resource",sourceResource)
	setElementData(image,"x",x)
	setElementData(image,"y",y)
	setElementData(image,"width",width)
	setElementData(image,"height",height)
	setElementData(image,"rotation",rotation)
	setElementData(image,"Section",false)
	setElementData(image,"Section:x",false)
	setElementData(image,"Section:y",false)
	setElementData(image,"Section:width",false)
	setElementData(image,"Section:height",false)
	setElementData(image,"image",path)
	setElementData(image,"visible",true)
	setElementData(image,"hover",false)
	setElementData(image,"parent",parent)
	setElementData(image,"container",false)
	setElementData(image,"postGUI",false)
	setElementData(image,"ZOrder",getElementData(parent,"ZIndex")+1)
	setElementData(parent,"ZIndex",getElementData(parent,"ZIndex")+1)
	return image
end

--[[!
	Crea un elemento de interfaz de usuario que muestra únicamente una sección de una
	imágen.
	@param x Es la componente x de la posición de la sección.
	@param y Es la componente y de la posición de la sección
	@param width Es la anchura que tendrá la sección
	@param height Es la altura que tendrá la seccion
	@param sectionX Es la coordenada x donde comienza la sección en la imagen en píxeles
	@param sectionY Es la coordenada y donde comienza la sección en la imagen en píxeles
	@param sectionWidth Es la anchura de la sección en la imagen en píxeles.
	@param sectionHeight Es la altura de la sección en la imagen en píxeles.
	@param path Es la ruta de la imagen
	@param relative Es un valor booleano indicando si la posición de la imagen y sus dimensiones deben ser relativas
	al padre de este componente
	@param parent Es el padre de este componente, por defecto, dxGetRootPane()
	@param rotation Es la rotación de la sección de la imagen, por defecto, 0 (en grados sexagesimales)
]]
function dxCreateStaticImageSection(x,y,width,height,sectionX,sectionY,sectionWidth,sectionHeight,path, relative, parent, rotation)
	-- check arguments
	checkargs("dxCreateStaticImageSection", 1, "number", x, "number", y, "number", width, "number", height, "number", sectionX,
		"number", sectionY, "number", sectionWidth, "number", sectionHeight, "string", path, "boolean", relative);
	checkoptionalargs("dxCreateStaticImageSection", 12, "number", rotation);
	
	if not parent then
		parent = dxGetRootPane()
	end
	if not rotation then
		rotation = 0
	end
	if not fileExists(path) then
		return false
	end
	
	local image = createElement("dxStaticImage")
	setElementParent(image,parent)
	setElementData(image,"resource",sourceResource)
	setElementData(image,"x",x)
	setElementData(image,"y",y)
	setElementData(image,"width",width)
	setElementData(image,"height",height)
	setElementData(image,"rotation",rotation)
	setElementData(image,"Section",true)
	setElementData(image,"Section:x",sectionX)
	setElementData(image,"Section:y",sectionY)
	setElementData(image,"Section:width",sectionWidth)
	setElementData(image,"Section:height",sectionHeight)
	setElementData(image,"image",path)
	setElementData(image,"visible",true)
	setElementData(image,"hover",false)
	setElementData(image,"parent",parent)
	setElementData(image,"container",false)
	return image
end
-- // Functions

--[[! 
@return Devuelve la ruta de la imagen asociada.
]]
function dxStaticImageGetLoadedImage(dxElement)
	checkargs("dxStaticImageGetLoadedImage", 1, "dxStaticImage", dxElement);

	return getElementData(dxElement,"image")
end

--[[!
	Carga una nueva imagen.
	@param dxElement Es la imagen
	@param path Es la ruta de la nueva imagen a mostrar.
]]
function dxStaticImageLoadImage(dxElement,path)
	checkargs("dxStaticImageLoadImage", 1, "dxStaticImage", dxElement, "string", path);

	if not fileExists(path) then
		return false
	end
	setElementData(dxElement,"image",path)
	triggerEvent("onClientDXPropertyChanged",dxElement,"image",path)
	return true
end

--[[!
	@return Devuelve la sección que renderiza la componente 
	de la imagen. (Una lista de cuatro elementos: x, y, width, height)
	Si la sección mostrada, es la imágen al completo, se devuelve false.
]]
function dxStaticImageGetSection(dxElement)
	checkargs("dxStaticImageGetSection", 1, "dxStaticImage", dxElement);

	if not (getElementData(dxElement,"Section")) then
		return false
	end
	return getElementData(dxElement,"Section:x"),getElementData(dxElement,"Section:y"),
		getElementData(dxElement,"Section:width"),getElementData(dxElement,"Section:height")
end

--[[!
	Indica que sección de la imagen debe renderizarse.
	@param dxElement Es la imagen
	@param sectionX Es la componente x de la posición de la nueva sección
	@param sectionY Es la componente y de la posición de la nueva sección
	@param sectionW Es la anchura de la nueva sección en pixeles
	@param sectionH Es la anchura de la nueva sección en pixeles.
	@note Si se invoca esta función con la siguiente sintaxis: dxStaticImageSetSection(dxElement), la 
	sección se establecerá a la imágen al completo.
]]
function dxStaticImageSetSection(dxElement,sectionX,sectionY,sectionW,sectionH)
	checkargs("dxStaticImageSetSection", 1, "dxStaticImage", dxElement);
	checkoptionalargs("dxStaticImageSetSection", 2, "number", sectionX, "number", sectionY, "number", sectionW, "number", sectionH);

	if not sectionX then
		setElementData(dxElement,"Section",false)
		setElementData(dxElement,"Section:x",false)
		setElementData(dxElement,"Section:y",false)
		setElementData(dxElement,"Section:width",false)
		setElementData(dxElement,"Section:height",false)
		triggerEvent("onClientDXPropertyChanged",dxElement,"section",false)
		return true
	end
	setElementData(dxElement,"Section",true)
	setElementData(dxElement,"Section:x",sectionX)
	setElementData(dxElement,"Section:y",sectionY)
	setElementData(dxElement,"Section:width",sectionW)
	setElementData(dxElement,"Section:height",sectionH)
	triggerEvent("onClientDXPropertyChanged",dxElement,"section",true,sectionX,sectionY,sectionW,sectionH)
	return true
end

--[[!
	@return Devuelve la rotación de la imagen en grados sexagesimales.
]]
function dxStaticImageGetRotation(dxElement)
	checkargs("dxStaticImageGetRotation", 1, "dxStaticImage", dxElement);

	return getElementData(dxElement,"rotation")
end

--[[!
	Establece la rotación de la imagen.
	@param dxElement La imágen
	@param rot La nueva rotación en grados sexagesimales.
]]
function dxStaticImageSetRotation(dxElement,rot)
	checkargs("dxStaticImageSetRotation", 1, "dxStaticImage", dxElement, "number", rot);

	setElementData(dxElement,"rotation",rot)
	triggerEvent("onClientDXPropertyChanged",dxElement,"rotation",rot)
end

-- // Render
function dxStaticImageRender(component,cpx,cpy,cpg)
	local path = getElementData(component,"image")
	local rotation = getElementData(component,"rotation")
	local cx,cy = dxGetPosition(component)
	local cw,ch = dxGetSize(component)
	if (getElementData(component,"Section")) then
		local sx,sy,sw,sh = getElementData(component,"Section:x"),getElementData(component,"Section:y"),getElementData(component,"Section:width"),getElementData(component,"Section:height")
		dxDrawImageSection(cpx+cx,cpx+cy,cw,ch,sx,sy,sw,sh,path,rotation,0,0,tocolor(255,255,255),cpg)
	else
		dxDrawImage(cpx+cx,cpy+cy,cw,ch,path,rotation,0,0,tocolor(255,255,255),cpg)
	end
end
