class MercenaryShieldController expands Info;

var Mercenary Mercenary;
var float InvulnerableCharge;
var bool bCharge;

event BeginPlay()
{
	Mercenary = Mercenary(Owner);
	if (Mercenary != none)
		InvulnerableCharge = Mercenary.invulnerableCharge;
}

event Tick(float DeltaTime)
{
	if (Mercenary == none ||
		Mercenary.Health == 0 ||
		Mercenary.bDeleteMe)
	{
		Destroy();
		return;
	}

	if (Mercenary.bIsInvulnerable || Mercenary.IsInState('Invulnerable'))
		bCharge = false;
	else if (Mercenary.invulnerableTime > 0)
	{
		bCharge = Mercenary.invulnerableCharge < InvulnerableCharge;
		Mercenary.invulnerableTime = 0;
	}

	if (bCharge)
		Mercenary.invulnerableCharge =
			FMin(Mercenary.invulnerableCharge + DeltaTime / 2, InvulnerableCharge);
}
