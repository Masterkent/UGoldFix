class UGoldFixCommon expands Info;

// Mutator config
var bool bAdjustDistanceLightnings;
var bool bDisableMoversGoodCollision;
var bool bDisableNetInterpolatePos;


replication
{
	reliable if (Role == ROLE_Authority)
		bAdjustDistanceLightnings,
		bDisableMoversGoodCollision,
		bDisableNetInterpolatePos;
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
	if (bAdjustDistanceLightnings)
		AdjustDistanceLightnings();
	if (bDisableMoversGoodCollision)
		DisableMoversGoodCollision(Level);
	if (bDisableNetInterpolatePos)
		Spawn(class'UGoldFixClientSpawnNotify');
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

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
}
