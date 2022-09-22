class MoverStateController expands UGoldFixServerInfo;

var name OpenPosEvent;
var name ClosePosEvent;

var private Mover ControlledMover;
var private name CurrentPos;
var private bool bChangedPermanently;

function PostBeginPlay()
{
	CurrentPos = '';
	bChangedPermanently = false;
}

function SetControlledMover(Mover m)
{
	ControlledMover = m;
	m.Tag = m.name;
}

function SetCurrentChange(name MoverPosChange, bool bPermanently, Actor A, Pawn EventInstigator)
{
	if (bChangedPermanently)
		return;
	if (ControlledMover == none || !ControlledMover.IsInState('TriggerToggle'))
		return;

	bChangedPermanently = bPermanently;

	if (CurrentPos == '')
		CurrentPos = GetCurrentMoverPosition(ControlledMover);

	if (MoverPosChange == 'Open' || MoverPosChange == 'Close')
	{
		if (MoverPosChange != CurrentPos)
			ChangeMoverPosition(ControlledMover, MoverPosChange, A, EventInstigator);
	}
	else if (MoverPosChange == 'Toggle')
		ChangeMoverPosition(ControlledMover, InverseMoverPosition(CurrentPos), A, EventInstigator);
}

static function name GetCurrentMoverPosition(Mover m)
{
	if (MoverIsClosingOrClosed(m))
		return 'Close';
	return 'Open';
}

static function name InverseMoverPosition(name MoverPos)
{
	if (MoverPos == 'Close')
		return 'Open';
	if (MoverPos == 'Open')
		return 'Close';
	return MoverPos;
}

function ChangeMoverPosition(Mover m, name NextMoverPos, Actor A, Pawn EventInstigator)
{
	CurrentPos = NextMoverPos;

	m.SavedTrigger = A;
	m.Instigator = EventInstigator;
	if (m.SavedTrigger != none)
		m.SavedTrigger.BeginEvent();
	m.GotoState(, NextMoverPos);
}

static function bool MoverIsClosingOrClosed(Mover m)
{
	return class'MoverStateSensor'.static.MoverIsClosingOrClosed(m);
}

function GenerateMoverEvent(Mover m, name EventName)
{
	local Actor A;
	foreach AllActors(class'Actor', A, EventName)
		A.Trigger(m.SavedTrigger, m.Instigator);
}

event Tick(float DeltaTime)
{
	if (ControlledMover == none)
		return;

	if (ControlledMover.bInterpolating)
		CurrentPos = GetCurrentMoverPosition(ControlledMover);

	if (OpenPosEvent != '' && !MoverIsClosingOrClosed(ControlledMover))
	{
		GenerateMoverEvent(ControlledMover, OpenPosEvent);
		OpenPosEvent = '';
	}
	if (ClosePosEvent != '' && MoverIsClosingOrClosed(ControlledMover))
	{
		GenerateMoverEvent(ControlledMover, ClosePosEvent);
		ClosePosEvent = '';
	}
}
