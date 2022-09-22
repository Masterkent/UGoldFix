class SpawnablePlayerStart expands PlayerStart;

var() vector NextLocation;
var() rotator NextRotation;

event Trigger(Actor Other, Pawn EventInstigator)
{
	Spawn(class'SpawnablePlayerStart',,, NextLocation, NextRotation);
	Destroy();
}

defaultproperties
{
	bStatic=False
}
