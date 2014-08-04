-- Autor: Víctor Ruiz Gómez.

-- Está función lee información de algún archivo xml para conocer que blips les corresponden a cada vehículo.
function parseXMLVehicleBlipConfigFile(path)
	local groupIdsToBlipInfo = {};

	local quotedPath = "\"" .. path .. "\"";
	local file = assert(xmlLoadFile(path), "Failed to load " .. quotedPath .. " file");
	local children = xmlNodeGetChildren(file);
	for _, child in ipairs(children) do 
		local width, height = xmlNodeGetAttribute(child, "width"), xmlNodeGetAttribute(child, "height"); 
		local streamRadius = xmlNodeGetAttribute(child, "stream_radius");
		local image = xmlNodeGetAttribute(child, "image"); 
		local ids = xmlNodeGetAttribute(child, "ids");
		assert(width and height and image and ids and tonumber(width) and tonumber(height) and ((not streamRadius) or (streamRadius and tonumber(streamRadius))), "Failed to parse " .. quotedPath .. " Invalid attributes");
		image = "images/" .. image; 
		assert(fileExists(image), "Failed to parse " .. quotedPath .. "; " .. image .. " image not exists");
	
		if not streamRadius then
			streamRadius = 500;
		else
			streamRadius = tonumber(streamRadius);
		end;
		width, height = tonumber(width), tonumber(height);
		ids = groupIds.fromString(ids, _G);
		groupIdsToBlipInfo[ids] = {width=width, height=height, image=image, streamRadius=streamRadius};
	end;
	
	return groupIdsToBlipInfo;
end; 
 
-- Devuelve el número de ocupantes en un veículo.
function getNumVehicleOccupants(vehicle)
	local count = 0;
	for _, vehicleOccupant in pairs(getVehicleOccupants(vehicle)) do count = count + 1; end;
	return count;
end;	

-- Esta tabla guarda para cada groupo de IDs, el blip que tienen asignado.
groupIdsToBlipInfo = {}; 

-- Esta tabla puede usarse para obtener la información del blip en función de la ID del vehículo.
vehicleIdToBlipInfo = 
	setmetatable({},
		{
			__index = 
				function(t, id) 
					-- buscar si la id está en alguno de los grupos de ids de
					-- vehiculos.
					local grps = groupIdsToBlipInfo; 
					if next(grps) then 
						local ids, blipInfo = next(grps);
						while next(grps, ids) and (not ids:has(id)) do
							ids, blipInfo = next(grps, ids);
						end;
						if ids:has(id) then 
							return blipInfo;
						end;
					end;
				end
		});
		
-- Esta tabla permite obtener información del blip pasando como índice el vehículo.
vehicleToBlipInfo = 
	setmetatable({},
		{
			__index = 
				function(t, vehicle)
					return vehicleIdToBlipInfo[getElementModel(vehicle)];
				end
		});
