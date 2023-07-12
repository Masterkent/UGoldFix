class ArbitItemController expands Info;

var UGoldFixSpawnNotify SpawnNotify;
var private array<class<Inventory> > InventoryClasses;
var private array<bool> MovingToGround;
var private int InventoryClassesNum;
var private Inventory CurrentItem;
var private int CurrentItemIndex;
var private float RespawnTimeScale;
var private InventorySpot MyMarker;
var private bool bInitialized;

static function StaticReplaceArbitItem(ArbitItem ArbitItem, UGoldFixSpawnNotify SpawnNotify)
{
	local ArbitItemController ArbitItemController;

	if (!ArbitItem.bStatic && !ArbitItem.bNoDelete)
		ArbitItemController = ArbitItem.Spawn(class'ArbitItemController',, ArbitItem.Tag);
	if (ArbitItemController != none)
	{
		ArbitItemController.SpawnNotify = SpawnNotify;
		ArbitItemController.ReplaceArbitItem(ArbitItem);
	}
}

function ReplaceArbitItem(ArbitItem ArbitItem)
{
	local int i;

	for (i = 0; i < ArrayCount(ArbitItem.SpawnItem); ++i)
		if (ArbitItem.SpawnItem[i] != none)
		{
			InventoryClasses[InventoryClassesNum] = ArbitItem.SpawnItem[i];
			MovingToGround[InventoryClassesNum] = ArbitItem.SpawnItemFallsToGround[i] > 0;
			++InventoryClassesNum;
		}

	RespawnTimeScale = ArbitItem.AdjustedSpawnTime;
	MyMarker = ArbitItem.MyMarker;
	ArbitItem.Destroy();

	if (InventoryClassesNum == 0)
		Destroy();
	else
	{
		GotoState('Pickup');
		bInitialized = true;
	}
}

function CheckCurrentItem()
{
	if (CurrentItem == none ||
		CurrentItem.bDeleteMe ||
		Pawn(CurrentItem.Owner) != none ||
		CurrentItem.IsInState('Sleeping'))
	{
		if (CurrentItem != none && !CurrentItem.bDeleteMe && CurrentItem.IsInState('Sleeping'))
			CurrentItem.Destroy();
		SelectNextItem();
		GotoState('Sleeping');
	}
}

function SelectNextItem()
{
	if (++CurrentItemIndex >= InventoryClassesNum)
		CurrentItemIndex = 0;
}

function SpawnItem()
{
	local int i;

	if (SpawnNotify != none)
		SpawnNotify.TrackSpawnClass = class'Inventory';

	for (i = 0; i < InventoryClassesNum; ++i)
	{
		if (TryToSpawnCurrentItem())
		{
			InitCurrentItem();
			break;
		}
		if (bDeleteMe)
			return;
		InventoryClasses[CurrentItemIndex] = none;
		SelectNextItem();
	}

	if (SpawnNotify != none)
		SpawnNotify.TrackSpawnClass = none;

	if (i == InventoryClassesNum)
		Destroy();
}

function bool TryToSpawnCurrentItem()
{
	local Inventory Inv;

	if (InventoryClasses[CurrentItemIndex] == none)
		return false;

	if (SpawnNotify != none)
		SpawnNotify.LastSpawnedActor = none;

	CurrentItem = Spawn(InventoryClasses[CurrentItemIndex],, Tag);

	if (CurrentItem == none)
	{
		if (SpawnNotify == none)
		{
			Destroy();
			return false;
		}
		Inv = Inventory(SpawnNotify.LastSpawnedActor);
		if (Inv != none && Pawn(Inv.Owner) == none)
			CurrentItem = Inv;
	}

	return CurrentItem != none;
}

function InitCurrentItem()
{
	if (MyMarker != none)
	{
		MyMarker.MarkedItem = CurrentItem;
		CurrentItem.MyMarker = MyMarker;
	}
	if (Weapon(CurrentItem) != none)
		Weapon(CurrentItem).bWeaponStay = false;
	if (MovingToGround[CurrentItemIndex])
	{
		CurrentItem.bCollideWorld = true;
		CurrentItem.Move(vect(0, 0, -65536));
	}
	if (bInitialized)
		Level.Game.PlaySpawnEffect(CurrentItem);
	if (!CurrentItem.bDeleteMe && Pawn(CurrentItem.Owner) == none)
		TouchOverlappingActors(CurrentItem);
}

static function TouchOverlappingActors(Actor A)
{
	if (A.bCollideWorld)
	{
		A.bCollideWorld = false;
		A.SetLocation(A.Location);
		A.bCollideWorld = true;
	}
	else
		A.SetLocation(A.Location);
}

state Pickup
{
	event BeginState()
	{
		SpawnItem();
	}
	event Tick(float DeltaTime)
	{
		CheckCurrentItem();
	}
}

state Sleeping
{
	function float GetRespawnTime()
	{
		return FMax(0.3, InventoryClasses[CurrentItemIndex].default.RespawnTime * RespawnTimeScale);
	}
Begin:
	Sleep(GetRespawnTime());
	GotoState('Pickup');
}
