class UnrealI_RazorBladeAlt expands RazorBladeAlt;

struct ReplicatedVector
{
	var float X, Y, Z;
};

var ReplicatedVector SyncLocation;
var float SyncTimestamp;
var float ClientServerTimestampDiff;
var float NextFullSyncTimestamp;

var int ServerNumWallHits;
var vector WallHitLocation;
var rotator WallHitRotation;

replication
{
	reliable if (Role == ROLE_Authority)
		SyncTimestamp,
		ServerNumWallHits,
		WallHitLocation,
		WallHitRotation;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation;
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

	simulated event Tick(float DeltaTime)
	{
		local int DeltaYaw, DeltaPitch;
		local int YawDiff;

		if (Level.NetMode == NM_Client)
		{
			ClientSyncMovement();
			if (ServerNumWallHits > 0)
				ClientSpawnWallHitDecal();
		}
		else
		{
			if (Instigator == none || Instigator.bDeleteMe || Instigator.Health <= 0 || Instigator.IsA('Bot'))
			{
				Disable('Tick');
				return;
			}
			else
			{
				DeltaYaw = (instigator.ViewRotation.Yaw & 65535) - (OldGuiderRotation.Yaw & 65535);
				DeltaPitch = (instigator.ViewRotation.Pitch & 65535) - (OldGuiderRotation.Pitch & 65535);
				if ( DeltaPitch < -32768 )
					DeltaPitch += 65536;
				else if ( DeltaPitch > 32768 )
					DeltaPitch -= 65536;
				if ( DeltaYaw < -32768 )
					DeltaYaw += 65536;
				else if ( DeltaYaw > 32768 )
					DeltaYaw -= 65536;

				YawDiff = (Rotation.Yaw & 65535) - (GuidedRotation.Yaw & 65535) - DeltaYaw;
				if ( DeltaYaw < 0 )
				{
					if ( ((YawDiff > 0) && (YawDiff < 16384)) || (YawDiff < -49152) )
						GuidedRotation.Yaw += DeltaYaw;
				}
				else if ( ((YawDiff < 0) && (YawDiff > -16384)) || (YawDiff > 49152) )
					GuidedRotation.Yaw += DeltaYaw;

				GuidedRotation.Pitch += DeltaPitch;

				Velocity += Vector(GuidedRotation) * 2000 * DeltaTime;
				speed = VSize(Velocity);
				Velocity = Velocity * FClamp(speed,400,750)/speed;
				OldGuiderRotation = instigator.ViewRotation;

				SyncMovement();
			}
		}
		SetRotation(rotator(Velocity) + rot(0, 0, 12768));
	}
}

simulated event PostNetBeginPlay()
{
	SyncTimestamp = 0;
}

function SyncMovement()
{
	SyncLocation = ConvertToReplicatedVector(Location);
	GuidedVelocity = Velocity;
	SyncTimestamp = Level.TimeSeconds;
}

simulated function ClientSyncMovement()
{
	local float TimestampDiff;

	if (SyncTimestamp == 0)
		return;

	SetLocation(ConvertReplicatedVector(SyncLocation));
	Velocity = GuidedVelocity;

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
