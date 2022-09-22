class Map_Glathriel1_CoopController expands Info;

var PlayerStart InitialStart;
var PlayerStart MovableStart;

function Init(PlayerStart InitialPlayerStart, PlayerStart MovablePlayerStart)
{
	InitialStart = InitialPlayerStart;
	MovableStart = MovablePlayerStart;
}

event Trigger(Actor Other, Pawn EventInstigator)
{
	local PlayerStart PStart;

	if (InitialStart != none && MovableStart != none)
	{
		InitialStart.bSinglePlayerStart = false;
		InitialStart.bCoopStart = false;
		InitialStart.bEnabled = false;
		InitialStart = none;

		MovableStart.bCoopStart = true;
		MovableStart.bEnabled = true;
		Tag = 'MoveStart';
	}
	else if (MovableStart != none)
	{
		foreach AllActors(class'PlayerStart', PStart)
			if (PStart.name == 'PlayerStart2' ||
				PStart.name == 'PlayerStart3' ||
				PStart.name == 'PlayerStart4' ||
				PStart.name == 'PlayerStart5')
			{
				PStart.bCoopStart = true;
				PStart.bEnabled = true;
			}
		MovableStart.bCoopStart = false;
		MovableStart.bEnabled = false;
		MovableStart = none;
	}
}

