class MoverOpening expands MoverStateSensor;

static function MoverOpening CreateInstance(Mover M, name Tag, optional name Event)
{
	local MoverOpening A;

	A = M.Spawn(class'MoverOpening', M, Tag);
	if (A == none)
		return none;

	if (Event != '')
		A.Event = Event;
	else
		A.Event = M.Tag;
	return A;
}

event BeginPlay()
{
	ControlledMover = Mover(Owner);
}

defaultproperties
{
	bCanTriggerWhenClosing=True
	bCanTriggerWhenClosed=True
}
