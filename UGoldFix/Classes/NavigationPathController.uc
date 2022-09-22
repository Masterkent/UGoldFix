class NavigationPathController expands UGoldFixServerInfo;

var NavigationPoint ControlledNavigationPoint;
var int OriginalExtraCost;
var bool bTriggerOnceOnly;

function Initialize(NavigationPoint ControlledNavPoint, bool bInitiallyBlocked, bool bTriggerOnceOnly)
{
	if (ControlledNavPoint == none)
	{
		log("WARNING: NavigationPathController initialized with None NavigationPoint");
		Destroy();
	}

	ControlledNavigationPoint = ControlledNavPoint;
	OriginalExtraCost = ControlledNavPoint.ExtraCost;
	SetNavigationPointBlock(bInitiallyBlocked);
	self.bTriggerOnceOnly = bTriggerOnceOnly;
}

function SetNavigationPointBlock(bool bBlock)
{
	if (bBlock)
		ControlledNavigationPoint.ExtraCost = class'MapFixServer'.static.BlockedNavigationPathCost();
	else
		ControlledNavigationPoint.ExtraCost = OriginalExtraCost;
}

function Trigger(Actor Other, Pawn EventInstigator)
{
	if (ControlledNavigationPoint == none)
		return;
	SetNavigationPointBlock(ControlledNavigationPoint.ExtraCost == OriginalExtraCost);
	if (bTriggerOnceOnly)
	{
		Disable('Trigger');
		Destroy();
	}
}

defaultproperties
{
}
