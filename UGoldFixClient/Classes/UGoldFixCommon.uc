class UGoldFixCommon expands Info;

// Mutator config
var bool bAdjustDistanceLightnings;
var bool bAdjustUPakBursts;
var bool bDisableMoversGoodCollision;
var bool bDisableNetInterpolatePos;
var bool bDisableZoneEnvironmentMapping;


replication
{
	reliable if (Role == ROLE_Authority)
		bAdjustDistanceLightnings,
		bAdjustUPakBursts,
		bDisableMoversGoodCollision,
		bDisableNetInterpolatePos,
		bDisableZoneEnvironmentMapping;
}


simulated event PostNetBeginPlay()
{
	if (Level.NetMode != NM_Client)
		return;
	ApplyNetClientGameFix();
	Destroy();
}

simulated function ApplyNetClientGameFix()
{
	local UGoldFixClientSpawnNotify ClientSpawnNotify;

	if (bAdjustDistanceLightnings)
		AdjustDistanceLightnings();
	if (bDisableMoversGoodCollision)
		DisableMoversGoodCollision(Level);
	if (bDisableZoneEnvironmentMapping)
		DisableZoneEnvironmentMapping();
	bDisableNetInterpolatePos = bDisableNetInterpolatePos && DynamicLoadObject("Engine.Actor.bNetInterpolatePos", class'Property', true) != none;
	if (ShouldUseClientSpawnNotify())
	{
		ClientSpawnNotify = Spawn(class'UGoldFixClientSpawnNotify');
		if (ClientSpawnNotify != none)
		{
			ClientSpawnNotify.bAdjustUPakBursts = bAdjustUPakBursts;
			ClientSpawnNotify.bDisableNetInterpolatePos = bDisableNetInterpolatePos;
		}
	}
}

simulated function bool ShouldUseClientSpawnNotify()
{
	return bAdjustUPakBursts || bDisableNetInterpolatePos;
}

simulated function AdjustDistanceLightnings()
{
	local DistanceLightning A;

	foreach AllActors(class'Engine.DistanceLightning', A)
		if (A.class == class'Engine.DistanceLightning')
		{
			A.Role = ROLE_Authority;
			if (Level.NetMode != NM_DedicatedServer)
				A.SetTimer(5 + FRand() * 10, false);
		}
}

static function DisableMoversGoodCollision(LevelInfo Level)
{
	local Mover m;

	if (MoverGoodCollisionSupported())
	{
		foreach Level.AllActors(class'Mover', m)
			m.SetPropertyText("bUseGoodCollision", "false");
	}
}

static function bool MoverGoodCollisionSupported()
{
	return DynamicLoadObject("Engine.Mover.bUseGoodCollision", class'Object', true) != none;
}

simulated function DisableZoneEnvironmentMapping()
{
	local ZoneInfo Zone;

	if (int(Level.EngineVersion) == 227 && int(Level.EngineSubVersion) == 9)
	{
		foreach AllActors(class'ZoneInfo', Zone)
			Zone.SetPropertyText("EnvironmentColor", "(X=0,Y=0,Z=0)");
	}
}

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
}
