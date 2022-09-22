class UnrealShare_FlashLightBeam expands FlashLightBeam;

var vector RepLocation;
var FlashLightBeam OriginalBeam;
var Flashlight SourceFlashlight;
var bool bReplaced;
var vector HitLocation, HitNormal, EndTrace;

replication
{
	reliable if (Role == ROLE_Authority && !bNetOwner)
		RepLocation;
}

simulated event Tick(float DeltaTime)
{
	if (Level.NetMode == NM_Client)
	{
		if (bNetOwner && Pawn(Owner) != none)
		{
			EndTrace = Pawn(Owner).Location + 10000 * vector(Pawn(Owner).ViewRotation);
			Trace(HitLocation, HitNormal, EndTrace, Owner.Location, true);
			SetLocation(HitLocation - vector(Pawn(Owner).ViewRotation) * 64);
		}
		else
			SetLocation(RepLocation);
	}
	else if (bReplaced)
		RepLocation = Location;
	else
		ReplaceBeam();
}

static function CreateReplacement(FlashLightBeam Beam)
{
	local UnrealShare_FlashLightBeam NewBeam;

	NewBeam = Beam.Spawn(class'UnrealShare_FlashLightBeam', Beam.Owner);
	if (NewBeam != none)
	{
		NewBeam.OriginalBeam = Beam;
		NewBeam.LightType = LT_None;
	}
}

function ReplaceBeam()
{
	local Flashlight aFlashlight;

	if (OriginalBeam == none || OriginalBeam.bDeleteMe)
	{
		Destroy();
		return;
	}

	foreach AllActors(class'Flashlight', aFlashlight)
		if (aFlashlight.s == OriginalBeam)
		{
			if (aFlashlight.Class != class'Flashlight' && aFlashlight.Class != class'SearchLight')
			{
				Destroy();
				return;
			}
			SourceFlashlight = aFlashlight;
			LightType = class'FlashLightBeam'.default.LightType;
			LightBrightness = OriginalBeam.LightBrightness;
			LightHue = OriginalBeam.LightHue;
			LightRadius = OriginalBeam.LightRadius;
			OriginalBeam.Destroy();
			SourceFlashlight.s = self;
			bReplaced = true;
			return;
		}
	Destroy();
}

defaultproperties
{
	RemoteRole=ROLE_SimulatedProxy
}
