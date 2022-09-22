class UnrealI_WarlordRocket_Explosion expands UnrealShare_Rocket_Explosion;

simulated function class<Actor> GetDecalClass()
{
	if (bReplaceBlastDecals)
		return class'UnrealShare.GrenadeBlastMark';
	return class'UnrealShare.BlastMark';
}

simulated function AdjustDecalTexture(Actor DecalActor)
{
	if (DecalActor.Class.Name == 'GrenadeBlastMark')
	{
		if (Rand(2) == 0)
			DecalActor.Texture = texture'UnrealShare.GLBlast3';
		else
			DecalActor.Texture = texture'UnrealShare.GLBlast4';
	}
}
