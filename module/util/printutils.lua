
--[[!
	\file
	\brief Este es un módulo que permite usar la función print, usando la función outputDebugString.
]]

print = 
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