class SpawnableTeleporter expands Teleporter;

// base class implementation must be overridden
function PostBeginPlay() {}

function ReplaceTeleporter(Teleporter OldTelep)
{
	URL = OldTelep.URL;
	Tag = OldTelep.Tag;
	SetCollision(OldTelep.bCollideActors, OldTelep.bBlockActors, OldTelep.bBlockPlayers);
	SetCollisionSize(OldTelep.CollisionRadius, OldTelep.CollisionHeight);
	bChangesVelocity = OldTelep.bChangesVelocity;
	bChangesYaw = OldTelep.bChangesYaw;
	bReversesX = OldTelep.bReversesX;
	bReversesY = OldTelep.bReversesY;
	bReversesZ = OldTelep.bReversesZ;
	bEnabled = OldTelep.bEnabled;
	TargetVelocity = OldTelep.TargetVelocity;
	if (Len(URL) == 0)
		SetCollision(false, false, false); // destination only

	OldTelep.Tag = '';
	OldTelep.URL = "";
	OldTelep.SetCollision(false);
}

static function SpawnableTeleporter StaticReplaceTeleporter(Teleporter OldTelep)
{
	local SpawnableTeleporter NewTelep;

	if (OldTelep == none)
		return none;

	NewTelep = OldTelep.Spawn(class'SpawnableTeleporter',, OldTelep.Tag);
	if (NewTelep == none)
		return none;

	NewTelep.ReplaceTeleporter(OldTelep);
	return NewTelep;
}

defaultproperties
{
	bStatic=False
	bCollideWhenPlacing=False
}
