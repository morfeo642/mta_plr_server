
--[[!
	\file
	\brief Este es un módulo que permite usar la función print (la reemplaza de la tabla _G), usando la función outputDebugString.
]]

_G.print = 
	function(...)
		local str = "";
		local args = {...};
		local i = 1; 
		if #args > 0 then 
			while (i < #args) do 
				str = str .. tostring(args[i]) .. "     ";
				i = i + 1; 
			end; 
			str = str .. tostring(args[#args]);
			outputDebugString(str);
		else
			outputDebugString("");
		end;
	end;