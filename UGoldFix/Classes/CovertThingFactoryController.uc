class CovertThingFactoryController expands UGoldFixServerInfo;

var ThingFactory ControlledFactory;
var float Timeout;

var private float LastTimerCounter;
var private int LastCapacity;
var float RemainingTime;
var int FailedSpawnsCount;

event PostBeginPlay()
{
	LastTimerCounter = -1;
}

event Tick(float DeltaTime)
{
	if (ControlledFactory == none || Timeout <= 0 || ControlledFactory.capacity <= 0 || !ControlledFactory.bCovert)
		return;
	if (!ControlledFactory.IsInState('Spawning'))
		return;
	if (FailedSpawnsCount < 2 &&
		ControlledFactory.numitems == 0 &&
		ControlledFactory.TimerCounter <= LastTimerCounter &&
		ControlledFactory.capacity == LastCapacity)
	{
		if (++FailedSpawnsCount == 2)
			RemainingTime = Timeout;
	}
	else if (ControlledFactory.capacity < LastCapacity)
	{
		FailedSpawnsCount = 0;
		RemainingTime = 0;
	}
	else if (RemainingTime > 0)
	{
		RemainingTime -= DeltaTime;
		if (RemainingTime <= 0)
		{
			ControlledFactory.SetTimer(0, false);
			ControlledFactory.Timer();
			if (ControlledFactory.capacity == LastCapacity)
			{
				ControlledFactory.bCovert = false;
				ControlledFactory.SetTimer(0, false);
				ControlledFactory.Timer();
				ControlledFactory.bCovert = true;
			}
			if (ControlledFactory.capacity < LastCapacity)
				FailedSpawnsCount = 0;
		}
	}
	LastTimerCounter = ControlledFactory.TimerCounter;
	LastCapacity = ControlledFactory.Capacity;
}
