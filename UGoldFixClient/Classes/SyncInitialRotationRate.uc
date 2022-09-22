class SyncInitialRotationRate expands UGoldFixInfo;

var int RotRatePitch, RotRateYaw, RotRateRoll;

replication
{
	reliable if (Role == ROLE_Authority)
		RotRatePitch, RotRateYaw, RotRateRoll;
}

event BeginPlay()
{
	if (Owner == none)
	{
		Destroy();
		return;
	}
	RotRatePitch = Owner.RotationRate.Pitch;
	RotRateYaw = Owner.RotationRate.Yaw;
	RotRateRoll = Owner.RotationRate.Roll;
}

simulated event PostNetBeginPlay()
{
	if (Level.NetMode != NM_Client)
		return;

	if (Owner != none)
	{
		Owner.RotationRate.Pitch = RotRatePitch;
		Owner.RotationRate.Yaw = RotRateYaw;
		Owner.RotationRate.Roll = RotRateRoll;
	}

	Destroy();
}

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
}
