class Map_Crashsite2_SpaceMarinesController expands Info;

function Trigger(Actor A, Pawn EventInstigator)
{
	Disable('Trigger');
	SetTimer(0.5, true);
}

function Timer()
{
	AdjustSpaceMarines();
}

function AdjustSpaceMarines()
{
	local Bots sm;
	foreach AllActors(class'Bots', sm)
	{
		if (!sm.IsA('SpaceMarine') || sm.class.outer.name != 'UPak')
			continue;

		if (!sm.IsInState('StartUp') && !sm.IsInState('BeamingIn') && sm.Enemy == none)
			FindNewEnemyFor(sm);
	}
}

function FindNewEnemyFor(Bots sm)
{
	local PlayerPawn p;
	local Pawn Target;
	local Bots otherMarine;

	ForEach AllActors(class'PlayerPawn', p)
		if (P.Health > 0 && sm.LineOfSightTo(P) &&
			!P.IsA('Spectator') &&
			(Target == None || VSize(p.Location - sm.Location) < VSize(Target.Location - sm.Location)))
		{
			Target = p;
		}
	if (Target == None)
	{
		foreach AllActors(class'Bots', otherMarine)
			if (otherMarine.IsA('SpaceMarine') && otherMarine.Enemy != None)
			{
				Target = otherMarine.Enemy;
				break;
			}
	}
	if (Target != None)
	{
		sm.SetEnemy(Target);
		sm.GotoState('Attacking');
	}
}


defaultproperties
{
}
