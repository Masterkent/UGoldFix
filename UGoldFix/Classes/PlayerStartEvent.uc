class PlayerStartEvent expands UGoldFixServerInfo;

// public:
var float DelayTime;

// private:
var PlayerPawn Player;

function Tick(float DeltaTime)
{
	local PlayerPawn P;

	if (Event == '')
		Event = Tag;

	if (Event == '')
	{
		Destroy();
		return;
	}

	foreach AllActors(class'PlayerPawn', P)
	{
		if (!P.IsA('Spectator') && P.Health > 0)
			break;
	}

	if (P != none)
	{
		Player = P;

		if (DelayTime > 0)
			SetTimer(DelayTime, false);
		else
			BeginEvent();

		Disable('Tick');
	}
}

function Timer()
{
	BeginEvent();
}

function BeginEvent()
{
	local Actor A;

	foreach AllActors(class'Actor', A, Event)
		A.Trigger(Player, Player);
	Destroy();	
}

defaultproperties
{
}
