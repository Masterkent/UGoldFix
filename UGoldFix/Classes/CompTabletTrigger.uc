class CompTabletTrigger expands Trigger;

var Pickup AssociatedCompTablet;

function AssignCompTablet(Pickup A)
{
	AssociatedCompTablet = A;
	Event = A.Event;
	Message = A.PickupMessage;
	SetCollisionSize(A.CollisionRadius, A.CollisionHeight);
	SetLocation(A.Location);
}

function Touch(actor Other)
{
	local actor A;

	if (IsRelevant(Other))
	{
		if (Event != '')
		{
			foreach AllActors(class 'Actor', A, Event)
				A.Trigger(Other, Other.Instigator);
		}
				
		if (Message != "" && Other.Instigator != none)
			Other.Instigator.ClientMessage(Message, 'Pickup');

		if (AssociatedCompTablet != none)
			AssociatedCompTablet.Destroy();

		SetCollision(false); // Ignore future touches
	}
}

function Tick(float DeltaTime)
{
	if (AssociatedCompTablet != none)
		MakePickupUntouchable(AssociatedCompTablet);
}

function MakePickupUntouchable(Pickup A)
{
	A.SetCollision(false);
}

defaultproperties
{
}
