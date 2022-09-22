class InstantDispatcher expands Dispatcher;

var Trigger ConditionTrigger;
var bool bTriggerOnceOnly;

function Trigger(Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if (ConditionTrigger != none && !ConditionTrigger.bInitiallyActive)
		return;

	Instigator = EventInstigator;

	Disable('Trigger');
	for (i = 0; i < ArrayCount(OutEvents); ++i)
	{
		if (OutEvents[i] != '')
		{
			foreach AllActors(class 'Actor', A, OutEvents[i])
				A.Trigger(self, Instigator);
		}
	}
	if (!bTriggerOnceOnly)
		Enable('Trigger');
	else
		Disable('UnTrigger');
}

function UnTrigger(Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if (ConditionTrigger != none && !ConditionTrigger.bInitiallyActive)
		return;

	Instigator = EventInstigator;

	Disable('UnTrigger');
	for (i = 0; i < ArrayCount(OutEvents); ++i)
	{
		if (OutEvents[i] != '')
		{
			foreach AllActors(class 'Actor', A, OutEvents[i])
				A.UnTrigger(self, Instigator);
		}
	}
	Enable('UnTrigger');
}

defaultproperties
{
}
