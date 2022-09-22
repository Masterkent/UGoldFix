class UPak_UPakRocket expands Projectile;

struct ReplicatedVector
{
	var float X, Y, Z;
};

var UGoldFixBase UGoldFix;

var float InitialSpeed;
var float OldSpeed;
var int Sequence;
var float RocketTrailTime;

var bool bTimerSync;
var ReplicatedVector SyncLocation;
var vector SyncVelocity;
var float SyncTimestamp;
var float ClientServerTimestampDiff;
var float NextFullSyncTimestamp;

var Sound AirAmbSound, WaterAmbSound;
var class<Actor> class_BubbleTrail;

replication
{
	reliable if (Role == ROLE_Authority)
		InitialSpeed,
		SyncTimestamp;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity;
}

simulated event PostBeginPlay()
{
	if (Level.NetMode != NM_Client)
	{
		Mesh = LodMesh(DynamicLoadObject("UPak.rocketL", class'LodMesh'));
		AirAmbSound = sound(DynamicLoadObject("UPak.RocketLoop1", class'sound'));
		WaterAmbSound = sound(DynamicLoadObject("UPak.RocketLoop2", class'sound'));
		if (Level.Game.bDeathMatch)
			Damage -= 35;
	}

	if (Level.NetMode != NM_DedicatedServer)
		class_BubbleTrail = class<Actor>(DynamicLoadObject("UPak.BubbleTrail", class'class'));
}

simulated event PostNetBeginPlay()
{
	SyncTimestamp = 0;
}

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode == NM_Client)
		ClientSyncMovement();
	else
	{
		if (VSize(Velocity) > 1200 && !Region.Zone.bWaterZone && AnimSequence != 'Fly')
			LoopAnim('Fly');
		else if (Region.Zone.bWaterZone && AnimSequence != 'Wings')
			LoopAnim('Wings');

		if (Region.Zone.bWaterZone)
			AmbientSound = WaterAmbSound;
		else
			AmbientSound = AirAmbSound;
	}

	if (Level.NetMode != NM_DedicatedServer)
		MakeRocketTrail(DeltaTime);

	if (VSize(Velocity) < MaxSpeed)
	{
		if (Region.Zone.bWaterZone)
			Velocity = Normal(Velocity) * FMin(VSize(Velocity) + InitialSpeed * 0.5 * 60 * DeltaTime * 0.37, MaxSpeed);
		else
			Velocity = Normal(Velocity) * FMin(VSize(Velocity) + InitialSpeed * 0.5 * 60 * DeltaTime, MaxSpeed);
	}

	Acceleration = vect(0, 0, 0);
}

event Timer()
{
	SyncMovement();

	if (VSize(Region.Zone.ZoneVelocity) != 0)
		SetTimer(0.1, false);
	else
		SetTimer(1, false);
}

auto state Flying
{
	function Explode(vector HitLocation, vector HitNormal)
	{
		local UPak_UPakRocket_Explosion explosion_info;

		ControlledHurtRadius(Damage, 340.0, 'exploded', MomentumTransfer, HitLocation);

		class'UGoldFixBase'.static.GetInstance(Level, UGoldFix);

		explosion_info = Spawn(class'UPak_UPakRocket_Explosion');
		explosion_info.AssignProjLocation(Location);
		explosion_info.AssignHitLocation(HitLocation);
		explosion_info.AssignHitNormal(HitNormal);
		explosion_info.bReplaceBlastDecals = UGoldFix.ShouldReplaceBlastDecals();
		explosion_info.Explosion();

 		Destroy();
	}

	function ProcessTouch( Actor Other, Vector HitLocation )
	{
		if (Other != Instigator && Rocket(Other) == none) 
			Explode(HitLocation, Normal(HitLocation - Other.Location));
	}

	event BeginState()
	{
		Velocity = speed * vector(Rotation) * 0.37;
		Acceleration = vector(Rotation) * 50;
		InitialSpeed = speed;
		Sequence = 1;
		PlayAnim('Popup', 0.001);
		RotationRate.Roll = 75000;

		if (Region.Zone.bWaterZone)
		{
			Velocity = 0.6 * Velocity;
			AmbientSound = WaterAmbSound;
		}
		else
			AmbientSound = AirAmbSound;

		PlaySound(sound(DynamicLoadObject("UPak.RocketShot1", class'sound')), SLOT_None);

		if (bTimerSync)
			SetTimer(1, false);
	}

	simulated event ZoneChange( Zoneinfo NewZone )
	{
		if (Region.Zone.bWaterZone != NewZone.bWaterZone)
		{
			if (NewZone.bWaterZone)
			{
				RotationRate.Pitch = 0;
				RotationRate.Roll = 90000 * 2 * 0.5 - 10000;

				Velocity = 0.6 * Velocity;
			}
			else if (Level.NetMode != NM_Client)
				PlayAnim('Wings', 0.15);
		}

		if (Level.NetMode != NM_Client && VSize(NewZone.ZoneVelocity) != 0)
			SyncMovement();
	}

	simulated event AnimEnd()
	{
		if (Sequence == 1)
		{
			OldSpeed = VSize(Velocity);
			///Velocity *= 0.37;
			if (Level.NetMode != NM_Client)
				PlayAnim('Wings', 0.001);
			RotationRate.Roll = 80000;
		}
		else if (Sequence == 2)
		{
			///if (Region.Zone.bWaterZone)
			///	Velocity = 0.6 * Velocity;
			///Velocity = OldSpeed * Normal(Velocity);
		}

		if (Sequence < 3)
			Sequence++;
	}
}

//
// Hurt actors within the radius.
//
function ControlledHurtRadius(float DamageAmount, float DamageRadius, name DamageName, float Momentum, vector HitLocation)
{
	local actor Victims;
	local float damageScale, dist;
	local vector dir;

	if( bHurtEntry )
		return;

	bHurtEntry = true;
	foreach VisibleCollidingActors( class 'Actor', Victims, DamageRadius, HitLocation )
	{
		if( Victims != self )
		{
			dir = Victims.Location - HitLocation;
			dist = FMax(1,VSize(dir));
			dir = dir/dist;
			damageScale = 1 - FMax(0,(dist - Victims.CollisionRadius)/DamageRadius);
			if( Pawn( Victims ) != none && Pawn( Victims ) == Instigator )
			{
				DamageScale *= 0.5;
				Momentum *= 5;
			}
			Victims.TakeDamage(	damageScale * DamageAmount, Instigator,  Victims.Location - 0.5 * (Victims.CollisionHeight + Victims.CollisionRadius) * dir, ( ( damageScale * 4 )* ( Momentum * 0.75 ) * dir), DamageName	);
		}
	}
	bHurtEntry = false;
}

simulated function MakeRocketTrail(float DeltaTime)
{
	local SpriteSmokePuff smoke_puff;
	local Actor bubble_trail;
	local float RocketTrailInterval;

	RocketTrailInterval = 1.0 / 60; // smoke generation rate for standard 60 FPS

	RocketTrailTime -= DeltaTime;
	if (RocketTrailTime > 0)
		return;

	RocketTrailTime = FMax(0, RocketTrailTime + RocketTrailInterval);

	if (Region.Zone.bWaterZone)
	{
		bubble_trail = Spawn(class_BubbleTrail,,, Location);
		if (bubble_trail != none)
		{
			bubble_trail.RemoteRole = ROLE_None;
			bubble_trail.ScaleGlow = 0.5;
		}
	}
	else
	{
		smoke_puff = Spawn(class'RisingSpriteSmokePuff',,, Location);
		if (smoke_puff != none)
		{
			smoke_puff.RemoteRole = ROLE_None;
			smoke_puff.LifeSpan = 1.5 + Rand( 8.5 );
			smoke_puff.DrawScale += FRand();
		}
	}
}

function SyncMovement()
{
	SyncLocation = ConvertToReplicatedVector(Location);
	SyncVelocity = Velocity;

	SyncTimestamp = Level.TimeSeconds;
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
	speed=850.000000
	MaxSpeed=2500.000000
	Damage=80.000000
	MomentumTransfer=8500
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=0.000000
	AnimSequence=Armed
	AmbientGlow=96
	bUnlit=True
	SoundRadius=128
	SoundVolume=255
	CollisionRadius=8.500000
	CollisionHeight=2.000000
	bProjTarget=True
	bBounce=True
	bFixedRotationDir=True
	RotationRate=(Roll=95000)
	bNetTemporary=False
	RocketTrailTime=0.1
	bTimerSync=True
}
