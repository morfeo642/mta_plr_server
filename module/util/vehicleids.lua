--[[!
	\file
	\brief Este script contiene grupos de IDs que nos permiten categorizar, clasificar
	vehiculos.
]]

loadModule("util/groupids"); 
loadModule("util/checkutils");

--[[! Este grupo posee todas las IDs de todos los vehiculos existentes en MTA ]]
allVehicleIds = groupIds(602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 
438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 
567, 535, 576, 412, 402, 542, 603, 475, 449, 537, 538, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458, 
606, 607, 610, 590, 569, 611, 584, 608, 435, 450, 591, 594);

--[[! A este grupo pertenecen todos los vehiculos que no pueden ser bloqueados ]]
notLockableVehicleIds = groupIds(594, 606, 607, 611, 584, 608, 435, 450, 591, 539, 441, 464, 501, 465, 564, 472, 473, 493, 595, 484, 430, 
453, 452, 446, 454, 581, 509, 481, 462, 521, 463, 510, 522, 461, 448, 468, 586, 425, 52);

--[[! A esta clase pertenecen los coches compactos o de dos puertas ]]
compactCarsAndTwoDoorIds = groupIds(602, 496, 401, 518,527, 589, 419, 533, 526, 474,
545, 517, 410, 600, 436, 580, 439, 549, 491);

--[[! A esta clase pertenecen vehicuos de 4 cuatro puertas y tambíen vehiculos 
lujosos ]]
luxuryCarsAndFourDoorIds = groupIds(445, 604, 507, 585, 587, 466, 492, 546, 551, 516,
467, 426, 547, 405, 409, 550, 566, 540, 421, 529);

--[[! A esta clase pertenecen todos los helicopteros ]]
helicopterIds = groupIds(548, 425, 417, 487, 488, 497, 563, 447, 469);


--[[! A esta clase pertenecen todos los aviones grandes (comerciales) ]]
bigPlaneIds = groupIds(592, 577, 553, 519); 

--[[! A esta clase pertenecen todos los aviones ligeros]]
lightPlaneIds = groupIds(511, 512, 593, 476, 460, 513, 520);

--[[! A esta clase pertenecen todos los aviones ]]
planeIds = bigPlaneIds + lightPlaneIds;

--[[! A esta clase pertenecen todos los helicopteros de ataque ]]
attackHelicopterIds = groupIds(425);

--[[! A esta clase pertenecen todos los aviones de ataque ]]
attackPlaneIds = groupIds(476, 520);

--[[! A esta clase pertenece todo vehículo aéreo de ataque ]]
aircraftAttackVehicleIds = attackHelicopterIds + attackPlaneIds;

--[[! A esta clase pertenecen todas las bicicletas ]]
bicycleIds = groupIds(509, 481, 510);

--[[! A esta clase pertenecen todas las motocicletas ]]
motorbikeIds = groupIds(581, 462, 521, 463, 522, 461, 448, 468, 586);

--[[! A esta clase pertenecen los vehículos de dos ruedas ]]
bikeIds = bicycleIds + motorbikeIds;

--[[! A esta clase pertenecen los barcos lígeros ]]
lightBoatIds = groupIds(472, 473, 493, 595, 484, 430, 453, 452, 446);

--[[! A esta clase pertenecen los barcos pesados ]]
bigBoatIds = groupIds(454); 

--[[! A esta clase pertenecen todos los barcos ]]
boatIds = lightBoatIds + bigBoatIds;

--[[! A esta clase pertenecen todo los vehículos de servicio
público como taxi, camión de la basura, e.t.c.]]
roadVehicleIds = groupIds(485, 552, 431, 438, 437, 574, 420, 525, 408);

--[[! A esta clase pertenecen todos los vehiculos gubernamentales ]]
governmentVehicleIds = groupIds(416, 433, 427, 490, 528, 407, 544, 523, 470, 598, 
596, 597, 599, 432, 601, 428);

--[[! A esta clase pertenecen los vehículos de policía ]]
policeVehicleIds = groupIds(598, 596, 597, 599);

--[[! A esta clase pertenecen camiones utilitarios y vehiculos pesados ]]
heavyAndUtilityTruckIds = groupIds(499, 609, 498, 524, 532,
578, 486, 406, 573, 455, 588, 403, 514, 423, 414, 443, 515, 531, 456);

--[[! A esta clase pertenecen las camionetas ]]
vansAndLightTruckIds = groupIds(459, 422, 482, 605, 530, 418, 572, 582, 413,
440, 543, 583, 478, 554);

lowridersIds = groupIds(536, 575, 534, 567, 535, 576, 412);

muscleCarIds = groupIds(402, 542, 603, 475);

--[[! A esta clase pertenecen todos los trenes y vagonetas de tren ]]
trainsAndRailroadCarIds = groupIds(449, 537, 538, 570, 569, 590);

--[[! A esta clase pertenecen los vehiculos RC ]]
rcVehicleIds = groupIds(441, 464, 501, 465, 564);

--[[! A esta clase pertenecen todos los vehiculos recreacionales ]]
recreationalVehicleIds = groupIds(568, 424, 504, 457, 483, 508, 571, 500, 444, 
556, 557, 471, 495, 539);

--[[! A esta clase pertenecen todos los vehículos monster ]] 
monsterVehicleIds = groupIds(444, 556, 557);

streetRacerVehicleIds = groupIds(429, 541, 415, 480, 562, 565, 434, 494,
502, 503, 411, 559, 561, 560, 506, 451, 558, 555, 477);

suvsAndWagonVehicleIds = groupIds(579, 400, 404, 489, 505, 479, 442, 458);

--[[! A esta clase pertenecen todos los trailers ]]
trailerVehicleIds = groupIds(606, 607, 610, 611, 584, 608, 435, 450, 591);

--[[! Míscelanea ]]
miscVehicleIds = groupIds(594);


local vehicles;

--[[!
Esta función devuelve la id de un vehículo dando el nombre de este.
@param vehicleName Es el nombre del vehículo.
@return Devuelve la id del vehículo cuyo nombre es el especificado como parámetro
o false si no hay ningun vehículo con ese nombre.
]]
function getVehicleIdFromName(vehicleName)
	checkArgumentType("getVehicleIdFromName", 2, vehicleName, 1, "string");
	local vehicleId = table.find(vehicles, vehicleName);
	if not vehicleId then 
		return false;
	end;
	return vehicleId;
end;

--[[!
Está función devuelve el nombre de un vehículo sabiendo la id del mismo
@param vehicleId Es la id del vehículo
@return Devuelve el nombre del vehículo o false si la ID no corresponde a ninguna 
id de ningún vehículo.
]]
function getVehicleNameFromId(vehicleId) 
	checkArgumentType("getVehicleNameFromId", 2, vehicleId, 1, "number");
	local vehicleName = vehicles[vehicleId];
	if not vehicleName then
		return false;
	end;
	return vehicleName;
end;

vehicles = 
{
	[602] = "Alpha",
	[545] = "Hustler",
	[496] = "Blista Compact",
	[517] = "Majestic",
	[401] = "Bravura",
	[410] = "Manana",
	[518] = "Buccaneer",
	[600] = "Picador",
	[527] = "Cadrona",
	[436] = "Previon",
	[589] = "Club",
	[580] = "Stafford",
	[419] = "Esperanto",
	[439] = "Stallion",
	[533] = "Feltzer",
	[549] = "Tampa",
	[526] = "Fortune",
	[491] = "Virgo",
	[474] = "Hermes",
	[445] = "Admiral",
	[467] = "Oceanic",
	[604] = "Damaged Glendale",
	[426] = "Premier",
	[507] = "Elegant",
	[547] = "Primo",
	[585] = "Emperor",
	[405] = "Sentinel",
	[587] = "Euros",
	[409] = "Stretch",
	[466] = "Glendale",
	[550] = "Sunrise",
	[492] = "Greenwood",
	[566] = "Tahoma",
	[546] = "Intruder",
	[540] = "Vincent",
	[551] = "Merit",
	[421] = "Washington",
	[516] = "Nebula",
	[529] = "Willard",
	[592] = "Andromada",
	[553] = "Nevada",
	[577] = "AT-400",
	[488] = "News Chopper",
	[511] = "Beagle",
	[497] = "Police Maverick",
	[548] = "Cargobob",
	[563] = "Raindance",
	[512] = "Cropduster",
	[476] = "Rustler",
	[593] = "Dodo",
	[447] = "Seasparrow",
	[425] = "Hunter",
	[519] = "Shamal",
	[520] = "Hydra",
	[460] = "Skimmer",
	[417] = "Leviathan",
	[469] = "Sparrow",
	[487] = "Maverick",
	[513] = "Stuntplane",
	[581] = "BF-400",
	[510] = "Mountain Bike",
	[509] = "Bike",
	[522] = "NRG-500",
	[481] = "BMX",
	[461] = "PCJ-600",
	[462] = "Faggio",
	[448] = "Pizza Boy",
	[521] = "FCR-900",
	[468] = "Sanchez",
	[463] = "Freeway",
	[586] = "Wayfarer",
	[472] = "Coastguard",
	[473] = "Dinghy",
	[493] = "Jetmax",
	[595] = "Launch",
	[484] = "Marquis",
	[430] = "Predator",
	[453] = "Reefer",
	[452] = "Speeder",
	[446] = "Squalo",
	[454] = "Tropic",
	[485] = "Baggage",
	[552] = "Utility Van",
	[431] = "Bus",
	[438] = "Cabbie",
	[437] = "Coach",
	[574] = "Sweeper",
	[420] = "Taxi",
	[525] = "Towtruck",
	[408] = "Trashmaster",
	[416] = "Ambulance",
	[596] = "Police Car (Los Santos)",
	[433] = "Barracks",
	[597] = "Police Car (San Fierro)",
	[427] = "Enforcer",
	[599] = "Police Ranger",
	[490] = "FBI Rancher",
	[432] = "Rhino",
	[528] = "FBI Truck",
	[601] = "S.W.A.T.",
	[407] = "Fire Truck",
	[428] = "Securicar",
	[544] = "Fire Truck (Ladder)",
	[523] = "HPV1000",
	[470] = "Patriot",
	[598] = "Police Car (Las Venturas)",
	[499] = "Benson",
	[588] = "Hotdog",
	[609] = "Black Boxville",
	[403] = "Linerunner",
	[498] = "Boxville",
	[514] = "Tanker",
	[524] = "Cement Truck",
	[423] = "Mr. Whoopee",
	[532] = "Combine Harvester",
	[414] = "Mule",
	[578] = "DFT-30",
	[443] = "Packer",
	[486] = "Dozer",
	[515] = "Roadtrain",
	[406] = "Dumper",
	[531] = "Tractor",
	[573] = "Dune",
	[456] = "Yankee",
	[455] = "Flatbed",
	[459] = "Berkley's RC Van",
	[543] = "Sadler",
	[422] = "Bobcat",
	[583] = "Tug",
	[482] = "Burrito",
	[478] = "Walton",
	[605] = "Damaged Sadler",
	[554] = "Yosemite",
	[530] = "Forklift",
	[418] = "Moonbeam",
	[572] = "Mower",
	[582] = "News Van",
	[413] = "Pony",
	[440] = "Rumpo",
	[536] = "Blade",
	[575] = "Broadway",
	[534] = "Remington",
	[567] = "Savanna",
	[535] = "Slamvan",
	[576] = "Tornado",
	[412] = "Voodoo",
	[402] = "Buffalo",
	[542] = "Clover",
	[603] = "Phoenix",
	[475] = "Sabre",
	[449] = "Tram",
	[537] = "Freight",
	[538] = "Brown Streak",
	[570] = "Brown Streak Carriage",
	[569] = "Flat Freight",
	[590] = "Box Freight",
	[441] = "RC Bandit",
	[464] = "RC Baron",
	[501] = "RC Goblin",
	[465] = "RC Raider",
	[564] = "RC Tiger",
	[568] = "Bandito",
	[557] = "Monster 3",
	[424] = "BF Injection",
	[471] = "Quadbike",
	[504] = "Bloodring Banger",
	[495] = "Sandking",
	[457] = "Caddy",
	[539] = "Vortex",
	[483] = "Camper",
	[508] = "Journey",
	[571] = "Kart",
	[500] = "Mesa",
	[444] = "Monster",
	[556] = "Monster 2",
	[429] = "Banshee",
	[411] = "Infernus",
	[541] = "Bullet",
	[559] = "Jester",
	[415] = "Cheetah",
	[561] = "Stratum",
	[480] = "Comet",
	[560] = "Sultan",
	[562] = "Elegy",
	[506] = "Super GT",
	[565] = "Flash",
	[451] = "Turismo",
	[434] = "Hotknife",
	[558] = "Uranus",
	[494] = "Hotring Racer",
	[555] = "Windsor",
	[502] = "Hotring Racer 2",
	[477] = "ZR-350",
	[503] = "Hotring Racer 3",
	[579] = "Huntley",
	[400] = "Landstalker",
	[404] = "Perennial",
	[489] = "Rancher",
	[505] = "Rancher (From \"Lure\")",
	[479] = "Regina",
	[442] = "Romero",
	[458] = "Solair",
	[606] = "Baggage Trailer (covered)",
	[607] = "Baggage Trailer (Uncovered)",
	[610] = "Farm Trailer",
	[611] = "\"Street Clean\" Trailer",
	[584] = "Trailer (From \"Tanker Commando\")(*PRONE TO CRASHES*)",
	[608] = "Trailer (Stairs)",
	[435] = "Trailer 1",
	[450] = "Trailer 2",
	[591] = "Trailer 3",
	[594] = "RC Cam (flower pot)",

};
