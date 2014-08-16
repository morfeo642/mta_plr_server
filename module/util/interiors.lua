--[[!
	\file
	\brief Es un módulo que permite trabajar con las IDs de interiores y 
	obtener las IDs de los mundos y las posiciones de los mismos.
]]

loadModule("util/tableutils");
loadModule("util/checkutils");

local interiors =
{
	{"(Outside)", 0, 0, 0, 3},
	{"24/7 shop 1", 18, -30.95, -91.71, 1002.55},
	{"24/7 shop 2", 6, -26.69, -57.81, 1002.55},
	{"24/7 shop 3", 4, -27.31, -31.38, 1002.55},
	{"Abandoned AC Tower (safehouse)", 10, 422.16, 2536.52, 9.01},
	{"Ammu-Nation 1", 1, 286.15, -41.54, 1000.57},
	{"Ammu-Nation 2", 4, 285.8, -85.45, 1000.54},
	{"Ammu-Nation 3", 6, 296.92, -111.97, 1000.57},
	{"Ammu-Nation 4", 6, 316.53, -169.61, 998.66},
	{"Ammu-Nation 5 (2 floors)", 7, 309.38, -136.3, 999.60},
	{"Andromada", 9, 315.48, 984.13, 1959.11},
	{"Atrium lobby entrance", 18, 1726.19, -1638.01, 19.27},
	{"Atrium lobby exit", 18, 1700.74, -1668.48, 19.22},
	{"Bar 1 (Gaydar Station)", 17, 493.39, -24.92, 999.69},
	{"Bar 2 (Ten Green Bottles)", 11, 501.98, -67.75, 997.84},
	{"Big Bear's apartment", 3, 1527.38, -11.02, 1002.1},
	{"Big Smoke's Crack Palace", 2, 2541.7, -1304.01, 1024.07},
	{"Big Spread Ranch", 3, 1212.02, -25.86, 1000.09},
	{"Binco", 15, 207.74, -111.42, 1004.27},
	{"Brothel", 3, 944.8, 1.96, 1000.93},
	{"Brothel 2", 3, 963.0, -47.2, 1001.12},
	{"Budget Inn Motel Room", 12, 447.52, 511.49, 1001.4},
	{"Burger Shot", 10, 363.11, -74.88, 1000.55},
	{"Burning Desire House", 5, 2352.34, -1181.25, 1027},
	{"Cafe shop (Catalina)", 1, 681.58, -473.42, 15.59},
	{"Caligulas Casino (Roof access)", 1, 2264.49, 1619.58, 1089.5},
	{"Cluckin' Bell", 9, 365.67, -11.61, 1000.87},
	{"Colonel Fuhrberger's House", 8, 2807.62, -1174.1, 1024.58},
	{"Diner 1", 4, 460.1, -88.43, 998.62},
	{"Diner 2", 5, 459.35, -111.01, 998.72},
	{"Dnameier Sachs", 14, 204.33, -168.7, 999.58},
	{"Driving School", 3, -2029.72, -119.55, 1034.17},
	{"Francis Int. Airport (Baggage Claim)", 14, -1860.82, 59.74, 1062.14},
	{"Gay Gordo's Barbershop", 3, 418.65, -84.14, 1000.96},
	{"Hemlock Tattoo", 17, -204.44, -9.17, 1001.3},
	{"Insnamee Track Betting", 3, 834.82, 7.42, 1003.18},
	{"Insnamee Track Betting (Chinatown SF)", 1, -2166.01, 643.05, 1057.59},
	{"Jefferson Motel", 15, 2214.34, -1150.51, 1024.8},
	{"Jizzy's Pleasure Domes", 3, -2661.01, 1417.74, 921.31},
	{"Johnson House", 3, 2496.05, -1692.73, 1013.75},
	{"LS Tattoo Parlour", 16, -204.44, -27.15, 1001.3},
	{"LSPD HQ", 6, 246.78, 62.2, 1002.64},
	{"LV Meat Factory", 1, 965.38, 2159.33, 1010.02},
	{"LV Tattoo Parlour", 3, -204.44, -44.35, 1001.3},
	{"LVPD HQ", 3, 238.66, 139.35, 1002.05},
	{"Las Venturas Gym", 7, 773.58, -78.2, 999.69},
	{"Las Venturas Planning Dep.", 3, 390.87, 173.81, 1007.39},
	{"Liberty City", 1, -750.80, 491.00, 1371.70},
	{"Lil Probe Inn (UFO Bar)", 18, -229.03, 1401.23, 26.77},
	{"Los Santos Gym", 5, 772.11, -5, 999.69},
	{"Macisla's Barbershop", 12, 412.02, -54.55, 1000.96},
	{"Madd Dogg's Mansion 1", 5, 1260.58, -785.31, 1090.96},
	{"Madd Dogg's Mansion 2", 5, 1299.08, -796.83, 1083.03},
	{"Millie's Bedroom", 6, 347.52, 306.77, 999.15},
	{"Police Station 1", 5, 322.72, 306.4, 999.11},
	{"RC Zero's Battlefield", 10, -975.57, 1061.13, 1345.67},
	{"RC Zero's Shop", 6, -2241.07, 128.52, 1034.42},
	{"Record Label Hallway", 3, 1037.9, 5.35, 1001.28},
	{"Reece's Barbershop", 2, 411.63, -23.33, 1000.8},
	{"Restaurant 1", 1, 452.89, -18.18, 1000.18},
	{"Restaurant 2", 6, 441.98, -49.92, 998.69},
	{"Rusty Brown's - Ring Donuts", 17, 378.29, -188.9, 1000.61},
	{"SFPD HQ", 10, 246.62, 112.1, 1003.2},
	{"Safe House 1", 1, 223.04, 1287.26, 1081.2},
	{"Safe House 10", 5, 2233.8, -1115.36, 1049.91},
	{"Safe House 11", 8, 2365.3, -1134.92, 1049.91},
	{"Safe House 12", 11, 2282.91, -1140.29, 1049.91},
	{"Safe House 13", 6, 2196.79, -1204.35, 1048.05},
	{"Safe House 14", 10, 2270.39, -1210.45, 1046.57},
	{"Safe House 15", 6, 2308.79, -1212.88, 1048.03},
	{"Safe House 16", 1, 2217.54, -1076.29, 1049.52},
	{"Safe House 17", 2, 2237.59, -1080.87, 1048.07},
	{"Safe House 18", 9, 2317.82, -1026.75, 1049.21},
	{"Safe House 2", 4, 260.98, 1284.55, 1079.3},
	{"Safe House 3", 5, 140.18, 1366.58, 1082.97},
	{"Safe House 4", 9, 82.95, 1322.44, 1082.89},
	{"Safe House 5", 15, -283.55, 1470.98, 1083.45},
	{"Safe House 6", 4, -260.6, 1456.62, 1083.45},
	{"Safe House 7", 8, -42.58, 1405.61, 1083.45},
	{"Safe House 8", 6, -68.69, 1351.97, 1079.28},
	{"Safe House 9", 6, 2333.11, -1077.1, 1048.04},
	{"San Fierro Chunk (cutscene place)", 14, -2015.66, 147.20, 29.31},
	{"San Fierro Gym", 6, 774.21, -50.02, 999.69},
	{"Sex Shop", 3, -100.33, -24.92, 999.74},
	{"Shamal", 1, 1.61, 34.74, 1199.0},
	{"Stadium 1", 1, -1400.21, 106.89, 1032.27},
	{"Stadium 2 (Bloodbowl)", 15, -1394.20, 987.62, 1023.96},
	{"Stadium 3 (Kickstart)", 14, -1410.72, 1591.16, 1052.53},
	{"Sub Urban", 1, 203.78, -49.89, 1000.8},
	{"The Caligulas Casino", 1, 2233.91, 1714.73, 1011.38},
	{"The Casino", 12, 1133.07, -12.77, 999.75},
	{"The Crack Den", 5, 318.57, 1115.21, 1082.98},
	{"The Four Dragons Casino", 10, 2018.95, 1017.09, 995.88},
	{"The Four Dragons Casino (office)", 11, 2004.01, 1027.42, 33.53},
	{"The Pig Pen", 2, 1204.81, -12.79, 1000.09},
	{"The Sherman's Dam Generator Hall", 17, -956.6, 1862.23, 9.01},
	{"Train Hard", 3, 207.06, -139.81, 1002.52},
	{"Victim", 5, 227.29, -7.43, 1001.26},
	{"Warehouse", 1, 1401.3, -15.5, 1002.9},
	{"Well Stacked Pizza Co.", 5, 372.35, -133.55, 1000.45},
	{"Zip", 18, 161.39, -96.69, 1000.81}
}


--[[!
	@return Devuelve una lista de nombres de todos los interiores.
]]	
function getAllInteriors()
	local aux = {};
	for _, interiorInfo in ipairs(interiors) do 
		local interiorName = unpack(interiorInfo);
		aux[#aux+1] = interiorName;
	end;
	return aux;
end;

--[[!
Obtiene la id del mundo para un interior.
@param interiorName Es el nombre del interior
@return Devuelve la id del mundo a la que pertenece este interior o false si este 
nombre no encaja con ningún nombre asociado a ningun interior.
@note Esta id puede usarse como argumento para la función setElementInterior
]]
function getInteriorWorldId(interiorName) 
	checkArgumentType("getInteriorWorldId", 2, interiorName, 1, "string");
	local interiorIndex = table.match(interiors, function(value) return (interiorName == value[1]); end)
	if not interiorIndex then 
		return false; 
	end;
	local _, worldId = unpack(interiors[interiorIndex]);
	return worldId;
end;

--[[!
Obtiene las coordenadas X, Y, Z del interior en su mundo.
@param interiorName Es el nombre del interior.
return Devuelve un lista de tres elementos con las coordenadas X,Y,Z del interior o 
false si no existe ningún interior que tenga ese nombre.
@note Estas coordenadas pueden usarse como argumentos para la función setElementInterior.
]]
function getInteriorPosition(interiorName)
	checkArgumentType("getInteriorPosition", 2, interiorName, 1, "string");
	local interiorIndex = table.match(interiors, function(value) return (interiorName == value[1]); end)
	if not interiorIndex then 
		return false; 
	end;
	local _, worldId, posX, posY, posZ = unpack(interiors[interiorIndex]);
	return posX, posY, posZ;
end;
