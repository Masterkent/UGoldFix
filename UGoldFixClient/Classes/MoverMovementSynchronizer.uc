class MoverMovementSynchronizer expands Info;

var Mover ControlledMover;
var bool bMoverInterpolating;
var float MoverPhysAlpha, PriorMoverPhysAlpha;
var float MoverPhysRate;
var bool bChangedPos;

var rotator LastMoverRotation;
var int MoverRotPitch, MoverRotYaw, MoverRotRoll;
var int MoverRotRatePitch, MoverRotRateYaw, MoverRotRateRoll;
var float ServerTimestamp, InitialServerTimestamp;
var float NextSyncTimestamp;
var float LastServerTimestamp, ClientServerTimestampDiff;
var float LastClientFullSyncTimestamp;
var float TimeSeconds;

var bool bIsInitialized;

replication
{
	reliable if (Role == ROLE_Authority)
		ControlledMover,
		bMoverInterpolating,
		MoverPhysRate,
		MoverRotPitch, MoverRotYaw, MoverRotRoll,
		MoverRotRatePitch, MoverRotRateYaw, MoverRotRateRoll,
		ServerTimestamp;

	reliable if (Role == ROLE_Authority && bNetInitial)
		InitialServerTimestamp;

	reliable if (Role == ROLE_Authority && (bNetInitial || ShouldReplicatePhysAlpha()))
		MoverPhysAlpha;

	reliable if (Role == ROLE_Authority && bNetInitial)
		bChangedPos;
}

simulated event Tick(float DeltaTime)
{
	TimeSeconds += DeltaTime; // does not change when the game is paused
	UpdateMover();
}

simulated function UpdateMover()
{
	if (ControlledMover != none)
	{
		if (Level.NetMode != NM_Client)
			Server_UpdateMover();
		else
			Client_UpdateMover();
	}
}

simulated function InitMover()
{
	if (bChangedPos)
	{
		if (ControlledMover.PrevKeyNum == ControlledMover.KeyNum)
			return;
		if (MoverPhysAlpha == 0)
			MoverPhysAlpha = 1;
		ControlledMover.PhysAlpha = MoverPhysAlpha;
	}
	bIsInitialized = true;
}

function Server_UpdateMover()
{
	bMoverInterpolating = ControlledMover.bInterpolating;
	PriorMoverPhysAlpha = MoverPhysAlpha;
	MoverPhysAlpha = ControlledMover.PhysAlpha;
	MoverPhysRate = ControlledMover.PhysRate;
	bChangedPos = MoverChangedPos(int(ControlledMover.SimInterpolate.Z));

	if (ControlledMover.Class == class'RotatingMover')
	{
		InitialServerTimestamp = TimeSeconds;

		if (MakeRotatorValue(MoverRotRatePitch, MoverRotRateYaw, MoverRotRateRoll) != GetRotateRate() ||
			ServerTimestamp == 0 ||
			NextSyncTimestamp < TimeSeconds && bool(GetRotateRate()))
		{
			SplitRotatorValue(ControlledMover.Rotation, MoverRotPitch, MoverRotYaw, MoverRotRoll);
			SplitRotatorValue(GetRotateRate(), MoverRotRatePitch, MoverRotRateYaw, MoverRotRateRoll);
			ServerTimestamp = TimeSeconds;
			NextSyncTimestamp = ServerTimestamp + 1 + FRand();
		}

		LastMoverRotation = ControlledMover.Rotation;
	}

	NetPriority = ControlledMover.NetPriority;
}

simulated function Client_UpdateMover()
{
	local float DeltaTime;

	if (!bIsInitialized)
		InitMover();
	if (!bMoverInterpolating && 0 < MoverPhysAlpha && MoverPhysAlpha < 1)
 	{
		if (ControlledMover.PhysRate != 0)
		{
			ControlledMover.PhysRate = 0;
			ControlledMover.PhysAlpha = MoverPhysAlpha;
		}
		else
			ControlledMover.bInterpolating = false;
	}
	else if (bMoverInterpolating ||
		0 < ControlledMover.PhysAlpha && ControlledMover.PhysAlpha < 1 && (MoverPhysAlpha == 0 || MoverPhysAlpha == 1))
	{
		ControlledMover.bInterpolating = true;
		ControlledMover.bMovable = true; // false value may cause client hanging
		ControlledMover.PhysRate = MoverPhysRate;
	}

	if (ControlledMover.Class == class'RotatingMover')
	{
		if (ServerTimestamp != LastServerTimestamp)
		{
			LastServerTimestamp = ServerTimestamp;

			if (ClientServerTimestampDiff >= TimeSeconds - ServerTimestamp ||
				TimeSeconds - LastClientFullSyncTimestamp > 30)
			{
				ClientServerTimestampDiff = TimeSeconds - FMax(ServerTimestamp, InitialServerTimestamp);
				ControlledMover.SetRotation(MakeRotatorValue(MoverRotPitch, MoverRotYaw, MoverRotRoll));
				LastClientFullSyncTimestamp = TimeSeconds;
				return;
			}
		}

		DeltaTime = TimeSeconds - (ServerTimestamp + ClientServerTimestampDiff);
		ControlledMover.SetRotation(
			MakeRotatorValue(MoverRotPitch, MoverRotYaw, MoverRotRoll) +
				MakeRotatorValue(MoverRotRatePitch, MoverRotRateYaw, MoverRotRateRoll) * DeltaTime);
	}
}

function bool ShouldReplicatePhysAlpha()
{
	if (!bMoverInterpolating ||
		MoverPhysAlpha <= 0 || MoverPhysAlpha >= 1 ||
		PriorMoverPhysAlpha <= 0 || PriorMoverPhysAlpha >= 1)
	{
		return true;
	}
	return false;
}

static function bool MoverChangedPos(int SimInterpolateZ)
{
	return (SimInterpolateZ >> 8) != (SimInterpolateZ & 0xFF);
}

static function rotator MakeRotatorValue(int Pitch, int Yaw, int Roll)
{
	local rotator Result;

	Result.Pitch = Pitch;
	Result.Yaw = Yaw;
	Result.Roll = Roll;
	return Result;
}

static function SplitRotatorValue(rotator R, out int Pitch, out int Yaw, out int Roll)
{
	Pitch = R.Pitch;
	Yaw = R.Yaw;
	Roll = R.Roll;
}

function rotator GetRotateRate()
{
	if (ControlledMover.Rotation == LastMoverRotation)
		return rot(0, 0, 0);
	return RotatingMover(ControlledMover).RotateRate + ControlledMover.RotationRate;
}

defaultproperties
{
	bAlwaysRelevant=True
	RemoteRole=ROLE_SimulatedProxy
	LastClientFullSyncTimestamp=-1000000
}
