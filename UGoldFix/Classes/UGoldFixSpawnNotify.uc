class UGoldFixSpawnNotify expands SpawnNotify;

var UGoldFix UGoldFix;

function Init(UGoldFix UGoldFix)
{
	self.UGoldFix = UGoldFix;
}

event Actor SpawnNotification(Actor A)
{
	if (UGoldFix == none || !UGoldFix.bEnableGameFix)
		return A;

	if (Effects(A) != none)
	{
		if (A.Class == UGoldFix.class_Octagon && UGoldFix.bReplaceOctagons && Level.NetMode != NM_Standalone)
			return ReplaceOctagon(A);
	}
	else if (Projectile(A) != none)
	{
		if (BigRock(A) != none && UGoldFix.bReplaceBigRocks)
			return ReplaceBigRock(Projectile(A));
		else if (DispersionAmmo(A) != none)
		{
			if (A.Instigator != none &&
				A.Instigator.Weapon != none &&
				A.Instigator.Weapon.Class == class'DispersionPistol')
			{
				if (UGoldFix.bAdjustDispersionAmmoAmount && !Level.Game.bDeathMatch)
					AdjustDispersionAmmoAmount(A.Instigator.Weapon);
				if (UGoldFix.bAdjustDispersionFireRate &&
					A.Class == class'UnrealShare.DispersionAmmo' &&
					!DispersionAmmo(A).bAltFire)
				{
					AdjustDispersionFireRate(A.Instigator.Weapon);
				}
			}
		}
		else if (A.Class == UGoldFix.class_GLDetGrenade || A.Class == UGoldFix.class_GLGrenade)
		{
			if (UGoldFix.bAdjustGLGrenades)
				AdjustClientProjectile(Projectile(A));
			return A;
		}
		else if (A.Class == class'Grenade')
			return GetProjectileReplacement(Projectile(A), class'UnrealShare_Grenade');
		else if (A.Class == class'RazorBlade')
			return GetProjectileReplacement(Projectile(A), class'UnrealI_RazorBlade');
		else if (A.Class == class'RazorBladeAlt')
			return GetProjectileReplacement(Projectile(A), class'UnrealI_RazorBladeAlt');
		else if (A.Class == class'Rocket')
			return GetProjectileReplacement(Projectile(A), class'UnrealShare_Rocket');
		else if (A.Class == class'SeekingRocket')
			return GetProjectileReplacement(Projectile(A), class'UnrealShare_SeekingRocket');
		else if (A.Class == class'WarlordRocket')
			return GetProjectileReplacement(Projectile(A), class'UnrealI_WarlordRocket');
		else if (A.Class.Outer == Class.Outer)
			BindProjectileMutator(Projectile(A));
	}
	else if (ReplicationInfo(A) != none)
	{
		if (UGoldFix.ShouldAdjustNetUpdateFrequency())
			class'UGoldFix'.static.AdjustReplicationInfoNetUpdateFrequency(ReplicationInfo(A));
	}
	return A;
}

static function Actor ReplaceBigRock(Projectile Proj)
{
	if (Proj.Class == class'BigRock')
		return GetProjectileReplacement(Proj, class'UnrealI_BigRock');
	if (Proj.Class == class'Boulder1')
		return GetProjectileReplacement(Proj, class'UnrealI_Boulder1');
	return Proj;
}

static function AdjustDispersionAmmoAmount(Weapon Weap)
{
	if (Weap.AmmoType != none &&
		Weap.AmmoType.AmmoAmount < 1 &&
		!Weap.IsInState('AltFiring'))
	{
		Weap.AmmoType.AmmoAmount = 1;
	}
}

static function AdjustDispersionFireRate(Weapon Weap)
{
	if (Weap.AnimRate >= 4)
		return;
	switch (Weap.AnimSequence)
	{
		case 'Shoot1':
		case 'Shoot2':
		case 'Shoot3':
		case 'Shoot4':
		case 'Shoot5':
			Weap.PlayAnim(Weap.AnimSequence, 0.4, 0.2);
	}
}

static function Projectile GetProjectileReplacement(Projectile Proj, class<Projectile> NewProjectileClass)
{
	ReplaceProjectile(Proj, NewProjectileClass);
	return Proj;
}

static function bool ReplaceProjectile(out Projectile Proj, class<Projectile> NewProjectileClass)
{
	local Projectile NewProj;

	Proj.SetCollision(false);

	NewProj = Proj.Spawn(NewProjectileClass, Proj.Owner);
	if (NewProj == none)
	{
		Proj.bCollideWhenPlacing = Proj.default.bCollideWhenPlacing;
		Proj.bCollideWorld = Proj.default.bCollideWorld;
		Proj.SetCollision(Proj.default.bCollideActors);
		return false;
	}
	Proj.Destroy();
	Proj = NewProj;
	return true;
}

function BindProjectileMutator(Projectile Proj)
{
	if (UnrealI_WarlordRocket(Proj) != none)
		UnrealI_WarlordRocket(Proj).UGoldFix = UGoldFix;
	else if (UnrealShare_Grenade(Proj) != none)
		UnrealShare_Grenade(Proj).UGoldFix = UGoldFix;
	else if (UnrealShare_Rocket(Proj) != none)
		UnrealShare_Rocket(Proj).UGoldFix = UGoldFix;
	else if (UnrealShare_SeekingRocket(Proj) != none)
		UnrealShare_SeekingRocket(Proj).UGoldFix = UGoldFix;
	else if (UPak_ExplosiveBullet(Proj) != none)
		UPak_ExplosiveBullet(Proj).UGoldFix = UGoldFix;
	else if (UPak_UPakRocket(Proj) != none)
		UPak_UPakRocket(Proj).UGoldFix = UGoldFix;
}

function AdjustClientProjectile(Projectile Proj)
{
	if (Level.NetMode != NM_Standalone)
		Spawn(class'ProjectileClientAdjustment').ControlledProjectile = Proj;
}

function Actor ReplaceOctagon(Actor A)
{
	local Actor Replacement;

	Replacement = A.Spawn(class'UPak_Octagon',,, A.Location, A.Rotation);

	A.SetLocation(vect(0, 0, -100000));
	return Replacement;
}

defaultproperties
{
	bHidden=True
	RemoteRole=ROLE_None
}
