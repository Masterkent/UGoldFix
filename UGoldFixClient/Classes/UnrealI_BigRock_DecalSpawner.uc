class UnrealI_BigRock_DecalSpawner expands ExplosionInfoBase;

simulated function LocalExplosion()
{
	local class<Actor> DecalClass;
	local float OldDrawScale;

	DecalClass = class'UnrealShare.BigWallCrack';
	OldDrawScale = DecalClass.default.DrawScale;
	DecalClass.default.DrawScale = DrawScale * 0.1;
	Spawn(DecalClass,,, GetProjLocation(), rotator(GetHitNormal()));
	DecalClass.default.DrawScale = OldDrawScale;
}
