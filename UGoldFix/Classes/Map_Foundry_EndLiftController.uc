class Map_Foundry_EndLiftController expands UGoldFixServerInfo;

var private Mover Lift;
var private bool bNoPrematureReturn;

function Initialize(MapFixServer MapFix)
{
	Lift = MapFix.LoadLevelMover("Mover125");
	Tag = Lift.Tag;
	Lift.Tag = Lift.name;
	Lift.MoverEncroachType = ME_IgnoreWhenEncroach;
}

function Trigger(Actor A, Pawn EventInstigator)
{
	if (Lift == none)
		return;
	if (!Lift.bInterpolating)
	{
		if (!class'MoverStateSensor'.static.MoverIsClosingOrClosed(lift))
			bNoPrematureReturn = false;
		Lift.Trigger(A, EventInstigator);
		return;
	}
	if (bNoPrematureReturn || class'MoverStateSensor'.static.MoverIsClosingOrClosed(lift))
		return;
	Lift.Trigger(A, EventInstigator);
	bNoPrematureReturn = true;
}
