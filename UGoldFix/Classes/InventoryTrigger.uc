class InventoryTrigger expands Trigger;

var Inventory AttachedInventory;
var bool bIsInventoryHolder;

function AttachInventory(Inventory Inv)
{
	AttachedInventory = Inv;
	bIsInventoryHolder = true;
	if (Inv == none || Inv.bDeleteMe || Inv.Owner != none)
	{
		Destroy();
		return;
	}
	Inv.SetOwner(self);
	SetCollisionSize(Inv.CollisionRadius, Inv.CollisionHeight);
	SetLocation(Inv.Location);
}

event Touch(Actor A)
{
	if (ValidTouch(A))
	{
		if (Level.TimeSeconds - TriggerTime < ReTriggerDelay)
			return;
		TriggerTime = Level.TimeSeconds;
		TriggerActorsEvent(A, AttachedInventory.Event);
		GiveCopyTo(AttachedInventory, Pawn(A));
	}
}

function bool ValidTouch(Actor A)
{
	return AttachedInventory != none &&
		A.bIsPawn &&
		Pawn(A).bIsPlayer &&
		Pawn(A).Health > 0;
}

function TriggerActorsEvent(Actor Initiator, name EventName)
{
	local Actor A;

	if (EventName != '')
	{
		foreach AllActors(class'Actor', A, EventName)
			A.Trigger(Initiator, Initiator.Instigator);
	}
}

event Tick(float DeltaTime)
{
	if (AttachedInventory != none &&
		!AttachedInventory.bDeleteMe &&
		AttachedInventory.Owner == self &&
		!AttachedInventory.bHeldItem)
	{
		AttachedInventory.bCollideWorld = true;
		if (AttachedInventory.bCollideActors || AttachedInventory.bBlockActors || AttachedInventory.bBlockPlayers)
			AttachedInventory.SetCollision(false);
		if (Location != AttachedInventory.Location)
			SetLocation(AttachedInventory.Location);
	}
	else if (bIsInventoryHolder)
		Destroy();
}

function GiveCopyTo(Inventory Inv, Pawn P)
{
	local Inventory Copy;

	if (Inv == none)
		return;

	Copy = Inv.Spawn(Inv.Class, self); // Owner prevents from destruction in zones where bNoInventory == true
	Copy.Tag = Inv.Tag;
	Copy.Event = Inv.Event;
	Copy.Charge = Inv.Charge;
	Copy.RespawnTime = 0;
	Copy.bHeldItem = True;
	Copy.PickupMessage = Inv.PickupMessage;
	Copy.Touch(P);
	if (Copy.Owner != P)
		Copy.Destroy();
}

defaultproperties
{
	ReTriggerDelay=0.500000
}
