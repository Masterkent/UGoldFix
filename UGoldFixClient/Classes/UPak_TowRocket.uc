class UPak_TowRocket expands UPak_UPakRocket;

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode == NM_Client)
		ClientSyncMovement();
	else
	{
		if (Pawn(Owner) != none && Pawn(Owner).Health <= 0)
			SetOwner(none);
		AdjustRocketRotation();

		Velocity = VSize(Velocity) * Vector(Rotation);
		if (!Region.Zone.bWaterZone)
		{
			Acceleration = Vector(Rotation) * 50;
			if (AnimSequence != 'Fly')
				LoopAnim('Fly');
		}
		else if (AnimSequence != 'Wings')
			LoopAnim('Wings');

		if (!Region.Zone.bWaterZone && VSize(Velocity) < InitialSpeed)
			Velocity = Normal(Velocity) * InitialSpeed;
		else if (VSize(Velocity) < InitialSpeed * 0.36)
			Velocity = Normal(Velocity) * InitialSpeed * 0.36;

		if (Region.Zone.bWaterZone)
			AmbientSound = WaterAmbSound;
		else
			AmbientSound = AirAmbSound;

		SyncMovement();
	}

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (Level.NetMode == NM_Client && bNetOwner)
		AdjustRocketRotation();

	MakeRocketTrail(DeltaTime);
}

simulated function AdjustRocketRotation()
{
	local rotator newRot;

	if (Pawn(Owner) != none)
	{
		newRot = Pawn(Owner).ViewRotation;
		newRot.Roll = Rotation.Roll;
		SetRotation(newRot);
	}
}

defaultproperties
{
	MomentumTransfer=9500
	bFixedRotationDir=False
	bTimerSync=False
}
