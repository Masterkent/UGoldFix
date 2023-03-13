class UGoldFixClientSpawnNotify expands SpawnNotify;

var bool bAdjustUPakBursts;
var bool bDisableNetInterpolatePos;

event Actor SpawnNotification(Actor A)
{
	if (bAdjustUPakBursts && A.Class.Name == 'UPakBurst' && A.Class.Outer.Name == 'UPak')
		AdjustUPakBurst(A);
	if (bDisableNetInterpolatePos)
		A.SetPropertyText("bNetInterpolatePos", "false");
	return A;
}

function AdjustUPakBurst(Actor A)
{
	Spawn(class'UPak_UPakBurst_Adjustment', A);
}

defaultproperties
{
	bHidden=True
}
