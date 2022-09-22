class PawnEventTrigger expands Triggers;

function Touch(Actor A)
{
	local Actor MatchingActor;
	if (Event != '' && A.bIsPawn && A.Event == Event)
	{
		foreach AllActors(class'Actor', MatchingActor, Event)
			MatchingActor.Trigger(A, Pawn(A));
		A.Event = '';
	}
}
