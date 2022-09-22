class UnrealI_RazorBlade expands RazorBlade;

struct ReplicatedVector
{
	var float X, Y, Z;
};

var ReplicatedVector SyncLocation;
var vector SyncVelocity;
var int SyncNum;

var int ServerNumWallHits;
var vector WallHitLocation;
var rotator WallHitRotation;

replication
{
	reliable if (Role == ROLE_Authority)
		SyncNum,
		ServerNumWallHits,
		WallHitLocation,
		WallHitRotation;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity;
}

auto state Flying
{
	function ProcessTouch(Actor Other, Vector HitLocation)
	{
		if (bCanHitInstigator || Other != Instigator)
		{
			if (Other.bIsPawn &&
				Instigator != none &&
				(PlayerPawn(Instigator) != none || Instigator.Skill > 1) &&
				Pawn(Other).IsHeadShot(HitLocation, Normal(Velocity)))
			{
				Other.TakeDamage(3.5 * Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), 'decapitated');
			}
			else
				Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer * Normal(Velocity), 'shredded');

			if (Other.bIsPawn)
				PlaySound(MiscSound, SLOT_Misc, 2.0);
			else
				PlaySound(ImpactSound, SLOT_Misc, 2.0);
			Destroy();
		}
	}

	simulated event ZoneChange(Zoneinfo NewZone)
	{
		local Splash w;

		if (Region.Zone.bWaterZone != NewZone.bWaterZone)
		{
			if (Level.NetMode != NM_Client)
			{
				w = Spawn(class'Splash',,,, rot(16384,0,0));
				w.DrawScale = 0.5;
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

	simulated event HitWall(vector HitNormal, Actor Wall)
	{
		local UnrealI_RazorBlade_DecalSpawner decal_spawner;

		bCanHitInstigator = true;
		PlayImpactSound();
		if (Level.NetMode != NM_DedicatedServer && Level.NetMode != NM_Client)
			Spawn(class'WallCrack',,, Location, rotator(HitNormal));
		if (AnimSequence != 'Spin')
			LoopAnim('Spin', 1.0);

		if (Role == ROLE_Authority)
		{
			if (Mover(Wall) != none && Mover(Wall).bDamageTriggered)
			{
				Wall.TakeDamage(Damage, instigator, Location, MomentumTransfer * Normal(Velocity), '');
				Destroy();
				return;
			}

			SetTimer(0, false);
			MakeNoise(0.3);

			if (++NumWallHits > 5)
			{
				if (Level.NetMode != NM_Standalone)
				{
					decal_spawner = Spawn(class'UnrealI_RazorBlade_DecalSpawner');
					decal_spawner.AssignProjLocation(Location);
					decal_spawner.AssignHitNormal(HitNormal);
				}

				Destroy();
				return;
			}

			ServerNumWallHits = NumWallHits;
			WallHitLocation = Location;
			WallHitRotation = rotator(HitNormal);
		}

		Velocity = MirrorVectorByNormal(Velocity, HitNormal);
		SetRoll(Velocity);

		SyncMovement();
	}
}

simulated event PostNetBeginPlay()
{
	SyncNum = 0;
}

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode != NM_Client)
		Disable('Tick');
	else
	{
		if (SyncNum > 0)
			ClientSyncMovement();
		if (ServerNumWallHits > 0)
			ClientSpawnWallHitDecal();
	}
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
	SetRotation(rotator(Velocity));
	SyncNum = 0;
}

simulated function ClientSpawnWallHitDecal()
{
	Spawn(class'WallCrack',,, WallHitLocation, WallHitRotation);
	ServerNumWallHits = 0;
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

function PlayImpactSound()
{
	PlaySound(ImpactSound, SLOT_Misc, 2.0);
}

defaultproperties
{
	bNetTemporary=False
}
