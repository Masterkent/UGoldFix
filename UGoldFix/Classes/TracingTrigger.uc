class TracingTrigger expands Trigger;

var Actor TracedActor;

function SetTracedActor(Actor A)
{
	TracedActor = A;
	SetTimer(0.1, true);
}

function Timer()
{
	TraceActor();
}

function TraceActor()
{
	local vector HitLocation, HitNormal, Extent;
	local Actor HitActor, A;

	if (TracedActor == None)
		return;

	HitActor = Trace(HitLocation, HitNormal, Location, TracedActor.Location, false, Extent);
	if (HitActor == None)
	{
		if (Event != '')
		{
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(TracedActor, TracedActor.Instigator);
		}

		if (bTriggerOnceOnly)
		{
			TracedActor = None;
			SetTimer(0, false);
		}
	}
}

defaultproperties
{
}
