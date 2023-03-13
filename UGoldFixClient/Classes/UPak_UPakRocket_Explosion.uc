class UPak_UPakRocket_Explosion expands ExplosionInfoBase;

var bool bReplaceBlastDecals;

replication
{
	reliable if (Role == ROLE_Authority)
		bReplaceBlastDecals;
}

simulated function LocalExplosion()
{
	local vector HitLocation, HitNormal;
	local Effects UPakBurst, UPakExplosion1;
	local Actor DecalActor;
	local class<Effects> class_UPakExplosion1;

	HitLocation = GetHitLocation();
	HitNormal = GetHitNormal();

	UPakBurst = Spawn(class'UPak_UPakBurst',,, HitLocation + HitNormal * 16);
	if (UPakBurst != none)
		UPakBurst.RemoteRole = ROLE_None;

	class_UPakExplosion1 = class<Effects>(DynamicLoadObject("UPak.UPakExplosion1", class'class', true));
	if (class_UPakExplosion1 != none)
	{
		UPakExplosion1 = Spawn(class_UPakExplosion1,,, HitLocation + HitNormal * 8 , rotator(HitNormal));
		if (UPakExplosion1 != none)
			UPakExplosion1.RemoteRole = ROLE_None;
	}

	DecalActor = Spawn(class'UnrealShare.RocketBlastMark', self,, GetProjLocation(), rotator(HitNormal));
	if (DecalActor != none)
		AdjustDecalTexture(DecalActor);
}

simulated function AdjustDecalTexture(Actor DecalActor)
{
	if (bReplaceBlastDecals)
		DecalActor.Texture = texture(DynamicLoadObject("UnrealShare.RocketBlast6", class'texture'));
}
