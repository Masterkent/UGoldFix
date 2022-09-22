class MoverClosing expands MoverStateSensor;

static function MoverClosing CreateInstance(Mover M, name Tag, optional name Event)
{
	local MoverClosing A;

	A = M.Spawn(class'MoverClosing', M, Tag);
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
	bCanTriggerWhenOpening=True
	bCanTriggerWhenOpened=True
}
