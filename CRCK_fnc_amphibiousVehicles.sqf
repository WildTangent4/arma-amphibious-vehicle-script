params ["_vehicle", "_boat"];
//function assumes it is executed locally and not on the server itself

LEFT = -1; 
RIGHT = 1;

vehicle player attachTo [boat];

CRCK_fnc_moveForward = {
    params ["_vehicle"]; 
    if (speed _vehicle < 25)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,900*diag_deltaTime,0], [0,0,0]]; 
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
_inWaterLastFrame = surfaceIsWater position player;
onEachFrame { 
    
    _inWater = surfaceIsWater position player;

    if(_inWater==true&&_inWaterLastFrame==false){

    }
    if(_inWater){
        if (inputAction "CarForward">0)then{ 
            [_boat] call CRCK_fnc_moveForward; 
        };
        if (inputAction "CarBreak">0)then{ 
            [_boat] call CRCK_fnc_break; 
        };
        if (inputAction "CarBack">0)then{ 
            [_boat] call CRCK_fnc_reverse; 
        };    
        if (inputAction "CarLeft">0)then{ 
            [_boat, LEFT] call CRCK_fnc_steer; 
        } ;
        if (inputAction "CarRight">0)then{ 
            [_boat, RIGHT] call CRCK_fnc_steer; 
        };
    }
    _inWaterLastFrame = _inWater;
}
