class UnrealI_RazorBlade_DecalSpawner expands ExplosionInfoBase;

simulated function LocalExplosion()
{
	Spawn(class'WallCrack',,, GetProjLocation(), rotator(GetHitNormal()));
}
