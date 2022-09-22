class UPak_Octagon expands Effects;

var class<Actor> class_Octagon;

event PostBeginPlay()
{
	class_Octagon = class<Actor>(DynamicLoadObject("UPak.octagon", class'class'));
	Texture = class_Octagon.default.Texture;
	Skin = class_Octagon.default.Skin;

	Fatness = 0;
	Disable('Tick');
	SetTimer(3.0, false);
}

event Landed(vector HitNormal)
{
	AmbientSound = sound(DynamicLoadObject("UPak.BeamIn", class'sound'));
	SoundVolume = 1;
	SoundRadius = 128;
	Mesh = mesh(DynamicLoadObject("UPak.Octagon", class'mesh'));
	Enable('Tick');
}

event Tick(float DeltaTime)
{
	if (SoundVolume <= 128)
		SoundVolume += 2;

	if (Fatness < 220 && mesh != none)
		Fatness += 1;
}

event Timer()
{
	SoundVolume = 128;
	GotoState('FadingOut');
}

state FadingOut
{
	event Tick(float DeltaTime)
	{
		if (Fatness > 0.0)
		{
			Fatness -= 1;
			if (DrawScale > 1)
				DrawScale -= 0.01;
		}
		else
		{
			if (ScaleGlow > 0.01)
			{
				if (SoundVolume > 15)
					SoundVolume -= 1;
				bUnlit = false;
				ScaleGlow -= 0.01;
			}
			else
				Destroy();
		}
	}
}

defaultproperties
{
	Physics=PHYS_Falling
	RemoteRole=ROLE_SimulatedProxy
	LifeSpan=10.000000
	DrawType=DT_Mesh
	Style=STY_Translucent
	bUnlit=True
	CollisionRadius=22.000000
	CollisionHeight=1.000000
	bCollideWorld=True
	bNetTemporary=False
}
