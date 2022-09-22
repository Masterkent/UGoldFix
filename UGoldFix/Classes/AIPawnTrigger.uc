class AIPawnTrigger expands Trigger;

var() int MinIntelligence; // for ScriptedPawns only
var Mover AssociatedMovers[4];

var private array<Pawn> TriggeredPawns;
var private int TriggeredPawnCount; // Is used instead of Array_Size(TriggeredPawns), because 227i's Array_Size causes memory leaks

function bool IsRelevant(Actor Other)
{
	if (!bInitiallyActive || !Other.bIsPawn)
		return false;
	if (ScriptedPawn(Other) != none && Pawn(Other).Intelligence >= MinIntelligence)
		return true;
	if (Other.IsA('Bot') || Other.IsA('Bots'))
		return true;
	return false;
}

function Actor SpecialHandling(Pawn Other)
{
	local Pawn P;

	if (bTriggerOnceOnly && !bCollideActors)
		return None;

	if (!bInitiallyActive)
	{
		if (TriggerActor == None)
			FindTriggerActor();
		if (TriggerActor == None)
			return None;
		if (TriggerActor2 != None &&
			VSize(TriggerActor2.Location - Other.Location) < VSize(TriggerActor.Location - Other.Location))
		{
			return TriggerActor2;
		}
		else
			return TriggerActor;
	}

	// can other trigger it right away?
	if (IsRelevant(Other))
	{
		foreach TouchingActors(class'Pawn', P)
			if (P == Other)
			{
				Touch(Other);
				UnTouch(Other);
				break;
			}
		return self;
	}

	return self;
}

event Touch(Actor Other)
{
	local Actor A;
	local Pawn InstigatorPawn;
	local AIPawnTriggerInfo PawnTriggerInfo;

	if (IsRelevant(Other))
	{
		if (ReTriggerDelay > 0)
		{
			if (Level.TimeSeconds - TriggerTime < ReTriggerDelay)
				return;
			TriggerTime = Level.TimeSeconds;
		}

		// Broadcast the Trigger message to all matching actors.
		if (Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Other, Other.Instigator);

		InstigatorPawn = Pawn(Other);
		AddTriggeredPawn(InstigatorPawn);

		if (InstigatorPawn.SpecialGoal == self)
			InstigatorPawn.SpecialGoal = none;

		if (HasAssociatedMover())
		{
			PawnTriggerInfo = InstigatorPawn.Spawn(class'AIPawnTriggerInfo');
			PawnTriggerInfo.AssociatedMover = RandomAssociatedMover();
			return;
		}

		if (RepeatTriggerTime > 0)
			SetTimer(RepeatTriggerTime, false);
	}
}

event UnTouch(Actor Other)
{
	local Actor A;

	if (RemoveTriggeredPawn(Pawn(Other)))
	{
		// Untrigger all matching actors.
		if (Event != '')
			foreach AllActors(class 'Actor', A, Event)
				A.UnTrigger(Other, Other.Instigator);
	}
}

event Timer()
{
	local bool bKeepTiming;
	local Pawn P;

	bKeepTiming = false;

	foreach TouchingActors(class'Pawn', P)
		if (IsRelevant(P))
		{
			bKeepTiming = true;
			Touch(P);
			UnTouch(P);
		}

	if (bKeepTiming)
		SetTimer(RepeatTriggerTime, false);
}

function bool HasAssociatedMover()
{
	return AssociatedMovers[0] != none;
}

function Mover RandomAssociatedMover()
{
	local int i, mover_index;

	for (i = 0; i < ArrayCount(AssociatedMovers); ++i)
	{
		if (AssociatedMovers[i] == none)
			break;
	}

	if (i == 0)
		return none;

	mover_index = Rand(i);

	if (mover_index >= ArrayCount(AssociatedMovers))
		mover_index = ArrayCount(AssociatedMovers) - 1;

	return AssociatedMovers[mover_index];
}

function AddTriggeredPawn(Pawn P)
{
	local int i;

	for (i = 0; i < TriggeredPawnCount; ++i)
		if (TriggeredPawns[i] == none)
		{
			TriggeredPawns[i] = P;
			return;
		}

	TriggeredPawns[TriggeredPawnCount++] = P;
}

function bool RemoveTriggeredPawn(Pawn P)
{
	local int i;

	// Note: TriggeredPawns may contain P more than once
	for (i = 0; i < TriggeredPawnCount; ++i)
		if (TriggeredPawns[i] == P)
		{
			TriggeredPawns[i] = none;
			return true;
		}
	return false;
}

defaultproperties
{
	MinIntelligence=2 // BRAINS_MAMMAL
	RepeatTriggerTime=0.5
}
