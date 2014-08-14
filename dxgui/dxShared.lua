--[[
/***************************************************************************************************************
*
*  PROJECT:     dxGUI
*  LICENSE:     See LICENSE in the top level directory
*  FILE:        dxShared.lua
*  PURPOSE:     All shared functions.
*  DEVELOPERS:  Skyline <xtremecooker@gmail.com>
*
*  dxGUI is available from http://community.mtasa.com/index.php?p=resources&s=details&id=4871
*
****************************************************************************************************************/
]]
-- dxDrawColorText : by Aiboforcen from mtasa.com
-- Edited: Someone
-- Skyline's add: clip,wordBreak,postGUI options.And added maxWidth compatible
-- Modified by Victor Ruiz Gomez (method don´t take care about color´s alpha component)
function dxDrawColorText(str, ax, ay, bx, by, color, scale, font, alignX, alignY,clip,wordBreak,postGUI)
	local alpha = extractalpha(color);
	--local maxWidth = bx-ax

	local strAdded = 0
	if str:sub(1,1) ~= " " then
		str = " "..str
		strAdded = 1
	end
		if alignX then
		if alignX == "center" then
		  local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
		  ax = ax + (bx-ax)/2 - w/2
		 -- maxWidth = bx-ax
		elseif alignX == "right" then
		  local w = dxGetTextWidth(str:gsub("#%x%x%x%x%x%x",""), scale, font)
		  ax = bx - w
		-- maxWidth = bx-ax
		end
	  end
	 
	  if alignY then
		if alignY == "center" then
		  local h = dxGetFontHeight(scale, font)
		  ay = ay + (by-ay)/2 - h/2
		elseif alignY == "bottom" then
		  local h = dxGetFontHeight(scale, font)
		  ay = by - h
		end
	  end
		local f = 1
	  local pat = "(.-)#(%x%x%x%x%x%x)"
	  local s, e, cap, col = str:find(pat, 1)
	  local last = 1
		while s do
		if cap == "" and col then color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha) end
		if s ~= 1 or cap ~= "" then
		  local w = dxGetTextWidth(cap, scale, font)
		 --[[ if (w > maxWidth) then
			w = maxWidth
		  end

		  maxWidth = maxWidth-w]]
		  if (f == 1) and strAdded == 1 then
			cap = cap:sub(2)
			f = f+1
		  end
			if not clip then
			clip = false
			end
			if not wordBreak then
				wordBreak = false
			end
			if not postGUI then
				postGUI = false
			end
		  dxDrawText(cap, ax, ay, ax + w, by, color, scale, font,"left","top",clip,wordBreak,postGUI)
		  ax = ax + w
		  color = tocolor(tonumber("0x"..col:sub(1, 2)), tonumber("0x"..col:sub(3, 4)), tonumber("0x"..col:sub(5, 6)), alpha)
		end
		last = e + 1
		s, e, cap, col = str:find(pat, last)
	  end
	  if last <= #str then
		cap = str:sub(last)
		local w = dxGetTextWidth(cap, scale, font)
		--[[if (w > maxWidth) then
			w = maxWidth
		  end

		  maxWidth = maxWidth-w
		]]
		if not clip then
			clip = false
		end
		if not wordBreak then
			wordBreak = false
		end
		if not postGUI then
			postGUI = false
		end
		if ( f == 1) and strAdded==1 then
			cap = cap:sub(2)
		end
		f = f+1
		dxDrawText(cap, ax, ay, ax + w, by, color, scale, font,"left","top",clip,wordBreak,postGUI)
	end
end

function toHex(x)
	return string.format("%x",x)
end

function intersect(x,y,x2,y2,posx,posy)
	if (posx >= x and posx<=x2) and (posy >= y and posy<=y2) then
		return true
	end
	return false
end

function string:tobool()
	if self == "true" then
		return true
	else
		return false
	end
end

function relativeToAbsolute(xcoord,ycoord)
	local x,y = guiGetScreenSize()
	local rx = x*xcoord
	local ry = y*ycoord
	return rx,ry
end

function getCursorAbsolute()
	if (not isCursorShowing()) then
		return false
	end
	local scx,scy,wx,wy,wh = getCursorPosition()
	local x,y = relativeToAbsolute(scx,scy)
	return x,y
end

function table.reverse ( tab )
    local size = #tab
    local newTable = {}
 
    for i,v in ipairs ( tab ) do
        newTable[size-i] = v
    end
 
    return newTable
end


--// Path Functions
function getImagePath(iResource, fileName)
	if (type(fileName)~="string") then
		return fileName
	end
	local start, stop = string.find(fileName,":")
	if  start == 1 then
		return fileName
	end
	
	return ":"..getResourceName(iResource).."/"..fileName
end

   --// checking functions                     
function checkargs(funcname, firstarg, ...)
	assert((type(funcname) == "string") and (type(firstarg) == "number") and (firstarg > 0));
	local args = {...};
	local i = 1;
	while (i < #args) do 
		assert((type(args[i]) == "string") or (type(args[i]) == "table"));
		local expectedTypes = {};
		if type(args[i]) == "string" then 
			table.insert(expectedTypes, args[i]);
		else 
			for j=1,#args[i],1 do expectedTypes[j] = args[i][j]; end;
		end;
		local value = args[i+1];
		local valueType;
		if isElement(value) then
			valueType = getElementType(value);
		else 
			valueType = type(value);
		end;
		-- check whatever the value has the type(s) expected.
		local j = 1;
		while (j < #expectedTypes) and (valueType ~= expectedTypes[j]) do 
			j = j + 1;	
		end;
		

		-- not founded any type that matches the argument's type. ? 
		assert(valueType == expectedTypes[j], "Argument mismatch in function \"" .. funcname .. "\" at argument " .. 
			tostring((i+1) / 2 + firstarg - 1) .. "; " .. table.concat(expectedTypes, " or ") .. " expected, but " .. valueType .. " found (" .. tostring(value) .. ")");
		
		i = i + 2;
	end;
end;

function checkoptionalargs(funcname, firstarg, ...)
	local args = {...};
	for i=1,#args-1,2 do
		if type(args[i]) ~= "table" then 
			local aux = args[i];
			args[i] = {};
			table.insert(args[i], aux);
		end;
		table.insert(args[i], "nil");
	end;
	checkargs(funcname, firstarg, unpack(args)); 
end;


function checkvalue(valuename, value, ...)
	local args = {...};
	assert(#args > 0);
	
	local i = 1;
	while (i < #args) and (value ~= args[i]) do 
		i = i + 1;
	end;
	assert(value == args[i], valuename .. " must be set to " .. table.concat(args, " or "));
end;

function iscontainer(var)
	return isElement(var) and (getElementData(var, "container"));
end; 

function checkcontainer(funcname, argnum, var)
	assert((type(funcname) == "string") and (type(argnum) == "number") and (argnum > 0));
	local varType;
	if isElement(var) then 
		varType = getElementType(var);
	else 
		varType = type(var);
	end;
	
	assert(iscontainer(var), "Argument mismatch in function \"" .. funcname .. "\" at argument " .. 
			argnum .. "; " .. table.concat({"dxRootPane", "dxWindow"}, " or ") .. " expected, but " .. varType .. " found");
end;

function checkoptionalcontainer(funcname, argnum, var) 
	if var ~= nil then 
		checkcontainer(funcname, argnum, var);
	end;
end;

function checkDXElement(funcname, argnum, var)
	assert((type(funcname) == "string") and (type(argnum) == "number") and (argnum > 0));
	local varType;
	if isElement(var) then 
		varType = getElementType(var); 
	else
		varType = type(var);
	end;
	assert(dxIsElement(var), "Argument mismatch in function \"" .. funcname .. "\" at argument " .. 
			argnum .. "; dxElement expected, but " .. varType .. " found");
end;

--// miscelaenous
function trimPosAndSize(x, y, w, h, relative, parent)
	if relative then 
		local sx, sy;
		if not parent then 
			sx, sy = guiGetScreenSize();
		else
			sx, sy = dxGetSize(parent, false);
		end;
		return x * sx, y * sy, w * sx, h * sy;
	end;
	return x, y, w, h;
end;

function trimSize(w, h, relative, parent)
	if relative then 
		local sx, sy;
		if not parent then 
			sx, sy = guiGetScreenSize();
		else
			sx, sy = dxGetSize(parent, false);
		end;
		return w * sx, h * sy;
	end;
	return w, h;
end;

function getEmbeddedText(text, maxWidth, font, scale) 
	if text:len() > 0 then 
		local i = 1;
		while (i < text:len()) and (dxGetTextWidth(text:sub(1,i), scale, font) <= maxWidth) do 
			i = i + 1; 
		end; 
		if dxGetTextWidth(text:sub(1,i)) > maxWidth then 
			i = i - 1; 
		end;
		if i > 0 then 
			return text:sub(1,i);
		end;
	end;
	return "";
end;

function getTextWithoutColorCodes(text)
	return text:gsub("#%x%x%x%x%x%x", "");
end;

function getSubColorCodedText(text, lastChar) 
	if text:len() >= 7 then 
		local str = "";
		local i, j = 1, 1;
		while ((text:len() - j + 1) >= 7) and (i <= lastChar) do
			if text:sub(j, j+6):find("#%x%x%x%x%x%x") then 
				str = str .. text:sub(j, j+6);
				j = j + 7; 
			else
				str = str .. text:sub(j, j);
				j = j + 1; 
				i = i + 1;
			end;
		end;
		return str .. text:sub(j, j + lastChar - i);
	end;
	return text:sub(1, lastChar);
end;

function getEmbeddedColorCodedText(text, ...)
	if text:len() > 0 then
		local textWithoutCode = getTextWithoutColorCodes(text);
		local embeddedText = getEmbeddedText(textWithoutCode, ...);
		return getSubColorCodedText(text, embeddedText:len());
	end;
	return "";
end;

function fromcolor(color)
	return bitExtract(color, 16,8), bitExtract(color, 8,8), bitExtract(color, 0, 8), bitExtract(color, 24,8);
end; 

function extractalpha(color)
	return bitExtract(color, 24, 8);
end; 

function multiplyalpha(color, factor)
	local r,g,b,a = fromcolor(color);
	return tocolor(r,g,b, a * factor);
end;

function isAnyWindowBeingMoved()
	local windows = getElementsByType("dxWindow");
	if #windows > 0 then 
		local i = 1; 
		while (i < #windows) and (not getElementData(windows[i], "isMoving")) do 
			i = i + 1;
		end;
		return getElementData(windows[i], "isMoving");
	end;
	return false;
end; 