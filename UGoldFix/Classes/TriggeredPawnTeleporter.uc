class TriggeredPawnTeleporter expands UGoldFixServerInfo;

var Pawn ControlledPawn;

function Trigger(Actor Other, Pawn EventInstigator)
{
	if (ControlledPawn != none)
		MoveControlledPawnLocation();
}

function MoveControlledPawnLocation()
{
	local bool bPawnCollideActors;
	local bool bPawnBlockActors;
	local bool bPawnBlockPlayers;

	bPawnCollideActors = ControlledPawn.bCollideActors;
	bPawnBlockActors = ControlledPawn.bBlockActors;
	bPawnBlockPlayers = ControlledPawn.bBlockPlayers;

	ControlledPawn.SetCollision(false, false, false);
	ControlledPawn.SetLocation(Location);
	ControlledPawn.SetCollision(bPawnCollideActors, bPawnBlockActors, bPawnBlockPlayers);
}

defaultproperties
{
}
