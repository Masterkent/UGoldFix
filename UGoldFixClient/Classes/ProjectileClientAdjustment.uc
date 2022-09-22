class ProjectileClientAdjustment expands Info;

var Projectile ControlledProjectile;

struct ReplicatedVector
{
	var float X, Y, Z;
};

var ReplicatedVector SyncLocation;
var vector SyncVelocity;
var vector SyncAcceleration;
var EPhysics SyncPhysics;

var float SyncTimestamp;
var float ClientServerTimestampDiff;
var float NextFullSyncTimestamp;

replication
{
	reliable if (Role == ROLE_Authority)
		ControlledProjectile,
		SyncTimestamp;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity,
		SyncAcceleration,
		SyncPhysics;
}

simulated event PostNetBeginPlay()
{
	SyncTimestamp = 0;
}

simulated function Tick(float DeltaTime)
{
	if (Level.NetMode != NM_Standalone && ControlledProjectile != none)
	{
		Server_UpdateMovement();
		Client_UpdateMovement();
	}
}

function Server_UpdateMovement()
{
	if (ControlledProjectile == none || ControlledProjectile.bDeleteMe)
	{
		Destroy();
		return;
	}

	SyncLocation.X = ControlledProjectile.Location.X;
	SyncLocation.Y = ControlledProjectile.Location.Y;
	SyncLocation.Z = ControlledProjectile.Location.Z;
	SyncVelocity = ControlledProjectile.Velocity;
	SyncAcceleration = ControlledProjectile.Acceleration;
	SyncPhysics = ControlledProjectile.Physics;
	SyncTimestamp = Level.TimeSeconds;
}

simulated function Client_UpdateMovement()
{
	local float TimestampDiff;
	local vector ProjLocation;

	if (Level.NetMode != NM_Client || SyncTimestamp == 0)
		return;

	ProjLocation.X = SyncLocation.X;
	ProjLocation.Y = SyncLocation.Y;
	ProjLocation.Z = SyncLocation.Z;
	ControlledProjectile.SetLocation(ProjLocation);
	ControlledProjectile.Velocity = SyncVelocity;
	ControlledProjectile.Acceleration = SyncAcceleration;
	if (ControlledProjectile.Physics != SyncPhysics)
		ControlledProjectile.SetPhysics(SyncPhysics);

	TimestampDiff = Level.TimeSeconds - SyncTimestamp;
	if (Level.TimeSeconds >= NextFullSyncTimestamp)
	{
		ClientServerTimestampDiff = TimestampDiff;
		NextFullSyncTimestamp = Level.TimeSeconds + 10;
	}
	else if (ClientServerTimestampDiff > TimestampDiff)
		ClientServerTimestampDiff = TimestampDiff;
	else if (ClientServerTimestampDiff < TimestampDiff)
		ControlledProjectile.AutonomousPhysics(TimestampDiff - ClientServerTimestampDiff);

	SyncTimestamp = 0;
}

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	RemoteRole=ROLE_SimulatedProxy
}
