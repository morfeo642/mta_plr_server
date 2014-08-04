-- Author: Victor Ruiz Gómez

		
-- Esta tabla devuelve un nuevo blip en función de la ID de cada vehículo.
local vehicleIdToBlip = 
	setmetatable({},
		{
			__index = 
				function(t, id) 
					-- obtener la información del blip.
					local blipInfo = vehicleIdToBlipInfo[id]; 
					if blipInfo then 
						-- crear un blip.
						local blips = exports.customblips;
						return blips:createCustomBlip(0, 0, blipInfo.width, blipInfo.height, blipInfo.image, blipInfo.streamRadius);
					end;
				end	
		});

-- Esta tabla devuelve un nuevo blip en función del vehículo y lo vincula a este.
local vehicleToBlip = 
	setmetatable({},
		{
			__index = 
				function(t, vehicle)
					-- obtener la id del vehículo.
					local id = getElementModel(vehicle);
					local blip = vehicleIdToBlip[id];
					if blip then 
						local blips = exports.customblips;
						blips:attachCustomBlipToElement(blip, vehicle);
						return blip;
					end;
				end
		});
		

local onVehicleDestroyed;
		
-- Esta tabla almacena los blips de los vehículos.
local _vehicleBlips = {};
local vehicleBlips = 
	setmetatable({},
		{
			__index = 	
				function(_, vehicle) 
					return _vehicleBlips[vehicle];
				end,
			__newindex = 
				function(_, vehicle, blip)
					if not blip then
						removeEventHandler("onClientElementDestroy", vehicle, onVehicleDestroyed);						
					else
						addEventHandler("onClientElementDestroy", vehicle, onVehicleDestroyed, false);
						addEventHandler("onClientVehicleExplode", vehicle, onVehicleDestroyed, false);
					end;
					_vehicleBlips[vehicle] = blip;
				end
		});

onVehicleDestroyed = 
	function() 
		exports.customblip:destroyCustomBlip(vehicleBlips[source]);
		vehicleBlips[source] = nil;
	end;
		
addEventHandler("onClientResourceStart", resourceRoot,
	function()
		-- cargar los módulo.
		loadModule("util/groupids", _G);
		loadModule("util/vehicleids", _G);
		
		-- leer el archivo XML con datos de los blips.
		groupIdsToBlipInfo = parseXMLVehicleBlipConfigFile("config/vehicle_blips.xml");
		
		-- si hay algún jugador remoto en algún vehículo, crear el blip del vehículo.
		for _, player in ipairs(getElementsByType("player", root)) do 
			if (player ~= localPlayer) and isPedInVehicle(player) and (getPedOccupiedVehicle(player) ~= getPedOccupiedVehicle(localPlayer)) 
				and (not vehicleBlips[getPedOccupiedVehicle(player)]) then 
				
				local vehicle = getPedOccupiedVehicle(player);
				local blip = vehicleToBlip[vehicle];
				if blip then 
					vehicleBlips[vehicle] = blip;
				end;
			end;
		end;
	end);
	
addEventHandler("onClientResourceStop", root,
	function() 
		-- eliminar todos los blips.
		for vehicle, blip in pairs(vehicleBlips) do 
			exports.customblips:destroyCustomBlip(blip);
		end;
	end);
	

addEventHandler("onClientVehicleEnter", root,
	function(player)
		local vehicle = source;
		if player == localPlayer then 
			-- si el jugador local entra en el vehículo ... 
			if vehicleBlips[vehicle] then 
				exports.customblips:destroyCustomBlip(vehicleBips[vehicle]);
				vehicleBlips[vehicle] = nil;
			end;	
		else
			-- si un jugador remoto entra en el vehículo y en el vehículo no está el jugador local...
			if (not vehicleBlips[vehicle]) and (vehicle ~= getPedOccupiedVehicle(localPlayer)) then
				local blip = vehicleToBlip[vehicle];
				if blip then 
					vehicleBlips[vehicle] = blip;
				end;
			end;
		end;
	end);
	
addEventHandler("onClientVehicleExit", root,
	function(player)
		local vehicle = source;
		if player == localPlayer then 
			-- si el jugador local sale del vehículo y hay más gente en él ...
			if getNumVehicleOccupants(vehicle) > 0 then 
				local blip = vehicleToBlip[vehicle];
				if blip then 
					vehicleBlips[vehicle] = blip;
				end;	
			end;
		else
			-- si un jugador remoto sale del vehículo...
			if (getNumVehicleOccupants(vehicle) == 0) and vehicleBlips[vehicle] then 
				-- no funcionaría correctamente si el jugador local estuviera dentro, pero 
				-- si no hay ningún ocupante, es que no está el jugador local, luego no hay ningún problema...
				exports.customblips:destroyCustomBlip(vehicleBlips[vehicle]);
				vehicleBlips[vehicle] = nil;
			end;
		end;
	end);
	
addEventHandler("onClientPlayerWasted", root,
	function() 
		if source == localPlayer then 
			-- puede ocurrir que al morir el jugador local, el vehículo en el que estaba haya algún jugador remoto, luego deberíamos 
			-- crear el blip para ese vehículo.
			local vehicles = getElementsByType("vehicle", root);
			local i = 1;
			if #vehicles >= 1 then 
				while (i < #vehicles) and ((getNumVehicleOccupants(vehicles[i]) == 0) or vehicleBlips[vehicles[i]]  or (not vehicleToBlipInfo[vehicles[i]])) do 
					i = i + 1;
				end;
				if (getNumVehicleOccupants(vehicles[i]) > 0) and (not vehicleBlips[vehicles[i]]) and vehicleToBlipInfo[vehicles[i]] then 
					-- creamos el blip.
					local vehicle = vehicles[i];
					vehicleBlips[vehicle] = vehicleToBlip[vehicle];
				end;
			end;
		else 
			-- si el jugador remoto muerto estaba en un vehículo, y era el único ocupante, deberiamos eliminar su blip asociado...
			if next(vehicleBlips) then 
				local vehicle, blip = next(vehicleBlips);
				while next(vehicleBlips, vehicle) and ((getNumVehicleOccupants(vehicle) > 0) or (not vehicleBlips[vehicle])) do 
					vehicle, blip = next(vehicleBlips, vehicle);
				end;
				if (getNumVehicleOccupants(vehicle) == 0) and vehicleBlips[vehicle] then 
					-- eliminar el blip.
					exports.customblips:destroyCustomBlip(blip);
					vehicleBlips[vehicle] = nil;
				end;	
			end;
		end;
	end);