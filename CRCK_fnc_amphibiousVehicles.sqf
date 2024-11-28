params ["_vehicle", "_boat"]//note "_boat" is a temporary variable for testing and should be generated via script when this project is complete

LEFT = -1; 
RIGHT = 1; 

CRCK_fnc_moveForward = {
    params ["_vehicle"]; 
    if (speed _vehicle < 25)then{ 
        _vehicle addForce [_vehicle vectorModelToWorld [0,1000*diag_deltaTime,0], [1,0,0]]; 
    } 
}; 
 
CRCK_fnc_steer = { 
    params ["_vehicle","_dir"];//number, either -1 (turns left) or 1 (turns right) 
    _vehicle addTorque (_vehicle vectorModelToWorld [0,0,(150*speed _vehicle*diag_deltaTime*_dir)]); 
}; 
 
[_vehicle,_boat] call BIS_fnc_attachToRelative; 
 
onEachFrame { 
    if (inputAction "CarForward">0)then{ 
        [_boat] call CRCK_fnc_moveForward; 
    };
    if (inputAction "CarLeft">0)then{ 
        [_boat, LEFT] call CRCK_fnc_steer; 
    } ;
    if (inputAction "CarRight">0)then{ 
        [_boat, RIGHT] call CRCK_fnc_steer; 
    }; 
} 
