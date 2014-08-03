--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        dxAnimation.lua
*  PURPOSE:     Animation Functions
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
function dxMove(dxElement,xMove,yMove,titleMove)
	if not dxElement or not xMove or not yMove then
		outputDebugString("dxMove gets wrong parameters (dxElement,xMove,yMove[,titleMove=true])")
		return
	end

	if titleMove == nil then
		titleMove = true
	end
	local x,y,tx,ty = dxGetPosition(dxElement)
	move = function()
		local movex,movey,movetx,movety = false,false,false,false
		local xx,yy,txx,tyy = dxGetPosition(dxElement)
		if ( xx ~= x+xMove ) then
			if (xx > x+xMove ) then
				xx = xx - 1
			else
				xx = xx + 1
			end
		else
			movex = true
		end
		
		if (yy ~= y+yMove) then
			if (yy > y+yMove) then
				yy = yy -1
			else
				yy = yy +1
			end
		else
			movey = true
		end
		
		if (tx) then
			if ( txx ~= tx+xMove ) then
				if (txx > tx+xMove ) then
					txx = txx - 1
				else
					txx = txx + 1
				end
			else
				movetx = true
			end
		else
			movetx = true
		end
		
		if (ty) then
			if ( tyy ~= ty+yMove ) then
				if (tyy > ty+yMove ) then
					tyy = tyy - 1
				else
					tyy = tyy + 1
				end
			else
				movety = true
			end
		else
			movety = true
		end
		
		dxSetPosition(dxElement,xx,yy,false,false)
		if (titleMove and getElementType(dxElement) == "dxWindow") then
			dxWindowSetTitlePosition(dxElement,txx,tyy)
		end
		if movex and movey and movetx and movety then
			removeEventHandler('onClientRender',getRootElement(),move)
			triggerEventHandler('onClientDXMove',dxElement,xx,yy,txx,tyy)
		end
	end
	addEventHandler('onClientRender',getRootElement(),move)
end



--[[!
	Este método cambia la transparencia de un componente de interfaz
	gradualmente.
	@param dxElement Es el elemento
	@param endAlpha Es el valor final de la componente alpha. En el rango [0, 255] por defecto 0.
	@param mlls Es el número de millisegundos que duraría la animación si el componente empezará con transparencia 0 y finalizara
	con transparencia 255. Por defecto 1.5s = 1500
	@note Si el componente de interfaz ya tenía una animación en curso, se eliminará la animación previa y
	se partirá del valor actual alpha e irá creciendo/decreciendo hasta llegar a la transparencia final de la animación.
]]

local componentFadeAnimationHandlers = {};

function dxFadeElement(dxElement, endAlpha, mlls)
	checkDXElement("dxFadeElement", 1, dxElement);
	checkoptionalargs("dxFadeElement", 2, "number", endAlpha, "number", mlls);
	assert((not mlls) or (mlls >= 0), "dx component fade animation duration must be a non-negative number");
	if not mlls then 
		mlls = 1500;
	end;
	if not endAlpha then 
		endAlpha = 0;
	end;
	
	local currAlpha = getElementData(dxElement, "alpha");
	local speed = (endAlpha - currAlpha) / mlls;
	
	-- hay alguna animación de este componente en curso ? 
	if componentFadeAnimationHandlers[dxElement] then 
		removeEventHandler("onClientPreRender", root, componentFadeAnimationHandlers[dxElement]);
	end;
	
	-- handler para eliminar animaciones de componentes que han sido eliminados...
	local function componentDestroyedHandler()
		local dxElement = source;
		-- eliminar la animación del componente.
		removeEventHandler("onClientPreRender", root, componentFadeAnimationHandlers[dxElement]);
	end
	
	componentFadeAnimationHandlers[dxElement] = 
		function(timeSlice) 
			local currAlpha = getElementData(dxElement, "alpha"); 
			local nextAlpha = currAlpha + speed * timeSlice;
			if speed > 0 then
				nextAlpha = math.min(nextAlpha, endAlpha);
			else 
				nextAlpha = math.max(nextAlpha, endAlpha);
			end;
			setElementData(dxElement, "alpha", nextAlpha);
			if nextAlpha == endAlpha then 
				-- la animación ha terminado...
				removeEventHandler("onClientPreRender", root, componentFadeAnimationHandlers[dxElement]);
				removeEventHandler("onClientDXDestroy", dxElement, componentDestroyedHandler);
				componentFadeAnimationHandlers[dxElement] = nil;
			end;
		end;
	-- añadir la animación.
	addEventHandler("onClientPreRender", root, componentFadeAnimationHandlers[dxElement]);
	addEventHandler("onClientDXDestroy", dxElement,  componentDestroyedHandler);
end;