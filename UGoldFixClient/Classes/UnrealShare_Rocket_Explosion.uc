class UnrealShare_Rocket_Explosion expands ExplosionInfoBase;

var bool bRing;
var bool bReplaceBlastDecals;

replication
{
	reliable if (Role == ROLE_Authority)
		bRing,
		bReplaceBlastDecals;
}

simulated function Explosion()
{
	local vector HitLocation, HitNormal;
	local SpriteBallExplosion ExplosionEffect;
	local RingExplosion3 RingEffect;
	local class<Actor> DecalClass;
	local Actor DecalActor;

	HitLocation = GetHitLocation();
	HitNormal = GetHitNormal();

	// Note: makes explosion sound on dedicated servers
	ExplosionEffect = Spawn(class'SpriteBallExplosion',,, HitLocation + HitNormal * 16);
	if (ExplosionEffect != none)
		ExplosionEffect.RemoteRole = ROLE_None;

	if (Level.NetMode == NM_DedicatedServer)
		return;

	if (bRing)
	{
		RingEffect = Spawn(class'RingExplosion3',,, HitLocation + HitNormal * 16, rotator(HitNormal));
		if (RingEffect != none)
		{
			RingEffect.RemoteRole = ROLE_None;
			RingEffect.bAddedDecal = true;
		}
	}

	DecalClass = GetDecalClass();
	if (DecalClass != none)
	{
		DecalActor = Spawn(DecalClass, self,, GetProjLocation(), rotator(HitNormal));
		if (DecalActor != none)
			AdjustDecalTexture(DecalActor);
	}
}

simulated function AdjustDecalTexture(Actor DecalActor)
{
	if (DecalActor.Class.Name == 'RocketBlastMark')
		DecalActor.Texture = texture'UnrealShare.RocketBlast6';
}

simulated function class<Actor> GetDecalClass()
{
	if (bReplaceBlastDecals)
		return class'UnrealShare.RocketBlastMark';
	return class'UnrealShare.BlastMark';
}

defaultproperties
{
}
