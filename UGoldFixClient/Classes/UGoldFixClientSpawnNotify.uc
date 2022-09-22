class UGoldFixClientSpawnNotify expands SpawnNotify;

event Actor SpawnNotification(Actor A)
{
	A.bNetInterpolatePos = false;
	return A;
}

defaultproperties
{
	bHidden=True
}
