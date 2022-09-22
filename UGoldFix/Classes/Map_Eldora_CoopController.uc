class Map_Eldora_CoopController expands Info;

var bool bDelayedRelocation;

event BeginPlay()
{
	Disable('Tick');
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	MovePlayers();
	bDelayedRelocation = true;
	Enable('Tick');
}

event Tick(float DeltaTime)
{
	if (bDelayedRelocation)
		MovePlayers();
}

function MovePlayers()
{
	local Pawn P;
	local bool bOldCollideActors, bOldBlockActors, bOldBlockPlayers;

	foreach AllActors(class'Pawn', P)
	{
		if (P.PlayerReplicationInfo != none &&
			P.Region.ZoneNumber == 1 &&
			P.Location.Z - P.CollisionHeight < Location.Z - 75 &&
			(!bDelayedRelocation || !P.IsInState('CheatFlying')))
		{
			bOldCollideActors = P.bCollideActors;
			bOldBlockActors = P.bBlockActors;
			bOldBlockPlayers = P.bBlockPlayers;

			P.Velocity = vect(0, 0, 0);
			P.SetCollision(false, false, false);
			P.SetLocation(Location);
			P.SetCollision(bOldCollideActors, bOldBlockActors, bOldBlockPlayers);
		}
	}
}
