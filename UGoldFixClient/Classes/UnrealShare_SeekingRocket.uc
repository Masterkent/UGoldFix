class UnrealShare_SeekingRocket expands SeekingRocket;
// Full Copy of UnrealShare_Rocket, except for the base class

struct ReplicatedVector
{
	var float X, Y, Z;
};

var float InitialSpeed;
var UGoldFixBase UGoldFix;

var bool bSyncPos;
var ReplicatedVector SyncLocation;
var vector SyncVelocity;
var float SyncTimestamp;
var float ClientServerTimestampDiff;
var float NextFullSyncTimestamp;

replication
{
	reliable if (Role == ROLE_Authority)
		InitialSpeed,
		SyncTimestamp;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity;
}

simulated event PostNetBeginPlay()
{
	SyncTimestamp = 0;
}

simulated event Tick(float DeltaTime)
{
	if (Region.Zone.bWaterZone)
	{
		if (VSize(Velocity) < InitialSpeed * 0.36)
		{
			Velocity = Normal(Velocity) * InitialSpeed * 0.36;
			Acceleration = vect(0, 0, 0);
			bSyncPos = true;
		}
		else
			Acceleration = Normal(Velocity) * VSize(Acceleration);
	}
	else
	{
		if (VSize(Velocity) < InitialSpeed)
		{
			Velocity = Normal(Velocity) * FMin(InitialSpeed, VSize(Velocity) + InitialSpeed * DeltaTime);
			if (VSize(Velocity) < InitialSpeed)
				bSyncPos = true;
		}
		Acceleration = Normal(Velocity) * 50;
	}

	if (Level.NetMode == NM_Client)
		ClientSyncMovement();

	if (VSize(Velocity) > 0)
		SetRotation(rotator(Velocity));

	if (Level.NetMode != NM_DedicatedServer)
		MakeRocketTrail(DeltaTime);
}

simulated function MakeRocketTrail(float DeltaTime)
{
	local SpriteSmokePuff smoke;
	local Bubble1 bubble;
	local float RocketTrailInterval;

	Count += DeltaTime;
	RocketTrailInterval = SmokeRate + FRand() * (SmokeRate + NumExtraRockets * 0.035);
	if (Count >= RocketTrailInterval)
	{
		if (Region.Zone.bWaterZone)
		{
	 		bubble = Spawn(class'Bubble1',,, Location);
			if (bubble != none)
			{
				bubble.DrawScale = 0.1 + FRand() * 0.2;
				bubble.RemoteRole = ROLE_None;
			}
		}
		else
		{
			smoke = Spawn(class'SpriteSmokePuff');
			if (smoke != none)
				smoke.RemoteRole = ROLE_None;
		}
		Count -= RocketTrailInterval;
		if (Count > RocketTrailInterval)
			Count = RocketTrailInterval;
	}
}

auto state Flying
{
	simulated function ZoneChange(Zoneinfo NewZone)
	{
		local WaterRing w;

		if (Region.Zone.bWaterZone != NewZone.bWaterZone)
		{
			if (Level.NetMode != NM_Client)
			{
				w = Spawn(class'WaterRing',,,,rot(16384,0,0));
				w.DrawScale = 0.2;
			}

			if (NewZone.bWaterZone)
				Velocity = 0.6 * Velocity;
		}

		if (VSize(NewZone.ZoneVelocity) != 0)
			SyncMovement();
	}

	function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if ((Other != instigator) && (Rocket(Other) == none))
			Explode(HitLocation,Normal(HitLocation-Other.Location));
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		if (Mover(Wall) != None && Mover(Wall).bDamageTriggered)
			Wall.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
		MakeNoise(1.0);
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}

	function RocketBlowUp(vector HitLocation, bool bRingExplosion)
	{
		if (Level.Game.IsA('DeathMatchGame')) // bigger damage radius
			HurtRadiusProj(0.9 * Damage, 240.0, 'exploded', MomentumTransfer, HitLocation);
		else
			HurtRadiusProj(Damage, 200.0, 'exploded', MomentumTransfer, HitLocation);
		MakeNoise(1.0);

		if (bRingExplosion)
			PlaySound(class'RingExplosion3'.default.ExploSound,, 6);
	}

	function Explode(vector HitLocation, vector HitNormal)
	{
		local UnrealShare_Rocket_Explosion explosion_info;

		class'UGoldFixBase'.static.GetInstance(Level, UGoldFix);

		explosion_info = Spawn(class'UnrealShare_Rocket_Explosion');
		explosion_info.AssignProjLocation(Location);
		explosion_info.AssignHitLocation(HitLocation);
		explosion_info.AssignHitNormal(HitNormal);
		explosion_info.bReplaceBlastDecals = UGoldFix.ShouldReplaceBlastDecals();
		explosion_info.bRing = bRing;
		explosion_info.Explosion();

		RocketBlowUp(HitLocation, bRing);

		Destroy();
	}

	function BeginState()
	{
		SetTimer(0.15, True);

		initialDir = vector(Rotation);
		Velocity = Speed * initialDir;
		InitialSpeed = Speed;
		Acceleration = initialDir * 50;
		PlaySound(SpawnSound, SLOT_None, 2.3);
		PlayAnim('Armed', 0.2);
		if (Region.Zone.bWaterZone)
			Velocity = 0.6 * Velocity;
	}
Begin:
	if (LifeSpan >= 2)
	{
		Sleep(1);
		LifeSpan += 1;
		Sleep(LifeSpan - 1);
		Explode(Location, vector(Rotation));
	}
}


function Timer()
{
	local vector SeekingDir;

	if (Seeking != none && !Seeking.bDeleteMe && Seeking != Instigator)
	{
		SeekingDir = Normal(Seeking.Location - Location);
		if (SeekingDir Dot InitialDir > 0)
		{
			MagnitudeVel = VSize(Velocity);
			Velocity =  MagnitudeVel * Normal(SeekingDir * 0.47 * MagnitudeVel + Velocity);
			SetRotation(rotator(Velocity));
			SyncMovement();
		}
	}
	else if (bSyncPos)
		SyncMovement();
}

function SyncMovement()
{
	SyncLocation = ConvertToReplicatedVector(Location);
	SyncVelocity = Velocity;

	SyncTimestamp = Level.TimeSeconds;
	bSyncPos = true;
}

simulated function ClientSyncMovement()
{
	local float TimestampDiff;

	if (SyncTimestamp == 0)
		return;

	SetLocation(ConvertReplicatedVector(SyncLocation));
	Velocity = SyncVelocity;

	TimestampDiff = Level.TimeSeconds - SyncTimestamp;
	if (Level.TimeSeconds >= NextFullSyncTimestamp)
	{
		ClientServerTimestampDiff = TimestampDiff;
		NextFullSyncTimestamp = Level.TimeSeconds + 10;
	}
	else if (ClientServerTimestampDiff > TimestampDiff)
		ClientServerTimestampDiff = TimestampDiff;
	else if (ClientServerTimestampDiff < TimestampDiff)
		AutonomousPhysics(TimestampDiff - ClientServerTimestampDiff);

	SyncTimestamp = 0;
}

static function ReplicatedVector ConvertToReplicatedVector(vector pos)
{
	local ReplicatedVector result;
	result.X = pos.X;
	result.Y = pos.Y;
	result.Z = pos.Z;
	return result;
}

static function vector ConvertReplicatedVector(ReplicatedVector pos)
{
	local vector result;
	result.X = pos.X;
	result.Y = pos.Y;
	result.Z = pos.Z;
	return result;
}

defaultproperties
{
	bGameRelevant=False
	bNetTemporary=False
	RemoteRole=ROLE_SimulatedProxy
	ClientServerTimestampDiff=1000000000
}
