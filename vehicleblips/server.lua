-- Author: Victor Ruiz Gómez


--// Funciones auxiliares.

-- Comprueba si un vehículo tiene blip custom.
local function hasVehicleCustomBlip(vehicle)
	return vehicleToBlipInfo[vehicle];
end; 


-- Establece la visibilidad de los blips vinculados a un jugador.
local function setPlayerBlipsVisibleTo(thePlayer, ...)
	local function getPlayerBlips(thePlayer) 
		local attachedElements = getAttachedElements(thePlayer);
		local blips = {};
		for _, attachedElement in ipairs(attachedElements) do
			if getElementType(attachedElement) == "blip" then
				blips[#blips+1] = attachedElement;
			end;
		end;
		return blips;
	end;
	
	for _, blip in ipairs(getPlayerBlips(thePlayer)) do 
		setElementVisibleTo(blip, ...);
	end;
end;	

-- Establece la visibilidad de los blips vinculados a los jugadores que están
-- en un vehículo
local function setVehicleOccupantsBlipsVisibleTo(vehicle, ...) 
	for _, vehicleOccupant in pairs(getVehicleOccupants(vehicle)) do
		setPlayerBlipsVisibleTo(vehicleOccupant, ...);
	end;
end;

--// Manejadores de eventos.


addEventHandler("onResourceStart", resourceRoot, 
	function() 
		-- cargamos los módulos necesarios.
		loadModule("util/vehicleids", _G);
		loadModule("util/groupids", _G);
		
		-- leemos el archivo XML con información de los scripts.
		groupIdsToBlipInfo = parseXMLVehicleBlipConfigFile("config/vehicle_blips.xml");
		
		-- hay algún jugador en un vehículo con blip ? 
		for _, player in ipairs(getElementsByType("player"), root) do 
			if isPedInVehicle(player) and hasVehicleCustomBlip(getPedOccupiedVehicle(player)) then 
				setPlayerBlipsVisibleTo(player, root, false);
			end;
		end;
	end);
	
	
addEventHandler("onResourceStop", resourceRoot,
	function() 
		-- hacemos visibles los blips de los jugadores que están en algún vehículo con blip.
		for _, player in ipairs(getElementsByType("player", root)) do
			if isPedInVehicle(player) and hasVehicleCustomBlip(getPedOccupiedVehicle(player)) then 
				setPlayerBlipsVisibleTo(player, root, true);
			end;
		end;
	end);
	
local function onVehicleDestroyed()
	local vehicle = source;
	setVehicleOccupantsBlipsVisibleTo(vehicle, root, true);
	removeEventHandler("onElementDestroy", vehicle, onVehicleDestroyed);
end;
	
addEventHandler("onVehicleEnter", root,
	function(thePlayer)
		local vehicle = source;
		if hasVehicleCustomBlip(vehicle) then 
			setPlayerBlipsVisibleTo(thePlayer, root, false);
			
			-- es este el primer jugador que entra al vehículo ? 
			if getNumVehicleOccupants(vehicle) == 1 then 
				addEventHandler("onElementDestroy", vehicle, onVehicleDestroyed, false);
				addEventHandler("onVehicleExplode", vehicle, onVehicleDestroyed, false);
			end;
		end;
	end);
	
	
addEventHandler("onVehicleExit", root,
	function(thePlayer)
		local vehicle = source;
		if hasVehicleCustomBlip(vehicle) then 
			setPlayerBlipsVisibleTo(thePlayer, root, true);
	
			-- el jugador que sale es el último que había dentro del vehículo.
			if getNumVehicleOccupants(vehicle) == 0 then 
				removeEventHandler("onElementDestroy", vehicle, onVehicleDestroyed);
				removeEventHandler("onVehicleExplode", vehicle, onVehicleDestroyed);
			end;
		end;	
	end);
	
addEventHandler("onPlayerWasted", root,
	function() 
		setPlayerBlipsVisibleTo(source, root, true);
	end);	

