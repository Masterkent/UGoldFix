class UPak_UPakBurst_Adjustment expands Info;

var bool bShrinking;
var float DeltaFatness, FatnessLimit;

auto state Adjustment
{
	event BeginState()
	{
		if (Owner != none && !Owner.bDeleteMe)
			Owner.Disable('Tick');
		else
			Destroy();
	}
Begin:
	if (Owner != none && !Owner.bDeleteMe)
		Owner.Disable('Tick');
}

event Tick(float DeltaTime)
{
	if (Owner != none && !Owner.bDeleteMe)
		UpdateEffect(DeltaTime);
	else
		Destroy();
}

function UpdateEffect(float DeltaTime)
{
	local float DeltaT;

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if( !bShrinking )
		{
			Owner.ScaleGlow = ( ( Owner.Lifespan / Owner.default.Lifespan ) * 0.75 );
			Owner.AmbientGlow = Owner.ScaleGlow * 100;
		}
		DeltaT = DeltaTime * 60.;
		if( Owner.DrawScale < float(Owner.GetPropertyText("MaxBurstSize")) && !bShrinking )
		{
			Owner.DrawScale += 0.3 * DeltaT;
			if (FatnessLimit == 0)
				FatnessLimit = 230 + Rand(26);
			DeltaFatness += (15 + Rand(15)) * DeltaT;
			Owner.Fatness = Min(Owner.Fatness + int(DeltaFatness), FatnessLimit);
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
			Owner.DrawScale += 0.15 * DeltaT;
			Owner.ScaleGlow -= 0.05 * DeltaT;
			DeltaFatness -= 15 * DeltaT;
			Owner.Fatness = Max(Owner.Fatness + int(DeltaFatness), FatnessLimit);
			DeltaFatness -= int(DeltaFatness);
		}
	}
}
