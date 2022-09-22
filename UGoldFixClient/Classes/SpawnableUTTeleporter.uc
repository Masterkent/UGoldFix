class SpawnableUTTeleporter expands SpawnableTeleporter;

static function SpawnableUTTeleporter StaticReplaceUTTeleporter(Teleporter OldTelep, optional bool bNoChangesYaw)
{
	local SpawnableUTTeleporter NewTelep;

	if (OldTelep == none)
		return none;

	NewTelep = OldTelep.Spawn(class'SpawnableUTTeleporter',, OldTelep.Tag);
	if (NewTelep == none)
		return none;

	NewTelep.ReplaceTeleporter(OldTelep);
	NewTelep.bChangesYaw = !bNoChangesYaw;
	return NewTelep;
}

// Accept an actor that has teleported in.
function bool Accept(Actor Incoming)
{
	return UTF_Accept(Incoming, none);
}

function bool UTF_Accept(Actor Incoming, Actor Source)
{
	local rotator newRot, newVelRot;
	local int oldVelYaw;
	local Pawn P;

	// Move the actor here.
	Disable('Touch');
	//log("Move Actor here "$tag);
	newRot = Incoming.Rotation;
	if (bChangesYaw)
	{
		newVelRot = rotator(Incoming.Velocity);
		oldVelYaw = newVelRot.Yaw;
		newVelRot.Yaw = Rotation.Yaw;
		newRot.Yaw = Rotation.Yaw;
		if (Source != none)
		{
			newRot.Yaw += (32768 + Incoming.Rotation.Yaw - Source.Rotation.Yaw);
			newVelRot.Yaw += (32768 + oldVelYaw - Source.Rotation.Yaw);
		}
	}

	if (Pawn(Incoming) != none)
	{
		for (P = Level.PawnList; P != none; P = P.nextPawn)
		{
			if (P.Enemy == Incoming)
				P.LastSeenPos = Incoming.Location; 
		}

		if (!Pawn(Incoming).SetLocation(Location))
		{
			Enable('Touch');
			return false;
		}
		Pawn(Incoming).SetRotation(newRot);
		Pawn(Incoming).ClientSetRotation(newRot);
		Pawn(Incoming).ViewRotation = newRot;
		Pawn(Incoming).MoveTimer = -1.0;
		Pawn(Incoming).MoveTarget = self;
		PlayTeleportEffect(Incoming, true);

		if (bChangesVelocity && (Incoming.Physics == PHYS_Walking || Incoming.Physics == PHYS_None) && !Incoming.Region.Zone.bWaterZone)
			Incoming.SetPhysics(PHYS_Falling);
	}
	else
	{
		if (!Incoming.SetLocation(Location))
		{
			Enable('Touch');
			return false;
		}
		if (bChangesYaw)
			Incoming.SetRotation(newRot);
	}

	Enable('Touch');


	if (bChangesVelocity)
		Incoming.Velocity = TargetVelocity;
	else
	{
		if (bChangesYaw)
		{
			if (Incoming.Physics == PHYS_Walking)
				newVelRot.Pitch = 0;
			Incoming.Velocity = VSize(Incoming.Velocity) * vector(newVelRot);
		} 
		if (bReversesX)
			Incoming.Velocity.X *= -1.0;
		if (bReversesY)
			Incoming.Velocity.Y *= -1.0;
		if (bReversesZ)
			Incoming.Velocity.Z *= -1.0;
	}

	return true;
}

static function bool UTSF_Accept(Teleporter Dest, Actor Incoming, Actor Source)
{
	if (SpawnableUTTeleporter(Dest) != none)
		return SpawnableUTTeleporter(Dest).UTF_Accept(Incoming, Source);
	return Dest.Accept(Incoming);
}

// Teleporter was touched by an actor.
event Touch(Actor Other)
{
	local Teleporter Dest;
	local int i;
	local Actor A;

	if (!bEnabled)
		return;

	if (Other.bCanTeleport && !Other.PreTeleport(self))
	{
		if (InStr(URL, "/") >= 0 || InStr(URL, "#") >= 0)
		{
			// Teleport to a level on the net.
			if (PlayerPawn(Other) != none)
				Level.Game.SendPlayer(PlayerPawn(Other), URL);
		}
		else
		{
			// Teleport to a random teleporter in this local level, if more than one pick random.

			foreach AllActors(class'Teleporter', Dest)
				if (string(Dest.Tag) ~= URL && Dest != self)
					i++;
			i = rand(i);
			foreach AllActors(class'Teleporter', Dest)
				if (string(Dest.Tag) ~= URL && Dest != self && i-- == 0)
					break;
			if (Dest != none)
			{
				// Teleport the actor into the other teleporter.
				if (Other.bIsPawn)
					PlayTeleportEffect(Pawn(Other), false);
				UTSF_Accept(Dest, Other, self);
				if (Event != '' && Other.bIsPawn)
					foreach AllActors(class'Actor', A, Event)
						A.Trigger(Other, Other.Instigator);
			}
			else
				Pawn(Other).ClientMessage("Teleport destination for " $ self $ " not found!");
		}
	}
}
