params ["_vehicle", "_boat"]//note "_boat" is a temporary variable for testing and should be generated via script when this project is complete

[_vehicle,_boat] call BIS_fnc_attachToRelative;

onEachFrame {
    //TODO: capture player inputs
    
    //TODO: apply inputs to boat

    if (speed _boat < 25)then{
        _boat addForce [_boat vectorModelToWorld [0,1000*diag_deltaTime,0], [1,0,0]];
    }
}