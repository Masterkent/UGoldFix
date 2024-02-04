class UGoldTriggeredDeath expands Triggers;

var TriggeredDeath TriggeredDeath;

event Touch(Actor A)
{
	local Pawn P;
	local GameRules GR;

	if (TriggeredDeath == none || !TriggeredDeath.IsInState('Enabled'))
		return;

	if (Pawn(A) != none)
	{
		P = Pawn(A);
		if (P.Health <= 0)
			return;

		for (GR = Level.Game.GameRules; GR != none; GR = GR.NextRules )
			if (GR.bHandleDeaths && GR.PreventDeath(P, none, TriggeredDeath.DeathName))
				return;

		if (PlayerPawn(A) != none)
			InitTriggeredPlayerPawnDeath(PlayerPawn(A));
		else
			KillVictim(P, TriggeredDeath.DeathName);
	}
	else if (TriggeredDeath.bDestroyItems)
		A.Destroy();
}

function InitTriggeredPlayerPawnDeath(PlayerPawn P)
{
	local PlayerTriggeredDeath PlayerTriggeredDeath;

	foreach ChildActors(class'PlayerTriggeredDeath', PlayerTriggeredDeath)
		if (PlayerTriggeredDeath.Victim == P)
			return;

	PlayerTriggeredDeath = Spawn(class'PlayerTriggeredDeath', self);
	if (PlayerTriggeredDeath != none)
		PlayerTriggeredDeath.Init(TriggeredDeath, P);
}

static function KillVictim(Pawn Victim, name DeathName)
{
	local int OldHealth;

	if (Victim.Health <= 0)
		return;
	OldHealth = Victim.Health;
	Victim.NextState = '';
	Victim.Health = -1;
	Victim.Died(None, DeathName, Victim.Location);
	if (Victim.Health > 0)
		Victim.Health = OldHealth;
}
