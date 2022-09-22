class UnrealI_Boulder1 expands Boulder1;

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
	class'UnrealI_BigRock'.static.TakeDamageImpl(self, ProjSpawnTime, NDamage, InstigatedBy, hitlocation, momentum, damageType);
}

static function SpawnChunksConstrained(BigRock this, float ProjSpawnTime, int num, Pawn NewInstigator, bool bZeroDamage)
{
	local int    NumChunks,i;
	local BigRock   TempRock;
	local float scale;

	NumChunks = 1+Rand(num);
	scale = 12 * sqrt(0.52/NumChunks);
	this.speed = VSize(this.Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = this.Spawn(class'UnrealI_BigRock');
		if (TempRock != none)
			class'UnrealI_BigRock'.static.InitFragConstrained(TempRock, this, scale, NewInstigator, bZeroDamage);
	}
	class'UnrealI_BigRock'.static.InitFragConstrained(this, this, 0.5, NewInstigator, bZeroDamage);
}

auto state Flying
{
	function ProcessTouch(Actor A, Vector HitLocation)
	{
		class'UnrealI_BigRock'.static.ProcessTouchImpl(self, A, HitLocation);
		SyncMovement();
	}

	function MakeSound()
	{
		class'UnrealI_BigRock'.static.MakeSoundImpl(self);
	}

	function HitWall(vector HitNormal, actor Wall)
	{
		Velocity = 0.75 * (Velocity - 2 * HitNormal * (Velocity Dot HitNormal));
		SetRotation(rotator(HitNormal));
		DrawScale *= 0.7;
		SpawnChunks(8);
		Destroy();
	}

Begin:
	Sleep(5.0);
	SetPhysics(PHYS_Falling);
}

defaultproperties
{
	Phys=PHYS_Walking
}
