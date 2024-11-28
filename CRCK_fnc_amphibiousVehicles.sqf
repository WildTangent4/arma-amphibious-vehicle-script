params ["_vehicle", "_boat"]//note "_boat" is a temporary variable for testing and should be generated via script when this project is complete

CRCK_fnc_moveForward = {
    if (speed _boat < 25)then{
        _boat addForce [_boat vectorModelToWorld [0,1000*diag_deltaTime,0], [1,0,0]];
    }
}

CRCK_fnc_steer = {
    params ["_dir"];//number, either -1 (turns left) or 1 (turns right)
    _boat addTorque (_boat vectorModelToWorld [0,0,(150*speed _boat*diag_deltaTime*_dir)]);
}

[_vehicle,_boat] call BIS_fnc_attachToRelative;

onEachFrame {
    //TODO: capture player inputs
    
    //TODO: apply inputs to boat

    
}
