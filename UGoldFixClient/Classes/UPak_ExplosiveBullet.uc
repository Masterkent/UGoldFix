class UPak_ExplosiveBullet expands Projectile;

var UGoldFixBase UGoldFix;
var class<Projectile> class_ExplosiveBullet;

simulated event PostBeginPlay()
{
	if (Level.NetMode == NM_Client)
		DrawType = DT_None; // the velocity vector has too big length to be replicated correctly
	else
	{
		class_ExplosiveBullet = class<Projectile>(DynamicLoadObject("UPak.ExplosiveBullet", class'class'));
		Mesh = class_ExplosiveBullet.default.Mesh;
	}
}

auto state Flying
{
	event BeginState()
	{
		Velocity = Vector(Rotation) * speed;
		PlaySound(class_ExplosiveBullet.default.SpawnSound);
	}
	function ProcessTouch(Actor Other, Vector HitLocation)
	{
		local vector HitNormal;

		if (Other == Instigator)
			return;

		HitNormal = Normal(HitLocation - Other.Location);

		if (!Other.IsA('Pawn'))
			Other.TakeDamage(30, instigator, HitLocation, -25000 * HitNormal, 'Exploded');
		BlowUp(HitLocation, HitNormal);
	}
	event HitWall(vector HitNormal, actor Wall)
	{
		if (Mover(Wall) != None && Mover(Wall).bDamageTriggered)
			Wall.TakeDamage(Damage, Instigator, Location, MomentumTransfer * Normal(Velocity), '');

		MakeNoise(1.0);
		BlowUp(Location, HitNormal);
	}
	function BlowUp(Vector HitLocation, vector HitNormal)
	{
		local UPak_ExplosiveBullet_Explosion explosion_info;
		local int ExplosionDamage;

		class'UGoldFixBase'.static.GetInstance(Level, UGoldFix);

		ExplosionDamage = 55;
		if (!UGoldFix.ShouldAdjustSpaceMarineCARDamage() && Instigator != none && Instigator.IsA('SpaceMarine'))
			ExplosionDamage = 2;

		HurtRadiusProj(ExplosionDamage, 100, 'exploded', 25000, HitLocation);

		explosion_info = Spawn(class'UPak_ExplosiveBullet_Explosion');
		explosion_info.AssignProjLocation(Location);
		explosion_info.AssignHitLocation(HitLocation);
		explosion_info.AssignHitNormal(HitNormal);
		explosion_info.ProjectileRotation = Rotation;
		explosion_info.bReplaceBlastDecals = UGoldFix.ShouldReplaceBlastDecals();
		explosion_info.Explosion();

 		Destroy();
	}
}

defaultproperties
{
	speed=50000.000000
	MaxSpeed=50000.000000
	Damage=15.000000
	RemoteRole=ROLE_SimulatedProxy
	bNetTemporary=False
	bGameRelevant=False
}
