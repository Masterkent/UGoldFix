class UnrealI_BigRock expands BigRock;

var float ProjSpawnTime;
var EPhysics Phys;
var vector SyncLocation, SyncVelocity;
var int SyncNum;
var int RotationRatePitch, RotationRateYaw, RotationRateRoll;
var float MinImpactSoundTimestamp;

replication
{
	reliable if (Role == ROLE_Authority)
		Phys,
		SyncNum,
		RotationRatePitch,
		RotationRateYaw,
		RotationRateRoll;

	reliable if (Role == ROLE_Authority && !bNetInitial)
		SyncLocation,
		SyncVelocity;
}

event PostBeginPlay()
{
	super.PostBeginPlay();
	ProjSpawnTime = Level.TimeSeconds + 0.1;
}

simulated event PostNetBeginPlay()
{
	SyncNum = 0;
}

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode == NM_Client)
	{
		if (Physics != Phys && Phys != PHYS_Walking)
			SetPhysics(Phys);

		if (SyncNum > 0)
		{
			SetLocation(SyncLocation);
			Velocity = SyncVelocity;
			SyncNum = 0;
		}

		RotationRate.Pitch = RotationRatePitch;
		RotationRate.Yaw = RotationRateYaw;
		RotationRate.Roll = RotationRateRoll;
	}
	else
	{
		Phys = Physics;
		RotationRatePitch = RotationRate.Pitch;
		RotationRateYaw = RotationRate.Yaw;
		RotationRateRoll = RotationRate.Roll;
	}
}

function SyncMovement()
{
	SyncLocation = Location;
	SyncVelocity = Velocity;
	++SyncNum;
}

function TakeDamage(
	int NDamage,
	Pawn InstigatedBy,
	vector hitlocation,
	vector momentum,
	name damageType)
{
	TakeDamageImpl(self, ProjSpawnTime, NDamage, InstigatedBy, hitlocation, momentum, damageType);
}

static function TakeDamageImpl(
	BigRock this,
	float ProjSpawnTime,
	int NDamage,
	Pawn InstigatedBy,
	vector hitlocation,
	vector momentum,
	name damageType)
{
	this.Velocity += momentum / (this.DrawScale * 10);
	if (this.Physics == PHYS_None)
	{
		this.SetPhysics(PHYS_Falling);
		this.Velocity.Z += 0.4 * VSize(momentum);
		if (!this.IsInState('Flying'))
			this.GotoState('Flying');
	}
	SpawnChunksConstrained(this, ProjSpawnTime, 4, InstigatedBy, true);
}

static function SpawnChunksConstrained(BigRock this, float ProjSpawnTime, int num, Pawn NewInstigator, bool bZeroDamage)
{
	local int NumChunks, i;
	local UnrealI_BigRock TempRock;
	local float scale;

	if (this.DrawScale < 1 + FRand() || ProjSpawnTime > this.Level.TimeSeconds)
		return;

	NumChunks = 1+Rand(num);
	scale = sqrt(0.52/NumChunks);
	if ( scale * this.DrawScale < 1 )
	{
		NumChunks *= scale * this.DrawScale;
		scale = 1 / this.DrawScale;
	}
	this.speed = VSize(this.Velocity);
	for (i = 0; i < NumChunks; ++i)
	{
		TempRock = this.Spawn(class'UnrealI_BigRock');
		if (TempRock != none)
			InitFragConstrained(TempRock, this, scale, NewInstigator, bZeroDamage);
	}
	InitFragConstrained(this, this, 0.5, NewInstigator, bZeroDamage);
}

static function InitFragConstrained(BigRock this, BigRock myParent, float scale, Pawn NewInstigator, bool bZeroDamage)
{
	// Pick a random size for the chunks
	this.RotationRate = RotRand();
	scale *= (0.5 + FRand());
	this.DrawScale = scale * myParent.DrawScale;
	if (this.DrawScale <= 2)
		this.SetCollisionSize(0, 0);
	else
		this.SetCollisionSize(this.CollisionRadius * this.DrawScale/this.default.DrawScale, this.CollisionHeight * this.DrawScale/this.default.DrawScale);

	///Velocity = Normal(VRand() + myParent.Velocity/myParent.speed) * (myParent.speed * (0.4 + 0.3 * (FRand() + FRand())));
	this.Velocity = Normal(VRand() * 0.3 + myParent.Velocity/VSize(myParent.Velocity)) * (myParent.speed * (0.4 + 0.3 * (FRand() + FRand())));
	if (NewInstigator != none)
		this.Instigator = NewInstigator;
	if (bZeroDamage)
		this.Damage = 0;
}

static function ProcessTouchImpl(BigRock this, Actor A, Vector HitLocation)
{
	local int HitDamage;

	if (A == this.Instigator )
		return;
	if (CheckImpactSoundTime(this))
		this.PlaySound(this.ImpactSound, SLOT_Interact, this.DrawScale/10);

	if (!A.IsA('BigRock'))
	{
		if (!A.IsA('Titan'))
		{
			this.speed = VSize(this.Velocity);
			HitDamage = this.Damage * 0.00002 * (this.DrawScale**3) * this.speed;
			if (HitDamage > 6 && this.speed > 150)
				A.TakeDamage(HitDamage, this.Instigator, HitLocation, 35000.0 * Normal(this.Velocity), 'crushed');
		}
		HitActorConstrained(this, Normal(A.Location - this.Location), A);
	}
}

static function HitActorConstrained(BigRock this, vector HitNormal, Actor A)
{
	local bool bDestructive;
	local vector RealHitNormal;

	bDestructive = A.bDeleteMe || Pawn(A) != none && Pawn(A).Health <= 0;

	this.speed = VSize(this.Velocity);
	if (!bDestructive)
		MakeSoundImpl(this);

	if (this.speed < 1)
	{
		this.SetPhysics(PHYS_None);
		this.GotoState('Sitting');
	}
	else if (!bDestructive)
	{
		if (this.Physics == PHYS_Projectile)
			HitNormal = Normal(HitNormal);
		else
		{
			RealHitNormal = HitNormal;
			HitNormal = Normal(HitNormal + 0.5 * VRand());
			if ((RealHitNormal Dot HitNormal) < 0)
				HitNormal.Z *= -0.7;
		}
		this.SetPhysics(PHYS_Falling);
		this.Velocity = 0.7 * (this.Velocity - 2 * HitNormal * (this.Velocity Dot HitNormal));
		if (FRand() < 0.5)
			this.RotationRate.Pitch = Max(this.RotationRate.Pitch, 100000);
		else
			this.RotationRate.Roll = Max(this.RotationRate.Roll, 100000);
		this.DesiredRotation = rotator(HitNormal);
		if (this.speed > 150 && FRand() * 30 < this.DrawScale)
			SpawnChunksConstrained(this, GetProjSpawnTime(this), 4, none, true);
	}
}

static function MakeSoundImpl(BigRock this)
{
	local float soundRad;

	if (!CheckImpactSoundTime(this))
		return;

	if (this.Drawscale > 2.0)
		soundRad = 500 * this.DrawScale;
	else
		soundRad = 100;
	this.PlaySound(this.ImpactSound, SLOT_Misc, this.DrawScale/8,, soundRad);
}

static function bool CheckImpactSoundTime(BigRock this)
{
	if (UnrealI_BigRock(this) != none)
		return CheckImpactSoundMinTimestamp(this, UnrealI_BigRock(this).MinImpactSoundTimestamp);
	if (UnrealI_Boulder1(this) != none)
		return CheckImpactSoundMinTimestamp(this, UnrealI_Boulder1(this).MinImpactSoundTimestamp);
	return true;
}

static function bool CheckImpactSoundMinTimestamp(Actor Context, out float MinTimestamp)
{
	const ImpactSoundDelay = 0.1;

	if (Context.Level.TimeSeconds < MinTimestamp)
		return false;
	MinTimestamp = Context.Level.TimeSeconds + ImpactSoundDelay;
	return true;
}

static function float GetProjSpawnTime(BigRock Proj)
{
	if (UnrealI_BigRock(Proj) != none)
		return UnrealI_BigRock(Proj).ProjSpawnTime;
	if (UnrealI_Boulder1(Proj) != none)
		return UnrealI_Boulder1(Proj).ProjSpawnTime;
	return 0;
}

auto state Flying
{
	function ProcessTouch(Actor A, Vector HitLocation)
	{
		ProcessTouchImpl(self, A, HitLocation);
		SyncMovement();
	}

	event Landed(vector HitNormal)
	{
		HitWall(HitNormal, none);
	}

	function MakeSound()
	{
		MakeSoundImpl(self);
	}

	event HitWall(vector HitNormal, Actor Wall)
	{
		local vector RealHitNormal;
		local UnrealI_BigRock_DecalSpawner decal_spawner;

		speed = VSize(velocity);

		if (Role == ROLE_Authority)
		{
			if (Mover(Wall) != none && Mover(Wall).bDamageTriggered)
				Wall.TakeDamage(Damage, Instigator, Location, MomentumTransfer * Normal(Velocity), '');

			MakeSound();

			if (HitNormal.Z > 0.8 && speed < 60 - DrawScale)
			{
				SetPhysics(PHYS_None);
				GotoState('Sitting');
			}
			else
			{
				SetPhysics(PHYS_Falling);
				RealHitNormal = HitNormal;
				if (FRand() < 0.5)
					RotationRate.Pitch = Max(RotationRate.Pitch, 100000);
				else
					RotationRate.Roll = Max(RotationRate.Roll, 100000);
				HitNormal = Normal(HitNormal + 0.5 * VRand());
				if ((RealHitNormal Dot HitNormal) < 0)
					HitNormal.Z *= -0.7;
				Velocity = 0.7 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
				DesiredRotation = rotator(HitNormal);
				if (speed > 150 && FRand() * 30 < DrawScale)
					SpawnChunksConstrained(self, ProjSpawnTime, 4, none, false);
			}

			SyncMovement();
		}
		if (DrawScale > 3 && speed > 250)
		{
			decal_spawner = Spawn(class'UnrealI_BigRock_DecalSpawner');
			decal_spawner.AssignProjLocation(Location);
			decal_spawner.AssignHitNormal(HitNormal);
			decal_spawner.Explosion();
		}
	}

Begin:
	Sleep(5.0);
	SetPhysics(PHYS_Falling);
}

State Sitting
{
Begin:
	SetPhysics(PHYS_None);
	Sleep(DrawScale * 0.5);
	Destroy();
}

defaultproperties
{
	Phys=PHYS_Walking
}
