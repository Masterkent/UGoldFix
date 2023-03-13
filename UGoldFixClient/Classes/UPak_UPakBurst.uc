class UPak_UPakBurst expands SpriteBallExplosion;

var bool bShrinking;
var float DeltaFatness, FatnessLimit;
var() float MaxBurstSize;

function MakeSound()
{
	// Note: DynamicLoadObject for UPak.Explosions.Explo4 returns invalid sound UPak.Explo4 on 227i clients
	DynamicLoadObject("UPak.UPakBurst", class'Class');
	EffectSound1 = FindObject(class'Sound', "UPak.Explosions.Explo4");
	PlaySound(EffectSound1,,7.0);
}

simulated event PostBeginPlay()
{
	MakeSound();
	Texture = SpriteAnim[Rand(5)];
	if (Level.NetMode != NM_DedicatedServer)
	{
		Mesh = Mesh(DynamicLoadObject("UPak.AMAPearl", class'Mesh', true));
		Skin = Texture(DynamicLoadObject("UPak.burst.Burst2", class'Texture', true));
	}
}

simulated function Tick( float DeltaTime )
{
	local float DeltaT;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if( !bShrinking )
		{
			ScaleGlow = ( ( Lifespan/Default.Lifespan ) * 0.75 );
			AmbientGlow = ScaleGlow * 100;
		}
		DeltaT = DeltaTime * 60.;
		if( DrawScale < MaxBurstSize && !bShrinking )
		{
			DrawScale += 0.3 * DeltaT;
			if (FatnessLimit == 0)
				FatnessLimit = 230 + Rand(26);
			DeltaFatness += (15 + Rand(15)) * DeltaT;
			Fatness = Min(Fatness + int(DeltaFatness), FatnessLimit);
			DeltaFatness -= int(DeltaFatness);
		}
		else
		{
			if (!bShrinking)
			{
				bShrinking = True;
				DeltaFatness = 0;
				FatnessLimit = 95 - Rand(15);
			}
			DrawScale += 0.15 * DeltaT;
			ScaleGlow -= 0.05 * DeltaT;
			DeltaFatness -= 15 * DeltaT;
			Fatness = Max(Fatness + int(DeltaFatness), FatnessLimit);
			DeltaFatness -= int(DeltaFatness);
		}
	}
}

event Timer();

defaultproperties
{
	MaxBurstSize=2.000000
	LifeSpan=1.000000
	DrawType=DT_Mesh
	Texture=None
	DrawScale=0.500000
	LightEffect=LE_TorchWaver
	LightBrightness=120
}
