class FallingMoverController expands Info;

var int KeyMovementBitmask; // 0 - falling, 1 - moving linearly

var Mover Mover;

var float GravityZ;
var int CurrentKey;
var float MoveTime;

replication
{
	reliable if (Role == ROLE_Authority)
		KeyMovementBitmask, GravityZ;

	reliable if (Role == ROLE_Authority && bNetInitial)
		CurrentKey, MoveTime;
}

event BeginPlay()
{
	Mover = Mover(Owner);
	if (Mover == none)
	{
		Log("Warning: none mover is assigned to" @ Class);
		return;
	}

	Mover.Tag = '';
	Mover.ClientUpdate = -1; // disables MoverMovementSynchronizer in UGoldFix
}

simulated event PostNetReceive()
{
	if (GravityZ > 0)
		GotoState('MoverFalling');
}

function Trigger(Actor A, Pawn EventInstigator)
{
	Mover = Mover(Owner);
	if (Mover == none)
		return;

	Instigator = EventInstigator;

	if (Mover.DelayTime <= 0)
		GotoState('MoverFalling');
	else
		GotoState('DelayMoverFalling');
}

simulated function UpdateMoverPosition(float DeltaTime)
{
	local float DeltaT;

	Mover = Mover(Owner);
	if (Mover == none)
		return;

	if (CurrentKey >= Mover.NumKeys - 1) // may be true for clients that connected to the server lately
	{
		MoveToEndPosition();
		GotoState('Finished');
		return;
	}

	MoveTime += DeltaTime;

	if ((KeyMovementBitmask & (1 << CurrentKey)) != 0)
		DeltaT = UpdateMoverPositionLinearly(DeltaTime);
	else
		DeltaT = UpdateMoverPositionAsFalling(DeltaTime);

	if (DeltaT == 1)
	{
		CurrentKey++;
		MoveTime = 0;
	}
	if (CurrentKey >= Mover.NumKeys - 1)
		GotoState('Finished');
}

simulated function float UpdateMoverPositionLinearly(float DeltaTime)
{
	local float DeltaT;
	local vector NewLocation;
	local rotator NewRotation;

	DeltaT = FMin(1, MoveTime / FMax(0.1, Mover.MoveTime));

	NewLocation = (Mover.KeyPos[CurrentKey + 1] - Mover.KeyPos[CurrentKey]) * DeltaT;
	NewLocation += Mover.BasePos + Mover.KeyPos[CurrentKey];
	NewRotation = (Mover.KeyRot[CurrentKey + 1] - Mover.KeyRot[CurrentKey]) * DeltaT;
	NewRotation += Mover.BaseRot + Mover.KeyRot[CurrentKey];

	Mover.Move(NewLocation - Mover.Location);
	Mover.SetRotation(NewRotation);

	return DeltaT;
}

simulated function float UpdateMoverPositionAsFalling(float DeltaTime)
{
	local float MaxOffsetZ;
	local float MaxMoveTime;
	local float DeltaZ;
	local float DeltaT;
	local vector NewLocation;
	local rotator NewRotation;

	if (GravityZ <= 0)
		return 1;

	MaxOffsetZ = Mover.KeyPos[CurrentKey + 1].Z - Mover.KeyPos[CurrentKey].Z;
	MaxMoveTime = Sqrt(2 * Abs(MaxOffsetZ) / GravityZ);

	if (MaxMoveTime > 0)
	{
		DeltaZ = FMin(1, (MoveTime / MaxMoveTime) ** 2);
		DeltaT = FMin(1, MoveTime / MaxMoveTime);
	}
	else
	{
		DeltaT = 1;
		DeltaZ = 1;
	}

	NewLocation = (Mover.KeyPos[CurrentKey + 1] - Mover.KeyPos[CurrentKey]) * DeltaT;
	NewLocation.Z = MaxOffsetZ * DeltaZ;
	NewLocation += Mover.BasePos + Mover.KeyPos[CurrentKey];
	NewRotation = (Mover.KeyRot[CurrentKey + 1] - Mover.KeyRot[CurrentKey]) * DeltaT;
	NewRotation += Mover.BaseRot + Mover.KeyRot[CurrentKey];

	Mover.Move(NewLocation - Mover.Location);
	Mover.SetRotation(NewRotation);

	return DeltaT;
}

simulated function MoveToEndPosition()
{
	Mover.Move(Mover.BasePos + Mover.KeyPos[Mover.NumKeys - 1] - Mover.Location);
	Mover.SetRotation(Mover.BaseRot + Mover.KeyRot[Mover.NumKeys - 1]);
}

state DelayMoverFalling
{
	ignores Trigger;

	event BeginState()
	{
		SetTimer(Mover.DelayTime, false);
	}

	event Timer()
	{
		GotoState('MoverFalling');
	}
}

state MoverFalling
{
	ignores PostNetReceive, Trigger;

	event BeginState()
	{
		GravityZ = Abs(Mover.Region.Zone.ZoneGravity.Z);
		Mover.PlaySound(Mover.OpeningSound, SLOT_None);
		Mover.AmbientSound = Mover.MoveAmbientSound;
	}

	event EndState()
	{
		Mover.AmbientSound = none;
	}

	simulated event Tick(float DeltaTime)
	{
		UpdateMoverPosition(DeltaTime);
	}
}

state Finished
{
	ignores PostNetReceive, Trigger;

	event BeginState()
	{
		Mover.PlaySound(Mover.OpenedSound, SLOT_None);
		if (Mover.Event != '')
			TriggerEvent(Mover.Event, Mover, Instigator);
	}
}

defaultproperties
{
	bAlwaysRelevant=True
	bNetNotify=True
	RemoteRole=ROLE_SimulatedProxy
}
