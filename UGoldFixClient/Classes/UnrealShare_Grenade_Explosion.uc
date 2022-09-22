class UnrealShare_Grenade_Explosion expands UnrealShare_Rocket_Explosion;

simulated function Explosion()
{
	local SpriteBallExplosion ExplosionEffect;
	local class<Actor> DecalClass;
	local Actor DecalActor;

	ExplosionEffect = Spawn(class'SpriteBallExplosion',,, GetHitLocation());
	if (ExplosionEffect != none)
		ExplosionEffect.RemoteRole = ROLE_None;

	if (Level.NetMode == NM_DedicatedServer)
		return;

	DecalClass = GetDecalClass();
	if (DecalClass != none)
	{
		DecalActor = Spawn(DecalClass, self,, GetProjLocation(), rot(16384, 0, 0));
		if (DecalActor != none)
			AdjustDecalTexture(DecalActor);
	}
}

simulated function AdjustDecalTexture(Actor DecalActor)
{
	local int n;

	if (DecalActor.Class.Name == 'RocketBlastMark')
	{
		n = Rand(3);
		if (n == 1)
			DecalActor.Texture = texture'UnrealShare.RocketBlast4';
		else if (n == 2)
			DecalActor.Texture = texture'UnrealShare.RocketBlast5';
		else
			DecalActor.Texture = texture'UnrealShare.RocketBlast7';
	}
}
