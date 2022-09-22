class ExplosionInfoBase expands Info
	abstract;

// replicated built-in vectors hold inexact values, float values are replicated precisely
struct ReplicatedVector
{
	var float X, Y, Z;
};

var private ReplicatedVector ProjLocation;
var private ReplicatedVector HitLocation;
var private int EncodedHitNormal;

replication
{
	// Variables the server should send to the client
	reliable if (Role == ROLE_Authority)
		ProjLocation,
		HitLocation,
		EncodedHitNormal;
}

event BeginPlay()
{
	LifeSpan = FMax(0.1, Level.TimeDilation);
}

simulated event PostNetBeginPlay()
{
	if (Level.NetMode != NM_Client)
		return;
	Explosion();
	Destroy();
}

// Subclasses may override Explosion or LocalExplosion
simulated function Explosion()
{
	if (Level.NetMode != NM_DedicatedServer)
		LocalExplosion();
}

simulated function LocalExplosion();

function AssignProjLocation(vector pos)
{
	ProjLocation = ConvertToReplicatedVector(pos);
}

function AssignHitLocation(vector pos)
{
	HitLocation = ConvertToReplicatedVector(pos);
}

function AssignHitNormal(vector pos)
{
	EncodedHitNormal = EncodeNormalVector(pos);
}

simulated function vector GetProjLocation()
{
	return ConvertReplicatedVector(ProjLocation);
}

simulated function vector GetHitLocation()
{
	return ConvertReplicatedVector(HitLocation);
}

simulated function vector GetHitNormal()
{
	return DecodeNormalVector(EncodedHitNormal);
}

static function ReplicatedVector ConvertToReplicatedVector(vector pos)
{
	local ReplicatedVector result;
	result.X = pos.X;
	result.Y = pos.Y;
	result.Z = pos.Z;
	return result;
}

static function vector ConvertReplicatedVector(ReplicatedVector pos)
{
	local vector result;
	result.X = pos.X;
	result.Y = pos.Y;
	result.Z = pos.Z;
	return result;
}

static function int EncodeNormalVector(vector NormalVect)
{
	local rotator R;

	if (VSize(NormalVect) == 0)
		return 0;

	R = rotator(NormalVect);
	if (R.Yaw < 0)
		R.Yaw += 65536;
	if (R.Pitch < 0)
		R.Pitch += 65536;

	return ((R.Yaw >> 1) << 1) + ((R.Pitch >> 1) << 16) + 1;
}

static function vector DecodeNormalVector(int EncodedNormalVect)
{
	local rotator R;

	if (EncodedNormalVect == 0)
		return vect(0, 0, 0);

	R.Yaw = EncodedNormalVect & (65536 - 2);
	R.Pitch = (EncodedNormalVect >> 16) << 1;

	return vector(R);
}

defaultproperties
{
	bAlwaysRelevant=True
	bCarriedItem=True
	bMovable=False
	bNetTemporary=True
	LifeSpan=1.000000
	RemoteRole=ROLE_SimulatedProxy
}
