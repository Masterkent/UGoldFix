class TeleportingTrigger expands Trigger;

var() vector Offset;
var() vector Destination;

function Touch(actor A)
{
	local bool bOldBlockActors, bOldBlockPlayers;

	if (!IsRelevant(A))
		return;

	bOldBlockActors = A.bBlockActors;
	bOldBlockPlayers = A.bBlockPlayers;

	A.Velocity = vect(0, 0, 0);
	A.SetCollision(false, false, false);

	if (VSize(Offset) != 0)
		A.SetLocation(A.Location + Offset);
	else
		A.SetLocation(Destination);

	A.SetCollision(true, bOldBlockActors, bOldBlockPlayers);

	if (Message != "" && A.Instigator != none)
		A.Instigator.ClientMessage(Message); // Send a string message to the toucher.
}

defaultproperties
{
}
