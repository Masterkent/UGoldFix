class PlayerTriggeredDeath expands Info;

var TriggeredDeath TriggeredDeath;
var PlayerPawn Victim;

var float TimePassed;

function Init(TriggeredDeath T, PlayerPawn P)
{
	if (T == none || P == none || P.bDeleteMe)
		return;

	TriggeredDeath = T;
	Victim = P;

	if (Victim.bIsFemale )
		Victim.PlaySound(TriggeredDeath.FemaleDeathSound, SLOT_Talk);
	else
		Victim.PlaySound(TriggeredDeath.MaleDeathSound, SLOT_Talk);
}

event Tick(float DeltaTime)
{
	local Float CurScale;
	local vector CurFog;
	local float  TimeRatio;

	if (TriggeredDeath == none || Victim == none || Victim.bDeleteMe || Victim.Health <= 0)
	{
		Destroy();
		return;
	}

	// Check the timing
	TimePassed += DeltaTime;
	if (TimePassed >= TriggeredDeath.ChangeTime)
	{
		Victim.ClientFlash(TriggeredDeath.EndFlashScale, 1000 * TriggeredDeath.EndFlashFog);
		class'UGoldTriggeredDeath'.static.KillVictim(Victim, TriggeredDeath.DeathName);
		Destroy();
	}
	else
	{
		// Continue the screen flashing
		TimeRatio = TimePassed / TriggeredDeath.ChangeTime;
		CurScale = (TriggeredDeath.EndFlashScale - TriggeredDeath.StartFlashScale) * TimeRatio + TriggeredDeath.StartFlashScale;
		CurFog = (TriggeredDeath.EndFlashFog - TriggeredDeath.StartFlashFog) * TimeRatio + TriggeredDeath.StartFlashFog;
		Victim.ClientFlash(CurScale, 1000 * CurFog);
	}
}
