class DelayedPawnTriggerInfo expands UGoldFixServerInfo;

var Trigger ControlledTrigger;

function AssignTrigger(Trigger t, optional name ModTag)
{
	if (t.TriggerType != TT_PawnProximity)
	{
		ControlledTrigger = t;
		Tag = t.Event;
		if (ModTag != '')
			Tag = ModTag;
	}
}

function Trigger(Actor A, Pawn EventInstigator)
{
	if (ControlledTrigger != none)
		ControlledTrigger.TriggerType = TT_PawnProximity;
}

defaultproperties
{
}
