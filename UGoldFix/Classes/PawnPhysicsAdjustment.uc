class PawnPhysicsAdjustment expands UGoldFixServerInfo;

var Pawn ControlledPawn;
var EPhysics AdjustedPawnPhysics;

function SetPawnAdjustment(Pawn P, EPhysics AdjustedPhysics, float Interval, bool bLoop)
{
	ControlledPawn = P;
	AdjustedPawnPhysics = AdjustedPhysics;
	SetTimer(Interval, bLoop);
}

function Timer()
{
	if (ControlledPawn.Physics == PHYS_None)
		ControlledPawn.SetPhysics(AdjustedPawnPhysics);
}

defaultproperties
{
}
