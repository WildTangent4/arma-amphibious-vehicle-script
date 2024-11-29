params ["_vehicle"];
//function assumes it is executed locally and not on the server itself

LEFT = -1; 
RIGHT = 1;

CRCK_fnc_summonVirtualBoat = { 
    _boat = "B_G_Boat_Transport_01_F" createVehicle position vehicle player; 
    _boat setVectorDirAndUp [vectorDir vehicle player,vectorUp vehicle player];

    _boat setPosATL [getPosATL vehicle player#0,getPosATL vehicle player#1,getPosATL vehicle player#2+0.2];//sometimes create vehicle does not use exact positions 
    vehicle player attachTo [_boat];
    //_boat allowDamage false;
    //hideObject _boat; 
    
    _boat 
};

CRCK_fnc_moveForward = {
    params ["_vehicle"]; 
    if (speed _vehicle < 30)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,1200*diag_deltaTime,0], [0,0,0]]; 
    };
};

CRCK_fnc_steer = { 
    params ["_vehicle","_dir"];
    _vehicle addTorque (_vehicle vectorModelToWorld [0,0,(500*speed _vehicle*diag_deltaTime*_dir)]); 
}; 
 
CRCK_fnc_break = { 
    params ["_vehicle"]; 
    if (speed _vehicle > 0)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,-1000*diag_deltaTime,0], [0,0,0]]; 
    };
    if (speed _vehicle < 0)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,1000*diag_deltaTime,0], [0,0,0]]; 
    };
}; 

CRCK_fnc_reverse = { 
    params ["_vehicle"]; 
    if (speed _vehicle > -22)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,-900*diag_deltaTime,0], [0,0,0]]; 
    };
}; 

inWaterLastFrame = false;//this public variable is bad, but needed to pass data into the onEachFrame
spawnedBoat = player;
onEachFrame { 
    if (vehicle player != player && driver vehicle player == player)then{
        _engineHp = vehicle player getHit "motor"; 
        _inWater = (getPosASLW vehicle player)#2<-0.3;// && (!isTouchingGround spawnedBoat || spawnedBoat==player); //waterDamaged vehicle player;
        vehicle player setHit ["motor", _engineHp];

        if(_inWater==true&&inWaterLastFrame==false)then{
            spawnedBoat = call CRCK_fnc_summonVirtualBoat;
            systemChat "player entered water";
        };
        if(_inWater)then{systemChat "splish splash";
            if (inputAction "CarForward">0)then{ 
                [spawnedBoat] call CRCK_fnc_moveForward; 
            };
            if (inputAction "CarBreak">0)then{ 
                [spawnedBoat] call CRCK_fnc_break; 
            };
            if (inputAction "CarBack">0)then{ 
                [spawnedBoat] call CRCK_fnc_reverse; 
            };    
            if (inputAction "CarLeft">0)then{ 
                [spawnedBoat, LEFT] call CRCK_fnc_steer; 
            } ;
            if (inputAction "CarRight">0)then{ 
                [spawnedBoat, RIGHT] call CRCK_fnc_steer; 
            };
        }else{
            systemchat "all dry";
        };
        if(_inWater==false&&inWaterLastFrame==true)then{
            vehicle player allowDamage false;
            detach vehicle player;
            deleteVehicle spawnedBoat;
            spawnedBoat = player;
            vehicle player setPosATL [(getPosATL vehicle player)#0,(getPosATL vehicle player)#1,(getPosATL vehicle player)#2 + 0.5];
            vehicle player allowDamage true;
            systemChat "player left water";
        };

        inWaterLastFrame = _inWater;
    }
}
