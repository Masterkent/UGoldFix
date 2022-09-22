class DMeshBase expands Actor
	abstract;

defaultproperties
{
	DrawType=DT_Mesh
	bHidden=True
	bCollideActors=True
	bBlockActors=True
	bBlockPlayers=True
	bUseMeshCollision=True
	bWorldGeometry=True
	bMovable=False
	bAlwaysRelevant=True
	bNetTemporary=True
	RemoteRole=ROLE_SimulatedProxy
}
