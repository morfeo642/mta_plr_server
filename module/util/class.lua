---- Copyright 2011 Simon Dales
--
-- This work may be distributed and/or modified under the
-- conditions of the LaTeX Project Public License, either version 1.3
-- of this license or (at your option) any later version.
-- The latest version of this license is in
--   http://www.latex-project.org/lppl.txt
--
-- This work has the LPPL maintenance status `maintained'.
-- 
-- The Current Maintainer of this work is Simon Dales.
--

--[[!
	\file	
	\brief enables classes in lua
	]]
	
--[[ class.lua
-- Compatible with Lua 5.1 (not 5.0).

	---------------------
	
	]]--
--! \brief ``declare'' as class
--! 
--! use as:
--!	\code{lua}
--!	TWibble = class()
--!	function TWibble.init(instance)
--!		self.instance = instance
--!		-- more stuff here
--!	end
--! \endcode
--! 	
function class(BaseClass, ClassInitialiser)
	local newClass = {}    -- a new class newClass
	if not ClassInitialiser and type(BaseClass) == 'function' then
		ClassInitialiser = BaseClass
		BaseClass = nil
	elseif type(BaseClass) == 'table' then
		-- our new class is a shallow copy of the base class!
		for i,v in pairs(BaseClass) do
			newClass[i] = v
		end
		newClass.__base = BaseClass
	end
	-- the class will be the metatable for all its newInstanceects,
	-- and they will look up their methods in it.
	newClass.__index = newClass

	-- expose a constructor which can be called by <classname>(<args>)
	local classMetatable = {}
	classMetatable.__call = 
	function(class_tbl, ...)
		local newInstance = {}
		setmetatable(newInstance,newClass)
		-- make sure that any stuff from the base class is initialized!
		if BaseClass and BaseClass.init then
			BaseClass.init(newInstance, ...)
		end
		-- initialize this class.
		if class_tbl.init then
			class_tbl.init(newInstance,...)
		end;
		return newInstance
	end
	newClass.init = ClassInitialiser
	newClass.isinstanceof = 
	function(this, class)
		local thisMetabable = getmetatable(this)
		while thisMetabable and (thisMetatable ~= class) do 
			thisMetabable = thisMetabable.__base
		end
		return thisMetatable == class;
	end
	setmetatable(newClass, classMetatable)
	return newClass
end


--eof
