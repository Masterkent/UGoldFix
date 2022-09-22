class UnrealI_WarlordRocket expands WarlordRocket;

var float InitialSpeed;

var UGoldFixBase UGoldFix;

replication
{
	reliable if (Role == ROLE_Authority)
		InitialSpeed;
}


simulated event Tick(float DeltaTime)
{
	if (!Region.Zone.bWaterZone && VSize(Velocity) < InitialSpeed)
	{
		Velocity = Normal(Velocity) * InitialSpeed;
		Acceleration = vect(0, 0, 0);
	}

	if (Level.NetMode != NM_DedicatedServer)
		MakeRocketTrail(DeltaTime);
}

simulated function MakeRocketTrail(float DeltaTime)
{
	local SpriteSmokePuff smoke;
	local Bubble1 bubble;
	local float RocketTrailInterval;

	Count += DeltaTime;
	RocketTrailInterval = SmokeRate + FRand() * SmokeRate;
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
	event ZoneChange(Zoneinfo NewZone)
	{
		local WaterRing w;

		if (Region.Zone.bWaterZone != NewZone.bWaterZone)
		{
			w = Spawn(class'WaterRing',,,,rot(16384,0,0));
			w.DrawScale = 0.2;
		}
	}

	event HitWall(vector HitNormal, actor Wall)
	{
		if (Mover(Wall) != None && Mover(Wall).bDamageTriggered)
			Wall.TakeDamage(Damage, Instigator, Location, MomentumTransfer * Normal(Velocity), '');
		MakeNoise(1.0);
		Explode(Location + ExploWallOut * HitNormal, HitNormal);
	}

	function Explode(vector HitLocation, vector HitNormal)
	{
		local UnrealI_WarlordRocket_Explosion explosion_info;

		class'UGoldFixBase'.static.GetInstance(Level, UGoldFix);
		HurtRadiusProj(Damage, 200.0, 'exploded', MomentumTransfer, HitLocation);

		explosion_info = Spawn(class'UnrealI_WarlordRocket_Explosion');
		explosion_info.AssignProjLocation(Location);
		explosion_info.AssignHitLocation(HitLocation);
		explosion_info.AssignHitNormal(HitNormal);
		explosion_info.bReplaceBlastDecals = UGoldFix.ShouldReplaceBlastDecals();
		explosion_info.Explosion();

		Destroy();
	}

	simulated event BeginState()
	{
		Super.BeginState();
		InitialSpeed = VSize(Velocity);

		if (Level.bHighDetailMode)
			SmokeRate = 0.035;
		else
			SmokeRate = 0.15;
	}
}

defaultproperties
{
	bGameRelevant=False
	bNetTemporary=False
	RemoteRole=ROLE_SimulatedProxy
}
