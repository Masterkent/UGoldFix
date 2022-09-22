class AIPawnTriggerInfo expands UGoldFixServerInfo;

var Mover AssociatedMover;

function Tick(float DeltaTime)
{
	if (Instigator != none && Instigator.Health > 0 && AssociatedMover != none)
	{
		if (AssociatedMover.bOpening || AssociatedMover.bDelaying)
		{
			Instigator.HitWall(
				Normal(Instigator.Location - AssociatedMover.Location),
				AssociatedMover);
			Destroy();
		}
	}
	else
		Destroy();
}

defaultproperties
{
	LifeSpan=0.5
}
