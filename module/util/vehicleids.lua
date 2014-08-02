--[[!
	\file
	\brief Este script contiene grupos de IDs que nos permiten categorizar, clasificar
	vehiculos.
]]

loadModule("util/groupids"); 

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
