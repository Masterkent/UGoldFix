class UPak_ExplosiveBullet_Explosion expands ExplosionInfoBase;

var rotator ProjectileRotation;
var bool bReplaceBlastDecals;

replication
{
	reliable if (Role == ROLE_Authority)
		ProjectileRotation,
		bReplaceBlastDecals;
}

simulated function LocalExplosion()
{
	local vector HitLocation, HitNormal;
	local class<Effects> class_UPakExplosion2;
	local class<Effects> class_CARWallHitEffect3;
	local class<Actor> class_SmallBlastMark;
	local Effects UPakExplosion2, WallHitEffect;
	local int i;

	HitLocation = GetHitLocation();
	HitNormal = GetHitNormal();

	class_UPakExplosion2 = class<Effects>(DynamicLoadObject("UPak.UPakExplosion2", class'class'));
	class_CARWallHitEffect3 = class<Effects>(DynamicLoadObject("UPak.CARWallHitEffect3", class'class'));
	class_SmallBlastMark = class<Actor>(DynamicLoadObject("UnrealShare.SmallBlastMark", class'class'));

	if (class_UPakExplosion2 != none)
	{
		UPakExplosion2 = Spawn(class_UPakExplosion2,,, HitLocation, ProjectileRotation);
		if (UPakExplosion2 != none)
			UPakExplosion2.RemoteRole = ROLE_None;
	}
	if (class_CARWallHitEffect3 != none)
	{
		WallHitEffect = Spawn(class_CARWallHitEffect3,,, HitLocation + HitNormal * 9, rotator(HitNormal));
		if (WallHitEffect != none)
			WallHitEffect.RemoteRole = ROLE_None;
	}
	if (class_SmallBlastMark != none)
	{
		for (i = 0; i < 3; ++i)
			Spawn(class_SmallBlastMark, self,, HitLocation, rotator(HitNormal));
	}
}

defaultproperties
{
}
