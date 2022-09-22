class AlarmTrigger expands Trigger;

var name AlarmTag;

function Touch(actor Other)
{
	local ScriptedPawn P;
	P = ScriptedPawn(Other);

	if (P == none || !IsRelevant(P))
		return;

	P.AlarmTag = AlarmTag;
	if (P.Enemy != none && !P.IsInState('TriggerAlarm'))
		P.GotoState('TriggerAlarm');

	if (bTriggerOnceOnly)
		Disable('Touch');
}

defaultproperties
{
}
