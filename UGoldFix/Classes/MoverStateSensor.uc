class MoverStateSensor expands UGoldFixServerInfo;

var Mover ControlledMover;

var bool bCanTriggerWhenOpening;
var bool bCanTriggerWhenClosing;
var bool bCanTriggerWhenOpened;
var bool bCanTriggerWhenClosed;

function Trigger(Actor Other, Pawn EventInstigator)
{
	local Actor A;

	if (ControlledMover == none)
		return;

	if (ControlledMover.bInterpolating)
	{
		if (ControlledMover.bOpening && !bCanTriggerWhenOpening)
			return;
		if (!ControlledMover.bOpening && !bCanTriggerWhenClosing)
			return;
	}
	else if (ControlledMover.bDelaying && !bCanTriggerWhenOpening)
		return;
	else
	{
		if (!MoverIsClosingOrClosed(ControlledMover) && !bCanTriggerWhenOpened)
			return;
		if (MoverIsClosingOrClosed(ControlledMover) && !bCanTriggerWhenClosed)
			return;
	}

	if (Event == '')
		Event = ControlledMover.Tag;

	Instigator = EventInstigator;

	foreach AllActors(class 'Actor', A, Event)
		A.Trigger(self, Instigator);
}

static function bool MoverIsClosingOrClosed(Mover m)
{
	return m.KeyNum == 0 || m.KeyNum < m.PrevKeyNum;
}


defaultproperties
{
}
