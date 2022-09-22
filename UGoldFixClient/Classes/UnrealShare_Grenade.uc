class UnrealShare_Grenade expands Grenade;

struct ReplicatedVector
{
	var float X, Y, Z;
};

var UGoldFixBase UGoldFix;
var bool bHandleZoneChange;
var ReplicatedVector SyncLocation;
var vector SyncVelocity;
var bool bStop;
var int SyncNum;

replication
{
	reliable if (Role == ROLE_Authority)
		SyncNum;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity,
		bStop;
}

simulated event PostBeginPlay()
{
	local vector X,Y,Z;
	local rotator RandRot;

	if (Level.NetMode != NM_DedicatedServer)
		PlayAnim('WingIn');

	RandSpin(50000);
	bHandleZoneChange = true;

	if (Role == ROLE_Authority)
	{
		SetTimer(2.5 + FRand() * 0.5, false); // Grenade begins unarmed
		if (Instigator != none)
		{
			GetAxes(Instigator.ViewRotation, X, Y, Z);
			Velocity = X * (Instigator.Velocity dot X) * 0.4 + vector(Rotation) * (Speed + FRand() * 100);
		}
		else
			Velocity = vector(Rotation) * (Speed + FRand() * 100);
		Velocity.z += 210;
		RandRot.Pitch = FRand() * 1400 - 700;
		RandRot.Yaw = FRand() * 1400 - 700;
		RandRot.Roll = FRand() * 1400 - 700;
		MaxSpeed = 1000;
		Velocity = Velocity >> RandRot;
		bCanHitOwner = false;
		if (Region.Zone.bWaterZone)
		{
			bHitWater = true;
			Velocity = 0.6 * Velocity;
		}
	}
}

simulated event PostNetBeginPlay()
{
	SyncNum = 0;
}

simulated function ZoneChange( Zoneinfo NewZone )
{
	local WaterRing w;

	if (!bHandleZoneChange)
		return;

	if (Region.Zone.bWaterZone != NewZone.bWaterZone)
	{
		if (Level.NetMode != NM_Client)
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
		}

		if (NewZone.bWaterZone)
		{
			bHitWater = true;
			Velocity = 0.6 * Velocity;
		}
	}

	if (VSize(NewZone.ZoneVelocity) != 0)
		SyncMovement();
}

function Timer()
{
	Explosion(Location+Vect(0,0,1)*16);
}

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode != NM_DedicatedServer)
		MakeGrenadeTrail(DeltaTime);
	if (Level.NetMode == NM_Client && SyncNum > 0)
		ClientSyncMovement();
}

function SyncMovement()
{
	SyncLocation = ConvertToReplicatedVector(Location);
	SyncVelocity = Velocity;
	++SyncNum;
}

simulated function ClientSyncMovement()
{
	SetLocation(ConvertReplicatedVector(SyncLocation));
	Velocity = SyncVelocity;
	if (bStop)
	{
		bBounce = false;
		SetPhysics(PHYS_None);
	}
	SyncNum = 0;
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

simulated function MakeGrenadeTrail(float DeltaTime)
{
	local BlackSmoke smoke;
	local float GrenadeTrailInterval;

	Count += DeltaTime;
	GrenadeTrailInterval = Frand() * SmokeRate + SmokeRate + NumExtraGrenades * 0.03;
	if (Count >= GrenadeTrailInterval)
	{
		if (!Region.Zone.bWaterZone)
		{
			smoke = Spawn(class'BlackSmoke');
			if (smoke != none)
				smoke.RemoteRole = ROLE_None;
		}
		Count -= GrenadeTrailInterval;
		if (Count > GrenadeTrailInterval)
			Count = GrenadeTrailInterval;
	}
}

function ProcessTouch(actor Other, vector HitLocation)
{
	if (Other != Instigator || bCanHitOwner)
		Explosion(HitLocation);
}

simulated function HitWall(vector HitNormal, actor Wall)
{
	bCanHitOwner = True;
	Velocity = 0.8*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	RandSpin(100000);
	speed = VSize(Velocity);
	PlayImpactSound();
	if (Velocity.Z > 400)
		Velocity.Z = 0.5 * (400 + Velocity.Z);
	else if (speed < 20 && Level.NetMode != NM_Client) 
	{
		bBounce = false;
		SetPhysics(PHYS_None);
		bStop = true;
	}

	SyncMovement();
}

function PlayImpactSound()
{
	PlaySound(ImpactSound, SLOT_Misc, FMax(0.5, speed/800));
}

function Explosion(vector HitLocation)
{
	local UnrealShare_Grenade_Explosion explosion_info;

	class'UGoldFixBase'.static.GetInstance(Level, UGoldFix);
	BlowUp(HitLocation);

	explosion_info = Spawn(class'UnrealShare_Grenade_Explosion');
	explosion_info.AssignProjLocation(Location);
	explosion_info.AssignHitLocation(HitLocation);
	explosion_info.bReplaceBlastDecals = UGoldFix.ShouldReplaceBlastDecals();
	explosion_info.Explosion();

	Destroy();
}

defaultproperties
{
	bGameRelevant=False
	bNetTemporary=False
	RemoteRole=ROLE_SimulatedProxy
}
