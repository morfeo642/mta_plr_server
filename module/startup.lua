

--[[!
	\file
	\brief Este es un script que contendrá el código que será devuelto por la función getStartupCode que será
	exportada por este recurso. 
]]


local __module_env = {};
local __module_loaded = {};
local __module_locked = {};
local __module_shared_count = {};
local __module_dependencies = {};

local __module_caller = false;

function loadModule(modulePath)
	local function getModuleChunk(modulePath) 
		local code = call(getResourceFromName("module"), "getModule", modulePath);
		local chunk, msg = loadstring(code);
		if not chunk then error("Failed to load script \"" .. ".lua\"; " .. msg, 3); end;
		return chunk;
	end;	
	
	local function createEnvironment()
		return setmetatable({}, 
			{
				__index = {loadModule=loadModule, importModule=loadModule}
			});
	end;
	
	if __module_caller then 
		local dependencies = __module_dependencies[__module_caller];
		dependencies[#dependencies+1] = modulePath;
	end;
	
	if (not __module_locked[modulePath]) and (not __module_loaded[modulePath]) then 
	
		local chunk = getModuleChunk(modulePath);
		local env = createEnvironment();
		setfenv(chunk, env);
		
		__module_locked[modulePath] = true;
		__module_caller = modulePath;
		if not __module_dependencies[__module_caller] then 
			__module_dependencies[__module_caller] =  {};
		end;
		
		local success, msg = pcall(chunk);
		if not success then error("Failed to execute script \"" .. ".lua\"; " .. msg, 2); end;
		
		__module_caller = false;
		__module_locked[modulePath] = nil;
		
		__module_env[modulePath] = env;
		__module_loaded[modulePath] = true;
	end;
	
	if not __module_shared_count[modulePath] then 
		__module_shared_count[modulePath] = 1;
	else
		__module_shared_count[modulePath] = __module_shared_count[modulePath] + 1;
	end;
end;

function unloadModule(modulePath)
	function __unloadModule(modulePath)	
		__module_shared_count[modulePath] = __module_shared_count[modulePath] - 1;
		
		if __module_shared_count[modulePath] == 0 then 
			__module_env[modulePath] = nil;
			__module_loaded[modulePath] = nil;
			__module_shared_count[modulePath] = nil;	
			
			for _, dependency in ipairs(__module_dependencies[modulePath]) do 
				__unloadModule(dependency);
			end;
			__module_dependencies[modulePath] = nil;
		end;
	end;

	if not __module_loaded[modulePath] then error("Module " .. modulePath .. " is not loaded", 2); end;
	__unloadModule(modulePath);
end;


importModule = loadModule;
freeModule = unloadModule;

